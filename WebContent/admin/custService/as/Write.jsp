<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�������� - �� ���</title>
</head>
	<script type="text/javascript">
		function validation() {
			var frm = document.forms(0);
			if(frm.title.value == "") {
				alert("������ �Է����ּ���");
				return false;
			}
			else if(frm.cont.value == "") {
				alert("������ �Է����ּ���");
				return false;
			}
			return true;
		}
	</script>
<body>
	<s:if test="step == 2 && no == 0">
		<script type="text/javascript">location.href="ASList.action";</script>
	</s:if>
	
	<s:elseif test="step == 2 && no != 0">
		<script type="text/javascript">location.href="ASInfo.action?no=<s:property value='no'/>";</script>
	</s:elseif>
	
	<s:else>
		<s:if test="no == 0">
			<form action="ASWrite.action" method="post" onsubmit="return validation();" >
		</s:if>
		
		<s:else>
			<form action="ASModify.action" method="post" onsubmit="return validation();" >
				<s:hidden name="no" value="%{no}" />
				<s:hidden name="custlog" value="%{custlog}" />
		</s:else>
			<table border="1" align="center">
				<s:if test="no == 0">
					<tr>
						<td>
							<select name="custlog">
								<option value="0">��������</option>
								<option value="1">FAQ</option>
							</select>
						</td>
					</tr>
				</s:if>
				<tr>
					<td align="center" width="150">����</td>
					<td align="center" width="400">
						<s:textfield name="title" theme="simple" value="%{resultClass.title}" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td align="center" valign="middle">����</td>
					<td align="center" valign="middle">
						<s:textarea name="cont" theme="simple" value="%{resultClass.cont}" rows="8" cols="60" />
					</td>
				</tr>
				<tr>
					<td colspan="2" align="right">
						<input type="hidden" value="1" name="step">
						<input type="submit" value="�۵��" >
					</td>
				</tr>
				<tr>
					<td colspan="2" align="left">
						<s:if test="no == 0">
							<s:a href="http://localhost:8080/SocialMap/ASList.action?currentPage=%{currentPage}">����Ʈ</s:a>
						</s:if>
						<s:else>
							<s:a href="http://localhost:8080/SocialMap/ASInfo.action?no=%{no}">��</s:a>
						</s:else>
					</td>
				</tr>
			</table>
		</form>
	</s:else>
</body>
</html>