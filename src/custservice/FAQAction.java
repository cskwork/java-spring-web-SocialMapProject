package custservice;

import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import temp.PagingAction;

@SuppressWarnings({ "unchecked", "serial" })
public class FAQAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	private CustserviceVO paramClass;
	private CustserviceVO resultClass;
	
	private String mainpage;

	private List<CustserviceVO> list = new ArrayList<CustserviceVO>();

	private int custlog;
	private String title;
	private String cont;
	private Date regdate;
	private int no;
	Calendar today = Calendar.getInstance();
	private int step;

	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private PagingAction page;
	private int num = 0;
	
	private String id;
	private String name;
	
	private String search;

	public FAQAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	public String write() throws Exception {
		if (step == 1) {
			paramClass = new CustserviceVO();
			paramClass.setCustlog(getCustlog());
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setRegdate(today.getTime());
			
			sqlMapper.insert("cust.insertCust", paramClass);
			
			setStep(2);
			
			return SUCCESS;
		} else {
			return SUCCESS;
		}
	}

	// FAQ list
	public String execute() throws Exception {
		setMainpage("faqlist");
		
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if(search!=null) {
			list = sqlMapper.queryForList("cust.searchfaq", "%"+getSearch()+"%");
		} else {
			list = sqlMapper.queryForList("cust.selectAllCust", 1);
		}
		
		totalCount = list.size();
		
		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "FAQList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;

		list = list.subList(page.getStartCount(), lastCount);

		if(session.get("auth") != null && session.get("auth").equals("0")) {
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			return SUCCESS;
		}
	}
	
	public String info() throws Exception {
		setMainpage("faqinfo");
		
		paramClass = new CustserviceVO();
		paramClass.setCustlog(getCustlog());
		paramClass.setNo(getNo());

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		if(session.get("auth") != null && session.get("auth").equals("0")) {
			resultClass = (CustserviceVO) sqlMapper.queryForObject("cust.selectOneCust", paramClass);
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			sqlMapper.update("cust.updateHits", paramClass);
			resultClass = (CustserviceVO) sqlMapper.queryForObject("cust.selectOneCust", paramClass);
			return SUCCESS;
		}
	}
	
	public String modify() throws Exception {
		paramClass = new CustserviceVO();
		if (step == 1) {
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setNo(getNo());
			paramClass.setCustlog(getCustlog());
			
			sqlMapper.update("cust.updateCust", paramClass);
			
			setStep(2);
			return SUCCESS;
		} else {
			paramClass.setNo(getNo());
			paramClass.setCustlog(getCustlog());
			
			resultClass = (CustserviceVO) sqlMapper.queryForObject("cust.selectOneCust", paramClass);
			
			return SUCCESS;
		}
	}
	
	public String delete() throws Exception {
		paramClass = new CustserviceVO();
		paramClass.setNo(getNo());
		paramClass.setCustlog(getCustlog());
		sqlMapper.delete("cust.deleteCust", paramClass);
		return SUCCESS;
	}

	public CustserviceVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(CustserviceVO paramClass) {
		this.paramClass = paramClass;
	}

	public CustserviceVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(CustserviceVO resultClass) {
		this.resultClass = resultClass;
	}

	public int getCustlog() {
		return custlog;
	}

	public void setCustlog(int custlog) {
		this.custlog = custlog;
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

	public List<CustserviceVO> getlist() {
		return list;
	}

	public void setlist(List<CustserviceVO> list) {
		this.list = list;
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

	public PagingAction getPage() {
		return page;
	}

	public void setPage(PagingAction page) {
		this.page = page;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public Calendar getToday() {
		return today;
	}

	public void setToday(Calendar today) {
		this.today = today;
	}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public List<CustserviceVO> getList() {
		return list;
	}

	public void setList(List<CustserviceVO> list) {
		this.list = list;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
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

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}	
}