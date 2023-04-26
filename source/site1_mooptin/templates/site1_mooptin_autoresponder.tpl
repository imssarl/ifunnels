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
	<link href="/skin/light/css/core.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/plugins/bootstrap-select/dist/css/bootstrap-select.min.css" rel="stylesheet" />
	<link href="/skin/light/css/pages.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/responsive.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/components.css" rel="stylesheet" type="text/css" />
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
	
	<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>

	<link rel="stylesheet" href="/skin/_css/contentbox.css" type="text/css" />
	<link rel="stylesheet" href="/skin/_css/bootstrap.vertical-tabs.css" type="text/css" />
</head>
<body style="padding:40px;">

{if $msg!=''}
<div class="alert alert-success alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
	<div>{$msg}</a></div>
</div>
{/if}
{if $error!=''}
	{include file='../../message.tpl' type='error' message=$error}
{/if}

<div class="card-box">
<form action="" method="post" id="form" class="wh validate" enctype="multipart/form-data">

<input type="hidden" name="arrData[id]" value="{if isset($arrData.id)}{$arrData.id}{/if}">

<div class="form-group">
	<label>Select autoresponder:</label>
	<select name="arrData[settings][integration][]" id="mo_optin_integration" size="5" class="btn-group selectpicker show-tick">
		<optgroup label="List integrations">
		<option value="aweber"{if isset($arrData.settings.integration) && in_array( 'aweber', $arrData.settings.integration )} selected="selected"{/if}>AWeber</option>
		<option value="getresponse"{if isset($arrData.settings.integration) && in_array( 'getresponse', $arrData.settings.integration )} selected="selected"{/if}>GetResponse</option>
		{if Core_Acs::haveAccess( array( 'Affiliate Funnels Starter' ) )}
		<option value="perkzilla"{if isset($arrData.settings.integration) && in_array( 'perkzilla', $arrData.settings.integration )} selected="selected"{/if}>PerkZilla</option>
		{/if}
		<option value="activecampaign"{if isset($arrData.settings.integration) && in_array( 'activecampaign', $arrData.settings.integration )} selected="selected"{/if}>ActiveCampaign</option>
		<option value="mailchimp"{if isset($arrData.settings.integration) && in_array( 'mailchimp', $arrData.settings.integration )} selected="selected"{/if}>MailChimp</option>
		
		<option value="ontraport"{if isset($arrData.settings.integration) && in_array( 'ontraport', $arrData.settings.integration )} selected="selected"{/if}>Ontraport</option>
		<option value="webhook"{if isset($arrData.settings.integration) && in_array( 'webhook', $arrData.settings.integration )} selected="selected"{/if}>Zapier (webhook)</option>
		
		<option value="gotowebinar"{if isset($arrData.settings.integration) && in_array( 'gotowebinar', $arrData.settings.integration )} selected="selected"{/if}>GoToWebinar</option>
		<option value="everwebinar"{if isset($arrData.settings.integration) && in_array( 'everwebinar', $arrData.settings.integration )} selected="selected"{/if}>EverWebinar</option>
		<option value="webinarjam"{if isset($arrData.settings.integration) && in_array( 'webinarjam', $arrData.settings.integration )} selected="selected"{/if}>WebinarJam</option>
		
		<option value="convertkit"{if isset($arrData.settings.integration) && in_array( 'convertkit', $arrData.settings.integration )} selected="selected"{/if}>Convertkit</option>
		
		<option value="html"{if isset($arrData.settings.integration) && in_array( 'html', $arrData.settings.integration )} selected="selected"{/if}>HTML</option>
		
		{*
		<option value="icontact"{if isset($arrData.settings.integration) && in_array( 'icontact', $arrData.settings.integration )} selected="selected"{/if}>iContact</option>
		<option value="campaignmonitor"{if isset($arrData.settings.integration) && in_array( 'campaignmonitor', $arrData.settings.integration )} selected="selected"{/if}>Campaign Monitor</option>
		<option value="madmimi"{if isset($arrData.settings.integration) && in_array( 'madmimi', $arrData.settings.integration )} selected="selected"{/if}>Mad Mimi</option>
		<option value="sendy"{if isset($arrData.settings.integration) && in_array( 'sendy', $arrData.settings.integration )} selected="selected"{/if}>Sendy</option>
		<option value="benchmark"{if isset($arrData.settings.integration) && in_array( 'benchmark', $arrData.settings.integration )} selected="selected"{/if}>Benchmark Email</option>
		<option value="interspire"{if isset($arrData.settings.integration) && in_array( 'interspire', $arrData.settings.integration )} selected="selected"{/if}>Interspire</option>
		*}
		</optgroup>
	</select>
</div>
{* POPUP_SETTINGS *}
{*gotowebinar*}
<div class="mo_optin_integration_group mo_optin_integration_gotowebinar" style="display:{if isset($arrData.settings.integration) && in_array( 'gotowebinar', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>User Name: </label>
		<input type="text" id="gotowebinar_username" name="arrData[settings][options][username]" value="{$arrData['settings']['options']['username']}" class="form-control">
	</div>
	<div class="form-group">
		<label>Password: </label>
		<input type="password" id="gotowebinar_password" name="arrData[settings][options][password]" value="{$arrData['settings']['options']['password']}" class="form-control">
	</div>
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="gotowebinar_connect();" >Activate Connection</button>
		<br><small id="gotowebinar_activate_loading"></small>
		<input type="hidden" id="gotowebinar_activation" name="arrData[settings][options][activation]" value="{$arrData['settings']['options']['activation']}" >
	</div>
