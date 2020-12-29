<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
   <link rel="stylesheet" href="css/notice.css" />
   <%-- <style>
	  img.ui-datepicker-trigger {
		  margin-left:5px; vertical-align:middle; cursor:pointer;
	  }
   </style>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/i18n/datepicker-ko.js"></script> --%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>���� ������Ʈ</title>
	<script>
		function view() {
			location.href="modifyMemberForm.action";
		}
		function favList() {
			location.href="favSpecList.action";
		}
		function favProj() {
			location.href="favProjList.action";
		}
		function myProj() {
			location.href="MyProjList.action";
		}
		function hopeList() {
			location.href="hopeList.action";
		}
	</script>
</head>
<body>
<div class="contents clearfix">
   <div class="title">
	  <div class="wrap">
		 <h2>���� ������Ʈ</h2>
	  </div>
   </div>
   <div class="wrap">
		<div class="sidebox">
			<h2>My Page</h2>
			<s:if test="#session.auth == 1">
				<ul>
					<li><a href="javascript:view()">����������/Ż��</a></li>
					<li><a href="javascript:favList()">���ɽ��帮��Ʈ</a></li>
					<!-- <li><a href="javascript:favProj()">������������Ʈ</a></li> -->
					<li><a href="javascript:myProj()">���� ������Ʈ</a></li>
					<li><a href="javascript:hopeList()">���� �����</a></li>
					<li><a href="#" onClick="window.open('RatingList.action','����','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">���� ����</a></li> 
				</ul>
			</s:if>
			<s:elseif test="#session.auth == 2">
				<ul>
					<li><a href="javascript:view()">����������/Ż��</a></li>
					<!-- <li><a href="javascript:favList()">���ɽ��帮��Ʈ</a></li> -->
					<li><a href="javascript:favProj()">������������Ʈ</a></li>
					<li><a href="javascript:myProj()">���� ������Ʈ</a></li>
					<li><a href="javascript:hopeList()">���� ����</a></li>
					<li><a href="#" onClick="window.open('RatingList.action','����','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">���� ����</a></li> 
				</ul>
			</s:elseif>
		</div>
	  <div class="detailbox">
	  <div class="table board_list">
		 <table class="tstyle_list">
			<tr>
			   <th><strong>����ID</strong></th>
			   <th><strong>������Ʈ��</strong></th>
			   <th><strong>ī�װ�</strong></th>
			   <th><strong>������Ʈ �Ⱓ</strong></th>
			   <th><strong>��������ο�/�����ο�</strong></th>
			   <th><strong>����</strong></th>
			   <th><strong>�ӱ�</strong></th>
			</tr>
			
			<s:if test="list.size()<=0">
			   <tr class="no">
				  <td colspan="3">��ϵ� �Խù��� �����ϴ�.</td>
			   </tr>
			</s:if>
			
			<s:iterator value="list" status="stat">
			   <s:url id="viewURL" action="MyProjInfo.action">
				  <s:param name="teamno">
					 <s:property value="teamno"/>
				  </s:param>
			   </s:url>
			   
			   <tr class="a">
				  <s:hidden value="teamno"/>
				  <s:hidden value="leaderid"/>
				  <td><s:property value="leaderid" /></td>
				  <td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
				  <td><s:property value="comp" /></td>
				  <td><s:property value="startdate" /> ~ <s:property value="enddate"/></td>
				  <td><s:property value="currmem"/>/<s:property value="recmem" /></td>
				  <td><s:property value="loc" /></td>
				  <td><s:property value="sal" /></td>
			   </tr>
			</s:iterator>
			 </table>
	  </div>
   </div>
</div>
</div>
<div class="title">
</div>
</body>
</html>