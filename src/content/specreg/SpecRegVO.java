package content.specreg;

import java.sql.Timestamp;

public class SpecRegVO {
	private String id;
	private Timestamp regdate;
	private String exp;
	private String contadd;
	private int showlog;
	private String maj;
	private String addr;
	
	
	
	public String getMaj() {
		return maj;
	}
	public void setMaj(String maj) {
		this.maj = maj;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Timestamp getRegdate() {
		return regdate;
	}
	public void setRegdate(Timestamp regdate) {
		this.regdate = regdate;
	}
	public String getExp() {
		return exp;
	}
	public void setExp(String exp) {
		this.exp = exp;
	}
	public String getContadd() {
		return contadd;
	}
	public void setContadd(String contadd) {
		this.contadd = contadd;
	}
	public int getShowlog() {
		return showlog;
	}
	public void setShowlog(int showlog) {
		this.showlog = showlog;
	}


}
