<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>마이 페이지 - 내 정보 수정하기</title>
</head>
<script>
	function checkIt() {
        var userinput = eval("document.userinput");
        
        if(!userinput.pwd.value ) {
            alert("비밀번호를 입력하세요");
            return false;
        }
        if(userinput.pwd.value != userinput.pwd2.value) {
            alert("비밀번호를 동일하게 입력하세요");
            return false;
        }
      
        if(!userinput.name.value) {
            alert("사용자 이름을 입력하세요");
            return false;
        }
        if(!userinput.birth.value  || !userinput.gen.value ) {
            alert("주민등록번호를 입력하세요");
            return false;
        }
	}
	function view() {
		location.href="modifyMemberForm.action";
	}
	function favList() {
		location.href="favSpecList.action";
	}
	function favProj() {
		location.href="favProjList.action";
	}
	function myProj() {
		location.href="MyProjList.action";
	}
	function pwdCheck(){
		url="deleteMemberForm.action";
		window.open(url,"post","toolbar=no ,width=300 ,height=200 ,directories=no,status=yes,scrollbars=yes,menubar=no");
	}
</script>
<body>
<div class="contents clearfix">
	<div class="title">       
		<div class="wrap">
			<h2>마이페이지 > 내정보수정/탈퇴</h2>
		</div>
	</div>
	<div class="wrap">
		<div class="sidebox">
			<h2>My Page</h2>
			<s:if test="auth == 1">
				<ul>
					<li><a href="javascript:view()">내정보수정/탈퇴</a></li>
					<li><a href="javascript:favList()">관심스펙리스트</a></li>
					<!-- <li><a href="javascript:favProj()">관심플젝리스트</a></li> -->
					<li><a href="javascript:myProj()">나의 프로젝트</a></li>
					<li><a href="javascript:hopeList()">참여 희망자</a></li>
					<li><a href="#" onClick="window.open('RatingList.action','평점','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">평점 보기</a></li> 
				</ul>
			</s:if>
			<s:elseif test="auth == 2">
				<ul>
					<li><a href="javascript:view()">내정보수정/탈퇴</a></li>
					<!-- <li><a href="javascript:favList()">관심스펙리스트</a></li> -->
					<li><a href="javascript:favProj()">관심플젝리스트</a></li>
					<li><a href="javascript:myProj()">나의 프로젝트</a></li>
					<li><a href="javascript:hopeList()">참여 제안</a></li>
					<li><a href="#" onClick="window.open('RatingList.action','평점','width=700, height=650, toolbar=no, menubar=no, scrollbars=no, resizable=yes');return false;">평점 보기</a></li> 
				</ul>
			</s:elseif>
		</div>
		<div class="detailbox">
		<form method="post" action="modifyMember.action" name="userinput" onsubmit="return checkIt()">
			<table class="tstyle_list" width="750px">
				<tr>
					<td style="font-weight:800;" colspan="2">나의 정보수정하기</td>
				</tr>
				<tr>
					<td class="list">사용자 ID</td>
					<td><s:property value="id"/></td>
				</tr>
				<tr>
					<td class="list">이름</td>
					<s:hidden name="name"/>
					<td><s:property value="name"/></td>
				</tr>
				<tr>
					<td class="list">비밀번호</td>
					<td><s:textfield name="pwd" theme="simple" value="%{resultClass.pwd}" maxlength="30" cssStyle="width: 100%; height: 25px;"/></td>
				</tr>
				<tr>
					<td class="list">주민등록 번호</td>
					<td><s:textfield name="birth" theme="simple" value="%{resultClass.birth}" maxlength="6" cssStyle="width: 165px; height: 30px" />
					 - 
					 <s:textfield name="gen" theme="simple" value="%{resultClass.gen}" maxlength="1" cssStyle="width: 15px; height: 30px"/>
					 ******</td>
				</tr>
				<tr>
					<td class="list">E-mail</td>
					<td><s:textfield name="email" theme="simple" value="%{resultClass.email}" maxlength="30" cssStyle="width: 100%; height: 25px;"/></td>
				</tr>
				<tr>
					<td class="list">주소</td>
					<td><s:textfield name="addr" theme="simple" value="%{resultClass.addr}" maxlength="50" cssStyle="width: 100%; height: 25px;"/></td>
				</tr>
				<tr>
					<td class="list">전공</td>
					<td><s:textfield name="maj" theme="simple" value="%{resultClass.maj}" maxlength="50" cssStyle="width: 100%; height: 25px;"/></td>
				</tr>
				<tr>
					<td class="list">전공관련 이력</td>
					<td><textarea name="exp" rows="7" cols="80" style="overflow: hidden;" ><s:property value="%{resultClass.exp}"/></textarea></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="submit" value="수정완료" >
						<input type="button" value="탈퇴하기" onclick="pwdCheck()">
						<input type="button" value="취    소" onclick="javascript:window.location='MyPage.action'" >
					</td>
				</tr>
			</table>
		</form>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>