<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>마이페이지</title>
	<script>
		function view() {
			location.href="modifyMemberForm.action";
		}
		function favList() {
			location.href="favSpecList.action";
		}
		function favProj() {
			location.href="favProjList.action";
		}
		function myProj() {
			location.href="MyProjList.action";
		}
		function hopeList() {
			location.href="hopeList.action";
		}
	</script>
</head>

<body>
<div class="contents clearfix">
	<div class="title">       
		<div class="wrap">
			<h2>마이페이지</h2>
		</div>
	</div>
	<div class="wrap">
		<div class="sidebox">
			<h2>My Page</h2>
			<s:if test="auth == 1">
				<ul>
					<li><a href="javascript:view()">내정보수정/탈퇴</a></li>
					<li><a href="javascript:favList()">관심스펙리스트</a></li>
					<!-- <li><a href="javascript:favProj()">관심플젝리스트</a></li> -->
					<li><a href="javascript:myProj()">나의 프로젝트</a></li>
					<li><a href="javascript:hopeList()">참여 희망자</a></li>
					<li><a href="#" onClick="window.open('RatingList.action','평점','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">평점 보기</a></li> 
				</ul>
			</s:if>
			<s:elseif test="auth == 2">
				<ul>
					<li><a href="javascript:view()">내정보수정/탈퇴</a></li>
					<!-- <li><a href="javascript:favList()">관심스펙리스트</a></li> -->
					<li><a href="javascript:favProj()">관심플젝리스트</a></li>
					<li><a href="javascript:myProj()">나의 프로젝트</a></li>
					<li><a href="javascript:hopeList()">참여 제안</a></li>
					<li><a href="#" onClick="window.open('RatingList.action','평점','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">평점 보기</a></li> 
				</ul>
			</s:elseif>
		</div>
		<div class="detailbox">
			<table class="tstyle_list" width="750px">
				<tr>
					<td style="font-weight:800;" colspan="2">나의 정보보기</td>
				</tr>
				<tr>
					<td class="list">사용자 ID</td>
					<td><s:property value="id"/></td>
				</tr>
				<tr>
					<td class="list">비밀번호</td>
					<td><s:property value="resultClass.pwd"/></td>
				</tr>
				<tr>
					<td class="list">이름</td>
					<td><s:property value="resultClass.name"/></td>
				</tr>
				<tr>
					<td class="list">주민등록 번호</td>
					<td><s:property value="resultClass.birth"/>
				 - 
				<s:property value="resultClass.gen"/>******</td>
				</tr>
				<tr>
					<td class="list">E-mail</td>
					<td><s:property value="resultClass.email"/></td>
				</tr>
				<tr>
					<td class="list">주소</td>
					<td><s:property value="resultClass.addr"/></td>
				</tr>
				<tr>
					<td class="list">전공</td>
					<td><s:property value="resultClass.maj"/></td>
				</tr>
				<tr>
					<td class="list">전공관련 이력</td>
					<td><s:property value="resultClass.exp"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>