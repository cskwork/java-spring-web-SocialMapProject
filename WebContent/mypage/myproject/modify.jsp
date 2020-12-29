<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : 프로젝트 팀 개설</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/write.css">
	<script type="text/javascript">
		function validation() {
			var frm = document.forms(0);
			if(frm.title.value == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if(frm.cont.value == "") {
				alert("내용을 입력해주세요");
				return false;
			}
			return true;
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
		function hopeList() {
			location.href="hopeList.action";
		}
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>프로젝트 수정하기</h2>
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
			<s:if test="step == 2">
				<script type="text/javascript">location.href="MyProjList.action";</script>
			</s:if>
			<s:else>
				<form action="ProjModify.action" method="post" enctype="multipart/form-data" onsubmit="return validation();">
					<table class="writetable">
						<tr>
							<td class="list">팀장 ID</td>
							<td class="input"><s:property value='id'/></td>
						</tr>
						<tr>
							<td class="list">글 제목</td>
							<td class="input"><input type="text" name="title" maxlength="30" value="<s:property value='resultClass.title'/>"></td>
						</tr>
						<tr>
							<td class="list">대회 및 공모전 계획</td>
							<td class="input"><input type="text" name="comp" maxlength="10" value="<s:property value='resultClass.comp'/>"></td>
						</tr>
						<tr>
							<td class="list">시작일</td>
							<td class="input"><input type="date" name="startdate" value="<s:property value='resultClass.startdate'/>"></tr>
						<tr>
						<tr>
							<td class="list">종료일</td>
							<td class="input"><input type="date" name="enddate" value="<s:property value='resultClass.enddate'/>"></tr>
						<tr>
						<tr>
							<td class="list">모집인원</td>
							<td class="input"><input type="text" name="recmem" maxlength="2" value="<s:property value='resultClass.recmem'/>"></td>
						</tr>
						<tr>
							<td class="list">모집전공</td>
							<td class="input"><input type="text" name="maj" maxlength="50" value="<s:property value='resultClass.maj'/>"></td>
						</tr>
						<tr>
							<td class="list">글 내용</td>
							<td class="input"><s:textarea theme="simple" rows="4" cols="50" name="cont" value='%{resultClass.cont}'/></td>
						</tr>
						<tr>
							<td class="list">지역</td>
							<td class="input"><input type="text" name="loc" maxlength="20" value="<s:property value='resultClass.loc'/>"></td>
						</tr>
						<tr>
							<td class="list">임금</td>
							<td class="input"><input type="text" name="sal" maxlength="6" value="<s:property value='resultClass.sal'/>"></td>
						</tr>
						
						<tr class="btn">
							<td colspan="2">
								<s:hidden value="1" name="step"/>
								<s:hidden value="%{teamno}" name="teamno"/>
								<input type="button" value="취    소" onclick="javascript:window.location='MyProjInfo.action?teamno=<s:property value='resultClass.teamno'/>'" >
								<input type="submit" value="수정 완료">
							</td>
						</tr>
					</table>
				</form>
			</s:else>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>