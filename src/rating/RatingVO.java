package rating;

import java.sql.Timestamp;

public class RatingVO {
	private String sendid;
	private String getid;
	private int rate;
	private int teamexp;
	private Timestamp ratingregdate;
	private String reputation;

	// 프로젝트 팀에서 가져오기
	private int teamno;
	private String title;
	private String id;

	public String getId() {
		return id;
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

	public int getTeamno() {
		return teamno;
	}

	public void setTeamno(int teamno) {
		this.teamno = teamno;
	}

	public int getRate() {
		return rate;
	}

	public void setRate(int rate) {
		this.rate = rate;
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

	public int getRating() {
		return rate;
	}

	public void setRating(int rating) {
		this.rate = rating;
	}

	public int getTeamexp() {
		return teamexp;
	}

	public void setTeamexp(int teamexp) {
		this.teamexp = teamexp;
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
