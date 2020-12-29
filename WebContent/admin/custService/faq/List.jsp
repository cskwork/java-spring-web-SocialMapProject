<!-- 2018-11-13 이준호 -->
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>FAQ - 자주묻는 질문</title>
</head>
<body>
	 <table width="600" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="center"><h2>FAQ</h2></td>
		</tr>
		<tr>
			<td height="20" />
		</tr>
	 </table>
	 
	 <table width="800" border="0" cellspacing="0" cellpadding="2">
		<tr align="center">
			<td><strong>구분</strong></td>
			<td><strong>제목</strong></td>
			<td><strong>내용</strong></td>
			<td><strong>날짜</strong></td>
			<td><strong>조회</strong></td>
			<td><strong>번호</strong></td>
		</tr>
	 
		<s:if test="list.size()<=0">
			<tr align="center">
				<td colspan="3">등록된 게시물이 없습니다.</td>
			</tr>
		</s:if>
		 
		<s:iterator value="list" status="stat">
			<s:url id="viewURL" action="FAQInfo">
				<s:param name = "custlog">
					<s:property value="custlog"/>
				</s:param>
				<s:param name="no">
					<s:property value="no"/>
				</s:param>
			</s:url>
			<tr align="center">
				<%-- <s:hidden name="no" value="%{resultClass.no}" />
				<s:hidden name="custlog" value="%{resultClass.custlog}"/> --%>
				<td><s:property value="custlog" /></td>
				<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
				<td><s:property value="cont" /></td>
				<td><s:property value="regdate" /></td>
				<td><s:property value="hits" /></td>
				<td><s:property value="no" /></td>
			</tr>
		</s:iterator>
		
		<tr align="center">
			<td colspan="5">
				<s:property value="pagingHtml" escape="false"/>
			</td>
		</tr>
		
		<tr align="right">
			<td>
				<input type="button" value="글쓰기" onClick="javascript:location.href='FAQWrite.action';">
			</td>
			<td>
				<a href="/SocialMap/admin/adminPageHome.jsp">관리자 페이지</a>
			</td>
		</tr>
	</table>
	<form method="post">
			<s:textfield name="search" theme="simple" maxlength="20" />
			<input type="submit" value="검색"/>
	</form>
</body>
</html>