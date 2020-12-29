package mypage;

import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import member.MemberVO;

@SuppressWarnings({ "unchecked", "serial" })
public class MyPageAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	private MemberVO paramClass;
	private MemberVO resultClass;

	private String mainpage;

	private String id;

	private String pwd;
	private String name;
	private String gen;
	private String birth;
	private String email;
	private String addr;
	private String maj;
	private String exp;
	
	private String auth;

	public MyPageAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	public String form() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		resultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));
		
		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));
		
		System.out.println(resultClass.getEmail());
		setMainpage("membermodify");
		
		return SUCCESS;
	}

	public String info() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		resultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));

		setId(session.get("id"));
		setName(session.get("name"));
		setAuth(session.get("auth"));
		
		setMainpage("memberinfo");
		
		return SUCCESS;
	}

	public String modify() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass = new MemberVO();
		paramClass.setId(session.get("id"));
		paramClass.setName(session.get("name"));
		paramClass.setAuth(session.get("auth"));

		sqlMapper.queryForObject("member.loginMember", session.get("id"));

		paramClass.setPwd(getPwd());
		paramClass.setName(getName());
		paramClass.setGen(getGen());
		paramClass.setBirth(getBirth());
		paramClass.setEmail(getEmail());
		paramClass.setAddr(getAddr());
		paramClass.setMaj(getMaj());
		paramClass.setExp(getExp());

		sqlMapper.update("member.updateMember", paramClass);

		resultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));

		setId(session.get("id"));
		setName(session.get("name"));
		
		return SUCCESS;
	}

	public String delete() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass = new MemberVO();
		/*paramClass.setId(session.get("id"));*/

		resultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"));

		paramClass.setPwd(resultClass.getPwd());

		sqlMapper.update("member.deleteMember", paramClass);
		
		System.out.println("!!!!!!");
		
		setMainpage("main");

		return SUCCESS;
	}
	

	public String checkPwd() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass = new MemberVO();
		paramClass.setId(session.get("id"));
		paramClass.setPwd(getPwd());
		
		resultClass=(MemberVO) sqlMapper.queryForObject("member.checkPwd", paramClass);
		
		if (resultClass == null || resultClass.getPwd().equals("")) {
			return ERROR;
		}
		
		return SUCCESS;
	}
	

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}

	public MemberVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(MemberVO paramClass) {
		this.paramClass = paramClass;
	}

	public MemberVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(MemberVO resultClass) {
		this.resultClass = resultClass;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getGen() {
		return gen;
	}

	public void setGen(String gen) {
		this.gen = gen;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getMaj() {
		return maj;
	}

	public void setMaj(String maj) {
		this.maj = maj;
	}

	public String getExp() {
		return exp;
	}

	public void setExp(String exp) {
		this.exp = exp;
	}

	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}
	
}
