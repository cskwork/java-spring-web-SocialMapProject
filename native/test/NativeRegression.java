import security.*;
import java.sql.*;
import java.nio.file.*;
import java.lang.reflect.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.ibatis.sqlmap.client.SqlMapClient;
/** Executes actual Service SQL and request guard against a fresh in-memory synthetic DB. */
public class NativeRegression {
 static Connection c;static int count=0;static ThreadLocal<Connection> local=new ThreadLocal<Connection>();
 static void check(boolean ok,String text){if(!ok)throw new AssertionError(text);count++;}
 static void deny(RunnableEx fn)throws Exception{try{fn.run();throw new AssertionError("Expected rejection");}catch(SecurityException expected){count++;}finally{c.rollback();}}
 interface RunnableEx{void run()throws Exception;}
 static long number(String query)throws Exception{try(Statement s=c.createStatement();ResultSet r=s.executeQuery(query)){r.next();return r.getLong(1);}}
 static Object primitive(Class<?> t){if(t==boolean.class)return false;if(t==int.class)return 0;if(t==long.class)return 0L;return null;}
 public static void main(String[] args)throws Exception{
  c=DriverManager.getConnection("jdbc:h2:mem:socialmap;MODE=Oracle;DB_CLOSE_DELAY=-1");
  String ddl=new String(Files.readAllBytes(Paths.get("native/db/001-empty-schema.sql")),"UTF-8").replaceAll("(?m)--.*$","");
  for(String sql:ddl.split(";"))if(!sql.trim().isEmpty()&&!sql.contains("CREATE UNIQUE INDEX"))c.createStatement().execute(sql);
  String seed=new String(Files.readAllBytes(Paths.get("native/db/002-synthetic-seed.sql")),"UTF-8").replaceAll("(?m)--.*$","");for(String sql:seed.split(";"))if(!sql.trim().isEmpty())c.createStatement().execute(sql);
  c.setAutoCommit(false);
  SqlMapClient client=(SqlMapClient)Proxy.newProxyInstance(NativeRegression.class.getClassLoader(),new Class[]{SqlMapClient.class},(p,m,a)->{switch(m.getName()){case "getCurrentConnection":return local.get()==null?c:local.get();case "startTransaction":c.setAutoCommit(false);return null;case "commitTransaction":c.commit();return null;case "endTransaction":c.rollback();return null;default:return primitive(m.getReturnType());}});
  Field field=Database.class.getDeclaredField("client");field.setAccessible(true);field.set(null,client);
  String hash=Passwords.hash("Synthetic-Password-42");check(hash.startsWith("pbkdf2$600000$"),"PBKDF2");check(!hash.equals(Passwords.hash("Synthetic-Password-42")),"Random salt");check(Passwords.verify("Synthetic-Password-42",hash),"Verify");check(!Passwords.verify("wrong",hash),"Wrong password");check(!Passwords.verify("demo","demo"),"No plaintext fallback");
  Service.hope("member01","leader01",1);c.commit();int no=((Number)Service.one("select no from hopelist where sendid='member01'").get("no")).intValue();
  deny(()->Service.accept("member02",no));check(number("select count(*) from hopelist")==1,"Unauthorized acceptance unchanged");
  Service.accept("leader01",no);c.commit();check(number("select teamno1 from member where id='member01'")==1,"Membership joined");check(number("select recmem from projectteam where teamno=1")==1,"Capacity decremented");check(number("select count(*) from hopelist")==0,"Request removed");check(number("select count(*) from msg")==2,"Internal notifications");
  deny(()->Service.accept("leader01",no));
  Service.hope("member02","leader01",1);c.commit();int second=((Number)Service.one("select no from hopelist where sendid='member02'").get("no")).intValue();
  // Database failure at final notification must roll back the preceding three writes.
  c.createStatement().execute("alter table msg add constraint forced_failure check(not (title = 'Project accepted' and getid='member02'))");
  try{Service.accept("leader01",second);throw new AssertionError("Expected injected failure");}catch(SQLException expected){c.rollback();count++;}
  check(number("select count(*) from hopelist where no="+second)==1,"Failure restores request");check(Service.one("select teamno1 from member where id='member02'").get("teamno1")==null,"Failure restores member");check(number("select recmem from projectteam where teamno=1")==1,"Failure restores capacity");c.createStatement().execute("alter table msg drop constraint forced_failure");
  Service.accept("leader01",second);c.commit();check(number("select recmem from projectteam where teamno=1")==0,"Last seat filled");
  deny(()->Service.withdraw("member01"));deny(()->Service.lifecycle("member02",false,"1","completed"));
  Service.lifecycle("leader01",false,"1","completed");c.commit();check(number("select count(*) from member where teamno1=1")==0,"Completion releases all members");check(number("select count(*) from project_history where teamno=1")==3,"Completion snapshots team");deny(()->Service.lifecycle("leader01",false,"1","released"));
  Service.update("update member set pwd=? where id in ('member01','member02')",hash);c.commit();Service.withdraw("member01");c.commit();check(number("select count(*) from member where id='member02'")==1,"Same password other member preserved");
  Service.requestReset("member02","member02@example.invalid");c.commit();String token=(String)Service.one("select token from local_outbox where id='member02'").get("token");Service.reset(token,"New-Synthetic-Password");c.commit();check(Passwords.verify("New-Synthetic-Password",(String)Service.one("select pwd from member where id='member02'").get("pwd")),"Reset stores hash");deny(()->Service.reset(token,"Another-password"));
  guard(client,"ProjDelete","GET",new HashMap<String,String>(),"leader01",403,false);
  guard(client,"ASWrite","POST",params("csrf","fixture","step","1"),"member02",403,false);
  guard(client,"QnaInfo","GET",params("no","99"),"member02",403,false);
  guard(client,"MsgList","GET",new HashMap<String,String>(),null,403,false);
  guard(client,"ProjList","GET",new HashMap<String,String>(),null,200,true);
  guard(client,"MsgWrite","POST",params("csrf","fixture","step","1"),"member02",403,true);
  check(number("select count(*) from msg where title='BUFFER_FAILED'")==0,"Flushed action failure rolls back SQL");
  // Two concurrent acceptances compete for exactly one remaining slot.
  Service.update("insert into member(id,pwd,name,email,auth) values('lead2','RESET_REQUIRED','Synthetic','lead2@example.invalid','1')");
  Service.update("insert into member(id,pwd,name,email,auth) values('joinA','RESET_REQUIRED','Synthetic','a@example.invalid','2')");
  Service.update("insert into member(id,pwd,name,email,auth) values('joinB','RESET_REQUIRED','Synthetic','b@example.invalid','2')");
  Service.update("insert into projectteam(teamno,leaderid,title,recmem,currmem,status) values(2,'lead2','Concurrent fixture',1,1,'recruiting')");
  Service.hope("joinA","lead2",1);Service.hope("joinB","lead2",1);c.commit();
  final int[] requests={((Number)Service.one("select no from hopelist where sendid='joinA'").get("no")).intValue(),((Number)Service.one("select no from hopelist where sendid='joinB'").get("no")).intValue()};
  final java.util.concurrent.atomic.AtomicInteger accepted=new java.util.concurrent.atomic.AtomicInteger();final List<Throwable> failures=Collections.synchronizedList(new ArrayList<Throwable>());
  Thread[] threads=new Thread[2];for(int i=0;i<2;i++){final int n=requests[i];threads[i]=new Thread(()->{try(Connection conn=DriverManager.getConnection("jdbc:h2:mem:socialmap;MODE=Oracle;DB_CLOSE_DELAY=-1")){conn.setAutoCommit(false);local.set(conn);try{Service.accept("lead2",n);conn.commit();accepted.incrementAndGet();}catch(SecurityException expected){conn.rollback();}finally{local.remove();}}catch(Throwable failure){failures.add(failure);}});threads[i].start();}
  for(Thread thread:threads)thread.join(10000);check(failures.isEmpty(),"Concurrent SQL has no unexpected failures");check(accepted.get()==1,"Exactly one concurrent acceptance");check(number("select count(*) from member where teamno1=2")==1,"One new member assigned");check(number("select recmem from projectteam where teamno=2")==0,"Capacity never negative");
  System.out.println("PASS "+count+" native security/SQL/transaction assertions; synthetic H2 only, not Oracle/container integration");c.close();
 }
 static Map<String,String> params(String... pairs){Map<String,String> m=new HashMap<>();for(int i=0;i<pairs.length;i+=2)m.put(pairs[i],pairs[i+1]);return m;}
 static void guard(SqlMapClient db,String action,String method,Map<String,String> params,String id,int expected,boolean chainExpected)throws Exception{
  Map<String,Object> session=new HashMap<>();session.put("id",id);session.put("csrf","fixture");session.put("auth","0"); // Forged session role must be replaced by stored role.
  HttpSession hs=(HttpSession)Proxy.newProxyInstance(NativeRegression.class.getClassLoader(),new Class[]{HttpSession.class},(p,m,a)->{switch(m.getName()){case "getAttribute":return session.get(a[0]);case "setAttribute":session.put((String)a[0],a[1]);return null;case "invalidate":session.clear();return null;default:return primitive(m.getReturnType());}});
  HttpServletRequest request=(HttpServletRequest)Proxy.newProxyInstance(NativeRegression.class.getClassLoader(),new Class[]{HttpServletRequest.class},(p,m,a)->{switch(m.getName()){case "getServletPath":return "/"+action+".action";case "getMethod":return method;case "getSession":return hs;case "getParameter":return params.get(a[0]);case "getParameterMap":return params;default:return primitive(m.getReturnType());}});
  java.io.ByteArrayOutputStream published=new java.io.ByteArrayOutputStream();
  int[] status={200};boolean[] invoked={false};HttpServletResponse response=(HttpServletResponse)Proxy.newProxyInstance(NativeRegression.class.getClassLoader(),new Class[]{HttpServletResponse.class},(p,m,a)->{if(m.getName().equals("sendError")||m.getName().equals("setStatus"))status[0]=(Integer)a[0];if(m.getName().equals("getOutputStream"))return new javax.servlet.ServletOutputStream(){public void write(int b){published.write(b);}};return primitive(m.getReturnType());});
  new RequestGuard().doFilter(request,response,(req,res)->{invoked[0]=true;if(action.equals("MsgWrite")){try{Service.message("member02","leader01","BUFFER_FAILED","Synthetic only");res.getWriter().write("premature-success");res.flushBuffer();check(published.size()==0,"JSP flush does not publish uncommitted success");throw new SecurityException("Injected post-flush failure");}catch(SecurityException expectedFailure){throw expectedFailure;}catch(Exception failure){throw new ServletException(failure);}}});
  if(action.equals("MsgWrite"))check(!published.toString("UTF-8").contains("premature-success"),"Rollback response replaces buffered success");check(status[0]==expected,action+" status");check(invoked[0]==chainExpected,action+" chain");
 }
}
