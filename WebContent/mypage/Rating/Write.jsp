<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import = "java.util.HashMap" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<style type="text/css">
	.value {
	 display:none;
	}
   .stars_label input {
      display:none;
   }
   
   .star_l {
      float:left;
      margin:0px;
      background:url(/SocialMap/mypage/images/star_02_01.jpg) no-repeat left top;
      display:block;
      border:0px;
      width:12px;
      height:23px;
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
      height:23px
   }
   .star_r:hover {
      background:url(/SocialMap/mypage/images/star_02_02.jpg) no-repeat left top;
   }
   .stars_label input[type=checkbox]:checked + .star_r {
      background:url(/SocialMap/mypage/images/star_01_02.jpg) no-repeat left top;
   }
   
   
   .stars_label_tmp_l {
      background:url(/SocialMap/mypage/images/star_02_01.jpg) no-repeat left top;
      float:left;
      margin:0px;
      display:block;
      border:0px;
      width:12px;
      height:23px
   }
   .stars_label_tmp_l_hover {
      background:url(/SocialMap/mypage/images/star_01_01.jpg) no-repeat left top;
      float:left;
      margin:0px;
      display:block;
      border:0px;
      width:12px;
      height:23px
   }
   
   
   .stars_label_tmp_r {
      background:url(/SocialMap/mypage/images/star_02_02.jpg) no-repeat left top;
      float:left;
      margin:0px;
      display:block;
      border:0px;
      width:12px;
      height:23px
   }
   .stars_label_tmp_r_hover {
      background:url(/SocialMap/mypage/images/star_01_02.jpg) no-repeat left top;
      float:left;
      margin:0px;
      display:block;
      border:0px;
      width:12px;
      height:23px
   }
</style>

<script type="text/javascript">
   //리뷰별컨트롤  var1 : 별 개수, var2 : 점수
   function view_review_star(var1, var2, var3) {
      var i;
      //모든별 흑백
      for(i=1;i<=10;i++) {
         document.getElementById("star_img"+var3+i).checked = false;
         if(i%2 == 1) {
            document.getElementById("star_img"+var3+i+"_tmp").setAttribute("class","stars_label_tmp_l");
         }else
            document.getElementById("star_img"+var3+i+"_tmp").setAttribute("class","stars_label_tmp_r");
      }
      //선택별까지 컬러
      for(i=1;i<=var1;i++) {
         document.getElementById("star_img"+var3+i).checked = true;
         if(i%2 == 1) {
            document.getElementById("star_img"+var3+i+"_tmp").setAttribute("class","stars_label_tmp_l_hover");
         } else
            document.getElementById("star_img"+var3+i+"_tmp").setAttribute("class","stars_label_tmp_r_hover");
      }
      
      if(var3 === 0) {
         document.getElementById("0").value = var2;
      } else if(var3 === 1) {
         document.getElementById("1").value = var2;
      }
   }
	function validation() {
		for(var i = 0;i < 5;i++) {
	         if(document.getElementById("title" + i).value == "") {
				alert("제목을 입력해주세요");
				return false;
	         }
	         else if(document.getElementById("getid" + i).value == "") {
				alert("받는 사람을 입력해주세요");
				return false;
	         }
	         else if(document.getElementById("reputation" + i).value == "") {
	            alert("한 줄 평을 입력해주세요");
           		return false;
			}
		}
		return true;
	}
</script>
   
	<script>
	    function checkProj() {
	        if (checkproj==null) {
	            window.alert("평가할 프로젝트가 없습니다! 프로젝트 목로으로 이동합니다.");
	
	            location.href= "http://localhost:8080/SocialMap/ProjList.action";
	
	        }
	    }
	</script>

