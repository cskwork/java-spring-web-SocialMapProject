<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/list.css" />
	<script type="text/javascript" >

	</script>
</head>
<body>
	<table class="listtable">	
		<tr>
		<td>
			<form action="QnaList.action" name="form" method="post" enctype="multipart/form-data" >
				<s:submit value="Q&A" theme="simple" cssStyle="height:50px; font-size:20px; width:100%;"/>
			</form>
		</td>
		</tr>
		
		<tr>
		<td>
			<form action="FAQList.action" name="form" method="post" enctype="multipart/form-data" >
				<s:submit value="FAQ" theme="simple" cssStyle="height:50px; font-size:20px; width:100%;"/>
			</form>
		</td>
		</tr>
		
		<tr>
		<td>
			<form action="ASList.action" name="form" method="post" enctype="multipart/form-data" >
				<s:submit value="Notice" theme="simple" cssStyle="height:50px; font-size:20px; width:100%;"/>
			</form>
		</td>
		</tr>
	</table>
</body>
</html>
