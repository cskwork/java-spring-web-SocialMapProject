<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : ������Ʈ �� ����</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/write.css">
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
		function majorCheck(){
			url="http://localhost:8080/SocialMap/Major.action";
			window.open(url,"post","toolbar=no ,width=350 ,height=400 ,directories=no,status=yes,scrollbars=yes,menubar=no");
		}
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>������Ʈ ����ϱ�</h2>
		</div>
	</div>
		<div class="wrap">
			<s:if test="step == 2">
				<script type="text/javascript">location.href="ProjList.action?check=<s:property value='check'/>";</script>
				
			</s:if>
			
			<s:else>
				<form action="ProjWrite.action" method="post" name="userinput" enctype="multipart/form-data" onsubmit="return validation();">
					<table class="writetable">
						<tr>
							<td class="list">���� ID</td>
							<td class="input"><s:property value='#session.id'/></td>
						</tr>
						<tr>
							<td class="list">�� ����</td>
							<td class="input"><input type="text" name="title" maxlength="30" value="<s:property value='resultClass.title'/>"></td>
						</tr>
						<tr>
							<td class="list">��ȸ �� ������ ��ȹ</td>
							<td class="input"><input type="text" name="comp" maxlength="10" value="<s:property value='resultClass.comp'/>"></td>
						</tr>
						<tr>
							<td class="list">������</td>
							<td class="input"><input type="date" name="startdate" value="<s:property value='resultClass.startdate'/>"></tr>
						<tr>
						
						<tr>
							<td class="list">������</td>
							<td class="input"><input type="date" name="enddate" value="<s:property value='resultClass.enddate'/>"></tr>
						<tr>

						<tr>
							<td class="list">�����ο�</td>
							<td class="input"><input type="text" name="recmem" maxlength="2" value="<s:property value='resultClass.recmem'/>"></td>
						</tr>
						<tr>
							<td class="list">��������</td>
							<td class="input">
								<input type="text" name="maj" maxlength="50"><%--  value="<s:property value='resultClass.maj'/> --%>
								<input type="button" onclick="majorCheck()" value="���� ã��" />
							</td>
						</tr>
						
						<tr>
							<td class="list">�� ����</td>
							<td class="input"><s:textarea theme="simple" rows="4" cols="50" name="cont" value='%{resultClass.cont}'/></td><!--  style="overflow: hidden;" -->
						</tr>
						
						<tr>
							<td class="list">����</td>
							<td class="input"><input type="text" name="loc" maxlength="20" value="<s:property value='resultClass.loc'/>"></td>
						</tr>
						
						<tr>
							<td class="list">�ӱ�</td>
							<td class="input"><input type="text" name="sal" maxlength="6" value="<s:property value='resultClass.sal'/>"></td>
						</tr>
						
						<tr class="btn">
							<td colspan="2">
								<s:hidden value="1" name="step"/>
								<input type="button" value="��    ��" onclick="javascript:window.location='ProjList.action'" >
								<input type="submit" value="�ۼ��ϱ�">
							</td>
						</tr>
					</table>
				</form>
			</s:else>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>