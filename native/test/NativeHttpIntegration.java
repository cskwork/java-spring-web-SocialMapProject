import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.Context;
import org.apache.catalina.loader.WebappLoader;
import com.ibatis.sqlmap.client.*;
import java.nio.file.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.lang.reflect.*;
import java.net.*;
import java.net.http.*;
import security.*;
/** Real embedded Servlet/Struts/Tiles HTTP integration using a fresh synthetic H2 schema. */
public class NativeHttpIntegration {
 static int checks;static HttpClient http;static String origin,csrf;static Path uploads;
 static HttpResponse<String> call(String action,String body)throws Exception{
  HttpRequest.Builder b=HttpRequest.newBuilder(URI.create(origin+"/socialmap/"+(action.contains("?")?action.replace("?",".action?"):action+".action")));
  if(body!=null)b.header("Content-Type","application/x-www-form-urlencoded;charset=UTF-8").header("X-CSRF-Token",csrf==null?"":csrf).POST(HttpRequest.BodyPublishers.ofString(body));
  HttpResponse<String> r=http.send(b.build(),HttpResponse.BodyHandlers.ofString(java.nio.charset.Charset.forName("EUC-KR")));csrf=r.headers().firstValue("x-socialmap-csrf").orElse(csrf);return r;
 }
 static HttpResponse<String> upload(String action,Map<String,String> fields,byte[] image,String filename,String mime)throws Exception{
  String boundary="SocialMapBoundedFixture";ByteArrayOutputStream body=new ByteArrayOutputStream();
  for(Map.Entry<String,String> field:fields.entrySet())body.write(("--"+boundary+"\r\nContent-Disposition: form-data; name=\""+field.getKey()+"\"\r\n\r\n"+field.getValue()+"\r\n").getBytes("UTF-8"));
  body.write(("--"+boundary+"\r\nContent-Disposition: form-data; name=\"upload\"; filename=\""+filename+"\"\r\nContent-Type: "+mime+"\r\n\r\n").getBytes("UTF-8"));body.write(image);body.write(("\r\n--"+boundary+"--\r\n").getBytes("UTF-8"));
  return http.send(HttpRequest.newBuilder(URI.create(origin+"/socialmap/"+action+".action")).header("Content-Type","multipart/form-data; boundary="+boundary).POST(HttpRequest.BodyPublishers.ofByteArray(body.toByteArray())).build(),HttpResponse.BodyHandlers.ofString());
 }
 static Map<String,String> uploadFields(String title){Map<String,String> p=new LinkedHashMap<>();p.put("step","1");p.put("csrf",csrf);p.put("title",title);p.put("cont","Synthetic image test");return p;}
 static byte[] png(int width,int height)throws Exception{java.awt.image.BufferedImage image=new java.awt.image.BufferedImage(width,height,java.awt.image.BufferedImage.TYPE_INT_RGB);image.setRGB(0,0,0x335577);ByteArrayOutputStream out=new ByteArrayOutputStream();javax.imageio.ImageIO.write(image,"png",out);return out.toByteArray();}
 static long fileCount()throws Exception{try(java.util.stream.Stream<Path> files=Files.list(uploads)){return files.count();}}
 static void check(boolean ok,String why){if(!ok)throw new AssertionError(why);checks++;}
 public static void main(String[] args)throws Exception{
  uploads=Files.createTempDirectory("socialmap-images-test");System.setProperty("socialmap.uploadDir",uploads.toString());
  String jdbc="jdbc:h2:mem:native_http;MODE=Oracle;DB_CLOSE_DELAY=-1";
  try(Connection c=DriverManager.getConnection(jdbc,"sa","")){
   for(String f:new String[]{"001-empty-schema.sql","002-synthetic-seed.sql"}){String text=new String(Files.readAllBytes(Paths.get("native/db/"+f)),"UTF-8").replaceAll("(?m)--.*$","");for(String s:text.split(";"))if(!s.trim().isEmpty()&&!s.contains("CREATE UNIQUE INDEX"))c.createStatement().execute(s);}
   try(PreparedStatement p=c.prepareStatement("update member set pwd=?")){p.setString(1,Passwords.hash("Synthetic-Password-42"));p.executeUpdate();}
  }
  Properties props=new Properties();props.setProperty("driver","org.h2.Driver");props.setProperty("url",jdbc);props.setProperty("username","sa");props.setProperty("password","");
  SqlMapClient client=SqlMapClientBuilder.buildSqlMapClient(new FileReader("src/sqlMapConfig.xml"),props);
  Field field=Database.class.getDeclaredField("client");field.setAccessible(true);field.set(null,client);
  Tomcat tomcat=new Tomcat();tomcat.setBaseDir(Files.createTempDirectory("socialmap-tomcat").toString());tomcat.setPort(0);tomcat.getConnector().setProperty("address","127.0.0.1");
  Path web=Files.createTempDirectory("socialmap-http-web");
  // Parent owns compiled app/libs for test-only H2 injection. Avoid loading duplicate Struts configs.
  try(java.util.zip.ZipFile war=new java.util.zip.ZipFile("native/build/socialmap.war")){java.util.Enumeration<? extends java.util.zip.ZipEntry> entries=war.entries();while(entries.hasMoreElements()){java.util.zip.ZipEntry e=entries.nextElement();if(e.isDirectory()||e.getName().startsWith("WEB-INF/lib/")||e.getName().startsWith("WEB-INF/classes/"))continue;Path file=web.resolve(e.getName());Files.createDirectories(file.getParent());Files.copy(war.getInputStream(e),file);}}
  Context context=tomcat.addWebapp("/socialmap",web.toString());context.setParentClassLoader(NativeHttpIntegration.class.getClassLoader());WebappLoader loader=new WebappLoader();loader.setDelegate(true);context.setLoader(loader);
  try{tomcat.start();origin="http://127.0.0.1:"+tomcat.getConnector().getLocalPort();CookieManager cookies=new CookieManager();http=HttpClient.newBuilder().cookieHandler(cookies).build();
   HttpResponse<String> response=call("Login",null);check(response.statusCode()==200,"Login page HTTP "+response.statusCode());check(csrf!=null&&!csrf.isEmpty(),"CSRF issued");
   response=call("MsgList",null);check(response.statusCode()==403,"Guest cannot read inbox");
   response=call("Login","check=1&id=member01&pwd=Synthetic-Password-42");check(response.statusCode()==200,"Native login "+response.statusCode());
   // Login rotates session and CSRF; reload once to obtain the current token.
   response=call("MsgList",null);check(response.statusCode()==200,"Authenticated inbox "+response.statusCode());
   response=call("ASWrite","step=1&title=forged&cont=forged");check(response.statusCode()==403,"Stored member role cannot publish admin notice");
   response=call("MsgWrite","step=1&sendid=admin&getid=leader01&title=NativeTest&cont=SyntheticOnly");check(response.statusCode()==200,"Native message write "+response.statusCode());Files.write(Paths.get("native/build/http-message.html"),response.body().getBytes("UTF-8"));
   try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select sendid from msg where title='NativeTest'")){check(r.next()&&"member01".equals(r.getString(1)),"Native action forces sender identity");}
   response=call("MsgInfo?no=999",null);
   check(response.statusCode()==403,"Unknown native target fails explicitly");
   int messageNo;try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select no from msg where title='NativeTest'")){r.next();messageNo=r.getInt(1);}
   call("Logout","");call("Login","check=1&id=member02&pwd=Synthetic-Password-42");
   response=call("MsgInfo?no="+messageNo,null);check(response.statusCode()==403,"Other member cannot read message over real HTTP");
   response=call("MsgDelete","no="+messageNo);check(response.statusCode()==403,"Other member cannot delete message over real HTTP");
   response=call("SignUp","step=1&id=forgedadmin&pwd=Synthetic-Password-42&name=Fake&email=fake%40example.invalid&auth=0");check(response.statusCode()==403,"Native signup rejects admin role");
   response=call("ProjDelete","teamno=1&leaderid=leader01");check(response.statusCode()==403,"Native owner check");
   response=call("MsgDelete",null);check(response.statusCode()==403,"Native GET mutation denied");
   response=call("ProjHopeMsg","getid=leader01");check(response.statusCode()==200,"Native application with internal notification");
   int hope;try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select no from hopelist where sendid='member02'")){check(r.next(),"Native request persisted");hope=r.getInt(1);}
   call("Logout","");call("Login","check=1&id=leader01&pwd=Synthetic-Password-42");
   response=call("insertTeam","no="+hope+"&id=forged&leaderid=forged");check(response.statusCode()==200,"Native acceptance derives request target");
   try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select teamno1 from member where id='member02'")){r.next();check(r.getInt(1)==1,"Native acceptance membership persisted");}
   response=call("ProjLifecycle","teamno=1&status=completed");check(response.statusCode()==200,"Native completion");
   response=call("RatingWrite","step=1&teamno=1&getid=member02&score=4&cont=SyntheticReview");check(response.statusCode()==200,"Native completed-peer rating");
   try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select rate from rating where sendid='leader01' and getid='member02'")){check(r.next()&&r.getInt(1)==4,"Native rating persisted");}
   call("Logout","");call("Login","check=1&id=admin&pwd=Synthetic-Password-42");
   response=call("CompWrite",null);check(response.statusCode()==200&&response.body().contains("CompWrite.action"),"Native admin competition form");
   response=call("CompWrite","step=1&title=NativeCompetition&cont=SyntheticOnly&fixture=fixture-poster.svg");check(response.statusCode()==200,"Native admin competition write");
   try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select img from competition where title='NativeCompetition'")){check(r.next()&&"fixture-poster.svg".equals(r.getString(1)),"Native safe fixture persisted");}
   byte[] picture=png(16,16);long before=fileCount();
   response=upload("CompWrite",uploadFields("UploadedCompetition"),picture,"poster.png","image/png");check(response.statusCode()==200,"Native PNG upload "+response.statusCode());
   int imageNo;String imageKey;try(Connection c=DriverManager.getConnection(jdbc,"sa","");ResultSet r=c.createStatement().executeQuery("select no,img from competition where title='UploadedCompetition'")){check(r.next(),"Uploaded competition persisted");imageNo=r.getInt(1);imageKey=r.getString(2);check(ImageUploads.stored(imageKey),"Generated storage key");}
   check(fileCount()==before+1,"One decoded image stored");
   HttpResponse<byte[]> download=http.send(HttpRequest.newBuilder(URI.create(origin+"/socialmap/competition-image?no="+imageNo)).build(),HttpResponse.BodyHandlers.ofByteArray());check(download.statusCode()==200&&javax.imageio.ImageIO.read(new ByteArrayInputStream(download.body()))!=null,"Current attached image downloads");check(download.headers().firstValue("x-content-type-options").orElse("").equals("nosniff"),"Download MIME protection");
   check(upload("CompWrite",uploadFields("UnsafeName"),picture,"../../poster.png","image/png").statusCode()==400,"Traversal filename rejected");
   check(upload("CompWrite",uploadFields("UnsafeType"),"<svg/>".getBytes("UTF-8"),"poster.png","image/png").statusCode()==400,"Spoofed image rejected");
   check(upload("CompWrite",uploadFields("Oversized"),new byte[ImageUploads.MAX_BYTES+1],"poster.png","image/png").statusCode()==400,"Oversized image rejected");
   check(upload("CompWrite",uploadFields("Dimensions"),png(4097,1),"poster.png","image/png").statusCode()==400,"Oversized dimensions rejected");
   Map<String,String> noCsrf=uploadFields("NoCsrf");noCsrf.put("csrf","forged");check(upload("CompWrite",noCsrf,picture,"poster.png","image/png").statusCode()==403,"Multipart CSRF enforced");
   try(Connection c=DriverManager.getConnection(jdbc,"sa","")){c.createStatement().execute("alter table competition add constraint fail_image_insert check(title <> 'UploadFailure')");}
   check(upload("CompWrite",uploadFields("UploadFailure"),picture,"poster.png","image/png").statusCode()==500,"Injected image DB failure reported");check(fileCount()==before+1,"Failed DB transaction cleans new file");
   try(Connection c=DriverManager.getConnection(jdbc,"sa","")){c.createStatement().execute("alter table competition drop constraint fail_image_insert");}
   Map<String,String> modify=uploadFields("UploadedCompetition");modify.put("no",String.valueOf(imageNo));check(upload("CompModify",modify,png(20,20),"replacement.png","image/png").statusCode()==200,"Image replacement succeeds");check(!Files.exists(uploads.resolve(imageKey))&&fileCount()==before+1,"Replaced image retired after commit");
   ByteArrayOutputStream jpeg=new ByteArrayOutputStream();javax.imageio.ImageIO.write(new java.awt.image.BufferedImage(12,12,java.awt.image.BufferedImage.TYPE_INT_RGB),"jpeg",jpeg);
   modify.put("csrf",csrf);check(upload("CompModify",modify,jpeg.toByteArray(),"replacement.jpg","image/jpeg").statusCode()==200,"Native JPEG upload succeeds");
   download=http.send(HttpRequest.newBuilder(URI.create(origin+"/socialmap/competition-image?no="+imageNo)).build(),HttpResponse.BodyHandlers.ofByteArray());check(download.statusCode()==200&&download.headers().firstValue("content-type").orElse("").startsWith("image/jpeg"),"JPEG download keeps verified MIME");
   call("Logout","");call("Login","check=1&id=member02&pwd=Synthetic-Password-42");modify.put("csrf",csrf);check(upload("CompModify",modify,picture,"poster.png","image/png").statusCode()==403,"Non-admin upload denied");check(fileCount()==before+1,"Denied upload does not write files");
   call("Logout","");call("Login","check=1&id=admin&pwd=Synthetic-Password-42");check(call("CompDelete","no="+imageNo).statusCode()==200,"Competition image owner can delete");check(fileCount()==before,"Deleted competition retires image");
   download=http.send(HttpRequest.newBuilder(URI.create(origin+"/socialmap/competition-image?no="+imageNo)).build(),HttpResponse.BodyHandlers.ofByteArray());check(download.statusCode()==404,"Deleted image cannot be downloaded");
   System.out.println("PASS "+checks+" real Tomcat/Struts/Tiles HTTP checks; synthetic H2 only");
  }finally{tomcat.stop();tomcat.destroy();}
 }
}
