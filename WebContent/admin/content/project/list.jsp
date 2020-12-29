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
	</script>
<body>
<form action="favProj.action">
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>������Ʈ ã��</h2>
		</div>
	</div>
		<div class="wrap">
			<table class="searchtable">
				<tr>
					<td>
						<form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" >
							<div class="selectbox">
								ī�װ�
								<select name="comp">
										<option value="0">--����--</option>
										<option>����</option>
										<option>������</option>
								</select>
								&nbsp; | &nbsp;
								����
								<select name="loc">
										<option value="0">--����--</option>
										<option>����</option>
										<option>�λ�</option>
								</select>
								&nbsp; | &nbsp;
								�ڰݿ��
								<select name="maj">
										<option value="0">--����--</option>
										<option>����</option>
										<option>��ǻ��</option>
										<option>����</option>
								</select>
								<div class="date">
									<br />������Ʈ �Ⱓ
									<label for="fromDate">������</label>
									
									<input type="text" name="fromDate" id="fromDate">
									~
									<label for="toDate">������</label>
									<input type="text" name="toDate" id="toDate">
									<s:submit theme="simple" value="���� ����"/>	
								</div>
							</div>
						</form>
					</td>
				</tr>
				<tr class="searchbox">
					<td colspan="6">
						<form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" >
							<input type="text" placeholder="������Ʈ �˻�">
							<s:submit theme="simple" value="�˻�"/>	
						</form>
					</td>
				</tr>
			</table>
			<table class="listtable">
				<tr class="list_title">
					<td><strong>����ID</strong></td>
					<td><strong>������Ʈ��</strong></td>
					<td><strong>ī�װ�</strong></td>
					<td><strong>������Ʈ �Ⱓ</strong></td>
					<td><strong>�����ο�/��������ο�</strong></td>
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
						<td><s:checkbox theme="simple" name="teamno" fieldValue="%{teamno}"/><s:property value="leaderid" /></td>
						<td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
						<td><s:property value="comp" /></td>
						<td><s:property value="startdate" /> ~ <s:property value="enddate"/></td>
						<td><s:property value="recmem" />/<s:property value="currmem"/></td>
						<td><s:property value="loc" /></td>
						<td><s:property value="sal" /></td>
					</tr>
				</s:iterator>
				
				<tr>
					<td colspan="7">
						<s:property value="pagingHtml" escape="false"/>
					</td>
				</tr>
				<tr class="btn">
					<td colspan="7">
						<form action="ProjWrite.action?leaderid=<s:property value="id"/>" method="post">
							<s:hidden name="step" value="0" />
							<input type="submit" value="�۾���" />
						</form>					
					</td>
				</tr>
				<tr>
					<td>
						<a href="/SocialMap/admin/adminPageHome.jsp">������ ������</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="title">
	</div>
</form>
</body>
</html>