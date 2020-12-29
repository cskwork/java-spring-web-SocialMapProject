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
	<title>SocialMap : 회원찾기</title>
	
	<script type="text/javascript" >
		function checkIt() {
			var frm = document.form;
			
			if(frm.name.value == "이름" | frm.name.value == "") {
				alert("이름을 입력해주세요.");
				
				return false;
			} else if(frm.email.value == "E-mail" | frm.email.value == "") {
				alert("E-mail을 입력해주세요.");
				
				return false;
			}
		}
	</script>
</head>
<body>
<div class="contents clearfix">
<div class="title">
	<div class="wrap">
		<h2>회원정보 찾기</h2>
	</div>
</div>
	<!-- 로그인 허가 -->
	<s:if test="check == 1">
		<script type="text/javascript"> location.href="/SocialMap/login/Result.jsp"; </script>
	</s:if>
	
	<s:else>
		<!-- 회원 정보 없음 -->
		<s:if test="check == 2">
			<script type="text/javascript">alert("입력된 정보와 일치되는 회원 정보가 없습니다");</script>
		</s:if>
		
		<!-- 로그인 폼 -->
		<form action="Find.action" method="post" name="form" enctype="multipart/form-data" onsubmit="return checkIt();">
			<s:hidden name="step" value="1" />
			
			<table style="margin: auto;" border="0">
				<!-- 공백 -->
				<tr style="height: 80px;"></tr>
			</table>
			
			<table style="width:450px; margin: auto;">
				<tr>
					<td>
						<input type="button" value="아이디 찾기" style="width: 200px; height: 40px;"  onclick="location.href='/SocialMap/Find.action?find=id'"/> 
					</td>
					<td width="50px" align="center">
					|
					</td>
					<td>
						<input type="button" value="비밀번호 찾기" style="width: 200px; height: 40px;" onclick="location.href='/SocialMap/Find.action?find=pwd'"/>
					</td>
				</tr>
			</table>		
			
			<table style="margin: auto;">
				<!-- 공백 -->
				<tr style="height: 80px;" />
				
				<tr style="height: 60px;">
					<td><s:textfield name="name" theme="simple" maxlength="10" cssStyle="width:300px; height:30px;" value="이름" onfocus="this.value=''" /></td>
				</tr>
				
				<tr style="height: 60px;">
					<td><s:textfield name="email" theme="simple" maxlength="20" cssStyle="width:300px; height:30px" value="E-mail" onfocus="this.value=''" /></td>
				</tr>
				
				<tr>
					<td><s:submit value="찾기" cssStyle="width:300px; height:50px; font-size:20px;" /></td>
				</tr>
			</table>
		</form>
	</s:else>
</div>
<div class="title">
</div>
</body>
</html>