<title>쪽지 쓰기</title>
</head>
<body>

   <table style="width: 670px; height: 600px; border-spacing: 0; padding: 0; margin: auto;" border="1">
   <tr valign="middle" height="10%">
   <td>
      <form action="RatingList.action" name="form" method="post" enctype="multipart/form-data" on>
         <table style="margin: auto; width: 100%;" border="0">
            <tr>
               <td align="left">
                  <a href="RatingWrite.action">평점쓰기</a>
                  <a href="RatingList.action">평점보기  </a>
                  <a href="javascript:document.log.submit();">보낸평점  </a>
               </td>
            </tr>
         </table>
      </form>
   </td>
   </tr>

   <tr valign="top" align="center">
   <td>
   <form action="RatingWrite.action" id="frm" onsubmit="return validation();" method="post" encType="multipart/form-data" >
      <s:hidden value="1" name="step" />
   
      <table style="margin: auto; width: 100%;" border="1">
         <s:iterator value="list" status="rate">
            <tr>
               <td align="center">프로젝트명</td>
               <td>
                  <s:textfield theme="simple" id="title%{#rate.index}" name="list[%{#rate.index}].title" value="%{title }" maxlength="50" />
                  <s:hidden theme="simple" name="list[%{#rate.index}].teamexp" value="%{teamexp}" />
               </td>
            </tr>
            <tr>
               <td align="center">받는 사람</td>
               <td>
                  <s:textfield theme="simple" id="getid%{#rate.index}" name="list[%{#rate.index}].getid" value="%{getid}" maxlength="10"/>
                  <s:hidden theme="simple" name="list[%{#rate.index}].sendid" value="%{sendid}" />
               </td>
            </tr>
            
            <tr>
               <td align="center">평점</td>
               <td width="250px" align="left">   
                  <s:div cssClass="stars_label">
                     <s:checkbox name="" id="star_img%{#rate.index}1" theme="simple" onclick="view_review_star(1,1,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}1" cssClass="star_l" id="star_img%{#rate.index}1_tmp"  ></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}2" theme="simple" onclick="view_review_star(2,2,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}2" cssClass="star_r" id="star_img%{#rate.index}2_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}3" theme="simple" onclick="view_review_star(3,3,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}3" cssClass="star_l" id="star_img%{#rate.index}3_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}4" theme="simple" onclick="view_review_star(4,4,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}4" cssClass="star_r" id="star_img%{#rate.index}4_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}5" theme="simple" onclick="view_review_star(5,5,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}5" cssClass="star_l" id="star_img%{#rate.index}5_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}6" theme="simple" onclick="view_review_star(6,6,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}6" cssClass="star_r" id="star_img%{#rate.index}6_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}7" theme="simple" onclick="view_review_star(7,7,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}7" cssClass="star_l" id="star_img%{#rate.index}7_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}8" theme="simple" onclick="view_review_star(8,8,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}8" cssClass="star_r" id="star_img%{#rate.index}8_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}9" theme="simple" onclick="view_review_star(9,9,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}9" cssClass="star_l" id="star_img%{#rate.index}9_tmp"></s:label>
                     
                     <s:checkbox name="" id="star_img%{#rate.index}10" theme="simple" onclick="view_review_star(10,10,%{#rate.index})" />
                     <s:label theme="simple" for="star_img%{#rate.index}10" cssClass="star_r" id="star_img%{#rate.index}10_tmp"></s:label>
                     
					<s:textfield theme="simple" name="list[%{#rate.index}].rate" id="%{#rate.index}" value="0" />
                  </s:div>
               </td>   
            </tr>

            <tr>
               <td align="center">한줄평</td>
               <td>
                  <s:textarea theme="simple" id="reputation%{#rate.index}" name="list[%{#rate.index}].reputation" value="%{reputation}" cols="50" rows="1"></s:textarea>
               </td>
            </tr>
         </s:iterator>

         <tr>
            <td align="right" colspan="2">
               <s:submit theme="simple" value ="입력"/>
               <s:submit theme="simple" name="method:cancel" value="취소"/>
            </td>
         </tr>
      </table>
   </form>
   </td>
   </tr>
   </table>
</body>
</html>