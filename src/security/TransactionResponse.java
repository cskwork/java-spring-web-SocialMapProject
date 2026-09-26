package security;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.*;
import java.io.*;
/** Do not expose action success before its transaction and file lifecycle have finished. */
public final class TransactionResponse extends HttpServletResponseWrapper {
 private final ByteArrayOutputStream body=new ByteArrayOutputStream();
 private int status=200;private PrintWriter writer;private boolean exceeded;
 private final ServletOutputStream output=new ServletOutputStream(){public void write(int b)throws IOException{if(body.size()>=4*1024*1024){exceeded=true;throw new IOException("Action response exceeds limit");}body.write(b);}public void write(byte[] b,int off,int len)throws IOException{if(body.size()+len>4*1024*1024){exceeded=true;throw new IOException("Action response exceeds limit");}body.write(b,off,len);}};
 public TransactionResponse(HttpServletResponse response){super(response);}
 public int statusCode(){return status;}
 public void setStatus(int value){status=value;}
 public void setStatus(int value,String message){status=value;}
 public void sendError(int code)throws IOException{sendError(code,"Request failed");}
 public void sendError(int code,String message)throws IOException{status=code;body.reset();writer=null;exceeded=false;setContentType("text/plain;charset=UTF-8");body.write(message.getBytes("UTF-8"));}
 public void sendRedirect(String location)throws IOException{status=302;setHeader("Location",location);resetBuffer();}
 public boolean isCommitted(){return false;}
 public void flushBuffer()throws IOException{if(writer!=null)writer.flush();}
 public void resetBuffer(){body.reset();exceeded=false;}
 public void reset(){super.reset();status=200;resetBuffer();writer=null;}
 public ServletOutputStream getOutputStream(){return output;}
 public PrintWriter getWriter()throws IOException{if(writer==null){String encoding=getCharacterEncoding();writer=new PrintWriter(new OutputStreamWriter(output,encoding==null?"ISO-8859-1":encoding)){public void close(){flush();}};}return writer;}
 public void ensureComplete()throws IOException{flushBuffer();if(exceeded||writer!=null&&writer.checkError())throw new IOException("Unable to buffer complete action response");}
 public void publish()throws IOException{ensureComplete();HttpServletResponse response=(HttpServletResponse)getResponse();response.setStatus(status);response.setContentLength(body.size());body.writeTo(response.getOutputStream());response.flushBuffer();}
}
