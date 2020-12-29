<!-- 2018-11-12 이준호 -->
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>공지사항</title>
</head>
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="center"><h2>공지사항</h2></td>
		</tr>
		<tr>
			<td height="20" />
		</tr>
	</table>
	<form action="ASDelete.action">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr align="center">
				<td>stat</td>
				<td>checkbox</td>
				<td><strong>구분</strong></td>
				<td><strong>제목</strong></td>
				<td><strong>내용</strong></td>
				<td><strong>날짜</strong></td>
				<td><strong>조회</strong></td>
				<td><strong>번호</strong></td>
			</tr>
			<s:iterator value="list" status="stat">
				<s:url id="viewURL" action="ASInfo">
					<s:param name="no">
						<s:property value="no"/>
					</s:param>
				</s:url>
				<tr align="center">
					<td><s:property value="#stat.index+1"/></td>
					<td><s:checkbox name="check" theme="simple" fieldValue="%{no}"/></td>
					<td><s:property value="custlog" /></td>
					<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
					<td><s:property value="cont" /></td>
					<td><s:property value="regdate" /></td>
					<td><s:property value="hits" /></td>
					<td><s:property value="no" /></td>
				</tr>
			</s:iterator>
			
			<tr align="center">
				<td colspan="6">
					<s:property value="pagingHtml" escape="false"/>
				</td>
			</tr>
			<tr align="left">
				<td>
					<a href="http://localhost:8080/SocialMap/ASWrite.action">글작성</a>
				</td>
				<td>
					<a href="/SocialMap/admin/adminPageHome.jsp">관리자 페이지</a>
				</td>
			</tr>
		</table>
		<input type="submit" value="삭제">
	</form>
	<form method="post">
		<s:textfield name="search" theme="simple" maxlength="20" />
		<input type="submit" value="검색"/>
	</form>
</body>
</html>