<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : 프로젝트 팀 정보</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/write.css" />
<script type="text/javascript"></script>
</head>
<body>
<div class="contents clearfix sm-project-page">
	<div class="title">
		<div class="wrap">
			<h2><s:property value="resultClass.title" /></h2>
		</div>
	</div>
	<div class="wrap">
		<div class="sm-project-status">
			<s:if test="resultClass.status == 'completed'"><span class="sm-chip done">완료된 프로젝트</span></s:if>
			<s:elseif test="resultClass.status == 'released'"><span class="sm-chip closed">해산된 프로젝트</span></s:elseif>
			<s:elseif test="resultClass.recmem > 0"><span class="sm-chip open">모집 중 · 추가 <s:property value="resultClass.recmem" />명</span></s:elseif>
			<s:else><span class="sm-chip closed">모집 마감</span></s:else>
			<span class="sm-chip"><s:property value="resultClass.comp" /></span>
			<span class="sm-leader">팀장 <s:property value="resultClass.leaderid" /></span>
		</div>
		<div class="sm-project-grid">
			<section class="sm-project-body">
				<h3>프로젝트 소개</h3>
				<p class="sm-preserve"><s:property value="resultClass.cont" /></p>
			</section>
			<aside class="sm-project-facts">
				<h3>모집 조건</h3>
				<dl>
					<dt>팀장 ID</dt><dd><s:property value="resultClass.leaderid" /></dd>
					<dt>카테고리</dt><dd><s:property value="resultClass.comp" /></dd>
					<dt>시작일</dt><dd><s:property value="resultClass.startdate" /></dd>
					<dt>종료일</dt><dd><s:property value="resultClass.enddate" /></dd>
					<dt>찾는 전공</dt><dd><s:property value="resultClass.maj" /></dd>
					<dt>현재 참여 인원</dt><dd><s:property value="resultClass.currmem" />명</dd>
					<dt>추가 모집 인원</dt><dd><s:property value="resultClass.recmem" />명</dd>
					<dt>지역</dt><dd><s:property value="resultClass.loc" /></dd>
					<dt>임금</dt><dd><s:if test="resultClass.sal == null || resultClass.sal == ''">정보 없음</s:if><s:elseif test="resultClass.sal == '0'">무급</s:elseif><s:else><s:property value="resultClass.sal"/>원</s:else></dd>
				</dl>
				<div class="sm-actions">
						<s:if test="auth == 2 && resultClass.recmem > 0">
							<!-- 팀장이 개설한 프로젝트 목록 중 선택하여 권유하기 -->
							<input type="button" value="프로젝트 참여 희망" onclick="javascript:window.location='ProjHopeMsg.action?getid=${resultClass.leaderid}'"/>
						</s:if>

						<s:if test="resultClass.recmem <= 0"><p role="status">모집이 마감된 프로젝트입니다.</p></s:if>
						<input type="button" value="리스트로 돌아가기" onclick="javascript:window.location='ProjList.action'"/>
						
						<s:if test="id == resultClass.leaderid">
							<input type="button" value="프로젝트 삭제" onclick="if(confirm('프로젝트를 삭제하시겠습니까?')) window.location='ProjDelete.action?leaderid=<s:property value="resultClass.leaderid"/>&teamno=<s:property value="resultClass.teamno"/>'" >
							<input type="button" value="프로젝트 수정" onclick="javascript:window.location='ProjModify.action?step=0&teamno=<s:property value="resultClass.teamno"/>'" >
						</s:if>
						
						<%-- <input type="button" value="글 삭제" onclick="javascript:window.location='ProjDelete.action?leaderid=<s:property value="resultClass.leaderid"/>&teamno=<s:property value="resultClass.teamno"/>'"/>
						<input type="button" value="프로젝트 수정" onClick="javascript:location.href='ProjModify.action?step=0&teamno=<s:property value='teamno'/>'" > --%>
					</div>
			</aside>
		</div>
	</div>
</div>
<s:if test="#session.id == resultClass.leaderid || #session.auth == 0"><form class="sm-lifecycle" action="ProjLifecycle.action" method="post"><input type="hidden" name="csrf" value="<s:property value="#session.csrf"/>"><input type="hidden" name="teamno" value="<s:property value="resultClass.teamno"/>"><label>프로젝트 상태<select name="status"><option value="closed">모집 마감</option><option value="completed">완료 및 팀원 해제</option><option value="released">해산</option></select></label><button type="submit">상태 변경</button></form></s:if></body>
</html>