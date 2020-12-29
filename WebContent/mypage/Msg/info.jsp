<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<style type="text/css">
		.msg input {
			border:none;
		}
		.msg textarea {
			border: none;
			resize: none;
			font-size: 1em;
		}
	</style>
	
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/list.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>쪽지 쓰기</title>
</head>
<body>	
	<table style="width: 670px; height: 600px; border-spacing: 0; padding: 0; margin: auto;" border="1">
	<tr valign="middle" height="10%">
	<td>
		<form action="MsgList.action" name="form" method="post" enctype="multipart/form-data" >
			<table style="margin: auto; width: 100%;" border="0">
				<tr>
					<td align="left">
						<a href="MsgWrite.action">쪽지쓰기</a>
						<a href="MsgList.action">받은쪽지  </a>
						<a href="javascript:document.log.submit();">보낸쪽지  </a>
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
	<form action="MsgList.action" method="post"  >
		<s:hidden value="1" name="step" />
		
		<table style="margin: auto;" border="0" class="msg">
			<tr height="40px">
				<td width="100px" align="center">제목</td>
				<td>
					<table>
						<tr>
						<td width="500px">
							<font size="2"><s:property value="%{resultClass.title}" /></font>
						</td>
						</tr>
					</table>
					
				</td>
			</tr>
			
			<tr height="40px">
				<s:if test="check == 1">
					<td align="center">받는 사람</td>
					<td>
						<font size="2"><s:property value="%{resultClass.getid}" /></font>
					</td>
				</s:if>
				<s:else>
					<td align="center">보낸 사람</td>
					<td>
						<font size="2"><s:property value="%{resultClass.sendid}" /></font>
					</td>
				</s:else>
			</tr>
			
			<tr height="300px" valign="top">
				<td align="center">내용</td>
				<td>
					<s:textarea theme="simple" name="cont" value="%{resultClass.cont}" readonly="true" cols="60" rows="15" />
				</td>
			</tr>
			
			<tr>
				<td align="right" colspan="2">
					<s:submit theme="simple" value="목록" />
				</td>
			</tr>
		</table>
	</form>
	</td>
	</tr>
	</table>
</body>
</html>