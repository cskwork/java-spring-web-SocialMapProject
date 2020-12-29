<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>SocialMap : 프로젝트 팀 정보</title>
	<script>
		function delList() {
			location.href="delProj.action?teamno=<s:property value='presultClass.teamno'/>";
		}
		function delFav() {
			location.href="delSpec.action?id=<s:property value='resultClass.id'/>&leaderid=<s:property value='resultClass.leaderid'/>";
		}
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
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>관심스펙 > 상세보기</h2>
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
				</ul>
			</s:if>
			<s:elseif test="auth == 2">
				<ul>
					<li><a href="javascript:view()">내정보수정/탈퇴</a></li>
					<!-- <li><a href="javascript:favList()">관심스펙리스트</a></li> -->
					<li><a href="javascript:favProj()">관심플젝리스트</a></li>
					<li><a href="javascript:myProj()">나의 프로젝트</a></li>
					<li><a href="javascript:hopeList()">참여 제안</a></li>
				</ul>
			</s:elseif>
		</div>
		<div class="detailbox">
			<table class="tstyle_list" width="750px">
				<tr>
					<td style="font-weight:800;" colspan="2">관심프로젝트</td>
				</tr>
				<tr>
					<td class="list">팀장ID</td>
					<td><s:property value="presultClass.leaderid" /></td>
				</tr>
				<tr>
					<td class="list">제목</td>
					<td><s:property value="presultClass.title" /></td>
				</tr>
				<tr>
					<td class="list">카테고리</td>
					<td><s:property value="presultClass.comp" /></td>
				</tr>
				<tr>
					<td class="list">시작일</td>
					<td><s:property value="presultClass.startdate" /></td>
				</tr>
				<tr>
					<td class="list">종료일</td>
					<td><s:property value="presultClass.enddate" /></td>
				</tr>
				<tr>
					<td class="list">현재모집인원/모집인원</td>
					<td><s:property value="presultClass.currmem" />/<s:property value="presultClass.recmem" /></td>
				</tr>
				<tr>
					<td class="list">전공</td>
					<td><s:property value="presultClass.maj" /></td>
				</tr>
				<tr>
					<td class="list">상세내용</td>
					<td><s:property value="presultClass.cont" /></td>
				</tr>
				<tr>
					<td class="list">지역</td>
					<td><s:property value="presultClass.loc" /></td>
				</tr>
				<tr>
					<td class="list">임금</td>
					<td><s:property value="presultClass.sal" /></td>
				</tr>
				
				<tr>
					<td colspan="2">
						<s:hidden value="presultClass.teamno" />
						<input type="button" value="스크랩취소하기" onclick="delList()"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</body>
</html>