<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>������Ʈ ã�� </title>
</head>
   <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
   <link rel="stylesheet" href="css/list.css" />
   <style>
	  /*datepicker���� ����� �̹��� ��ư style����*/
	  img.ui-datepicker-trigger {
		  margin-left:5px; vertical-align:middle; cursor:pointer;
	  }
   </style>
   <!-- datepicker �ѱ���� -->
   <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/i18n/datepicker-ko.js"></script>
   <script>
	  $(function() {
		 //���� ��¥�� ���
		 $("#today").text(new Date().toLocaleDateString());

		 //datepicker �ѱ���� ����ϱ� ���� ����
		 $.datepicker.setDefaults($.datepicker.regional['ko']); 
		  
		 // ������(fromDate)�� ������(toDate) ���� ��¥ ���� �Ұ�
		 // ������(toDate)�� ������(fromDate) ���� ��¥ ���� �Ұ�

		 //������.
		 $('#fromDate').datepicker({
			showOn: "both",					 // �޷��� ǥ���� Ÿ�̹� (both: focus or button)
			buttonImage: "images/calendar.gif", // ��ư �̹���
			buttonImageOnly : true,			 // ��ư �̹����� ǥ������ ����
			buttonText: "��¥����",			 // ��ư�� ��ü �ؽ�Ʈ
			dateFormat: "yy-mm-dd",			 // ��¥�� ����
			changeMonth: true,				  // ���� �̵��ϱ� ���� ���û��� ǥ�ÿ���
			//minDate: 0,						// �����Ҽ��ִ� �ּҳ�¥, ( 0 : ���� ���� ��¥ ���� �Ұ�)
			onClose: function( selectedDate ) {	
			   // ������(fromDate) datepicker�� ������
			   // ������(toDate)�� �����Ҽ��ִ� �ּ� ��¥(minDate)�� ������ �����Ϸ� ����
			   $("#toDate").datepicker( "option", "minDate", selectedDate );
			}				
		 });

		 //������
		 $('#toDate').datepicker({
			showOn: "both", 
			buttonImage: "images/calendar.gif", 
			buttonImageOnly : true,
			buttonText: "��¥����",
			dateFormat: "yy-mm-dd",
			changeMonth: true,
			//minDate: 0, // ���� ���� ��¥ ���� �Ұ�
			onClose: function( selectedDate ) {
			   // ������(toDate) datepicker�� ������
			   // ������(fromDate)�� �����Ҽ��ִ� �ִ� ��¥(maxDate)�� ������ �����Ϸ� ���� 
			   $("#fromDate").datepicker( "option", "maxDate", selectedDate );
			}				
		 });
	  });
   </script>
<body>

<s:if test="!check">
	<script type="text/javascript">alert("������Ʈ�� 2�� �̻� ������ �� �����ϴ�.");</script>
</s:if>

<div class="contents clearfix">
   <div class="title">
	  <div class="wrap">
		 <h2>������Ʈ ã��</h2>
	  </div>
   </div>
	  <div class="wrap">
		<form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" >
		 <table class="searchtable">
			<tr>
			   <td>
					 <div class="selectbox">
						��ȸ/����
						<select name="comp">
							  <option value="0">--����--</option>
						
						<s:iterator value="complist" status="stat">
							<option><s:property value="%{complist[#stat.index]}"/></option> 
						</s:iterator>
						
						</select>
						&nbsp; | &nbsp;
						����
						<select name="loc">
						<option value="0">--����--</option>
						
						<s:iterator value="loclist" status="stat">
							<option><s:property value="%{loclist[#stat.index]}"/></option> 
						</s:iterator>
						
						</select>
						&nbsp; | &nbsp;
						����
						<select name="maj">
							  <option value="0">--����--</option>
						
						<s:iterator value="majlist" status="stat">
							<option><s:property value="%{majlist[#stat.index]}"/></option> 
						
						</s:iterator>
						</select>
					 </div>
					 <s:submit theme="simple" value="���� ����"/>
				  <!-- </form> -->
				  
			   </td>
			</tr>
			<tr style="float:right;">
			   <td colspan="6">
				 <!-- <form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" > -->
						 <%-- styleId="proj" --%> 
					<select name="searchnum">
						<option value="0">������Ʈ��</option>
						<option value="1">����ID</option> 
					</select>
					<s:textfield name="search" theme="simple" value="" cssStyle=" width: 200px; height: 20px; border-radius: 0;"/>	
						<input name="submit" type="submit" value="�˻��ϱ�" class="submit"/>
			   </td>
			</tr>
		 </table>
		</form>
		<form action="favProj.action">
		 <table class="listtable">
			<tr class="list_title">
			 	<td><strong>����ID</strong></td>
			   <td><strong>������Ʈ��</strong></td>
			   <td><strong>��ȸ/����</strong></td>
			   <td><strong>����</strong></td>
			   <td><strong>������Ʈ �Ⱓ</strong></td>
			   <td><strong>��������ο�/�����ο�</strong></td>
			   <td><strong>����</strong></td>
			   <td><strong>�ӱ�</strong></td>
			</tr>
			
			<s:if test="list.size()<=0">
			   <tr class="no">
				  <td colspan="3">��ϵ� �Խù��� �����ϴ�.</td>
			   </tr>
			</s:if>
			
			<s:iterator value="list" status="stat">
			
			   <s:url id="viewURL" action="ProjInfo.action">
			   	  <s:param name="leaderid">
					 <s:property value="leaderid"/>
				  </s:param>
			   	
				  <s:param name="teamno">
					 <s:property value="teamno"/>
				  </s:param>
				  
				  <s:param name="currentPage">
					 <s:property value="currentPage"/>
				  </s:param>
			   </s:url>
			
			   <tr class="list">
				  <s:hidden value="teamno"/>
				  <s:hidden value="leaderid"/>
				 <td>
					  <s:if test="#session.auth == 2">
						  <s:checkbox theme="simple" name="teamno" fieldValue="%{teamno}"/>
					  </s:if>
					  <s:property value="leaderid" />
				  </td>
				  <td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
				  <td><s:property value="comp" /></td>
				  <td><s:property value="maj" /></td>
				  <td><s:property value="startdate" /> ~ <s:property value="enddate"/></td>
				  <td><s:property value="currmem"/>/<s:property value="recmem" /></td>
				  <td><s:property value="loc" /></td>
				  <td><s:property value="sal" /></td>
			   </tr>
			</s:iterator>
				<tr>
				   <td colspan="7">
					  <s:property value="pagingHtml" escape="false"/>
				   </td>
				</tr>
				 
				<s:if test="#session.auth == 2">	<!-- ���� -->
					<tr class="btn">
					   <td colspan="7">
						  <input type="submit" value="��ũ���ϱ�"/>
					   </td>
					</tr>
				</s:if>
			 </table>
		</form>
		<s:if test="#session.auth == 1">	<!-- ���� -->
			<form action="ProjWrite.action" method="post">
			   <s:hidden name="step" value="0" />
			   <input type="submit" value="�۾���" />
			</form>
		</s:if>
	  </div>
   </div>
   <div class="title">
   </div>
</body>
</html>