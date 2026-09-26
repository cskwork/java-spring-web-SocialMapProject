package security;
import java.security.*;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
/** No plaintext fallback. Existing accounts require the controlled reset flow. */
public final class Passwords {
 public static String hash(String password) throws Exception {
  if(password==null||password.length()<8||password.length()>128)throw new IllegalArgumentException("Password length must be 8-128");
  byte[] salt=new byte[16];new SecureRandom().nextBytes(salt);
  return "pbkdf2$600000$"+Base64.getEncoder().encodeToString(salt)+"$"+Base64.getEncoder().encodeToString(derive(password,salt,600000));
 }
 private static byte[] derive(String p,byte[] s,int iterations)throws Exception {PBEKeySpec spec=new PBEKeySpec(p.toCharArray(),s,iterations,256);try{return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();}finally{spec.clearPassword();}}
 public static boolean verify(String password,String stored){try{String[] v=stored.split("\\$");int rounds=Integer.parseInt(v[1]);return v.length==4&&v[0].equals("pbkdf2")&&rounds>=600000&&rounds<=1000000&&MessageDigest.isEqual(Base64.getDecoder().decode(v[3]),derive(password,Base64.getDecoder().decode(v[2]),rounds));}catch(Exception e){return false;}}
 public static String token(){byte[] b=new byte[32];new SecureRandom().nextBytes(b);return Base64.getUrlEncoder().withoutPadding().encodeToString(b);}
 public static String digest(String s)throws Exception{return Base64.getEncoder().encodeToString(MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8")));}
}
