<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Q&A</title>
   <script type="text/javascript">
      function open_win_noresizable(url, name) {
         var oWin = window.open(url, name, "scrollbars=no, status=no, resizable=no, width=300, height=150");
      }
   </script>
</head>
<body>
<div align="center">
   <table width="100%" height="100%" style="margin: auto;" border="0">
      <tr height="30%" valign="top">
         <td align="center">
            <table width="70%" border="0" cellspacing="0" cellpadding="2">
               <tr height="40px">
                  <td align="center" class="text01 formbar"><h2>Q & A</h2></td>
               </tr>
            </table>
         </td>
      </tr>
      <tr height="70%" valign="top">
         <td align="center">
            <table width="70%" border="1" cellspacing="0" cellpadding="0">
               <tr height="40px">
                  <td width="30px" align="center" class="tdstyle1">번호</td>
                  <td width="85%"><s:property value="resultClass1.no" /></td>
               </tr>
               
               <tr height="40px">
                  <td align="center">아이디</td>
                  <td><s:property value="resultClass1.id" /></td>
               </tr>
               
               <tr height="40px">
                  <td align="center">등록날짜</td>
                  <td><s:property value="resultClass1.regdate" /></td>
               </tr>
               
               <tr height="250px">
                  <td align="center" class="tdstyle1">질문</td>
                  <td><s:property value="resultClass1.cont" /></td>
               </tr>
               
               <tr height="250px">
                  <td align="center">답변</td>
                  <td><s:property value="resultClass2.cont" /><br><br>
               </tr>
            
               <tr height="40px">
                  <td colspan="2" align="right">
                     <s:url id="deleteURL" action="QnaDelete">
                        <s:param name="no">
                           <s:property value="no" />
                        </s:param>
                     </s:url>
                     <s:if test="list.size() > 1">
                        <form action="QnaAdminModify.action" method="post">
                           <s:hidden name="id" value="%{resultClass1.id}" />
                           <s:hidden name="cont" value="%{resultClass1.cont}" />
                           <s:hidden name="title" value="%{resultClass1.title}" />
                           <s:hidden name="no" value="%{no}" />
                           <input type="submit" value="답변수정"/>
                        </form>
                     </s:if>
                     <s:else>
                        <form action="QnaAdminWrite.action" method="post">
                           <s:hidden name="id" value="%{resultClass1.id}" />
                           <s:hidden name="cont" value="%{resultClass1.cont}" />
                           <s:hidden name="title" value="%{resultClass1.title}" />
                           <s:hidden name="no" value="%{no}" />
                           <input type="submit" value="답변등록"/>
                        </form>
                      </s:else>
                      <input type="button" value="질문삭제" onClick="javascript:location.href='QnaDelete.action?no=<s:property value="no" />&currentPage=<s:property value="currentPage" />'">
                     <input type="button" value="QnA목록" onClick="javascript:location.href='QnaList.action?currentPage=<s:property value="currentPage" />'">
                  </td>
               </tr>
            </table>
         </td>
      </tr>
   </table>
</div>
</body>
</html>