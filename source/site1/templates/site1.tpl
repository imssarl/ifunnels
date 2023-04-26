{if $arrPrm.action}{*this module own action*}
{*тут отступы лучше не делать а то попадут в буфер*}{include file="site1_`$arrPrm.action`.tpl"}
{elseif $arrNest.name&&$arrNest.flg_tpl}{*pop-up actions*}
{*тут отступы лучше не делать а то попадут в буфер*}{module name=$arrNest.name action=$arrNest.action}
{else}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" {if !$arrUser.id} style="background: #fff!important;"{/if}>
<head>
	{if $arrUser.id}
		{module name='site1' action='head'}
	{elseif $arrNest.action=="registration"}
		{module name='site1' action='head' type='reggi'}
	{else}
		{module name='site1' action='head' type='mini'}
	{/if}
</head>
<body class="fixed-left" {if !$arrUser.id}style="background: #FFFFFF !important;"{/if}>
	{if isset( Core_Users::$info['id'] ) && !empty( Core_Users::$info['id'] )}
	<!-- <iframe src="https://app.local/services/updater.php?method=202004032&user_id={Core_Users::$info['id']}" style="display:none !important;"></iframe> -->
	{/if}
	{if $temporaryUnavailable}
    <div style="margin:80px 40px 70px 200px;">
        The Creative Niche Manager system is under maintenance right now. It will be back shortly. We apologize for any
        inconvenience.
    </div>
		{else}
		{if $arrNest.name=='site1_ecom_funnels' && $arrNest.action=='share' }
			{module name='site1_ecom_funnels' action='share'}
		{else}
		{if $arrNest.name}{*nested mod actions*}
		<div id="{if $arrNest.action!="change"}wrapper{/if}">
			{if $arrNest.action!="registration"&&$arrNest.action!="activate"&&$arrNest.action!="change"&&$arrNest.action!="unsubscribe"}
			<div class="topbar">
                <div class="navbar navbar-default" role="navigation">
                    <div class="container">
		                <div class="topbar-left col-md-5">
			                <div class="col-md-3 col-xs-9">
			                    <a href="/" class="logo"><img src="/skin/i/frontends/ifunnels.png" alt="" class="img-responsive" style="width: 135px;" /></a>
			                </div>
			                <div class="col-md-1 col-xs-3">
                                <button class="button-menu-mobile open-left m-t-10">
                                    <i class="ion-navicon"></i>
                                </button>
                                <span class="clearfix"></span>
                            </div>
			            </div>
			            <div class="col-md-7 user-panel">
			            	<style type="text/css">
			            		.dropdown, a[data-toggle="tooltip"] { display: block!important; }
							</style>
			            	<ul class="nav navbar-nav navbar-right pull-right">
								<li class="hidden-xs">
									<a href="https://help.ifunnels.com" target="_blank" class="btn btn-info btn-rounded waves-effect waves-light m-t-15 i-help" style="line-height:normal;color:#5fbeaa!important;padding:6px 20px;">
										<span class="btn-label"><i class="fa fa-exclamation"></i></span>iFunnels Help
									</a>
								</li>
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
										<li><a href="{url name='site1_accounts' action='credits'}"><i class="ti-money m-r-5"></i> {Core_Users::$info['amount']} credits (add more)</a></li>
                                    	<li><a href="{url name='site1_accounts' action='profile'}"><i class="ti-settings m-r-5"></i> Settings</a></li>
										{if Core_Acs::haveRight( ['site1_deliver'=>['dashboard']] ) && Project_Deliver_Member::hasExistsOnEthiccash(Core_Users::$info.email)}
										<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='billing'}active{/if}"><a href="{url name='site1_deliver' action='billing'}" class="stripe-billing"><img class="icon" src="/skin/i/frontends/stripe.png" alt=""> Billing</a></li>
										{/if}
                                        <li><a href="{url name='site1_accounts' action='payment_history'}"><i class="ti-info-alt m-r-5"></i> Information</a></li>
                                        <li><a href="{url name='site1_accounts' action='termspage'}" target="_blank"><i class="ti-announcement m-r-5"></i> Terms and Conditions</a></li>
                                        <li><a href="{url name='site1_accounts' action='apppolicypage'}" target="_blank"><i class="ti-world m-r-5"></i> Privacy Policy</a></li>
										<li><a href="{url name='site1_accounts' action='logoff'}"><i class="ti-power-off m-r-5"></i> Sign Out</a></li>
                                    </ul>
                                </li>
                            </ul>
			            </div>
                    </div>
                </div>
            </div>
			{include file='site1_sidebar.tpl'}
			{/if}
			<div class="content-page"> 
				 <div class="content">
	                <div class="container">
						{module name=$arrNest.name action=$arrNest.action}
					</div>
				</div>
			</div>
		</div>
		{else}{*main page*}
			{if $arrUser.id}
				<div id="wrapper">
					<div class="topbar">
		                <div class="navbar navbar-default" role="navigation">
		                    <div class="container">
		                    	<div class="topbar-left col-md-5">
					                <div class="col-md-3 col-xs-9">
										<a href="/" class="logo"> 
											<img src="/skin/i/frontends/ifunnels.png" alt="" class="img-responsive" style="width: 135px;" />
										</a>
					                </div>
					                <div class="col-md-1 col-xs-3">
		                                <button class="button-menu-mobile open-left m-t-10">
		                                    <i class="ion-navicon"></i>
		                                </button>
		                                <span class="clearfix"></span>
		                            </div>
					            </div>
					            <div class="col-md-7 user-panel">
					            	<style type="text/css">
					            		.dropdown, a[data-toggle="tooltip"] { display: block!important; }
									</style>
					            	<ul class="nav navbar-nav navbar-right pull-right">
		                                <li class="hidden-xs" style="padding-right:10px;">
											<div class="btn btn-info btn-rounded waves-effect waves-light m-t-15 i-help dropdown" style="overflow:visible;line-height:normal;background-color: transparent;padding:6px 20px;">
												<a href="https://roadmap.ifunnels.com/" target="_blank" style="display: inline !important;">Feedback & Roadmap </a>&nbsp;&nbsp;
												<a href="" class="dropdown-toggle profile" data-toggle="dropdown" aria-expanded="false" style="display: inline !important;"><i class="fa fa-arrow-down m-r-5"></i></a>
												<ul class="dropdown-menu">
													<li><a href="https://roadmap.ifunnels.com/b/bugs/" target="_blank"><i class="ti-info-alt m-r-5"></i> Bugs</a></li>
													<li><a href="https://roadmap.ifunnels.com/b/feedbacks-features-roadmap/" target="_blank"><i class="ti-world m-r-5"></i> Feature requests</a></li>
												</ul>
											</div>
		                                </li>
										<li class="hidden-xs">
											<a href="https://help.ifunnels.com" target="_blank" class="btn btn-info btn-rounded waves-effect waves-light m-t-15 i-help" style="line-height:normal;color:#5fbeaa!important;padding:6px 20px;">
												<span class="btn-label"><i class="fa fa-exclamation"></i></span>iFunnels Help
											</a>
										</li>
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
												<li><a href="{url name='site1_accounts' action='credits'}"><i class="ti-money m-r-5"></i> {Core_Users::$info['amount']} credits (add more)</a></li>
		                                    	<li><a href="{url name='site1_accounts' action='profile'}"><i class="ti-settings m-r-5"></i> Settings</a></li>
												{if Core_Acs::haveRight( ['site1_deliver'=>['dashboard']] ) && Project_Deliver_Member::hasExistsOnEthiccash(Core_Users::$info.email)}
												<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='billing'}active{/if}"><a href="{url name='site1_deliver' action='billing'}" class="stripe-billing"><img class="icon" src="/skin/i/frontends/stripe.png" alt=""> Billing</a></li>
												{/if}
		                                        <li><a href="{url name='site1_accounts' action='payment_history'}"><i class="ti-info-alt m-r-5"></i> Information</a></li>
		                                        <li><a href="{url name='site1_accounts' action='termspage'}" target="_blank"><i class="ti-announcement m-r-5"></i> Terms and Conditions</a></li>
                                        		<li><a href="{url name='site1_accounts' action='apppolicypage'}" target="_blank"><i class="ti-world m-r-5"></i> Privacy Policy</a></li>
												<li><a href="{url name='site1_accounts' action='logoff'}"><i class="ti-power-off m-r-5"></i> Sign Out</a></li>
		                                    </ul>
		                                </li>
		                            </ul>
					            </div>
		                    </div>
		                </div>
		            </div>
					{include file='site1_sidebar.tpl'}
					 <div class="content-page">
		                <div class="content">
		                    <div class="container">
		                    	{module name='site1_hiam_lite' action='view'}
								{module name='site1_accounts' action='main'}
		                    </div>
		                </div>
	                </div>
				</div>
			{else}
				{module name='site1_accounts' action='login'}
			{/if}
		{/if}
		{/if}
	{/if}
	{if $arrUser.id}
	{if $flgShowDPA}
