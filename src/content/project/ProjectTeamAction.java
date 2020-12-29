package content.project;

import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
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

import member.MemberVO;
import temp.PagingAction;
import temp.SearchVO;
import temp.UpdateTeamnoVO;

@SuppressWarnings({ "serial", "unchecked" })
public class ProjectTeamAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	public int step;

	// 페이지 관련
	private String mainpage;
	private String name;

	// 리스트 관련
	private List<ProjectTeamVO> list = new ArrayList<ProjectTeamVO>();;
	
	//필터 관련
	private List<String> loclist = new ArrayList<String>();
	private List<String> complist = new ArrayList<String>();
	private List<String> majlist = new ArrayList<String>();

	private PagingAction page;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;

	// 상세보기 관련
	private String teamno;
	private ProjectTeamVO paramClass; // 요청jsp에서 파라미터를 저장할 객체
	private ProjectTeamVO resultClass; // 리턴jsp에서 받을 파라미터를 저장할 객체

	// 글쓰기 관련
	private String id;
	private String title;
	private String comp;
	private String startdate;
	private String enddate;
	private String recmem;
	private String maj;
	private String cont;
	private String loc;
	private String sal;
	private boolean check = true;

	// 검색 관련
	private String search;
	private int searchnum;

	// 권한 관련
	private int auth;

	// 수정삭제 관련
	private String leaderid;

	public ProjectTeamAction() throws IOException, SQLException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml"); // sqlMapConfig.xml 파일의 설정내용을 가져온다.
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader); // sqlMapConfig.xml의 내용을 적용한 sqlMapper 객체 생성.
		reader.close();
		
		
		/*필터 관련*/
		//대회공모 title
		complist = sqlMapper.queryForList("content.selectFilterComp");
		
		loclist.add("서울");
		loclist.add("부산");
		loclist.add("대구");
		loclist.add("인천");
		loclist.add("광주");
		loclist.add("대전");
		loclist.add("울산");
		loclist.add("세종");
		loclist.add("경기도");
		loclist.add("강원도");
		loclist.add("충청남도");
		loclist.add("충청북도");
		loclist.add("전라북도");
		loclist.add("전라남도");
		loclist.add("경상북도");
		loclist.add("경상남도");
		loclist.add("제주도");
		
		//전공 가져오기
	    majlist = sqlMapper.queryForList("major.selectFilterMaj");
		

	}

	@Override
	public String execute() throws Exception {
		SearchVO sVO = new SearchVO();
		int a, b, c;
		a = b = c = 0;
		if (!(getComp() == null || getComp().equals("") || getComp().equals("0"))) {
			sVO.setComp(getComp());
			a = 1;
		}
		if (!(getLoc() == null || getLoc().equals("") || getLoc().equals("0"))) {
			sVO.setLoc("%" + getLoc() + "%");
			b = 1;
		}
		if (!(getMaj() == null || getMaj().equals("") || getMaj().equals("0"))) {
			sVO.setMaj("%" + getMaj() + "%");
			c = 1;
		}

		sVO.setAnd1(a * (b * (c == 1 ? 0 : 1) + c));
		sVO.setAnd2(b * c);

		if (!(getSearch() == null || getSearch().equals(""))) {
			if (searchnum == 0) {
				list = sqlMapper.queryForList("content.selectProjTitle", "%" + getSearch() + "%");
			} else if (searchnum == 1) {
				list = sqlMapper.queryForList("content.selectProjLeader", "%" + getSearch() + "%");
			}
		} else {
			list = sqlMapper.queryForList("content.selectProjList", sVO);
		}

		totalCount = list.size();

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "ProjList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;

		list = list.subList(page.getStartCount(), lastCount);

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		setCheck(isCheck());
		if (session.get("auth") != null && session.get("auth").equals("0")) {
			return "admin";
		} else {
			setMainpage("projlist");

			return SUCCESS;
		}
	}

	public String info() throws Exception {
		resultClass = (ProjectTeamVO) sqlMapper.queryForObject("content.selectProj", Integer.parseInt(getTeamno()));

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if (session.get("auth") != null && session.get("auth").equals("0")) {
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			setAuth(Integer.parseInt(session.get("auth")));
			
			System.out.println("로그인 아이디 : " + getId());
			System.out.println("선택한 글 아이디 : " + leaderid);
			
			setMainpage("projinfo");
			return SUCCESS;
		}
	}

	public String write() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		setId(session.get("id"));
		setName(session.get("name"));
		
		MemberVO tempMember = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));
		setMainpage("projwrite");

		if(!(tempMember.getTeamno1() == null || tempMember.getTeamno1().equals("0"))) {
			setStep(2);
			setCheck(false);
			return SUCCESS;
		}
		
		System.out.println(tempMember.getTeamno1());

		setTeamno(tempMember.getTeamno1());

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date start = null;
		Date end = null;

		if (!(getStartdate() == null || getStartdate().equals("")))
			start = format.parse(getStartdate() + " 00:00:00");
		if (!(getEnddate() == null || getEnddate().equals("")))
			end = format.parse(getEnddate() + " 23:59:59");

		paramClass = new ProjectTeamVO();
		paramClass.setLeaderid(session.get("id"));
		paramClass.setTitle(getTitle());
		paramClass.setComp(getComp());
		paramClass.setStartdate(start);
		paramClass.setEnddate(end);
		paramClass.setRecmem(getRecmem());
		paramClass.setMaj(getMaj());
		paramClass.setCont(getCont());
		paramClass.setLoc(getLoc());
		paramClass.setSal(getSal());

		if (getStep() == 0) {

			return SUCCESS;
		} else { // step == 1
			sqlMapper.insert("content.insertProj", paramClass);

			UpdateTeamnoVO paramClass2 = new UpdateTeamnoVO();
			paramClass2.setId(session.get("id"));
			paramClass2.setAuth(Integer.parseInt(session.get("auth")));

			if (!(getTeamno() == null || getTeamno().equals("")))
				paramClass2.setTeamno1(Integer.parseInt(getTeamno()));

			sqlMapper.update("member.updateTeamNo", paramClass2);

			setStep(2);

			return SUCCESS;
		}
	}

	public String modify() throws Exception {
		setMainpage("projwrite");

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		if (getStep() == 0) {
			/* 폼 스탭 */
			setId(session.get("id"));
			setName(session.get("name"));
			setTeamno(getTeamno());

			resultClass = (ProjectTeamVO) sqlMapper.queryForObject("content.selectProj", Integer.parseInt(getTeamno()));

			return SUCCESS;

		} else {/* 수정 스텝 */
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

			Date start = format.parse(getStartdate() + " 00:00:00");
			Date end = format.parse(getEnddate() + " 23:59:59");

			paramClass = new ProjectTeamVO();
			paramClass.setLeaderid(session.get("id"));
			paramClass.setTitle(getTitle());
			paramClass.setComp(getComp());
			paramClass.setStartdate(start);
			paramClass.setEnddate(end);
			paramClass.setRecmem(getRecmem());
			paramClass.setMaj(getMaj());
			paramClass.setCont(getCont());
			paramClass.setLoc(getLoc());
			paramClass.setSal(getSal());

			sqlMapper.update("content.updateProj", paramClass);

			return "list";
		}
	}

	public String delete() throws Exception {
		paramClass = new ProjectTeamVO();
		paramClass.setLeaderid(getLeaderid());
		paramClass.setTeamno(getTeamno());

		sqlMapper.delete("content.deleteProj", paramClass);

		return SUCCESS;
	}
	
	public String mylist() throws Exception {
	      ActionContext context = ActionContext.getContext();
	      Map<String, String> session = (Map<String, String>) context.getSession();
	      setId(session.get("id"));
	      setName(session.get("name"));
	      
	      MemberVO tempClass1 = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));
	      
	      setTeamno(tempClass1.getTeamno1());
	      
	      System.out.println(tempClass1.getTeamno1());
	      
	      resultClass = (ProjectTeamVO) sqlMapper.queryForObject("content.selectProj", Integer.parseInt(teamno));
	      
	      list.add(resultClass);

	      setMainpage("myprojlist");
	      return SUCCESS;
	}
	
	public String myinfo() throws Exception {
		setMainpage("myprojinfo");
		resultClass = (ProjectTeamVO) sqlMapper.queryForObject("content.selectProj", Integer.parseInt(getTeamno()));
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(Integer.parseInt(session.get("auth")));
		return SUCCESS;
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

	public List<String> getLoclist() {
		return loclist;
	}

	public void setLoclist(List<String> loclist) {
		this.loclist = loclist;
	}

	public boolean isCheck() {
		return check;
	}

	public void setCheck(boolean check) {
		this.check = check;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}

	public List<ProjectTeamVO> getList() {
		return list;
	}

	public void setList(List<ProjectTeamVO> list) {
		this.list = list;
	}

	public String getTeamno() {
		return teamno;
	}

	public void setTeamno(String teamno) {
		this.teamno = teamno;
	}

	public ProjectTeamVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(ProjectTeamVO paramClass) {
		this.paramClass = paramClass;
	}

	public ProjectTeamVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(ProjectTeamVO resultClass) {
		this.resultClass = resultClass;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public String getId() {
		return id;
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

	public void setId(String id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getComp() {
		return comp;
	}

	public void setComp(String comp) {
		this.comp = comp;
	}

	public String getStartdate() {
		return startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getRecmem() {
		return recmem;
	}

	public void setRecmem(String recmem) {
		this.recmem = recmem;
	}

	public String getMaj() {
		return maj;
	}

	public void setMaj(String maj) {
		this.maj = maj;
	}

	public String getCont() {
		return cont;
	}

	public void setCont(String cont) {
		this.cont = cont;
	}

	public String getLoc() {
		return loc;
	}

	public void setLoc(String loc) {
		this.loc = loc;
	}

	public String getSal() {
		return sal;
	}

	public void setSal(String sal) {
		this.sal = sal;
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

	public String getLeaderid() {
		return leaderid;
	}

	public void setLeaderid(String leaderid) {
		this.leaderid = leaderid;
	}

	public static Reader getReader() {
		return reader;
	}

	public static void setReader(Reader reader) {
		ProjectTeamAction.reader = reader;
	}
	
	
}
