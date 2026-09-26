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
<form action="ProjList.action" method="get" class="sm-project-search">
 <div class="sm-search-line">
  <label>검색 기준 <select name="searchnum"><option value="0">프로젝트명</option><option value="1" <s:if test="searchnum == 1">selected="selected"</s:if>>팀장ID</option></select></label>
  <label class="sm-query">검색어 <input type="text" name="search" value="<s:property value='search'/>" placeholder="프로젝트명 또는 팀장ID"/></label>
  <button type="submit">검색하기</button><a href="ProjList.action">조건 초기화</a>
 </div>
 <details class="sm-filters"><summary>지역·전공·대회 필터</summary><p>검색어를 입력하면 검색어로 찾고, 비우면 아래 필터를 적용합니다.</p>
 <div class="sm-search-line">
 <label>대회/공모 <select name="comp"><option value="0">전체 대회</option><s:iterator value="complist" status="stat"><option <s:if test="comp == complist[#stat.index]">selected="selected"</s:if>><s:property value="%{complist[#stat.index]}"/></option></s:iterator></select></label>
 <label>지역 <select name="loc"><option value="0">전체 지역</option><s:iterator value="loclist" status="stat"><option <s:if test="loc == loclist[#stat.index]">selected="selected"</s:if>><s:property value="%{loclist[#stat.index]}"/></option></s:iterator></select></label>
 <label>전공 <select name="maj"><option value="0">전체 전공</option><s:iterator value="majlist" status="stat"><option <s:if test="maj == majlist[#stat.index]">selected="selected"</s:if>><s:property value="%{majlist[#stat.index]}"/></option></s:iterator></select></label>
 <button type="submit">필터 적용</button>
 </div></details>
</form>
<p class="sm-results" role="status">검색 결과 <s:property value="totalCount"/>개 · 모집 인원은 앞으로 합류할 수 있는 인원입니다.</p>
		<form action="favProj.action">
		 <table class="listtable sm-project-list">
			<tr class="list_title">
			 	<td><strong>팀장ID</strong></td>
			   <td><strong>프로젝트명</strong></td>
			   <td><strong>대회/공모</strong></td>
			   <td><strong>전공</strong></td>
			   <td><strong>프로젝트 기간</strong></td>
			   <td><strong>현재 참여 / 추가 모집</strong></td>
			   <td><strong>지역</strong></td>
			   <td><strong>임금</strong></td>
			</tr>
			
			<s:if test="list.size()<=0">
			   <tr class="no">
				  <td colspan="8">등록된 게시물이 없습니다.</td>
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
				 <td data-label="팀장 / 스크랩">
					  <s:if test="#session.auth == 2">
						  <s:checkbox theme="simple" name="teamno" fieldValue="%{teamno}"/>
					  </s:if>
					  <s:property value="leaderid" />
				  </td>
				  <td data-label="프로젝트" class="sm-project-name"><s:a href="%{viewURL}"><s:property value="title" /></s:a></td>
				  <td data-label="대회/공모"><s:property value="comp" /></td>
				  <td data-label="전공"><s:property value="maj" /></td>
				  <td data-label="기간"><s:property value="startdate" /> ~ <s:property value="enddate"/></td>
				  <td data-label="모집 상태">현재 <s:property value="currmem"/>명 · <s:if test="recmem > 0">추가 <s:property value="recmem"/>명</s:if><s:else><strong>모집 마감</strong></s:else></td>
				  <td data-label="지역"><s:property value="loc" /></td>
				  <td data-label="임금"><s:if test="sal == null || sal == ''">정보 없음</s:if><s:elseif test="sal == '0'">무급</s:elseif><s:else><s:property value="sal"/>원</s:else></td>
			   </tr>
			</s:iterator>
				<tr>
				   <td colspan="8">
					  <s:property value="pagingHtml" escape="false"/>
				   </td>
				</tr>
				 
				<s:if test="#session.auth == 2">	<!-- 팀원 -->
					<tr class="btn">
					   <td colspan="8">
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