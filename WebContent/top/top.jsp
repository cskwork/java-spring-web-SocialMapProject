<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>	
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<script src="js/main.js"></script>
	<link rel="stylesheet" href="css/header.css" />
	<script type="text/javascript">
		function scroll(id) {
			var position = $(window).scrollTop();
			$(id).stop().animate({top:position+"px"},1);
		}
	</script>
</head>
<body>
	<div class="header">
		<div class="mobile_gnb">
			<a class="mobilemenu" href="#n"><img src="images/menu.png" alt="menu" /></a>
			<div class="gnb_rbg">
				<ul>
					<li>
						<a href="#n">등록하기</a>
						<div>
							<ul>
								<li><a href="ProjWrite.action">프로젝트등록</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">찾기</a>
						<div>
							<ul>
								<li><a href="ProjList.action">프로젝트 목록</a></li>
								<li><a href="SpecList.action">프리랜서 목록</a></li>
								<li><a href="CompList.action">대회/공모전목록</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">Guide</a>
						<div>
							<ul>
								<li><a href="">프리랜서/프로젝트 등록방법</a></li>
								<li><a href="">프로젝트/팀원 찾는방법</a></li>
								<li><a href="">프로젝트 참여방법</a></li>
								<li><a href="modifyMemberForm.action">회원정보 수정/탈퇴</a></li>
							</ul>
						</div>
					</li>

					<!-- <li class="on">
						<a href="#n">목차</a>
						<div>
							<ul>
								<li><a href="#n">서브메뉴</a></li>
								<li><a href="#n">서브메뉴</a></li>
								<li><a href="#n">서브메뉴</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">목차</a>
						<div>
							<ul>
								<li><a href="#n">서브메뉴</a></li>
								<li><a href="#n">서브메뉴</a></li>
								<li><a href="#n">서브메뉴</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">목차</a>
						<div>
							<ul>
								<li><a href="#n">서브메뉴</a></li>
								<li><a href="#n">서브메뉴</a></li>
								<li><a href="#n">서브메뉴</a></li>
							</ul>
						</div>
					</li> -->
				</ul>
				<a class="close">
					<img src="images/close.png" alt="close" />
				</a>
			</div>
			<div class="gnb_bbg">
			</div>
		</div>
		<div class="wrap">
			<h1><a href="http://localhost:8080/SocialMap/SocialMap.action"><img src="images/logo.png" alt="" /></a></h1>
			<div class="logon">
				<s:if test="#session.id == null || #session.id == ''" >
					<a class="login" href="Login.action">로그인</a>
					<img src="images/login.png" alt="로그인" />
				</s:if>
		
				<s:else>
					<a class="greet"><s:property value="#session.name"/>님 환영합니다.<br /></a>
					<div class="my">
						<a href="MyPage.action">마이페이지 </a> | 
						<a href="#" onClick="window.open('MsgList.action','쪽지','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">쪽지</a> |  
						<a href="Logout.action">로그아웃</a>
					</div>
				</s:else>
			</div>
		</div>
	</div>
</body>
</html>
