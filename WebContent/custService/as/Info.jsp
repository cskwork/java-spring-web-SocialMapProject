<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>공지사항</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>공지사항 > 공지사항 상세보기</h2>
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
	</div>
	<div class="detailbox">
		<table class="tstyle_list" width="750px">
			<tr>
				<td style="font-weight:800;" colspan="2">공지사항</td>
			</tr>
			<tr>
				<td class="list">No</td>
				<td><s:property value="resultClass.no" /></td>
			</tr>
			<tr>
				<td class="list">제목</td>
				<td><s:property value="resultClass.title" /></td>
			</tr>
			<tr>
				<td class="list">내용</td>
				<td><s:property value="resultClass.cont" /></td>
			</tr>
			<tr>
				<td class="list">작성일</td>
				<td><s:property value="resultClass.regdate" /></td>
			</tr>
			<tr>
				<td class="list">조회수</td>
				<td><s:property value="resultClass.hits" /></td>
			</tr>
			
			
			<tr>
				<td colspan="2">
					<s:url id="deleteURL" action="QnaDelete">
						<s:param name="no">
							<s:property value="no" />
						</s:param>
					</s:url> 
					<%-- <input type="button" value="수정하기" onClick="javascript:location.href='ASModify.action?custlog=<s:property value="custlog" />&no=<s:property value="no" />'">
	 				<input type="button" value="삭제하기" onClick="javascript:open_win_noresizable('ASDelete.action?custlog=<s:property value="custlog" />&no=<s:property value="no" />','delete')"> --%>
					<input type="button" value="목록보기" onClick="javascript:location.href='ASList.action?currentPage=<s:property value="currentPage" />'">
				</td>
			</tr>
		</table>
	</div>
</div>
	<%-- 

		<tr align="left">
			<td>
				<a href="http://localhost:8080/SocialMap/ASList.action">리스트</a>
			</td>
			<td>
				<a href="http://localhost:8080/SocialMap/ASDelete.action?custlog=<s:property value='custlog'/>&&no=<s:property value='no'/>">글 삭제</a>
			</td>
			<td>
				<a href="http://localhost:8080/SocialMap/ASModify.action?custlog=<s:property value='custlog'/>&no=<s:property value='no'/>">글 수정</a>
			</td>
		</tr>
	</table> --%>
</body>
</html>