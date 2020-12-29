package msg;

import java.sql.Timestamp;

public class MsgVO {
	private int no;
	private String sendid;
	private String getid;
	private String title;
	private String cont;
	private Timestamp sendtime;

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
}
