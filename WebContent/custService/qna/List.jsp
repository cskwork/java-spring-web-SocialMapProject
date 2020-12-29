<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Q&A - 질문하기</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
	<script type="text/javascript">
		function open_win_noresizable(url, name) {
			var oWin = window.open(url, name, "scrollbars=no, status=no, resizable=no, width=300, height=150");
		}
	</script> 
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>Q&A</h2>
		</div>
	</div>
	<div class="wrap">
		<div class="sidebox">
			<h2>Help Desk</h2>
			<ul>
				<li><a href="QnaList.action">Q&A</a></li>
				<li><a href="FAQList.action">FAQ</a></li>
				<li><a href="ASList.action">공지사항</a></li>
			</ul>
		</div>
		<div class="detailbox">
			<div class="write">
				<input type="button" value="질문작성" class="submit" onClick="javascript:location.href='QnaWrite.action?currentPage=<s:property value="currentPage" />'">
			</div>
			<div class="table board_list">
				<table class="tstyle_list">
					<colgroup>
						<col width="*">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th scope="col">질문</th>
						<th scope="col">작성자</th>
						<th scope="col">작성일</th>
					</tr>
					
					<s:if test="list.size() <= 0">
						<tr bgcolor="#FFFFFF" align="center">
							<td colspan="3">등록된 게시물이 없습니다.</td>
						</tr>
					</s:if>
					
					<s:iterator value="list" status="stat">
						<s:if test="qalog == 0">
							<s:url id="viewURL" action="QnaInfo">
								<s:param name="no">
									<s:property value="no" />
								</s:param>
								<s:param name="currentPage">
									<s:property value="currentPage" />
								</s:param>
							</s:url>
							
							<tr class="a">
								<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>	
								<td><s:property value="id" /></td>
								<td><s:property value="regdate" /></td>
							</tr>
						</s:if>
					</s:iterator>  
					
					<tr align="center" style="background-color:#f5f5ff;">
						<td colspan="3"><s:property value="pagingHtml" escape="false" /></td>
					</tr>	
				</table>
			</div>
			<div class="board_search">
				<form method="post">
					<select name="searchnum">
						<option value="0">제목</option>
						<option value="1">작성자ID</option>
					</select>
					
					<s:textfield name="search" theme="simple" value="" cssStyle=" width: 320px; height: 35px; border-radius: 0;"/>	
					<input name="submit" type="submit" value="검색하기" class="submit"/>
				</form>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>