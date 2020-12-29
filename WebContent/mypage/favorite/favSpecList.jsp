<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
	<title>관심스펙 리스트</title>
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
						<col width="15%">
						<col width="10%">
						<col width="10%">
						<col width="*">
					</colgroup>
					<tr>
						<th scope="col">프리랜서ID</th>
						<th scope="col">등록날짜</th>
						<th scope="col">자격증</th>
						<th scope="col">프로젝트 경험</th>
					</tr>
					
					<s:if test="favlist.size()<=0">
						<tr align="center">
							<td colspan="4">스크랩한 스펙이 없습니다.</td>
						</tr>
					</s:if>
					
					<s:iterator value="favlist" status="stat">
						<s:hidden value="artlog"/>
						<s:url id="viewURL" action="favSpecInfo.action">
							<s:param name="id">
								<s:property value="id"/>
							</s:param>
							<s:param name="currentPage">
								<s:property value="currentPage"/>
							</s:param>
						</s:url>
					
						<!-- 글 내용 출력 부분 -->
						<tr class="a">
							<td><s:a  href="%{viewURL}"><s:property value="id"/></s:a></td>
							<td><s:property value="regdate" /></td>
							<td><s:property value="spec" /></td>
							<td><s:property value="proexp" /></td>
						</tr>
					</s:iterator>
					
					<tr align="center">	
						<td colspan="5">
							<s:property value="pagingHtml" escape="false"/>
						</td>
					</tr>
				</table>
				<div class="board_search">
					<input type="button"  value="돌아가기" onclick="javascript:location.href='SpecList.action'"/>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>