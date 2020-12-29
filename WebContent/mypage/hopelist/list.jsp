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
			<tr>
			   <th><strong>보낸 사람 ID</strong></th>
			   <th><strong>수락여부</strong></th>
			</tr>
			
			<s:if test="list.size()==0">
			   <tr class="no">
				  <td colspan="3">등록된 게시물이 없습니다.</td>
			   </tr>
			</s:if>
			
			<s:iterator value="list" status="stat">
			   <tr class="a">
			   	  <s:hidden value="no"/>
			   	  <s:hidden value="getid"/>
				  <td><s:property value="sendid" /></td>
				  
				  <s:if test="auth == 1">
				  	<td><input type="button"  value="수락" onclick="javascript:location.href='insertTeam.action?no=${no}&id=${sendid}&leaderid=${getid}'"/> <!-- teamno 멤버테이블 추가 및 프로젝트 현인원 증가 -->
				  	<input type="button"  value="거절" onclick="javascript:location.href='deleteHopeList.action?no=${no}'"/></td> <!-- hopelist 테이블에서 삭제 -->
			   	  </s:if>
				  
				  <s:elseif test="auth == 2">
				  	<td><input type="button"  value="수락" onclick="javascript:location.href='insertTeam.action?no=${no}&id=${getid}&leaderid=${sendid}'"/> <!-- teamno 멤버테이블 추가 및 프로젝트 현인원 증가 -->
				  	<input type="button"  value="거절" onclick="javascript:location.href='deleteHopeList.action?no=${no}'"/></td> <!-- hopelist 테이블에서 삭제 -->
			   	  </s:elseif>
			   </tr>
			</s:iterator>
			
			<tr align="center">	
						<td colspan="6">
							<s:property value="pagingHtml" escape="false"/>
						</td>
			</tr>
			
		</table>
				<div class="board_search">
					<input type="button"  value="돌아가기" onclick="javascript:location.href='MyPage.action'"/>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>