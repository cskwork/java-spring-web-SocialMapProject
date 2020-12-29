<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
	<script type="text/javascript">
		function locationURL()
		{	
			alert('삭제 되었습니다.');
			/* window.opener.parent.location.href="deleteMember.action?id=<s:property value="id"/>"; */
			window.opener.parent.location.href="deleteMember.action";
			window.close();	
		}
	</script>
</head>
<body>
	<script>locationURL()</script>
</body>
</html>