<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>관리자 페이지</title>
	<script>
		function projList() {
			location.href="/SocialMap/ProjList.action";
		}
		function specList() {
			location.href="/SocialMap/SpecList.action";
		}
		function compList() {
			location.href="/SocialMap/CompList.action";
		}
		function qnaList() {
			location.href="/SocialMap/QnaList.action";
		}
		function asList() {
			location.href="/SocialMap/ASList.action";
		}
		function faqList() {
			location.href="/SocialMap/FAQList.action";
		}
	</script>
</head>
<body>
	<table border="1">
		<tr height="60">
			<td>
				<b>관리자 메뉴</b>
			</td>
		</tr>
		<tr height="60">
			<td>
				<input type="button" value="프로젝트 페이지 관리" onclick="projList()"/>
			</td>
		</tr>
		<tr height="60">
			<td>
				<input type="button" value="스펙 등록 페이지 관리" onclick="specList()"/>
			</td>
		</tr>
		<tr height="60">
			<td>
				<input type="button" value="대회 공모 페이지 관리" onclick="compList()"/>
			</td>
		</tr>
		<tr height="60">
			<td>
				<input type="button" value="Q&A 페이지 관리" onclick="qnaList()"/>
			</td>
		</tr>
		<tr height="60">
			<td>
				<input type="button" value="공지사항 페이지 관리" onclick="asList()"/>
			</td>
		</tr>
		<tr height="60">
			<td>
				<input type="button" value="FAQ 페이지 관리" onclick="faqList()"/>
			</td>
		</tr>
		<tr height="60">
			<td>
				<a href="/SocialMap/Logout.action" style="text-decoration: none;"><strong>로그아웃</strong></a>
			</td>
		</tr>
	</table>
</body>
</html>