</div>

{*webhook*}
<div class="mo_optin_integration_group mo_optin_integration_webhook" style="display:{if isset($arrData.settings.integration) && in_array( 'webhook', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Webhook</label>
	</div>
	<div class="form-group">
		<label>URL to Ping: </label>
		<input type="text" id="webhook_url" name="arrData[settings][options][webhook_url]" value="{$arrData['settings']['options']['webhook_url']}" class="form-control">
	</div>
</div>

{*html*}
<div class="mo_optin_integration_group mo_optin_integration_html" style="display:{if isset($arrData.settings.integration) && in_array( 'html', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Autoresponder Form: </label>
		<textarea name="arrData[settings][options][html_form]" class="form-control">{$arrData['settings']['options']['html_form']}</textarea>
	</div>
</div>

{*ontraport*}
<div class="mo_optin_integration_group mo_optin_integration_ontraport" style="display:{if isset($arrData.settings.integration) && in_array( 'ontraport', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Ontraport</label>
	</div>
	<div class="form-group">
		<label>Ontraport APP Id: </label>
		<input type="text" id="ontraport_app_id" name="arrData[settings][options][ontraport_app_id]" value="{$arrData['settings']['options']['ontraport_app_id']}" class="form-control">
		<br><small>Enter your Ontraport APP Id. You can get it <a href="https://app.ontraport.com/#!/api_settings/listAll" target="_blank">here</a>.</small>
	</div>
	<div class="form-group">
		<label>Ontraport API Key: </label>
		<input type="text" id="ontraport_api_key" name="arrData[settings][options][ontraport_api_key]" value="{$arrData['settings']['options']['ontraport_api_key']}" class="form-control">
		<br><small>Enter your Ontraport API Key.</small>
	</div>
</div>


{*mailchimp*}
<div class="mo_optin_integration_group mo_optin_integration_mailchimp" style="display:{if isset($arrData.settings.integration) && in_array( 'mailchimp', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>MailChimp</label>
	</div>
	<div class="form-group">
		<label>MailChimp API Key: </label>
		<input type="text" id="mailchimp_api_key" name="arrData[settings][options][mailchimp_api_key]" value="{$arrData['settings']['options']['mailchimp_api_key']}" class="form-control">
		<br><small>Enter your MailChimp API Key. You can get it <a href="https://admin.mailchimp.com/account/api-key-popup" target="_blank">here</a>.</small>
	</div>
	<div class="form-group">
		<label>MailChimp User Name: </label>
		<input type="text" id="mailchimp_api_key" name="arrData[settings][options][mailchimp_user]" value="{$arrData['settings']['options']['mailchimp_user']}" class="form-control">
		<br><small>Enter your User Name. You can get it <a href="https://admin.mailchimp.com/account/users/" target="_blank">here</a>.</small>
	</div>
</div>


{*icontact*}
<div class="mo_optin_integration_group mo_optin_integration_icontact" style="display:{if isset($arrData.settings.integration) && in_array( 'icontact', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>iContact</label>
	</div>
	<div class="form-group">
		<label>AppID: </label>
		<input type="text" id="icontact_appid" name="arrData[settings][options][icontact_appid]" value="{$arrData['settings']['options']['icontact_appid']}" class="form-control">
		<small>Obtained when you <a href="http://developer.icontact.com/documentation/register-your-app/" target="_blank">Register the API application</a>. This identifier is used to uniquely identify your application.</small>
	</div>
	<div class="form-group">
		<label>API Username: </label>
		<input type="text" id="icontact_apiusername" name="arrData[settings][options][icontact_apiusername]" value="{$arrData['settings']['options']['icontact_apiusername']}" class="form-control">
		<br><small>The iContact username for logging into your iContact account.</small>
	</div>
	<div class="form-group">
		<label>API Password: </label>
		<input type="text" id="icontact_apipassword" name="arrData[settings][options][icontact_apipassword]" value="{$arrData['settings']['options']['icontact_apipassword']}" class="form-control">
		<small>The API application password set when the application was registered. This API password is used as input when your application authenticates to the API. This password is not the same as the password you use to log in to iContact.</small>
	</div>
	
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return icontact_check();" >Make Connection</button>
		<img id="ulp-icontact-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="icontact_status"></small>
	</div>
</div>

{*everwebinar*}
<div class="mo_optin_integration_group mo_optin_integration_everwebinar" style="display:{if isset($arrData.settings.integration) && in_array( 'everwebinar', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Ever Webinar</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="everwebinar_api_key" name="arrData[settings][options][everwebinar_api_key]" value="{$arrData['settings']['options']['everwebinar_api_key']}" class="form-control">
	</div>
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return everwebinar_check();" >Make Connection</button>
		<img id="ulp-everwebinar-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="everwebinar_status" ></small>
	</div>
