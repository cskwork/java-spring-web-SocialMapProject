
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	 pageEncoding="EUC-KR"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import = "java.util.HashMap" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>평점</title>
<style type="text/css">

.stars_label input {
display:none;
}
.star_l {
float:left;
margin:0px;
background:url(./images/star_02_01.jpg) no-repeat left top;
display:block;
border:0px;
width:12px;
height:23px;
overflow:hidden;
}
.star_l:hover {
background:url(/SocialMap/mypage/images/star_02_01.jpg) no-repeat left top;
}
.stars_label input[type=checkbox]:checked + .star_l {
background:url(/SocialMap/mypage/images/star_01_01.jpg) no-repeat left top;
}


.star_r {
float:left;
margin:0px;
background:url(/SocialMap/mypage/images/star_02_02.jpg) no-repeat left top;
display:block;
border:0px;
width:12px;
height:23px;
overflow:hidden;
}
.star_r:hover {
background:url(/SocialMap/mypage/images/star_02_02.jpg) no-repeat left top;
}
.stars_label input[type=checkbox]:checked + .star_r {
background:url(/SocialMap/mypage/images/star_01_02.jpg) no-repeat left top;
}

.rate_star {
width:12px;
height:23px;
float:left;
}
</style>
<script type="text/javascript">

function view_review_star(var1, var2) {
	var i;
	
	//모든별 흑백
	for(i=1;i<=10;i++) {
		document.getElementById("star_img"+i).checked = false;
	}
	//선택별까지 컬러
	for(i=1;i<=var1;i++) {
		document.getElementById("star_img"+i).checked = true;
	}
	document.getElementById("stars").value = var2;
}

function closeWin() {
		    var nvua = navigator.userAgent;
		    if (nvua.indexOf('MSIE') >= 0){
		        if(nvua.indexOf('MSIE 5.0') == -1) {
		            top.opener = '';
		        }
		    } else if (nvua.indexOf('Gecko') >= 0){
		        top.name = 'CLOSE_WINDOW';
		        wid = window.open('','CLOSE_WINDOW');
		    }
		    top.close();
		}
	</script>
</head>
<body>
	<table style="width: 670px; height: 600px; border-spacing: 0; padding: 0; margin: auto;" border="1">
	<tr valign="middle" height="10%">
	<td>
		<form action="RatingList.action" name="form" method="post" enctype="multipart/form-data" >
			<table style="margin: auto; width: 100%;" border="0">
				<tr>
					<td align="left">
						<a href="RatingWrite.action">평가쓰기</a>
						<a href="RatingList.action">평가보기  </a>
						<a href="javascript:document.log.submit();">평가확인  </a>
					</td>
				</tr>
			</table>
		</form>
		<form action="RatingList.action" name="log" method="post" enctype="multipart/form-data" >
			<s:hidden value="<s:property value='id'/>" name="sendid" />
		</form>
	</td>
	</tr>
	
	<tr valign="top" height="90%">
	<td>
		<form action="RatingDelete.action" name="form" method="post" enctype="multipart/form-data" >
			<table style="margin: auto; width: 100%; height: 90%" border="0">
				<tr valign="top">
				<td>
				<table style="width: 100%; height: 20px" border="0">
					<tr valign="top">
						<td width="1%" align="center"><input type="checkbox" /></td>
						<td width="30%" align="center">프로젝트명</td>	
						<td width="20%" align="center">평점</td>
						<td width="30%" align="center">한줄평</td>
						<td width="20%" align="center">날짜</td>
					</tr>
				</table>
				</td>
				</tr>
				
				<tr valign="top" height="">
				<td>
				<table style="width: 100%; height: 20px" border="0">
				<c:forEach items="${list}" var="datas" >
					<tr align="center">
							<td width="1%" align="center"><input type="checkbox" name="" /></td>
							<td width="30%" align="center">${datas.title}</td>
							<td width="20%" align="center">
		
							<c:set var="star_tmp" value="1" scope="request"></c:set>
							
							<c:forEach begin="1" end="${datas.rate}">
								<c:if test="${star_tmp eq 1}"><div class="rate_star"><img src="/SocialMap/mypage/images/star_01_01.jpg" alt="star1" /></div></c:if>
								<c:if test="${star_tmp eq -1}"><div class="rate_star"><img src="/SocialMap/mypage/images/star_01_02.jpg" alt="star2" /></div></c:if>
								<c:set var="star_tmp" value="${star_tmp * (-1)}" scope="request"></c:set>
							</c:forEach>
							<c:forEach begin="1" end="${10-datas.rate}">
								<c:if test="${star_tmp eq 1}"><div class="rate_star"><img src="/SocialMap/mypage/images/star_02_01.jpg" alt="star1" /></div></c:if>
								<c:if test="${star_tmp eq -1}"><div class="rate_star"><img src="/SocialMap/mypage/images/star_02_02.jpg" alt="star2" /></div></c:if>
								<c:set var="star_tmp" value="${star_tmp * (-1)}" scope="request"></c:set>
							</c:forEach>

							</td>
							<td width="30%" align="center">${datas.reputation}</td>
							<td align="left" width="20%">${datas.ratingregdate}</td>
						</tr>
				</c:forEach>
				</table>
				</td>
				</tr>
					
				<tr>	
					<td colspan="5" align="center">
						<s:property value="pagingHtml" escape="false"/>
					</td>
				</tr>
					
				<tr>
					<td align="right">
						<input type="submit" value="삭제"/>
						<input type="button" value="닫기" onclick="javascript:history.onclick=closeWin();"/>
					</td>
				</tr>
			</table>
		</form>
	</td>
	</tr>
	</table>
