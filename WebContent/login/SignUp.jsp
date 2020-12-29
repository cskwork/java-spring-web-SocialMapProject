<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
   <link rel="stylesheet" href="css/list.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : ȸ�� ����</title>
   <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
   <script>
      function openConfirmid(userinput) {
           if (userinput.id.value == "") {
               alert("���̵� �Է��ϼ���");
               return;
           }
           url = "ConfirmId.action?id=" + userinput.id.value ;
          
           open(url, "confirm",
                 "toolbar=no, location=no, status=no, menubar=no,scrollbars=no,resizable=no,width=300, height=200px");
      }
      
      function checkIt() {
           var userinput = eval("document.userinput");

           if(!userinput.id.value) {
               alert("ID�� �Է��ϼ���");
               return false;
           }
          
           if(!userinput.password.value ) {
               alert("��й�ȣ�� �Է��ϼ���");
               return false;
           }
           if(userinput.password.value != userinput.password2.value) {
               alert("��й�ȣ�� �����ϰ� �Է��ϼ���");
               return false;
           }
         
           if(!userinput.name.value) {
               alert("����� �̸��� �Է��ϼ���");
               return false;
           }
           if(!userinput.jumin1.value  || !userinput.jumin2.value ) {
               alert("�ֹε�Ϲ�ȣ�� �Է��ϼ���");
               return false;
           }
      }
      
      function majorCheck(){
         url="http://localhost:8080/SocialMap/Major.action";
         window.open(url,"post","toolbar=no ,width=350 ,height=400 ,directories=no,status=yes,scrollbars=yes,menubar=no");
      }
      
      function execDaumPostcode() {
         new daum.Postcode({
            oncomplete : function(data) {
               var fullAddr = '';
               var extraAddr = '';
               
               if (data.userSelectedType === 'R') {
                  fullAddr = data.roadAddress;
               } else {
                  fullAddr = data.jibunAddress;
               }
               
               if (data.userSelectedType === 'R') {
                  if (data.bname !== '') {
                     extraAddr += data.bname;
                  }
                  
                  if (data.buildingName !== '') {
                     extraAddr += (extraAddr !== '' ? ', '+ data.buildingName: data.buildingName);
                  }
                  fullAddr += (extraAddr !== '' ? ' ('+ extraAddr + ')' : '');
               }
               
               document.getElementById('address').value = fullAddr;
            }
         
         }).open();
      }
   </script>
</head>
<body>
<div class="contents clearfix">
<div class="title">
   <div class="wrap">
      <h2>ȸ������</h2>
   </div>
</div>
   <form method="post" action="SignUp.action" name="userinput" onsubmit="return checkIt()" >
   <s:hidden name="step" value="1"/>
      <table border="0" style="width: 450px; cellspacing: 0; cellpadding: 3; margin: auto; align-content: center; padding-top:50px;" >
         <!-- 1.ID -->
         <tr>
            <td colspan="2" colspan="2">����� ID</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="id" maxlength="12"   style="width: 350px; height: 30px" />
               <input type="button" name="confirm_id" value="�ߺ�Ȯ��" onclick="openConfirmid(this.form)" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 2.password -->
         <tr>
            <td colspan="2" width="200px">��й�ȣ</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="password" name="pwd" maxlength="16" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <tr>
            <td colspan="2" width="200px">��й�ȣ Ȯ��</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="password" name="pwd2" maxlength="16" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 3.name -->
         <tr>
            <td colspan="2">�̸�</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="name" maxlength="12" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 4.�������, ����-->
         <tr>
            <td colspan="2" width="200px">�ֹε�� ��ȣ</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="birth" maxlength="6" style="width: 165px; height: 30px" />
                - 
                <input type="text" name="gen" maxlength="1" style="width: 15px; height: 30px" />
                ******
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 6.email -->
         <tr>
            <td colspan="2" width="200px">E-mail</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="email" maxlength="30" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 7.�ּ� -->
         <tr>
            <td colspan="2" width="200px">�ּ�</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="addr" id="address" style="width: 350px; height: 30px;" placeholder="�ּ�" />
               <input type="button" onclick="execDaumPostcode()" value="�ּ� ã��" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 8.���� ���� -->
         <tr>
            <td width="100px" height="">���� ����</td>
         </tr>
         <tr>
            <td>
               <select name="auth" style="width: 100px; height:30px">
                  <option value="1">����</option>
                  <option value="2">��������</option>
               </select>
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 9.���� -->
         <tr>
            <td colspan="2" width="200px">����</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="maj" maxlength="50" style="width: 350px; height: 30px" />
               <input type="button" onclick="majorCheck()" value="���� ã��" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 10. �̷� -->
         <tr>
            <td colspan="2" width="200px">�������� �̷�</td>
         </tr>
         <tr>
            <td colspan="2">
               <textarea name="exp" rows="7" cols="52" style="overflow: hidden;"></textarea>
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- ��ư -->
         <tr>
            <td colspan="2">
               <input type="hidden" name="asd" value="asd" />
               <input type="submit" value="��    ��" style="width: 174px; height: 40px"  />
               <input type="button" value="��    ��" style="width: 174px; height: 40px" onclick="javascript:window.location='homepage.jsp'" />
            </td>
         </tr>
      </table>
   </form>
</div>
<div class="title">
</div>
</body>
</html>