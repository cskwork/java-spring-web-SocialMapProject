<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>Q&A</title>
	<script type="text/javascript">
		function validation() {
			if(document.getElementById("frm").title.value == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if(document.getElementById("frm").cont.value == "") {
				alert("내용을 입력해주세요");
				return false;
			}
			return true;
		}
	</script>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>Q&A > 질문 작성하기</h2>
		</div>
	</div>
	<div class="wrap">
		<div class="sidebox">
			<h2>Help Desk</h2>
			<ul>
				<li><a href="QnaList.action">Q&A</a></li>
				<li><a href="FAQList.action">FAQ</a></li>
				<li><a href="ASList.action">공지사항</a></li>
			</ul>
		</div>
	</div>
	<div class="detailbox">
	<s:if test="step == 0">
		<!-- 글쓰기 액션 -->
		<s:if test="no==0">
			<form action="QnaWrite.action" id="frm" method="post" onsubmit="return validation();">
		</s:if>
		
		<s:else>
			<form action="QnaModify.action" id="frm" method="post" onsubmit="return validation();">
			<s:hidden name="no" value="%{no}" />
			<s:hidden name="currentPage" value="%{currentPage}" />
		</s:else>		
			<table>
				<tr>
					<td style="font-weight:800;"><font color="#ff0000">*</font>는 필수 입력사항입니다.</td>
				</tr>				
				<tr>
				<td>	
				<table class="tstyle_list" width="750px">
					<tr>
						<td class="list">
							<font color="#FF0000">*</font> 문의제목
						</td>
						<td>
							<s:textfield name="title" id="title" theme="simple" value="%{resultClass1.title}" cssStyle="width:370px" maxlength="30"/>
						</td>
					</tr>
			
					<tr>
						<td class="list"><font color="#FF0000">*</font>	아이디 </td>
						<td><s:property value="id"/></td>
					</tr>
											
					<tr>
						<td class="list"><font color="#FF0000">*</font>	내용 </td>
						<td>
							<s:textarea name="cont" id="cont" theme="simple" value="%{resultClass1.cont}" cols="50" rows="10" ></s:textarea>	
						</td>
					</tr>
					
					<tr>
						<td colspan="2">
							<!-- 여기서 step을 바꿔준다 -->
							<input type="hidden" name="step" value="1">
							<s:if test="no==0">
								<input type="submit" value="작성완료" >
							</s:if>
							<s:else>
								<input type="submit" value="질문수정">	
							</s:else>
							<input type="button" value="목록" class="submit" onClick="javascript:location.href='QnaList.action?currentPage=<s:property value="currentPage"/>'">
						</td>
					</tr>
				</table>
				</td>
				</tr>
			</table>
		 </form>
	</s:if>	
	<s:else>
		<script type="text/javascript">location.href="QnaList.action?currentPage=<s:property value='currentPage'/>" </script>
	</s:else>
	</div>
</div>
<div class="title">
</div>
</body>
</html>