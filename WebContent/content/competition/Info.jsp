<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>��ȸ����</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/write.css" />
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2><s:property value="resultClass.title" /></h2>
		</div>
	</div>
		<div class="wrap">
			<table class="writetable">
<%-- 				<tr>
					<td class="list">��ȣ</td>
					<td class="input"><s:property value="resultClass.no" /></td>
				</tr> --%>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.title" /></td>
				</tr>
				<tr>
					<td class="list">������</td>
					<td class="input"><s:property value="resultClass.startdate" /></td>
				</tr>
				<tr>
					<td class="list">�����</td>
					<td class="input"><s:property value="resultClass.regdate" /></td>
				</tr>
				<tr>
					<td class="list">������</td>
					<td class="input"><s:property value="resultClass.enddate" /></td>
				</tr>
				<tr>
					<td class="list">����</td>
					<td class="input"><s:property value="resultClass.cont" /></td>
				</tr>
				<tr>
					<td class="list">�߰�����</td>
					<td class="input"><s:property value="resultClass.contadd" /></td>
				</tr>
<%-- 				<tr>
					<td class="list">��������</td>
					<td class="input"><s:property value="resultClass.showlog" /></td>
				</tr> --%>
				<tr>
					<td class="list">��ȸ��</td>
					<td class="input"><s:property value="resultClass.hits" /></td>
				</tr>
				<tr>
					<td class="list">�̹���</td>
					<td class="input"><img src="/SocialMap/upload/file_<s:property value='resultClass.no'/>.PNG"></td>
				</tr>
				
				<tr class="btn">
					<td colspan="2">
						<input type="button" value="����Ʈ" onclick="javascript:window.location='CompList.action'"/>
						<%-- <input type="button" value="�� ����" onclick="javascript:window.location='CompDelete.action?no=<s:property value="resultClass.no"/>'"/>
						<input type="button" value="�� ����" onclick="javascript:window.location='CompModify.action?step=0&no=<s:property value="resultClass.no"/>'"/>
						<a href="http://localhost:8080/SocialMap/CompList.action">����Ʈ</a>  
						<a href="http://localhost:8080/SocialMap/CompDelete.action?no=<s:property value='resultClass.no'/>">�� ����</a>  
						<a href="http://localhost:8080/SocialMap/CompModify.action?step=0&no=<s:property value='resultClass.no'/>">�� ����</a> --%>
					</td>
				</tr>
			</table>
		</div>
	</div>
<div class="title">
</div>
</body>
</html>