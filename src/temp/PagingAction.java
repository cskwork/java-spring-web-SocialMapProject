package temp;

public class PagingAction {
	private int currentPage;
	private int totalCount;
	private int totalPage;
	private int blockCount;
	private int blockPage;
	private int startCount;
	private int endCount;
	private int startPage;
	private int endPage;

	private StringBuffer pagingHtml;

	public PagingAction(int currentPage, int totalCount, int blockCount, int blockPage, int num, String pageAction,String isSearch) {
		this.blockCount = blockCount;
		this.blockPage = blockPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;

		// 전체페이지?
		totalPage = (int) Math.ceil((double) totalCount / blockCount);

		if (totalPage == 0)
			totalPage = 1;

		// 현재페이지 > 전체페이지 ? 전체페이지 : 현재 페이지
		if (currentPage > totalPage)
			currentPage = totalPage;

//		System.out.println("currentPage: " + currentPage);

		// 현재 페이지의 처음과 마지막 번호 추출
		startCount = (currentPage - 1) * blockCount;
		endCount = startCount + blockCount - 1;

		// 시작 페이지와 마지막 페이지 계산
		startPage = (int) ((currentPage - 1) / blockPage) * blockPage - 1;
		if(startPage < 1)
			startPage = 1;
		
		endPage = startCount + blockPage - 1;

		// 마지막 페이지 > 전체 페이지 ? 전체페이지 : 마지막 페이지
		if (endPage > totalPage)
			endPage = totalPage;

		// 이전 block 페이지?
		pagingHtml = new StringBuffer();

		if (currentPage > blockPage) {
			pagingHtml.append("<a href=" + pageAction + ".action?currentPage=" + (startPage - 1) + ">");
			pagingHtml.append("이전");
			pagingHtml.append("</a>");
		}

		pagingHtml.append("&nbsp;|&nbsp;");

		// 페이지 번호와 현재 페이지는 빨간색으로 강조하고 링크를 제거.
		for (int i = startPage; i <= endPage; i++) {
			if (i > totalPage) {
				break;
			}
			if (i == currentPage) {
				pagingHtml.append("&nbsp;<b> <font color='red'>");
				pagingHtml.append(i);
				pagingHtml.append("</font></b>");
			} else {
				pagingHtml.append("&nbsp;<a href='" + pageAction + ".action?currentPage=");
				pagingHtml.append(i);
				pagingHtml.append("'>");
				pagingHtml.append(i);
				pagingHtml.append("</a>");
			}

			pagingHtml.append("&nbsp;");
		}

		pagingHtml.append("&nbsp;&nbsp;|&nbsp;&nbsp;");

		// 다음 block 페이지
		if (totalPage - startPage >= blockPage) {
			pagingHtml.append("<a href=" + pageAction + ".action?currentPage=" + (endPage + 1) + ">");
			pagingHtml.append("다음");
			pagingHtml.append("</a>");
		}
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public int getBlockCount() {
		return blockCount;
	}

	public int getBlockPage() {
		return blockPage;
	}

	public int getStartCount() {
		return startCount;
	}

	public int getEndCount() {
		return endCount;
	}

	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public StringBuffer getPagingHtml() {
		return pagingHtml;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public void setBlockCount(int blockCount) {
		this.blockCount = blockCount;
	}

	public void setBlockPage(int blockPage) {
		this.blockPage = blockPage;
	}

	public void setStartCount(int startCount) {
		this.startCount = startCount;
	}

	public void setEndCount(int endCount) {
		this.endCount = endCount;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public void setPagingHtml(StringBuffer pagingHtml) {
		this.pagingHtml = pagingHtml;
	}
}