<!-- 2018-11-13 ����ȣ -->
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>FAQ</title>
</head>
<body>
	<table width="600" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="center"><h2>FAQ</h2></td>
		</tr>
		<tr>
			<td height="20" />
		</tr>
	</table>
	<table width="600" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>����</td>
			<td><s:property value="resultClass.custlog" /></td>
		</tr>
		<tr>
			<td>����</td>
			<td><s:property value="resultClass.title" /></td>
		</tr>
		<tr>
			<td>��ȸ</td>
			<td><s:property value="resultClass.cont" /></td>
		</tr>
		<tr>
			<td>��¥</td>
			<td><s:property value="resultClass.regdate" /></td>
		</tr>
		<tr>
			<td>��ȸ</td>
			<td><s:property value="resultClass.hits" /></td>
		</tr>
		<tr>
			<td>��ȣ</td>
			<td><s:property value="resultClass.no" /></td>
		</tr>
		<tr align="left">
			<td>
				<a href="http://localhost:8080/SocialMap/FAQList.action">����Ʈ</a>
			</td>
			<td>
				<a href="http://localhost:8080/SocialMap/FAQDelete.action?custlog=<s:property value='custlog'/>&&no=<s:property value='no'/>">�� ����</a>
			</td>
			<td>
				<a href="http://localhost:8080/SocialMap/FAQModify.action?custlog=<s:property value='custlog'/>&no=<s:property value='no'/>">�� ����</a>
			</td>
		</tr>
	</table>
</body>
</html>