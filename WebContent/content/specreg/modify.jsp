<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : �������� ����</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/write.css">
	<script type="text/javascript">
		function validation() {
			var frm = document.forms(0);
			if(frm.title.value == "") {
				alert("������ �Է����ּ���");
				return false;
			}
			else if(frm.cont.value == "") {
				alert("������ �Է����ּ���");
				return false;
			}
			return true;
		}
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>������Ʈ �����ϱ�</h2>
		</div>
	</div>
		<div class="wrap">
			<s:if test="step == 2">
				<script type="text/javascript">location.href="SpecList.action";</script>
			</s:if>
			<s:else>
				<form action="SpecModify.action" method="post" enctype="multipart/form-data" onsubmit="return validation();">
					<table class="writetable">
						<tr>
							<td class="list">ID</td>
							<td class="input"><s:property value='id'/></td>
						</tr>
						<tr>
							<td class="list">�����̷�</td>
							<td class="input"><input type="text" name="exp" maxlength="30" value="<s:property value='resultClass.exp'/>"></td>
						</tr>
						<tr>
							<td class="list">����</td>
							<td class="input"><input type="text" name="maj" maxlength="10" value="<s:property value='resultClass.maj'/>"></td>
						</tr>
						<tr>
							<td class="list">����</td>
							<td class="input"><input type="text" name="addr" value="<s:property value='resultClass.addr'/>"></tr>
						<tr>
						<tr>
							<td class="list">�߰�����</td>
							<td class="input"><input type="text" name="contadd" value="<s:property value='resultClass.contadd'/>"></tr>
						<tr>
						<tr>
							<td class="list">��������</td>
							<td class="input"><input type="text" name="showlog" maxlength="2" value="<s:property value='resultClass.showlog'/>"></td>
						</tr>
				
						
						<tr class="btn">
							<td colspan="2">
								<s:hidden value="1" name="step"/>
								<s:hidden value="%{teamno}" name="teamno"/>
								<input type="button" value="��    ��" onclick="javascript:window.location='SpecInfo.action?id=<s:property value='id'/>'">
								<input type="submit" value="���� �Ϸ�">
							</td>
						</tr>
					</table>
				</form>
			</s:else>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>