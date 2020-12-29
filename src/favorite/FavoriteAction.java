package favorite;

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

import content.project.ProjectTeamVO;
import content.specreg.SpecRegVO;
import temp.PagingAction;

@SuppressWarnings({ "unchecked", "serial" })
public class FavoriteAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	private String mainpage;

	private SpecRegVO paramClass;
	private SpecRegVO resultClass;
	private ProjectTeamVO pparamClass;
	private ProjectTeamVO presultClass;
	private FavoriteVO fparamClass;
	private FavoriteVO fresultClass;

	private List<SpecRegVO> favlist = new ArrayList<SpecRegVO>();
	private PagingAction page;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;

	private int artlog;

	private String id;
	private String name;
	private Timestamp regdate;
	private String exp;
	private String spec;
	private String projexp;
	private String contadd;
	private int showlog;
	private String leaderid;

	private int teamno;
	
	private String auth;

	public FavoriteAction() throws Exception {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	public String favspecList() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		favlist = sqlMapper.queryForList("favorite.selectFavSpec",session.get("id"));
		
		//System.out.println("size : " + favlist.size());

		totalCount = favlist.size();

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "favlist", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount) {
			lastCount = page.getEndCount() + 1;
		}

		favlist = favlist.subList(page.getStartCount(), lastCount);

		//setLeaderid(session.get("id"));
		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));

		setMainpage("favspeclist");

		return SUCCESS;
	}

	public String favSpec() throws Exception {
//		ActionContext context = ActionContext.getContext();
//		Map<String, String> session = (Map<String, String>) context.getSession();
//
//		MemberVO check;
//		check = (MemberVO) sqlMapper.queryForObject("loginMember", session.get("leaderid"));
//
//		if (check.getAuth().equals("1"));
		
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		setLeaderid(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));


		fparamClass = new FavoriteVO();
		fparamClass.setId(getId());
		fparamClass.setLeaderid(session.get("id"));

		favlist = sqlMapper.queryForList("favorite.checkinsertFavSpec", fparamClass);


		if (favlist.size() > 0) {
			return ERROR;
		} else {
			sqlMapper.insert("favorite.insertFavSpec", fparamClass);

			return SUCCESS;
		}
	}

	public String specinfo() throws Exception {
		resultClass = (SpecRegVO) sqlMapper.queryForObject("content.selectSpec", getId());

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		setLeaderid(session.get("id"));
		
		setName(session.get("name"));
		setAuth(session.get("auth"));
		
		setMainpage("favspecinfo");

		return SUCCESS;
	}

	public String delSpec() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		setLeaderid(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));

		fparamClass = new FavoriteVO();
		
		fparamClass.setId(getId());
		fparamClass.setLeaderid(session.get("id"));

		sqlMapper.delete("favorite.deleteFavSpec", fparamClass);
		
		System.out.println("∆¿¿ÂId : "+getLeaderid());

		/*ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		setId(session.get("id"));
		setName(session.get("name"));*/

		return SUCCESS;
	}

	public String favprojList() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		setTeamno(getTeamno());
		
		favlist = sqlMapper.queryForList("favorite.selectFavProj",session.get("id"));

		totalCount = favlist.size();

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "FAQList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount) {
			lastCount = page.getEndCount() + 1;
		}

		favlist = favlist.subList(page.getStartCount(), lastCount);

		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));

		setMainpage("favprojlist");

		return SUCCESS;
	}

	public String favProj() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));

		fparamClass = new FavoriteVO();
		fparamClass.setTeamno(getTeamno());
		fparamClass.setId(session.get("id"));

		favlist = sqlMapper.queryForList("favorite.checkinsertFavProj", fparamClass);

		if (favlist.size() > 0) {
			return ERROR;
		} else {
			System.out.println(getLeaderid());
			fresultClass = (FavoriteVO) sqlMapper.insert("favorite.insertFavProj", fparamClass);

			return SUCCESS;
		}
	}

	public String projinfo() throws Exception {
		presultClass = (ProjectTeamVO) sqlMapper.queryForObject("content.selectProj", getTeamno());
		
		setMainpage("favprojinfo");

		return SUCCESS;
	}

	public String delProj() throws Exception {
		fparamClass = new FavoriteVO();

		/* fparamClass.setId(getId()); */
		fparamClass.setTeamno(getTeamno());

		sqlMapper.delete("favorite.deleteFavProj", fparamClass);

		return SUCCESS;
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

	public List<SpecRegVO> getFavlist() {
		return favlist;
	}

	public void setFavlist(List<SpecRegVO> favlist) {
		this.favlist = favlist;
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

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Timestamp getRegdate() {
		return regdate;
	}

	public void setRegdate(Timestamp regdate) {
		this.regdate = regdate;
	}

	public String getExp() {
		return exp;
	}

	public void setExp(String exp) {
		this.exp = exp;
	}

	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}

	public String getProjexp() {
		return projexp;
	}

	public void setProjexp(String projexp) {
		this.projexp = projexp;
	}

	public String getContadd() {
		return contadd;
	}

	public void setContadd(String contadd) {
		this.contadd = contadd;
	}

	public int getShowlog() {
		return showlog;
	}

	public void setShowlog(int showlog) {
		this.showlog = showlog;
	}

	public int getArtlog() {
		return artlog;
	}

	public void setArtlog(int artlog) {
		this.artlog = artlog;
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

	public FavoriteVO getFparamClass() {
		return fparamClass;
	}

	public void setFparamClass(FavoriteVO fparamClass) {
		this.fparamClass = fparamClass;
	}

	public FavoriteVO getFresultClass() {
		return fresultClass;
	}

	public void setFresultClass(FavoriteVO fresultClass) {
		this.fresultClass = fresultClass;
	}

	public String getLeaderid() {
		return leaderid;
	}

	public void setLeaderid(String leaderid) {
		this.leaderid = leaderid;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public int getTeamno() {
		return teamno;
	}

	public void setTeamno(int teamno) {
		this.teamno = teamno;
	}

	public ProjectTeamVO getPparamClass() {
		return pparamClass;
	}

	public void setPparamClass(ProjectTeamVO pparamClass) {
		this.pparamClass = pparamClass;
	}

	public ProjectTeamVO getPresultClass() {
		return presultClass;
	}

	public void setPresultClass(ProjectTeamVO presultClass) {
		this.presultClass = presultClass;
	}

	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}
	
}