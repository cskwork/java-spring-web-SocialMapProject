<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/header.css" />
	<script type="text/javascript" >
		function go() {
			document.form.submit();
		}	
	</script>
	<script>
		$(document).ready(function() {
			 
			// 기존 css에서 플로팅 배너 위치(top)값을 가져와 저장한다.
			var floatPosition = parseInt($(".floatMenu").css('top'));
			// 250px 이런식으로 가져오므로 여기서 숫자만 가져온다. parseInt( 값 );
		 
			$(window).scroll(function() {
				// 현재 스크롤 위치를 가져온다.
				var scrollTop = $(window).scrollTop();
				var newPosition = scrollTop + floatPosition + "px";
		 
				/* 애니메이션 없이 바로 따라감
				 $("#floatMenu").css('top', newPosition);
				 */
		 
				$(".floatMenu").stop().animate({
					"top" : newPosition
				}, 500);
		 
			}).scroll();
		 
		});
	</script>
	<script type="text/javascript" >
		function go() {
			document.form.submit();
		}
		
		function checkRateDate() {
		    var ask = window.confirm("평점 등록이 필요합니다!");
		    if (ask) {
		        window.alert("평점 등록 페이지로 이동합니다.");

		        location.href= "http://localhost:8080/SocialMap/mypage/Rating/RatingList.action";

		    }
		}
	</script>
</head>
<body>
<s:if test="checkdate == 1">
      <script type="text/javascript"> location.href="/SocialMap/mypage/Rating/RatingList.action"; </script>
</s:if>
<div class="contents clearfix sm-home">
 <div class="wrap">
  <h2>프로젝트 업무 데스크</h2>
  <p class="sm-intro">지역, 전공, 모집 조건을 비교하고 함께할 팀을 선택하세요.</p>
  <form class="sm-desk-search" action="ProjList.action" method="get"><label>모집 검색<input name="search" placeholder="프로젝트 제목으로 검색"></label><button type="submit">프로젝트 찾기</button></form>
  <div class="sm-home-actions">
   <a class="button-style1" href="ProjList.action">프로젝트 찾기</a>
   <a class="button-style1" href="SpecList.action">프리랜서 찾기</a>
   <s:if test="auth == 1"><a href="ProjWrite.action">프로젝트 등록하기</a></s:if>
   <s:if test="auth == 2"><a href="SpecList.action">내 스펙 등록하기</a></s:if>
  </div>
  <div class="sm-desk-columns"><section><h3>모집 중인 프로젝트</h3>
  <div class="sm-featured">
   <s:iterator value="featuredProjects">
    <article>
     <s:url id="homeProject" action="ProjInfo.action"><s:param name="teamno"><s:property value="teamno"/></s:param><s:param name="leaderid"><s:property value="leaderid"/></s:param></s:url>
     <h4><s:a href="%{homeProject}"><s:property value="title"/></s:a></h4>
     <p><s:property value="loc"/> · <s:property value="maj"/></p>
     <p>추가 모집 <s:property value="recmem"/>명 · 현재 참여 <s:property value="currmem"/>명</p>
     <p><s:property value="startdate"/> ~ <s:property value="enddate"/></p>
    </article>
   </s:iterator>
  </div>
  <p><a href="ProjList.action">전체 프로젝트 보기</a></p></section><aside class="sm-work-panel"><h3>내 작업 이어가기</h3><p>받은 신청을 검토하고 함께할 팀을 확정하세요.</p><a href="hopeList.action">받은 신청</a><a href="MyProjList.action">내 프로젝트</a><a href="MsgList.action">쪽지함</a><a href="guideHome.action">참여 방법 보기</a></aside></div>
 </div>
</div>
</body>
</html>
