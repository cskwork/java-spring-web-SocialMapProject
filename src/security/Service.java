package security;
import java.sql.*;
import java.util.*;
import com.ibatis.sqlmap.client.SqlMapClient;
/** Compatibility lifecycle and atomic operations on the original tables. Caller owns transaction. */
public final class Service {
 public static Connection connection()throws Exception{return Database.client().getCurrentConnection();}
 public static Map<String,Object> one(String sql,Object... args)throws Exception{List<Map<String,Object>> rows=list(sql,args);return rows.isEmpty()?null:rows.get(0);}
 public static List<Map<String,Object>> list(String sql,Object... args)throws Exception{PreparedStatement p=connection().prepareStatement(sql);try{bind(p,args);ResultSet r=p.executeQuery();try{List<Map<String,Object>> out=new ArrayList<Map<String,Object>>();while(r.next()){Map<String,Object> row=new HashMap<String,Object>();for(int i=1;i<=r.getMetaData().getColumnCount();i++)row.put(r.getMetaData().getColumnLabel(i).toLowerCase(),r.getObject(i));out.add(row);}return out;}finally{r.close();}}finally{p.close();}}
 public static int update(String sql,Object... args)throws Exception{PreparedStatement p=connection().prepareStatement(sql);try{bind(p,args);return p.executeUpdate();}finally{p.close();}}
 private static void bind(PreparedStatement p,Object[] a)throws Exception{for(int i=0;i<a.length;i++)p.setObject(i+1,a[i]);}
 public static void require(boolean condition,String reason){if(!condition)throw new SecurityException(reason);}
 public static void changed(int count){require(count==1,"Conflicting or missing record");}
 public static void message(String from,String to,String title,String cont)throws Exception{require(one("select id from member where id=?",to)!=null,"Recipient missing");update("insert into msg(no,sendid,getid,title,cont,sendtime) values(msg_seq.nextval,?,?,?,?,CURRENT_TIMESTAMP)",from,to,title,cont);}
 public static void accept(String actor,int no)throws Exception{
  Map<String,Object> h=one("select * from hopelist where no=? for update",no);require(h!=null&&actor.equals(h.get("getid")),"Only recipient may accept");
  boolean applied=((Number)h.get("log")).intValue()==1;String leader=(String)h.get(applied?"getid":"sendid"), member=(String)h.get(applied?"sendid":"getid");
  Map<String,Object> p=one("select * from projectteam where leaderid=? and status in ('recruiting','closed') for update",leader);require(p!=null&&"recruiting".equals(p.get("status"))&&((Number)p.get("recmem")).intValue()>0,"Recruitment closed");
  changed(update("update member set teamno1=? where id=? and (teamno1 is null or teamno1=0)",p.get("teamno"),member));
  changed(update("update projectteam set currmem=currmem+1,recmem=recmem-1 where teamno=? and recmem>0 and status='recruiting'",p.get("teamno")));
  changed(update("delete from hopelist where no=? and getid=?",no,actor));message(actor,(String)h.get("sendid"),"Project accepted","Open My Projects to view the team.");
 }
 public static void hope(String actor,String recipient,int log)throws Exception{
  String leader=log==1?recipient:actor, member=log==1?actor:recipient;
  Map<String,Object> p=one("select * from projectteam where leaderid=? and status='recruiting' for update",leader);
  Map<String,Object> m=one("select * from member where id=? for update",member);
  require(p!=null&&((Number)p.get("recmem")).intValue()>0&&m!=null&&"2".equals(String.valueOf(m.get("auth")))&&(m.get("teamno1")==null||"0".equals(String.valueOf(m.get("teamno1")))),"Unavailable project or member");
  require(one("select no from hopelist where sendid=? and getid=?",actor,recipient)==null,"Duplicate request");
  update("insert into hopelist(no,sendid,getid,regdate,log) values(hopelist_seq.nextval,?,?,CURRENT_TIMESTAMP,?)",actor,recipient,log);message(actor,recipient,"Project invitation","Open received requests to accept or reject.");
 }
 public static void lifecycle(String actor,boolean admin,String team,String status)throws Exception{
  Map<String,Object> p=one("select * from projectteam where teamno=? for update",team);require(p!=null&&(admin||actor.equals(p.get("leaderid"))),"Project ownership required");
  require(Arrays.asList("closed","completed","released").contains(status)&&!Arrays.asList("completed","released").contains(String.valueOf(p.get("status"))),"Invalid transition");
  if("completed".equals(status))update("insert into project_history(teamno,id) select teamno1,id from member where teamno1=?",team);
  if(!"closed".equals(status)){update("update member set teamno1=null where teamno1=?",team);update("delete from hopelist where sendid=? or getid=?",p.get("leaderid"),p.get("leaderid"));}
  changed(update("update projectteam set status=?,recmem=0 where teamno=?",status,team));
 }
 public static void withdraw(String actor)throws Exception{
  Map<String,Object> m=one("select * from member where id=? for update",actor);require(m!=null&&(m.get("teamno1")==null||"0".equals(String.valueOf(m.get("teamno1")))),"Release active project first");
  update("delete from favoritelist where id=? or leaderid=?",actor,actor);update("delete from hopelist where sendid=? or getid=?",actor,actor);update("delete from specreg where id=?",actor);update("delete from password_reset where id=?",actor);update("delete from local_outbox where id=?",actor);changed(update("delete from member where id=?",actor));
 }
 public static void requestReset(String id,String email)throws Exception{
  if(one("select id from member where id=? and email=?",id,email)==null)return;
  String token=Passwords.token();update("delete from password_reset where id=?",id);
  update("insert into password_reset(id,token_hash,expires_at) values(?,?,?)",id,Passwords.digest(token),new Timestamp(System.currentTimeMillis()+900000));
  // Local, access-controlled development outbox; a production delivery adapter must replace this boundary.
  update("insert into local_outbox(id,token,created_at) values(?,?,CURRENT_TIMESTAMP)",id,token);
 }
 public static void reset(String token,String password)throws Exception{
  Map<String,Object> r=one("select * from password_reset where token_hash=? and expires_at>CURRENT_TIMESTAMP for update",Passwords.digest(token));require(r!=null,"Invalid or expired token");
  changed(update("update member set pwd=? where id=?",Passwords.hash(password),r.get("id")));changed(update("delete from password_reset where id=?",r.get("id")));update("delete from local_outbox where id=?",r.get("id"));
 }
}
