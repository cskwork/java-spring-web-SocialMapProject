<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>ID �ߺ�Ȯ��</title>
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
				<td height="39"><s:property value="id"/>�� �̹� ������� ���̵��Դϴ�.</td>
			</tr>
		</table>
		<form action="ConfirmId.action" method="post" >
			<table style="width: 270px; border: 0; cellspacing: 0; cellpadding: 5;">
				<tr>
					<td align="center">�ٸ� ���̵� �����ϼ���.
						<p>
							<input type="text" size="10" maxlength="12" name="id">
							<input type="submit" value="ID�ߺ�Ȯ��">
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
						�Է��Ͻ� <s:property value="id"/>�� ����Ͻ� �� �ִ� ID�Դϴ�.
					</p> 
					<input type="button" value="�ݱ�" onclick="sendid('<s:property value="id"/>')" />
				</td>
			</tr>
		</table>
	</s:elseif>
</body>
</html>
