package custservice;

import java.util.Date;

public class QnaVO {
	private String id; // �ۼ��� ID
	private int qalog; // Q(0)/A(1)
	private String title; // ����
	private String cont; // ����
	private int no; // �۹�ȣ
	private Date regdate; // �����

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
