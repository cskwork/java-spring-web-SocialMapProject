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
	<title>SocialMap : 로그인</title>
	
	<script type="text/javascript" >
		function checkIt() {
			var id = document.getElementById("id").value;
			var pwd = document.getElementById("pwd").value;
			
			if(id == "아이디" || id == "" || id == null) {
				alert("아이디를 입력해주세요.");
				
				return false;
			}
			if(pwd == "패스워드" || pwd == "" || pwd == null) {
				alert("패스워드를 입력해주세요.");
				
				return false;
			}
		}
	</script>
</head>
<body>
<div class="contents clearfix">
<div class="title">
	<div class="wrap">
		<h2>로그인</h2>
	</div>
</div>
	<!-- 패스워드 틀림 -->
	<s:if test="check == 2">
		<script type="text/javascript">alert("패스워드를 틀렸습니다.")</script>
	</s:if>
	<!-- 아이디 없음 -->
	<s:if test="check == 3">
		<script type="text/javascript">alert("아이디가 없습니다.")</script>
	</s:if>
	
	<!-- 로그인 폼 -->
	<form action="Login.action" method="post" name="form" enctype="multipart/form-data" onsubmit="return checkIt()">
		<s:hidden name="check" value="0" />		
		<table style="margin: auto;" border="0">
			<!-- 공백 -->
			<tr style="height: 80px;"></tr>
			
			<tr style="height: 120px;">
				<td align="center">
					<!-- 이미지로 대체할지도 모름 -->
					<img src="images/logo.png" alt="소셜맵"/>
				</td>
			</tr>
			
			<tr style="height: 60px;">
				<td>
					<s:textfield name="id" id="id" theme="simple" maxlength="10" cssStyle="width:300px; height:30px;" value="ID" onfocus="this.value=''"/>
				</td>
			</tr>
			
			<tr style="height: 60px;">
				<td>
					<s:password name="pwd" id="pwd" theme="simple" maxlength="10" cssStyle="width:300px; height:30px;" value="password" onfocus="this.value=''" />
				</td>
			</tr>
			
			<tr style="height: 80px;">
				<td>
					<s:submit value="로그인" cssStyle="width:300px; height:50px; font-size:20px;" />
				</td>
			</tr>
			
			<tr align="center">
				<td style="font-size: 13px;">
					<a href="/SocialMap/Find.action?find=id" style="text-decoration: none;">아이디 찾기</a>
					 | 
					<a href="/SocialMap/Find.action?find=pwd" style="text-decoration: none;">비밀번호 찾기</a>
					 | 
					<a href="/SocialMap/SignUp.action" style="text-decoration: none;">회원가입</a>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>
