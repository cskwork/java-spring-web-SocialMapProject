package member;

import java.io.IOException;
import java.io.Reader;
import java.util.Calendar;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings({ "serial", "unchecked" })
public class MemberAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	// 페이지 관련
	private String mainpage;

	// 로그인 관련
	private MemberVO paramClass; // 파라미터를 저장할 객체
	private MemberVO resultClass;
	private String id; // 회원찾기, 회원가입 에서도 씀
	private String pwd; // 회원가입 에서도 씀
	private String check;

	// 회원찾기 관련
	private int step = 0;
	private String find = "id";
	private String name; // 회원가입 에서도 씀
	private String birth; // 회원가입에서도 씀
	private String email; // 회원가입에서도 씀

	// 회원가입 관련
	private String gen;
	private String auth;
	private String teamno1;
	private String teamno2;
	private String teamno3;
	private String addr;
	private String maj;
	private String exp;
	private Calendar joindate = Calendar.getInstance();
	
	private int checkdate;

	
	// 생성자
	public MemberAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml"); // sqlMapConfig.xml 파일의 설정내용을 가져온다.
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader); // sqlMapConfig.xml의 내용을 적용한 sqlMapper 객체 생성.
		reader.close();
	}	
	// 홈페이지
	public String home() throws Exception {
	      ActionContext context = ActionContext.getContext();
	      Map<String, String> session = (Map<String, String>) context.getSession();
	      
	      setId(session.get("id"));
	      setName(session.get("name"));
	      setAuth(session.get("auth"));
	      	      
	      /*//checkdate=(int) sqlMapper.queryForObject("member.checkRateDate",getId());
	      if(sqlMapper.queryForObject("member.checkRateDate",getId()) == null){
	            return SUCCESS;
	      }
	      else {
	          checkdate=(int) sqlMapper.queryForObject("member.checkRateDate",getId());
	      }*/
	      
	      setMainpage("main");
	      
	      return SUCCESS;
	  }
	
	// 아이디 찾기
		public String confirmid() throws Exception {
			resultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", getId());

			if (resultClass == null || resultClass.getId().equals("")) {
				check = "0";
			} else {
				check = "1";
			}

			return SUCCESS;
		}
	
	// 로그인(= 회원 비교 쿼리문)
	@Override
	public String execute() throws Exception {
		if (getCheck() == null || getCheck().equals("")) {

			setMainpage("login");
			return SUCCESS;
		} else {
			paramClass = new MemberVO();
			paramClass.setId(getId());

			resultClass = (MemberVO) sqlMapper.queryForObject("member.loginMember", getId());

			// 1: 로그인 허가, 2: 패스워드 틀림, 3: 아이디 없음
			if (resultClass == null || resultClass.getPwd().equals("")) {
				check = "3";
			} else {
				if (resultClass.getPwd().equals(getPwd())) {
					ActionContext context = ActionContext.getContext();
					Map<String, String> session = (Map<String, String>) context.getSession();
					
					if(resultClass.getAuth().equals("0")) {
						session.put("auth", resultClass.getAuth());
						context.setSession(session);
						
						return "admin";
					} else {
						session.put("id", getId());
						session.put("name", resultClass.getName());
						session.put("auth", resultClass.getAuth());
						
						context.setSession(session);
						
						setId(session.get("id"));
						setName(session.get("name"));
						setAuth(session.get("auth"));
	
						setMainpage("main");
						
						return SUCCESS;
					}
				} else {
					setId("");
					check = "2";
				}
			}
			setMainpage("login");
			return SUCCESS;
		}
	}

	// 로그아웃
	public String logout() throws Exception {
		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		session.remove("id");
		session.remove("name");
		session.remove("auth");
		context.setSession(session);

		setId("");

		return SUCCESS;
	}

	// 회원가입(= 회원 정보 입력 쿼리문)
	public String signup() throws Exception {
		if (getStep() == 0) {
			setMainpage("signup");
		} else {
			paramClass = new MemberVO();

			paramClass.setId(getId()); //
			paramClass.setPwd(getPwd()); //
			paramClass.setName(getName()); //
			paramClass.setBirth(getBirth()); //
			paramClass.setGen(getGen()); //
			paramClass.setEmail(getEmail()); //
			paramClass.setAddr(getAddr()); //
			paramClass.setAuth(getAuth()); //
			paramClass.setMaj(getMaj()); //
			paramClass.setExp(getExp()); //

			sqlMapper.insert("member.insertMember", paramClass);
					
			ActionContext context = ActionContext.getContext();
			Map<String, String> session = (Map<String, String>) context.getSession();

			setId(session.get("id"));
			setName(session.get("name"));
			setAuth(session.get("auth"));
			
			setMainpage("login");
		}
		return SUCCESS;
	}

	// 회원 찾기(= 회원 아이디 찾기 쿼리문)
	public String find() throws Exception {
		if (getStep() == 0) {
			if (getFind().equals("id")) {
				setMainpage("findid");
			} else if (getFind().equals("pwd")) {
				setMainpage("findpwd");
			}
		} else {
			paramClass = new MemberVO();

			paramClass.setId(getId());
			paramClass.setName(getName());
			paramClass.setEmail(getEmail());
			paramClass.setEmail(getEmail());
			paramClass.setBirth(getBirth());

			String[] sql = { "member.findIdMember", "member.findPwdMember" };

			resultClass = (MemberVO) sqlMapper.queryForObject(sql[getStep() - 1], paramClass);

			if (resultClass == null || resultClass.getPwd().equals("")) {
				check = "2";

				// 정보 불일치
				if (getStep() == 1) {
					setMainpage("findid");
				} else if (getStep() == 2) {
					setMainpage("findpwd");
				}
			} else {
				check = "1";
				// 정보 일치
				setMainpage("findresult");
			}
		}
		return SUCCESS;
	}
	
	

	// getter, setter
	public int getCheckdate() {
		return checkdate;
	}
	public void setCheckdate(int checkdate) {
		this.checkdate = checkdate;
	}
	
	
	public String getFind() {
		return find;
	}

	public void setFind(String find) {
		this.find = find;
	}

	public MemberVO getParamClass() {

		return paramClass;
	}

	public void setParamClass(MemberVO paramClass) {
		this.paramClass = paramClass;
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

	public String getCheck() {
		return check;
	}

	public void setCheck(String check) {
		this.check = check;
	}

	public MemberVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(MemberVO resultClass) {
		this.resultClass = resultClass;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getGen() {
		return gen;
	}

	public void setGen(String gen) {
		this.gen = gen;
	}

	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}

	public String getTeamno1() {
		return teamno1;
	}

	public void setTeamno1(String teamno1) {
		this.teamno1 = teamno1;
	}
	
	public String getTeamno2() {
		return teamno2;
	}
	public void setTeamno2(String teamno2) {
		this.teamno2 = teamno2;
	}
	public String getTeamno3() {
		return teamno3;
	}
	public void setTeamno3(String teamno3) {
		this.teamno3 = teamno3;
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

	public Calendar getJoindate() {
		return joindate;
	}

	public void setJoindate(Calendar joindate) {
		this.joindate = joindate;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}
}
