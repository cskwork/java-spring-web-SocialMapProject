package temp;

import com.opensymphony.xwork2.ActionSupport;

public class guideAction extends ActionSupport{
	private String mainpage;
	
	public String execute() {	
		setMainpage("guide");
		return SUCCESS;
	}
	public String execute1() {	
		setMainpage("guide1");
		return SUCCESS;
	}
	public String execute2() {	
		setMainpage("guide2");
		return SUCCESS;
	}
	public String execute3() {	
		setMainpage("guide3");
		return SUCCESS;
	}

	public String getMainpage() {
		return mainpage;
	}

	public void setMainpage(String mainpage) {
		this.mainpage = mainpage;
	}
}
