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
  <div class="sm-home-head">
   <div><h2>프로젝트 업무 데스크</h2>
   <p class="sm-intro">지역, 전공, 모집 조건을 비교하고 함께할 팀을 선택하세요.</p></div>
   <form class="sm-desk-search" action="ProjList.action" method="get"><label>모집 검색<input name="search" placeholder="프로젝트 제목으로 검색"></label><button type="submit">프로젝트 찾기</button></form>
  </div>
  <s:if test="openSummary != null">
  <div class="sm-pulse">
   <p><strong><s:property value="openSummary.projects"/>개 프로젝트</strong>가 팀원 <strong><s:property value="openSummary.seats"/>명</strong>을 더 찾고 있습니다. 지역을 고르면 해당 지역 모집만 봅니다.</p>
   <ul class="sm-region-links" aria-label="지역별 모집 중 프로젝트">
    <s:iterator value="openSummary.regions">
     <s:url id="regionURL" action="ProjList.action"><s:param name="loc"><s:property value="loc"/></s:param></s:url>
     <li><s:a href="%{regionURL}"><s:property value="loc"/> <span><s:property value="count"/>곳</span></s:a></li>
    </s:iterator>
   </ul>
  </div>
  </s:if>
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
     <p class="sm-meta"><s:property value="loc"/> · <s:property value="comp"/></p>
     <p class="sm-desc"><s:property value="cont"/></p>
     <dl class="sm-facts">
      <div><dt>찾는 전공</dt><dd><s:property value="maj"/></dd></div>
      <div><dt>인원</dt><dd>현재 참여 <s:property value="currmem"/>명 · 추가 모집 <strong><s:property value="recmem"/>명</strong></dd></div>
      <div><dt>기간</dt><dd><s:property value="startdate"/> ~ <s:property value="enddate"/></dd></div>
     </dl>
    </article>
   </s:iterator>
  </div>
  <p><a href="ProjList.action">전체 프로젝트 보기</a></p></section>
  <aside class="sm-work-panel"><h3>내 작업 이어가기</h3>
   <s:if test="work != null">
    <dl class="sm-work-counts"><div><dt>받은 신청</dt><dd><s:property value="work.received"/>건</dd></div><div><dt>보낸 신청</dt><dd><s:property value="work.sent"/>건</dd></div></dl>
    <s:if test="work.project != null"><p>참여 중인 프로젝트<br><strong><s:property value="work.project.title"/></strong></p></s:if>
    <s:else><p>아직 참여 중인 프로젝트가 없습니다.</p></s:else>
   </s:if>
   <s:else><p>받은 신청을 검토하고 함께할 팀을 확정하세요.</p></s:else>
   <a href="hopeList.action">받은 신청</a><a href="MyProjList.action">내 프로젝트</a><a href="MsgList.action">쪽지함</a><a href="guideHome.action">참여 방법 보기</a>
  </aside></div>
 </div>
</div>
</body>
</html>
