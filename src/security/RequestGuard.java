package security;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import com.ibatis.sqlmap.client.SqlMapClient;
/** Protects both original action requests and the native HTML transport. */
public final class RequestGuard implements Filter {
 public void init(FilterConfig config){} public void destroy(){}
 private boolean write(HttpServletRequest r,String a){return a.matches(".*(Delete|HopeMsg)|delete.*|delProj|delSpec|favProj|favSpec|insertTeam|Logout|SessionExpire|ProjLifecycle|ResetPassword|checkPwd|modifyMember|SpecWrite")||((a.matches(".*(Write|Modify)|SignUp|Find|Login"))&&(!"0".equals(r.getParameter("step"))&&r.getParameter("step")!=null||r.getParameter("check")!=null));}
 private String val(HttpServletRequest r,String k){String v=r.getParameter(k);return v==null?"":v;}
 public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException {
  HttpServletRequest r=(HttpServletRequest)request;
  String uri=r.getServletPath();
  if(uri.startsWith("/admin/")||uri.endsWith(".jsp")&&!uri.equals("/index.jsp")){((HttpServletResponse)response).sendError(403,"Use an action route");return;}
  if(!uri.endsWith(".action")){chain.doFilter(r,response);return;}
  TransactionResponse responseBuffer=new TransactionResponse((HttpServletResponse)response);HttpServletResponse w=responseBuffer;
  try {
  String a=uri.substring(uri.lastIndexOf('/')+1,uri.length()-7);if(!a.matches("[A-Za-z][A-Za-z0-9]*")){w.sendError(400,"Unknown action name");return;}r.setCharacterEncoding(r.getContentType()!=null&&r.getContentType().toLowerCase().contains("utf-8")?"UTF-8":"EUC-KR");
  HttpSession session=r.getSession();if(session.getAttribute("csrf")==null)session.setAttribute("csrf",Passwords.token());
  w.setHeader("X-Content-Type-Options","nosniff");w.setHeader("Cache-Control","no-store");w.setHeader("X-SocialMap-CSRF",String.valueOf(session.getAttribute("csrf")));
  if(r.getContentType()!=null&&r.getContentType().toLowerCase().startsWith("multipart/")){
   if(!"POST".equals(r.getMethod())||!a.matches("CompWrite|CompModify")||session.getAttribute("id")==null){w.sendError(403,"Authenticated competition upload required");return;}
   try{r=CompetitionMultipart.parse(r);}catch(IOException e){w.sendError(400,e.getMessage());return;}
  }
  for(Object key:r.getParameterMap().keySet())if(!String.valueOf(key).matches("[A-Za-z][A-Za-z0-9_]{0,40}")){w.sendError(400,"Unsupported parameter name");return;}
  boolean mutation=write(r,a);if(mutation&&(!"POST".equals(r.getMethod())||!String.valueOf(session.getAttribute("csrf")).equals(r.getParameter("csrf"))&&!String.valueOf(session.getAttribute("csrf")).equals(r.getHeader("X-CSRF-Token")))){w.sendError(403,"POST with CSRF token required");return;}
  SqlMapClient db=null;boolean committed=false;
  try{
   db=Database.client();db.startTransaction();
   String id=(String)session.getAttribute("id");Map<String,Object> member=id==null?null:Service.one("select * from member where id=?",id);
   if(id!=null&&member==null){session.invalidate();throw new SecurityException("Session expired");}
   String role=member==null?null:String.valueOf(member.get("auth"));if(member!=null)session.setAttribute("auth",role);
   boolean admin="0".equals(role);
   boolean publicAction=a.matches("SocialMap|Login|SignUp|Find|ConfirmId|ResetPassword|Major|ProjList|ProjInfo|SpecList|SpecInfo|CompList|CompBestlist|CompInfo|ASList|ASInfo|FAQList|FAQInfo|guideHome[123]?");
   Service.require(publicAction||member!=null,"Login required");
   if(a.matches("(Comp|AS|FAQ)(Write|Modify|Delete)|QnaAdmin.*|AdminHome"))Service.require(admin,"Administrator required");
   if(a.equals("ProjWrite")){Service.require("1".equals(role),"Team leader required");if(mutation){Map<String,Object> owner=Service.one("select * from member where id=? for update",id);Service.require(owner.get("teamno1")==null||"0".equals(String.valueOf(owner.get("teamno1"))),"One active project only");}}
   if(a.matches("ProjWrite|ProjModify")&&mutation){Service.require(val(r,"recmem").matches("[0-9]{1,2}")&&Integer.parseInt(val(r,"recmem"))>=1,"Recruitment must be 1-99");Service.require(!val(r,"title").trim().isEmpty()&&!val(r,"cont").trim().isEmpty(),"Title and content required");Service.require(val(r,"startdate").isEmpty()||val(r,"enddate").isEmpty()||val(r,"enddate").compareTo(val(r,"startdate"))>=0,"Invalid dates");}
   if(a.equals("SpecHopeMsg"))Service.require("1".equals(role),"Team leader required");
   if(a.equals("ProjHopeMsg")||a.equals("SpecWrite"))Service.require("2".equals(role),"Team member required");
   if(a.matches("ProjModify|ProjDelete|MyProjInfo")){Map<String,Object> p=Service.one("select * from projectteam where teamno=?",val(r,"teamno"));Service.require(p!=null&&(admin||id.equals(p.get("leaderid"))||a.equals("MyProjInfo")&&String.valueOf(p.get("teamno")).equals(String.valueOf(member.get("teamno1")))),"Project ownership required");}
   if(a.matches("SpecDelete|deleteSpec"))Service.require(admin||id.equals(val(r,"id")),"Spec ownership required");
   if(a.matches("SpecInfo|favSpecInfo")){Map<String,Object> p=Service.one("select * from specreg where id=?",val(r,"id"));Service.require(p!=null&&(admin||Objects.equals(id,p.get("id"))||"1".equals(String.valueOf(p.get("showlog")))),"Private spec");}
   if(a.matches("QnaInfo|QnaModify|QnaDelete")){Map<String,Object> q=Service.one("select * from qna where no=? and qalog=0",val(r,"no"));Service.require(q!=null&&(admin||id.equals(q.get("id"))),"Question ownership required");}
   if(mutation){for(String field:new String[]{"title","cont","exp","name","email"}){String v=r.getParameter(field);if(v!=null)Service.require(v.length()<=5000,"Input too long");}}
   chain.doFilter(r,w);
   responseBuffer.ensureComplete();
   if(responseBuffer.statusCode()<400 && !Boolean.TRUE.equals(r.getAttribute("socialmap.rollback"))){db.commitTransaction();committed=true;}
  }catch(SecurityException e){if(!w.isCommitted())w.sendError(403,e.getMessage());}
   catch(Exception e){Throwable cause=e;while(cause.getCause()!=null&&cause.getCause()!=cause)cause=cause.getCause();if(!w.isCommitted())w.sendError(cause instanceof SecurityException?403:500,"Request failed; no changes committed");if(!(cause instanceof SecurityException))getServletContext(r).log("SocialMap request failed",e);}
   finally{try{ImageUploads.finish(r,committed);}catch(IOException cleanup){getServletContext(r).log("Image cleanup requires retry",cleanup);}if(db!=null)try{db.endTransaction();}catch(Exception e){throw new ServletException(e);}}
  } finally { responseBuffer.publish(); }
 }
 private ServletContext getServletContext(HttpServletRequest r){return r.getSession().getServletContext();}
}
