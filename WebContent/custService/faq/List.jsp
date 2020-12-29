<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="js/main.js"></script>
	<link rel="stylesheet" href="css/faq.css" />
<title>FAQ - 자주묻는 질문</title>
</head>
<body>
<div class="contents clearfix">
	<div class="title">
		<div class="wrap">
			<h2>FAQ</h2>
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
		<div class="detailbox">
			<div class="tstyle_list">
			<!-- 글쓰기는 관리자 권한 -->
			<%-- <dl class="btn">
				<dt>
					<input type="button" value="글쓰기" onClick="javascript:location.href='FAQWriteForm.action?currentPage=<s:property value="currentPage"/>';">
				</dt>
			</dl> --%>
				<dl>
					<s:if test="list.size()<=0">
						<dt>
							등록된 게시물이 없습니다.
						</dt>
					</s:if>
					 
					<s:iterator value="list" status="stat">
						<s:hidden name="no" value="%{resultClass.no}" />
						<s:hidden name="custlog" value="%{resultClass.custlog}"/>
						<dt>
							<span class="q">Q</span>
							<a href="#" onclick="toggles('answer_<s:property value='no' />')">
								<span class="q_cnt">
									<s:property value="title" />
								</span>
							</a>
						</dt>
						<dd id="answer_<s:property value="no" />" style="display:none;">
							<div class="a_cnt"><s:property value="cont" /></div>
						</dd>
					</s:iterator>
					<div align="center">
						<s:property value="pagingHtml" escape="false"/>
					</div>
				</dl>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>