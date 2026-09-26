package rating;
import com.opensymphony.xwork2.*;
import security.Service;
import java.util.*;
/** Original Rating action contract; eligibility now uses explicit completed-project history. */
public class RatingAction extends ActionSupport {
 private int step,score,teamno;private String getid,cont;
 private List<Map<String,Object>> list=new ArrayList<Map<String,Object>>(),completed=new ArrayList<Map<String,Object>>();
 public String execute()throws Exception{
  String id=(String)ActionContext.getContext().getSession().get("id");Service.require(id!=null,"Login required");
  list=Service.list("select sendid,getid,rate as score,reputation as cont,teamexp as teamno from rating where sendid=? or getid=?",id,id);
  completed=Service.list("select p.teamno,p.title from projectteam p join project_history h on h.teamno=p.teamno where h.id=? and p.status='completed'",id);
  for(Map<String,Object> project:completed){StringBuilder peers=new StringBuilder();for(Map<String,Object> row:Service.list("select id from project_history where teamno=? and id<>?",project.get("teamno"),id)){if(peers.length()>0)peers.append(", ");peers.append(row.get("id"));}project.put("peers",peers.toString());}return SUCCESS;
 }
 public String write()throws Exception{
  if(step==0)return "write";String id=(String)ActionContext.getContext().getSession().get("id");
  Service.require(id!=null&&!id.equals(getid)&&score>=1&&score<=5,"Invalid rating");
  Service.require(Service.one("select p.teamno from projectteam p join project_history a on a.teamno=p.teamno join project_history b on b.teamno=p.teamno where p.teamno=? and p.status='completed' and a.id=? and b.id=?",teamno,id,getid)!=null,"Completed shared project required");
  Service.require(Service.one("select sendid from rating where sendid=? and getid=? and teamexp=?",id,getid,teamno)==null,"Already rated");
  Service.changed(Service.update("insert into rating(sendid,getid,rate,teamexp,ratingregdate,reputation) values(?,?,?,?,CURRENT_TIMESTAMP,?)",id,getid,score,teamno,cont));return SUCCESS;
 }
 public List getList(){return list;}public List getCompleted(){return completed;}public int getTeamno(){return teamno;}
 public void setStep(int v){step=v;}public void setScore(int v){score=v;}public void setTeamno(int v){teamno=v;}public void setGetid(String v){getid=v;}public void setCont(String v){cont=v;}
}
