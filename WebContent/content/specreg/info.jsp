<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SocialMap : ������Ʈ �� ����</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/write.css" />
<script>
	function favList() {
		location.href="favSpec.action?id=<s:property value='resultClass.id'/>";
	}
</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>�������� �󼼺���</h2>
		</div>
	</div>
		<div class="wrap">
			<table class="writetable">
				<tr>
					<td class="list">�������� ID</td>
					<td class="input"><s:property value="resultClass.id" /></td>
				</tr>
				<tr>
					<td class="list">�����</td>
					<td class="input"><s:property value="resultClass.regdate" /></td>
				</tr>
				<tr>
					<td class="list">���� �̷�</td>
					<td class="input"><s:property value="resultClass.exp" /></td>
				</tr>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.maj" /></td>
				</tr>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.addr" /></td>
				</tr>
				<tr>
					<td class="list">�߰�����</td>
					<td class="input"><s:property value="resultClass.contadd" /></td>
				</tr>
				<tr>
					<td class="list">����/�����</td>
					<td class="input"><s:property value="resultClass.showlog" /></td>
				</tr>
				
				<tr class="btn">
					<td colspan="2">
						<!-- �� ���� ���� ��ư -->
						<s:if test="auth == 1">
						<!-- ������ ������ ������Ʈ ��� �� �����Ͽ� �����ϱ� -->
						<input type="button" value="������Ʈ ���� ����" onclick="javascript:window.location='SpecHopeMsg.action?getid=${resultClass.id}'"/>
						</s:if>
						
						<input type="button" value="����Ʈ" onclick="javascript:window.location='SpecList.action'"/>
						<input type="button" value="�� ����" onclick="javascript:window.location='SpecDelete.action?id=<s:property value="resultClass.id"/>'"/>
						<input type="button" value="�� ����" onclick="javascript:window.location='SpecModify.action?step=0&id=<s:property value="resultClass.id"/>'"/>
						<s:hidden value="resultClass.id" />
						<input type="button" value="��ũ���ϱ�" onclick="favList()"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>