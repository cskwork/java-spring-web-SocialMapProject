<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>��ȸ����</title>
</head>
<body>
	<table width="100%" height="100%" style="margin: auto;" border="0">
		<tr valign="middle" height="20%">
		<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td align="center"><h2>��ȸ����</h2></td>
			</tr>
		</table>
		</td>
		</tr>
		
		<tr valign="top">
		<td align="center">
		<table width="90%" style="margin: auto;" border="0" cellspacing="0" cellpadding="0">
			<tr height="30px">
				<td width="15%">��ȣ</td>
				<td><s:property value="resultClass.no" /></td>
			</tr>
			<tr height="30px">
				<td>����</td>
				<td><s:property value="resultClass.title" /></td>
			</tr>
			<tr height="30px">
				<td>������</td>
				<td><s:property value="resultClass.startdate" /></td>
			</tr>
			<tr height="30px">
				<td>�����</td>
				<td><s:property value="resultClass.regdate" /></td>
			</tr>
			<tr height="30px">
				<td>������</td>
				<td><s:property value="resultClass.enddate" /></td>
			</tr>
			<tr height="30px">
				<td>����</td>
				<td><s:property value="resultClass.cont" /></td>
			</tr>
			<tr height="30px">
				<td>�󼼳���</td>
				<td><s:property value="resultClass.contadd" /></td>
			</tr>
			<tr height="30px">
				<td>��������</td>
				<td><s:property value="resultClass.showlog" /></td>
			</tr>
			<tr height="30px">
				<td>��ȸ��</td>
				<td><s:property value="resultClass.hits" /></td>
			</tr>
			<tr height="30px">
				<td>�̹���</td>
				<td><img src="/SocialMap/upload/file_<s:property value='resultClass.no'/>.PNG"></td>
			</tr>
			<tr height="30px" align="left">
				<td colspan="3">
					<a href="http://localhost:8080/SocialMap/CompList.action">����Ʈ</a>  
					<a href="http://localhost:8080/SocialMap/CompDelete.action?no=<s:property value='resultClass.no'/>">�� ����</a>  
					<a href="http://localhost:8080/SocialMap/CompModify.action?step=0&no=<s:property value='resultClass.no'/>">�� ����</a>
				</td>
			</tr>
		</table>
		</td>
		</tr>
	</table>
</body>
</html>