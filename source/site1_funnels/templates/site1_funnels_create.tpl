<link rel="stylesheet" type="text/css" href="/skin/light/css/card.css" />
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
{literal}<style type="text/css">.display-block{display: block!important;}</style>{/literal}

{literal}<style type="text/css">.a8r_new_element{display: none!important;}</style>{/literal}
<div class="card-box">
	<form action="" method="post">
		<input type="hidden" name="id" value="{$arrData.id}">
		<input type="hidden" name="arrData[settings][url]" value="{$arrData.url}">
		<p>Note: click Select Funnel button below to review the available offers and select one to proceed.</p>
        <div class="form-group">
        	<a href="{url name='site1_funnels' action='popup_templates'}" class="btn btn-default waves-effect waves-light popup_mb">Select Funnel</a>
        </div>

		<div class="row">
	        <div class="col-md-3">
	        	<div class="card m-b-20" data-template {if empty($arrTpl.settings.template_hash)}style="display:none;"{/if} data-debug="{$arrTpl.settings.template_hash}">
	                <img class="card-img-top img-fluid img-responsive" src="{if !isset($arrTpl.settings.template_hash) || empty($arrTpl.settings.template_hash)}#{else}{Zend_Registry::get( 'config' )->domain->url}{Zend_Registry::get('config')->path->html->user_files}squeeze/templates/{$arrTpl.settings.template_hash}.jpg{/if}">
	                <div class="card-body">
	                    <p class="card-text">{if !isset($arrTpl.settings.template_description) || empty($arrTpl.settings.template_description)}&nbsp;{else}{$arrTpl.settings.template_description}{/if}</p>
	                </div>
	            </div>
	        </div>
		</div>

		<div id="gdpr-block"{if $arrMoOptin.settings.type != 'optin'} style="display: none"{/if}>
			<div class="form-group">
				<input type="hidden" name="arrData[settings][form][flg_gdpr]" value="0" />
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arrData[settings][form][flg_gdpr]" value="1" id="flg_gdpr"{if $arrMoOptin.settings.form.flg_gdpr} checked=""{/if} />
					<label for="flg_gdpr">Enable GDPR Consent</label>
				</div>
			</div>
			<div class="form-group gdpr" {if !$arrMoOptin.settings.form.flg_gdpr}style="display: none"{/if}>
				<textarea name="arrData[settings][form][gdpr]" id="gdpr">{if empty($arrMoOptin.settings.form.gdpr)}I agree to the OnlineNewsletters.net <a target="_blank" href="https://onlinenewsletters.net/terms.php">Terms of service</a> and <a target="_blank" href="https://onlinenewsletters.net/privacy.php">Privacy policy</a>.{else}{$arrMoOptin.settings.form.gdpr}{/if}</textarea>
			</div>
		</div>
		
        <div class="clearfix"></div>
		
		<input type="hidden" name="arrData[settings][funnel_tpl]" id="template_id" value="{if isset($arrData.settings.funnel_tpl) && !empty($arrData.settings.funnel_tpl)}{$arrData.settings.funnel_tpl}{/if}" />
		<input type="hidden" name="arrData[settings][flg_messenger]" id="flg_messenger" value="{if $arrData.settings.type_page=='3'}1{/if}" />
		<input type="hidden" name="arrData[settings][flg_redirect]" id="flg_redirect" value="{if $arrData.settings.type_page=='1'}1{/if}" />
		<input type="hidden" name="arrData[settings][flg_optin]" id="flg_optin" value="{if $arrData.settings.type_page=='2'}1{/if}" />
		
		<input type="hidden" name="arrData[settings][publishing_options]" value="{if isset( $arrData.settings.publishing_options ) && !empty( $arrData.settings.publishing_options ) }{$arrData.settings.publishing_options}{/if}">
		<input type="hidden" name="arrData[ftp_directory]" value="{if isset( $arrData.settings.ftp_directory ) && !empty( $arrData.settings.ftp_directory ) }{$arrData.settings.ftp_directory}{/if}" />
		
        <div class="form-group" id="additional_link_box" {if !isset($arrData.tpl_settings.affiliate_link) || empty($arrData.tpl_settings.affiliate_link)}style="display:none;"{/if}>
        	<div class="form-group">
				<a href="{if !isset($arrData.tpl_settings.affiliate_link) || empty($arrData.tpl_settings.affiliate_link)}#{else}{$arrData.tpl_settings.affiliate_link}{/if}" target="_blank" id="additional_link" >Request Approval &amp; Get Your Affiliate Link Here</a>
			</div>
        </div>
		
        <div id="additional_info" {if !isset($arrData.tpl_settings.info) || empty($arrData.tpl_settings.info)}style="display:none;"{/if}>
				<div class="form-group">
					<label>Additional Information</label>
					<p id="set_additional_info">{if !isset($arrData.tpl_settings.info) || empty($arrData.tpl_settings.info)}&nbsp;{else}{$arrData.tpl_settings.info}{/if}</p>
				</div>
        </div>

		<div class="form-group" id="show_tags" {if !isset($arrData.id) || empty($arrData.id)}style="display:none;"{/if}>
			<input type="text" name="arrData[tags]" class="form-control" id="str_tags" value="{$arrData.tags}" />
			<p>Please add your tags, separated by comma, that will be help you differentiate your subscribers</p>
		</div>
		{if Core_Acs::haveAccess( array( 'email test group', 'Validate' ) )}
		<div class="form-group" id="validation_realtime" {if !isset($arrData.id) || empty($arrData.id)}style="display:none;"{/if}>
			<div class="checkbox checkbox-primary">
				<input type="hidden" name="arrData[settings][validation_realtime]" value="0" />
				<input type="checkbox" name="arrData[settings][validation_realtime]" value="1" id="validation_realtime_cb" data-check="{$arrData.settings.validation_realtime}" {if Project_Validations_Realtime::check( Core_Users::$info['id'], Project_Validations_Realtime::FUNNEL, $arrData.id )} checked{/if} />
				<label for="validation_realtime_cb">Enable Real Time Email Validation</label>
			</div>
		</div>
		{/if}
        <div class="form-group" data-block="optin" {if !isset($arrData.settings.type_page) || $arrData.settings.type_page!='2'}style="display:none;"{/if}>
			<label>Where Should We Send The Leads To:</label>
			<select name="arrData[settings][integrations][]" id="mo_optin_integrations" multiple size="3" class="btn-group selectpicker show-tick" data-options="{$b64data}">
				<option id="integrations_local" value="local" selected="selected" >Store Locally</option>
				{if Core_Acs::haveAccess( array( 'Email Funnels', 'Email Funnels Performance' ) )}
				<option class="integrations_other" value="emailfunnels"{if isset($arrMoOptin.settings.integrations) && in_array( 'emailfunnels', $arrMoOptin.settings.integrations )} selected="selected"{/if} data-options='{base64_encode('{"newFields":[{"name":"email"}],"integration":"emailfunnels"}')}'>Email Funnels</option>
				{/if}
				{foreach from=$arList key=i item=data}
				<option class="integrations_other" value="{$data.id}" data-options="{$data.b64opt}" {if isset($arrMoOptin.settings.integrations) && in_array( $data.id, $arrMoOptin.settings.integrations )} selected="selected"{/if}>{$data.name}</option>
				{/foreach}
			</select>
			<br/><a href="#" class="move_to_redirect">(no thanks, I don't want to build a list right now, I just want a Click-through page)</a>
			{*============================================*}
			{*html*}
			<div id="mo_type_html" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">HTML</label>
				</div>
				<div class="a8r_new_element" rel="html">
					<span></span>
					<a href="#new-element" class="add_A8r_Field hidden" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>

			{*webhook*}
			<div id="mo_type_webhook" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">Webhook</label>
				</div>
				<div class="a8r_new_element" rel="webhook">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>

			{*emailfunnels*}
			<div id="mo_type_emailfunnels" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">Email Funnels</label>
				</div>
				<div class="form-group">
					<label>Email Funnels: </label>
					<select data-name="arrData[settings][options][email_funnel_id]" class="ic_input_m btn-group show-tick"></select>
					<br><small>Select your Email Funnel.</small>
				</div>
				<div class="a8r_new_element" rel="emailfunnels">
					<a href="#new-element" class="add_A8r_Field hidden" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			
			{*gotowebinar*}
			<div id="mo_type_gotowebinar" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">GoTo Webinar</label>
				</div>
				<div class="form-group">
					<label>Webinar: </label>
					<select data-name="arrData[settings][options][gotowebinar_webinar_id]" class="ic_input_m btn-group show-tick"></select>
					<br><small>Select your Webinar.</small>
				</div>
				<div class="a8r_new_element" rel="gotowebinar">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			
			{*ontraport*}
			<div id="mo_type_ontraport" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">Ontraport</label>
				</div>
				<div class="form-group">
					<label>Contact Tags: </label>
					<select data-name="arrData[settings][options][ontraport_contact_cat]" class="ic_input_m btn-group show-tick" multiple></select>
					<br><small>Select your Contact Tags.</small>
					<br>Not seeing your tag here:
					<button class="btn btn-success btn-rounded waves-effect waves-light" type="button" id="check_tags">Load more</button>
				</div>
				<div class="form-group">
					<label>Sequences: </label>
					<select data-name="arrData[settings][options][ontraport_sequence]" class="ic_input_m btn-group show-tick" multiple></select>
					<br><small>Select your Sequences.</small>
				</div>
				<div class="a8r_new_element" rel="ontraport">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			{*mailchimp*}
			<div id="mo_type_mailchimp" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">MailChimp</label>
				</div>
				<div class="form-group" id="mailchimp_show_lists">
					<label>List: </label>
					<select data-name="arrData[settings][options][mailchimp_list_id]" class="ic_input_m btn-group show-tick"></select>
					<br><small>Select your List.</small>
				</div>
				<div class="a8r_new_element" rel="mailchimp">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			
			{*everwebinar*}
			<div id="mo_type_everwebinar" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">EverWebinar</label>
				</div>
				<div class="form-group">
					<label>Webinar: </label>
					<select data-name="arrData[settings][options][everwebinar_webinar_id]" class="btn-group show-tick"></select>
				</div>
				<div class="a8r_new_element" rel="everwebinar">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			
			{*webinarjam*}
			<div id="mo_type_webinarjam" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">WebinarJam</label>
				</div>
				<div class="form-group">
					<label>Webinar: </label>
					<select data-name="arrData[settings][options][webinarjam_webinar_id]" class="btn-group show-tick"></select>
				</div>
				<div class="a8r_new_element" rel="webinarjam">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>

			{*convertkit*}
			<div id="mo_type_convertkit" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">ConvertKit</label>
				</div>
				<div class="form-group">
					<label>Sequence: </label>
					<select data-name="arrData[settings][options][convertkit_webinar_id]" class="btn-group show-tick"></select>
				</div>
				<div class="a8r_new_element" rel="convertkit">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>

			{*perkzilla*}
			<div id="mo_type_perkzilla" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">PerkZilla</label>
				</div>
				<div class="form-group">
					<label>Campaign ID: </label>
					<select data-name="arrData[settings][options][perkzilla_campaign_id]" class="btn-group show-tick"></select>
					<br><small>Select your Campaign ID.</small>
				</div>
				<div class="a8r_new_element" rel="perkzilla">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>

			{*getresponse*}
			<div id="mo_type_getresponse" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">GetResponse</label>
				</div>
				<div class="form-group">
					<label>Campaign ID: </label>
					<select data-name="arrData[settings][options][getresponse_campaign_id]" class="btn-group show-tick"></select>
					<br><small>Select your Campaign ID.</small>
				</div>
				<div class="a8r_new_element" rel="getresponse">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			
			{*activecampaign*}
			<div id="mo_type_activecampaign" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">ActiveCampaign</label>
				</div>
				
				<div class="form-group">
					<label>List ID: </label>
					<select data-name="arrData[settings][options][activecampaign_list_id]" class="btn-group show-tick"></select>
					<br><small>Select desired list.</small>
				</div>
				<div class="a8r_new_element" rel="activecampaign">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			{*aweber*}
			<div id="mo_type_aweber" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">AWeber </label>
				</div>
				<div class="form-group" id="aweber_show_lists">
					<label>List ID: </label>
					<select data-name="arrData[settings][options][aweber_listid]" class="ic_input_m btn-group show-tick"></select>
					<br><small>Select your List ID.</small>
				</div>
				<div class="a8r_new_element" rel="aweber">
					<a href="#new-element" class="add_A8r_Field" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
						<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
					</a>
				</div>
			</div>
			{*============================================*}
		</div>
		
		<div class="form-group" data-block="optin" {if !isset($arrData.settings.type_page) || $arrData.settings.type_page!='2'}style="display:none;"{/if}>
			<label class="col-2 col-form-label">Confirm or Edit Your Affiliate Link</label>
        	<div class="col-10">
                <input type="text" name="arrData[settings][affiliate_link_after_optin]" class="form-control" value="{if isset($arrData.settings.optinButtonActionURL)}{$arrData.settings.optinButtonActionURL}{/if}">
            </div>
		</div>
		
		<div class="form-group" data-block="redirect" {if !isset($arrData.settings.type_page) || $arrData.settings.type_page!='1'}style="display:none;"{/if}>
			<a href="#" class="move_to_optin">(Click Here it you want to turn this Click-through page into an optin funnel)</a>
		</div>
		
		<div class="form-group" data-block="redirect" {if !isset($arrData.settings.type_page) || $arrData.settings.type_page!='1'}style="display:none;"{/if}>
			<label class="col-2 col-form-label">Confirm or Edit Your Affiliate Link</label>
        	<div class="col-10">
                <input type="text" name="arrData[settings][affiliate_link]" class="form-control display-block" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Your affiliate link is already embedded, but you can edit it if you wish, or use a different link" value="{if isset($arrData.settings.link_url)}{$arrData.settings.link_url}{/if}">
            </div>
		</div>
		
		<div class="form-group" data-block="messenger" {if !isset($arrData.settings.type_page) || $arrData.settings.type_page!='3'}style="display:none;"{/if}>
			<label class="col-2 col-form-label">Messenger Page Username</label>
        	<div class="col-10">
                <input type="text" name="arrData[settings][user_name]" class="form-control" value="{if isset($arrData.settings.facebook_username)}{$arrData.settings.facebook_username}{/if}" />
            </div>
		</div>

		<div class="form-group">
			<div class="checkbox checkbox-custom">
				<input type="hidden" name="arrData[settings][flg_powered]" value="0" />
				<input id="show_powered" type="checkbox" name="arrData[settings][flg_powered]" {if !isset($arrData.settings.flg_powered) || $arrData.settings.flg_powered=='1'}checked{/if} value="1" />
				<label for="show_powered">Show «Powered by AffiliateFunnels.io» Link</label>
				<p>Note: it will carry your Affiliate Funnels affiliate link</p>
			</div>
		</div>

		<div class="form-group">
			<button class="btn btn-success waves-effect waves-light" id="save"{if !isset( $arrData.id )} disabled{/if}>Get Funnel Link</button>
		</div>
		
		<div class="hidden">
			
			<textarea name="arrData[settings][optin_form]" id="autoresponder_form_data" class="form-control" style="height: 200px;width:100%;display:inline;float:left;margin-bottom: 20px;" >{if isset($arrData.settings.optin_form)}{$arrData.settings.optin_form}{else}<form>
		<input type="submit">
		</form>{/if}</textarea>

		<div style="height:auto;width:100%;overflow:inherit;display:inline;float:left;padding:0 5px;" id="form_new_element">
			{if isset( $arrMoOptin.settings.form )}
				{if isset( $arrMoOptin.settings.form.add )}
					{foreach from=$arrMoOptin.settings.form.add item=attr key=hashcode}
						<input type="hidden" class="edit_form_value" data-json='{json_encode($attr)}'>
					{/foreach}
				{/if}
			{/if}
			<a href="#new-element" id="add_form_new_element" title="Add New Form Element" style="float: left;">
				<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> Add New Field
			</a>
		</div>
		
			<input type="checkbox" name="arrData[settings][flg_conformation]" class="form-control" id="flg_conformation_trigger" {if $arrMoOptin.settings.flg_conformation}checked{/if} value="1"/>
			
			<input type="radio" class="mo_optin_sms_confirmation" name="arrData[settings][sms_confirmation]" value="1"{if !isset( $arrMoOptin.settings.sms_confirmation ) || $arrMoOptin.settings.sms_confirmation == 1 } checked="checked"{/if} >
			<input type="radio" class="mo_optin_sms_confirmation" name="arrData[settings][sms_confirmation]" value="2"{if $arrMoOptin.settings.sms_confirmation == 2 } checked="checked"{/if} >

			
			<div style="height: 200px;width:450px;overflow:auto;display:inline;float:left;padding:0 5px;" id="autoresponder_form_settings">{if isset( $settings.form_autoresponder ) && !empty( $settings.form_autoresponder )}
			{foreach from=$settings.form_autoresponder key=elementId item=elementVaue}
				<input type="text" class="medium-input text-input" name="settings[form_autoresponder][{$elementId}]" value="{$elementVaue}" />
				<input type="hidden" name="settings[form_autoresponder_hide][{$elementId}]" value="0" checked />
				<input type="checkbox" name="settings[form_autoresponder_hide][{$elementId}]" value="1" {if isset($settings.form_autoresponder_hide[{$elementId}] ) && $settings.form_autoresponder_hide[{$elementId}] != 0}checked{/if} />&nbsp;Hide<br/>
			{/foreach}
		{else}&nbsp;{/if}</div>
	
		</div>
	</form>
</div>


{literal}
<script type="text/javascript">
	var urlRequest='{/literal}{url name="site1_mooptin" action="request"}{literal}';
	var urlGenerate='{/literal}{url name="site1_mooptin" action="create"}{literal}';

	function b64_d(str){
		return decodeURIComponent(Array.prototype.map.call(atob(str), function(c){
			return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
		}).join(''));
	}
	
	window.placeNewNumber=function( pnumber ){
		if( typeof country == undefined || typeof pnumber == undefined ){
			return;
		}
		jQuery('.selectpicker').selectpicker();
		$('mo_optin_sms_number_phone').adopt(
			new Element( 'option' ).set('value', pnumber).set('html', pnumber ).set('selected', true)
		);
		jQuery('.selectpicker').selectpicker('refresh');
	}

	window.placeAutoresponder=function( id, name ){
		if( typeof id == undefined || typeof name == undefined ){
			return;
		}
		jQuery('.selectpicker').selectpicker();
		$('mo_optin_integrations').adopt(
			new Element( 'option' ).set('value', id).set('html', name ).set('selected', true)
		);
		checkIntegrationCampaigns();
		jQuery('.selectpicker').selectpicker('refresh');
	}

	window.mooptinpopup=new CeraBox( $$('.popup'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}',
		fixedPosition: true
	});

	function mailchimp_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId != '' 
			&& typeof options.mailchimp_api_key != 'undefined' 
			&& options.mailchimp_api_key != null
			&& typeof options.mailchimp_user != 'undefined' 
			&& options.mailchimp_user != null
		){
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null 
				&& moData != false 
				&& typeof moData.options != 'undefined' 
				&& moData.options != null
				&& typeof moData.options.mailchimp_list_id != 'undefined' 
				&& moData.options.mailchimp_list_id != null
				&& typeof moData.options.mailchimp_list_id[a8rId]!='undefined'
				&& moData.options.mailchimp_list_id[a8rId]!=null
			){
				defaultListId=moData.options.mailchimp_list_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'mailchimp-loadlists',
					"mailchimp_api_key": options.mailchimp_api_key,
					"mailchimp_user": options.mailchimp_user
				},
				function(return_data){
					try {
						data = jQuery.parseJSON(return_data);
						if (data.status == "OK" ){
							var flgHaveLists=false;
							jQuery("#"+eltSelectId).empty();
							if( defaultListId=='' ){
								defaultListId=data.lists[0].id;
							}
							for (var listId=0; listId<data.lists.length; listId++){
						//	for (var listId in data.lists){
								var addElement=new Element( 'option' ).set('value',data.lists[listId].id).set('html', data.lists[listId].name );
								if( data.lists[listId].id == defaultListId ){
									addElement.selected=true;
								}
								$(eltSelectId).adopt( addElement );
								flgHaveLists=true;
							}
							mailchimp_loadfields( eltSelectId, options, defaultListId );
							$(eltSelectId).addEvent('change',function( events ){
								mailchimp_loadfields( eltSelectId, options, defaultListId );
							});
							if( !flgHaveLists ){
								jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
							}else{
								jQuery("#"+eltSelectId).removeAttr("disabled");
							}
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e){
						console.log( e );
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}

	function mailchimp_loadfields( eltSelectId='', options, listValue='' ){
		if (eltSelectId == '' || typeof options.mailchimp_api_key == 'undefined' || typeof options.mailchimp_user == 'undefined' || listValue=='' ){
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
				"action": 'mailchimp-loadfields',
				"mailchimp_api_key": options.mailchimp_api_key,
				"mailchimp_user": options.mailchimp_user,
				"mailchimp_list_id": listValue
			}, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ){
					var fieldsarray=['email_address', 'language'];
					for (var listId=0; listId<data.fields.length; listId++){
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error){
				console.log( error );
			}
		});
		return false;
	}
	
	function perkzilla_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId != '' && typeof options.perkzilla_api_key != 'undefined' ){
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null 
				&& moData != false 
				&& typeof moData.options != 'undefined' 
				&& moData.options != null
				&& typeof moData.options.perkzilla_campaign_id != 'undefined'
				&& moData.options.perkzilla_campaign_id != null
				&& typeof moData.options.perkzilla_campaign_id[a8rId]!='undefined'
				&& moData.options.perkzilla_campaign_id[a8rId]!=null
			){
				defaultListId=moData.options.perkzilla_campaign_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'perkzilla-campaigns',
					"perkzilla_api_key": options.perkzilla_api_key,
					"perkzilla_campaign_id": defaultListId
				},
				function(return_data){
					try {
						data = jQuery.parseJSON(return_data);
						if (data){
							jQuery("#"+eltSelectId).html(data.options);
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e){
						console.log(e);
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function getresponse_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId != '' && typeof options.getresponse_api_key != 'undefined' ){
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null 
				&& moData != false 
				&& typeof moData.options != 'undefined' 
				&& moData.options != null
				&& typeof moData.options.getresponse_campaign_id != 'undefined'
				&& moData.options.getresponse_campaign_id != null
				&& typeof moData.options.getresponse_campaign_id[a8rId]!='undefined'
				&& moData.options.getresponse_campaign_id[a8rId]!=null
			){
				defaultListId=moData.options.getresponse_campaign_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'getresponse-campaigns',
					"getresponse_api_key": options.getresponse_api_key,
					"getresponse_campaign_id": defaultListId
				},
				function(return_data){
					try {
						data = jQuery.parseJSON(return_data);
						if (data){
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								getresponse_loadfields( eltSelectId, options );
								$(eltSelectId).addEvent('change',function( events ){
									getresponse_loadfields( eltSelectId, options );
								});
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e){
						console.log(e);
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function everwebinar_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId != '' 
			&& typeof options.everwebinar_api_key != 'undefined'
			&& options.everwebinar_api_key != null
		){
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null 
				&& moData != false 
				&& typeof moData.options != 'undefined' 
				&& moData.options != null
				&& typeof moData.options.everwebinar_webinar_id != 'undefined' 
				&& moData.options.everwebinar_webinar_id != null
				&& typeof moData.options.everwebinar_webinar_id[a8rId]!='undefined' 
				&& moData.options.everwebinar_webinar_id[a8rId]!=null
			){
				defaultListId=moData.options.everwebinar_webinar_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'everwebinar-campaigns',
					"everwebinar_api_key": options.everwebinar_api_key,
					"everwebinar_webinar_id": defaultListId
				},
				function(return_data){
					try {
						data = jQuery.parseJSON(return_data);
						if (data){
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								var fieldsarray=[ 'first_name', 'last_name', 'email', 'phone' ];
								for (var listId in data.fields){
									fieldsarray.push( data.fields[listId] );
								}
								$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
								addDefaultFormElements();
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e){
						console.log(e);
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function webinarjam_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId != '' 
			&& typeof options.webinarjam_api_key != 'undefined'
			&& options.webinarjam_api_key != null
		){
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null 
				&& moData != false 
				&& typeof moData.options != 'undefined' 
				&& moData.options != null
				&& typeof moData.options.webinarjam_webinar_id != 'undefined' 
				&& moData.options.webinarjam_webinar_id != null
				&& typeof moData.options.webinarjam_webinar_id[a8rId]!='undefined' 
				&& moData.options.webinarjam_webinar_id[a8rId]!=null
			){
				defaultListId=moData.options.webinarjam_webinar_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'webinarjam-campaigns',
					"webinarjam_api_key": options.webinarjam_api_key,
					"webinarjam_webinar_id": defaultListId
				},
				function(return_data){
					try {
						data = jQuery.parseJSON(return_data);
						if (data){
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								var fieldsarray=[ 'first_name', 'last_name', 'email', 'phone' ];
								for (var listId in data.fields){
									fieldsarray.push( data.fields[listId] );
								}
								$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
								addDefaultFormElements();
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e){
						console.log(e);
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function convertkit_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId != '' 
			&& typeof options.convertkit_api_key != 'undefined'
			&& options.convertkit_api_key != null
		){
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null 
				&& moData != false 
				&& typeof moData.options != 'undefined' 
				&& moData.options != null
				&& typeof moData.options.convertkit_webinar_id != 'undefined' 
				&& moData.options.convertkit_webinar_id != null
				&& typeof moData.options.convertkit_webinar_id[a8rId]!='undefined' 
				&& moData.options.convertkit_webinar_id[a8rId]!=null
			){
				defaultListId=moData.options.convertkit_webinar_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'convertkit-campaigns',
					"convertkit_api_key": options.convertkit_api_key,
					"convertkit_webinar_id": defaultListId
				},
				function(return_data){
					try {
						data = jQuery.parseJSON(return_data);
						if (data){
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								var fieldsarray=[ 'first_name' ];
								for (var listId in data.fields){
									fieldsarray.push( data.fields[listId] );
								}
								$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
								addDefaultFormElements();
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e){
						console.log(e);
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function getresponse_loadfields( eltSelectId='', options ){
		if (eltSelectId == '' || typeof options.getresponse_api_key== 'undefined' ){
			return false;
		}
		if( typeof options.getresponse_api_key == 'undefined' ){
			// сначала коннект, потом получение списков
			// только как сохранить полученные насройки
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "getresponse-loadfields", "getresponse_api_key": options.getresponse_api_key }, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ){
					var fieldsarray=['name', 'email'];
					for (var listId=0; listId<data.fields.length; listId++){
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error){
				console.log( error );
			}
		});
		return false;
	}
	
	function activecampaign_loadlist( eltSelectId='', options, moData, a8rId  ){
		if (eltSelectId == '' || typeof options.activecampaign_url == 'undefined' || typeof options.activecampaign_api_key == 'undefined' ){
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		var defaultListId='';
		if( moData != null 
			&& moData != false 
			&& typeof moData.options != 'undefined' 
			&& moData.options != null
			&& typeof moData.options.activecampaign_list_id!='undefined' 
			&& moData.options.activecampaign_list_id!=null
			&& typeof moData.options.activecampaign_list_id[a8rId]!='undefined'
			&& moData.options.activecampaign_list_id[a8rId]!=null
		){
			defaultListId=moData.options.activecampaign_list_id[a8rId];
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
				"action": 'activecampaign-lists',
				"activecampaign_url": options.activecampaign_url,
				"activecampaign_api_key": options.activecampaign_api_key,
				"activecampaign_list_id": defaultListId
			},
			function(return_data){
				try {
					data = jQuery.parseJSON(return_data);
					if (data){
						jQuery("#"+eltSelectId).html(data.options);
						jQuery("#"+eltSelectId).removeAttr("disabled");
						addDefaultFormElements();
					} else jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				} catch(e){
					console.log(e);
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
				jQuery('.selectpicker').selectpicker('refresh');
			}
		);
	}
	
	function aweber_loadfields( eltSelectId='', options, listValue='' ){
		if (eltSelectId == '' || typeof options.aweber_oauth_id == 'undefined' ){
			return false;
		}
		if (	typeof options.aweber_consumer_key == 'undefined' 
			|| typeof options.aweber_consumer_secret == 'undefined' 
			|| typeof options.aweber_access_key == 'undefined' 
			|| typeof options.aweber_access_secret == 'undefined' 
		){
			// сначала коннект, потом получение списков
			// только как сохранить полученные насройки
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "aweber-loadfields", "aweber-consumer_key": options.aweber_consumer_key, "aweber-consumer_secret": options.aweber_consumer_secret, "aweber-access_key": options.aweber_access_key, "aweber-access_secret": options.aweber_access_secret, "aweber-listid": listValue }, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ){
					var fieldsarray=['email', 'name', 'tags', 'misc_notes'];
					for (var listId in data.fields){
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error){
				console.log( error );
			}
		});
		return false;
	}
	
	function aweber_loadlist( eltSelectId='', options, moData, a8rId ){
		if (eltSelectId == '' || typeof options.aweber_oauth_id == 'undefined' ){
			return false;
		}
		if (	typeof options.aweber_consumer_key == 'undefined' 
			|| typeof options.aweber_consumer_secret == 'undefined' 
			|| typeof options.aweber_access_key == 'undefined' 
			|| typeof options.aweber_access_secret == 'undefined' 
		){
			// сначала коннект, потом получение списков
			// только как сохранить полученные насройки
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "aweber-loadlist", "aweber-consumer_key": options.aweber_consumer_key, "aweber-consumer_secret": options.aweber_consumer_secret, "aweber-access_key": options.aweber_access_key, "aweber-access_secret": options.aweber_access_secret }, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK"){
					var flgHaveLists=false;
					jQuery("#"+eltSelectId).empty();
					for ( var listId in data.lists ){
						var addNewField=new Element( 'option' ).set('value',listId).set('html', data.lists[listId] );
						if( moData != null 
							&& moData != false 
							&& typeof moData.options != 'undefined' 
							&& moData.options != null
							&& typeof moData.options.aweber_listid != 'undefined' 
							&& moData.options.aweber_listid != null
							&& typeof moData.options.aweber_listid[a8rId]!='undefined' 
							&& moData.options.aweber_listid[a8rId]!=null
							&& moData.options.aweber_listid[a8rId]==listId
						){
							addNewField.selected=true;
						}
						$(eltSelectId).adopt( addNewField );
						flgHaveLists=true;
					}
					if( $(eltSelectId).options.length > 0 ){
						aweber_loadfields( eltSelectId, options, $($(eltSelectId).options[0]).get( 'value' ) );
						$(eltSelectId).addEvent('change',function( events ){
							aweber_loadfields( eltSelectId, options, events.target.value );
						});
					}
					if( !flgHaveLists ){
						jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
					}else{
						jQuery("#"+eltSelectId).removeAttr("disabled");
					}
				} else if (status == "ERROR"){
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				} else {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
			} catch(error){
				console.log(error);
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}
	
	function ontraport_loadtags( eltSelectId='', options, moData, a8rId ){
		if (eltSelectId == '' || typeof options.ontraport_app_id == 'undefined' || typeof options.ontraport_api_key == 'undefined' ){
			return false;
		}
		jQuery("#tags_"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
			action: "ontraport-updatetags", 
			"ontraport_app_id": options.ontraport_app_id,
			"ontraport_api_key": options.ontraport_api_key,
			"ontraport_start": $('tags_'+eltSelectId).options.length
			}, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK"){
					var flgHaveTags=false;
					var tagsCounter=0;
					for (var tagId in data.tags){
						var newOptionTag=new Element( 'option' ).set('value',tagId).set('html', data.tags[tagId] );
						if( moData!=null 
							&& typeof moData.options!='undefined' 
							&& moData.options!=null
							&& typeof moData.options.ontraport_contact_cat!='undefined'
							&& moData.options.ontraport_contact_cat!=null
							&& typeof moData.options.ontraport_contact_cat[a8rId]!='undefined'
							&& moData.options.ontraport_contact_cat[a8rId]!=null
							&& jQuery.inArray( tagId, moData.options.ontraport_contact_cat[a8rId] ) != -1 ){
							newOptionTag.selected=true;
						}
						$('tags_'+eltSelectId).adopt( newOptionTag );
						flgHaveTags=true;
						tagsCounter++;
					}
					if( tagsCounter < 50 ){
						$('check_tags_'+eltSelectId).set('html','Reload');
					}
					if( !flgHaveTags ){
						jQuery("#tags_"+eltSelectId).html("<option>-- Can not get Tags --</option>");
					}else{
						jQuery("#tags_"+eltSelectId).removeAttr("disabled").attr('multiple',true).attr('name', jQuery("#tags_"+eltSelectId).attr('name') + ( jQuery("#tags_"+eltSelectId).prop('name').indexOf( '[]' ) == -1 ? "[]" : "" ) );
					}
				}
			} catch(error){
				console.log( error );
				jQuery("#tags_"+eltSelectId).html("<option>-- Can not get Tags --</option>");
			}
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}

	function ontraport_loadlist( eltSelectId='', options, moData, a8rId ){
		if (eltSelectId == '' || typeof options.ontraport_app_id == 'undefined' || typeof options.ontraport_api_key == 'undefined' ){
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#check_tags_"+eltSelectId).html("Load more");
		jQuery("#tags_"+eltSelectId).html("<option>-- Loading Tags --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
				action: "ontraport-loadlist", 
				"ontraport_app_id": options.ontraport_app_id, 
				"ontraport_api_key": options.ontraport_api_key
			}, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK"){
					var flgHaveLists=false;
					jQuery("#"+eltSelectId).empty();
					ontraport_loadtags( eltSelectId, options, moData, a8rId );
					for (var listId in data.lists){
						var newOption=new Element( 'option' ).set('value',listId).set('html', data.lists[listId] );
						if( moData!=null && moData != false && typeof moData.options!='undefined' 
							&& typeof moData.options.ontraport_sequence!='undefined'
							&& typeof moData.options.ontraport_sequence[a8rId]!='undefined'
							&&jQuery.inArray( listId, moData.options.ontraport_sequence[a8rId] ) != -1 ){
							newOption.selected=true;
						}
						$(eltSelectId).adopt( newOption );
						flgHaveLists=true;
					}
					$('check_tags_'+eltSelectId).removeEvents('click');
					$('check_tags_'+eltSelectId).addEvent('click',function(elt){
						ontraport_loadtags( eltSelectId, options, moData, a8rId );
					});
					if( $(eltSelectId).options.length > 0 ){
						ontraport_loadfields( eltSelectId, options );
					}
					if( !flgHaveLists ){
						jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
					}else{
						jQuery("#"+eltSelectId).removeAttr("disabled").attr('multiple',true).attr('name', jQuery("#"+eltSelectId).attr('name')+"[]");
					}
					var fieldsarray=[ 'firstname', 'lastname', 'email', 'address', 'city', 'state', 'zip', 'birthday', 'notes', 'status', 'category', 'lead_source', 'cell_phone', 'home_phone', 'sms_number', 'office_phone', 'fax', 'company', 'address2', 'title', 'website', 'country', 'source_location'];
					for (var listId in data.fields){
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				} else if (status == "ERROR"){
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				} else {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
			} catch(error){
				console.log( error );
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}

	function ontraport_loadfields( eltSelectId='', options ){
		if (eltSelectId == '' || typeof options.ontraport_app_id == 'undefined' || typeof options.ontraport_api_key == 'undefined' ){
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "ontraport-loadfields", "ontraport_app_id": options.ontraport_app_id, "ontraport_api_key": options.ontraport_api_key }, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ){
					var fieldsarray=['firstname', 'lastname', 'email', 'address', 'city', 'state', 'zip', 'birthday', 'notes', 'status', 'category', 'lead_source', 'cell_phone', 'home_phone', 'sms_number', 'office_phone', 'fax', 'company', 'address2', 'title', 'website', 'country', 'source_location'];
					for (var listId=0; listId<data.fields.length; listId++){
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error){
				console.log( error );
			}
		});
		return false;
	}

	function gotowebinar_loadwebinars( eltSelectId='', options, moData, a8rId ){
		if (eltSelectId == '' || typeof options == 'undefined' || typeof options.activation == 'undefined' ){
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
				action: "gotowebinar-getwebinars",
				"activation": options.activation,
				"organizer_key": options.gotowebinar_organizer_id,
			}, function(return_data){
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK" && data.lists!=null){
					var flgHaveLists=false;
					jQuery("#"+eltSelectId).empty();
					for (var listId=0; listId<data.lists.length; listId++){
						data.lists[listId].webinarKey=data.lists[listId].webinarKey.substr(1);
						var newOption=new Element( 'option' ).set('value',data.lists[listId].webinarKey).set('html', data.lists[listId].subject );
						if( moData!=null && moData != false && typeof moData.options!='undefined' 
							&& typeof moData.options.gotowebinar_webinar_id!='undefined'
							&& typeof moData.options.gotowebinar_webinar_id[a8rId]!='undefined'
							&& data.lists[listId].webinarKey==moData.options.gotowebinar_webinar_id[a8rId] ){
							newOption.selected=true;
						}
						$(eltSelectId).adopt( newOption );
						flgHaveLists=true;
					}
					if( !flgHaveLists ){
						jQuery("#"+eltSelectId).html("<option>-- Webinars Lists is Empty --</option>");
					}else{
						jQuery("#"+eltSelectId).removeAttr("disabled");
					}
					var fieldsarray=[ 'firstName', 'lastName', 'email', 'source', 'address', 'city', 'state', 'zipCode', 'country', 'phone', 'organization', 'jobTitle', 'questionsAndComments', 'industry', 'numberOfEmployees', 'purchasingTimeFrame', 'purchasingRole' ];
					for (var listId in data.fields){
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				} else if (status == "ERROR"){
					jQuery("#"+eltSelectId).html("<option>-- Webinar Status Error --</option>");
				} else {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
			} catch(error){
				console.log( error );
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}

	function emailfunnels_loadlist( eltSelectId='', options, moData, a8rId ){
		if ( eltSelectId == '' ){
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post( '{/literal}{url name='email_funnels' action='request'}{literal}', {
			action : "getlist"
		} ).done( function( data ){
			try {
				data = jQuery.parseJSON( data );
				jQuery( "#" + eltSelectId ).empty();
				console.log( data );
				data.forEach( function( item ){
					var _flgSelected = false;
					if( moData !=null && moData != false && typeof moData.options!='undefined' && moData.options !== null 	
							&& typeof moData.options.email_funnel_id!='undefined'
							&& moData.options.email_funnel_id !== null
							&& typeof moData.options.email_funnel_id[a8rId]!='undefined'
							&& moData.options.email_funnel_id[a8rId]!==null
							&& item.id==moData.options.email_funnel_id[a8rId] ){
							_flgSelected=true;
					}
					jQuery( "#" + eltSelectId ).append( '<option value="' + item.id + '" ' + (_flgSelected ? 'selected="selected"' : '') + '>' + item.title + '</option>' )
				} );

				jQuery( "#" + eltSelectId ).removeAttr( 'disabled' );
			} catch(error){
				console.log( error );
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			jQuery('.selectpicker').selectpicker('refresh');
		} );
		return false;
	}

	var updateNameHashs=function(){
		$$('[data-hash="element"]').each(function(elt){
			// при редактировании не обновлять
			elt.empty();
			var flgSelected=false;
			if( elt.get('data-default') != null ){
				flgSelected=elt.get('data-default');
			}
			var formFields=[{'hash':'', 'name':'Static Value'}];
			$$('.hash_tags').each( function(formfield){
				var formFieldHash=formfield.get('value');
				var formFieldName=formfield.getPrevious('input').get('value');
				if( formFieldName == '' ){
					formFieldName=formfield.getPrevious('input').get('placeholder');
					formFieldNameFromSelect=formfield.getPrevious('select');
					if( formFieldNameFromSelect.options[formFieldNameFromSelect.selectedIndex].value != '' ){
						formFieldName=formFieldNameFromSelect.options[formFieldNameFromSelect.selectedIndex].get('html')
					}
				}
				if( formFieldName == '' ){
					formFieldName=formfield.getPrevious('input').get('placeholder');
				}
				formFields.push( {'hash':formFieldHash, 'name':formFieldName} );
			});
			var flgBeSelected=false;
			Array.each( formFields, function(data){ // этос писок элементов выбранных в форме
				var setValue=data.hash;
				var setHtml=data.name;
				if( flgSelected === data.hash ){
					flgSelected=true;
					flgBeSelected=true;
				}
				elt.adopt(
					new Element( 'option' )
						.set('value',setValue)
						.set('html', setHtml )
						.set('selected', flgSelected )
				);
				if( flgSelected == true ){
					flgSelected=false;
				}
			});
			if( flgBeSelected == true ){
				elt.getNext('input').set('type','hidden');
			}
			if( flgSelected != false ){
				elt.options[0].selected=true;
				$(elt).fireEvent('change',{target:$(elt)});
			}
		});
		jQuery('.selectpicker').selectpicker('refresh');
	};
	
	var arrAllFields=[
		{'name': 'name','placeholder': 'Enter Your Name','text': 'Name', 'tags': ['fname', 'firstname', 'name', 'firstName']},
		{'name': 'firstname','placeholder': 'Enter Your First Name','text': 'First Name', 'tags': ['fname', 'firstname', 'name', 'firstName']},
		{'name': 'lastname','placeholder': 'Enter Your Last Name','text': 'Last Name', 'tags': ['lname', 'lastname', 'lastName']},
		{'name': 'phone','placeholder': 'Enter Your Phone','text': 'Phone', 'tags': ['phone', 'cell_phone']},
		{'name': 'email','placeholder': 'Enter Your Email','text': 'Email', 'tags': ['email', 'email_address']},
		{'name': 'country','placeholder': 'Enter Your Country','text': 'Country'},
		{'name': 'city','placeholder': 'Enter Your City','text': 'City'},
		{'name': 'zip','placeholder': 'Enter Your Zip Code','text': 'Zip Code', 'tags': ['zip', 'zipCode']},
		{'name': 'street','placeholder': 'Enter Your Address','text': 'Address'}
	];
	
	var addA8rFiled=function(a8rId, eltsLength){ /// добавляем генерацию autoresponder отчета
		var newElt = [
			new Element('select.btn-group.mooptin-select.selectpicker.show-tick[name="arrData[settings][form]['+a8rId+']['+eltsLength+'][name]"]') // это список элементов полученных с a8r
				.set('style',"width:40%;display:inline-block;")
				.addEvent('change',function(event){
					if( $(event.target).get('value') == '' ){
						$('new_input_elt_'+a8rId+'_'+eltsLength)
							.set('type','text');
					}else{
						$('new_input_elt_'+a8rId+'_'+eltsLength)
							.set('value', '' )
							.set('type','hidden');
					}
				})
		];
		var strData='';
		newElt[0].adopt(
			new Element( 'option' )
				.set('value','')
				.set('html', 'New Field Type' )
		);
		var selectedDefaulttValue=false;
		if( $('select_'+a8rId)!= null &&  $('select_'+a8rId).get( 'data-fields' ) != null ){
			Array.each( $('select_'+a8rId).get( 'data-fields' ).split('|'), function(data){ // это список переменных полученных с a8r
				var showValue;
				var showTitle;
				showValue=showTitle=data;
				var splitedData=data.split('~');
				if( splitedData.length == 2 ){
					showValue=splitedData[0];
					showTitle=splitedData[1];
				}
				var newA8rOptions=new Element( 'option' ).set('value',showValue).set('html', showTitle );
				if( ( addDefaultFormElementsValue != false && addDefaultFormElementsValue==showValue )
					|| ( addDefaultFormElementsVariations != null && jQuery.inArray( showValue, addDefaultFormElementsVariations.split('|') ) >=0 )){
					newA8rOptions.set('selected','selected');
					selectedDefaulttValue=true;
				}
				newElt[0].adopt( newA8rOptions );
			});
		}
		var newNameElement=new Element('input.form-control#new_input_elt_'+a8rId+'_'+eltsLength+'[type="text"][name="arrData[settings][form]['+a8rId+']['+eltsLength+'][new_name]"][value="field'+eltsLength+'"][placeholder="write name"]').set( 'style',"width:20%;display:inline-block;");
		if( !selectedDefaulttValue ){
			if( addDefaultFormElementsValue == false ){
				addDefaultFormElementsValue='field_'+a8rId;
			}
			newNameElement.set('value', addDefaultFormElementsValue);
		}else{
			newNameElement
				.set('value', '' )
				.set('type','hidden');
		}
		newElt.include(newNameElement);
		// это список элементов полученных с a8r
		var newNameElementTarget=new Element('select.btn-group.mooptin-select.selectpicker.show-tick.check_ar_hashs_'+a8rId+'[data-hash="element"][name="arrData[settings][form]['+a8rId+']['+eltsLength+'][hash]"]') 
			.set('style',"width:40%;margin-left:5px;display:inline-block;")
			.addEvent('change', function(event_change){
				if( event_change.target.get('value') != '' ){
					event_change.target.set('data-default',event_change.target.get('value'));
					$('new_input_value_'+a8rId+'_'+eltsLength)
						.set('value', '' )
						.set('type','hidden');
				}else{
					event_change.target.erase('data-default');
					$('new_input_value_'+a8rId+'_'+eltsLength)
						.set('type','text');
				}
			});
		if( addDefaultFormElementsValue != false ){
			newNameElementTarget.set('data-default',addDefaultFormElementsValue);
			addDefaultFormElementsValue=true;
		}
		newElt.include(newNameElementTarget);
		var newDataElement=new Element('input.form-control#new_input_value_'+a8rId+'_'+eltsLength+'[type="text"][name="arrData[settings][form]['+a8rId+']['+eltsLength+'][static_value]"][placeholder="write value"]')
				.set( 'style',"width:20%;display:inline-block;");
		if( addDefaultFormElementsData != false ){
			newDataElement.set('value',addDefaultFormElementsData);
			addDefaultFormElementsData=false;
		}
		newElt.include(newDataElement);
		newElt.include(
			new Element('a.alert1[href="#delete"][title="Delete"][alt="Do you want to delete this element?"]')
				.set('style',"display:inline-block;height: 38px;margin-bottom:5px;width:5%;")
				.adopt(
					new Element( 'i.ion-trash-a' ).set('style','font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px; padding-top: 8px;')
				)
				.addEvent('click',function(){
					$('new_elt_'+a8rId+'_'+eltsLength).destroy();
					//updateFormFileds(); 
					return false;
				})
		);
		var _return=new Element('div.form-group.new_elts_ar.new_elt_'+a8rId+'#new_elt_'+a8rId+'_'+eltsLength).set('style',"margin-bottom:5px;").adopt(newElt);
		if( addDefaultFormElementsHide ){
			_return.hide();
		}
		return _return;
	};
	
	var addFormFiled=function(eltsLength, flgDefault=false, selectType=false){ /// добавляем в список для генерации формы
		var haveInFormFields=false;
		$$('select.form_names').each(function( elt ){
			if( typeof selectType.name != 'undefined' && selectType.name==elt.get('value') ){
				haveInFormFields=true;
			}
		});
		if( haveInFormFields ){
			return false;
		}
		var newElt = [
			new Element('select.form_names.btn-group.mooptin-select.selectpicker.show-tick[name="arrData[settings][form][add]['+eltsLength+'][name]"]')
				.set('style',"width:40%;display:inline-block;")
				.addEvent('change',function(event){
					if( $(event.target).get('value') != '' ){
						$$('[name="arrData[settings][form][add]['+eltsLength+'][placeholder]"]')[0].set('value', $$('[name="arrData[settings][form][add]['+eltsLength+'][placeholder]"]')[0].get( 'data-'+$(event.target).get('value') ) );
						$$('.new_class_add_'+eltsLength)[0].set('value', $(event.target).get('value') );
					}else{
						$$('[name="arrData[settings][form][add]['+eltsLength+'][placeholder]"]')[0].set('placeholder', 'Enter Your Placeholder' );
						$$('.new_class_add_'+eltsLength)[0]
							.set('name', 'arrData[settings][form][add]['+eltsLength+'][tag]' )
							.set('value','field'+eltsLength)
							.addClass('hash_tags')
							.addEvent('change',function(){
								updateNameHashs();
							});
					}
					updateNameHashs();
				})
		];
		var strData='';
		newElt[0].adopt(
			new Element( 'option' )
				.set('value','')
				.set('html', 'Custom Field '+(eltsLength+1) )
		);
		Array.each(arrAllFields, function(data){
			var addNewOption=new Element( 'option' ).set('value',data.name).set('html', data.text );
			if( typeof data.tags != 'undefined' && data.tags != null ){
				addNewOption.set('data-tags', data.tags.join('|'));
			}
			if( flgDefault && typeof selectType.name != 'undefined' && selectType.name != null && data.name==selectType.name){
				addNewOption.set('selected', 'selected');
			}
			newElt[0].adopt(addNewOption);
			strData+='[data-'+data.name+'="'+data.placeholder+'"]';
		});
		var setLoadedLabel='';
		if( typeof selectType.label != 'undefined' && selectType.label != null ){
			setLoadedLabel=selectType.label;
		}
		newElt.include(
			new Element('input.form-control.form_label[type="text"]')
			.set('style',"width:21%;margin-left:5px;display:inline-block;")
			.set('name', 'arrData[settings][form][add]['+eltsLength+'][label]' )
			.set('value',setLoadedLabel)
			.set('placeholder','Label '+eltsLength)
			.addEvent('change',function(elt){
				updateNameHashs();
			})
		);
		var setLoadedTag='field'+eltsLength;
		if( typeof selectType.tag != 'undefined' && selectType.tag != null ){
			setLoadedTag=selectType.tag;
		}
		newElt.include(
			new Element('input.form-control.new_class_add_'+eltsLength+'[type="hidden"][disabled]')
			.set('name', 'arrData[settings][form][add]['+eltsLength+'][tag]' )
			.set('value',setLoadedTag)
			.set('disabled',false)
			.addClass('hash_tags')
		);
		if( typeof selectType.name != 'undefined' && selectType.name != null && flgDefault ){
			newElt[2].set('value',selectType.name);
		}
		var addPhElement=new Element('input.form-control[name="arrData[settings][form][add]['+eltsLength+'][placeholder]"]'+strData+'[type="text"][placeholder="Enter Placeholder"]')
			.set('style',"width:40%;margin-left:5px;display:inline-block;");
		if( typeof selectType.placeholder != 'undefined' && selectType.placeholder != null ){
			addPhElement.set('value', selectType.placeholder);
		}
		newElt.include(addPhElement);
		var setLoadedRemove='0';
		if( typeof selectType.remove != 'undefined' && selectType.remove != null ){
			setLoadedRemove=selectType.remove;
		}
		newElt.include(
			new Element('input.form-control[name="arrData[settings][form][add]['+eltsLength+'][remove]"]'+strData+'[type="hidden"][value="'+setLoadedRemove+'"]')
			.set('style',"width:40%;margin-left:5px;display:inline-block;")
		);
		newElt.include(
			new Element('a.alert1[href="#delete"][title="Delete"][alt="Do you want to delete this element?"]')
				.set('style',"display:inline-block;height: 38px;margin-bottom:5px;width:5%;")
				.adopt(
					new Element( 'i.ion-trash-a' ).set('style','font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px; padding-top: 8px;')
				)
				.addEvent('click',function(){
					$('new_elt_'+eltsLength).destroy();
					updateNameHashs();
					return false;
				})
		);
		var eltRemoverClass='';
		if( typeof selectType.remove != 'undefined' && selectType.remove == 1 && flgDefault ){
			newElt[0].hide();
			newElt[1].hide();
			newElt[2].hide();
			newElt[3].hide();
			newElt[4].set('value',1);
			newElt[5].hide();
			eltRemoverClass='.email_form_group';
		}
		return new Element('div.form-group.new_etl_parent#new_elt_'+eltsLength+eltRemoverClass).set('style',"margin-bottom:5px;").adopt(newElt);
	};
	
	var addA8rElements=function(elt){
		var parentElt=$(elt).getParent('.a8r_new_element');
		var eltsType=parentElt.get('rel');
		var a8rId=$(elt).getParent('.mo_type_'+eltsType).get('data-id');
		var eltsLength=0;
		if( $$('.new_elt_'+a8rId).length > 0 ){
			eltsLength=$$('.new_elt_'+a8rId)[$$('.new_elt_'+a8rId).length-1].get('id').substr(('new_elt_'+a8rId).length+1);
			eltsLength++;
		}
		var haveHashValue=false;
		$$('.check_ar_hashs_'+a8rId).each(function(elthash){
			if( elthash.get('value') == addDefaultFormElementsValue ){
				haveHashValue=true;
			}
		});
		if( haveHashValue ){
			return true;
		}
		$(parentElt.getElements('.add_A8r_Field')[0]).grab(
			addA8rFiled(a8rId, eltsLength)
		,'before');
		updateNameHashs();
		jQuery('.selectpicker').selectpicker('refresh');
		// updateFormFileds();
		return false;
	};
	
	var addDefaultFormElementsTo=false;
	var addDefaultFormElementsValue=false;
	var addDefaultFormElementsData=false;
	var addDefaultFormElementsHide=false;
	var addDefaultFormElementsVariations=null;
	var addDefaultFormElements=function(){
		// проверка выбранных элементов основной формы
		if( addDefaultFormElementsTo != false ){
			$$('select.form_names').each(function( elt ){
				addDefaultFormElementsValue=elt.get('value');
				addDefaultFormElementsVariations=$(elt).options[$(elt).selectedIndex].get('data-tags');
				addA8rElements( addDefaultFormElementsTo.getElements('.add_A8r_Field')[0] );
			});
		}
		addDefaultFormElementsTo=false;
	};
	
	var newA8rElement=function(parent, a8rId, a8rIntegration){
		$(parent).set('data-id', a8rId );
	//	$(parent).getElements('.add_A8r_Field').addEvent('click',function(elt){
	//		addA8rElements(elt.target);
	//	});
		addDefaultFormElementsTo=$(parent);
	};
	
	var checkIntegrationCampaigns = function (){
		jQuery('.selectpicker').selectpicker();
		for(var i=$('mo_optin_integrations').childElementCount-1; i>=0; i-- ){
			var elmt=$('mo_optin_integrations')[i];
			$('integrations_local').selected=true;
			if( elmt.selected && $('mo_'+elmt.get('value'))==null && elmt.get('data-options') != null ){
				var eltOptions=JSON.decode( b64_d( elmt.get('data-options') ) );
//console.log( eltOptions );
				var eltsData=false;
				if( $('mo_optin_integrations').get('data-options') != null ){
					eltsData=JSON.decode( b64_d( $('mo_optin_integrations').get('data-options') ) );
				}
				if( typeof eltOptions.integration != 'undefined' && eltOptions.integration != null && $('mo_type_'+eltOptions.integration)!=null ){
					// тут создаем дубликат блока
					var newBlock=$('mo_type_'+eltOptions.integration)
						.clone()
						.set('id', 'mo_'+elmt.get('value') )
						.set('class','mo_type_'+eltOptions.integration)
						.show();
					newBlock.inject($('mo_type_ontraport'), 'before');
					var newBlock=$('mo_'+elmt.get('value'));
					$(newBlock.getElements('.a8r_name')[0]).set('html', elmt.get('html'));
					newBlock.getElements('[data-name^="arrData[settings][options]"]').each(function(nameSel){
						nameSel.set('name',nameSel.get('data-name')+'['+elmt.get('value')+']');
						if( eltsData != false && eltsData != null ){
							var lastName=nameSel.get('data-name').match(/(.*)\[(.*)\]$/i);
							if( typeof eltsData['options'] != 'undefined'
								&& eltsData['options'] != null
								&& typeof eltsData['options'][lastName[2]] != 'undefined'
								&& eltsData['options'][lastName[2]] != null
								&& typeof eltsData['options'][lastName[2]][elmt.get('value')]!='undefined'
							){
								nameSel.set('value',eltsData['options'][lastName[2]][elmt.get('value')]);
							}
						}
					});
					newA8rElement(newBlock, elmt.get('value'), eltOptions.integration);
					// тут редактирование 
					if( typeof eltOptions.newFields != 'undefined' && eltOptions.newFields != null ){
						for (var l=0, iLen=eltOptions.newFields.length; l<iLen; l++){
							addDefaultFormElementsValue=eltOptions.newFields[l].name;
							addDefaultFormElementsData=eltOptions.newFields[l].value;
							if( typeof eltOptions.newFields[l].hidden != 'undefined' ){
								addDefaultFormElementsHide=eltOptions.newFields[l].hidden;
							}else{
								addDefaultFormElementsHide=false;
							}
							addA8rElements(newBlock.getElements('.a8r_new_element a')[0]);
						}
					}
					if( typeof newBlock.getElementsByTagName('select') != 'undefined' && newBlock.getElementsByTagName('select') != null && newBlock.getElementsByTagName('select').length > 0 ){
						console.log( eltOptions.integration );
						var eltSeletId='select_'+elmt.get('value');
						$(newBlock.getElementsByTagName('select')[0])
							.addClass('selectpicker')
							.set('id', eltSeletId );
						if( eltOptions.integration == 'ontraport' ){
							$(newBlock.getElementsByTagName('select')[0])
								.set('id', "tags_"+eltSeletId );
							$(newBlock.getElementsByTagName('select')[1])
								.addClass('selectpicker')
								.set('id', eltSeletId );
							$(newBlock.getElementsByTagName('button')[0])
								.set('id', "check_tags_"+eltSeletId )
								.set('data-id', elmt.get('value') );
							ontraport_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'gotowebinar' ){
							$(newBlock.getElementsByTagName('select')[0])
								.addClass('selectpicker')
								.set('id', eltSeletId );
							gotowebinar_loadwebinars( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'emailfunnels' ){
							$(newBlock.getElementsByTagName('select')[0])
								.addClass('selectpicker')
								.set('id', eltSeletId );
							emailfunnels_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'mailchimp' ){
							mailchimp_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'getresponse' ){
							getresponse_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'perkzilla' ){
							perkzilla_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'everwebinar' ){
							everwebinar_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'webinarjam' ){
							webinarjam_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'convertkit' ){
							convertkit_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'activecampaign' ){
							activecampaign_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						if( eltOptions.integration == 'aweber' ){
							aweber_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value') );
						}
						jQuery('.selectpicker').selectpicker();
					}
					if( eltOptions.integration == 'html' ){
						var eltSeletId='select_'+elmt.get('value');
						$(newBlock.getElementsByTagName('span')[0])
							.set('id', eltSeletId );
					}
					if( eltOptions.integration == 'webhook' ){
						addDefaultFormElements();
						jQuery('.selectpicker').selectpicker();
					}
					// тут тоже редактирование
					if( typeof eltOptions.newFields != 'undefined' && eltOptions.newFields != null ){
						for (var l=0, iLen=eltOptions.newFields.length; l<iLen; l++){
							if( typeof newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][name]"]') != 'undefined' && typeof eltOptions.newFields[l]['name'] != 'undefined' && newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][name]"]') != null && eltOptions.newFields[l]['name'] != null ){
								var updateSelected=newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][name]"]')[0].getElements('option[value="'+eltOptions.newFields[l]['name']+'"]');
								if( updateSelected.length == 0 ){
									newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][name]"]')[0]
										.adopt( new Element( 'option' )
											.set('value',eltOptions.newFields[l]['name'])
											.set('html', eltOptions.newFields[l]['name'] )
											.set('selected',true)
										);
								}else{
									newBlock
										.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][name]"]')[0]
										.getElements('option[value="'+eltOptions.newFields[l]['name']+'"]')[0]
										.set('selected',true);
								}
								newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][new_name]"]')
									.hide();
							}
							if( typeof newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][new_name]"]') != 'undefined' && typeof eltOptions.newFields[l]['new_name'] != 'undefined' && newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][new_name]"]') != null && eltOptions.newFields[l]['new_name'] != null ){
								newBlock
									.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][new_name]"]')
									.set('value', eltOptions.newFields[l]['new_name'] );
							}
							if( typeof newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][hash]"]') != 'undefined' && typeof eltOptions.newFields[l]['hash'] != 'undefined' && newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][hash]"]') != null && eltOptions.newFields[l]['hash'] != null ){
								newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][hash]"]')[0].getElements('[value="'+eltOptions.newFields[l]['hash']+'"]').set( 'selected', true );
								newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][hash]"]')[0].set( 'data-default', eltOptions.newFields[l]['hash'] );
								newBlock
									.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][static_value]"]')
									.set('type','hidden');
							}
							if( typeof newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][static_value]"]') != 'undefined' && typeof eltOptions.newFields[l]['static_value'] != 'undefined' 
								&& newBlock.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][static_value]"]') != null && eltOptions.newFields[l]['static_value'] != null ){
								newBlock
									.getElements('[name="arrData[settings][form]['+elmt.get('value')+']['+l+'][static_value]"]')
									.set('value', eltOptions.newFields[l]['static_value'] );
							}
						}
						jQuery('.selectpicker').selectpicker();
					}
				}
			}else{
				if( !elmt.selected && $('mo_'+elmt.get('value'))!=null ){
					$('mo_'+elmt.get('value')).destroy();
					// тут нужно убрать опции, если они были выбраны в предыдущем пункте
				}
			}
		}
		jQuery('.selectpicker').selectpicker('refresh');
		$$('.mo_optin_integrations_group').hide();
		for (var i=0, iLen=$('mo_optin_integrations').options.length; i<iLen; i++){
			opt = $('mo_optin_integrations').options[i];
			if (opt.selected){
				$$('.mo_optin_integrations_'+( opt.value || opt.text )).show();
			}
		}
	};
	
	$('mo_optin_integrations').addEvent( 'change', function(){checkIntegrationCampaigns();});
	
	window.addEvent('domready', function(){
		setTimeout(function(){
			setTimeout(function(){
				$$('.edit_form_value').each(function(elt){
					var eltOptions=jQuery.parseJSON($(elt).get('data-json'));
					var eltsLength=0;
					if( $$('.new_etl_parent').length > 0 ){
						eltsLength=$$('.new_etl_parent')[$$('.new_etl_parent').length-1].get('id').substr(8);
						eltsLength++;
					}
					var removeElement=false;
					if( typeof eltOptions.remove != 'undefined' 
						&& eltOptions.remove != null
						&& eltOptions.remove==1
					){
						removeElement=true
					}
					var addElement=addFormFiled(eltsLength, true, eltOptions);
					if( addElement !== false ){
						$('add_form_new_element').grab(addElement,'before');
					}
					jQuery('.selectpicker').selectpicker('refresh');
				});
				
				checkIntegrationCampaigns();
				$$('select.form_names').each(function(elt){
					elt.addEvent('change',function(event){
						var splitName=event.target.get('name').split('][');
						eltsLength=splitName[3];
						eltsType=splitName[2];
						if( $(event.target).get('value') != '' ){
							$$('[name="arrData[settings][form]['+eltsType+']['+eltsLength+'][placeholder]"]')[0].set('value', $$('[name="arrData[settings][form]['+eltsType+']['+eltsLength+'][placeholder]"]')[0].get( 'data-'+$(event.target).get('value') ) );
							$$('.new_class_'+eltsType+'_'+eltsLength)[0].set('value', $(event.target).get('value') );
						}else{
							$$('[name="arrData[settings][form]['+eltsType+']['+eltsLength+'][placeholder]"]')[0].set('placeholder', 'Enter Your Placeholder' );
							$$('.new_class_'+eltsType+'_'+eltsLength)[0]
								.set('name', 'arrData[settings][form]['+eltsType+']['+eltsLength+'][tag]' )
								.set('value','field'+eltsLength)
								.addClass('hash_tags')
								.addEvent('change',function(){
									updateNameHashs();
								});
						}
						updateNameHashs();
					})
				});

				$$('input.form_label').each(function(elt){
					elt.addEvent('change',function(event){
						updateNameHashs();
					});
				});

				$$('.alert1').each(function(elt){
					elt.addEvent('click',function(evt){
						evt.target.getParent('div').destroy();
						updateNameHashs();
						return false;
					});
				});
				
			}, 10 );
		}, 10 );
	});
	
	var getFormElements=function (){
		$('autoresponder_form_settings').set('html','');
		new Request({
			url:"{/literal}{url name='site1_mooptin' action='request'}{literal}",
			method: 'post',
			onComplete: function(res){
				if( res != '' ){
					$('autoresponder_form_settings').set( 'html', res );
				}
				jQuery('.selectpicker').selectpicker();
				updateNameHashs();
				$$('.alert1').each(function(elt){
					elt.addEvent('click',function(evt){
						evt.target.getParent('div').destroy();
						updateNameHashs();
						return false;
					});
				});
			}
		}).post({"action": 'fetch-form',data:$('autoresponder_form_data').get('value')});
	};
	$('autoresponder_form_data').addEvent( 'change', function(){ getFormElements() });

	$('flg_conformation_trigger').addEvent('click',function(){
		if( $('flg_conformation_trigger').checked ){
			$('flg_conformation').show();
		}else{
			$('flg_conformation').hide();
		}
	});

	$('add_form_new_element').addEvent('click',function(){
		var eltsLength=0;
		if( $$('.new_etl_parent').length > 0 ){
			eltsLength=$$('.new_etl_parent')[$$('.new_etl_parent').length-1].get('id').substr(8);
			eltsLength++;
		}
		var addElement=addFormFiled(eltsLength);
		if( addElement !== false ){
			$('add_form_new_element').grab(addElement,'before');
		}
		jQuery('.selectpicker').selectpicker('refresh');
		updateNameHashs();
		return false;
	});

	$$('.mo_optin_sms_confirmation').addEvent('click',function(elt){
		$$('.mo_optin_sms_confirmation_block').hide();
		$$('.mo_optin_sms_confirmation_'+elt.target.get('value')).show();
	});	

	var moOptinEmail=function(){
		$('autoresponder_form_data').set('html','');
		$('autoresponder_form_data').set('html','<form>\n\
<input type="submit">\n\
</form>');
		// тут добавляются невидимы элементы email и name
		$$('.new_etl_parent').each(function(eltdel){
			$(eltdel).destroy();
		});
		var eltsLength=0;
		if( $$('.new_etl_parent').length > 0 ){
			eltsLength=$$('.new_etl_parent')[$$('.new_etl_parent').length-1].get('id').substr(8);
			eltsLength++;
		}
		var addElement=addFormFiled(eltsLength, true, {'name':'email'});
		if( addElement !== false ){
			$('add_form_new_element').grab(addElement,'before');
			addElement.children[0].options[5].selected=true;
			addElement.children[0].fireEvent('change', {'target':addElement.children[0]});
		}
	//	eltsLength++;
	//	var addElement=addFormFiled(eltsLength, true, {'name':'name', 'remove':1});
	//	if( addElement !== false ){
	//		$('add_form_new_element').grab(addElement,'before');
	//	}
		jQuery('.selectpicker').selectpicker('refresh');
		$$('.email_form_group').hide();
		updateNameHashs();
		getFormElements();
	};

	multibox=new CeraBox( $$('.popup_mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});

	var template_url = '{/literal}{Zend_Registry::get( 'config' )->domain->url}{Zend_Registry::get('config')->path->html->user_files}{literal}';

	$$('.move_to_optin').addEvent('click',function(evt){
		evt||evt.stop();
		$('flg_redirect').set('value',0);
		$('flg_optin').set('value',1);
		jQuery( '[data-block="optin"]' ).show();
		jQuery( '[data-block="redirect"]' ).hide();
		jQuery( '[data-block="messenger"]' ).hide();
		$$('[name="arrData[settings][affiliate_link_after_optin]"]')[0].set('value',$$('[name="arrData[settings][affiliate_link]"]')[0].get('value'));
		moOptinEmail();
	});
	
	$$('.move_to_redirect').addEvent('click',function(evt){
		evt||evt.stop();
		$('flg_redirect').set('value',1);
		$('flg_optin').set('value',0);
		jQuery( '[data-block="optin"]' ).hide();
		jQuery( '[data-block="redirect"]' ).show();
		jQuery( '[data-block="messenger"]' ).hide();
		$$('[name="arrData[settings][affiliate_link]"]')[0].set('value',$$('[name="arrData[settings][affiliate_link_after_optin]"]')[0].get('value'));
	});

	CKEDITOR.replace( 'gdpr', {
		toolbar : 'Basic_Squeeze',
		enterMode: CKEDITOR.ENTER_BR,
		shiftEnterMode: CKEDITOR.ENTER_BR,
		fontSize_sizes: '8px/8;9px/9;10px/10;11px/11;12px/12;14px/14;16px/16;18px/18;20px/20;22px/22;24px/24;26px/26;28px/28;36px/36;48px/48;72px/72',
		fontSize_style: {
			element: 'font',
			attributes: { 'size': '#(size)' },
			styles: { 'font-size': '#(size)px', 'line-height': '100%' }
		}
	});

	jQuery( '#flg_gdpr' ).on( 'click', function(){
		if( jQuery( this ).prop( 'checked' ) ){
			jQuery( '.gdpr' ).fadeIn( 'fast' );
		} else {
			jQuery( '.gdpr' ).fadeOut( 'fast' );
		}
	} );

	window.setTemplate = function(template_id){
		$('template_id').set('value', template_id);
		jQuery( '[data-block="optin"]' ).hide();
		jQuery( '[data-block="redirect"]' ).hide();
		jQuery( '[data-block="messenger"]' ).hide();
		$('gdpr-block').hide();
		$('flg_redirect').set('value',0);
		$('flg_optin').set('value',0);
		$('flg_messenger').set('value',0);
		$('flg_gdpr').set('checked',0);
		jQuery.ajax({
			method: "POST",
			url: '{/literal}{url name="site1_funnels" action="ajax"}{literal}',
			data: { template_id: jQuery( '#template_id' ).prop( 'value' ) }
		}).done(function( msg ){
			msg = JSON.parse( msg );
			jQuery( '[data-template]' ).find( 'img' ).prop( 'src', template_url + 'squeeze/templates/' +  msg.settings.template_hash + '.jpg' );
			jQuery( '[data-template]' ).find( 'p' ).html( msg.settings.template_description );
			jQuery( '[data-template]' ).fadeIn( 'fast' );
			if( typeof msg.tpl_settings != 'undefined' 
				&& msg.tpl_settings != null
				&& msg.tpl_settings.flg_require != '' 
				&& msg.tpl_settings.offer_application != ''
			){
				$('additional_link_box').show();
				$('additional_link').set('href', msg.tpl_settings.offer_application);
			}
			if( msg.settings.type_page == '2' ){
				$('flg_optin').set('value', 1);
				$('gdpr-block').show();
				if( typeof msg.tpl_settings != 'undefined' 
					&& msg.tpl_settings != null
					&& msg.tpl_settings.affiliate_link != '' 
				){
					$$('[name="arrData[settings][affiliate_link_after_optin]"]')[0].set('value', msg.tpl_settings.affiliate_link);
					$$('[name="arrData[settings][affiliate_link]"]')[0].set('value', msg.tpl_settings.affiliate_link);
				}
				jQuery( '[data-block="optin"]' ).show();
				moOptinEmail();
			}
			if( msg.settings.type_page == '1' ){
				$('flg_redirect').set('value', 1);
				if( typeof msg.tpl_settings != 'undefined' 
					&& msg.tpl_settings != null
					&& msg.tpl_settings.affiliate_link != ''
				){
					$$('[name="arrData[settings][affiliate_link]"]')[0].set('value', msg.tpl_settings.affiliate_link);
					$$('[name="arrData[settings][affiliate_link_after_optin]"]')[0].set('value', msg.tpl_settings.affiliate_link);
				}
				jQuery( '[data-block="redirect"]' ).show();
			}
			if( msg.settings.type_page == '3' ){
				$('flg_messenger').set('value', 1);
				jQuery( '[data-block="messenger"]' ).show();
			}
			if( typeof msg.tpl_settings != 'undefined' 
				&& msg.tpl_settings != null
				&& msg.tpl_settings.info != '' 
			){
				$('additional_info').show();
				$('set_additional_info').set( 'html', msg.tpl_settings.info );
			}
			jQuery( '[name="arrData[tags]"]' ).prop( 'value', msg.tags );
			jQuery( '#show_tags' ).show();
			jQuery( '#validation_realtime' ).show();
			jQuery( '#save' ).removeAttr( 'disabled' );
		});
	}
</script>
{/literal}