//2018-10-31 ¿Ã¡ÿ»£
package content.competition;
import java.util.Date;
public class CompetitionVO {
	private int no;
	private String title;
	private Date startdate;
	private Date regdate;
	private Date enddate;
	private String cont;
	private String contadd;
	private int showlog;
	private int hits;
	private String img;
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Date getStartdate() {
		return startdate;
	}
	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public Date getEnddate() {
		return enddate;
	}
	public void setEnddate(Date enddate) {
		this.enddate = enddate;
	}
	public String getCont() {
		return cont;
	}
	public void setCont(String cont) {
		this.cont = cont;
	}
	public String getContadd() {
		return contadd;
	}
	public void setContadd(String contadd) {
		this.contadd = contadd;
	}
	public int getHits() {
		return hits;
	}
	public void setHits(int hits) {
		this.hits = hits;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public int getShowlog() {
		return showlog;
	}
	public void setShowlog(int showlog) {
		this.showlog = showlog;
	}
}