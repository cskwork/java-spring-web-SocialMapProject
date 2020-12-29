//2018-10-30 ¿Ã¡ÿ»£
package custservice;

import java.util.Date;

public class CustserviceVO {
	private int custlog;
	private String title;
	private String cont;
	private Date regdate;
	private int hits;
	private int no;

	public int getCustlog() {
		return custlog;
	}

	public void setCustlog(int custlog) {
		this.custlog = custlog;
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

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public int getHits() {
		return hits;
	}

	public void setHits(int hits) {
		this.hits = hits;
	}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}
}