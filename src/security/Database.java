package security;
import java.io.*;
import java.util.Properties;
import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.*;
/** One iBATIS client: transaction context is per thread, not per action instance. */
public final class Database {
 private static SqlMapClient client;
 public static synchronized SqlMapClient client() throws IOException {
  if(client==null){Properties p=new Properties();p.setProperty("driver","oracle.jdbc.OracleDriver");
   for(String[] entry:new String[][]{{"url","SOCIALMAP_DB_URL"},{"username","SOCIALMAP_DB_USER"},{"password","SOCIALMAP_DB_PASSWORD"}}){String value=System.getenv(entry[1]);if(value==null||value.trim().length()==0)throw new IOException("Required environment variable: "+entry[1]);p.setProperty(entry[0],value);}
   Reader r=Resources.getResourceAsReader("sqlMapConfig.xml");try{client=SqlMapClientBuilder.buildSqlMapClient(r,p);}finally{r.close();}
  }return client;
 }
}
