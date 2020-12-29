<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
   <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
   <link rel="stylesheet" href="/SocialMap/css/list.css" />

<script type="text/javascript">

function main_scroll_bt_ch1() {
  main_scroll_bt1.style.background = "url(/SocialMap/images/d1.jpg)";
  main_scroll_bt2.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt3.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt4.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt5.style.background = "url(/SocialMap/images/d2.jpg)";
}
function main_scroll_bt_ch2() {
  main_scroll_bt1.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt2.style.background = "url(/SocialMap/images/d1.jpg)";
  main_scroll_bt3.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt4.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt5.style.background = "url(/SocialMap/images/d2.jpg)";
}
function main_scroll_bt_ch3() {
  main_scroll_bt1.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt2.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt3.style.background = "url(/SocialMap/images/d1.jpg)";
  main_scroll_bt4.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt5.style.background = "url(/SocialMap/images/d2.jpg)";
}
function main_scroll_bt_ch4() {
  main_scroll_bt1.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt2.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt3.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt4.style.background = "url(/SocialMap/images/d1.jpg)";
  main_scroll_bt5.style.background = "url(/SocialMap/images/d2.jpg)";
}
function main_scroll_bt_ch5() {
  main_scroll_bt1.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt2.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt3.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt4.style.background = "url(/SocialMap/images/d2.jpg)";
  main_scroll_bt5.style.background = "url(/SocialMap/images/d1.jpg)";
}



//Jquery
$(function(){
  var cnv;
  var timers = 3000;
  
  var imgsize = 500;
  
  var mst1 = function(){
    main_scroll_bt_ch1();
    $("#main_scroll").stop().animate({'scrollLeft':0},500);
     clearTimeout(cnv);

    cnv = setTimeout(mst2,timers);
  };
  var mst2 = function(){
    main_scroll_bt_ch2();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize},500);
     clearTimeout(cnv);

    cnv = setTimeout(mst3,timers);
  };
  var mst3 = function(){
    main_scroll_bt_ch3();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize*2},500);
     clearTimeout(cnv);

    cnv = setTimeout(mst4,timers);
  };
  var mst4 = function(){
    main_scroll_bt_ch4();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize*3},500);
     clearTimeout(cnv);

    cnv = setTimeout(mst5,timers);
  };
  var mst5 = function(){
    main_scroll_bt_ch5();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize*4},500);
     clearTimeout(cnv);

    cnv = setTimeout(mst1,timers);
  };
  
  cnv = setTimeout(mst2,timers);
  
  $("#main_scroll_bt1").mouseover(function(){
    main_scroll_bt_ch1();
    $("#main_scroll").stop().animate({'scrollLeft':0},500);
     clearTimeout(cnv);
    cnv = setTimeout(mst2,timers);
  });
  $("#main_scroll_bt2").mouseover(function(){
    main_scroll_bt_ch2();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize},500);
     clearTimeout(cnv);
    cnv = setTimeout(mst3,timers);
  });
  $("#main_scroll_bt3").mouseover(function(){
    main_scroll_bt_ch3();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize*2},500);
     clearTimeout(cnv);
    cnv = setTimeout(mst4,timers);
  });
  $("#main_scroll_bt4").mouseover(function(){
    main_scroll_bt_ch4();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize*3},500);
     clearTimeout(cnv);
    cnv = setTimeout(mst5,timers);
  });
  $("#main_scroll_bt5").mouseover(function(){
    main_scroll_bt_ch5();
    $("#main_scroll").stop().animate({'scrollLeft':imgsize*4},500);
     clearTimeout(cnv);
    cnv = setTimeout(mst1,timers);
  });
});
</script>
<title>대회정보</title>

