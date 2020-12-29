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

	// ����Ʈ ����
	private List<MsgVO> list;
	private String sendid; // ����� ����
	private String getid; // ����� ����
	private String id;

	private int check = 0;
	private PagingAction page;
	private int no;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;

	// ���� ����
	private int step = 0;
	private String title;
	private String cont;
	private Timestamp sendtime;
	private String msglog = "3";
	
	private String mainpage;

	public MsgAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml"); // sqlMapConfig.xml ������ ���������� �����´�.
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader); // sqlMapConfig.xml�� ������ ������ sqlMapper ��ü ����.
		reader.close();
	}

	@Override
	public String execute() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass = new MsgVO();

		if (getSendid() == null || getSendid().equals("")) {
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
			paramClass.setSendid(getSendid());
			paramClass.setGetid(getGetid());
			paramClass.setTitle(getTitle());
			paramClass.setCont(getCont());
			paramClass.setSendtime(new Timestamp(System.currentTimeMillis()));

			sqlMapper.insert("msg.MsgWrite", paramClass);
			
			return SUCCESS;
		}
	}
	
	public String delete() throws Exception {
	      paramClass = new MsgVO();
	      paramClass.setNo(getNo());
	      
	      System.out.println("--������ �޼��� No:"+getNo());
	      
	      sqlMapper.delete("msg.MsgDelete",paramClass);
	      
	      return SUCCESS;
	   }

	public String info() throws Exception {
		setCheck(getCheck());

		resultClass = (MsgVO) sqlMapper.queryForObject("msg.MsgInfo", getNo());
		return SUCCESS;
	}
	
	public String spechope() throws Exception {	
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		paramClass = new MsgVO();
		paramClass.setSendid(session.get("id")); // �α��� ���� ���̵�
		paramClass.setGetid(getid); // ���忡�� ������ ���̵�
		paramClass.setTitle("�츮 ������Ʈ�� ���� ���ֽñ� ����մϴ�.");
		paramClass.setCont("���� ������Ʈ�� ������ �ֱ� ����մϴ�. �������������� ���� ���θ� �������ּ���.");
		paramClass.setSendtime(new Timestamp(System.currentTimeMillis()));

		//�˸����� �߼�
		sqlMapper.insert("msg.MsgWrite", paramClass);
		
		//���������� - ������Ʈ ���� ���� �߰�
		paramClass2 = new HopeListVO();
		
		paramClass2.setSendid(session.get("id")); // �α��� ���� ���̵�
		paramClass2.setGetid(getid); // ���忡�� ������ ���̵�
		paramClass2.setRegdate(new Timestamp(System.currentTimeMillis()));
		paramClass2.setLog(0); // 0�̸� ������ �������� ����
		
		sqlMapper.insert("hopelist.insertHopeList", paramClass2);
		
		setMainpage("sendcomplete");
		
		return SUCCESS;
	}
	
	public String projhope() throws Exception {	
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();
		
		//System.out.println("------" + getid);
		//System.out.println("------" + session.get("id"));
		
		paramClass = new MsgVO();
		paramClass.setSendid(session.get("id")); // �α��� ���� ���̵�
		paramClass.setGetid(getid); // ������ ������Ʈ ���� ���̵�
		paramClass.setTitle("������Ʈ�� ������ ����մϴ�.");
		paramClass.setCont("�������������� ���� ���θ� �������ּ���.");
		paramClass.setSendtime(new Timestamp(System.currentTimeMillis()));
		
		//System.out.println("----------------");

		//�˸����� �߼�
		sqlMapper.insert("msg.MsgWrite", paramClass);
		
		//���������� - ������Ʈ ���� ���� �߰�
		paramClass2 = new HopeListVO();
		
		paramClass2.setSendid(session.get("id")); // �α��� ���� ���̵�
		paramClass2.setGetid(getid); // ���忡�� ������ ���̵�
		paramClass2.setRegdate(new Timestamp(System.currentTimeMillis()));
		paramClass2.setLog(1); // 0�̸� ������ �������� ����
		
		sqlMapper.insert("hopelist.insertHopeList", paramClass2);
		
		setMainpage("projlist");
		
		return SUCCESS;
	}

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
