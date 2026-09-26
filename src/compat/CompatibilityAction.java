package compat;
import com.opensymphony.xwork2.*;
import java.util.*;
import security.*;
public class CompatibilityAction extends ActionSupport {
 private String mainpage,teamno,status,token,pwd;
 public String admin(){Service.require("0".equals(ActionContext.getContext().getSession().get("auth")),"Administrator required");mainpage="adminhome";return SUCCESS;}
 public String expire(){ActionContext.getContext().getSession().clear();mainpage="login";return SUCCESS;}
 public String reset()throws Exception{Service.reset(token,pwd);ActionContext.getContext().getSession().clear();mainpage="login";return SUCCESS;}
 public String lifecycle()throws Exception{Map s=ActionContext.getContext().getSession();Service.lifecycle((String)s.get("id"),"0".equals(s.get("auth")),teamno,status);mainpage="main";return SUCCESS;}
 public String getMainpage(){return mainpage;}public void setTeamno(String v){teamno=v;}public void setStatus(String v){status=v;}public void setToken(String v){token=v;}public void setPwd(String v){pwd=v;}
}
