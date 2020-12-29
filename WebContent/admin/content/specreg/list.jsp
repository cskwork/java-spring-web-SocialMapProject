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
            showOn: "both",                     // �޷��� ǥ���� Ÿ�̹� (both: focus or button)
            buttonImage: "images/calendar.gif", // ��ư �̹���
            buttonImageOnly : true,             // ��ư �̹����� ǥ������ ����
            buttonText: "��¥����",             // ��ư�� ��ü �ؽ�Ʈ
            dateFormat: "yy-mm-dd",             // ��¥�� ����
            changeMonth: true,                  // ���� �̵��ϱ� ���� ���û��� ǥ�ÿ���
            //minDate: 0,                        // �����Ҽ��ִ� �ּҳ�¥, ( 0 : ���� ���� ��¥ ���� �Ұ�)
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
               alert("���� �ִµ� �ǰڳ�?");
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
         <h2>������ ����</h2>
      </div>
   </div>
   <div class="wrap">
      <form action="deleteSpec.action">
         <table class="listtable">
            <tr class="list_title">
               <td><strong>�������� ID</strong></td>
               <td><strong>��ϳ�¥</strong></td>
               <td><strong>���� �̷�</strong></td>
               <td><strong>�ڰ���</strong></td>
               <td><strong>������Ʈ ����</strong></td>
               <td><strong>�߰� ����</strong></td>
               <td><strong>����/�����</strong></td>
            </tr>
                  
            <s:if test="list.size()<=0">
               <tr class="no">
                  <td colspan="3">��ϵ� �Խù��� �����ϴ�.</td>
               </tr>
            </s:if>
            
            <s:iterator value="list" status="stat">
            
               <!-- �� ���� ��� �κ� -->
               <tr class="list">
                  <td><s:checkbox theme="simple" id="chk" name="id" fieldValue="%{id}" value="false"/>
                  <s:property value="id"/></td>
                  <td><s:property value="regdate" /></td>
                  <td><s:property value="exp" /></td>
                  <td><s:property value="spec" /></td>
                  <td><s:property value="projexp" /></td>
                  <td><s:property value="contadd" /></td>
                  <td><s:property value="showlog" /></td>
               </tr>
            </s:iterator>
            <tr>   
               <td colspan="4">
                  <s:property value="pagingHtml" escape="false"/>
               </td>
            </tr>
            <tr class="btn">
               <td colspan="4">
                  <input type="submit" value="�����ϱ�" onclick=""/>
               </td>
            </tr>
            <tr>
               <td>
                  <a href="/SocialMap/admin/adminPageHome.jsp">������ ������</a>
               </td>
            </tr>
         </table>
      </form>
      <%-- <form action="SpecWrite.action" name="form" method="post" id="a" enctype="multipart/form-data">
         <s:hidden id="check" name="check" value="%{check}" />
         <input type='button' id='b' onclick='plusFun()' value='���ѵ��' style="float:right;"/>         
      </form> --%>
   </div>
</div>
<div class="title">
</div>
</body>
</html>