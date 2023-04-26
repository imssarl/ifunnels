<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>{if $arrCurReverse}{foreach from=$arrCurReverse item='node'}{$node.title} / {/foreach}{/if}{Core_Module_Router::$domain}</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type" />
	<meta name="Robots" content="{if !$arrCurReverse[0].meta_robots}NO{/if}INDEX, FOLLOW" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	{if $arrCurReverse[0].meta_keywords}<meta name="keywords" content="{$arrCurReverse[0].meta_keywords}" />{/if}
	{if $arrCurReverse[0].meta_description}<meta name="description" content="{$arrCurReverse[0].meta_description}" />{/if}
	{*CSS*}
	<link rel="stylesheet" href="/skin/_css/new/site1_mini.css" type="text/css" media="screen" />
	{*JS*}
	<script type="text/javascript" src="/skin/_js/mootools-core.js"></script>
	<script type="text/javascript" src="/skin/_js/xlib.js"></script>
	{*cerabox*}

	<link href="/skin/light/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/icons.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/plugins/bootstrap-select/dist/css/bootstrap-select.min.css" rel="stylesheet" />

	<link rel="stylesheet" href="/skin/_js/cerabox/style/cerabox.css" media="screen" />
	<script type="text/javascript" src="/skin/_js/cerabox/cerabox.js"></script>
	<script src="/skin/light/js/jquery.min.js"></script> 
	<script>
		jQuery.noConflict();
        var resizefunc = [];
    </script>

	{*validator*}
	<link rel="stylesheet" type="text/css" href="/skin/_js/validator/style.css" />
	<script type="text/javascript" src="/skin/_js/validator/validator.js"></script>
	{*r.alert*}
	<link rel="stylesheet" type="text/css" href="/skin/_js/roar/roar.css" />
	<script type="text/javascript" src="/skin/_js/roar/roar.js"></script>
	{*additional js*}
	<script type="text/javascript" src="/skin/_js/site1.js"></script>
	<script type="text/javascript" src="/skin/_js/ui.js"></script>
	<script type="text/javascript" src="/skin/_js/categories.js"></script>

	<script type="text/javascript" src="/skin/_js/jsColorpicker/colors.js"></script>
	<script type="text/javascript" src="/skin/_js/jsColorpicker/colorPicker.data.js"></script>
	<script type="text/javascript" src="/skin/_js/jsColorpicker/colorPicker.js"></script>
	<script type="text/javascript" src="/skin/_js/jsColorpicker/jsColor.js"></script>
	
	<script type="text/javascript" src="/skin/_js/ckeditor_cb/ckeditor.js"></script>

	<link rel="stylesheet" href="/skin/_css/contentbox.css" type="text/css" />
	<link rel="stylesheet" href="/skin/_css/bootstrap.vertical-tabs.css" type="text/css" />
	<link rel="stylesheet" href="/skin/_css/jquery.custom-scroll.css">

