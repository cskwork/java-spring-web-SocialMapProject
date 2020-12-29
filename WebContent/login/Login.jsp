<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/list.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>SocialMap : �α���</title>
	
	<script type="text/javascript" >
		function checkIt() {
			var id = document.getElementById("id").value;
			var pwd = document.getElementById("pwd").value;
			
			if(id == "���̵�" || id == "" || id == null) {
				alert("���̵� �Է����ּ���.");
				
				return false;
			}
			if(pwd == "�н�����" || pwd == "" || pwd == null) {
				alert("�н����带 �Է����ּ���.");
				
				return false;
			}
		}
	</script>
</head>
<body>
<div class="contents clearfix">
<div class="title">
	<div class="wrap">
		<h2>�α���</h2>
	</div>
</div>
	<!-- �н����� Ʋ�� -->
	<s:if test="check == 2">
		<script type="text/javascript">alert("�н����带 Ʋ�Ƚ��ϴ�.")</script>
	</s:if>
	<!-- ���̵� ���� -->
	<s:if test="check == 3">
		<script type="text/javascript">alert("���̵� �����ϴ�.")</script>
	</s:if>
	
	<!-- �α��� �� -->
	<form action="Login.action" method="post" name="form" enctype="multipart/form-data" onsubmit="return checkIt()">
		<s:hidden name="check" value="0" />		
		<table style="margin: auto;" border="0">
			<!-- ���� -->
			<tr style="height: 80px;"></tr>
			
			<tr style="height: 120px;">
				<td align="center">
					<!-- �̹����� ��ü������ �� -->
					<img src="images/logo.png" alt="�Ҽȸ�"/>
				</td>
			</tr>
			
			<tr style="height: 60px;">
				<td>
					<s:textfield name="id" id="id" theme="simple" maxlength="10" cssStyle="width:300px; height:30px;" value="ID" onfocus="this.value=''"/>
				</td>
			</tr>
			
			<tr style="height: 60px;">
				<td>
					<s:password name="pwd" id="pwd" theme="simple" maxlength="10" cssStyle="width:300px; height:30px;" value="password" onfocus="this.value=''" />
				</td>
			</tr>
			
			<tr style="height: 80px;">
				<td>
					<s:submit value="�α���" cssStyle="width:300px; height:50px; font-size:20px;" />
				</td>
			</tr>
			
			<tr align="center">
				<td style="font-size: 13px;">
					<a href="/SocialMap/Find.action?find=id" style="text-decoration: none;">���̵� ã��</a>
					 | 
					<a href="/SocialMap/Find.action?find=pwd" style="text-decoration: none;">��й�ȣ ã��</a>
					 | 
					<a href="/SocialMap/SignUp.action" style="text-decoration: none;">ȸ������</a>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>