</div>

{*webinarjam*}
<div class="mo_optin_integration_group mo_optin_integration_webinarjam" style="display:{if isset($arrData.settings.integration) && in_array( 'webinarjam', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>WebinarJam</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="webinarjam_api_key" name="arrData[settings][options][webinarjam_api_key]" value="{$arrData['settings']['options']['webinarjam_api_key']}" class="form-control">
		<small><a target="_blank" href="https://help.genesisdigital.co/017125-WebinarJam-Where-do-I-find-my-WebinarJam-API-Key">Where do I find my WebinarJam API Key?</a></small>
	</div>
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return webinarjam_check();" >Make Connection</button>
		<img id="ulp-webinarjam-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="webinarjam_status" ></small>
	</div>
</div>

{*convertkit*}
<div class="mo_optin_integration_group mo_optin_integration_convertkit" style="display:{if isset($arrData.settings.integration) && in_array( 'convertkit', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>ConvertKit</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="convertkit_api_key" name="arrData[settings][options][convertkit_api_key]" value="{$arrData['settings']['options']['convertkit_api_key']}" class="form-control">
		<small><a target="_blank" href="#">Where do I find my ConvertKit API Key?</a></small>
	</div>
	<div class="form-group">
		<label>Secret Key: </label>
		<input type="text" id="convertkit_secret_key" name="arrData[settings][options][convertkit_secret_key]" value="{$arrData['settings']['options']['convertkit_secret_key']}" class="form-control">
		<small><a target="_blank" href="#">Where do I find my ConvertKit Secret Key?</a></small>
	</div>
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return convertkit_check();" >Make Connection</button>
		<img id="ulp-convertkit-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="convertkit_status" ></small>
	</div>
</div>

{*perkzilla*}
<div class="mo_optin_integration_group mo_optin_integration_perkzilla" style="display:{if isset($arrData.settings.integration) && in_array( 'perkzilla', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>PerkZilla</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="perkzilla_api_key" name="arrData[settings][options][perkzilla_api_key]" value="{$arrData['settings']['options']['perkzilla_api_key']}" class="form-control">
		<small>Enter your PerkZilla API Key.</small>
	</div>
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return perkzilla_check();" >Make Connection</button>
		<img id="ulp-perkzilla-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="perkzilla_status" ></small>
	</div>
</div>

{*getresponse*}
<div class="mo_optin_integration_group mo_optin_integration_getresponse" style="display:{if isset($arrData.settings.integration) && in_array( 'getresponse', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>GetResponse</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="getresponse_api_key" name="arrData[settings][options][getresponse_api_key]" value="{$arrData['settings']['options']['getresponse_api_key']}" class="form-control">
		<small>Enter your GetResponse API Key. You can get your API Key <a href="https://app.getresponse.com/manage_api.html" target="_blank">here</a>.</small>
	</div>
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return getresponse_check();" >Make Connection</button>
		<img id="ulp-getresponse-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="getresponse_status" ></small>
	</div>
</div>

{*campaignmonitor*}
<div class="mo_optin_integration_group mo_optin_integration_campaignmonitor" style="display:{if isset($arrData.settings.integration) && in_array( 'campaignmonitor', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Campaign Monitor</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="campaignmonitor_api_key" name="arrData[settings][options][campaignmonitor_api_key]" value="{$arrData['settings']['options']['campaignmonitor_api_key']}" class="form-control">
		<small>Enter your Campaign Monitor API Key. You can get your API Key from the Account Settings page when logged into your Campaign Monitor account.</small>
	</div>


	<div class="form-group">
		<label>List ID: </label>
		<input type="text" id="campaignmonitor_list_id" name="arrData[settings][options][campaignmonitor_list_id]" value="{$arrData['settings']['options']['campaignmonitor_list_id']}" class="form-control">
		<small>Enter your List ID. You can get List ID from the list editor page when logged into your Campaign Monitor account.</small>
	</div>
</div>
{*madmimi*}
<div class="mo_optin_integration_group mo_optin_integration_madmimi" style="display:{if isset($arrData.settings.integration) && in_array( 'madmimi', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Mad Mimi</label>
	</div>
	<div class="form-group">
		<label>Username/E-mail: </label>
		<input type="text" id="madmimi_login" name="arrData[settings][options][madmimi_login]" value="{$arrData['settings']['options']['madmimi_login']}" class="form-control" onblur="madmimi_loadlist();">
		<small>The Mad Mimi username/e-mail for logging into your Mad Mimi account.</small>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="madmimi_api_key" name="arrData[settings][options][madmimi_api_key]" value="{$arrData['settings']['options']['madmimi_api_key']}" class="form-control" onblur="madmimi_loadlist();">
		<small>Enter your Mad Mimi API Key. You can get your API Key <a href="https://madmimi.com/user/edit?account_info_tabs=account_info_personal" target="_blank">here</a>.</small>
	</div>
	<div class="form-group">
		<small id="madmimi_status" ></small>
	</div>


	<div class="form-group">
		<label>List ID: </label>
		<select id="madmimi_list_id" name="arrData[settings][options][madmimi_list_id]" class="btn-group selectpicker show-tick">
			<option value="">-- Select List --</option>
		</select>
		<br><small>Select desired list.</small>
	</div>
