<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>전공 검색</title>
<script>
	function sendMajor(maj) {
		opener.document.userinput.maj.value = maj;
		self.close();
	}
</script>
</head>
<body>
	<table class="tstyle_list">
		<tr>
			<td align="center">
				<form method="post">
					<br><br> 전공 입력 :
					<s:textfield name="search" theme="simple" maxlength="10"/>
					<input type="submit" value="검색"/>
				</form>
				<br><br><br>
			</td>
		</tr>
			<s:iterator value="list" status="stat">
				<tr align="center" class="a">
					<td><s:a href="javascript:sendMajor('%{major_name}')"><s:property value="major_name"/></s:a></td>
				</tr>
			</s:iterator>
		<tr>
			<td align="center"><br><a href="javascript:this.close();">닫기</a></td>
		</tr>
	</table>
</body>
</html>