</head>
<body>
	<div class="topbar">
        <div class="navbar navbar-default" role="navigation">
            <div class="container">
                <div class="topbar-left col-md-7">
	                <div class="col-md-5 col-xs-9">
	                    <a href="/" class="logo">Creative Niche Manager</a>
	                </div>
	                <div class="col-md-1 col-xs-3 hidden">
                        <button class="button-menu-mobile open-left">
                            <i class="ion-navicon"></i>
                        </button>
                        <span class="clearfix"></span>
                    </div>
	            </div>
	            <div class="col-md-5 user-panel">
	            	<style type="text/css">
	            		.dropdown, a[data-toggle="tooltip"] { display: block!important; }
	            	</style>
	            	<ul class="nav navbar-nav navbar-right pull-right">
                        <li class="hidden-xs">
                            <a href="#" id="btn-fullscreen" class="waves-effect waves-light"><i class="icon-size-fullscreen"></i></a>
                        </li>
                        {if Core_Users::$info['statistic']['lpb_campaigns_img'] != 0}
                            <li class="hidden-xs">
                            	<a href="javascript:void(0);" data-toggle="tooltip" data-placement="bottom" title="Number of Your LPS Pages">
                            		<img src="/skin/i/frontends/design/gamification/rocket/{Core_Users::$info['statistic']['lpb_campaigns_img']}.png" width="36px" height="36px" />
                            	</a>
                            </li>
                        {/if}
                        {if Core_Users::$info['statistic']['traffic_campaigns_img'] != 0}
                        	<li class="hidden-xs">
                        		<a href="javascript:void(0);" data-toggle="tooltip" data-placement="bottom" title="Traffic Exchange">
									<img src="/skin/i/frontends/design/gamification/hands/{Core_Users::$info['statistic']['traffic_campaigns_img']}.png" width="36px" height="36px" />
                        		</a>
                        	</li>
                        {/if}
                        {if Core_Users::$info['statistic']['traffic_received_img'] != 0}
                        	<li class="hidden-xs">
                        		<a href="javascript:void(0);" data-toggle="tooltip" data-placement="bottom" title="Traffic Your LPS Pages Received">
                        			<img src="/skin/i/frontends/design/gamification/bmen/{Core_Users::$info['statistic']['traffic_received_img']}.png" width="36px" height="36px" />
                        		</a>
                        	</li>
                        {/if}
                        <li class="dropdown" style="display: block!important;">
                            <a href="" class="dropdown-toggle profile" data-toggle="dropdown" aria-expanded="false"><img src="/skin/i/frontends/design/avatar-1.jpg" alt="user-img" class="img-circle"> </a>
                            <ul class="dropdown-menu">
                                <li><a href="{url name='site1_accounts' action='details'}"><i class="ti-user m-r-5"></i> Account</a></li>
                            	<li><a href="{url name='site1_accounts' action='profile'}"><i class="ti-settings m-r-5"></i> Settings</a></li>
                                <li><a href="{url name='site1_accounts' action='payment_history'}"><i class="ti-info-alt m-r-5"></i> Information</a></li>
                                <li><a href="/logoff/"><i class="ti-power-off m-r-5"></i> Sign Out</a></li>
                            </ul>
                        </li>
                    </ul>
	            </div>
            </div>
        </div>
    </div>

    <div class="body" id="body">

		<h3></h3>
		<div id="menu">
			<div class="settings" data-target="block">
				<img src="/skin/i/frontends/design/newUI/contentbox/BOX.png" title="Box" width="62px" height="62px" />
			</div>
			<div class="settings" data-target="text">
				<img src="/skin/i/frontends/design/newUI/contentbox/TEXT.png" title="Text" width="62px" height="62px" />
			</div>
			
			<div class="settings" data-target="lead_channels">
				<img src="/skin/i/frontends/design/newUI/contentbox/FORM.png" title="Form" width="62px" height="62px" />

				<div class="menu_options options_form">
					<!--<div class="settings" data-target="form">Default</div>
					<div class="settings" data-target="form_formated">Formated</div>-->
					<div class="settings" data-target="lead_channels">Lead Channels</div>
				</div>
			</div>
			
			
			<div class="options" data-target="button">
				<img src="/skin/i/frontends/design/newUI/contentbox/BUTTON.png" title="Button" width="62px" height="62px" />

				<div class="menu_options options_button">
					<div class="settings" data-target="button">Create</div>
					<div class="settings" data-target="button_select">Select</div>
					<div class="settings" data-target="button_upload">Upload</div>
				</div>
			</div>
			
			
			<div class="settings" data-target="video">
				<img src="/skin/i/frontends/design/newUI/contentbox/VIDEO.png" title="Video" width="62px" height="62px" />
			</div>
			<div class="settings" data-target="image">
				<img src="/skin/i/frontends/design/newUI/contentbox/IMAGE.png" title="Image" width="62px" height="62px" />
			</div>
			<div class="settings" data-target="html">
				<img src="/skin/i/frontends/design/newUI/contentbox/HTML.png" title="Html" width="62px" height="62px" />
			</div>
			<div class="options">
				<a href="/">Dashboard</a><br/>
				<a href="{url name='site1_contentbox' action='manage'}">Manage</a><br/>
				<a href="#popup-templates" class="popup-templates">Templates</a>
			</div>
		</div>

		<form action="" method="post" id="form-cb" novalidate>
			{if !empty($smarty.get.id)} <input type="hidden" name="arrData[id]" value="{$arrData.id}">{/if}
			<div id="hide_grid_menu_block" class="hidden" style="top: 94px;">&nbsp;</div>
			<div id="grid_setting" class="hidden" style="top: 84px; display: none;"></div>

			<div style="position: absolute; top: 0px; right: 0; width: 350px; z-index: 5;" class="setting-tabs">
				<div class="col-xs-3 no-padding"> <!-- required for floating -->
			    <!-- Nav tabs -->
					<ul class="nav nav-tabs tabs-left sideways">
						<li><a href="javascript:void(0);" id="close"><i class="fa fa-arrow-circle-down" aria-hidden="true"></i></a></li>
						<li class="active"><a href="#home" data-toggle="tab">View</a></li>
						<li><a href="#settings_menu" data-toggle="tab">Advanced</a></li>
						<li><a href="#messages" data-toggle="tab">Styles</a></li>
						<li><a href="#components_menu" data-toggle="tab">Layers</a></li>
					</ul>
				</div>

				<div class="col-xs-9 no-padding">
					<div class="tab-content color-f7f7f7">
						<div class="tab-pane active" id="home">
							<div class="grid">
								<span>Grid on/off</span>
								<input type="checkbox" id="grid" checked="checked">
								<label for="grid"></label>
							</div>
							<div class="">
								<span class="setting_label">Cell size</span>
								<input type="number" value="20" class="form-control" id="cell-size">
							</div>

							<span class="setting_label">Size mobile screen</span>
							<ul class="mobile-size">
								<li><a href="javascript:void(0);" data-size-width="375" data-size-height="667" data-orientation="true" data-type="mobile"><i class="icon-screen-smartphone"></i></a><span>375*667</span></li>
								<!--<li><a href="javascript:void(0);" data-size-width="800" data-size-height="1280" data-orientation="true" data-type="tablet"><i class="icon-screen-smartphone" style="font-size: 35px;"></i></a><span>800*1280</span></li>-->
								<li><a href="javascript:void(0);" data-orientation="false" class="active" data-type="pc"><i class="icon-screen-desktop" style="font-size: 32px;"></i></a><span>PC</span></li>
							</ul>

							<span class="orientation">Orientation</span>
							<ul class="mobile-size orientation">
								<li><a href="javascript:void(0);" data-orientation="portret" class="active"><i class="icon-screen-smartphone"></i></a></li>
								<li><a href="javascript:void(0);" data-orientation="albumn"><i class="icon-screen-smartphone rotate-90deg"></i></a></li>
							</ul>
						</div>
						<div class="tab-pane" id="settings_menu">
							<span class="setting_label">ContentBox Name</span>
							<input type="text" name="arrData[name]" value="{$arrData.name}" placeholder="New Content Box" class="form-control">
							{if Core_Acs::haveAccess( array( 'LPB Admins' ) )}
							<span class="setting_label">Create Template</span>
							<input type="hidden" name="arrData[flg_template]" value="0">
							<input type="checkbox" name="arrData[flg_template]"{if $arrData.flg_template!=0} checked{/if} value="1" >
							{/if}
						</div>
						<div class="tab-pane" id="messages">

						</div>
						<div class="tab-pane" id="components_menu">

						</div>
					</div>
				</div>  
			</div>

			<button type="submit" name="create_cb" id="generate" class="btn btn-info waves-effect waves-light" style="left: 20px;top: 600px;position: absolute; z-index: 20;">Save</button>
		</form>

	<canvas id="drawingCanvas" style="display: none;" width="100" height="100"></canvas>
	
	<div  style="display:none;">
	<div id="popup-templates" style="overflow: scroll;" class="cerabox-content">
		<div class="card-box" >
			{if $arrTemplList}
			<table class="table table-striped">
			<thead>
				<tr>
					<th>Box Name</th>
					<th>Options</th>
				</tr>
			</thead>
			<tbody>
				{foreach $arrTemplList as $v}
				<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
					<td>{if empty($v.name)}Box #{$v.id}{else}{$v.name}{/if}</td>
					<td><a href="#" data-settings="{base64_encode(json_encode( array_values( $v.settings ) ))}" class="move_box_settings">Add</a></td>
				</tr>
				{/foreach}
			</tbody>
			</table>
			{else}
			<div>No templates found</div>
			{/if}
		</div>
	</div>
	</div>

	<script src="{url name='site1_contentbox' action='view'}{if isset($smarty.get.id)}?id={Project_Contentbox::generateId($smarty.get.id)}&{else}?{/if}local_data" type="text/javascript"></script>
