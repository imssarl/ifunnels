// NOT USED 20.11.2014 TELL ADMIS

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>{$arrData.title}</title>
	<meta name="description" content="{$arrData.description}" />
	<meta name="keywords" content="{$arrData.keywords}" />
	{literal}
	<style type="text/css">
		@import "//fonts.googleapis.com/css?family=Lato:900";
		@import "//fonts.googleapis.com/css?family=Rock+Salt";
		@import "//fonts.googleapis.com/css?family=Rambla:400,700|Source+Sans+Pro:400,700|Droid+Sans:400,700|Permanent+Marker|Signika+Negative:400,700|Lato:400,900|Magra:400,700|Exo:400,800|Cinzel:400,700|Titillium+Web:400,700|Oxygen:400,700";
		@import "//fonts.googleapis.com/css?family=Yellowtail|Permanent+Marker|Give+You+Glory|La+Belle+Aurore|Marck+Script|Gochi+Hand|Walter+Turncoat|Kaushan+Script|Loved+by+the+King|Over+the+Rainbow|Architects+Daughter";
		html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, big, cite, code, del, dfn, em, font, img, ins, kbd, q, s, samp, small, strike, strong, sub, sup, tt, var, b, u, i, center, dl, dt, dd, ol, ul, li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td {
		    border: 0;
		    outline: 0;
		    font-size: 100%;
		    vertical-align: baseline;
		    background: transparent;
		    padding: 0;
		    margin: 0;
		}
		html,body{
			height: 100%;
		}
		ol, ul {
		    list-style: none;
		}
		blockquote, q {
		    quotes: none;
		}
		blockquote:before, blockquote:after, q:before, q:after {
		    content: '';
		    content: none;
		}
		:focus {
		    outline: 0;
		}
		ins {
		    text-decoration: none;
		}
		del {
		    text-decoration: line-through;
		}
		table {
		    border-collapse: collapse;
		    border-spacing: 0;
		}
		.skiplink {
		    display: none;
		    position: absolute;
		    left: -9999px;
		}
		a, a:visited {
		    color: #00f;
		    text-decoration: none;
		}
		body {
		    font-size: 13px;
			background: {/literal}{$arrData.body_color}{literal};
			color: #333;
		    position: relative;
		}
		.body-bg, .body-bg img {
		    width: 100%;
		    height: 100%;
			{/literal}{if $arrData.type_background=='color'}{literal}
		    background: {/literal}{$arrData.background_color}{literal};
			{/literal}{/if}{literal}
			opacity: {/literal}{$arrData.background_transparency_tmp}{literal};
		    display: block;
		    position: fixed;
		    top: 0;
		    z-index: 1;
		}
		.body-bg img{
			{/literal}{if $arrData.image_blur=='1'}{literal}
			filter: blur(3px); 
			-webkit-filter: blur(3px); 
			-moz-filter: blur(3px);
			-o-filter: blur(3px); 
			-ms-filter: blur(3px);
			filter: url({/literal}{Zend_Registry::get('config')->path->html->user_files}{literal}squeeze/example/blur.svg#blur);
			filter:progid:DXImageTransform.Microsoft.Blur(PixelRadius='3');
			{/literal}{/if}{literal}
		}
		/*====================wrapper==========================*/
		#wrapper {
		    width: {/literal}{$arrData.box_width}{literal}px;
		    position: absolute;
		    z-index: 100;
		    /*padding-top: 150px;*/
			{/literal}{if $arrData.box_position_right>99.5}{literal}
			right: 6px;
			{/literal}{else}{literal}
			left:{/literal}{$arrData.box_position_left}{literal}%;
			{/literal}{/if}{literal}
			{/literal}{if $arrData.box_position_bottom>99.5}{literal}
			bottom: 0;
			{/literal}{else}{literal}
			top:{/literal}{$arrData.box_position_top}{literal}%;
			{/literal}{/if}{literal}
			{/literal}{if $arrData.delay>0}{literal}
			display: none;
			{/literal}{/if}{literal}
		}
		{/literal}{if $arrData.box_bottom_shadow=='1'}{literal}
		#wrapper:after {
			content: " ";
			border-bottom: 35px solid rgba( 0,0,0,0.1 );
			border-left: 80px solid transparent;
			border-right: 80px solid transparent;
			height: 0;
			width: {/literal}{$arrData.box_width-160+2*$arrData.box_border_width}{literal}px;
			opacity: 1;
			margin: 10px 0px 10px 0px;
			display: block;
		}
		{/literal}{/if}{literal}
		/*=========================header=====================*/
		.cont-box {
		    background: rgba({/literal}{hex2rgb hex=$arrData.box_background}, {$arrData.box_transparency_tmp}{literal});
		    border-style: {/literal}{$arrData.box_border_style}{literal};
		    border-width: {/literal}{$arrData.box_border_width}{literal}px;
		    border-color: {/literal}{$arrData.box_border_color}{literal};
		    border-radius: {/literal}{$arrData.box_border_radius}{literal}px;
		    z-index: 1;
		    width: 100%;
		    padding: 20px;
			text-align: left;
		}
		.cont-top {
		    width: 600px;
		}
		.search-panel {
		    overflow: hidden;
		    padding: 0 0 0 37px;
		    width: auto;
			overflow: visible;
			margin: 0 37px 0 0;
		}
		.search-panel form {
			text-align: center;
		}
		.search-panel input {
		    float: none;
		    margin-bottom: 9px;
		}
		.search-panel .get-button {
		    background: url({/literal}{assign var=button value=$arrData['button']}{assign var=src value="$buttonDir$button"}{img src=$src w=$button_settings[0]}{literal}) no-repeat;
		    width: {/literal}{$button_settings[0]}{literal}px;
		    height: {/literal}{$button_settings[1]}{literal}px;
		    cursor: pointer;
		    text-indent: -9999px;
		    border: none;
			{/literal}{if $arrData.flg_fields_style==1}{literal}
			margin-left: auto;
			margin-right: auto;
			display: block;
			{/literal}{else}{literal}
			margin-left: {/literal}{$arrData.box_width*2.2/100}{literal}px;
			display:inline-block;
			{/literal}{/if}{literal}
		}
		input[type="text"],input[type="password"] {
			font-size: 25px;
			height: 29px;
			line-height: 29px;
			padding: 4px 10px;
			{/literal}{if $arrData.flg_fields_style==1}{literal}
			margin-left: auto;
			margin-right: auto;
			display:block;
			{/literal}{else}{literal}
			margin-left: {/literal}{$arrData.box_width*2.2/100}{literal}px;
			display:inline-block;
			{/literal}{/if}{literal}
			
			width: auto;//{/literal}{$arrData.box_width*52/100}{literal}px;
		}
		textarea{
			width: 307px;
			height: 100px;
			font-size: 29px;
			line-height: 29px;
			padding-top: 10px;
			padding-bottom: 9px;
			padding-left: 10px;
			padding-right: 10px;
			display: block;
		}
		form label {
			font-family: Verdana, Geneva, sans-serif;
			font-size: 18px;
			display: block;
		}
		.cont-box p {
		    padding-left: 37px;
		    color: #333;
		    line-height: 18px;
		}
		.cont-box p em {
		    display: block;
		}
		.download{
			position: absolute;
			left: 20px;
			top:10px;
			z-index: 1000;
			cursor: pointer;
		}
		.back{
			position: absolute;
			left: 10px;
			top:10px;
			z-index: 1000;
			cursor: pointer;
		}
		.clear{
			clear:both;
			font-size: 1px;;
		}
		.tubular-pause{
			position: absolute;
			right: 20px;
			top: 20px;
			z-index: 1000;
			background: url("/usersdata/squeeze/example/js/video/bigvideo.png");
			width: 10px;
			height: 16px;
			cursor: pointer;
		}
		.tubular-play{
			position: absolute;
			right: 20px;
			top: 20px;
			z-index: 1000;
			background: url("/usersdata/squeeze/example/js/video/bigvideo.png") -16px 0px;
			width: 10px;
			height: 16px;
			cursor: pointer;
		}
		#video-bg{
			height:100%;
		}
		.kic {
			-moz-animation-delay: 0.2s;
			-moz-animation-duration: 1s;
			-moz-animation-fill-mode: both;
			-moz-animation-timing-function: ease;
			-moz-backface-visibility: hidden;
			-webkit-animation-fill-mode: both;
			-moz-animation-fill-mode: both;
			-ms-animation-fill-mode: both;
			-o-animation-fill-mode: both;
			animation-fill-mode: both;
			-webkit-animation-duration: 1s;
			-moz-animation-duration: 1s;
			-ms-animation-duration: 1s;
			-o-animation-duration: 1s;
			animation-duration: 1s;
			display: inline-block;
		}
		@-webkit-keyframes flash {
			0%, 50%, 100% {opacity: 1;}
			25%, 75% {opacity: 0;}
		}
		@-moz-keyframes flash {
			0%, 50%, 100% {opacity: 1;}
			25%, 75% {opacity: 0;}
		}
		@-o-keyframes flash {
			0%, 50%, 100% {opacity: 1;}
			25%, 75% {opacity: 0;}
		}
		@keyframes flash {
			0%, 50%, 100% {opacity: 1;}
			25%, 75% {opacity: 0;}
		}
		.flash {
			-webkit-animation-name: flash;
			-moz-animation-name: flash;
			-o-animation-name: flash;
			animation-name: flash;
		}
		@-webkit-keyframes shake {
			0%, 100% {-webkit-transform: translateX(0);}
			10%, 30%, 50%, 70%, 90% {-webkit-transform: translateX(-10px);}
			20%, 40%, 60%, 80% {-webkit-transform: translateX(10px);}
		}
		@-moz-keyframes shake {
			0%, 100% {-moz-transform: translateX(0);}
			10%, 30%, 50%, 70%, 90% {-moz-transform: translateX(-10px);}
			20%, 40%, 60%, 80% {-moz-transform: translateX(10px);}
		}
		@-o-keyframes shake {
			0%, 100% {-o-transform: translateX(0);}
			10%, 30%, 50%, 70%, 90% {-o-transform: translateX(-10px);}
			20%, 40%, 60%, 80% {-o-transform: translateX(10px);}
		}
		@keyframes shake {
			0%, 100% {transform: translateX(0);}
			10%, 30%, 50%, 70%, 90% {transform: translateX(-10px);}
			20%, 40%, 60%, 80% {transform: translateX(10px);}
		}
		.shake {
			-webkit-animation-name: shake;
			-moz-animation-name: shake;
			-o-animation-name: shake;
			animation-name: shake;
		}
		@-webkit-keyframes bounce {
			0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
			40% {-webkit-transform: translateY(-30px);}
			60% {-webkit-transform: translateY(-15px);}
		}
		@-moz-keyframes bounce {
			0%, 20%, 50%, 80%, 100% {-moz-transform: translateY(0);}
			40% {-moz-transform: translateY(-30px);}
			60% {-moz-transform: translateY(-15px);}
		}
		@-o-keyframes bounce {
			0%, 20%, 50%, 80%, 100% {-o-transform: translateY(0);}
			40% {-o-transform: translateY(-30px);}
			60% {-o-transform: translateY(-15px);}
		}
		@keyframes bounce {
			0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
			40% {transform: translateY(-30px);}
			60% {transform: translateY(-15px);}
		}
		.bounce {
			-webkit-animation-name: bounce;
			-moz-animation-name: bounce;
			-o-animation-name: bounce;
			animation-name: bounce;
		}
		@-webkit-keyframes tada {
			0% {-webkit-transform: scale(1);}
			10%, 20% {-webkit-transform: scale(0.9) rotate(-3deg);}
			30%, 50%, 70%, 90% {-webkit-transform: scale(1.5) rotate(3deg);}
			40%, 60%, 80% {-webkit-transform: scale(1.5) rotate(-3deg);}
			100% {-webkit-transform: scale(1) rotate(0);}
		}
		@-moz-keyframes tada {
			0% {-moz-transform: scale(1);}
			10%, 20% {-moz-transform: scale(0.9) rotate(-3deg);}
			30%, 50%, 70%, 90% {-moz-transform: scale(1.5) rotate(3deg);}
			40%, 60%, 80% {-moz-transform: scale(1.5) rotate(-3deg);}
			100% {-moz-transform: scale(1) rotate(0);}
		}
		@-o-keyframes tada {
			0% {-o-transform: scale(1);}
			10%, 20% {-o-transform: scale(0.9) rotate(-3deg);}
			30%, 50%, 70%, 90% {-o-transform: scale(1.5) rotate(3deg);}
			40%, 60%, 80% {-o-transform: scale(1.5) rotate(-3deg);}
			100% {-o-transform: scale(1) rotate(0);}
		}
		@keyframes tada {
			0% {transform: scale(1);}
			10%, 20% {transform: scale(0.9) rotate(-3deg);}
			30%, 50%, 70%, 90% {transform: scale(1.5) rotate(3deg);}
			40%, 60%, 80% {transform: scale(1.5) rotate(-3deg);}
			100% {transform: scale(1) rotate(0);}
		}
		.tada {
			-webkit-animation-name: tada;
			-moz-animation-name: tada;
			-o-animation-name: tada;
			animation-name: tada;
		}
		@-webkit-keyframes swing {
			20%, 40%, 60%, 80%, 100% { -webkit-transform-origin: top center; }
			20% { -webkit-transform: rotate(15deg); }
			40% { -webkit-transform: rotate(-10deg); }
			60% { -webkit-transform: rotate(5deg); }
			80% { -webkit-transform: rotate(-5deg); }
			100% { -webkit-transform: rotate(0deg); }
		}
		@-moz-keyframes swing {
			20% { -moz-transform: rotate(15deg); }
			40% { -moz-transform: rotate(-10deg); }
			60% { -moz-transform: rotate(5deg); }
			80% { -moz-transform: rotate(-5deg); }
			100% { -moz-transform: rotate(0deg); }
		}
		@-o-keyframes swing {
			20% { -o-transform: rotate(15deg); }
			40% { -o-transform: rotate(-10deg); }
			60% { -o-transform: rotate(5deg); }
			80% { -o-transform: rotate(-5deg); }
			100% { -o-transform: rotate(0deg); }
		}
		@keyframes swing {
			20% { transform: rotate(15deg); }
			40% { transform: rotate(-10deg); }
			60% { transform: rotate(5deg); }
			80% { transform: rotate(-5deg); }
			100% { transform: rotate(0deg); }
		}
		.swing {
			-webkit-transform-origin: top center;
			-moz-transform-origin: top center;
			-o-transform-origin: top center;
			transform-origin: top center;
			-webkit-animation-name: swing;
			-moz-animation-name: swing;
			-o-animation-name: swing;
			animation-name: swing;
		}
		/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */
		@-webkit-keyframes wobble {
		  0% { -webkit-transform: translateX(0%); }
		  15% { -webkit-transform: translateX(-25%) rotate(-5deg); }
		  30% { -webkit-transform: translateX(20%) rotate(3deg); }
		  45% { -webkit-transform: translateX(-15%) rotate(-3deg); }
		  60% { -webkit-transform: translateX(10%) rotate(2deg); }
		  75% { -webkit-transform: translateX(-5%) rotate(-1deg); }
		  100% { -webkit-transform: translateX(0%); }
		}
		@-moz-keyframes wobble {
		  0% { -moz-transform: translateX(0%); }
		  15% { -moz-transform: translateX(-25%) rotate(-5deg); }
		  30% { -moz-transform: translateX(20%) rotate(3deg); }
		  45% { -moz-transform: translateX(-15%) rotate(-3deg); }
		  60% { -moz-transform: translateX(10%) rotate(2deg); }
		  75% { -moz-transform: translateX(-5%) rotate(-1deg); }
		  100% { -moz-transform: translateX(0%); }
		}
		@-o-keyframes wobble {
		  0% { -o-transform: translateX(0%); }
		  15% { -o-transform: translateX(-25%) rotate(-5deg); }
		  30% { -o-transform: translateX(20%) rotate(3deg); }
		  45% { -o-transform: translateX(-15%) rotate(-3deg); }
		  60% { -o-transform: translateX(10%) rotate(2deg); }
		  75% { -o-transform: translateX(-5%) rotate(-1deg); }
		  100% { -o-transform: translateX(0%); }
		}
		@keyframes wobble {
		  0% { transform: translateX(0%); }
		  15% { transform: translateX(-25%) rotate(-5deg); }
		  30% { transform: translateX(20%) rotate(3deg); }
		  45% { transform: translateX(-15%) rotate(-3deg); }
		  60% { transform: translateX(10%) rotate(2deg); }
		  75% { transform: translateX(-5%) rotate(-1deg); }
		  100% { transform: translateX(0%); }
		}
		.wobble {
			-webkit-animation-name: wobble;
			-moz-animation-name: wobble;
			-o-animation-name: wobble;
			animation-name: wobble;
		}
		@-webkit-keyframes wiggle {
			0% { -webkit-transform: skewX(9deg); }
			10% { -webkit-transform: skewX(-8deg); }
			20% { -webkit-transform: skewX(7deg); }
			30% { -webkit-transform: skewX(-6deg); }
			40% { -webkit-transform: skewX(5deg); }
			50% { -webkit-transform: skewX(-4deg); }
			60% { -webkit-transform: skewX(3deg); }
			70% { -webkit-transform: skewX(-2deg); }
			80% { -webkit-transform: skewX(1deg); }
			90% { -webkit-transform: skewX(0deg); }
			100% { -webkit-transform: skewX(0deg); }
		}
		@-moz-keyframes wiggle {
			0% { -moz-transform: skewX(9deg); }
			10% { -moz-transform: skewX(-8deg); }
			20% { -moz-transform: skewX(7deg); }
			30% { -moz-transform: skewX(-6deg); }
			40% { -moz-transform: skewX(5deg); }
			50% { -moz-transform: skewX(-4deg); }
			60% { -moz-transform: skewX(3deg); }
			70% { -moz-transform: skewX(-2deg); }
			80% { -moz-transform: skewX(1deg); }
			90% { -moz-transform: skewX(0deg); }
			100% { -moz-transform: skewX(0deg); }
		}
		@-o-keyframes wiggle {
			0% { -o-transform: skewX(9deg); }
			10% { -o-transform: skewX(-8deg); }
			20% { -o-transform: skewX(7deg); }
			30% { -o-transform: skewX(-6deg); }
			40% { -o-transform: skewX(5deg); }
			50% { -o-transform: skewX(-4deg); }
			60% { -o-transform: skewX(3deg); }
			70% { -o-transform: skewX(-2deg); }
			80% { -o-transform: skewX(1deg); }
			90% { -o-transform: skewX(0deg); }
			100% { -o-transform: skewX(0deg); }
		}
		@keyframes wiggle {
			0% { transform: skewX(9deg); }
			10% { transform: skewX(-8deg); }
			20% { transform: skewX(7deg); }
			30% { transform: skewX(-6deg); }
			40% { transform: skewX(5deg); }
			50% { transform: skewX(-4deg); }
			60% { transform: skewX(3deg); }
			70% { transform: skewX(-2deg); }
			80% { transform: skewX(1deg); }
			90% { transform: skewX(0deg); }
			100% { transform: skewX(0deg); }
		}
		.wiggle {
			-webkit-animation-name: wiggle;
			-moz-animation-name: wiggle;
			-o-animation-name: wiggle;
			animation-name: wiggle;

			-webkit-animation-timing-function: ease-in;
			-moz-animation-timing-function: ease-in;
			-o-animation-timing-function: ease-in;
			animation-timing-function: ease-in;
		}
		/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */
		@-webkit-keyframes pulse {
			0% { -webkit-transform: scale(1); }
			50% { -webkit-transform: scale(1.1); }
			100% { -webkit-transform: scale(1); }
		}
		@-moz-keyframes pulse {
			0% { -moz-transform: scale(1); }
			50% { -moz-transform: scale(1.1); }
			100% { -moz-transform: scale(1); }
		}
		@-o-keyframes pulse {
			0% { -o-transform: scale(1); }
			50% { -o-transform: scale(1.1); }
			100% { -o-transform: scale(1); }
		}
		@keyframes pulse {
			0% { transform: scale(1); }
			50% { transform: scale(1.1); }
			100% { transform: scale(1); }
		}
		.pulse {
			-webkit-animation-name: pulse;
			-moz-animation-name: pulse;
			-o-animation-name: pulse;
			animation-name: pulse;
		}
		@-webkit-keyframes fadein {
			0% {opacity: 0;}
			100% {opacity: 1;}
		}
		@-moz-keyframes fadein {
			from {
				opacity:0;
			}
			to {
				opacity:1;
			}
		}
		@-o-keyframes fadein {
			0% {opacity: 0;}
			100% {opacity: 1;}
		}
		@keyframes fadein {
			0% {filter: alpha(opacity=0);}
			100% {filter: alpha(opacity=100);}
		}
		.fadein {
			animation: fadein 1.2s;
			-moz-animation: fadein 1.2s;
			-webkit-animation: fadein 1.2s;
			-o-animation: fadein 1.2s;
		}
		@media screen and (max-width: {/literal}{$arrData.box_width}{literal}px) {
			#wrapper {
				width: 94%;
				position: absolute;
				right: auto;
				bottom: auto;
				top:0px;
				left:0px;
			}
			.cont-box {
				padding: 3%;
				border-width: 0px;
				border-radius: 0px;
			}
			#wrapper.kic{
				animation: none;
				-moz-animation: none;
				-webkit-animation: none;
				-o-animation: none;
			}
		}
	</style>
	{/literal}
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js" type="text/javascript"></script>
	<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.22/jquery-ui.min.js"></script>
	<script src="/usersdata/squeeze/example/js/video/bigvideo.js"></script>
	<script src="/usersdata/squeeze/example/js/video/modernizr-2.5.3.min.js"></script>
	<link rel="stylesheet" href="/usersdata/squeeze/example/js/video/bigvideo.css" type="text/css" media="screen" />
	<script src="/usersdata/squeeze/example/js/video/jquery.imagesloaded.min.js"></script>
	<script src="/usersdata/squeeze/example/js/video/jquery.tubular.1.0.js"></script>
	<script src="//vjs.zencdn.net/4.0/video.js"></script>
	{if $arrData.type_page_through==1}
	<link rel="stylesheet" href="/usersdata/squeeze/example/js/fancybox/fancybox.css" type="text/css" media="screen" />
	<script type="text/javascript" src="/usersdata/squeeze/example/js/fancybox/fancybox.js"></script>
	{/if}
	{if $arrData.flg_misc=='1'}{literal}<script type="text/javascript">
	var PreventExitPopup = false;
	var activateMainShow=function(){
		var ExitPopupmessage="{/literal}{$arrData.exit_pop_message}{literal}";
		var ExitPopuppage = "{/literal}{$arrData.exit_pop_url}{literal}";
		function addLoadEvent(func) {
			var oldonload = window.onload;
			if (typeof window.onload != 'function') { window.onload = func; } else { window.onload = function() { if (oldonload) { oldonload(); } func(); }}
		}
		function addClickEvent(a,i,func) {
			if (typeof a[i].onclick != 'function') { a[i].onclick = func; }
		}
		var theDiv = '<div id="ExitPopupDiv" style="display:block; width:100%; height:100%; position:absolute; background:#FFFFFF; margin-top:0px; margin-left:0px;" align="center">';
		theDiv = theDiv + '<iframe src="'+ExitPopuppage+'" width="100%" height="100%" align="middle" frameborder="0"></iframe>';
		theDiv = theDiv + '</div>';
		theBody = document.body;
		if (!theBody) {theBody = document.getElementById("body");
		if (!theBody) {theBody = document.getElementsByTagName("body")[0];}}
		function DisplayExitPopup(){
			if(PreventExitPopup == false){
				window.scrollTo(0,0);
				window.alert(ExitPopupmessage);
				PreventExitPopup=true;
				divtag = document.createElement("div");
				divtag.setAttribute("id","ExitPopupMainOuterLayer" );
				divtag.style.position="absolute";
				divtag.style.width="100%";
				divtag.style.height="100%";
				divtag.style.zIndex="99";
				divtag.style.left="0px";
				divtag.style.top="0px";
				divtag.innerHTML=theDiv;
				theBody.innerHTML="";
				theBody.topMargin="0px";
				theBody.rightMargin="0px";
				theBody.bottomMargin="0px";
				theBody.leftMargin="0px";
				theBody.style.overflow="hidden";
				theBody.appendChild(divtag);
				return ExitPopupmessage;
			}
		}
		var a = document.getElementsByTagName('a');
		for (var i = 0; i < a.length; i++) {
			addClickEvent(a,i, function(){ PreventExitPopup=(a[i].target === '_blank'); });
		}
		disablelinksfunc = function(){
			var a = document.getElementsByTagName('a');
			for (var i = 0; i < a.length; i++) {
				addClickEvent(a,i, function(){ PreventExitPopup=(a[i].target === '_blank'); });
			}
		}
		hideexitcancelbuttonimage = function(){
			document.getElementById('ExitCancelButtonImageDiv' ).style.display='none';
		}
		addLoadEvent(disablelinksfunc);
		window.onbeforeunload=DisplayExitPopup;
	}
	jQuery( document ).ready(function(){
		activateMainShow();
	});
	</script>{/literal}{/if}
	{$arrData.tracking_code}
