package msg;

import java.io.IOException;
import java.io.Reader;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import hopelist.HopeListVO;
import temp.PagingAction;

/*import temp.PagingAction;*/

@SuppressWarnings({ "serial", "unchecked" })
public class MsgAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	private MsgVO paramClass;
	private MsgVO resultClass;
	
	private HopeListVO paramClass2;

	// 리스트 관련
	private List<MsgVO> list;
	private String sendid; // 쓰기와 공용
	private String getid; // 쓰기와 공용
	private String id;
    private String box; public void setBox(String value){box=value;} public String getBox(){return box;}

	private int check = 0;
	private PagingAction page;
	private int no;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;

	// 쓰기 관련
	private int step = 0;
	private String title;
	private String cont;
	private Timestamp sendtime;
	private String msglog = "3";
	
	private String mainpage;

	public MsgAction() throws IOException {
		sqlMapper = security.Database.client();
	}

	@Override
	public String execute() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass = new MsgVO();

		if (!"sent".equals(box)) {
			paramClass.setGetid(session.get("id"));
		} else {
			paramClass.setSendid(session.get("id"));
		}

		list = sqlMapper.queryForList("msg.MsgList", paramClass);

		totalCount = list.size();
		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "MsgList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;

		list = list.subList(page.getStartCount(), lastCount);

		for(int i = 0;i < list.size(); i++)
			System.out.println(list.get(i).getNo());
		
		setCheck(getCheck());

		return SUCCESS;
	}

	public String write() throws Exception {
		if (getStep() == 0) {
			return "write";
		} else {
			paramClass = new MsgVO();
			paramClass.setSendid((String)ActionContext.getContext().getSession().get("id"));
			paramClass.setGetid(getGetid());
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setSendtime(new Timestamp(System.currentTimeMillis()));

			security.Service.require(getTitle()!=null && getTitle().trim().length()>0 && getCont()!=null && getCont().trim().length()>0 && getCont().length()<=2000,"Invalid message");
            security.Service.message(paramClass.getSendid(),getGetid(),getTitle(),getCont());
			
			return SUCCESS;
		}
	}
	
 public String delete() throws Exception {
  String actor=(String)ActionContext.getContext().getSession().get("id");
  java.util.Map row=security.Service.one("select * from msg where no=? and (sendid=? or getid=?)",no,actor,actor);
  security.Service.require(row!=null,"Message ownership required");
  if(security.Service.one("select no from message_deleted where no=? and id=?",no,actor)==null)security.Service.update("insert into message_deleted(no,id) values(?,?)",no,actor);
  return SUCCESS;
 }
 public String info() throws Exception {
  String actor=(String)ActionContext.getContext().getSession().get("id");
  resultClass=(MsgVO)sqlMapper.queryForObject("msg.MsgInfo",getNo());
  security.Service.require(resultClass!=null&&(actor.equals(resultClass.getSendid())||actor.equals(resultClass.getGetid())),"Message ownership required");
  security.Service.require(security.Service.one("select no from message_deleted where no=? and id=?",no,actor)==null,"Message deleted");
  security.Service.update("update msg set read_at=CURRENT_TIMESTAMP where no=? and getid=?",no,actor);return SUCCESS;
 }
 public String spechope() throws Exception {security.Service.hope((String)ActionContext.getContext().getSession().get("id"),getid,0);setMainpage("sendcomplete");return SUCCESS;}
 public String projhope() throws Exception {security.Service.hope((String)ActionContext.getContext().getSession().get("id"),getid,1);setMainpage("sendcomplete");return SUCCESS;}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public int getCheck() {
		return check;
	}

	public void setCheck(int check) {
		this.check = check;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getCont() {
		return cont;
	}

	public void setCont(String cont) {
		this.cont = cont;
	}

	public Timestamp getSendtime() {
		return sendtime;
	}

	public void setSendtime(Timestamp sendtime) {
		this.sendtime = sendtime;
	}

	public String getMsglog() {
		return msglog;
	}

	public void setMsglog(String msglog) {
		this.msglog = msglog;
	}

	public String getSendid() {
		return sendid;
	}

	public void setSendid(String sendid) {
		this.sendid = sendid;
	}

	public String getGetid() {
		return getid;
	}

	public void setGetid(String getid) {
		this.getid = getid;
	}

	public MsgVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(MsgVO paramClass) {
		this.paramClass = paramClass;
	}

	public MsgVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(MsgVO resultClass) {
		this.resultClass = resultClass;
	}

	public List<MsgVO> getList() {
		return list;
	}

	public void setList(List<MsgVO> list) {
		this.list = list;
	}

	public PagingAction getPage() {
		return page;
	}

	public void setPage(PagingAction page) {
		this.page = page;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getBlockCount() {
		return blockCount;
	}

	public void setBlockCount(int blockCount) {
		this.blockCount = blockCount;
	}

	public int getBlockPage() {
		return blockPage;
	}

	public void setBlockPage(int blockPage) {
		this.blockPage = blockPage;
	}

	public String getPagingHtml() {
		return pagingHtml;
	}

	public void setPagingHtml(String pagingHtml) {
		this.pagingHtml = pagingHtml;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}
	
	public String getMainpage() {
		return mainpage;
	}
	
	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}

}
