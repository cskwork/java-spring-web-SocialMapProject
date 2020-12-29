<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>관심프로젝트 리스트</title>
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
			<h2>관심스펙리스트</h2>
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
			<div class="table board_list">
				<table class="tstyle_list">
					<colgroup>
						<col width="10%">
						<col width="*">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<tr>
						<th scope="col">팀장ID</th>
						<th scope="col">프로젝트명</th>
						<th scope="col">카테고리</th>
						<th scope="col">프로젝트 기간</th>
						<th scope="col">모집인원</th>
						<th scope="col">지역</th>
					</tr>
					
					<s:if test="favlist.size()<=0">
						<tr align="center">
							<td colspan="6">스크랩한 프로젝트가 없습니다.</td>
						</tr>
					</s:if>
					
					<s:iterator value="favlist" status="stat">
						<s:hidden value="artlog"/>
						<s:url id="viewURL" action="favProjInfo.action">
							<s:param name="teamno">
								<s:property value="teamno"/>
							</s:param>
							<s:param name="currentPage">
								<s:property value="currentPage"/>
							</s:param>
						</s:url>
					
						<!-- 글 내용 출력 부분 -->
						<tr class="a">
							<td><s:property value="leaderid"/></td>
							<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
							<td><s:property value="comp" /></td>
							<td><s:property value="startdate" /> ~ <s:property value="enddate"/></td>
							<td><s:property value="recmem" />/<s:property value="currmem"/></td>
							<td><s:property value="loc" /></td>
						</tr>
					</s:iterator>
					
					<tr align="center">	
						<td colspan="6">
							<s:property value="pagingHtml" escape="false"/>
						</td>
					</tr>
				</table>
				<div class="board_search">
					<input type="button"  value="돌아가기" onclick="javascript:location.href='ProjList.action'"/>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>