<a class="dpa" href="{url name='site1_accounts' action='dpa'}">DPA</a>
<script type="text/javascript">{literal}
	dpaBox=new CeraBox( $$('.dpa'), {
		group: false,
		width:'80%',
		height:'80%',
		displayTitle: true,
		titleFormat: 'Data Protection Agreement',
		clickToCloseOverlay: false,
		clickToClose: false
	});
	window.addEvent('domready', function(){
		document.getElement('a.dpa').fireEvent('click');
		document.getElements('.cerabox-close').setStyle('display','none');
	});
{/literal}</script>
	{/if}
	<script type="text/javascript">{literal}
	window.addEvent('domready', function(){
		var obj=new Request.JSON({
			method:'post',
			url:'/services/regenerate.php',
			initialDelay:(10 * 1000),
			delay:(5 * 60 * 1000),
			limit:(10 * 60 * 1000),
			onSuccess: function(json){
				if ( json.redirect ) {
					if( json.redirect == 2 ){
						alert('You do not have access to this module!');
						location.href='{/literal}{url name="site1_accounts" action="payment"}{literal}';
					} else {
						location.href = '/';
					}
				}
			}
		}).startTimer({
		'action': '{/literal}{$arrNest.action}',
		'name': '{$arrNest.name}{literal}'
		});
	});
	{/literal}</script>
		{*if Core_Acs::haveAccess( array( 'Maintenance' ) )}
        <script type="text/javascript" src="//assets.zendesk.com/external/zenbox/v2.4/zenbox.js"></script>
        <style type="text/css" media="screen, projection">
            @import url(//assets.zendesk.com/external/zenbox/v2.4/zenbox.css);
        </style>
        <script type="text/javascript">
            if (typeof(Zenbox) !== "undefined") {
                Zenbox.init({
                    dropboxID:"20080738",
                    url:"https://creativenichemanager.zendesk.com",
                    tabID:"help",
                    tabColor:"black",
                    tabPosition:"Left"
                });
            }
        </script>
		{/if*}
	{/if}
	{if $arrUser.id}
		{if $smarty.server.HTTP_HOST != 'cnm.local' }
		{* <script>{literal}
		window.customerlySettings = {
			app_id: "7d63aa7c",
			user_id: "{/literal}{$arrUser.id}{literal}",// Optional
			name: "{/literal}{if !empty($arrUser.buyer_name)}{$arrUser.buyer_name}{else}{$arrUser.nickname}{/if}{literal}", 
			email: "{/literal}{$arrUser.email}{literal}", 
			//Add your custom attributes of the user you want to track
			attributes: {
				subscription_type: "2",
				created_at: 1384902000, // Signup date as a Unix timestamp
				license_expire_at: 1603490400,
				cnm_groups: "{/literal}{$intercomUpdatedGroups}{literal}"
			},
			//If you manage different user companies you can track the companies and their attributes like this:
			company: {
			company_id: "REPLACE WITH COMPANY ID",
			name: "REPLACE WITH COMPANY NAME",
			// Add comapnies's custom attributes as you prefer
			license_expire_at: 1643410800, 
			company_size: 12, 
			}
		};
		!function(){function e(){var e=t.createElement("script");e.type="text/javascript",e.async=!0,e.src="https://widget.customerly.io/widget/7d63aa7c";var r=t.getElementsByTagName("script")[0];r.parentNode.insertBefore(e,r)}var r=window,t=document,n=function(){n.c(arguments)};r.customerly_queue=[],n.c=function(e){r.customerly_queue.push(e)},r.customerly=n,r.attachEvent?r.attachEvent("onload",e):r.addEventListener("load",e,!1)}();
		window.customerly( "attribute", "cnm_groups", "{/literal}{$intercomUpdatedGroups}{literal}" );
		{/literal}</script>
		*}
		<script type="text/javascript">
		{literal}
		{/literal}{if empty( $arrNest ) && $smarty.session.flgFirstLogin===true}{literal}
		heap.identify({
			name: '{/literal}{$arrUser.nickname}{literal}', //replace with real name dynamically
			email: '{/literal}{$arrUser.email}{literal}' // replace with logged in email dynamically
		});
		{/literal}{/if}{literal}
		var _learnq = _learnq || [];
		_learnq.push(['account', 'h2D9Pa']);
		_learnq.push(['identify', {
			'$email' : '{/literal}{$arrUser.email}{literal}'// Change the line below to dynamically print the user's email.
		}]);
		{/literal}
		{if $arrNest.name=="site1_squeeze"}
			{module name='site1_squeeze' action='learnq_script'}
		{/if}
		</script>
		{/if}
	{/if}
	<script type="text/javascript" src="/skin/_js/ui.js"></script>
	<script src="/skin/light/js/bootstrap.min.js"></script>
	<script src="/skin/light/js/detect.js"></script>
	<script src="/skin/light/js/fastclick.js"></script>
	<script src="/skin/light/js/jquery.slimscroll.js"></script>
	<script src="/skin/light/js/jquery.blockUI.js"></script>
	<script src="/skin/light/js/waves.js"></script>
	<script src="/skin/light/js/wow.min.js"></script>
	<script src="/skin/light/js/jquery.nicescroll.js"></script>
	<script src="/skin/light/js/jquery.scrollTo.min.js"></script>
	<script src="/skin/light/plugins/peity/jquery.peity.min.js"></script>
	<!-- jQuery  -->
	<script src="/skin/light/plugins/waypoints/lib/jquery.waypoints.js"></script>
	<script src="/skin/light/plugins/counterup/jquery.counterup.min.js"></script>
	<script src="/skin/light/plugins/jquery-knob/jquery.knob.js"></script>
	<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
	<script src="/skin/light/js/jquery.core.js"></script>
	<script src="/skin/light/js/jquery.app.js"></script>

{literal}<script type="text/javascript">
jQuery(document).ready(function($) {
$('.counter').counterUp({
	 delay: 100,
	 time: 1200
});
$('.selectpicker').selectpicker({
	style: 'btn-info',
	size: 4
});
	//$(".knob").knob();
});
</script>{/literal}

</body>
</html>
{/if}