<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : ������Ʈ �� ����</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/write.css" />
<script type="text/javascript"></script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2><s:property value="resultClass.title" /></h2>
		</div>
	</div>
		<div class="wrap">
			<table class="writetable">
				<tr>
					<td class="list">���� ID</td>
					<td class="input"><s:property value="resultClass.leaderid" /></td>
				</tr>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.title" /></td>
				</tr>
				<tr>
					<td class="list">ī�װ�</td>
					<td class="input"><s:property value="resultClass.comp" /></td>
				</tr>
				<tr>
					<td class="list">������</td>
					<td class="input"><s:property value="resultClass.startdate" /></td>
				</tr>
				<tr>
					<td class="list">������</td>
					<td class="input"><s:property value="resultClass.enddate" /></td>
				</tr>
				<tr>
					<td class="list">�����ο�</td>
					<td class="input"><s:property value="resultClass.recmem" /></td>
				</tr>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.maj" /></td>
				</tr>
				<tr height="100">
					<td class="list">����</td>
					<td class="input"><textarea disabled="disabled" onfocus="this.blur()" rows="10" style="border:none; overflow: hidden;" ><s:property value='resultClass.cont' /></textarea></td>
				</tr>
				<tr>
					<td class="list">�����ο�</td>
					<td class="input"><s:property value="resultClass.currmem" /></td>
				</tr>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.loc" /></td>
				</tr>
				<tr>
					<td class="list">�ӱ�</td>
					<td class="input"><s:property value="resultClass.sal" />��</td>
				</tr>
				
				<tr class="btn">
					<td colspan="2">
						<s:if test="auth == 2">
							<!-- ������ ������ ������Ʈ ��� �� �����Ͽ� �����ϱ� -->
							<input type="button" value="������Ʈ ���� ���" onclick="javascript:window.location='ProjHopeMsg.action?getid=${resultClass.leaderid}'"/>
						</s:if>

						<input type="button" value="����Ʈ�� ���ư���" onclick="javascript:window.location='ProjList.action'"/>
						
						<s:if test="id == resultClass.leaderid">
							<input type="button" value="������Ʈ ����" onClick="" >
							<input type="button" value="������Ʈ ����" onClick="" >
						</s:if>
						
						<%-- <input type="button" value="�� ����" onclick="javascript:window.location='ProjDelete.action?leaderid=<s:property value="resultClass.leaderid"/>&teamno=<s:property value="resultClass.teamno"/>'"/>
						<input type="button" value="������Ʈ ����" onClick="javascript:location.href='ProjModify.action?step=0&teamno=<s:property value='teamno'/>'" > --%>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>