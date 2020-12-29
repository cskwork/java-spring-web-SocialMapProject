/*$(document).ready(function(){		
	$(".box2 .top").on("click", function(){
		$( 'html, body' ).animate( { scrollTop : 0 }, 300 );
		return 0;
	});	
	$(".mobile .mobilemenu img").on("click", function(){
		$(".mobile .gnb_wbg").show();
		$(".mobile .gnb_wbg").animate({
			right : 0
		}, 300);
		$(".slide").animate({
			left : "-35%"
		}, 300);
		$(".gnb_wbg >ul>li a").show();
		$(".mobile .gnb_bbg").show();
		$(".mobile .close").show();
	});	
	
	$(".mobile .close").on("click", function(){
		$(".mobile .gnb_wbg").hide();
		$(".mobile .gnb_wbg").animate({
			right : 0
		}, 300);
		$(".slide").animate({
			left : 0
		}, 300);
		$(".gnb_wbg >ul>li a").hide();
		$(".mobile .gnb_bbg").hide();
	});
	

	$(".mobile .gnb_wbg>ul>li").on("click", function(){
		if($(this).hasClass("on")){//이미 열린 메뉴
			$(this).removeClass("on");
		}else{
			$(".mobile .gnb_wbg>ul>li").removeClass("on");
			$(this).addClass("on");
		}
	});
});*/

function toggles(var1) {
	if(document.getElementById(var1).style.display == "none")
		document.getElementById(var1).style.display = "";
	else 
		document.getElementById(var1).style.display = "none";
}

$(document).ready(function(){
	
	//로딩된 후 한번 실행하는 구간
	var scroll_top = $(window).scrollTop();
	var window_w = $(window).width();
	scroll_check();
	
	//윈도우가 스크롤 될때마다 실행되는 구간
	$(window).scroll(function(){
		scroll_top = $(window).scrollTop();
		scroll_check();
		//console.log(scroll_top);
	});
	
	$(window).resize(function(){
		window_w = $(window).width();
	});
	
	function scroll_check(){
		if(window_w>1000){
			if(scroll_top>0){
				$(".header").addClass("scroll");
			}else{
				$(".header").removeClass("scroll");
			}
		}		
	}
	$(".mobile_gnb .mobilemenu img").on("click", function(){
		$(".mobile_gnb .gnb_rbg").show();
		$(".gnb_rbg >ul>li a").show();
		$(".header .gnb_bbg").show();
		$(".mobile_gnb .close").show();
	});
	$(".mobile_gnb .close").on("click", function(){
		$(".mobile_gnb .gnb_rbg").hide();
		$(".gnb_rbg >ul>li a").hide();
		$(".header .gnb_bbg").hide();
		$(".mobile_gnb .close").hide();
	});
	
});