</div>
{*sendy*}
<div class="mo_optin_integration_group mo_optin_integration_sendy" style="display:{if isset($arrData.settings.integration) && in_array( 'sendy', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Sendy</label>
	</div>
	<div class="form-group">
		<label>Installation URL: </label>
		<input type="text" id="sendy_url" name="arrData[settings][options][sendy_url]" value="{$arrData['settings']['options']['sendy_url']}" class="form-control">
		<br><small>Enter your Sendy installation URL (without the trailing slash).</small>
	</div>

	<div class="form-group">
		<label>List ID: </label>
		<input type="text" id="sendy_listid" name="arrData[settings][options][sendy_listid]" value="{$arrData['settings']['options']['sendy_listid']}" class="form-control">
		<small>Enter your List ID. This encrypted & hashed id can be found under View all lists section named ID.</small>
	</div>
</div>
{*benchmark*}
<div class="mo_optin_integration_group mo_optin_integration_benchmark" style="display:{if isset($arrData.settings.integration) && in_array( 'benchmark', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Benchmark</label>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="benchmark_api_key" name="arrData[settings][options][benchmark_api_key]" value="{$arrData['settings']['options']['benchmark_api_key']}" class="form-control" onblur="benchmark_loadlist();">
		<br><small>Enter your Benchmark Email API Key. You can get your API Key <a href="https://ui.benchmarkemail.com/EditSetting" target="_blank">here</a>.</small>
	</div>
	<div class="form-group">
		<small id="benchmark_status" ></small>
	</div>

	<div class="form-group">
		<label>List ID: </label>
		<select id="benchmark_list_id" name="arrData[settings][options][benchmark_list_id]" class="btn-group selectpicker show-tick">
			<option value="">-- Select List --</option>
		</select>
		<br><small>Select desired list.</small>
	</div>
</div>
{*activecampaign*}
<div class="mo_optin_integration_group mo_optin_integration_activecampaign" style="display:{if isset($arrData.settings.integration) && in_array( 'activecampaign', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>ActiveCampaign</label>
	</div>
	<div class="form-group">
		<label>API URL: </label>
		<input type="text" id="activecampaign_url" name="arrData[settings][options][activecampaign_url]" value="{$arrData['settings']['options']['activecampaign_url']}" class="form-control">
		<small>Enter your ActiveCampaign API URL. To get API URL please go to your ActiveCampaign Account >> Integration >> ActiveCampaign API.</small>
	</div>
	<div class="form-group">
		<label>API Key: </label>
		<input type="text" id="activecampaign_api_key" name="arrData[settings][options][activecampaign_api_key]" value="{$arrData['settings']['options']['activecampaign_api_key']}" class="form-control">
		<small>Enter your ActiveCampaign API Key. To get API Key please go to your ActiveCampaign Account >> Integration >> ActiveCampaign API.</small>
	</div>
	
	<div class="form-group">
		<label></label>
		<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return activecampaign_check();" >Make Connection</button>
		<img id="ulp-activecampaign-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
	</div>
	
	<div class="form-group">
		<small id="activecampaign_status" ></small>
	</div>
</div>
{*interspire*}
<div class="mo_optin_integration_group mo_optin_integration_interspire" style="display:{if isset($arrData.settings.integration) && in_array( 'interspire', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>Interspire</label>
	</div>
	<div class="form-group">
		<label>XML Path: </label>
		<input type="text" id="interspire_url" name="arrData[settings][options][interspire_url]" value="{$arrData['settings']['options']['interspire_url']}" class="form-control" onblur="interspire_loadlist();">
		<small>Enter your Interspire XML Path. You can find it in Advanced User Settings.</small>
	</div>
	<div class="form-group">
		<label>XML Username: </label>
		<input type="text" id="interspire_username" name="arrData[settings][options][interspire_username]" value="{$arrData['settings']['options']['interspire_username']}" class="form-control" onblur="interspire_loadlist();">
		<small>Enter your Interspire XML Username. You can find it in Advanced User Settings.</small>
	</div>
	<div class="form-group">
		<label>XML Token: </label>
		<input type="text" id="interspire_token" name="arrData[settings][options][interspire_token]" value="{$arrData['settings']['options']['interspire_token']}" class="form-control" onblur="interspire_loadlist();">
		<small>Enter your Interspire XML Token. You can find it in Advanced User Settings.</small>
	</div>
	<div class="form-group">
		<small id="interspire_status" ></small>
	</div>


	<div class="form-group">
		<label>List ID: </label>
		<select id="interspire_listid" name="arrData[settings][options][interspire_listid]" class="btn-group selectpicker show-tick" onchange="interspire_loadfield();">
			<option value="">-- Select List --</option>
		</select>
		<br><small>Select desired list.</small>
	</div>
	<div class="form-group">
		<label>"Name" field ID: </label>
		<select id="interspire_nameid" name="arrData[settings][options][interspire_nameid]" class="btn-group selectpicker show-tick">
			<option value="">-- Select List --</option>
		</select>
		<br><small>Select your "Name" field.</small>
	</div>
