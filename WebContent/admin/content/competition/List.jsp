<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>대회정보</title>
</head>
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="center"><h2>대회정보</h2></td>
		</tr>
		<tr>
			<td height="20" />
		</tr>
	</table>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">				<!-- 조회수 top5 게시물 리스트 -->
		<tr align="center">
			<td><strong>번호</strong></td>
			<td><strong>이미지</strong></td>
			<td><strong>제목</strong></td>
			<td><strong>시작일</strong></td>
			<td><strong>마감일</strong></td>
			<td><strong>내용</strong></td>
			<td><strong>등록일</strong></td>
			<td><strong>조회수</strong></td>
		</tr>
		<s:iterator value="list1" status="stat1">
			<s:url id="viewURL" action="CompInfo">
				<s:param name="no">
					<s:property value="no"/>
				</s:param>
			</s:url>
			<s:if test="#stat1.index < 5">
				<tr align="center">
					<td><s:property value="no" /></td>
					<td ><s:a href="%{viewURL}"><img width="65" height="40" src=".\\..\\..\\upload\\file_<s:property value='no'/>.PNG"></s:a></td>
					<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
					<td><s:property value="startdate" /></td>
					<td><s:property value="enddate" /></td>
					<td><s:property value="cont" /></td>
					<td><s:property value="regdate" /></td>
					<td><s:property value="hits" /></td>
					<%-- <td><s:property value="#stat1.index+1"/></td> --%>
				</tr>
			</s:if>
		</s:iterator>
		<tr>
			<td height="20" />
		</tr>
	</table>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">				<!-- 게시물 출력 리스트 -->
		<tr align="center">
			<td><strong>번호</strong></td>
			<td><strong>이미지</strong></td>
			<td><strong>제목</strong></td>
			<td><strong>시작일</strong></td>
			<td><strong>마감일</strong></td>
			<td><strong>내용</strong></td>
			<td><strong>등록일</strong></td>
			<td><strong>조회수</strong></td>
		</tr>
		<s:iterator value="list" status="stat">
			<s:url id="viewURL" action="CompInfo">
				<s:param name="no">
					<s:property value="no"/>
				</s:param>
			</s:url>
			<tr align="center">
				<td><s:property value="no" /></td>
				<td ><s:a href="%{viewURL}"><img width="65" height="40" src="/SocialMap/upload/file_<s:property value='no'/>.PNG"></s:a></td>
				<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
				<td><s:property value="startdate" /></td>
				<td><s:property value="enddate" /></td>
				<td><s:property value="cont" /></td>
				<td><s:property value="regdate" /></td>
				<td><s:property value="hits" /></td>
			</tr>
		</s:iterator>
		<tr align="center">
			<td colspan="8">
				<s:property value="pagingHtml" escape="false"/>
			</td>
		</tr>
		<tr>
			<td>
				<a href="http://localhost:8080/SocialMap/CompWrite.action?step=0">글 작성</a>
			</td>
			<td>
				<a href="/SocialMap/admin/adminPageHome.jsp">관리자 페이지</a>
			</td>
		</tr>
	</table>
</body>
</html>