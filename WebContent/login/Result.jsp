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
	<title>SocialMap : ȸ�� ã�� ���</title>
	
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>ȸ������ ã��</h2>
		</div>
	</div>
	<table style="margin: auto;">
		<tr height="100px" valign="bottom">
			<td>ȸ������ ���̵�� </td>
			<td><font color="#0000ff" style="font-weight:800; font-size:25px;"><s:property value="resultClass.id" /></font>�Դϴ�.</td> 
		</tr>
		<s:if test="step == 2">
			<tr>
				<td>��й�ȣ</td>
				<td><font color="#0000ff" style="font-weight:800; font-size:25px;"><s:property value="resultClass.pwd" /></font></td>
			</tr>
		</s:if>
		<tr>
			<td colspan="2" align="center" style="padding-top:25px;">
				<a href="Login.action" style="text-decoration: none;"><strong>�α���</strong></a>
			</td>
		</tr>
	</table>
</div>
<div class="title"></div>
</body>
</html>
