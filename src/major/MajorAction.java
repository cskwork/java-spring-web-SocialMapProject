package major;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings({ "unchecked", "serial" })
public class MajorAction extends ActionSupport {
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	private List<MajorVO> list = new ArrayList<MajorVO>();
	
	private String search;
	
	public MajorAction() throws IOException {
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}
	
	public String execute() throws Exception {
		if(search!=null) {
			list = sqlMapper.queryForList("major.search", "%"+getSearch()+"%");
		} else {
			list = sqlMapper.queryForList("major.selectList");
		}
		return SUCCESS;
	}

	public List<MajorVO> getList() {
		return list;
	}

	public void setList(List<MajorVO> list) {
		this.list = list;
	}

	public String getSearch() {
		return search;
	}
	
	public void setSearch(String search) {
		this.search = search;
	}
}