</div>



<div class="emulator scroll-pane" id="emulator"></div>
<div class="mobile-img"></div>
<script src="/skin/light/js/bootstrap.min.js"></script>
<script src="/skin/light/js/detect.js"></script>
<script src="/skin/light/js/jquery.slimscroll.js"></script>

<script src="/skin/light/js/fastclick.js"></script>
<script src="/skin/light/js/waves.js"></script>
<script src="/skin/light/js/wow.min.js"></script>

<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
<script src="/skin/light/js/jquery.app.js"></script>

<script src="/skin/_css//jquery.custom-scroll.js"></script>
{literal}
<script type="text/javascript">
    jQuery(document).ready(function($) {
    	jQuery('#emulator').customScroll();
		
		$('.selectpicker').selectpicker({
		  	style: 'btn-default',
		  	size: 4
		});

		jQuery('#close').click(function(){
			if(jQuery(this).children('i').hasClass('fa-arrow-circle-down')) {
				jQuery('.setting-tabs').stop(true, true).animate({
					right : "-255px"
				}, "fast", function(){
					jQuery('.sideways > li:not(:first-child)').addClass('hidden');
				});
			} else {
				jQuery('.setting-tabs').stop(true, true).animate({
					right : "0px"
				}, "fast", function(){
					jQuery('.sideways > li:not(:first-child)').removeClass('hidden');
				});
			}
			
			jQuery(this).children('i').toggleClass('fa-arrow-circle-down').toggleClass('fa-arrow-circle-up');
		});
	});

	var canvas;
	var context;
	
	window.onload = function() {
		var size = parseInt(jQuery('#cell-size').val());
		var dataUrl;
		jQuery('#drawingCanvas').attr('width', size);
		jQuery('#drawingCanvas').attr('height', size);
		canvas = document.getElementById("drawingCanvas");
		context = canvas.getContext("2d");
		
		context.beginPath();
		for (var x = 0; x < size; x += size) {
			context.moveTo(x, 0);
			context.lineTo(x, size);
		}

		for (var y = 0; y < 100; y += size) {
			context.moveTo(0, y);
			context.lineTo(size, y);
		}
		context.strokeStyle = "#eee";
		context.stroke();

		dataUrl = canvas.toDataURL();
		jQuery('.emulator').attr('style','background:url(' + dataUrl +') #fff!important;');


		jQuery('#cell-size').change(function(){
			var background = jQuery('.emulator').attr('style').match(/background:(.*)!important;/i);
			if(jQuery('#grid').prop('checked')){
				size = parseInt(jQuery(this).val());
				jQuery('#drawingCanvas').attr('width', size);
				jQuery('#drawingCanvas').attr('height', size);
				context.clearRect(0, 0, canvas.width, canvas.height);
				
				context.beginPath();
				for (var x = 0; x < size; x += size) {
					context.moveTo(x, 0);
					context.lineTo(x, size);
				}

				for (var y = 0; y < size; y += size) {
					context.moveTo(0, y);
					context.lineTo(size, y);
				}
				context.strokeStyle = "#eee";
				context.stroke();

				jQuery('.emulator').attr('style',jQuery('.emulator').attr('style').replace(background[0], 'background:url(' + canvas.toDataURL() +') #fff!important;'));
			}
		});

		jQuery('#grid').change(function(){
			var background = jQuery('.emulator').attr('style').match(/background:(.*)!important;/i);
			if(jQuery(this).prop('checked')) {
				size = parseInt(jQuery('#cell-size').val());
				console.log(size);
				jQuery('#drawingCanvas').attr('width', size);
				jQuery('#drawingCanvas').attr('height', size);
				context.clearRect(0, 0, canvas.width, canvas.height);
				
				context.beginPath();
				for (var x = 0; x < size; x += size) {
					context.moveTo(x, 0);
					context.lineTo(x, size);
				}

				for (var y = 0; y < size; y += size) {
					context.moveTo(0, y);
					context.lineTo(size, y);
				}
				context.strokeStyle = "#eee";
				context.stroke();
				jQuery('.emulator').attr('style', jQuery('.emulator').attr('style').replace(background[0], 'background:url(' + canvas.toDataURL() +') #fff!important;'));
			} else {
				jQuery('.emulator').attr('style', jQuery('.emulator').attr('style').replace(background[0], 'background: #ffffff!important;'));
			}
		});
	}


</script>
{/literal}
</body>
</html>