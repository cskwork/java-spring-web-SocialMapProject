package security;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import javax.imageio.*;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.http.HttpServletRequest;
/** Local competition images: bounded decode/re-encode, generated names, outside webroot. */
public final class ImageUploads {
 public static final int MAX_BYTES=2*1024*1024;
 public static final String PENDING="socialmap.image.pending", CREATED="socialmap.image.created", RETIRED="socialmap.image.retired";
 public static final class Pending {final byte[] bytes;final String format;Pending(byte[] b,String f){bytes=b;format=f;}}
 public static Pending validate(byte[] source,String filename,String contentType)throws IOException{
  if(source.length==0||source.length>MAX_BYTES)throw new IOException("Image must be 1 byte to 2 MiB");
  if(filename==null||!filename.matches("[A-Za-z0-9][A-Za-z0-9_. -]{0,120}\\.(?i:png|jpe?g)"))throw new IOException("PNG/JPEG filename required; paths are forbidden");
  ImageInputStream in=ImageIO.createImageInputStream(new ByteArrayInputStream(source));if(in==null)throw new IOException("Unreadable image");
  try{Iterator<ImageReader> readers=ImageIO.getImageReaders(in);if(!readers.hasNext())throw new IOException("Not a PNG/JPEG image");ImageReader reader=readers.next();
   try{reader.setInput(in,true,true);String format=reader.getFormatName().toLowerCase(Locale.ROOT);if(format.equals("jpg"))format="jpeg";
    if(!format.equals("png")&&!format.equals("jpeg"))throw new IOException("Only PNG/JPEG supported");
    if(!("image/"+format).equalsIgnoreCase(contentType))throw new IOException("Image type does not match contents");
    int width=reader.getWidth(0),height=reader.getHeight(0);if(width<1||height<1||width>4096||height>4096||(long)width*height>16000000)throw new IOException("Image dimensions exceed limits");
    BufferedImage image=reader.read(0);ByteArrayOutputStream clean=new ByteArrayOutputStream();if(!ImageIO.write(image,format,clean))throw new IOException("Image re-encoding failed");if(clean.size()>MAX_BYTES)throw new IOException("Decoded image exceeds storage limit");return new Pending(clean.toByteArray(),format);
   }finally{reader.dispose();}
  }finally{in.close();}
 }
 public static Path root()throws IOException{
  String configured=System.getProperty("socialmap.uploadDir",System.getenv("SOCIALMAP_UPLOAD_DIR"));if(configured==null||configured.trim().isEmpty())throw new IOException("SOCIALMAP_UPLOAD_DIR is required for local uploads");
  Path root=Paths.get(configured).toAbsolutePath().normalize();if(!Paths.get(configured).isAbsolute())throw new IOException("Upload directory must be absolute");
  try{Files.createDirectories(root,java.nio.file.attribute.PosixFilePermissions.asFileAttribute(java.nio.file.attribute.PosixFilePermissions.fromString("rwx------")));}catch(UnsupportedOperationException unsupported){Files.createDirectories(root);}if(Files.isSymbolicLink(root))throw new IOException("Upload directory cannot be a symbolic link");return root.toRealPath();
 }
 public static boolean stored(String name){return name!=null&&name.matches("[0-9a-f-]{36}\\.(png|jpeg)");}
 public static Path path(String name)throws IOException{if(!stored(name))throw new IOException("Invalid stored image key");Path root=root(),target=root.resolve(name).normalize();if(!target.getParent().equals(root)||Files.isSymbolicLink(target))throw new IOException("Unsafe image path");return target;}
 public static String persist(HttpServletRequest request)throws IOException{
  Pending image=(Pending)request.getAttribute(PENDING);if(image==null)return null;
  String webroot=request.getSession().getServletContext().getRealPath("/");if(webroot!=null&&root().startsWith(Paths.get(webroot).toRealPath()))throw new IOException("Upload directory must be outside webroot");
  String name=UUID.randomUUID().toString()+"."+image.format;Path target=path(name);try{Files.createFile(target,java.nio.file.attribute.PosixFilePermissions.asFileAttribute(java.nio.file.attribute.PosixFilePermissions.fromString("rw-------")));}catch(UnsupportedOperationException unsupported){Files.createFile(target);}request.setAttribute(CREATED,name);Files.write(target,image.bytes,StandardOpenOption.WRITE);return name;
 }
 public static void retire(HttpServletRequest request,String previous){if(stored(previous))request.setAttribute(RETIRED,previous);}
 public static void finish(HttpServletRequest request,boolean committed)throws IOException{
  Object name=request.getAttribute(committed?RETIRED:CREATED);if(name!=null)Files.deleteIfExists(path(String.valueOf(name)));
 }
}
