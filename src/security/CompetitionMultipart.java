package security;
import javax.servlet.http.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.*;
/** Strict bounded form parser, isolated from the legacy Struts multipart interceptor. */
public final class CompetitionMultipart extends HttpServletRequestWrapper {
 private final Map<String,String[]> fields=new LinkedHashMap<String,String[]>();
 private CompetitionMultipart(HttpServletRequest request){super(request);}
 public static CompetitionMultipart parse(HttpServletRequest request)throws IOException{
  String type=request.getContentType();Matcher boundaryMatch=Pattern.compile("boundary=(?:\"([A-Za-z0-9'()+_,./:=?-]{1,70})\"|([A-Za-z0-9'()+_,./:=?-]{1,70}))").matcher(type);
  if(!boundaryMatch.find()||request.getQueryString()!=null)throw new IOException("Invalid multipart boundary or query");String boundary=boundaryMatch.group(1)==null?boundaryMatch.group(2):boundaryMatch.group(1);
  int max=ImageUploads.MAX_BYTES+65536;if(request.getContentLength()>max)throw new IOException("Upload request too large");ByteArrayOutputStream bytes=new ByteArrayOutputStream();InputStream in=request.getInputStream();byte[] buffer=new byte[8192];int n;while((n=in.read(buffer))!=-1){if(bytes.size()+n>max)throw new IOException("Upload request too large");bytes.write(buffer,0,n);}
  byte[] body=bytes.toByteArray();String raw=new String(body,StandardCharsets.ISO_8859_1),marker="--"+boundary;CompetitionMultipart result=new CompetitionMultipart(request);int pos=0,parts=0;boolean imageSeen=false;
  if(!raw.startsWith(marker+"\r\n"))throw new IOException("Malformed multipart body");pos=marker.length()+2;
  while(true){if(++parts>24)throw new IOException("Too many form parts");int headerEnd=raw.indexOf("\r\n\r\n",pos);if(headerEnd<0||headerEnd-pos>4096)throw new IOException("Malformed part headers");String headers=raw.substring(pos,headerEnd);int end=raw.indexOf("\r\n"+marker,headerEnd+4);if(end<0)throw new IOException("Missing boundary");
   Matcher disposition=Pattern.compile("(?im)^Content-Disposition: form-data; name=\"([A-Za-z][A-Za-z0-9_]{0,40})\"(?:; filename=\"([^\"\r\n]*)\")?$").matcher(headers);if(!disposition.find())throw new IOException("Invalid form disposition");String name=disposition.group(1),filename=disposition.group(2);byte[] value=Arrays.copyOfRange(body,headerEnd+4,end);
   if(filename!=null){if(!name.equals("upload")||imageSeen)throw new IOException("Only one competition image is allowed");imageSeen=true;if(!filename.isEmpty()){Matcher mime=Pattern.compile("(?im)^Content-Type: (image/(?:png|jpeg))$").matcher(headers);if(!mime.find())throw new IOException("PNG/JPEG content type required");request.setAttribute(ImageUploads.PENDING,ImageUploads.validate(value,filename,mime.group(1)));}}
   else{if(value.length>8192||result.fields.containsKey(name))throw new IOException("Invalid or duplicate field");result.fields.put(name,new String[]{new String(value,StandardCharsets.UTF_8)});}
   pos=end+2+marker.length();if(raw.startsWith("--",pos)){if(!raw.substring(pos+2).matches("(?:\\r\\n)?"))throw new IOException("Trailing multipart data");break;}if(!raw.startsWith("\r\n",pos))throw new IOException("Malformed boundary");pos+=2;
  }return result;
 }
 public String getContentType(){return "application/x-www-form-urlencoded;charset=UTF-8";}
 public String getHeader(String name){return "content-type".equalsIgnoreCase(name)?getContentType():super.getHeader(name);}
 public String getParameter(String name){String[] values=fields.get(name);return values==null?null:values[0];}
 public String[] getParameterValues(String name){return fields.get(name);}
 public Map<String,String[]> getParameterMap(){return Collections.unmodifiableMap(fields);}
 public Enumeration<String> getParameterNames(){return Collections.enumeration(fields.keySet());}
}
