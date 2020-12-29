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
	<div class="visual">		
		<div class="v_cts">
			<div class="wrap">
			<h2></h2>
			</div>
		</div>
	</div>
	<!-- content -->
	<!-- 비로그인 -->
	<s:if test="id == null || id == ''">
		<div class="contents clearfix">
		<div class="wrap">
			<div class="box">	
				<div class="search">
					<h3></h3>
					<a class="" href=""> </a>
				</div>		
			</div>
			<div class="box">	
				<div class="search">
					<img src="images/guide.png" alt="가이드"/>
					<h3>가이드</h3>
					<a class="button-style1" href="guideHome.action">Read More</a>
				</div>		
			</div>
		</div>
		</div>
	</s:if>
	
	
	<!-- 팀장로그인 -->
	<s:elseif test="auth == 1">
		<div class="contents clearfix">
		<div class="wrap">
			<div class="box">	
				<div class="search">
					<img src="images/search_1.png" alt="사람찾기"/>
					<h3>프리랜서찾기</h3>
					<a class="button-style1" href="SpecList.action">Read More</a>
				</div>		
			</div>
			<div class="box">
				<div class="search">
					<img src="images/proj_reg.png" alt="사람찾기"/>
					<h3>프로젝트 등록하기</h3>
					<a class="button-style1" href="ProjWrite.action">Read More</a>
				</div>	
			</div>
			
			<div class="box">
				<div class="search">
					<img src="images/comp.png" alt="사람찾기"/>
					<h3>대회,공모전</h3>
					<a class="button-style1" href="CompList.action">Read More</a>
				</div>	
			</div>
		</div>
	</div>
	</s:elseif>
	
	
	<!-- 팀원로그인 -->
	<s:elseif test="auth == 2">
		<div class="contents clearfix">
		<div class="wrap">
			<div class="box">
				<div class="search">
					<img src="images/search_2.png" alt="사람찾기"/>
					<h3>프로젝트찾기</h3>
					<a class="button-style1" href="ProjList.action">Read More</a>
				</div>	
			</div>
			<div class="box">
				<div class="search">
					<img src="images/spec_reg.png" alt="사람찾기"/>
					<h3>스펙등록</h3>
					<a class="button-style1" href="SpecList.action">Read More</a>
				</div>	
			</div>
			<div class="box">
				<div class="search">
					<img src="images/comp.png" alt="사람찾기"/>
					<h3>대회,공모전</h3>
					<a class="button-style1" href="CompList.action">Read More</a>
				</div>	
			</div>
		</div>
	</div>
	</s:elseif>
	
</body>
</html>

