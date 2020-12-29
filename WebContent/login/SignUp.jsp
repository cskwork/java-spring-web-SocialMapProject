<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
   <link rel="stylesheet" href="css/list.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : 회원 가입</title>
   <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
   <script>
      function openConfirmid(userinput) {
           if (userinput.id.value == "") {
               alert("아이디를 입력하세요");
               return;
           }
           url = "ConfirmId.action?id=" + userinput.id.value ;
          
           open(url, "confirm",
                 "toolbar=no, location=no, status=no, menubar=no,scrollbars=no,resizable=no,width=300, height=200px");
      }
      
      function checkIt() {
           var userinput = eval("document.userinput");

           if(!userinput.id.value) {
               alert("ID를 입력하세요");
               return false;
           }
          
           if(!userinput.password.value ) {
               alert("비밀번호를 입력하세요");
               return false;
           }
           if(userinput.password.value != userinput.password2.value) {
               alert("비밀번호를 동일하게 입력하세요");
               return false;
           }
         
           if(!userinput.name.value) {
               alert("사용자 이름을 입력하세요");
               return false;
           }
           if(!userinput.jumin1.value  || !userinput.jumin2.value ) {
               alert("주민등록번호를 입력하세요");
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
      <h2>회원가입</h2>
   </div>
</div>
   <form method="post" action="SignUp.action" name="userinput" onsubmit="return checkIt()" >
   <s:hidden name="step" value="1"/>
      <table border="0" style="width: 450px; cellspacing: 0; cellpadding: 3; margin: auto; align-content: center; padding-top:50px;" >
         <!-- 1.ID -->
         <tr>
            <td colspan="2" colspan="2">사용자 ID</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="id" maxlength="12"   style="width: 350px; height: 30px" />
               <input type="button" name="confirm_id" value="중복확인" onclick="openConfirmid(this.form)" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 2.password -->
         <tr>
            <td colspan="2" width="200px">비밀번호</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="password" name="pwd" maxlength="16" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <tr>
            <td colspan="2" width="200px">비밀번호 확인</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="password" name="pwd2" maxlength="16" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 3.name -->
         <tr>
            <td colspan="2">이름</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="name" maxlength="12" style="width: 350px; height: 30px" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
   
         <!-- 4.생년월일, 성별-->
         <tr>
            <td colspan="2" width="200px">주민등록 번호</td>
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
   
         <!-- 7.주소 -->
         <tr>
            <td colspan="2" width="200px">주소</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="addr" id="address" style="width: 350px; height: 30px;" placeholder="주소" />
               <input type="button" onclick="execDaumPostcode()" value="주소 찾기" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 8.가입 유형 -->
         <tr>
            <td width="100px" height="">참여 유형</td>
         </tr>
         <tr>
            <td>
               <select name="auth" style="width: 100px; height:30px">
                  <option value="1">팀장</option>
                  <option value="2">프리랜서</option>
               </select>
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 9.전공 -->
         <tr>
            <td colspan="2" width="200px">전공</td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="text" name="maj" maxlength="50" style="width: 350px; height: 30px" />
               <input type="button" onclick="majorCheck()" value="전공 찾기" />
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 10. 이력 -->
         <tr>
            <td colspan="2" width="200px">전공관련 이력</td>
         </tr>
         <tr>
            <td colspan="2">
               <textarea name="exp" rows="7" cols="52" style="overflow: hidden;"></textarea>
            </td>
         </tr>
         <tr><td height="10px"></td></tr>
         
         <!-- 버튼 -->
         <tr>
            <td colspan="2">
               <input type="hidden" name="asd" value="asd" />
               <input type="submit" value="가    입" style="width: 174px; height: 40px"  />
               <input type="button" value="취    소" style="width: 174px; height: 40px" onclick="javascript:window.location='homepage.jsp'" />
            </td>
         </tr>
      </table>
   </form>
</div>
<div class="title">
</div>
</body>
</html>