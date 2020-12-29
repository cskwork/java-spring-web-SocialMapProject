<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Qna</title>
	<script type="text/javascript">
		function open_win_noresizable(url, name) {
			var oWin = window.open(url, name, "scrollbars=no, status=no, resizable=no, width=300, height=150");
		}
	</script> 
</head>
<body>
<table width="100%" height="100%" style="margin: auto;" border="0">
	<tr height="10%" valign="top">
	<td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="center" class="text01 formbar"><h2>QnA</h2></td>
		</tr>
	</table>
	</td>
	</tr>
	
	<tr height="70%" valign="top">
	<td>
	<table width="100%" border="0" cellspacing="0" cellpadding="2" id="form">
		<tr align="center" height="50px">
			<td width="15%"  align="center"><strong>작성자</strong></td>
			<td width="55%" align="center"><strong>제목</strong></td>
			<td width="20%" align="center"><strong>날짜</strong></td>
		</tr>
		
		<s:if test="list.size() <= 0">
			<tr bgcolor="#FFFFFF" align="center">
				<td colspan="3">등록된 게시물이 없습니다.</td>
			</tr>
			<tr bgcolor="#777777">
				<td height="1" colspan="3"></td>
			</tr>
		</s:if>
		
		<s:iterator value="list" status="stat">
			<s:if test="qalog == 0">
				<s:url id="viewURL" action="QnaInfo">
					<s:param name="no">
						<s:property value="no" />
					</s:param>
					<s:param name="currentPage">
						<s:property value="currentPage" />
					</s:param>
				</s:url>
				
				<tr height="50px">
					<td align="center" ><s:property value="id" /></td>
					<td align="left"><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>	
					<td align="center"><s:property value="regdate" /></td>
				</tr>
			</s:if>
		</s:iterator>  
	</table>
	</td>
	</tr>
	
	<tr height="30%" valign="top">
	<td>		
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="left">
				<%-- <input type="button" value="질문 작성" class="submit" onClick="javascript:location.href='QnaWrite.action?currentPage=<s:property value="currentPage" />&no=<s:property value="no" />'"> --%>
			</td>
		</tr>
		
		<tr height="50" align="center">
			<td colspan="3"><s:property value="pagingHtml" escape="false" /></td>
		</tr>
		<tr align="center">
			<td colspan="3">
				<form method="post">
					<select name="searchnum" Style="width:100px; height:30px;">
						<option value="0">제목</option>
						<option value="1">작성자ID</option>

					</select>
					<s:textfield name="search" theme="simple" value="" cssStyle="width:200px; height:30px;" maxlength="20" />
					
					<input name="submit" type="submit" value="검색" class="submit"/>
				</form>
			</td>
		</tr>
		<tr>
			<td>
				<a href="/SocialMap/admin/adminPageHome.jsp">관리자 페이지</a>
			</td>
		</tr>
	</table>
	</td>
	</tr>
</table>
</body>
</html>







