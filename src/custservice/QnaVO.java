package custservice;

import java.util.Date;

public class QnaVO {
	private String id; // 작성자 ID
	private int qalog; // Q(0)/A(1)
	private String title; // 제목
	private String cont; // 내용
	private int no; // 글번호
	private Date regdate; // 등록일

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

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

}
