<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>대회정보 - 글 등록</title>
	<script type="text/javascript">
		function validation() {
			var frm = document.forms(0);
			if(frm.title.value == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if(frm.cont.value == "") {
				alert("내용을 입력해주세요");
				return false;
			}
			return true;
		}
	</script>
</head>
<body>
	<s:if test="step == 2 && no == 0">
		<script type="text/javascript">location.href="CompList.action";</script>
	</s:if>
	<s:elseif test="step == 2 && no != 0">
		<script type="text/javascript">location.href="CompInfo.action?no=<s:property value='no'/>";</script>
	</s:elseif>
	<s:else>
		<s:if test="no == 0">
			<form action="CompWrite.action" method="post" enctype="multipart/form-data" onsubmit="return validation();">
		</s:if>
		<s:else>
			<form action="CompModify.action" method="post" enctype="multipart/form-data" onsubmit="return validation();">
				<s:hidden name="no" value="%{no}" />
		</s:else>
			<table border="0" align="center">
				<tr height="30px">
					<td align="center" width="150">제목</td>
					<td align="left" width="400">
						<s:textfield name="title" theme="simple" value="%{resultClass.title}" maxlength="50" size="48"/>
					</td>
				</tr>
				<tr height="30px">
					<td align="center">
						시작일&마감일
					</td>
					<td align="left">
					<s:textfield name="startdate" theme="simple" value="%{resultClass.startdate}" maxlength="25" />
					~ <s:textfield name="enddate" theme="simple" value="%{resultClass.enddate}" maxlength="25" />
					</td>
				</tr>
				<tr height="140px">
					<td align="center" valign="middle">내용</td>
					<td align="center" valign="middle">
						<s:textarea name="cont" theme="simple" value="%{resultClass.cont}" rows="8" cols="60" />
					</td>
				</tr>
				<tr height="320px">
					<td align="center" valign="middle">상세내용</td>
					<td align="center" valign="middle">
						<s:textarea name="contadd" theme="simple" value="%{resultClass.cont}" rows="20" cols="60" />
					</td>
				</tr>
				<tr height="30px">
					<td align="center" valign="middle">이미지</td>
					<td align="center">
						<s:file name="upload" theme="simple" />
					</td>
				</tr>
				<tr height="30px">
					<td align="center" valign="middle">비공개 처리</td>
					<td align="center">
						<s:checkbox name="check" theme="simple" value="%{resultClass.showlog}" />
					</td>
				</tr>
				<tr height="30px">
					<td colspan="2" align="left">
						<s:if test="no == 0">
							<a href="http://localhost:8080/SocialMap/CompList.action">리스트</a>
						</s:if>
						<s:else>
							<a href="http://localhost:8080/SocialMap/CompInfo.action?no=<s:property value='no'/>">뷰</a>
						</s:else>
					</td>
					<td colspan="2" align="left">
						
					</td>
					<td colspan="2" align="right">
						<input type="hidden" value="1" name="step">
						<input type="submit" value="글등록" >
					</td>
				</tr>
			</table>
		</form>
	</s:else>
</body>
</html>