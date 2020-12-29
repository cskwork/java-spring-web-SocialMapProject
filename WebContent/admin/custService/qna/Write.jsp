<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Q&A</title>
</head>
<body>
	<s:if test="step == 0">
		<div align="center">
			<table width="600" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td align="center" class="text01 formbar"><h2>Q&A</h2></td>
				</tr>
			</table>
			<s:if test="list.size() > 1">
				<form action="QnaAdminModify.action" method="post">
			</s:if>
			<s:else>
				<form action="QnaAdminWrite.action" method="post">
			</s:else>
				<table width="600" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="right" colspan="2"><font color="#FF0000">*</font>는 필수 입력사항입니다.</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td align="center">
										<font color="#FF0000">*</font> 질문 제목
									</td>
									<td>
										<s:property value="title"/>
									</td>
								</tr>
								
								<tr>
									<td align="center">
										<font color="#FF0000">*</font> 질문 내용
									</td>
									<td>
										<s:property value="cont"/>
									</td>
								</tr>
								
								<tr>
									<td class="tdstyle2"><font color="#FF0000">*</font>	아이디 </td>
									<td class="tdstyle2"><s:property value="id"/></td>
								</tr>
								
								<tr>
									<td class="tdstyle2"><font color="#FF0000">*</font> 답변 </td>
									<td class="tdstyle2">
										<s:textarea name="cont" theme="simple" value="%{resultClass2.cont}" cols="50" rows="10" ></s:textarea>	
									</td>
								</tr>
								
								<tr>
									<td align="right" colspan="2">
										<input type="hidden" name="step" value="1">
										<s:hidden name="no" value="%{no}" />
										<s:hidden name="title" value="%{title}" />
										<input type="submit" value="완료" >
										<input type="button" value="목록" class="submit" onClick="javascript:location.href='QnaList.action?currentPage=<s:property value="currentPage"/>'">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			 </form>
		</div>
	</s:if>
	<s:else>
		<script type="text/javascript">location.href="QnaInfo.action?no=<s:property value='no'/>" </script>
	</s:else>
</body>
</html>