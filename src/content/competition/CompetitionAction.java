//2018-11-01 이준호
package content.competition;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import temp.PagingAction;

@SuppressWarnings({ "unchecked", "serial" })
public class CompetitionAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	private List<CompetitionVO> list = new ArrayList<CompetitionVO>(); // 전체 글 리스트
	private List<CompetitionVO> list1 = new ArrayList<CompetitionVO>(); // Top5 인기글 리스트
	private CompetitionVO paramClass;
	private CompetitionVO resultClass;
	private int no; // 글번호
	private String title; // 제목
	private String startdate; // 대회 시작일
	private Date regdate; // 글 등록일
	private String enddate; // 대회 마감일
	private String cont; // 글 내용
	private String contadd; // 글 추가 내용
	private int showlog; // 공개/비공개 구분
	private int hits; // 조회수
	private int step;
	private String mainpage;
	private boolean check;
	private String img; // 이미지 업로드 파일 이름
	private File upload; // 이미지 파일
	private String fileUploadPath = "..\\App\\SocialMap\\WebContent\\upload\\"; // 이미지 업로드 파일 경로
	Calendar today = Calendar.getInstance();
	
	private PagingAction page;
	private String pagingHtml;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 8;
	private int blockPage = 5;
	private int num = 0;
	
	private String id;
	private String name;

	public CompetitionAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	public String execute() throws Exception {
		setMainpage("complist");
		
		list = sqlMapper.queryForList("content.selectCompList");
		
		totalCount = list.size();

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "CompList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;

		list = list.subList(page.getStartCount(), lastCount);
		
		return SUCCESS;
	}
	
	public String best() throws Exception {
		list1 = sqlMapper.queryForList("content.selectCompBestlist");
		
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if(session.get("auth") != null && session.get("auth").equals("0")) {
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			return SUCCESS;
		}
	}

	public String info() throws Exception {
		setMainpage("compinfo");
		
		paramClass = new CompetitionVO();
		paramClass.setNo(getNo());

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		if(session.get("auth") != null && session.get("auth").equals("0")) {
			resultClass = (CompetitionVO) sqlMapper.queryForObject("content.selectComp", paramClass);
			return "admin";
		} else {
			setId(session.get("id"));
			setName(session.get("name"));
			sqlMapper.update("content.updateHits", paramClass);
			resultClass = (CompetitionVO) sqlMapper.queryForObject("content.selectComp", paramClass);
			return SUCCESS;
		}
	}

	public String write() throws Exception {
		System.out.println(System.getProperty("user.dir"));
		
		if (step == 1) {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

			Date start = null;
			Date end = null;

			paramClass = new CompetitionVO();

			if (!getStartdate().equals("")) {
				start = format.parse(getStartdate() + " 00:00:00");
			}
			if (!getEnddate().equals("")) {
				end = format.parse(getEnddate() + " 23:59:59");
			}
			if (isCheck() == true) {
				paramClass.setShowlog(1);
			} else {
				paramClass.setShowlog(0);
			}

			paramClass.setRegdate(today.getTime());
			paramClass.setTitle(getTitle());
			paramClass.setStartdate(start);
			paramClass.setEnddate(end);
			paramClass.setCont(getCont());
			paramClass.setContadd(getContadd());

			sqlMapper.insert("content.insertComp", paramClass);

			// 이미지 파일 업로드
			if (getUpload() != null) {
				resultClass = (CompetitionVO) sqlMapper.queryForObject("content.selectLastNo");

				File destFile = new File(fileUploadPath + "file_" + resultClass.getNo() + ".PNG");
				FileUtils.copyFile(getUpload(), destFile);

				paramClass.setNo(resultClass.getNo());
				paramClass.setImg("file_" + resultClass.getNo() + ".PNG");

				sqlMapper.update("content.updateFile", paramClass);
			}
			setStep(2);

			return SUCCESS;
		} else {
			return SUCCESS;
		}
	}

	public String delete() throws Exception {
		File deleteFile = new File(fileUploadPath + "file_" + getNo() + ".PNG");

		deleteFile.delete();

		sqlMapper.delete("content.deleteComp", getNo());

		return SUCCESS;
	}

	public String modify() throws Exception {
		paramClass = new CompetitionVO();

		if (step == 1) {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			Date start = null;
			Date end = null;

			if (!getStartdate().equals("")) {
				start = format.parse(getStartdate() + " 00:00:00");
			}
			if (!getEnddate().equals("")) {
				end = format.parse(getEnddate() + " 23:59:59");
			}
			if (isCheck() == true) {
				paramClass.setShowlog(1);
			} else {
				paramClass.setShowlog(0);
			}

			paramClass.setRegdate(today.getTime());
			paramClass.setTitle(getTitle());
			paramClass.setStartdate(start);
			paramClass.setEnddate(end);
			paramClass.setCont(getCont());
			paramClass.setContadd(getContadd());
			paramClass.setNo(getNo());

			sqlMapper.update("content.updateComp", paramClass);

			if (getUpload() != null) { // 이미지 파일 업로드
				File destFile = new File(fileUploadPath + "file_" + getNo() + ".PNG");
				FileUtils.copyFile(getUpload(), destFile);

				paramClass.setImg("file_" + getNo() + ".PNG");

				sqlMapper.update("content.updateFile", paramClass);
			}

			setStep(2);

			return SUCCESS;
		} else {
			paramClass.setNo(getNo());

			resultClass = (CompetitionVO) sqlMapper.queryForObject("content.selectComp", paramClass);

			return SUCCESS;
		}
	}

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}

	public List<CompetitionVO> getList() {
		return list;
	}

	public void setList(List<CompetitionVO> list) {
		this.list = list;
	}

	public CompetitionVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(CompetitionVO paramClass) {
		this.paramClass = paramClass;
	}

	public CompetitionVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(CompetitionVO resultClass) {
		this.resultClass = resultClass;
	}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public String getCont() {
		return cont;
	}

	public void setCont(String cont) {
		this.cont = cont;
	}

	public String getContadd() {
		return contadd;
	}

	public void setContadd(String contadd) {
		this.contadd = contadd;
	}

	public int getHits() {
		return hits;
	}

	public void setHits(int hits) {
		this.hits = hits;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public Calendar getToday() {
		return today;
	}

	public void setToday(Calendar today) {
		this.today = today;
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

	public int getShowlog() {
		return showlog;
	}

	public void setShowlog(int showlog) {
		this.showlog = showlog;
	}

	public boolean isCheck() {
		return check;
	}

	public void setCheck(boolean check) {
		this.check = check;
	}

	public List<CompetitionVO> getList1() {
		return list1;
	}

	public void setList1(List<CompetitionVO> list1) {
		this.list1 = list1;
	}

	public File getUpload() {
		return upload;
	}

	public void setUpload(File upload) {
		this.upload = upload;
	}

	public String getFileUploadPath() {
		return fileUploadPath;
	}

	public void setFileUploadPath(String fileUploadPath) {
		this.fileUploadPath = fileUploadPath;
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

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
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