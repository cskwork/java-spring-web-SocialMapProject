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
			 
			// ���� css���� �÷��� ��� ��ġ(top)���� ������ �����Ѵ�.
			var floatPosition = parseInt($(".floatMenu").css('top'));
			// 250px �̷������� �������Ƿ� ���⼭ ���ڸ� �����´�. parseInt( �� );
		 
			$(window).scroll(function() {
				// ���� ��ũ�� ��ġ�� �����´�.
				var scrollTop = $(window).scrollTop();
				var newPosition = scrollTop + floatPosition + "px";
		 
				/* �ִϸ��̼� ���� �ٷ� ����
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
		    var ask = window.confirm("���� ����� �ʿ��մϴ�!");
		    if (ask) {
		        window.alert("���� ��� �������� �̵��մϴ�.");

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
	<!-- ��α��� -->
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
					<img src="images/guide.png" alt="���̵�"/>
					<h3>���̵�</h3>
					<a class="button-style1" href="guideHome.action">Read More</a>
				</div>		
			</div>
		</div>
		</div>
	</s:if>
	
	
	<!-- ����α��� -->
	<s:elseif test="auth == 1">
		<div class="contents clearfix">
		<div class="wrap">
			<div class="box">	
				<div class="search">
					<img src="images/search_1.png" alt="���ã��"/>
					<h3>��������ã��</h3>
					<a class="button-style1" href="SpecList.action">Read More</a>
				</div>		
			</div>
			<div class="box">
				<div class="search">
					<img src="images/proj_reg.png" alt="���ã��"/>
					<h3>������Ʈ ����ϱ�</h3>
					<a class="button-style1" href="ProjWrite.action">Read More</a>
				</div>	
			</div>
			
			<div class="box">
				<div class="search">
					<img src="images/comp.png" alt="���ã��"/>
					<h3>��ȸ,������</h3>
					<a class="button-style1" href="CompList.action">Read More</a>
				</div>	
			</div>
		</div>
	</div>
	</s:elseif>
	
	
	<!-- �����α��� -->
	<s:elseif test="auth == 2">
		<div class="contents clearfix">
		<div class="wrap">
			<div class="box">
				<div class="search">
					<img src="images/search_2.png" alt="���ã��"/>
					<h3>������Ʈã��</h3>
					<a class="button-style1" href="ProjList.action">Read More</a>
				</div>	
			</div>
			<div class="box">
				<div class="search">
					<img src="images/spec_reg.png" alt="���ã��"/>
					<h3>������</h3>
					<a class="button-style1" href="SpecList.action">Read More</a>
				</div>	
			</div>
			<div class="box">
				<div class="search">
					<img src="images/comp.png" alt="���ã��"/>
					<h3>��ȸ,������</h3>
					<a class="button-style1" href="CompList.action">Read More</a>
				</div>	
			</div>
		</div>
	</div>
	</s:elseif>
	
</body>
</html>

