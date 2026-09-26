<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : 프로젝트 팀 개설</title>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/write.css">
	<script type="text/javascript">
		function validation() {
			var frm = document.userinput;
			if(frm.title.value.trim() == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if(frm.cont.value.trim() == "") {
				alert("내용을 입력해주세요");
				return false;
			}
            if (!/^\d{1,2}$/.test(frm.recmem.value.trim()) || Number(frm.recmem.value) < 1) {
                alert("모집인원은 1~99 사이의 숫자로 입력해주세요"); frm.recmem.focus(); return false;
            }
            if (frm.sal.value.trim() && !/^\d{1,6}$/.test(frm.sal.value.trim())) {
                alert("임금은 6자리 이하의 숫자로 입력해주세요"); frm.sal.focus(); return false;
            }
            if (frm.startdate.value && frm.enddate.value && frm.enddate.value < frm.startdate.value) {
                alert("종료일은 시작일보다 빠를 수 없습니다"); frm.enddate.focus(); return false;
            }
            return true;
			
		}
		function majorCheck(){
			url="Major.action";
			window.open(url,"post","toolbar=no ,width=350 ,height=400 ,directories=no,status=yes,scrollbars=yes,menubar=no");
		}
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>프로젝트 등록하기</h2>
		</div>
	</div>
		<div class="wrap">
			<s:if test="step == 2">
				<script type="text/javascript">location.href="ProjList.action?check=<s:property value='check'/>";</script>
				
			</s:if>
			
			<s:else>
				<form action="<s:if test="teamno != null && teamno != '' && teamno != '0'">ProjModify.action</s:if><s:else>ProjWrite.action</s:else>" method="post" name="userinput" enctype="multipart/form-data" onsubmit="return validation();">
					<table class="writetable">
						<tr>
							<td class="list">팀장 ID</td>
							<td class="input"><s:property value='#session.id'/></td>
						</tr>
						<tr>
							<td class="list">글 제목</td>
							<td class="input"><input type="text" name="title" aria-label="프로젝트 제목" maxlength="30" value="<s:property value='resultClass.title'/>"></td>
						</tr>
						<tr>
							<td class="list">대회 및 공모전 계획</td>
							<td class="input"><input type="text" name="comp" aria-label="대회 및 공모전" maxlength="10" value="<s:property value='resultClass.comp'/>"></td>
						</tr>
						<tr>
							<td class="list">시작일</td>
							<td class="input"><input type="date" name="startdate" aria-label="시작일" value="<s:property value='resultClass.startdate'/>"></tr>
						<tr>
						
						<tr>
							<td class="list">종료일</td>
							<td class="input"><input type="date" name="enddate" aria-label="종료일" value="<s:property value='resultClass.enddate'/>"></tr>
						<tr>

						<tr>
							<td class="list">추가 모집 인원 (1~99명)</td>
							<td class="input"><input type="text" name="recmem" inputmode="numeric" aria-label="추가 모집 인원" maxlength="2" value="<s:property value='resultClass.recmem'/>"></td>
						</tr>
						<tr>
							<td class="list">모집전공</td>
							<td class="input">
								<input type="text" name="maj" aria-label="모집전공" maxlength="50" value="<s:property value='resultClass.maj'/>">
								<input type="button" onclick="majorCheck()" value="전공 찾기" />
							</td>
						</tr>
						
						<tr>
							<td class="list">글 내용</td>
							<td class="input"><s:textarea theme="simple" rows="4" cols="50" name="cont" value='%{resultClass.cont}'/></td><!--  style="overflow: hidden;" -->
						</tr>
						
						<tr>
							<td class="list">지역</td>
							<td class="input"><input type="text" name="loc" aria-label="지역" maxlength="20" value="<s:property value='resultClass.loc'/>"></td>
						</tr>
						
						<tr>
							<td class="list">임금 (원, 0은 무급)</td>
							<td class="input"><input type="text" name="sal" inputmode="numeric" aria-label="임금" maxlength="6" value="<s:property value='resultClass.sal'/>"></td>
						</tr>
						
						<tr class="btn">
							<td colspan="2">
								<s:hidden value="1" name="step"/>
								<s:hidden value="%{teamno}" name="teamno"/>
								<input type="button" value="취    소" onclick="javascript:window.location='ProjList.action'" >
								<input type="submit" value="작성하기">
							</td>
						</tr>
					</table>
				</form>
			</s:else>
		</div>
	</div>
	<div class="title">
	</div>
</body>
</html>