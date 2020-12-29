<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : 프로젝트 팀 정보</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/write.css" />
<script type="text/javascript"></script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2><s:property value="resultClass.title" /></h2>
		</div>
	</div>
		<div class="wrap">
			<table class="writetable">
				<tr>
					<td class="list">팀장 ID</td>
					<td class="input"><s:property value="resultClass.leaderid" /></td>
				</tr>
				<tr>
					<td class="list">제목</td>
					<td class="input"><s:property value="resultClass.title" /></td>
				</tr>
				<tr>
					<td class="list">카테고리</td>
					<td class="input"><s:property value="resultClass.comp" /></td>
				</tr>
				<tr>
					<td class="list">시작일</td>
					<td class="input"><s:property value="resultClass.startdate" /></td>
				</tr>
				<tr>
					<td class="list">종료일</td>
					<td class="input"><s:property value="resultClass.enddate" /></td>
				</tr>
				<tr>
					<td class="list">모집인원</td>
					<td class="input"><s:property value="resultClass.recmem" /></td>
				</tr>
				<tr>
					<td class="list">전공</td>
					<td class="input"><s:property value="resultClass.maj" /></td>
				</tr>
				<tr>
					<td class="list">내용</td>
					<td class="input"><s:property value="resultClass.cont" /></td>
				</tr>
				<tr>
					<td class="list">현재인원</td>
					<td class="input"><s:property value="resultClass.currmem" /></td>
				</tr>
				<tr>
					<td class="list">지역</td>
					<td class="input"><s:property value="resultClass.loc" /></td>
				</tr>
				<tr>
					<td class="list">임금</td>
					<td class="input"><s:property value="resultClass.sal" />원</td>
				</tr>
				
				<tr class="btn">
					<td colspan="2">
						<input type="button" value="리스트" onclick="javascript:window.location='ProjList.action'"/>
						<input type="button" value="글 삭제" onclick="javascript:window.location='ProjDelete.action?no=<s:property value="resultClass.no"/>'"/>
						<input type="button" value="글 수정" onclick="javascript:window.location='ProjModify.action?step=0&no=<s:property value="resultClass.no"/>'"/>
						<%-- <a href="http://localhost:8080/SocialMap/CompList.action">리스트</a>  
						<a href="http://localhost:8080/SocialMap/CompDelete.action?no=<s:property value='resultClass.no'/>">글 삭제</a>  
						<a href="http://localhost:8080/SocialMap/CompModify.action?step=0&no=<s:property value='resultClass.no'/>">글 수정</a> --%>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>