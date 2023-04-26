{literal}
<script type="text/javascript">
jQuery.noConflict();
var objAccordion = {};

window.addEvent('domready', function() {
	objAccordion = new myAccordion($('accordion'), $$('.toggler'), $$('.element'), { fixedHeight:false });
});

var myAccordion = new Class({
	Extends: Fx.Accordion,
	initialize: function(container, toggler, element, options){
		this.parent(container, toggler, element, options);
		this.initButton();
	}, 
	initButton:function(){
		this.prev = $$('a.acc_prev');
		this.next = $$('a.acc_next');		
		var obj = this;
		this.prev.each(function(el){
			el.removeEvents('click');
			el.addEvent('click',function(e){e.stop(); obj.display(obj.previous-1);   });
		});
		this.next.each(function(el){
			el.removeEvents('click');
			el.addEvent('click',function(e){e.stop(); obj.display(obj.previous+1);
			var myFx = new Fx.Scroll(document.body, {
    		offset: {
        		'x': 0,
        		'y': 260
    			}
			}).toTop();
			});
		});
		jQuery('create_form').show();
	},
	add:function(){
		$('proprietary').style.display='block';
		$('toggler').addClass('toggler');
		$('toggler').getNext().addClass('element');
		this.addSection($('toggler'),$('toggler').getNext());
		$('toggler').getNext().addClass('initElement');
		$$('div.initElement').each(function(div,index){
			div.set('id',index);
		});
		this.initButton();
		this.clearEvent();
		this.initialize($('accordion'), $$('.toggler'), $$('.element'));
	},
	deleteSection:function(init){
		$('proprietary').style.display='none';
		$('toggler').removeClass('toggler');
		$('toggler').getNext().removeClass('element');
		$('toggler').getNext().removeClass('initElement');
		$$('div.initElement').each(function(div,index){
			div.set('id',index);
		});
		
		if( init ) {
			this.clearEvent();
			this.initialize($('accordion'), $$('.toggler'), $$('.element'));
		}
	},
	clearEvent:function(){
		$$('.toggler').each(function(el){
			el.removeEvents(this.trigger);
		});
	}
});
</script>
{/literal}
{if !empty($error_message)}
	{include file='../../message.tpl' type='error' message={$error_message}}
{elseif !empty($ok_message)}
	{include file='../../message.tpl' type='success' message={$ok_message}}
{/if}
<form class="ulp-popup-form" enctype="multipart/form-data" method="post" style="margin: 0px" action="">
	<div class="panel-group" id="accordion-test-2"> 
        <div class="panel panel-default"> 
            <div class="panel-heading"> 
                <h4 class="panel-title"> 
                    <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">AWeber Connection</a> 
                </h4> 
            </div> 
            <div id="collapseOne-2" class="panel-collapse collapse in"> 
                <div class="panel-body">
                	<fieldset>
						{if !$account}
						<div class="form-group">
							<label>Authorization code: </label>
							<input type="text" id="ulp_aweber_oauth_id" value="" class="form-control" placeholder="AWeber authorization code">
							<small>Get your authorization code <a target="_blank" href="https://auth.aweber.com/1.0/oauth/authorize_app/{Project_Exquisite::$AWeberAppId}">here</a>.</small>
						</div>
						<div class="form-group">
							<label></label>
							<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return ulp_aweber_connect();" >Make Connection</button>
							<img id="ulp-aweber-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
						</div>
						{else}
							{if empty($aweber_account->lists)}
							<div class="form-group">
								<label class="label-control">Activate AWeber: </label>
								<br><small>This AWeber account does not currently have any lists.</small>
							</div>
							{else}
							<div class="form-group">
								<label>Activate AWeber: </label>
								<div class="checkbox checkbox-primary">
									<input type="checkbox" id="ulp_aweber_enable" name="ulp_aweber_enable" {if $options['aweber_enable'] == "on"}checked="checked"{/if} />
									<label>Submit contact details to AWeber</label>
								</div>
								<small>Please tick checkbox if you want to submit contact details to AWeber.</small>
							</div>
							<div class="form-group">
								<label>List ID: </label>
								<select name="ulp_aweber_listid" class="ic_input_m btn-group selectpicker show-tick">
									{foreach from=$aweber_account->lists item='list'}
									<option value="{$list->id}"{if $list->id == $options['aweber_listid']} selected="selected"{/if}>{$list->name}</option>
									{/foreach}
								</select>
								<br><small>Select your List ID.</small>
							</div>
							{/if}
							<div class="form-group">
								<label>Connected: </label>
								<input type="button" class="submit button" value="Disconnect" onclick="return ulp_aweber_disconnect();" >
								<img id="ulp-aweber-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
								<br><small>Click the button to disconnect.</small>
							</div>
						{/if}
						<div id="ulp-aweber-message"></div>
					</fieldset>
                </div> 
            </div> 
        </div>
        <div class="panel panel-default"> 
            <div class="panel-heading"> 
                <h4 class="panel-title"> 
                    <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" class="collapsed" aria-expanded="false">Miscellaneous</a> 
                </h4> 
            </div> 
            <div id="collapseTwo-2" class="panel-collapse collapse"> 
                <div class="panel-body">
                    <fieldset>
						<div class="form-group">
							<label>CSV column separator: </label>
							<select id="ulp_csv_separator" name="ulp_csv_separator" class="btn-group selectpicker show-tick">
								<option value=";"{if $options.csv_separator == ";"} selected="selected"{/if}>Semicolon - ";"</option>
								<option value=","{if $options.csv_separator == ","} selected="selected"{/if}>Comma - ","</option>
								<option value="tab"{if $options.csv_separator == "tab"} selected="selected"{/if}>Tab</option>
							</select>
							<br><small>Please select CSV column separator.</small>
						</div>
						<div class="form-group">
							<label>Single subscription: </label>
							<input type="hidden" name="ulp_onexit_limits" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_onexit_limits" name="ulp_onexit_limits" {if $options['onexit_limits'] == "on"} checked="checked"{/if}>
								<label>Disable all event popups if user subscribed through any popup or inline form</label>	
							</div>
							<small>Disable OnLoad/OnExit/OnScroll popup if user subscribed through any popup or inline form.</small>
						</div>
						<div class="form-group">
							<label>Extended e-mail validation: </label>
							<input type="hidden" name="ulp_email_validation" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_email_validation" name="ulp_email_validation" {if $options.email_validation ==  "on"} checked="checked"{/if}>
								<label>Enable extended e-mail address validation</label>	
							</div>
							 
							<small>If you turn this option on, the plugin will check MX records according to the host provided within the email address. PHP 5 >= 5.3 required!</small>
						</div>
						<div class="form-group">
							<label>Google Analytics tracking: </label>
							<input type="hidden" name="ulp_ga_tracking" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_ga_tracking" name="ulp_ga_tracking" {if $options.ga_tracking ==  "on"} checked="checked"{/if} >
								<label>Enable Google Analytics tracking</label>	
							</div>
							<small>Send popup events to Google Analytics. Google Analytics must be installed on your website.</small>
						</div>
						<div class="form-group">
							<label>Font Awesome icons: </label>
							<input type="hidden" name="ulp_fa_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_fa_enable" name="ulp_fa_enable" {if $options.fa_enable ==  "on"} checked="checked"{/if} >
								<label>Enable Font Awesome icons</label>	
							</div>
							 
							<small>Enable Font Awesome icons.</small>
						</div>
					</fieldset>
                </div> 
            </div> 
        </div> 
        <div class="panel panel-default"> 
            <div class="panel-heading"> 
                <h4 class="panel-title"> 
                    <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseThree-2" class="collapsed" aria-expanded="false">Social Media API Settings <span class="ulp-badge ulp-badge-beta">Beta</span></a> 
                </h4> 
            </div> 
            <div id="collapseThree-2" class="panel-collapse collapse"> 
                <div class="panel-body">
					<fieldset>
						<div class="form-group">
							<label>Facebook App ID: </label>
							<input type="text" class="form-control" id="ulp_social2_facebook_appid" name="ulp_social2_facebook_appid" value="{$options['social2_facebook_appid']}">
							<br><small>Enter Facebook App ID.</small>
						</div>
						<div class="form-group">
							If you want to use "Subscribe with Facebook" button, you must create Facebook App connected with your website.
							<br/>If you already have such App, please skip step 1 and start reading from step 2.
							<ol>
								<li>
									Go to <a href="https://developers.facebook.com/apps/" target="_blank">Facebook Apps</a> and create new application.
									Please watch the video below. It explains what settings are required for your application.<br />
									<iframe width="640" height="360" src="//www.youtube.com/embed/bIRPR_1ENKY?rel=0" frameborder="0" allowfullscreen></iframe>
								</li>
							</ol>
						</div>
						<div class="form-group">
							<label>Google Client ID: </label>
							<input type="text" class="form-control" id="ulp_social2_google_clientid" name="ulp_social2_google_clientid" value="{$options['social2_google_clientid']}">
							<br><small>Enter Google Client ID.</small>
						</div>
						<div class="form-group">
							<label>Google API Key: </label>
							<input type="text" class="form-control" id="ulp_social2_google_apikey" name="ulp_social2_google_apikey" value="{$options['social2_google_apikey']}">
							<br><small>Enter Google API Key.</small>
						</div>
						<div class="form-group">
							If you want to use "Subscribe with Google" button, you must create Google Project connected with your website.
							<br/>If you already have such Project, please skip step 1 and start reading from step 2.
							<ol>
								<li>
									Go to <a href="https://console.developers.google.com/project?authuser=0" target="_blank">Google Developers Console</a> and create new project.
									Please watch the video below. It explains what settings are required for your project.<br />
									<iframe width="640" height="360" src="//www.youtube.com/embed/nP95OffQD0M?rel=0" frameborder="0" allowfullscreen></iframe>
								</li>
							</ol>
						</div>
					</fieldset>
                </div> 
            </div> 
        </div> 
        <div class="panel panel-default"> 
            <div class="panel-heading"> 
                <h4 class="panel-title"> 
                    <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFour-2" class="collapsed" aria-expanded="false">Autoresponder Parameters</a> 
                </h4> 
            </div> 
            <div id="collapseFour-2" class="panel-collapse collapse"> 
                <div class="panel-body">
                	<fieldset>
						<p><small>The parameters below are used for subscription/contact form only. Please read FAQ section about adding subscription/contact form into layers.</small></p>
						
						<div class="form-group">
							<label>Activate MailChimp: </label>
							<input type="hidden" name="ulp_mailchimp_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_mailchimp_enable" name="ulp_mailchimp_enable" {if $options['mailchimp_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to MailChimp</label>
							</div>
							<small>Please tick checkbox if you want to submit contact details to MailChimp.</small>
						</div>
						<div class="form-group">
							<label>MailChimp API Key: </label>
							<input type="text" id="ulp_mailchimp_api_key" name="ulp_mailchimp_api_key" value="{$options['mailchimp_api_key']}" class="form-control">
							<br><small>Enter your MailChimp API Key. You can get it <a href="https://admin.mailchimp.com/account/api-key-popup" target="_blank">here</a>.</small>
						</div>
						
						<div class="form-group">
							<label>Activate iContact: </label>
							<input type="hidden" name="ulp_icontact_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_icontact_enable" name="ulp_icontact_enable" {if $options['icontact_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to iContact</label>
							</div>
							 <small>Please tick checkbox if you want to submit contact details to iContact.</small>
						</div>
						<div class="form-group">
							<label>AppID: </label>
							<input type="text" id="ulp_icontact_appid" name="ulp_icontact_appid" value="{$options['icontact_appid']}" class="form-control" onblur="icontact_loadlist();">
							<small>Obtained when you <a href="http://developer.icontact.com/documentation/register-your-app/" target="_blank">Register the API application</a>. This identifier is used to uniquely identify your application.</small>
						</div>
						<div class="form-group">
							<label>API Username: </label>
							<input type="text" id="ulp_icontact_apiusername" name="ulp_icontact_apiusername" value="{$options['icontact_apiusername']}" class="form-control" onblur="icontact_loadlist();">
							<br><small>The iContact username for logging into your iContact account.</small>
						</div>
						<div class="form-group">
							<label>API Password: </label>
							<input type="text" id="ulp_icontact_apipassword" name="ulp_icontact_apipassword" value="{$options['icontact_apipassword']}" class="form-control" onblur="icontact_loadlist();">
							<small>The API application password set when the application was registered. This API password is used as input when your application authenticates to the API. This password is not the same as the password you use to log in to iContact.</small>
						</div>
						<div class="form-group">
							<small id="ulp_icontact_status"></small>
						</div>
						
						<div class="form-group">
							<label>Activate GetResponse: </label>
							<input type="hidden" name="ulp_getresponse_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_getresponse_enable" name="ulp_getresponse_enable" {if $options['getresponse_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to GetResponse</label>	
							</div>
							<br><small>Please tick checkbox if you want to submit contact details to GetResponse.</small>
						</div>
						<div class="form-group">
							<label>API Key: </label>
							<input type="text" id="ulp_getresponse_api_key" name="ulp_getresponse_api_key" value="{$options['getresponse_api_key']}" class="form-control" onblur="getresponse_loadlist();">
							<small>Enter your GetResponse API Key. You can get your API Key <a href="https://app.getresponse.com/my_api_key.html" target="_blank">here</a>.</small>
						</div>
						<div class="form-group">
							<small id="ulp_getresponse_status" ></small>
						</div>
						
						<div class="form-group">
							<label>Activate Campaign Monitor: </label>
							<input type="hidden" name="ulp_campaignmonitor_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_campaignmonitor_enable" name="ulp_campaignmonitor_enable" {if $options['campaignmonitor_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to Campaign Monitor</label>	
							</div>
							<small>Please tick checkbox if you want to submit contact details to Campaign Monitor.</small>
						</div>
						<div class="form-group">
							<label>API Key: </label>
							<input type="text" id="ulp_campaignmonitor_api_key" name="ulp_campaignmonitor_api_key" value="{$options['campaignmonitor_api_key']}" class="form-control">
							<small>Enter your Campaign Monitor API Key. You can get your API Key from the Account Settings page when logged into your Campaign Monitor account.</small>
						</div>
						
						<div class="form-group">
							<label>Activate Mad Mimi: </label>
							<input type="hidden" name="ulp_madmimi_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_madmimi_enable" name="ulp_madmimi_enable" {if $options['madmimi_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to Mad Mimi</label>	
							</div>
							<small>Please tick checkbox if you want to submit contact details to Mad Mimi.</small>
						</div>
						<div class="form-group">
							<label>Username/E-mail: </label>
							<input type="text" id="ulp_madmimi_login" name="ulp_madmimi_login" value="{$options['madmimi_login']}" class="form-control" onblur="madmimi_loadlist();">
							<small>The Mad Mimi username/e-mail for logging into your Mad Mimi account.</small>
						</div>
						<div class="form-group">
							<label>API Key: </label>
							<input type="text" id="ulp_madmimi_api_key" name="ulp_madmimi_api_key" value="{$options['madmimi_api_key']}" class="form-control" onblur="madmimi_loadlist();">
							<small>Enter your Mad Mimi API Key. You can get your API Key <a href="https://madmimi.com/user/edit?account_info_tabs=account_info_personal" target="_blank">here</a>.</small>
						</div>
						<div class="form-group">
							<small id="ulp_madmimi_status" ></small>
						</div>
						
						<div class="form-group">
							<label>Activate Sendy: </label>
							<input type="hidden" name="ulp_sendy_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_sendy_enable" name="ulp_sendy_enable" {if $options['sendy_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to Sendy</label>	
							</div>
							<small>Please tick checkbox if you want to submit contact details to Sendy.</small>
						</div>
						<div class="form-group">
							<label>Installation URL: </label>
							<input type="text" id="ulp_sendy_url" name="ulp_sendy_url" value="{$options['sendy_url']}" class="form-control">
							<br><small>Enter your Sendy installation URL (without the trailing slash).</small>
						</div>
						
						<div class="form-group">
							<label>Activate Benchmark: </label>
							<input type="hidden" name="ulp_benchmark_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_benchmark_enable" name="ulp_benchmark_enable"{if $options['benchmark_enable'] == "on"} checked="checked"{/if} />
								<label>Submit contact details to Benchmark Email</label>	
							</div>
							<small>Please tick checkbox if you want to submit contact details to Benchmark Email.</small>
						</div>
						<div class="form-group">
							<label>API Key: </label>
							<input type="text" id="ulp_benchmark_api_key" name="ulp_benchmark_api_key" value="{$options['benchmark_api_key']}" class="form-control" onblur="benchmark_loadlist();">
							<br><small>Enter your Benchmark Email API Key. You can get your API Key <a href="https://ui.benchmarkemail.com/EditSetting" target="_blank">here</a>.</small>
						</div>
						<div class="form-group">
							<small id="ulp_benchmark_status" ></small>
						</div>

						<div class="form-group">
							<label>Activate ActiveCampaign: </label>
							<input type="hidden" name="ulp_activecampaign_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_activecampaign_enable" name="ulp_activecampaign_enable" {if $options['activecampaign_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to ActiveCampaign</label>	
							</div>
							<small>Please tick checkbox if you want to submit contact details to ActiveCampaign.</small>
						</div>
						<div class="form-group">
							<label>API URL: </label>
							<input type="text" id="ulp_activecampaign_url" name="ulp_activecampaign_url" value="{$options['activecampaign_url']}" class="form-control" onblur="activecampaign_loadlist();">
							<small>Enter your ActiveCampaign API URL. To get API URL please go to your ActiveCampaign Account >> Integration >> ActiveCampaign API.</small>
						</div>
						<div class="form-group">
							<label>API Key: </label>
							<input type="text" id="ulp_activecampaign_api_key" name="ulp_activecampaign_api_key" value="{$options['activecampaign_api_key']}" class="form-control" onblur="activecampaign_loadlist();">
							<small>Enter your ActiveCampaign API Key. To get API Key please go to your ActiveCampaign Account >> Integration >> ActiveCampaign API.</small>
						</div>
						<div class="form-group">
							<small id="ulp_activecampaign_status" ></small>
						</div>
						
						<div class="form-group">
							<label>Activate Interspire: </label>
							<input type="hidden" name="ulp_interspire_enable" value="off">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="ulp_interspire_enable" name="ulp_interspire_enable" {if $options['interspire_enable'] == "on"}checked="checked"{/if} />
								<label>Submit contact details to Interspire</label>	
							</div>
							<small>Please tick checkbox if you want to submit contact details to Interspire.</small>
						</div>
						<div class="form-group">
							<label>XML Path: </label>
							<input type="text" id="ulp_interspire_url" name="ulp_interspire_url" value="{$options['interspire_url']}" class="form-control" onblur="interspire_loadlist();">
							<small>Enter your Interspire XML Path. You can find it in Advanced User Settings.</small>
						</div>
						<div class="form-group">
							<label>XML Username: </label>
							<input type="text" id="ulp_interspire_username" name="ulp_interspire_username" value="{$options['interspire_username']}" class="form-control" onblur="interspire_loadlist();">
							<small>Enter your Interspire XML Username. You can find it in Advanced User Settings.</small>
						</div>
						<div class="form-group">
							<label>XML Token: </label>
							<input type="text" id="ulp_interspire_token" name="ulp_interspire_token" value="{$options['interspire_token']}" class="form-control" onblur="interspire_loadlist();">
							<small>Enter your Interspire XML Token. You can find it in Advanced User Settings.</small>
						</div>
						<div class="form-group">
							<small id="ulp_interspire_status" ></small>
						</div>

					</fieldset>
                </div> 
            </div> 
        </div> 
    </div>
    <div class="from-group">
    	<div style="text-align: right; margin-bottom: 5px; margin-top: 20px;">
			<input type="hidden" name="action" value="save-settings" />
			<img class="ulp-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
			<button type="submit" class="submit btn btn-success waves-effect waves-light" name="submit" onclick="return ulp_save_settings();">Save Settings</button>
		</div>
		<div class="ulp-message"></div>
    </div>
</form>
<script type="text/javascript">{literal}
	function ulp_aweber_connect() {
		jQuery("#ulp-aweber-loading").fadeIn(350);
		jQuery("#ulp-aweber-message").slideUp(350);
		var data = {action: "aweber-connect", "aweber-oauth-id": jQuery("#ulp_aweber_oauth_id").val()};
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', data, function(return_data) {
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
					jQuery("#ulp-aweber-message").html("Service for connect aweber is not available.");
					jQuery("#ulp-aweber-message").slideDown(350);
				}
			} catch(error) {
				jQuery("#ulp-aweber-message").html("Service for connect aweber is not available. Error: "+error);
				jQuery("#ulp-aweber-message").slideDown(350);
			}
		});
		return false;
	}
	function ulp_aweber_disconnect() {
		jQuery("#ulp-aweber-loading").fadeIn(350);
		jQuery("#ulp-aweber-message").slideUp(350);
		var data = {action: "aweber-disconnect"};
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', data, function(return_data) {
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
	function ulp_save_settings() {
		jQuery(".ulp-popup-form").find(".ulp-loading").fadeIn(350);
		jQuery(".ulp-popup-form").find(".ulp-message").slideUp(350);
		jQuery(".ulp-popup-form").find(".ulp-button").attr("disabled", "disabled");
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', 
			jQuery(".ulp-popup-form").serialize(),
			function(return_data) {
				//alert(return_data);
				jQuery(".ulp-popup-form").find(".ulp-loading").fadeOut(350);
				jQuery(".ulp-popup-form").find(".ulp-button").removeAttr("disabled");
				var data;
				try {
					var data = jQuery.parseJSON(return_data);
					var status = data.status;
					if (status == "OK") {
						location.href = data.return_url;
					} else if (status == "ERROR") {
						jQuery(".ulp-popup-form").find(".ulp-message").html(data.message);
						jQuery(".ulp-popup-form").find(".ulp-message").slideDown(350);
					} else {
						jQuery(".ulp-popup-form").find(".ulp-message").html("Service for save settings is not available.");
						jQuery(".ulp-popup-form").find(".ulp-message").slideDown(350);
					}
				} catch(error) {
					jQuery(".ulp-popup-form").find(".ulp-message").html("Service for save settings is not available. Error: "+error);
					jQuery(".ulp-popup-form").find(".ulp-message").slideDown(350);
				}
			}
		);
		return false;
	}
	var active_icontact_appid = "";
	var active_icontact_apiusername = "";
	var active_icontact_apipassword = "";
	function icontact_loadlist() {
		if (active_icontact_appid != jQuery("#ulp_icontact_appid").val() || 
			active_icontact_apiusername != jQuery("#ulp_icontact_apiusername").val() ||
			active_icontact_apipassword != jQuery("#ulp_icontact_apipassword").val()) {
			jQuery("#ulp_icontact_status").html("Connection...");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
					"action": 'icontact-lists',
					"icontact_appid": jQuery("#ulp_icontact_appid").val(),
					"icontact_apiusername": jQuery("#ulp_icontact_apiusername").val(),
					"icontact_apipassword": jQuery("#ulp_icontact_apipassword").val(),
					"icontact_listid": "{/literal}{$popup_options['icontact_listid']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#ulp_icontact_status").html("Account Linked Successfully.");
							active_icontact_appid = jQuery("#ulp_icontact_appid").val();
							active_icontact_apiusername = jQuery("#ulp_icontact_apiusername").val();
							active_icontact_apipassword = jQuery("#ulp_icontact_apipassword").val();
						} else jQuery("#ulp_icontact_status").html("Account Linked Failed.");
					} catch(e) {
						jQuery("#ulp_icontact_status").html("Account Linked Failed.");
					}
				}
			);
		}
	}
	var active_getresponse_api_key = "";
	function getresponse_loadlist() {
		if (active_getresponse_api_key != jQuery("#ulp_getresponse_api_key").val()) {
			jQuery("#ulp_getresponse_status").html("Connection...");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
					"action": 'getresponse-campaigns',
					"getresponse_api_key": jQuery("#ulp_getresponse_api_key").val(),
					"getresponse_campaign_id": "{/literal}{$popup_options['getresponse_campaign_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#ulp_getresponse_status").html("Account Linked Successfully.");
							active_getresponse_api_key = jQuery("#ulp_getresponse_api_key").val();
						} else jQuery("#ulp_getresponse_status").html("Account Linked Failed.");
					} catch(e) {
						jQuery("#ulp_getresponse_status").html("Account Linked Failed.");
					}
				}
			);
		}
	}
	var active_madmimi_login = "";
	var active_madmimi_api_key = "";
	function madmimi_loadlist() {
		if (active_madmimi_login != jQuery("#ulp_madmimi_login").val() || active_madmimi_api_key != jQuery("#ulp_madmimi_api_key").val()) {
			jQuery("#ulp_madmimi_status").html("Connection...");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
					"action": 'madmimi-lists',
					"madmimi_login": jQuery("#ulp_madmimi_login").val(),
					"madmimi_api_key": jQuery("#ulp_madmimi_api_key").val(),
					"madmimi_list_id": "{/literal}{$popup_options['madmimi_list_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#ulp_madmimi_status").html("Account Linked Successfully.");
							active_madmimi_api_key = jQuery("#ulp_madmimi_api_key").val();
						} else jQuery("#ulp_madmimi_status").html("Account Linked Failed.");
					} catch(e) {
						jQuery("#ulp_madmimi_status").html("Account Linked Failed.");
					}
				}
			);
		}
	}
	var active_benchmark_api_key = "";
	function benchmark_loadlist() {
		if (active_benchmark_api_key != jQuery("#ulp_benchmark_api_key").val()) {
			jQuery("#ulp_benchmark_status").html("Connection...");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
					"action": 'benchmark-lists',
					"benchmark_api_key": jQuery("#ulp_benchmark_api_key").val(),
					"benchmark_list_id": "{/literal}{$popup_options['benchmark_list_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#ulp_benchmark_status").html("Account Linked Successfully.");
							active_benchmark_api_key = jQuery("#ulp_benchmark_api_key").val();
						} else jQuery("#ulp_benchmark_status").html("Account Linked Failed.");
					} catch(e) {
						jQuery("#ulp_benchmark_status").html("Account Linked Failed.");
					}
				}
			);
		}
	}
	var active_activecampaign_url = "";
	var active_activecampaign_api_key = "";
	function activecampaign_loadlist() {
		if (active_activecampaign_api_key != jQuery("#ulp_activecampaign_api_key").val() || active_activecampaign_url != jQuery("#ulp_activecampaign_url").val()) {
			jQuery("#ulp_activecampaign_status").html("Connection...");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
					"action": 'activecampaign-lists',
					"activecampaign_url": jQuery("#ulp_activecampaign_url").val(),
					"activecampaign_api_key": jQuery("#ulp_activecampaign_api_key").val(),
					"activecampaign_list_id": "{/literal}{$popup_options['activecampaign_list_id']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#ulp_activecampaign_status").html("Account Linked Successfully.");
							active_activecampaign_url = jQuery("#ulp_activecampaign_url").val();
							active_activecampaign_api_key = jQuery("#ulp_activecampaign_api_key").val();
						} else jQuery("#ulp_activecampaign_status").html("Account Linked Failed.");
					} catch(e) {
						jQuery("#ulp_activecampaign_status").html("Account Linked Failed.");
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
		if (active_interspire_url != jQuery("#ulp_interspire_url").val() || active_interspire_username != jQuery("#ulp_interspire_username").val() || active_interspire_token != jQuery("#ulp_interspire_token").val()) {
			jQuery("#ulp_interspire_status").html("Connection...");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
					"action": 'interspire-lists',
					"interspire_url": jQuery("#ulp_interspire_url").val(),
					"interspire_username": jQuery("#ulp_interspire_username").val(),
					"interspire_token": jQuery("#ulp_interspire_token").val(),
					"interspire_listid": "{/literal}{$popup_options['interspire_listid']}{literal}"
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#ulp_interspire_status").html("Account Linked Successfully.");
							active_interspire_url = jQuery("#ulp_interspire_url").val();
							active_interspire_username = jQuery("#ulp_interspire_username").val();
							active_interspire_token = jQuery("#ulp_interspire_token").val();
						} else jQuery("#ulp_interspire_status").html("Account Linked Failed.");
					} catch(e) {
						jQuery("#ulp_interspire_status").html("Account Linked Failed.");
					}
				}
			);
		}
	}
	icontact_loadlist();
	getresponse_loadlist();
	madmimi_loadlist();
	benchmark_loadlist();
	activecampaign_loadlist();
	interspire_loadlist();
{/literal}</script>