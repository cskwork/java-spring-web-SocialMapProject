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
      /*datepicker에서 사용한 이미지 버튼 style적용*/
      img.ui-datepicker-trigger {
          margin-left:5px; vertical-align:middle; cursor:pointer;
      }
   </style>
   <!-- datepicker 한국어로 -->
   <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/i18n/datepicker-ko.js"></script>
   <script>
      $(function() {
         //오늘 날짜를 출력
         $("#today").text(new Date().toLocaleDateString());

         //datepicker 한국어로 사용하기 위한 언어설정
         $.datepicker.setDefaults($.datepicker.regional['ko']); 
          
         // 시작일(fromDate)은 종료일(toDate) 이후 날짜 선택 불가
         // 종료일(toDate)은 시작일(fromDate) 이전 날짜 선택 불가

         //시작일.
         $('#fromDate').datepicker({
            showOn: "both",                     // 달력을 표시할 타이밍 (both: focus or button)
            buttonImage: "images/calendar.gif", // 버튼 이미지
            buttonImageOnly : true,             // 버튼 이미지만 표시할지 여부
            buttonText: "날짜선택",             // 버튼의 대체 텍스트
            dateFormat: "yy-mm-dd",             // 날짜의 형식
            changeMonth: true,                  // 월을 이동하기 위한 선택상자 표시여부
            //minDate: 0,                        // 선택할수있는 최소날짜, ( 0 : 오늘 이전 날짜 선택 불가)
            onClose: function( selectedDate ) {    
               // 시작일(fromDate) datepicker가 닫힐때
               // 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
               $("#toDate").datepicker( "option", "minDate", selectedDate );
            }                
         });

         //종료일
         $('#toDate').datepicker({
            showOn: "both", 
            buttonImage: "images/calendar.gif", 
            buttonImageOnly : true,
            buttonText: "날짜선택",
            dateFormat: "yy-mm-dd",
            changeMonth: true,
            //minDate: 0, // 오늘 이전 날짜 선택 불가
            onClose: function( selectedDate ) {
               // 종료일(toDate) datepicker가 닫힐때
               // 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정 
               $("#fromDate").datepicker( "option", "maxDate", selectedDate );
            }                
         });
      });
      
      var count = 0;
      
      function plusFun() {
            var form = eval("document.form");
            
            if(document.getElementById('check').value == 1) {
               alert("글이 있는데 되겠냐?");
               return false;
            }

            if(count == 0) {
               var parent = document.getElementById("a");
               var child = document.getElementById("b");
               parent.removeChild(child);
              
               
               //plusUl 변수에 createElement 를 사용해 생성할 엘리먼트를 담습니다.
               var plusUl = document.createElement('ul');
               // 추가할 plusUl 엘리먼트 안의 내용을 정해줍니다. ( 꼭 정해야 하는건 아닙니다. )
               plusUl.innerHTML = "<table style='margin: auto;'>" +
                  "<tr>" +
                     "<td rowspan='2'>" +
                        "<textarea name='exp' rows='7' cols='52' style='overflow: hidden;''></textarea>" +
                     "</td>"+
                     "<td>"+
                        "공개 여부 <input type='checkbox' name='showlog' />"+
                     "</td>"+
                  "</tr>"+
                  "<tr>"+
                     "<td>"+
                        "<input type='submit' value='스팩 등록'>"+
                     "</td>"+
                  "</tr>"+
               "</table>";
               
               // appendChild 로 이전에 정의한 plusUl 변수의 내용을 실제 추가합니다.
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
         <h2>스펙등록 관리</h2>
      </div>
   </div>
   <div class="wrap">
      <form action="deleteSpec.action">
         <table class="listtable">
            <tr class="list_title">
               <td><strong>프리랜서 ID</strong></td>
               <td><strong>등록날짜</strong></td>
               <td><strong>기존 이력</strong></td>
               <td><strong>자격증</strong></td>
               <td><strong>프로젝트 경험</strong></td>
               <td><strong>추가 내용</strong></td>
               <td><strong>공개/비공개</strong></td>
            </tr>
                  
            <s:if test="list.size()<=0">
               <tr class="no">
                  <td colspan="3">등록된 게시물이 없습니다.</td>
               </tr>
            </s:if>
            
            <s:iterator value="list" status="stat">
            
               <!-- 글 내용 출력 부분 -->
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
                  <input type="submit" value="삭제하기" onclick=""/>
               </td>
            </tr>
            <tr>
               <td>
                  <a href="/SocialMap/admin/adminPageHome.jsp">관리자 페이지</a>
               </td>
            </tr>
         </table>
      </form>
      <%-- <form action="SpecWrite.action" name="form" method="post" id="a" enctype="multipart/form-data">
         <s:hidden id="check" name="check" value="%{check}" />
         <input type='button' id='b' onclick='plusFun()' value='스팩등록' style="float:right;"/>         
      </form> --%>
   </div>
</div>
<div class="title">
</div>
</body>
</html>