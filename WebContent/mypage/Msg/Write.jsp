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
	<title>���� ����</title>
</head>
<body>
	<table style="width: 670px; height: 600px; border-spacing: 0; padding: 0; margin: auto;" border="1">
	<tr valign="middle" height="10%">
	<td>
		<form action="MsgList.action" name="form" method="post" enctype="multipart/form-data" >
			<table style="margin: auto; width: 100%;" border="0">
				<tr>
					<td align="left">
						<a href="MsgWrite.action">��������</a>
						<a href="MsgList.action">��������  </a>
						<a href="javascript:document.log.submit();">��������  </a>
					</td>
				</tr>
			</table>
		</form>
		<form action="MsgList.action" name="log" method="post" enctype="multipart/form-data" >
			<s:hidden value="%{#session.id}" name="sendid" />
			<s:hidden value="1" name="check" />
		</form>
	</td>
	</tr>
	
	<tr valign="top" align="center">
	<td>
	<form action="MsgWrite.action" method="post" enctype="multipart/form-data" >
		<s:hidden value="1" name="step"></s:hidden>
		
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td align="center">����</td>
				<td>
					<s:textfield theme="simple" name="title" value="%{title}" maxlength="50" />
				</td>
			</tr>
			<tr>
				<td align="center">�޴� ���</td>
				<td>
					<s:textfield theme="simple" name="getid" value="%{getid}" maxlength="10"/>
					<s:hidden theme="simple" name="sendid" value="%{#session.id}" />
				</td>
			</tr>
			<tr>
				<td align="center">����</td>
				<td>
					<s:textarea theme="simple" name="cont" value="%{cont}" cols="60" rows="15"></s:textarea>
				</td>
			</tr>
			<tr>
				<td align="right" colspan="2">
					<s:submit theme="simple" value ="����"/>
					<s:submit theme="simple" name="method:cancel" value="���"/>
				</td>
			</tr>
		</table>
	</form>
	</td>
	</tr>
	</table>
</body>
</html>