</head>
<body>
<div class="contents clearfix">
   <div class="title">
      <div class="wrap">
         <h2>대회정보</h2>
      </div>
   </div>
      <div class="wrap">
      <strong>TOP 5</strong>
      <div id="main_scroll_bg">
         <div id="main_scroll">
         <ul>
            <s:iterator value="list1" status="stat1">
               <s:url id="viewURL" action="CompInfo">
                  <s:param name="no">
                     <s:property value="no"/>
                  </s:param>
               </s:url>
               <s:if test="#stat1.index < 5">
                  <li><s:a href="%{viewURL}"><img width="500px" height="500px" src="/SocialMap/upload/file_<s:property value='no'/>.PNG"></s:a></li>
               </s:if>
            </s:iterator>
         </ul>
      </div>
   </div>
      <!-- <div class="wrap"> --><div>
      <ul id="main_scroll_bt">
        <li id="main_scroll_bt1" style="background:url(/SocialMap/images/d1.jpg) no-repeat left top;"></li>
        <li id="main_scroll_bt2" style="background:url(/SocialMap/images/d2.jpg) no-repeat left top;"></li>
        <li id="main_scroll_bt3" style="background:url(/SocialMap/images/d2.jpg) no-repeat left top;"></li>
        <li id="main_scroll_bt4" style="background:url(/SocialMap/images/d2.jpg) no-repeat left top;"></li>
        <li id="main_scroll_bt5" style="background:url(/SocialMap/images/d2.jpg) no-repeat left top;"></li>
      </ul>
      </div>
  <!--  </div> -->
         <%-- <table class="listtable">
            <tr class="list_title">
               <td colspan="8"><strong>TOP 5</strong></td>
            </tr>
            <tr class="list_title2">
               <td><strong>번호</strong></td>
               <td><strong>이미지</strong></td>
               <td><strong>제목</strong></td>
               <td><strong>시작일</strong></td>
               <td><strong>마감일</strong></td>
               <td><strong>내용</strong></td>
               <td><strong>등록일</strong></td>
               <td><strong>조회수</strong></td>
            </tr>
            <s:iterator value="list1" status="stat1">
               <s:url id="viewURL" action="CompInfo">
                  <s:param name="no">
                     <s:property value="no"/>
                  </s:param>
               </s:url>
               <s:if test="#stat1.index < 5">
                  <tr class="list">
                     <td><s:property value="no" /></td>
                     <td ><s:a href="%{viewURL}"><img width="65" height="40" src="/SocialMap/upload/file_<s:property value='no'/>.PNG"></s:a></td>
                     <td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
                     <td><s:property value="startdate" /></td>
                     <td><s:property value="enddate" /></td>
                     <td><s:property value="cont" /></td>
                     <td><s:property value="regdate" /></td>
                     <td><s:property value="hits" /></td>
                     <td><s:property value="#stat1.index+1"/></td>
                  </tr>
               </s:if>
            </s:iterator>
         </table> --%>
         <br><br><br>
         <table class="listtable">
            <tr class="list_title">
               <td><strong>번호</strong></td>
               <td><strong>이미지</strong></td>
               <td><strong>제목</strong></td>
               <td><strong>시작일</strong></td>
               <td><strong>마감일</strong></td>
               <%-- td><strong>내용</strong></td> --%>
               <td><strong>등록일</strong></td>
               <td><strong>조회수</strong></td>
            </tr>
            
            <s:if test="list.size()<=0">
               <tr class="no">
                  <td colspan="3">등록된 게시물이 없습니다.</td>
               </tr>
            </s:if>
            
            <s:iterator value="list" status="stat">
               <s:url id="viewURL" action="CompInfo">
                  <s:param name="no">
                     <s:property value="no"/>
                  </s:param>
               </s:url>
               
               <tr class="list">
                  <td><s:property value="no" /></td>
                  <td ><s:a href="%{viewURL}"><img width="65" height="40" src="/SocialMap/upload/file_<s:property value='no'/>.PNG"></s:a></td>
                  <td><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
                  <td><s:property value="startdate" /></td>
                  <td><s:property value="enddate" /></td>
                  <%-- <td><s:property value="cont" /></td> --%>
                  <td><s:property value="regdate" /></td>
                  <td><s:property value="hits" /></td>
               </tr>
            </s:iterator>
            <%-- <tr class="btn">
               <td colspan="8">
                  <form action="CompWrite.action?step=0" name="form" method="post" id="a" enctype="multipart/form-data" >
                     <s:hidden name="check" value="%{check}" />
                     <input type='submit' id='b' value='공모전등록'/>         
                  </form>
               </td>
            </tr> --%>
            <tr align="center">
               <td colspan="8">
                  <s:property value="pagingHtml" escape="false"/>
               </td>
            </tr>
         </table>
      </div>
   </div>
   <div class="title">
   </div>
</body>
</html>