</body>
</html>




<%--

오류 코드!!!!@!@!#@!#@!#


 <%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import = "java.util.HashMap" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<style type="text/css">

.stars_label input {
display:none;
}
.star_l {
float:left;
margin:0px;
background:url(./images/star_02_01.jpg) no-repeat left top;
display:block;
border:0px;
width:12px;
height:23px;
overflow:hidden;
}
.star_l:hover {
background:url(./images/star_02_01.jpg) no-repeat left top;
}
.stars_label input[type=checkbox]:checked + .star_l {
background:url(./images/star_01_01.jpg) no-repeat left top;
}


.star_r {
float:left;
margin:0px;
background:url(./images/star_02_02.jpg) no-repeat left top;
display:block;
border:0px;
width:12px;
height:23px;
overflow:hidden;
}
.star_r:hover {
background:url(./images/star_02_02.jpg) no-repeat left top;
}
.stars_label input[type=checkbox]:checked + .star_r {
background:url(./images/star_01_02.jpg) no-repeat left top;
}

</style>
<script type="text/javascript">

function view_review_star(var1, var2) {
	var i;
	
	//모든별 흑백
	for(i=1;i<=10;i++) {
		document.getElementById("star_img"+i).checked = false;
	}
	//선택별까지 컬러
	for(i=1;i<=var1;i++) {
		document.getElementById("star_img"+i).checked = true;
	}
	document.getElementById("stars").value = var2;
}

function closeWin() {
    var nvua = navigator.userAgent;
    if (nvua.indexOf('MSIE') >= 0){
        if(nvua.indexOf('MSIE 5.0') == -1) {
            top.opener = '';
        }
    } else if (nvua.indexOf('Gecko') >= 0){
        top.name = 'CLOSE_WINDOW';
        wid = window.open('','CLOSE_WINDOW');
    }
    top.close();
}
</script>

</head>

<body>

