package temp;

public class SearchVO {
	// 조건 종류만큼 추가
	private String comp;
	private String loc;
	private String maj;
	private String addr;
	private String exp;
	
	// and 갯수만큼 추가
	private int and1;
	private int and2;
	public String getComp() {
		return comp;
	}
	public void setComp(String comp) {
		this.comp = comp;
	}
	public String getLoc() {
		return loc;
	}
	public void setLoc(String loc) {
		this.loc = loc;
	}
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
	public String getExp() {
		return exp;
	}
	public void setExp(String exp) {
		this.exp = exp;
	}
	public int getAnd1() {
		return and1;
	}
	public void setAnd1(int and1) {
		this.and1 = and1;
	}
	public int getAnd2() {
		return and2;
	}
	public void setAnd2(int and2) {
		this.and2 = and2;
	}
	
	
	
}