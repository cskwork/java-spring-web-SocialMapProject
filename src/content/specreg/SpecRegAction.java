package content.specreg;

import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import content.project.ProjectTeamVO;
import member.MemberVO;
import temp.PagingAction;
import temp.SearchVO;

@SuppressWarnings({ "serial", "unchecked" })
public class SpecRegAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	public int step;
	// 페이지관련
	private String mainpage;
	private String name;

	// 리스트 관련
	private List<SpecRegVO> list;
	private PagingAction page;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;
	private int check = 0;
	
	//필터 관련
	private List<String> addrlist = new ArrayList<String>();
	private List<String> complist = new ArrayList<String>();
	private List<String> majlist = new ArrayList<String>();
	
	public int getCheck() {
		return check;
	}

	public void setCheck(int check) {
		this.check = check;
	}

	// 상세정보 관련
	private SpecRegVO paramClass;
	private SpecRegVO resultClass;
	private MemberVO tempResultClass;
	private String id; // 글쓰기에도 관련

	// 글쓰기 관련
	private Date regdate;
	private String exp;
	private String maj;
	private String addr;
	private String contadd;
	private boolean showlog;
	
	//검색 관련
	private String search;
	private int searchnum;
	
	//권한
	private int auth;
	
	
	public SpecRegAction() throws IOException, SQLException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml"); // sqlMapConfig.xml 파일의 설정내용을 가져온다.
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader); // sqlMapConfig.xml의 내용을 적용한 sqlMapper 객체 생성.
		reader.close();
		
		/*필터 관련*/
		//스펙 검색 필터
		majlist = sqlMapper.queryForList("major.selectFilterMaj");
		
		addrlist.add("서울");
		addrlist.add("부산");
		addrlist.add("대구");
		addrlist.add("인천");
		addrlist.add("광주");
		addrlist.add("대전");
		addrlist.add("울산");
		addrlist.add("세종");
		addrlist.add("경기도");
		addrlist.add("강원도");
		addrlist.add("충청남도");
		addrlist.add("충청북도");
		addrlist.add("전라북도");
		addrlist.add("전라남도");
		addrlist.add("경상북도");
		addrlist.add("경상남도");
		addrlist.add("제주도");
		
		//전공 가져오기
	   
	    
	}

	@Override
	public String execute() throws Exception {
		SearchVO sVO = new SearchVO();
		int b, c;
		b = c = 0;
		if (!(getAddr() == null || getAddr().equals("") || getAddr().equals("0"))) {
			sVO.setAddr("%" + getAddr() + "%");
			b = 1;
		}
		if (!(getMaj() == null || getMaj().equals("") || getMaj().equals("0"))) {
			sVO.setMaj("%" + getMaj() + "%");
			c = 1;
		}

		sVO.setAnd1(b * (c == 1 ? 0 : 1) + c);
		sVO.setAnd2(b * c);

		// 옵션 1

		if (search != null) {
			list = sqlMapper.queryForList("content.selectSpecId", "%" + getSearch() + "%");
		} else {
			list = sqlMapper.queryForList("content.selectSpecList", sVO);
		}

		totalCount = list.size();

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "SpecList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;

		list = list.subList(page.getStartCount(), lastCount);

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		if (session.get("auth") != null && session.get("auth").equals("0")) {
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			setAuth(Integer.parseInt(session.get("auth")));

			for (SpecRegVO vo : list) {
				if (vo.getId().equals(session.get("id"))) {
					setCheck(1);

					break;
				}
			}

			setMainpage("speclist");
			return SUCCESS;
		}
	}

	public String info() throws Exception {
		System.out.println("------" + getId());
		
		resultClass = (SpecRegVO) sqlMapper.queryForObject("content.selectSpec", getId());

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if (session.get("auth") != null && session.get("auth").equals("0")) {
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			setAuth(Integer.parseInt(session.get("auth")));
	
			setMainpage("specinfo");
			return SUCCESS;
		}
	}

	public String write() throws Exception {
		paramClass = new SpecRegVO();
		
		setId((String) ActionContext.getContext().getSession().get("id"));
		
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		//member가져와야될 값 Addr, Contadd, MAJ
		
		tempResultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));		

		paramClass.setId(getId());
		paramClass.setExp(getExp());
		paramClass.setAddr(tempResultClass.getAddr());
		paramClass.setMaj(tempResultClass.getMaj());		
		paramClass.setContadd(tempResultClass.getExp());
		
		paramClass.setRegdate(new Timestamp(System.currentTimeMillis()));
		

		if (getShowlog())
			paramClass.setShowlog(1);
		else
			paramClass.setShowlog(0);

		sqlMapper.insert("content.insertSpec", paramClass);

		
		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(Integer.parseInt(session.get("auth")));

		setMainpage("speclist");

		return SUCCESS;
	}
	
	public String modify() throws Exception {
		setMainpage("specmodify");

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if (getStep() == 0) {

			setId(session.get("id"));
			setName(session.get("name"));
			setAuth(Integer.parseInt(session.get("auth")));
			
			resultClass = (SpecRegVO) sqlMapper.queryForObject("content.selectSpec", session.get("id"));
			
			return SUCCESS;

		} else {
		
			paramClass = new SpecRegVO();
			paramClass.setId(session.get("id"));
			paramClass.setExp(getExp());
			paramClass.setMaj(getMaj());
			paramClass.setAddr(getAddr());
			paramClass.setContadd(getContadd());
			if (getShowlog())
				paramClass.setShowlog(1);
			else
				paramClass.setShowlog(0);

			sqlMapper.update("content.updateSpec", paramClass);
			
			setStep(2);

			return SUCCESS;
		}
	}


	public String delete() throws Exception {
		paramClass = new SpecRegVO();
	    paramClass.setId(getId());
	      
	    sqlMapper.delete("content.deleteSpec", paramClass);
	    System.out.println("삭제할 스펙등록 아이디 :"+getId());
	    return SUCCESS;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<SpecRegVO> getList() {
		return list;
	}

	public void setList(List<SpecRegVO> list) {
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

	public List<String> getAddrlist() {
		return addrlist;
	}

	public void setAddrlist(List<String> addrlist) {
		this.addrlist = addrlist;
	}

	public List<String> getComplist() {
		return complist;
	}

	public void setComplist(List<String> complist) {
		this.complist = complist;
	}

	public List<String> getMajlist() {
		return majlist;
	}

	public void setMajlist(List<String> majlist) {
		this.majlist = majlist;
	}

	public SpecRegVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(SpecRegVO paramClass) {
		this.paramClass = paramClass;
	}

	public SpecRegVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(SpecRegVO resultClass) {
		this.resultClass = resultClass;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public String getExp() {
		return exp;
	}

	public void setExp(String exp) {
		this.exp = exp;
	}

	public String getMaj() {
		return maj;
	}

	public void setMaj(String maj) {
		this.maj = maj;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getContadd() {
		return contadd;
	}

	public void setContadd(String contadd) {
		this.contadd = contadd;
	}

	public boolean isShowlog() {
		return showlog;
	}
	
	public boolean getShowlog() {
		return showlog;
	}

	public void setShowlog(boolean showlog) {
		this.showlog = showlog;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public int getSearchnum() {
		return searchnum;
	}

	public void setSearchnum(int searchnum) {
		this.searchnum = searchnum;
	}

	public int getAuth() {
		return auth;
	}

	public void setAuth(int auth) {
		this.auth = auth;
	}

	
}
