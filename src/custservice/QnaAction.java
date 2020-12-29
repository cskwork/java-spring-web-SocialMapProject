package custservice;

import java.io.IOException;
import java.io.Reader;
import java.sql.Timestamp;
import java.util.ArrayList;
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
public class QnaAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	private QnaVO paramClass;
	private QnaVO resultClass;

	private int num = 0;
	private String mainpage;

	// list
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private PagingAction page;

	private List<QnaVO> list = new ArrayList<QnaVO>();
	private int searchnum;
	private String search;

	// write
	public int step = 0;
	private String id; // 작성자 ID
	private int qalog; // Q(0)/A(1)
	private String title; // 제목
	private String cont; // 내용
	private int no; // 글번호
	private Date RegDate; // 등록일
	private String name;

	// info
	private QnaVO resultClass1;
	private QnaVO resultClass2;

	public QnaAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	@Override
	public String execute() throws Exception {
		setMainpage("qnalist");

		//세션 비교
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if(session.get("auth") != null && session.get("auth").equals("0")) { //admin
			
			//검색
			if (search != null) {
				if (searchnum == 0) {
					list = sqlMapper.queryForList("cust.selectQnaTitle", "%" + getSearch() + "%");
				} else if (searchnum == 1) {
					list = sqlMapper.queryForList("cust.selectQnaId", "%" + getSearch() + "%");
				}
			} else {
				list = sqlMapper.queryForList("cust.selectQnaAdminList");
			}
			
			//페이징
			totalCount = list.size();

			page = new PagingAction(currentPage, totalCount, blockCount, blockPage, searchnum, "QnaList", getSearch());
			pagingHtml = page.getPagingHtml().toString();

			int lastCount = totalCount;

			if (page.getEndCount() < totalCount)
				lastCount = page.getEndCount() + 1;

			list = list.subList(page.getStartCount(), lastCount);
			
			return "admin";
		} else {  //비 회원, 팀장, 팀원
			setId(session.get("id"));
			setName(session.get("name"));
			
			//검색
			if (search != null) {

				if (searchnum == 0) {
					list = sqlMapper.queryForList("cust.selectQnaTitle", "%" + getSearch() + "%");
				} else if (searchnum == 1) {
					list = sqlMapper.queryForList("cust.selectQnaId", "%" + getSearch() + "%");
				}
			} else {
				list = sqlMapper.queryForList("cust.selectQnaList", getId());
			}
			
			//페이징
			totalCount = list.size();

			page = new PagingAction(currentPage, totalCount, blockCount, blockPage, searchnum, "QnaList", getSearch());
			pagingHtml = page.getPagingHtml().toString();

			int lastCount = totalCount;

			if (page.getEndCount() < totalCount)
				lastCount = page.getEndCount() + 1;

			list = list.subList(page.getStartCount(), lastCount);
			
			return SUCCESS;
		}
	}

	public String write() throws Exception {
		setMainpage("qnawrite");

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		if (getStep() == 0) {
			setId(session.get("id"));
			setName(session.get("name"));
			return SUCCESS;
		} else {
			paramClass = new QnaVO();
			paramClass.setId(session.get("id"));
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setRegdate(new Timestamp(System.currentTimeMillis()));

			sqlMapper.insert("cust.insertQna", paramClass);

			/* setStep(2); */

			return "list";
		}
	}

	public String info() throws Exception {
		setMainpage("qnainfo");
		paramClass = new QnaVO();

		//세션 비교
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if(session.get("auth") != null && session.get("auth").equals("0")) {
			list = sqlMapper.queryForList("cust.selectQna", getNo());
			resultClass1 = list.get(0);
			if (list.size() > 1) {
				resultClass2 = list.get(1);
			}
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));

			list = sqlMapper.queryForList("cust.selectQna", getNo());
			resultClass1 = list.get(0);
			if (list.size() > 1) {
				resultClass2 = list.get(1);
			}
			return SUCCESS;
		}
	}

	public String delete() throws Exception {
		paramClass = new QnaVO();
		paramClass.setNo(getNo());
		paramClass.setQalog(getQalog());

		sqlMapper.delete("cust.deleteQna", paramClass);

		return SUCCESS;
	}

	public String modify() throws Exception {
		setMainpage("qnawrite");
		
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		if (getStep() == 0) {
			/* 폼 스탭 */
			setId(session.get("id"));
			setName(session.get("name"));
			list = sqlMapper.queryForList("cust.selectQna", getNo());
			resultClass1 = list.get(0);

			return SUCCESS;

		} else {
			/* 수정 스텝 */
			paramClass = new QnaVO();
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setNo(getNo());
			sqlMapper.update("cust.updateQna", paramClass);
			return "list";
		}
	}
	
	public String adminwrite() throws Exception {
		if (getStep() == 0) {
			list = sqlMapper.queryForList("cust.selectQna", getNo());
			return SUCCESS;
		} else {
			paramClass = new QnaVO();
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setNo(getNo());
			paramClass.setRegdate(new Timestamp(System.currentTimeMillis()));
			
			sqlMapper.insert("cust.insertAdminQna", paramClass);
			setStep(2);
			return SUCCESS;
		}
	}
	
	public String adminmodify() throws Exception {
		if (getStep() == 0) {
			list = sqlMapper.queryForList("cust.selectQna", getNo());
			resultClass2 = list.get(1);
			return SUCCESS;
		} else {
			paramClass = new QnaVO();
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setNo(getNo());
			sqlMapper.update("cust.updateAdminQna", paramClass);
			
			return SUCCESS;
		}
	}

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}

	public QnaVO getResultClass1() {
		return resultClass1;
	}

	public void setResultClass1(QnaVO resultClass1) {
		this.resultClass1 = resultClass1;
	}

	public QnaVO getResultClass2() {
		return resultClass2;
	}

	public void setResultClass2(QnaVO resultClass2) {
		this.resultClass2 = resultClass2;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public QnaVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(QnaVO paramClass) {
		this.paramClass = paramClass;
	}

	public QnaVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(QnaVO resultClass) {
		this.resultClass = resultClass;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
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

	public java.util.List<QnaVO> getList() {
		return list;
	}

	public void setList(java.util.List<QnaVO> list) {
		this.list = list;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getQalog() {
		return qalog;
	}

	public void setQalog(int qalog) {
		this.qalog = qalog;
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

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public Date getRegDate() {
		return RegDate;
	}

	public void setRegDate(Date regDate) {
		RegDate = regDate;
	}

	public int getSearchnum() {
		return searchnum;
	}

	public void setSearchnum(int searchnum) {
		this.searchnum = searchnum;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}