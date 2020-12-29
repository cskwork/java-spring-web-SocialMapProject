<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>비밀번호 확인</title>
</head>
<body>
<h2>비밀번호 확인</h2>

<form action="checkPwd.action" method="post">
	<table width="250" border="0" cellspacing="0" cellpadding="0">
		<tr bgcolor="#777777">
			<td height="1" colspan="2"></td>
		</tr>
		<tr>
			<td width="100" bgcolor="f4f4f4">비밀번호 입력</td>
			<td width="150" bgcolor="#ffffff">
			<s:hidden value="resultClass.id"/>
				&nbsp;&nbsp;<s:textfield name="pwd" theme="simple" cssStyle="width:100px" maxlength="20" />
				&nbsp;&nbsp;<input name="submit" type="submit" value="확인" class="inputb">
			</td>
		</tr>
		<tr bgcolor="#777777">
			<td height="1" colspan="2"></td>
		</tr>
	</table>
</form>
</body>
</html>