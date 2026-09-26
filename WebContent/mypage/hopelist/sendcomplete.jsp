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
			   <th><strong>참여 신청을 저장했습니다</strong></th>
			</tr>
			
			<tr align="center">	
						<td colspan="6">
							<p>상대방이 수락하면 내 프로젝트에서 참여 상태를 확인할 수 있습니다.</p>
						</td>
			</tr>
			
		</table>
		
		
				<div class="board_search">
					<input type="button"  value="내 프로젝트 확인" onclick="javascript:location.href='MyProjList.action'"/>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="title">
</div>
</body>
</html>