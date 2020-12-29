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
	<title>SocialMap : 회원 찾기 결과</title>
	
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>회원정보 찾기</h2>
		</div>
	</div>
	<table style="margin: auto;">
		<tr height="100px" valign="bottom">
			<td>회원님의 아이디는 </td>
			<td><font color="#0000ff" style="font-weight:800; font-size:25px;"><s:property value="resultClass.id" /></font>입니다.</td> 
		</tr>
		<s:if test="step == 2">
			<tr>
				<td>비밀번호</td>
				<td><font color="#0000ff" style="font-weight:800; font-size:25px;"><s:property value="resultClass.pwd" /></font></td>
			</tr>
		</s:if>
		<tr>
			<td colspan="2" align="center" style="padding-top:25px;">
				<a href="Login.action" style="text-decoration: none;"><strong>로그인</strong></a>
			</td>
		</tr>
	</table>
</div>
<div class="title"></div>
</body>
</html>
