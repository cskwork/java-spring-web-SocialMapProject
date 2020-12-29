<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>��������</title>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>��������</h2>
		</div>
	</div>
	<div class="wrap">
		<div class="sidebox">
			<h2>Help Desk</h2>
			<ul>
				<li><a href="QnaList.action">Q&A</a></li>
				<li><a href="FAQList.action">FAQ</a></li>
				<li><a href="ASList.action">��������</a></li>
			</ul>
		</div>
		<div class="detailbox">
			<%--�� ����� �����ڸ� --%>
			<%-- <div class="write">
				<input type="button" value="���������ۼ�" class="submit" onClick="javascript:location.href='ASWrite.action.action?custlog=<s:property value="custlog" />'">
			</div> --%>
			<div class="table board_list">
				<table class="tstyle_list">
					<colgroup>
						<col width="10%">
						<col width="*">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<tr>
						<th scope="col">��ȣ</th>
						<th scope="col">����</th>
						<th scope="col">��¥</th>
						<th scope="col">��ȸ��</th>
					</tr>
					
					<s:if test="list.size() <= 0">
						<tr>
							<td colspan="4">��ϵ� �Խù��� �����ϴ�.</td>
						</tr>
					</s:if>
					
					<s:iterator value="list" status="stat">
						<s:url id="viewURL" action="ASInfo">
							<s:param name = "custlog">
								<s:property value="custlog"/>
							</s:param>
							<s:param name="no">
								<s:property value="no"/>
							</s:param>
						</s:url>
						<tr class="a">
							<td><s:property value="no" /></td>
							<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
							<td><s:property value="regdate" /></td>
							<td><s:property value="hits" /></td>
						</tr>
					</s:iterator>
					
					<tr align="center" style="background-color:#f5f5ff;">
						<td colspan="4"><s:property value="pagingHtml" escape="false" /></td>
					</tr>
				</table>
			</div>
			<div class="board_search">
				<form method="post">
					<select name="searchnum">
						<option value="0">����</option>
						<option value="1">����+����</option>
					</select>
					
					<s:textfield name="search" theme="simple" value="" cssStyle=" width: 320px; height: 35px; border-radius: 0;"/>	
					<input name="submit" type="submit" value="�˻��ϱ�" class="submit"/>
				</form>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
	<%-- <tr align="left">
			<td>
				<a href="http://localhost:8080/SocialMap/ASList.action">�׼�</a>
			</td>
			<td>
				<a href="http://localhost:8080/SocialMap/ASWrite.action">���ۼ�</a>
			</td>
		</tr> --%>
</body>
</html>