</head>
<body>
<div id="video-bg">
{if $arrData.flg_sound=='1' }{foreach  from=$arrData.file_sound_path item=_file key=_key}
<audio src="{$_file}" autoplay {if $arrData.flg_sound_loop.{$_key}==1}loop{/if}></audio>
{/foreach}{/if}
<main>
	{if $arrData.type_background=='upload'}
	<div class="body-bg"><img src="{$arrData.upload}" alt="" /></div>
	{elseif $arrData.type_background=='image'}
	<div class="body-bg"><img src="{if $arrData.background_google==0}/usersdata/squeeze/backgrounds/{/if}{$arrData.background}" alt="" /></div>
	{elseif $arrData.type_background=='color'}
	<div class="body-bg">&nbsp;</div>
	{/if}
	{if isset( $arrData.ep_content ) }{$arrData.ep_content}{/if}
	{if !isset($arrData.popup_style) || $arrData.popup_style=='content' || $arrData.popup_style=='popup' }
	<section id="wrapper" class="kic" rel="{$arrData.box_effect}">
		<section class="cont-box">
			{$arrData.header}
			<center>{$arrData.video_holder}</center>
			<br />
			<div class="search-panel">
			{$arrData.form}
			</div>
			<p>{$arrData.fineprint}</p>
		</section>
		{if !isset( $arrData.flg_ads_widget ) || $arrData.flg_ads_widget == 1}
		<div style="float:right;"><script type="text/javascript" src="{Zend_Registry::get( 'config' )->domain->url}/services/widgets.php?name=Copt&action=get&id=VFZSQk0wNVJQVDA9K0E="></script></div>
		{/if}
	</section>
	{/if}
