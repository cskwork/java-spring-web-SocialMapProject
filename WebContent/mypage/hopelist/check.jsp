<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>프로젝트 참여 제안 목록</title>
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
		 <h2>프로젝트 참여 제안 목록</h2>
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
	  <div class="table board_list">
		 <table class="tstyle_list">
			
		<td colspan="3">거절하였습니다.</td>	
			
		</table>
				<div class="board_search">
					<input type="button"  value="돌아가기" onclick="javascript:location.href='hopelist.action'"/>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>