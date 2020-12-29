<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" href="css/notice.css" />
<title>신청</title>
</head>
<body>
<div class="contents clearfix">
   <div class="title">
	  <div class="wrap">
		 <h2>신청 완료</h2>
	  </div>
   </div>
   
	  <div class="detailbox">
	  <div class="table board_list">
		 <table class="tstyle_list">
			<tr>
			   <th><strong>신청 완료</strong></th>
			</tr>
			
			<tr align="center">	
						<td colspan="6">
							<s:property value="pagingHtml" escape="false"/>
						</td>
			</tr>
			
		</table>
		
		
				<div class="board_search">
					<input type="button"  value="돌아가기" onclick="javascript:location.href='MyPage.action'"/>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>