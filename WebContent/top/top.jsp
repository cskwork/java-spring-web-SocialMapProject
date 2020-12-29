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
						<a href="#n">����ϱ�</a>
						<div>
							<ul>
								<li><a href="ProjWrite.action">������Ʈ���</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">ã��</a>
						<div>
							<ul>
								<li><a href="ProjList.action">������Ʈ ���</a></li>
								<li><a href="SpecList.action">�������� ���</a></li>
								<li><a href="CompList.action">��ȸ/���������</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">Guide</a>
						<div>
							<ul>
								<li><a href="">��������/������Ʈ ��Ϲ��</a></li>
								<li><a href="">������Ʈ/���� ã�¹��</a></li>
								<li><a href="">������Ʈ �������</a></li>
								<li><a href="modifyMemberForm.action">ȸ������ ����/Ż��</a></li>
							</ul>
						</div>
					</li>

					<!-- <li class="on">
						<a href="#n">����</a>
						<div>
							<ul>
								<li><a href="#n">����޴�</a></li>
								<li><a href="#n">����޴�</a></li>
								<li><a href="#n">����޴�</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">����</a>
						<div>
							<ul>
								<li><a href="#n">����޴�</a></li>
								<li><a href="#n">����޴�</a></li>
								<li><a href="#n">����޴�</a></li>
							</ul>
						</div>
					</li>
					<li class="on">
						<a href="#n">����</a>
						<div>
							<ul>
								<li><a href="#n">����޴�</a></li>
								<li><a href="#n">����޴�</a></li>
								<li><a href="#n">����޴�</a></li>
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
					<a class="login" href="Login.action">�α���</a>
					<img src="images/login.png" alt="�α���" />
				</s:if>
		
				<s:else>
					<a class="greet"><s:property value="#session.name"/>�� ȯ���մϴ�.<br /></a>
					<div class="my">
						<a href="MyPage.action">���������� </a> | 
						<a href="#" onClick="window.open('MsgList.action','����','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">����</a> |  
						<a href="Logout.action">�α׾ƿ�</a>
					</div>
				</s:else>
			</div>
		</div>
	</div>
</body>
</html>
