<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SocialMap : 프로젝트 팀 정보</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
	<link rel="stylesheet" href="css/write.css" />
<script>
	function favList() {
		location.href="favSpec.action?id=<s:property value='resultClass.id'/>";
	}
</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>스펙정보 상세보기</h2>
		</div>
	</div>
		<div class="wrap">
			<table class="writetable">
				<tr>
					<td class="list">프리랜서 ID</td>
					<td class="input"><s:property value="resultClass.id" /></td>
				</tr>
				<tr>
					<td class="list">등록일</td>
					<td class="input"><s:property value="resultClass.regdate" /></td>
				</tr>
				<tr>
					<td class="list">기존 이력</td>
					<td class="input"><s:property value="resultClass.exp" /></td>
				</tr>
				<tr>
					<td class="list">전공</td>
					<td class="input"><s:property value="resultClass.maj" /></td>
				</tr>
				<tr>
					<td class="list">지역</td>
					<td class="input"><s:property value="resultClass.addr" /></td>
				</tr>
				<tr>
					<td class="list">추가내용</td>
					<td class="input"><s:property value="resultClass.contadd" /></td>
				</tr>
				<tr>
					<td class="list">공개/비공개</td>
					<td class="input"><s:property value="resultClass.showlog" /></td>
				</tr>
				
				<tr class="btn">
					<td colspan="2">
						<!-- 팀 참여 권유 버튼 -->
						<s:if test="auth == 1">
						<!-- 팀장이 개설한 프로젝트 목록 중 선택하여 권유하기 -->
						<input type="button" value="프로젝트 참여 권유" onclick="javascript:window.location='SpecHopeMsg.action?getid=${resultClass.id}'"/>
						</s:if>
						
						<input type="button" value="리스트" onclick="javascript:window.location='SpecList.action'"/>
						<input type="button" value="글 삭제" onclick="javascript:window.location='SpecDelete.action?id=<s:property value="resultClass.id"/>'"/>
						<input type="button" value="글 수정" onclick="javascript:window.location='SpecModify.action?step=0&id=<s:property value="resultClass.id"/>'"/>
						<s:hidden value="resultClass.id" />
						<input type="button" value="스크랩하기" onclick="favList()"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>