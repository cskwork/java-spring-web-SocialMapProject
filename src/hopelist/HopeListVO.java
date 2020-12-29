package hopelist;

import java.sql.Timestamp;

public class HopeListVO {
	private int no;
	private String sendid;
	private String getid;
	private Timestamp regdate;
	private int log;
	
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
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
	public Timestamp getRegdate() {
		return regdate;
	}
	public void setRegdate(Timestamp regdate) {
		this.regdate = regdate;
	}
	public int getLog() {
		return log;
	}
	public void setLog(int log) {
		this.log = log;
	}
}