</div>
{*aweber*}
<div class="mo_optin_integration_group mo_optin_integration_aweber" style="display:{if !isset($arrData.settings.integration) || in_array( 'aweber', $arrData.settings.integration )}block{else}none{/if}">
	<div class="form-group">
		<label>AWeber </label>
	</div>
	

	<div id="aweber_no_connnection" style="display:{if !isset($arrData['settings']['options']['aweber_access_secret'])}block{else}none{/if};">
		<div class="form-group">
			<label>Authorization code: </label>
			<input type="text" name="arrData[settings][options][aweber_oauth_id]" id="aweber_oauth_id" value="{$arrData['settings']['options']['aweber_oauth_id']}" class="form-control" placeholder="AWeber authorization code">
			<small>Get your authorization code <a target="_blank" href="https://auth.aweber.com/1.0/oauth/authorize_app/{Project_Exquisite::$AWeberAppId}">here</a>.</small>
		</div>
		<div class="form-group">
			<label></label>
			<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return aweber_connect();" >Make Connection</button>
			<img id="ulp-aweber-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
		</div>
	</div>
	
	<div id="ulp-aweber-connection" style="display:{if isset($arrData['settings']['options']['aweber_access_secret'])}block{else}none{/if};">
	
		<input type="hidden" name="arrData[settings][options][aweber_consumer_key]" id="aweber_consumer_key" value="{$arrData['settings']['options']['aweber_consumer_key']}" />
		<input type="hidden" name="arrData[settings][options][aweber_consumer_secret]" id="aweber_consumer_secret" value="{$arrData['settings']['options']['aweber_consumer_secret']}" />
		<input type="hidden" name="arrData[settings][options][aweber_access_key]" id="aweber_access_key" value="{$arrData['settings']['options']['aweber_access_key']}" />
		<input type="hidden" name="arrData[settings][options][aweber_access_secret]" id="aweber_access_secret" value="{$arrData['settings']['options']['aweber_access_secret']}" />
		
		<div class="form-group" id="aweber_empty_lists" style="display:{if empty($aweber_lists)}block{else}none{/if};">
			<label class="label-control">Activate AWeber: </label>
			<br><small>This AWeber account does not currently have any lists.</small>
		</div>
		<div class="form-group" id="aweber_show_lists" style="display:{if empty($aweber_lists)}none{else}block{/if};">
			<label>Connected: </label>
			<button type="button" class="submit btn btn-success waves-effect waves-light" value="" onclick="return aweber_disconnect();" >Disconnect</button>
			<img id="ulp-aweber-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif" style="display:none;">
			<br><small>Click the button to disconnect.</small>
		</div>
	</div>
	
	<div id="ulp-aweber-message"></div>
	
	
	
<div class="form-group hidden">
 <select id="interspire_nameid" name="arrData[settings][options][interspire_nameid]" class="btn-group selectpicker show-tick" style="width:30%;float:left;margin-bottom:5px;">
  <option value="">-- Select List --</option>
 </select>
 <input type="text" class="form-control" value="name" disabled style="width:30%;margin-bottom:5px; display:inline-block;">
 <input type="text" class="form-control" data-name="use" data-nameattr="name" value="%%name%%" style="width:30%;margin-bottom:5px;margin-left:5px; display:inline-block;">
</div>
	
	
</div>

<div class="form-group">
	<label>Give your Autoresponder a Name:</label>
	<input type="text" name="arrData[name]" value="{$arrData.name}" required class="form-control">
</div>

<fieldset class="m-t-10">
	<button class="btn btn-success btn-rounded waves-effect waves-light" type="button" value="Create Autoresponder" id="create">Create Autoresponder</button>
	<input type="submit" style="display: none;" value="Submit">
</fieldset>

</form>
</div>

<script src="/skin/light/js/bootstrap.min.js"></script>
<script src="/skin/light/js/detect.js"></script>
<script src="/skin/light/js/jquery.slimscroll.js"></script>

<script src="/skin/light/js/fastclick.js"></script>
<script src="/skin/light/js/waves.js"></script>
<script src="/skin/light/js/wow.min.js"></script>

