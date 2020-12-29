<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SocialMap : ������Ʈ �� ����</title>

	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<script src="js/main.js"></script>
	<link rel="stylesheet" href="css/header.css" />
	<script>
		$(document).ready(function() {
			 
			// ���� css���� �÷��� ��� ��ġ(top)���� ������ �����Ѵ�.
			var floatPosition = parseInt($(".floatMenu").css('top'));
			// 250px �̷������� �������Ƿ� ���⼭ ���ڸ� �����´�. parseInt( �� );
		 
			$(window).scroll(function() {
				// ���� ��ũ�� ��ġ�� �����´�.
				var scrollTop = $(window).scrollTop();
				var newPosition = scrollTop + floatPosition + "px";
		 
				/* �ִϸ��̼� ���� �ٷ� ����
				 $("#floatMenu").css('top', newPosition);
				 */
		 
				$(".floatMenu").stop().animate({
					"top" : newPosition
				}, 500);
		 
			}).scroll();
		 
		});
	</script>
</head>
<body>
	<tiles:insertAttribute name="top" />
	
	<div>
		<s:if test="mainpage == null || mainpage == ('main')">
			<tiles:insertAttribute name="main" />
		</s:if>
		<!-- �α��� ���� -->
		<s:elseif test="mainpage == ('login')">
			<tiles:insertAttribute name="login" />
		</s:elseif>
		<s:elseif test="mainpage == ('signup')">
			<tiles:insertAttribute name="signup" />
		</s:elseif>
		<s:elseif test="mainpage == ('findid')">
			<tiles:insertAttribute name="findid" />
		</s:elseif>
		<s:elseif test="mainpage == ('findpwd')">
			<tiles:insertAttribute name="findpwd" />
		</s:elseif>
		<s:elseif test="mainpage == ('findresult')">
			<tiles:insertAttribute name="findresult" />
		</s:elseif>
		
		<!-- ȸ�� ���� ���� -->
		<s:elseif test="mainpage == ('memberinfo')">
			<tiles:insertAttribute name="memberinfo" />
		</s:elseif>
		<s:elseif test="mainpage == ('membermodify')">
			<tiles:insertAttribute name="membermodify" />
		</s:elseif>
		
		<!-- ���� �Խñ� ���� -->
	      <s:elseif test="mainpage == ('favspeclist')">
	         <tiles:insertAttribute name="favspeclist" />
	      </s:elseif>
	      <s:elseif test="mainpage == ('favspecinfo')">
	         <tiles:insertAttribute name="favspecinfo" />
	      </s:elseif>
	      
	      <s:elseif test="mainpage == ('favprojlist')">
	         <tiles:insertAttribute name="favprojlist" />
	      </s:elseif>
	      <s:elseif test="mainpage == ('favprojinfo')">
	         <tiles:insertAttribute name="favprojinfo" />
	      </s:elseif>
		
		<!-- ������Ʈ �� ���� -->
		<s:elseif test="mainpage == ('projlist')">
			<tiles:insertAttribute name="projlist" />
		</s:elseif>
		<s:elseif test="mainpage == ('projinfo')">
			<tiles:insertAttribute name="projinfo" />
		</s:elseif>
		<s:elseif test="mainpage == ('projwrite')">
			<tiles:insertAttribute name="projwrite" />
		</s:elseif>
		
		<!-- ���� ������Ʈ ���� -->
		<s:elseif test="mainpage == ('myprojlist')">
			<tiles:insertAttribute name="myprojlist" />
		</s:elseif>
		<s:elseif test="mainpage == ('myprojinfo')">
			<tiles:insertAttribute name="myprojinfo" />
		</s:elseif>
		<s:elseif test="mainpage == ('myprojmodify')">
			<tiles:insertAttribute name="myprojmodify" />
		</s:elseif>
		
		<!-- ���� ���� -->
		<s:elseif test="mainpage == ('speclist')">
			<tiles:insertAttribute name="speclist" />
		</s:elseif>
		<s:elseif test="mainpage == ('specinfo')">
			<tiles:insertAttribute name="specinfo" />
		</s:elseif>
		<s:elseif test="mainpage == ('specmodify')">
			<tiles:insertAttribute name='specmodify' />
		</s:elseif>
		
		<!-- ������ ���� -->
		<s:elseif test="mainpage == ('complist')">
       	 	<tiles:insertAttribute name="complist" />
        </s:elseif>
        <s:elseif test="mainpage == ('compinfo')">
       		<tiles:insertAttribute name="compinfo" />
        </s:elseif>
        
	    <div class="floatMenu">
			<tiles:insertAttribute name="right" />
		</div>
		
		<!-- qna -->
 		<s:elseif test="mainpage == ('qnalist')">
			<tiles:insertAttribute name="qnalist" />
		</s:elseif>
		<s:elseif test="mainpage == ('qnainfo')">
			<tiles:insertAttribute name="qnainfo" />
		</s:elseif>
		<s:elseif test="mainpage == ('qnawrite')">
			<tiles:insertAttribute name="qnawrite" />
		</s:elseif>
		
		<!-- as -->
		<s:elseif test="mainpage == ('aslist')">
			<tiles:insertAttribute name="aslist" />
		</s:elseif>
		<s:elseif test="mainpage == ('asinfo')">
			<tiles:insertAttribute name="asinfo" />
		</s:elseif>
		
		<!-- faq -->
		<s:elseif test="mainpage == ('faqlist')">
			<tiles:insertAttribute name="faqlist" />
		</s:elseif>
		
		<!-- hopelist -->
		<s:elseif test="mainpage == ('hopelist')">
			<tiles:insertAttribute name="hopelist" />
		</s:elseif>
		<s:elseif test="mainpage == ('deletehopelist')">
			<tiles:insertAttribute name="hopelist" />
		</s:elseif>
		
		
		<s:elseif test="mainpage == ('guide')">
			<tiles:insertAttribute name="guide" />
		</s:elseif>
		<s:elseif test="mainpage == ('guide1')">
			<tiles:insertAttribute name="guide1" />
		</s:elseif>
		<s:elseif test="mainpage == ('guide2')">
			<tiles:insertAttribute name="guide2" />
		</s:elseif>
		<s:elseif test="mainpage == ('guide3')">
			<tiles:insertAttribute name="guide3" />
		</s:elseif>
	</div>
	<div>
		<tiles:insertAttribute name="bottom" />
	</div>
</body>
</html>
<!-- http://localhost:8080/SocialMap/SocialMap.action -->