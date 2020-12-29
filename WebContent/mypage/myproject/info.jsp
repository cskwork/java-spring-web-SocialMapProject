<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : 프로젝트 팀 정보</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/notice.css" />
<script type="text/javascript"></script>
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
			<h2><s:property value="resultClass.title" /></h2>
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
	</div>
		<div class="detailbox">
			<table class="tstyle_list" width="750px">
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
				<tr height="100">
					<td class="list">내용</td>
					<td class="input"><textarea disabled="disabled" onfocus="this.blur()" rows="10" style="border:none; overflow: hidden;" ><s:property value='resultClass.cont' /></textarea></td>
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
						<input type="button" value="리스트" onclick="javascript:window.location='MyProjList.action'"/>
						<s:if test="auth == 1">
							<input type="button" value="글 삭제" onclick="javascript:window.location='ProjDelete.action?leaderid=<s:property value="resultClass.leaderid"/>&teamno=<s:property value="resultClass.teamno"/>'"/>
							<input type="button" value="프로젝트 수정" onclick="javascript:window.location='ProjModify.action?step=0&teamno=<s:property value='resultClass.teamno'/>'" >
						</s:if>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>