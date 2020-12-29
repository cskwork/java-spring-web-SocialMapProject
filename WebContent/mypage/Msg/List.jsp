<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
   <link rel="stylesheet" href="css/list.css" />
   <meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
   <title>쪽지함</title>
   <script type="text/javascript">
      function closeWin() {
          var nvua = navigator.userAgent;
          if (nvua.indexOf('MSIE') >= 0){
              if(nvua.indexOf('MSIE 5.0') == -1) {
                  top.opener = '';
              }
          } else if (nvua.indexOf('Gecko') >= 0){
              top.name = 'CLOSE_WINDOW';
              wid = window.open('','CLOSE_WINDOW');
          }
          top.close();
      }
      
      function info(var1) {
         document.getElementById('no').value = var1;
         document.getElementById('frm').submit();
      }   
      </script>
</head>
<body>
   <table style="width: 670px; height: 600px; border-spacing: 0; padding: 0; margin: auto;" border="1">
   <tr valign="middle" height="10%">
   <td>
      <form action="MsgList.action" name="form" method="post" enctype="multipart/form-data" >
         <table style="margin: auto; width: 100%;" border="0">
            <tr>
               <td align="left">
                  <a href="MsgWrite.action">쪽지쓰기</a>
                  <a href="MsgList.action">받은쪽지  </a>
                  <a href="javascript:document.log.submit();">보낸쪽지  </a>
               </td>
               <td align="right">
                  검색 
                  <input type="search" name="searchValue" /> 
                  <input type="submit" value="search" />
               </td>
            </tr>
         </table>
      </form>
      <form action="MsgList.action" name="log" method="post" enctype="multipart/form-data" >
         <s:hidden value="%{#session.id}" name="sendid" />
         <s:hidden value="1" name="check" />
      </form>
   </td>
   </tr>
   
   <tr valign="top" height="90%">
   <td>
      <form action="MsgDelete.action" name="form" method="post" enctype="multipart/form-data" >
         <table style="margin: auto; width: 100%; height: 90%" border="0">
            <tr valign="top" height="">
            <td>
            <table style="width: 100%; height: 20px" border="0">
               <tr valign="top">
                  <td width="10px" align="center"><input type="checkbox" /></td>
                  <s:if test="check == 0">
                     <td width="100px" align="center">보낸사람</td>
                  </s:if>
                  <s:else>
                     <td width="100px" align="center">받는사람</td>
                  </s:else>
                  <td width="350px" align="center">제목</td>
                  <td align="center">날짜</td>
               </tr>
            </table>
            </td>
            </tr>
            <tr valign="top" height="">
            <td>
            <table style="width: 100%; height: 20px" border="0">
               <s:iterator value="list" status="stat">
                  
                  <!-- 글 내용 출력 부분 -->
                  <tr align="center">
                     <s:hidden value="no"/>
                     <td width="10px" align="center"><input type="checkbox" name="no" value="${no}"/></td>
                     <td width="100px" align="center"><s:property value="sendid" /></td>
                     <td width="350px" align="left"><s:a href="javascript:info(%{list[#stat.index].no});"><s:property value="title" /></s:a></td>
                     <td align="center"><s:property value="sendtime" /></td>
                  </tr>
               </s:iterator>
            </table>
            </td>
            </tr>
               
            <tr>   
               <td colspan="5" align="center">
                  <s:property value="pagingHtml" escape="false"/>
               </td>
            </tr>
               
            <tr>
               <td align="right">
                  <input type="submit" value="삭제"/>
                  <input type="button" value="닫기" onclick="javascript:history.onclick=closeWin();"/>
               </td>
            </tr>
         </table>
      </form>

      <form action="MsgInfo.action" name="form" id="frm" method="post" >
         <s:hidden name="currentPage" value="%{currentPage}"/>
         <s:hidden name="getid" value="%{getid}"/>
         <s:hidden name="check" value="%{check}"/>
         <s:hidden name="no" id="no" value=""/>
      </form>
   </td>
   </tr>
   </table>
</body>
</html>