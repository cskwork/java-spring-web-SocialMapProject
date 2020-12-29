<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/list.css" />
	<script type="text/javascript" >
		function go() {
			document.form.submit();
		}
	</script>
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
				showOn: "both",							// �޷��� ǥ���� Ÿ�̹� (both: focus or button)
				buttonImage: "images/calendar.gif", // ��ư �̹���
				buttonImageOnly : true,				 // ��ư �̹����� ǥ������ ����
				buttonText: "��¥����",				 // ��ư�� ��ü �ؽ�Ʈ
				dateFormat: "yy-mm-dd",				 // ��¥�� ����
				changeMonth: true,						// ���� �̵��ϱ� ���� ���û��� ǥ�ÿ���
				//minDate: 0,								// �����Ҽ��ִ� �ּҳ�¥, ( 0 : ���� ���� ��¥ ���� �Ұ�)
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
		
		var count = 0;
		
		function plusFun() {
	         var form = eval("document.form");
	         
	         if(document.getElementById('check').value == 1) {
	            alert("�̹� ���� ��ϵǾ��ֽ��ϴ�.");
	            return false;
	         }

	         if(count == 0) {
	            var parent = document.getElementById("a");
	            var child = document.getElementById("b");
	            parent.removeChild(child);
	           
	            
	            //plusUl ������ createElement �� ����� ������ ������Ʈ�� ����ϴ�.
	            var plusUl = document.createElement('ul');
	            // �߰��� plusUl ������Ʈ ���� ������ �����ݴϴ�. ( �� ���ؾ� �ϴ°� �ƴմϴ�. )
	            plusUl.innerHTML = "<table style='margin: auto;'>" +
	               "<tr>" +
	                  "<td rowspan='2'>" +
	                     "<textarea name='exp' rows='7' cols='52' style='overflow: hidden;''></textarea>" +
	                  "</td>"+
	                  "<td>"+
	                     "���� ���� <input type='checkbox' name='showlog' />"+
	                  "</td>"+
	               "</tr>"+
	               "<tr>"+
	                  "<td>"+
	                     "<input type='submit' value='���� ���'>"+
	                  "</td>"+
	               "</tr>"+
	            "</table>";
	            
	            // appendChild �� ������ ������ plusUl ������ ������ ���� �߰��մϴ�.
	            document.getElementById('a').appendChild(plusUl);
	            
	            count++;
	         }
	     }
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>�������� ã��</h2>
		</div>
	</div>
		<div class="wrap">
			<table class="searchtable">		
				<tr>
					<td>
						<form action="SpecList.action" method="post" name="form" enctype="multipart/form-data" >
							 <div class="selectbox">	
						����
						<select name="addr">
						<option value="0">--����--</option>
						
						<s:iterator value="addrlist" status="stat">
							<option><s:property value="%{addrlist[#stat.index]}"/></option> 
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
						</form>
					</td>
				</tr>
				
				<tr class="searchbox">
						<td colspan="6">
						<form method="post" enctype="multipart/form-data"> 
							<input type="text" name="search" placeholder="�������� ID">			
							<input name="submit" type="submit" value="ã��" class="submit"/>
						</form>
						</td>
				</tr>
			
			</table>
		</div>
	<div class="wrap">
		<form action="favSpec.action">
			<table class="listtable">
				<tr class="list_title">
					<td><strong>����</strong></td>
					<td><strong>��������</strong></td>
					<td><strong>����</strong></td>
					<td><strong>������Ʈ ����</strong></td>
					<td><strong>����</strong></td>
				</tr>
						
				<s:if test="list.size()<=0">
					<tr class="no">
						<td colspan="3">��ϵ� �Խù��� �����ϴ�.</td>
					</tr>
				</s:if>
				
				<s:iterator value="list" status="stat">
					<s:url id="viewURL" action="SpecInfo.action">
						<s:param name="id">
							<s:property value="id"/>
						</s:param>
						
						<s:param name="currentPage">
							<s:property value="currentPage"/>
						</s:param>
					</s:url>
				
					<!-- �� ���� ��� �κ� -->
					<tr class="list">
						<td><s:checkbox theme="simple" id="chk" name="id" fieldValue="%{id}" value="false"/></td>
						<td><s:a href="%{viewURL}"><s:property value="id"/></s:a></td>
						<td><s:property value="%{maj}" /></td>
						<td><s:property value="%{exp}" /></td>
						<td><s:property value="%{addr}" /></td>
					</tr>
				</s:iterator>
				<tr>	
					<td colspan="4">
						<s:property value="pagingHtml" escape="false"/>
					</td>
				</tr>
				<s:if test="auth==1">
				<tr class="btn">
					<td colspan="4">
						<input type="submit" value="��ũ���ϱ�" onclick="chkCount()"/>
					</td>
				</tr>
				</s:if>
			</table>
		</form>
		<form action="SpecWrite.action" name="form" method="post" id="a" enctype="multipart/form-data">
		   <s:hidden id="check" name="check" value="%{check}" />
		   <s:hidden id="auth" value="%{auth}"></s:hidden>
		   <s:if test="auth == 2">
				<input type='button' id='b' onclick='plusFun()' value='���ѵ��' style="float:right;"/>
		   </s:if>         
		</form>
	</div>
</div>
<div class="title">
</div>
</body>
</html>