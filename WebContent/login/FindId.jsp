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
	<title>SocialMap : ȸ��ã��</title>
	
	<script type="text/javascript" >
		function checkIt() {
			var frm = document.form;
			
			if(frm.name.value == "�̸�" | frm.name.value == "") {
				alert("�̸��� �Է����ּ���.");
				
				return false;
			} else if(frm.email.value == "E-mail" | frm.email.value == "") {
				alert("E-mail�� �Է����ּ���.");
				
				return false;
			}
		}
	</script>
</head>
<body>
<div class="contents clearfix">
<div class="title">
	<div class="wrap">
		<h2>ȸ������ ã��</h2>
	</div>
</div>
	<!-- �α��� �㰡 -->
	<s:if test="check == 1">
		<script type="text/javascript"> location.href="/SocialMap/login/Result.jsp"; </script>
	</s:if>
	
	<s:else>
		<!-- ȸ�� ���� ���� -->
		<s:if test="check == 2">
			<script type="text/javascript">alert("�Էµ� ������ ��ġ�Ǵ� ȸ�� ������ �����ϴ�");</script>
		</s:if>
		
		<!-- �α��� �� -->
		<form action="Find.action" method="post" name="form" enctype="multipart/form-data" onsubmit="return checkIt();">
			<s:hidden name="step" value="1" />
			
			<table style="margin: auto;" border="0">
				<!-- ���� -->
				<tr style="height: 80px;"></tr>
			</table>
			
			<table style="width:450px; margin: auto;">
				<tr>
					<td>
						<input type="button" value="���̵� ã��" style="width: 200px; height: 40px;"  onclick="location.href='/SocialMap/Find.action?find=id'"/> 
					</td>
					<td width="50px" align="center">
					|
					</td>
					<td>
						<input type="button" value="��й�ȣ ã��" style="width: 200px; height: 40px;" onclick="location.href='/SocialMap/Find.action?find=pwd'"/>
					</td>
				</tr>
			</table>		
			
			<table style="margin: auto;">
				<!-- ���� -->
				<tr style="height: 80px;" />
				
				<tr style="height: 60px;">
					<td><s:textfield name="name" theme="simple" maxlength="10" cssStyle="width:300px; height:30px;" value="�̸�" onfocus="this.value=''" /></td>
				</tr>
				
				<tr style="height: 60px;">
					<td><s:textfield name="email" theme="simple" maxlength="20" cssStyle="width:300px; height:30px" value="E-mail" onfocus="this.value=''" /></td>
				</tr>
				
				<tr>
					<td><s:submit value="ã��" cssStyle="width:300px; height:50px; font-size:20px;" /></td>
				</tr>
			</table>
		</form>
	</s:else>
</div>
<div class="title">
</div>
</body>
</html>