</main>
</div>
{if $arrData.youtube_pause}
<div class="tubular-pause" style="display: block;"></div>
<div class="tubular-play" style="display: none;"></div>
{/if}
{if $arrData.type_page_through==1}
<div id="fancybox-form" style="width: auto; display: none;">{$arrData.optin_form}</div>{/if}
{if isset( $arrData.ep_action_content )}{$arrData.ep_action_content}{/if}
{literal}
	<script type="text/javascript">
		var urlDownload='{/literal}{url name='site1_squeeze' action='example'}{literal}';
		var urlBack='{/literal}{url name='site1_squeeze' action='customization'}{literal}';
		$(document).ready(function(){
			$('#download').click(function(){
				PreventExitPopup=true
				$('#post-form').attr('action',urlDownload);
				$('#post-form').submit();
			});
			setTimeout(function() {
				$('.kic').each(function() {
					$('#wrapper').show();
					var relAttr=$(this).attr('rel');
					$(this).addClass( relAttr );
					window.setTimeout(function(){
						$('.kic').removeClass( relAttr );
						$('.kic').removeClass( 'kic' );
					},1200);
				});
			}, {/literal}{if !empty($arrData.delay)}{$arrData.delay}{else}0{/if}{literal} ) ;
			{/literal}{if $arrData.type_page_through==1}{literal}
			$(".fancybox").fancybox({
				helpers : {
					overlay : {
						css : {
							'background' : 'rgba(58, 42, 45, 0.35)'
						}
					}
				}
			});
			{/literal}{/if}{literal}
		});
		{/literal}{if $arrData.type_background=='mp4'}{literal}
		$(function() {
		    var BV = new $.BigVideo({defaultVolume:{/literal}{$arrData.mp4_sound|default:0}{literal},doLoop:{/literal}{$arrData.mp4_loop|default:0}{literal},controls:{/literal}{$arrData.mp4_pause|default:0}{literal},forceAutoplay:true});
		    BV.init();
			if (Modernizr.touch) {
				BV.show({/literal}'{$arrData.mp4}'{literal});
			}else{
				BV.show({/literal}'{$arrData.mp4}'{literal},{ambient:true});
			}
		});
		{/literal}{/if}{literal}
		{/literal}{if $arrData.type_background=='youtube'}{literal}
			$(document).ready(function() {
				if( $('#video-bg').tubular != undefined )
				$('#video-bg').tubular({mute:{/literal}{if empty($arrData.youtube_sound)}true{else}false{/if}{literal},repeat:{/literal}{$arrData.youtube_loop|default:0}{literal},videoId: {/literal}'{$arrData.youtubeId}'{literal}});
				{/literal}{if $arrData.youtube_pause}{literal}
				$('.tubular-pause').click(function(){
					if($(this).css('display')=='block'){
						$(this).css('display','none');
						$('.tubular-play').css('display','block');
					} else {
						$(this).css('display','block');
					}
				});
				$('.tubular-play').click(function(){
					if($(this).css('display')=='block'){
						$(this).css('display','none');
						$('.tubular-pause').css('display','block');
					} else {
						$(this).css('display','block');
					}
				});
				{/literal}{/if}{literal}
			});
		{/literal}{/if}{literal}
	</script>
{/literal}
{$arrData.tracking_code_body}
</body>
</html>
