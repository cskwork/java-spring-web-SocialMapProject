package hopelist;

import java.io.IOException;
import java.io.Reader;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import content.specreg.SpecRegVO;
import favorite.FavoriteVO;
import hopelist.HopeListVO;
import temp.PagingAction;

@SuppressWarnings({ "unchecked", "serial" })
public class HopeListAction extends ActionSupport{
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	private HopeListVO paramClass;
	private HopeListVO resultClass;
	
	private List<HopeListVO> list = new ArrayList<HopeListVO>();
	private PagingAction page;
	private int currentPage = 1;
	private int totalCount;
	

	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;
	
	private String mainpage;
	
	private int no;
	private String sendid;
	private String getid;
	private Timestamp regdate;
	private int log;
	
	private String leaderid;
	
	private String auth;
	private String id;
	
	public HopeListAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}
	
	public String hopeList() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		list = sqlMapper.queryForList("hopelist.selectHopeList", session.get("id"));
		
		totalCount = list.size();

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "list", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount) {
			lastCount = page.getEndCount() + 1;
		}

		list = list.subList(page.getStartCount(), lastCount);
		
		//setGetid(session.get("id"));
		setAuth(session.get("auth"));

		setMainpage("hopelist");
		
		return SUCCESS;
	}
	
	public String insertTeam() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass = new HopeListVO();
		
		paramClass.setNo(no);
		paramClass.setSendid(leaderid);
		paramClass.setGetid(id);
		

		System.out.println(paramClass.getNo());
		System.out.println("보낸사람 : " + paramClass.getSendid());
		System.out.println("받는사람 : " + paramClass.getGetid());
		
		//member테이블에 Teamno1 추가
		sqlMapper.update("hopelist.insertTeam", paramClass);
		
		//projectteam의 현재인원 증가
		sqlMapper.update("hopelist.addCurrmem", paramClass);	
		
		//hopelist에서 삭제하기
		sqlMapper.delete("hopelist.deleteHopeList", paramClass);
		
		setMainpage("hopelist");

		return SUCCESS;
	}
	
	
	
	
	public String delete() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		

		paramClass = new HopeListVO();
		paramClass.setNo(no); //선택한 제안 번호

		sqlMapper.delete("hopelist.deleteHopeList", paramClass);
		
		setMainpage("deletehopelist");


		return SUCCESS;
	}

	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLeaderid() {
		return leaderid;
	}

	public void setLeaderid(String leaderid) {
		this.leaderid = leaderid;
	}

	public List<HopeListVO> getList() {
		return list;
	}

	public void setList(List<HopeListVO> list) {
		this.list = list;
	}
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
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
	public Timestamp getRegdate() {
		return regdate;
	}
	public void setRegdate(Timestamp regdate) {
		this.regdate = regdate;
	}
	public int getLog() {
		return log;
	}
	public void setLog(int log) {
		this.log = log;
	}
	
	public String getMainpage() {
		return mainpage;
	}
	
	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}
	
	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}

	public PagingAction getPage() {
		return page;
	}

	public void setPage(PagingAction page) {
		this.page = page;
	}

	public String getPagingHtml() {
		return pagingHtml;
	}

	public void setPagingHtml(String pagingHtml) {
		this.pagingHtml = pagingHtml;
	}
	
}