<!-- 평점 시스템 -->

	<table style="width: 670px; height: 600px; border-spacing: 0; padding: 0; margin: auto;" border="1">
	<tr valign="middle" height="10%">
	<td>
		<form action="RatingList.action" name="form" method="post" enctype="multipart/form-data" >
			<table style="margin: auto; width: 100%;">
				<tr>
					<td align="left">
						<a href="RatingWrite.action">평가쓰기</a>
						<a href="RatingList.action">평가보기  </a>
						<a href="javascript:document.log.submit();">평가확인  </a>
					</td>
					<td align="right">
						검색 
						<input type="search" name="searchValue" /> 
						<input type="submit" value="search" />
					</td>
				</tr>
			</table>
		</form>
		<form action="RatingList.action" name="log" method="post" enctype="multipart/form-data" >
			<s:hidden value="<s:property value='id'/>" name="sendid" />
		</form>
	</td>
	</tr>
	
	<tr valign="top" height="90%">
	<td>
	
		<form action="RatingDelete.action" name="form" method="post" enctype="multipart/form-data" >
			<table style="margin: auto; width: 100%; height: 90%" border="0">
				<tr valign="top" height="">
				<td>
				<table style="width: 100%; height: 20px" border="0">
					<tr valign="top">
						<td width="10px" align="center"><input type="checkbox" /></td>
						<td width="350px" align="center">프로젝트명</td>
						<td width="150px" align="center">날짜</td>
						<td width="350px" align="center">평점</td>
					</tr>
				</table>
				</td>
				</tr>
				<tr valign="top" height="">
				<td>
				
				<table style="width: 100%; height: 20px" border="0">
					
					<!-- 	
					글 내용 부분
					<s:iterator value="list" status="stat">
						<s:url id="viewURL" action="RatingInfo.action">
							<s:param name="getid">
								<s:property value="getid"/>
							</s:param>
							
							<s:param name="currentPage">
								<s:property value="currentPage"/>
							</s:param>
						</s:url> -->
				
	<!-- 글내용없으면 -->
		<s:if test="list.size() <= 0">
			<tr bgcolor="#FFFFFF" align="center">
				<td colspan="3">평가기록이 없습니다.</td>
			</tr>
			<tr bgcolor="#777777">
				<td height="1" colspan="3"></td>
			</tr>
		</s:if>
		
		
	<!-- 리스트 출력 -->
	
		<s:iterator value="list" status="stat">
							<s:param name="getid">
								<s:property value="getid"/>
							</s:param>
							
							<s:param name="currentPage">
								<s:property value="currentPage"/>
							</s:param>
	
						
						
						<tr align="center">
							<td width="10px" align="center"><input type="checkbox" name="" /></td>
							<td width="100px" align="center"><s:hidden value="sendid" /></td>
							<td width="350px" align="left"><s:a href="%{viewURL}"><s:property value="teamexp" /></s:a></td>
							<td align="center"><s:property value="ratingregdate" /></td>
							<td width="250px" align="center">
		
<div class="stars_label">
	<input type="checkbox" id="star_img1" name="rating" value="1" onchange="view_review_star(1,0.5)" /><label for="star_img1" class="star_l"></label>
	<input type="checkbox" id="star_img2" name="rating" value="2" onchange="view_review_star(2,1)" /><label for="star_img2" class="star_r"></label>
	<input type="checkbox" id="star_img3" name="rating" value="3" onchange="view_review_star(3,1.5)" /><label for="star_img3" class="star_l"></label>
	<input type="checkbox" id="star_img4" name="rating" value="4" onchange="view_review_star(4,2)" /><label for="star_img4" class="star_r"></label>
	<input type="checkbox" id="star_img5" name="rating" value="5" onchange="view_review_star(5,2.5)" /><label for="star_img5" class="star_l"></label>
	<input type="checkbox" id="star_img6" name="rating" value="6" onchange="view_review_star(6,3)" /><label for="star_img6" class="star_r"></label>
	<input type="checkbox" id="star_img7" name="rating" value="7" onchange="view_review_star(7,3.5)" /><label for="star_img7" class="star_l"></label>
	<input type="checkbox" id="star_img8" name="rating" value="8" onchange="view_review_star(8,4)" /><label for="star_img8" class="star_r"></label>
	<input type="checkbox" id="star_img9" name="rating" value="9" onchange="view_review_star(9,4.5)" /><label for="star_img9" class="star_l"></label>
	<input type="checkbox" id="star_img10" name="rating" value="10" onchange="view_review_star(10,5)" /><label for="star_img10" class="star_r"></label>
	<input type="text" name="stars" id="stars" value="-1" />
</div>

							</td>
						</tr>
	</s:iterator>
				</table>
				</td>
				</tr>
					
				<tr>	
					<td colspan="5" align="center">
						<s:property value="pagingHtml" escape="false"/>
					</td>
				</tr>
					
				<tr>
					<td align="right">
						<input type="submit" value="삭제"/>
						<input type="button" value="닫기" onclick="javascript:history.onclick=closeWin();"/>
					</td>
				</tr>
			</table>
		</form>
	</td>
	</tr>
	</table>

	<!-- 
	프로젝트 목록 시스템 -->
		
</body>
</html> --%>