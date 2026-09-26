package security;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import com.ibatis.sqlmap.client.SqlMapClient;
/** Only the image currently attached to a competition is retrievable. No raw path parameter. */
public final class CompetitionImageServlet extends HttpServlet {
 protected void doGet(HttpServletRequest request,HttpServletResponse response)throws IOException{
  response.setHeader("X-Content-Type-Options","nosniff");response.setHeader("Content-Security-Policy","default-src 'none'; sandbox");
  SqlMapClient db=null;try{String no=request.getParameter("no");if(no==null||!no.matches("[0-9]{1,10}")){response.sendError(400);return;}db=Database.client();db.startTransaction();Map row=Service.one("select img from competition where no=?",Integer.valueOf(no));if(row==null||!ImageUploads.stored((String)row.get("img"))){response.sendError(404);return;}
   String key=(String)row.get("img");Path file=ImageUploads.path(key);if(!Files.isRegularFile(file,LinkOption.NOFOLLOW_LINKS)){response.sendError(404);return;}response.setContentType(key.endsWith(".png")?"image/png":"image/jpeg");response.setHeader("Content-Disposition","attachment; filename=\"competition-"+no+(key.endsWith(".png")?".png":".jpeg")+"\"");response.setContentLength((int)Files.size(file));Files.copy(file,response.getOutputStream());
  }catch(Exception e){if(!response.isCommitted())response.sendError(500,"Image unavailable");}finally{if(db!=null)try{db.endTransaction();}catch(Exception ignored){}}
 }
}