<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
<script src="/skin/light/js/jquery.app.js"></script>
{literal}
<script type="text/javascript">
	{/literal}{if !$flgLoad}{literal}
	setTimeout(function(){
		if( typeof window.mooptinpopup != undefined ){
			window.parent.placeAutoresponder('{/literal}{$arrData.id}{literal}','{/literal}{$arrData.name}{literal}');
			window.parent.mooptinpopup.boxWindow.close();
		}
	}, 3000);
	{/literal}{/if}{literal}
	$('create').addEvent('click',function(){
		$('form').set( 'action','{/literal}{url name="site1_mooptin" action="autoresponder"}{literal}' );
		$('form').set( 'target','_self' );
		$('form').submit();
	});
	$('mo_optin_integration').addEvent('change',function( elt ){
			$$('.mo_optin_integration_group').hide();
			for (var i=0, iLen=elt.target.options.length; i<iLen; i++) {
				opt = elt.target.options[i];
				if (opt.selected) {
					$$('.mo_optin_integration_'+( opt.value || opt.text )).show();
				}
			}
	});

	function aweber_disconnect() {
		jQuery("#ulp-aweber-loading").fadeIn(350);
		jQuery("#ulp-aweber-message").slideUp(350);
		var data = {action: "aweber-disconnect"};
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', data, function(return_data) {
			jQuery("#ulp-aweber-loading").fadeOut(350);
			try {
				//alert(return_data);
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK") {
					jQuery("#ulp-aweber-connection").slideUp(350, function() {
						jQuery("#ulp-aweber-connection").html(data.html);
						jQuery("#ulp-aweber-connection").slideDown(350);
					});
				} else if (status == "ERROR") {
					jQuery("#ulp-aweber-message").html(data.message);
					jQuery("#ulp-aweber-message").slideDown(350);
				} else {
					jQuery("#ulp-aweber-message").html("Service for disconnect aweber is not available.");
					jQuery("#ulp-aweber-message").slideDown(350);
				}
			} catch(error) {
				jQuery("#ulp-aweber-message").html("Service for disconnect aweber is not available. Error: "+error);
				jQuery("#ulp-aweber-message").slideDown(350);
			}
		});
		return false;
	}
	
	function aweber_connect() {
		jQuery("#ulp-aweber-loading").fadeIn(350);
		jQuery("#ulp-aweber-message").slideUp(350);
		var data = {action: "aweber-connect", "aweber-oauth-id": jQuery("#aweber_oauth_id").val()};
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', data, function(return_data) {
			jQuery("#ulp-aweber-loading").fadeOut(350);
			try {
				//alert(return_data);
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK") {
					jQuery("#ulp-aweber-connection").slideDown(350, function() {
						// тут getList =======================================================
						var flgHaveLists=false;
						for (var listId in data.lists) {
							flgHaveLists=true;
						}
						$('aweber_consumer_key').set('value', data.api_settings.aweber_consumer_key);
						$('aweber_consumer_secret').set('value', data.api_settings.aweber_consumer_secret);
						$('aweber_access_key').set('value', data.api_settings.aweber_access_key);
						$('aweber_access_secret').set('value', data.api_settings.aweber_access_secret);
						if( !flgHaveLists ){
							jQuery("#aweber_empty_lists").slideDown(350);
							jQuery("#aweber_show_lists").slideUp(350);
						}else{
							jQuery("#aweber_show_lists").slideDown(350);
							jQuery("#aweber_empty_lists").slideUp(350);
						}
						jQuery('.selectpicker').selectpicker('refresh');
						//================================================================
					});
				} else if (status == "ERROR") {
					jQuery("#ulp-aweber-message").html(data.message);
					jQuery("#ulp-aweber-message").slideDown(350);
				} else {
					jQuery("#ulp-aweber-message").html("Service for connect aweber is not available.");
					jQuery("#ulp-aweber-message").slideDown(350);
				}
			} catch(error) {
				jQuery("#ulp-aweber-message").html("Service for connect aweber is not available. Error: "+error);
				jQuery("#ulp-aweber-message").slideDown(350);
			}
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}
	
	
	
	var active_icontact_appid = "";
	var active_icontact_apiusername = "";
	var active_icontact_apipassword = "";
	function icontact_check() {
		if (active_icontact_appid != jQuery("#icontact_appid").val() || 
			active_icontact_apiusername != jQuery("#icontact_apiusername").val() ||
			active_icontact_apipassword != jQuery("#icontact_apipassword").val()) {
			jQuery("#icontact_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'icontact-lists',
					"icontact_appid": jQuery("#icontact_appid").val(),
					"icontact_apiusername": jQuery("#icontact_apiusername").val(),
					"icontact_apipassword": jQuery("#icontact_apipassword").val(),
					"icontact_listid": "{/literal}{$popup_options['icontact_listid']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#icontact_status").html('iContact connected.');
						} else {
							jQuery("#icontact_status").html('Connection Error.');
						}
					} catch(e) {
						jQuery("#icontact_status").html('Connection Error.'+e);
					}
					jQuery('.selectpicker').selectpicker({
						style: 'btn-info',
						size: 4
					});
				}
			);
		}
	}
	var active_perkzilla_api_key = "";
	function perkzilla_check() {
		jQuery("#ulp-perkzilla-loading").fadeIn(350);
		if (active_perkzilla_api_key != jQuery("#perkzilla_api_key").val()) {
			jQuery("#perkzilla_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'perkzilla-campaigns',
					"perkzilla_api_key": jQuery("#perkzilla_api_key").val(),
					"perkzilla_campaign": "{/literal}{$popup_options['perkzilla_campaign']}{literal}"
				},
				function(return_data) {
					jQuery("#ulp-perkzilla-loading").fadeOut(350);
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#perkzilla_status").html('PerkZilla connected.');
							active_perkzilla_api_key = jQuery("#perkzilla_api_key").val();
						} else{
							jQuery("#perkzilla_status").html('Connection Error.');
						}
					} catch(e) {
						jQuery("#perkzilla_status").html('Connection Error.'+e);
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_getresponse_api_key = "";
	function getresponse_check() {
		if (active_getresponse_api_key != jQuery("#getresponse_api_key").val()) {
			jQuery("#getresponse_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'getresponse-campaigns',
					"getresponse_api_key": jQuery("#getresponse_api_key").val(),
					"getresponse_campaign": "{/literal}{$popup_options['getresponse_campaign']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#getresponse_status").html('Getresponse connected.');
							active_getresponse_api_key = jQuery("#getresponse_api_key").val();
						} else{
							jQuery("#getresponse_status").html('Connection Error.');
						}
					} catch(e) {
						jQuery("#getresponse_status").html('Connection Error.'+e);
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_everwebinar_api_key = "";
	function everwebinar_check() {
		if (active_everwebinar_api_key != jQuery("#everwebinar_api_key").val()) {
			jQuery("#everwebinar_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'everwebinar-campaigns',
					"everwebinar_api_key": jQuery("#everwebinar_api_key").val(),
					"everwebinar_webinar_id": "{/literal}{$popup_options['everwebinar_webinar_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#everwebinar_status").html('Everwebinar connected.');
							active_everwebinar_api_key = jQuery("#everwebinar_api_key").val();
						} else{
							jQuery("#everwebinar_status").html('Connection Error.');
						}
					} catch(e) {
						jQuery("#everwebinar_status").html('Connection Error.'+e);
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_webinarjam_api_key = "";
	function webinarjam_check() {
		if (active_webinarjam_api_key != jQuery("#webinarjam_api_key").val()) {
			jQuery("#webinarjam_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'webinarjam-campaigns',
					"webinarjam_api_key": jQuery("#webinarjam_api_key").val(),
					"webinarjam_webinar_id": "{/literal}{$popup_options['webinarjam_webinar_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#webinarjam_status").html('WebinarJam connected.');
							active_webinarjam_api_key = jQuery("#webinarjam_api_key").val();
						} else{
							jQuery("#webinarjam_status").html('Connection Error.');
						}
					} catch(e) {
						jQuery("#webinarjam_status").html('Connection Error.'+e);
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_convertkit_api_key = "";
	var active_convertkit_secret_key = "";
	function convertkit_check() {
		if ( active_convertkit_api_key != jQuery("#convertkit_api_key").val() && active_convertkit_secret_key != jQuery("#convertkit_secret_key").val() ) {
			jQuery("#convertkit_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'convertkit-campaigns',
					"convertkit_api_key": jQuery("#convertkit_api_key").val(),
					"convertkit_secret_key": jQuery("#convertkit_secret_key").val(),
					"convertkit_webinar_id": "{/literal}{$popup_options['convertkit_webinar_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (typeof data.error == 'undefined') {
							jQuery("#convertkit_status").html('ConvertKit connected.');
							active_convertkit_api_key = jQuery("#convertkit_api_key").val();
						}else{
							jQuery("#convertkit_status").html('Connection Error. '+data.message);
						}
					}catch(e){
						jQuery("#convertkit_status").html('Connection Error.'+e);
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_madmimi_login = "";
	var active_madmimi_api_key = "";
	function madmimi_loadlist() {
		if (active_madmimi_login != jQuery("#madmimi_login").val() || active_madmimi_api_key != jQuery("#madmimi_api_key").val()) {
			jQuery("#madmimi_list_id").html("<option>-- Loading Lists --</option>");
			jQuery("#madmimi_list_id").attr("disabled", "disabled");
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'madmimi-lists',
					"madmimi_login": jQuery("#madmimi_login").val(),
					"madmimi_api_key": jQuery("#madmimi_api_key").val(),
					"madmimi_list_id": "{/literal}{$popup_options['madmimi_list_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#madmimi_list_id").html(data.options);
							jQuery("#madmimi_list_id").removeAttr("disabled");
							active_madmimi_api_key = jQuery("#madmimi_api_key").val();
						} else jQuery("#madmimi_list_id").html("<option>-- Can not get Lists --</option>");
					} catch(e) {
						jQuery("#madmimi_list_id").html("<option>-- Can not get Lists --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_benchmark_api_key = "";
	function benchmark_loadlist() {
		if (active_benchmark_api_key != jQuery("#benchmark_api_key").val()) {
			jQuery("#benchmark_list_id").html("<option>-- Loading Lists --</option>");
			jQuery("#benchmark_list_id").attr("disabled", "disabled");
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'benchmark-lists',
					"benchmark_api_key": jQuery("#benchmark_api_key").val(),
					"benchmark_list_id": "{/literal}{$popup_options['benchmark_list_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#benchmark_list_id").html(data.options);
							jQuery("#benchmark_list_id").removeAttr("disabled");
							active_benchmark_api_key = jQuery("#benchmark_api_key").val();
						} else jQuery("#benchmark_list_id").html("<option>-- Can not get Lists --</option>");
					} catch(e) {
						jQuery("#benchmark_list_id").html("<option>-- Can not get Lists --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	var active_activecampaign_url = "";
	var active_activecampaign_api_key = "";
	function activecampaign_check() {
		if (active_activecampaign_api_key != jQuery("#activecampaign_api_key").val() || active_activecampaign_url != jQuery("#activecampaign_url").val()) {
			jQuery("#activecampaign_status").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'activecampaign-lists',
					"activecampaign_url": jQuery("#activecampaign_url").val(),
					"activecampaign_api_key": jQuery("#activecampaign_api_key").val(),
					"activecampaign_list_id": "{/literal}{$popup_options['activecampaign_list_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#activecampaign_status").html('ActiveCampaign connected.');
							active_activecampaign_url = jQuery("#activecampaign_url").val();
							active_activecampaign_api_key = jQuery("#activecampaign_api_key").val();
						} else {
							jQuery("#activecampaign_status").html('Connection Error.');
						}
					} catch(e) {
						jQuery("#activecampaign_status").html('Connection Error.'+e);
					}
				}
			);
		}
	}
	
	var gotowebinar_username = "";
	var gotowebinar_password = "";
	function gotowebinar_connect() {
		if (gotowebinar_username != jQuery("#gotowebinar_username").val()
			|| gotowebinar_password != jQuery("#gotowebinar_password").val()
		){
			jQuery("#gotowebinar_activate_loading").html('Connection...');
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'gotowebinar-connect',
					"password": jQuery("#gotowebinar_password").val(),
					"username": jQuery("#gotowebinar_username").val()
				},
				function(return_data) {
					var data;
					data={};
					try {
						data=jQuery.parseJSON(return_data);
					}catch(e){}
					try{
						if (typeof data.error_message == 'undefined' ) {
							jQuery("#gotowebinar_activate_loading").html('GoToWebinar connected.');
							jQuery("#gotowebinar_activation").attr('value',return_data);
						} else {
							if (typeof data.error_message !== 'undefined' ) {
								jQuery("#gotowebinar_activate_loading").html('Error: '+data.error_message);
							}else{
								jQuery("#gotowebinar_activate_loadingd").html('Connection Error.');
							}
						}
					} catch(e) {
						jQuery("#gotowebinar_activate_loading").html('Connection Error. '+e);
					}
				}
			);
		}
	}
	var active_interspire_url = "";
	var active_interspire_username = "";
	var active_interspire_token = "";
	var active_interspire_listid = "";
	function interspire_loadlist() {
		if (active_interspire_url != jQuery("#interspire_url").val() || active_interspire_username != jQuery("#interspire_username").val() || active_interspire_token != jQuery("#interspire_token").val()) {
			jQuery("#interspire_listid").html("<option>-- Loading Lists --</option>");
			jQuery("#interspire_listid").attr("disabled", "disabled");
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'interspire-lists',
					"interspire_url": jQuery("#interspire_url").val(),
					"interspire_username": jQuery("#interspire_username").val(),
					"interspire_token": jQuery("#interspire_token").val(),
					"interspire_listid": "{/literal}{$popup_options['interspire_listid']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#interspire_listid").html(data.options);
							jQuery("#interspire_listid").removeAttr("disabled");
							active_interspire_url = jQuery("#interspire_url").val();
							active_interspire_username = jQuery("#interspire_username").val();
							active_interspire_token = jQuery("#interspire_token").val();
						} else jQuery("#interspire_listid").html("<option>-- Can not get Lists --</option>");
					} catch(e) {
						jQuery("#interspire_listid").html("<option>-- Can not get Lists --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
					interspire_loadfield();
				}
			);
		}
	}
	function interspire_loadfield() {
		if (active_interspire_url != jQuery("#interspire_url").val() || active_interspire_username != jQuery("#interspire_username").val() || active_interspire_token != jQuery("#interspire_token").val() || active_interspire_listid != jQuery("#interspire_listid").val()) {
			//jQuery("#interspire_nameid").html("<option>-- Loading Fields --</option>");
			//jQuery("#interspire_nameid").attr("disabled", "disabled");
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'interspire-fields',
					"interspire_url": jQuery("#interspire_url").val(),
					"interspire_username": jQuery("#interspire_username").val(),
					"interspire_token": jQuery("#interspire_token").val(),
					"interspire_listid": jQuery("#interspire_listid").val(),
					//"interspire_nameid": "{/literal}{$popup_options['interspire_nameid']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
						//	jQuery("#interspire_nameid").html(data.options);
						//	jQuery("#interspire_nameid").removeAttr("disabled");
							active_interspire_url = jQuery("#interspire_url").val();
							active_interspire_username = jQuery("#interspire_username").val();
							active_interspire_token = jQuery("#interspire_token").val();
							active_interspire_lsitid = jQuery("#interspire_listid").val();
						} //else jQuery("#interspire_nameid").html("<option>-- Can not get Fields --</option>");
					} catch(e) {
						//jQuery("#interspire_nameid").html("<option>-- Can not get Fields --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	icontact_check();
	getresponse_check();
	madmimi_loadlist();
	benchmark_loadlist();
	activecampaign_check();
	interspire_loadlist();
	
	
	
</script>
{/literal}


<br>
<br>
<br>
</body>
</html>