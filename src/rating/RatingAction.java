package rating;

import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import member.MemberVO;
import temp.PagingAction;
import content.project.ProjectTeamVO;

@SuppressWarnings({ "serial", "unchecked" })
public class RatingAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;

	private RatingVO paramClass;
	private RatingVO resultClass;

	private String title;
	// 리스트 관련
	private List<RatingVO> list;
	private String sendid; // 대상자
	private String getid; // 작성자
	private int rate;
	private int teamexp;
	private int compexp;

	private PagingAction page;
	private int currentPage = 1;
	private int totalCount;
	private int blockCount = 10;
	private int blockPage = 5;
	private String pagingHtml;
	private int num = 0;

	// 쓰기 관련
	private int step = 0;
	private Timestamp ratingregdate;
	private String reputation;

	private List<RatingVO> memberlist;

	// member --값
	private String id;
	private int teamno;

	private List<RatingVO> membvalue;

	// 별 임시변수
	int star_tmp = 0;
	private int stars;

	// 동시 폼 테스트 -- (스타 제외)
	private List<RatingVO> rating;

	public RatingAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml"); // sqlMapConfig.xml 파일의 설정내용을 가져온다.
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader); // sqlMapConfig.xml의 내용을 적용한 sqlMapper 객체 생성.
		reader.close();
	}

	@Override
	/* 평점 보기 (세션 맵핑,리스트출력쿼리,페이지표시) */
	public String execute() throws Exception {
		paramClass = new RatingVO();

		ActionContext context = ActionContext.getContext();
		Map<String, String> session = (Map<String, String>) context.getSession();

		paramClass.setSendid(session.get("id"));

		list = sqlMapper.queryForList("rating.RatingList", paramClass);

		totalCount = list.size();
		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "SpecList", "");

		page = new PagingAction(currentPage, totalCount, blockCount, blockPage, num, "RatingList", "");
		pagingHtml = page.getPagingHtml().toString();

		int lastCount = totalCount;

		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;

		list = list.subList(page.getStartCount(), lastCount);

		return SUCCESS;
	}

	private MemberVO paramClass2;

	// 평점 쓰기
	public String write() throws Exception {
		if (getStep() == 0) {
			ActionContext context = ActionContext.getContext();
			Map<String, String> session = (Map<String, String>) context.getSession();

			paramClass2 = new MemberVO();
			paramClass2.setId(session.get("id"));
			paramClass2.setTeamno1(((MemberVO) sqlMapper.queryForObject("member.loginMember", session.get("id"))).getTeamno1());

			List<MemberVO> templist = (List<MemberVO>) sqlMapper.queryForList("member.ratingMember", paramClass2);

			list = new ArrayList<RatingVO>();

			for (int i = 0; i < templist.size(); i++) {
				RatingVO tempClass = new RatingVO();
				ProjectTeamVO pjt;

				pjt = (ProjectTeamVO) sqlMapper.queryForObject("content.selectProj",
						Integer.parseInt(templist.get(i).getTeamno1()));

				tempClass.setGetid(templist.get(i).getId());
				tempClass.setSendid(paramClass2.getId());
				tempClass.setTitle(pjt.getTitle());
				tempClass.setTeamexp(Integer.parseInt(templist.get(i).getTeamno1()));

				list.add(tempClass);
			}
			return "write";
		} else if (getStep() == 1) {
			Timestamp tmp = new Timestamp(System.currentTimeMillis());

			for (RatingVO vo : list) {
				vo.setRatingregdate(tmp);

				sqlMapper.insert("rating.RatingWrite", vo);
			}
			return SUCCESS;
		} else {
			return SUCCESS;
		}
	}

	// 테스트
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public List<RatingVO> getRating() {
		return rating;
	}

	public void setRating(List<RatingVO> rating) {
		this.rating = rating;
	}

	public List<RatingVO> getMembvalue() {
		return membvalue;
	}

	public void setMembvalue(List<RatingVO> membvalue) {
		this.membvalue = membvalue;
	}

	public List<RatingVO> getMemberlist() {
		return memberlist;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getTeamno() {
		return teamno;
	}

	public void setTeamno(int teamno) {
		this.teamno = teamno;
	}

	public void setMemberlist(List<RatingVO> memberlist) {
		this.memberlist = memberlist;
	}

	public int getStars() {
		return stars;
	}

	public void setStars(int stars) {
		this.stars = stars;
	}

	public int getRate() {
		return rate;
	}

	public void setRate(int rate) {
		this.rate = rate;
	}

	public int getStar_tmp() {
		return star_tmp;
	}

	public void setStar_tmp(int star_tmp) {
		this.star_tmp = star_tmp;
	}

	public RatingVO getParamClass() {
		return paramClass;
	}

	public void setParamClass(RatingVO paramClass) {
		this.paramClass = paramClass;
	}

	public RatingVO getResultClass() {
		return resultClass;
	}

	public void setResultClass(RatingVO resultClass) {
		this.resultClass = resultClass;
	}

	public List<RatingVO> getList() {
		return list;
	}

	public void setList(List<RatingVO> list) {
		this.list = list;
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

	public int getTeamexp() {
		return teamexp;
	}

	public void setTeamexp(int teamexp) {
		this.teamexp = teamexp;
	}

	public int getCompexp() {
		return compexp;
	}

	public void setCompexp(int compexp) {
		this.compexp = compexp;
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

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public Timestamp getRatingregdate() {
		return ratingregdate;
	}

	public void setRatingregdate(Timestamp ratingregdate) {
		this.ratingregdate = ratingregdate;
	}

	public String getReputation() {
		return reputation;
	}

	public void setReputation(String reputation) {
		this.reputation = reputation;
	}

}
