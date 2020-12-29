<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>프로젝트 찾기 </title>
</head>
   <script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
   <link rel="stylesheet" href="css/list.css" />
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
			showOn: "both",					 // 달력을 표시할 타이밍 (both: focus or button)
			buttonImage: "images/calendar.gif", // 버튼 이미지
			buttonImageOnly : true,			 // 버튼 이미지만 표시할지 여부
			buttonText: "날짜선택",			 // 버튼의 대체 텍스트
			dateFormat: "yy-mm-dd",			 // 날짜의 형식
			changeMonth: true,				  // 월을 이동하기 위한 선택상자 표시여부
			//minDate: 0,						// 선택할수있는 최소날짜, ( 0 : 오늘 이전 날짜 선택 불가)
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
   </script>
<body>

<s:if test="!check">
	<script type="text/javascript">alert("프로젝트를 2개 이상 진행할 수 없습니다.");</script>
</s:if>

<div class="contents clearfix">
   <div class="title">
	  <div class="wrap">
		 <h2>프로젝트 찾기</h2>
	  </div>
   </div>
	  <div class="wrap">
		<form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" >
		 <table class="searchtable">
			<tr>
			   <td>
					 <div class="selectbox">
						대회/공모
						<select name="comp">
							  <option value="0">--선택--</option>
						
						<s:iterator value="complist" status="stat">
							<option><s:property value="%{complist[#stat.index]}"/></option> 
						</s:iterator>
						
						</select>
						&nbsp; | &nbsp;
						지역
						<select name="loc">
						<option value="0">--선택--</option>
						
						<s:iterator value="loclist" status="stat">
							<option><s:property value="%{loclist[#stat.index]}"/></option> 
						</s:iterator>
						
						</select>
						&nbsp; | &nbsp;
						전공
						<select name="maj">
							  <option value="0">--선택--</option>
						
						<s:iterator value="majlist" status="stat">
							<option><s:property value="%{majlist[#stat.index]}"/></option> 
						
						</s:iterator>
						</select>
					 </div>
					 <s:submit theme="simple" value="필터 적용"/>
				  <!-- </form> -->
				  
			   </td>
			</tr>
			<tr style="float:right;">
			   <td colspan="6">
				 <!-- <form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" > -->
						 <%-- styleId="proj" --%> 
					<select name="searchnum">
						<option value="0">프로젝트명</option>
						<option value="1">팀장ID</option> 
					</select>
					<s:textfield name="search" theme="simple" value="" cssStyle=" width: 200px; height: 20px; border-radius: 0;"/>	
						<input name="submit" type="submit" value="검색하기" class="submit"/>
			   </td>
			</tr>
		 </table>
		</form>
		<form action="favProj.action">
		 <table class="listtable">
			<tr class="list_title">
			 	<td><strong>팀장ID</strong></td>
			   <td><strong>프로젝트명</strong></td>
			   <td><strong>대회/공모</strong></td>
			   <td><strong>전공</strong></td>
			   <td><strong>프로젝트 기간</strong></td>
			   <td><strong>현재모집인원/모집인원</strong></td>
			   <td><strong>지역</strong></td>
			   <td><strong>임금</strong></td>
			</tr>
			
			<s:if test="list.size()<=0">
			   <tr class="no">
				  <td colspan="3">등록된 게시물이 없습니다.</td>
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
				 
				<s:if test="#session.auth == 2">	<!-- 팀원 -->
					<tr class="btn">
					   <td colspan="7">
						  <input type="submit" value="스크랩하기"/>
					   </td>
					</tr>
				</s:if>
			 </table>
		</form>
		<s:if test="#session.auth == 1">	<!-- 팀장 -->
			<form action="ProjWrite.action" method="post">
			   <s:hidden name="step" value="0" />
			   <input type="submit" value="글쓰기" />
			</form>
		</s:if>
	  </div>
   </div>
   <div class="title">
   </div>
</body>
</html>