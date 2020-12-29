<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>ID 중복확인</title>
	<script type="text/javascript">
		function sendid(id) {
			opener.document.userinput.id.value = id;
			opener.document.userinput.submit.disabled = false;
			
			self.close();
		}
	</script>
</head>
<body>
	<s:if test="check == 1">
		<table style="width: 270px; border: 0; cellspacing: 0; cellpadding: 5;" >
			<tr></tr>
			<tr>
				<td height="39"><s:property value="id"/>는 이미 사용중인 아이디입니다.</td>
			</tr>
		</table>
		<form action="ConfirmId.action" method="post" >
			<table style="width: 270px; border: 0; cellspacing: 0; cellpadding: 5;">
				<tr>
					<td align="center">다른 아이디를 선택하세요.
						<p>
							<input type="text" size="10" maxlength="12" name="id">
							<input type="submit" value="ID중복확인">
						</p>
					</td>
				</tr>
			</table>
		</form>
	</s:if>
	
	<s:elseif test="check == 0">
		<table style="width: 270px; border: 0; cellspacing: 0; cellpadding: 5;">
			<tr>
				<td align="center">
					<p>
						입력하신 <s:property value="id"/>는 사용하실 수 있는 ID입니다.
					</p> 
					<input type="button" value="닫기" onclick="sendid('<s:property value="id"/>')" />
				</td>
			</tr>
		</table>
	</s:elseif>
</body>
</html>
