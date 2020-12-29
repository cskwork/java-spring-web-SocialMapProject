<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>공지사항</title>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>공지사항</h2>
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
			<%--글 등록은 관리자만 --%>
			<%-- <div class="write">
				<input type="button" value="공지사항작성" class="submit" onClick="javascript:location.href='ASWrite.action.action?custlog=<s:property value="custlog" />'">
			</div> --%>
			<div class="table board_list">
				<table class="tstyle_list">
					<colgroup>
						<col width="10%">
						<col width="*">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">제목</th>
						<th scope="col">날짜</th>
						<th scope="col">조회수</th>
					</tr>
					
					<s:if test="list.size() <= 0">
						<tr>
							<td colspan="4">등록된 게시물이 없습니다.</td>
						</tr>
					</s:if>
					
					<s:iterator value="list" status="stat">
						<s:url id="viewURL" action="ASInfo">
							<s:param name = "custlog">
								<s:property value="custlog"/>
							</s:param>
							<s:param name="no">
								<s:property value="no"/>
							</s:param>
						</s:url>
						<tr class="a">
							<td><s:property value="no" /></td>
							<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
							<td><s:property value="regdate" /></td>
							<td><s:property value="hits" /></td>
						</tr>
					</s:iterator>
					
					<tr align="center" style="background-color:#f5f5ff;">
						<td colspan="4"><s:property value="pagingHtml" escape="false" /></td>
					</tr>
				</table>
			</div>
			<div class="board_search">
				<form method="post">
					<select name="searchnum">
						<option value="0">제목</option>
						<option value="1">제목+내용</option>
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
	<%-- <tr align="left">
			<td>
				<a href="http://localhost:8080/SocialMap/ASList.action">액션</a>
			</td>
			<td>
				<a href="http://localhost:8080/SocialMap/ASWrite.action">글작성</a>
			</td>
		</tr> --%>
</body>
</html>