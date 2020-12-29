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
				showOn: "both",							// 달력을 표시할 타이밍 (both: focus or button)
				buttonImage: "images/calendar.gif", // 버튼 이미지
				buttonImageOnly : true,				 // 버튼 이미지만 표시할지 여부
				buttonText: "날짜선택",				 // 버튼의 대체 텍스트
				dateFormat: "yy-mm-dd",				 // 날짜의 형식
				changeMonth: true,						// 월을 이동하기 위한 선택상자 표시여부
				//minDate: 0,								// 선택할수있는 최소날짜, ( 0 : 오늘 이전 날짜 선택 불가)
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
<form action="favProj.action">
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>프로젝트 찾기</h2>
		</div>
	</div>
		<div class="wrap">
			<table class="searchtable">
				<tr>
					<td>
						<form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" >
							<div class="selectbox">
								카테고리
								<select name="comp">
										<option value="0">--선택--</option>
										<option>개발</option>
										<option>디자인</option>
								</select>
								&nbsp; | &nbsp;
								지역
								<select name="loc">
										<option value="0">--선택--</option>
										<option>서울</option>
										<option>부산</option>
								</select>
								&nbsp; | &nbsp;
								자격요건
								<select name="maj">
										<option value="0">--선택--</option>
										<option>전기</option>
										<option>컴퓨터</option>
										<option>전자</option>
								</select>
								<div class="date">
									<br />프로젝트 기간
									<label for="fromDate">시작일</label>
									
									<input type="text" name="fromDate" id="fromDate">
									~
									<label for="toDate">종료일</label>
									<input type="text" name="toDate" id="toDate">
									<s:submit theme="simple" value="필터 적용"/>	
								</div>
							</div>
						</form>
					</td>
				</tr>
				<tr class="searchbox">
					<td colspan="6">
						<form action="ProjList.action" method="post" name="form" enctype="multipart/form-data" >
							<input type="text" placeholder="프로젝트 검색">
							<s:submit theme="simple" value="검색"/>	
						</form>
					</td>
				</tr>
			</table>
			<table class="listtable">
				<tr class="list_title">
					<td><strong>팀장ID</strong></td>
					<td><strong>프로젝트명</strong></td>
					<td><strong>카테고리</strong></td>
					<td><strong>프로젝트 기간</strong></td>
					<td><strong>모집인원/현재모집인원</strong></td>
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
							<input type="submit" value="글쓰기" />
						</form>					
					</td>
				</tr>
				<tr>
					<td>
						<a href="/SocialMap/admin/adminPageHome.jsp">관리자 페이지</a>
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