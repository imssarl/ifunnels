<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<div class="row">
	<div class="col-lg-12" id="no_elements_error" style="display:none;">{include file='../../message.tpl' type='error' message='Add one or more Form Fields, like as Email, Name.'}</div>   
</div>   

<div class="card-box">
	<form action="" method="post" id="form" class="wh validate" enctype="multipart/form-data">
		<input type="hidden" name="arrData[id]" value="{if isset( $arrData.id )}{$arrData.id}{/if}" />

		<div class="form-group">
			<label>Select Campaign Type:</label>
			<select name="arrData[settings][type]" class="btn-group selectpicker show-tick" id="mo_optin_type">
				<option value="optin"{if !isset($arrData.settings.type) || $arrData.settings.type=='optin'} selected="selected"{/if}>Optin Form</option>
				<option value="email"{if $arrData.settings.type=='email'} selected="selected"{/if}>MO Email Optin</option> 
				<option value="sms"{if $arrData.settings.type=='sms'} selected="selected"{/if}>MO SMS Optin</option> 
			</select>
		</div>

		<div class="form-group">
			<div class="form-group">
				<label class="control-label">Tags:</label>
				<input type="text" name="arrData[tags]" class="form-control" value="{$arrData.tags}" />
			</div>
		</div>

		<div id="gdpr-block">
			<div class="form-group">
				<input type="hidden" name="arrData[settings][flg_gdpr]" value="0" />
				<div class="checkbox checkbox-primary">
					<input type="checkbox" id="flg_gdpr" value="1" name="arrData[settings][form][flg_gdpr]"{if $arrData.settings.form.flg_gdpr} checked=""{/if} />
					<label for="flg_gdpr">Enable GDPR Consent</label>
				</div>
			</div>
			
			{if Core_Acs::haveAccess( array( 'email test group', 'Validate' ) )}
			<div class="form-group" id="validation_realtime">
				<input type="hidden" name="arrData[settings][validation_realtime]" value="0" />
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arrData[settings][validation_realtime]" value="1" id="validation_realtime_cb"{if Project_Validations_Realtime::check( Core_Users::$info['id'], Project_Validations_Realtime::MOOPTIN, $arrData.id )} checked{/if} />
					<label for="validation_realtime_cb">Enable Real Time Email Validation</label>
				</div>
			</div>
			{/if}
			
			<div class="form-group gdpr" {if !$arrData.settings.form.flg_gdpr}style="display: none"{/if}>
				<label class="control-label"></label>
				<textarea name="arrData[settings][form][gdpr]" id="gdpr">{if empty($arrData.settings.form.gdpr)}I agree to the OnlineNewsletters.net <a target="_blank" href="https://onlinenewsletters.net/terms.php">Terms of service</a> and <a target="_blank" href="https://onlinenewsletters.net/privacy.php">Privacy policy</a>.{else}{$arrData.settings.form.gdpr}{/if}</textarea>
			</div>
		</div>

		<div class="form-group">
			<div class="hidden">
				<label class="control-label">Optin Form:</label>
				<textarea name="arrData[settings][optin_form]" id="autoresponder_form_data" class="form-control">
					{if isset($arrData.settings.optin_form)}{$arrData.settings.optin_form}{else}<form><input type="submit"></form>{/if}
				</textarea>
			</div>

			<div id="autoresponder_form_settings">
				{if isset( $arrData.settings.form )}
					{if isset( $arrData.settings.form.attr )}
						{foreach from=$arrData.settings.form.attr item=attributes key=hashcode}
							{if isset($arrData.settings.form.attr[$hashcode].action) }
					<label style="float:left;width:20%;height:30px;margin-top: 7px;">Form Action:</label>
					<input type="text" class="form-control" name="arrData[settings][form][attr][{$hashcode}][action]" value="{$arrData.settings.form.attr[$hashcode].action}" placeholder="Form Action" style="width:75%;float:left;margin-bottom:5px;">
							{/if}
							{if isset($arrData.settings.form.attr[$hashcode].method) }
					<input type="hidden" name="arrData[settings][form][attr][{$hashcode}][method]" value="{$arrData.settings.form.attr[$hashcode].method}">
							{/if}
						{/foreach}
						
						{*foreach from=$arrData.settings.form.inputs item=attr key=hashcode}
							<input type="hidden" class="edit_form_value" data-json='{json_encode($attr)}'>
						{/foreach*}
					{/if}
				{/if}
			</div>

			<div class="form-group" id="form_new_element">
				{if isset( $arrData.settings.form )}
					{if isset( $arrData.settings.form.add )}
						{foreach from=$arrData.settings.form.add item=attr key=hashcode}
							<input type="hidden" class="edit_form_value" data-json='{json_encode($attr)}'>
						{/foreach}
					{/if}
				{/if}

				<a href="#new-element" id="add_form_new_element" title="Add New Form Element">
					<i class="ion-android-add" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0"></i> Add New Field
				</a>
			</div>
		</div>

		<div class="mo_optin_group mo_optin_sms"{if $arrData.settings.type=='sms' } style="display: inline;"{else} style="display: none;"{/if}></div>

		<div class="mo_optin_group mo_optin_email"{if $arrData.settings.type=='email' } style="display: inline;"{else} style="display: none;"{/if}>
			<div class="form-group checkbox checkbox-primary">
				<input type="hidden" name="arrData[settings][flg_conformation]" checked  value="0"/>
				<input type="checkbox" name="arrData[settings][flg_conformation]" class="form-control" id="flg_conformation_trigger" {if $arrData.settings.flg_conformation}checked{/if} value="1"/>
				<label>Send Confirmation Email</label>
			</div>
			<div id="flg_conformation" {if !isset($arrData.settings.flg_conformation) || $arrData.settings.flg_conformation=='0'}style="display:none;"{/if}>
				<div class="form-group">
					<label class="control-label">Confirmation Line:</label>
					<input type="text" name="arrData[settings][conformation_line]" class="form-control" value="{$arrData.settings.conformation_line}" />
				</div>
				<div class="form-group" style="height: 200px;">
					<textarea name="arrData[settings][conformation_text]" class="form-control" style="height: 200px;width:500px;display:inline;float:left;" >{$arrData.settings.conformation_text}</textarea>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label">Subject Line:</label>
				<input type="text" name="arrData[settings][subject_line]" class="form-control" value="{$arrData.settings.subject_line}" />
			</div>
			<div class="form-group" style="height: 200px;">
				<textarea name="arrData[settings][subject_text]" class="form-control" style="height: 200px;width:500px;display:inline;float:left;" >{$arrData.settings.subject_text}</textarea>
			</div>
		</div>

		<div style="display: inline-block;width:100%;height:1px;">&nbsp;</div>

		<div class="mo_optin_group mo_optin_sms"{if $arrData.settings.type=='sms' } style="display: block;"{else} style="display: none;"{/if}>
			<div class="form-group">
				<label class="control-label">Select Phone Number: </label>
				<select name="arrData[settings][sms_number]" class="btn-group selectpicker show-tick" id="mo_optin_sms_number_phone">
				{if isset( $arrUserCountries ) && count( $arrUserCountries ) >0}{foreach from=$arrUserCountries item=i key=k}
					{foreach from=$i.numbers item=n key=t}
					<option value="{$n}"{if $arrData.settings.sms_number==$n} selected="selected"{/if}>{$n}</option>
					{/foreach}
				{/foreach}{/if}
				</select>
				<br/>
				<a href="{url name='site1_mooptin' action='providenumber'}" class="popup" title="Provision a New Number">Provision a New Number</a>
			</div>
		</div>

		<div>
			<div class="form-group">
				<label>Where Should We Send The Leads To:</label>

				<select name="arrData[settings][integrations][]" id="mo_optin_integrations" multiple size="3" class="btn-group selectpicker show-tick" data-options="{$b64data}">
					<option id="integrations_local" value="local" selected="selected" >Store Locally</option>
					{if Core_Acs::haveAccess( array( 'Email funnels' ) )}
					<option class="integrations_other" value="emailfunnels"{if isset($arrData.settings.integrations) && in_array( 'emailfunnels', $arrData.settings.integrations )} selected="selected"{/if} data-options='{base64_encode('{"newFields":[{"name":"email","hash":"email"}],"integration":"emailfunnels"}')}'>Email Funnels</option>
					{/if}
					{foreach from=$arList key=i item=data}
					<option class="integrations_other" value="{$data.id}" data-options="{$data.b64opt}" {if isset($arrData.settings.integrations) && in_array( $data.id, $arrData.settings.integrations )} selected="selected"{/if}>{$data.name}</option>
					{/foreach}
				</select>

				<br/>

				<a href="{url name='site1_mooptin' action='autoresponder'}" class="popup hidden" title="Add New Integration">Add New Integration</a>
			</div>
			{*============================================*}
			
			{*html*}
			<div id="mo_type_html" style="display:none;">
				<div class="form-group">
					<label class="a8r_name">HTML</label>
				</div>

				<div class="a8r_new_element" rel="html">
					<span></span>
					<a href="#new-element" class="add_A8r_Field  hidden" title="Add New Integration Value" style="width:100%;float:left;margin-bottom:5px;">
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
					<label class="a8r_name">GoTo Webinar</label>
				</div>

				<div class="form-group">
					<label>Email Funnels: </label>
					<select data-name="arrData[settings][options][email_funnel_id]" class="ic_input_m btn-group show-tick"></select>
					<br><small>Select your Email Funnel.</small>
				</div>

				<div class="a8r_new_element" rel="emailfunnels">
					<div class="alert alert-info">
						<p>All contact details will be stored in Contact details in Email Funnels.</p>
					</div>

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
					<label>Webinar: </label>
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

		<div class="mo_optin_group mo_optin_sms"{if $arrData.settings.type=='sms' } style="display: block;"{else} style="display: none;"{/if}>
			<div class="form-group">
				<label class="control-label">Do you want to send a confirmation message (SMS):</label>
				<div class="radio radio-primary">
					<input type="radio" class="mo_optin_sms_confirmation" name="arrData[settings][sms_confirmation]" value="1"{if !isset( $arrData.settings.sms_confirmation ) || $arrData.settings.sms_confirmation == 1 } checked="checked"{/if} >
					<label>Yes</label>
				</div>

				<div class="radio radio-primary">
					<input type="radio" class="mo_optin_sms_confirmation" name="arrData[settings][sms_confirmation]" value="2"{if $arrData.settings.sms_confirmation == 2 } checked="checked"{/if} >
					<label>No</label>
				</div>
			</div>
			
			<div class="form-group mo_optin_sms_confirmation_block mo_optin_sms_confirmation_1" style="height: 260px;{if $arrData.settings.sms_confirmation == 1 }display:none;{/if}">
				<label class="control-label" style="float: left;width: 100%;">Confirmaton Message</label>
				<textarea name="arrData[settings][sms_text]" class="form-control" style="height: 200px;width:500px;display:inline;float:left;" >{$arrData.settings.sms_text}</textarea>
			</div>
		</div>

		<div class="form-group">
			<label>Give your Campaign a Name:</label>
			<input type="text" name="arrData[name]" value="{$arrData.name}" required class="form-control">
		</div>

		<fieldset class="m-t-10">
			<button class="btn btn-success btn-rounded waves-effect waves-light" type="button" value="{if !isset( $arrData.id )}Activate{else}Update{/if} Campaign" id="create">{if !isset( $arrData.id )}Activate{else}Update{/if} Campaign</button>
			<input type="submit" style="display: none;" value="Submit">
		</fieldset>

		{if isset( $popup ) && $popup===true}
		<input type="hidden" name="flgFromPopup" value="1">
		{/if}
	</form>
</div>

{literal}
<script type="text/javascript">
	var urlRequest='{/literal}{url name="site1_mooptin" action="request"}{literal}';
	var urlGenerate='{/literal}{url name="site1_mooptin" action="create"}{literal}';

	function b64_d(str) {
		return decodeURIComponent(Array.prototype.map.call(atob(str), function(c) {
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
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}',
		fixedPosition: true
	});

	function mailchimp_loadlist( eltSelectId='', options, moData, a8rId, newBlock){
		if (eltSelectId != '' && typeof options.mailchimp_api_key != 'undefined' && typeof options.mailchimp_user != 'undefined' ) {
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null && moData != false && typeof moData.options != 'undefined' && typeof moData.options.mailchimp_list_id != 'undefined' && typeof moData.options.mailchimp_list_id[a8rId]!='undefined' ){
				defaultListId=moData.options.mailchimp_list_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'mailchimp-loadlists',
					"mailchimp_api_key": options.mailchimp_api_key,
					"mailchimp_user": options.mailchimp_user
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data.status == "OK" ) {
							var flgHaveLists=false;
							jQuery("#"+eltSelectId).empty();
							if( defaultListId=='' ){
								defaultListId=data.lists[0].id;
							}
							for (var listId=0; listId<data.lists.length; listId++) {
						//	for (var listId in data.lists) {
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
					} catch(error) {
						console.log( error );
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					editNewFilds( options.newFields, newBlock, a8rId );
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}

	function mailchimp_loadfields( eltSelectId='', options, listValue='' ) {
		if (eltSelectId == '' || typeof options.mailchimp_api_key == 'undefined' || typeof options.mailchimp_user == 'undefined' || listValue=='' ) {
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
				"action": 'mailchimp-loadfields',
				"mailchimp_api_key": options.mailchimp_api_key,
				"mailchimp_user": options.mailchimp_user,
				"mailchimp_list_id": listValue
			}, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ) {
					var fieldsarray=['email_address', 'language'];
					for (var listId=0; listId<data.fields.length; listId++) {
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error) {
				console.log( error );
			}
		});
		return false;
	}
		
	function perkzilla_loadlist( eltSelectId='', options, moData, a8rId, newBlock  ){
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
					}catch(error){
						console.log(error);
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					editNewFilds( options.newFields, newBlock, a8rId );
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}

	function getresponse_loadlist( eltSelectId='', options, moData, a8rId, newBlock ) {
		if (eltSelectId != '' && typeof options.getresponse_api_key != 'undefined' ) {
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null && moData != false && typeof moData.options != 'undefined' && typeof moData.options.getresponse_campaign_id != 'undefined' && typeof moData.options.getresponse_campaign_id[a8rId]!='undefined' ){
				defaultListId=moData.options.getresponse_campaign_id[a8rId];
			}

			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'getresponse-campaigns',
					"getresponse_api_key": options.getresponse_api_key,
					"getresponse_campaign_id": defaultListId
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								getresponse_loadfields( eltSelectId, options );
								$(eltSelectId).addEvent('change',function( events ){
									getresponse_loadfields( eltSelectId, options );
								});
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e) {
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					editNewFilds( options.newFields, newBlock, a8rId );
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function everwebinar_loadlist( eltSelectId='', options, moData, a8rId, newBlock  ) {
		if (eltSelectId != '' && typeof options.everwebinar_api_key != 'undefined' ) {
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null && moData != false && typeof moData.options != 'undefined' && typeof moData.options.everwebinar_webinar_id != 'undefined' && typeof moData.options.everwebinar_webinar_id[a8rId]!='undefined' ){
				defaultListId=moData.options.everwebinar_webinar_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'everwebinar-campaigns',
					"everwebinar_api_key": options.everwebinar_api_key,
					"everwebinar_webinar_id": defaultListId
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								var fieldsarray=[ 'first_name', 'last_name', 'email', 'phone' ];
								for (var listId in data.fields) {
									fieldsarray.push( data.fields[listId] );
								}
								$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
								
								addDefaultFormElements();
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e) {
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					editNewFilds( options.newFields, newBlock, a8rId );
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function webinarjam_loadlist( eltSelectId='', options, moData, a8rId, newBlock  ) {
		if (eltSelectId != '' && typeof options.webinarjam_api_key != 'undefined' ) {
			jQuery("#"+eltSelectId).html("<option>-- Loading Campaigns --</option>");
			jQuery("#"+eltSelectId).attr("disabled", "disabled");
			jQuery('.selectpicker').selectpicker('refresh');
			var defaultListId='';
			if( moData != null && moData != false && typeof moData.options != 'undefined' && typeof moData.options.webinarjam_webinar_id != 'undefined' && typeof moData.options.webinarjam_webinar_id[a8rId]!='undefined' ){
				defaultListId=moData.options.webinarjam_webinar_id[a8rId];
			}
			jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
					"action": 'webinarjam-campaigns',
					"webinarjam_api_key": options.webinarjam_api_key,
					"webinarjam_webinar_id": defaultListId
				},
				function(return_data) {
					try {
						data = jQuery.parseJSON(return_data);
						if (data) {
							jQuery("#"+eltSelectId).html(data.options);
							if( data.options != '' ){
								var fieldsarray=[ 'first_name', 'last_name', 'email', 'phone' ];
								for (var listId in data.fields) {
									fieldsarray.push( data.fields[listId] );
								}
								$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
								addDefaultFormElements();
							}
							jQuery("#"+eltSelectId).removeAttr("disabled");
						} else jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					} catch(e) {
						jQuery("#"+eltSelectId).html("<option>-- Can not get Campaigns --</option>");
					}
					editNewFilds( options.newFields, newBlock, a8rId );
					jQuery('.selectpicker').selectpicker('refresh');
				}
			);
		}
	}
	
	function convertkit_loadlist( eltSelectId='', options, moData, a8rId  ){ // test
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
								var fieldsarray=[ 'first_name', 'fields', 'tags', 'email' ];
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
	
	function getresponse_loadfields( eltSelectId='', options ) {
		if (eltSelectId == '' || typeof options.getresponse_api_key== 'undefined' ) {
			return false;
		}
		if( typeof options.getresponse_api_key == 'undefined' ){
			// сначала коннект, потом получение списков
			// только как сохранить полученные насройки
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "getresponse-loadfields", "getresponse_api_key": options.getresponse_api_key }, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ) {
					var fieldsarray=['name', 'email'];
					for (var listId=0; listId<data.fields.length; listId++) {
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error) {
				console.log( error );
			}
		});
		return false;
	}
	
	function activecampaign_loadlist( eltSelectId='', options, moData, a8rId, newBlock  ) {
		if (eltSelectId == '' || typeof options.activecampaign_url == 'undefined' || typeof options.activecampaign_api_key == 'undefined' ) {
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		var defaultListId='';
		if( moData != null && moData != false && typeof moData.options != 'undefined' && typeof moData.options.activecampaign_list_id!='undefined' && typeof moData.options.activecampaign_list_id[a8rId]!='undefined' ){
			defaultListId=moData.options.activecampaign_list_id[a8rId];
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
				"action": 'activecampaign-lists',
				"activecampaign_url": options.activecampaign_url,
				"activecampaign_api_key": options.activecampaign_api_key,
				"activecampaign_list_id": defaultListId
			},
			function(return_data) {
				try {
					data = jQuery.parseJSON(return_data);
					if (data) {
						jQuery("#"+eltSelectId).html(data.options);
						jQuery("#"+eltSelectId).removeAttr("disabled");
						$(eltSelectId).set('data-fields', ['email', 'firstName', 'lastName', 'phone'].join( '|' ));
						addDefaultFormElements();
					} else jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				} catch(e) {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
				editNewFilds( options.newFields, newBlock, a8rId );
				jQuery('.selectpicker').selectpicker('refresh');
			}
		);
	}
	
	function aweber_loadfields( eltSelectId='', options, listValue='' ) {
		if (eltSelectId == '' || typeof options.aweber_oauth_id == 'undefined' ) {
			return false;
		}
		if (	typeof options.aweber_consumer_key == 'undefined' 
			|| typeof options.aweber_consumer_secret == 'undefined' 
			|| typeof options.aweber_access_key == 'undefined' 
			|| typeof options.aweber_access_secret == 'undefined' 
		) {
			// сначала коннект, потом получение списков
			// только как сохранить полученные насройки
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "aweber-loadfields", "aweber-consumer_key": options.aweber_consumer_key, "aweber-consumer_secret": options.aweber_consumer_secret, "aweber-access_key": options.aweber_access_key, "aweber-access_secret": options.aweber_access_secret, "aweber-listid": listValue }, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ) {
					var fieldsarray=['email', 'name', 'tags', 'misc_notes'];
					for (var listId in data.fields) {
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error) {
				console.log( error );
			}
		});
		return false;
	}
	
	function aweber_loadlist( eltSelectId='', options, moData, a8rId, newBlock ) {
		if (eltSelectId == '' || typeof options.aweber_oauth_id == 'undefined' ) {
			return false;
		}
		if (	typeof options.aweber_consumer_key == 'undefined' 
			|| typeof options.aweber_consumer_secret == 'undefined' 
			|| typeof options.aweber_access_key == 'undefined' 
			|| typeof options.aweber_access_secret == 'undefined' 
		) {
			// сначала коннект, потом получение списков
			// только как сохранить полученные насройки
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "aweber-loadlist", "aweber-consumer_key": options.aweber_consumer_key, "aweber-consumer_secret": options.aweber_consumer_secret, "aweber-access_key": options.aweber_access_key, "aweber-access_secret": options.aweber_access_secret }, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK") {
					var flgHaveLists=false;
					jQuery("#"+eltSelectId).empty();
					for ( var listId in data.lists ) {
						var addNewField=new Element( 'option' ).set('value',listId).set('html', data.lists[listId] );
						if( moData != null && moData != false && typeof moData.options != 'undefined' && typeof moData.options.aweber_listid != 'undefined' && typeof moData.options.aweber_listid[a8rId]!='undefined' && moData.options.aweber_listid[a8rId]==listId ){
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
				} else if (status == "ERROR") {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				} else {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
			} catch(error) {
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			editNewFilds( options.newFields, newBlock, a8rId );
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}
	
	function ontraport_loadtags( eltSelectId='', options, moData, a8rId ) {
		if (eltSelectId == '' || typeof options.ontraport_app_id == 'undefined' || typeof options.ontraport_api_key == 'undefined' ) {
			return false;
		}
		jQuery("#tags_"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {
			action: "ontraport-updatetags", 
			"ontraport_app_id": options.ontraport_app_id,
			"ontraport_api_key": options.ontraport_api_key,
			"ontraport_start": $('tags_'+eltSelectId).options.length
			}, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK") {
					var flgHaveTags=false;
					var tagsCounter=0;
					for (var tagId in data.tags) {
						var newOptionTag=new Element( 'option' ).set('value',tagId).set('html', data.tags[tagId] );
						if( moData!=null && typeof moData.options!='undefined' 
							&& typeof moData.options.ontraport_contact_cat!='undefined'
							&& typeof moData.options.ontraport_contact_cat[a8rId]!='undefined'
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
			} catch(error) {
				console.log( error );
				jQuery("#tags_"+eltSelectId).html("<option>-- Can not get Tags --</option>");
			}
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}

	function ontraport_loadlist( eltSelectId='', options, moData, a8rId, newBlock ) {
		if (eltSelectId == '' || typeof options.ontraport_app_id == 'undefined' || typeof options.ontraport_api_key == 'undefined' ) {
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
			}, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK") {
					var flgHaveLists=false;
					jQuery("#"+eltSelectId).empty();
					ontraport_loadtags( eltSelectId, options, moData, a8rId );
					for (var listId in data.lists) {
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
					for (var listId in data.fields) {
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				} else if (status == "ERROR") {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				} else {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
			} catch(error) {
				console.log( error );
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			editNewFilds( options.newFields, newBlock, a8rId );
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}

	function ontraport_loadfields( eltSelectId='', options ) {
		if (eltSelectId == '' || typeof options.ontraport_app_id == 'undefined' || typeof options.ontraport_api_key == 'undefined' ) {
			return false;
		}
		jQuery.post('{/literal}{url name='site1_mooptin' action='request'}{literal}', {action: "ontraport-loadfields", "ontraport_app_id": options.ontraport_app_id, "ontraport_api_key": options.ontraport_api_key }, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				if ( data.status == "OK" ) {
					var fieldsarray=['firstname', 'lastname', 'email', 'address', 'city', 'state', 'zip', 'birthday', 'notes', 'status', 'category', 'lead_source', 'cell_phone', 'home_phone', 'sms_number', 'office_phone', 'fax', 'company', 'address2', 'title', 'website', 'country', 'source_location'];
					for (var listId=0; listId<data.fields.length; listId++) {
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				}
			} catch(error) {
				console.log( error );
			}
		});
		return false;
	}
	
	function gotowebinar_loadwebinars( eltSelectId='', options, moData, a8rId, newBlock ){
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
			}, function(return_data) {
			try {
				var data = jQuery.parseJSON(return_data);
				var status = data.status;
				if (status == "OK" && data.lists!=null) {
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
					for (var listId in data.fields) {
						fieldsarray.push( data.fields[listId] );
					}
					$(eltSelectId).set('data-fields', fieldsarray.join( '|' ));
					addDefaultFormElements();
				} else if (status == "ERROR") {
					jQuery("#"+eltSelectId).html("<option>-- Webinar Status Error --</option>");
				} else {
					jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
				}
			} catch(error) {
				console.log( error );
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			editNewFilds( options.newFields, newBlock, a8rId );
			jQuery('.selectpicker').selectpicker('refresh');
		});
		return false;
	}

	function emailfunnels_loadlist( eltSelectId='', options, moData, a8rId, newBlock ){
		if ( eltSelectId == '' ) {
			return false;
		}
		jQuery("#"+eltSelectId).html("<option>-- Loading Lists --</option>");
		jQuery("#"+eltSelectId).attr("disabled", "disabled");
		jQuery('.selectpicker').selectpicker('refresh');
		jQuery.post( '{/literal}{url name='email_funnels' action='request'}{literal}', {
			action : "getlist"
		} ).done( function( data ) {
			try {
				data = jQuery.parseJSON( data );
				jQuery( "#" + eltSelectId ).empty();
				data.forEach( function( item ) {
					var _flgSelected = false;
					if( moData !=null && moData != false && typeof moData.options!='undefined' && moData.options!=null
						&& typeof moData.options.email_funnel_id!='undefined'
						&& moData.options.email_funnel_id !== null
						&& typeof moData.options.email_funnel_id[a8rId]!='undefined'
						&& moData.options.email_funnel_id[a8rId]!=null
						&& item.id==moData.options.email_funnel_id[a8rId] ){
							_flgSelected=true;
					}
					jQuery( "#" + eltSelectId ).append( '<option value="' + item.id + '" ' + (_flgSelected ? 'selected="selected"' : '') + '>' + item.title + '</option>' )
				} );
				jQuery( "#" + eltSelectId ).removeAttr( 'disabled' );
			} catch(error) {
				console.log( error );
				jQuery("#"+eltSelectId).html("<option>-- Can not get Lists --</option>");
			}
			editNewFilds( options.newFields, newBlock, a8rId );
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
		{'name': 'street','placeholder': 'Enter Your Address','text': 'Address'},
		{'name': 'use_as_tag', 'text': 'Use as tag', 'placeholder': 'Enter name of URL query'}
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
				if( ( addDefaultFormElementsNewName != false && addDefaultFormElementsNewName==showValue )
					|| ( addDefaultFormElementsVariations != null && jQuery.inArray( showValue, addDefaultFormElementsVariations.split('|') ) >=0 )){
					newA8rOptions.set('selected','selected');
					selectedDefaulttValue=true;
				}
				newElt[0].adopt( newA8rOptions );
			});
		}
		var newNameElement=new Element('input.form-control#new_input_elt_'+a8rId+'_'+eltsLength+'[type="text"]')
			.set('name', "arrData[settings][form]["+a8rId+"]["+eltsLength+"][new_name]" )
			.set('placeholder', "write name" )
			.set('value', 'field'+eltsLength )
			.set( 'style',"width:20%;display:inline-block;");
		if( !selectedDefaulttValue ){
			if( addDefaultFormElementsNewName == false ){
				addDefaultFormElementsNewName='field_'+eltsLength;
			}
			newNameElement.set('value', addDefaultFormElementsNewName);
			addDefaultFormElementsNewName=false;
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
		if( addDefaultFormElementsNewName != false ){
			newNameElementTarget.set('data-default', addDefaultFormElementsNewName);
			addDefaultFormElementsNewName=false;
			selectedDefaulttValue=false;
		}
		if( addDefaultFormElementsHash != false ){
			newNameElementTarget.set('data-default', addDefaultFormElementsHash);
			addDefaultFormElementsHash=false;
		}
		newElt.include(newNameElementTarget);
		var newDataElement=new Element('input.form-control#new_input_value_'+a8rId+'_'+eltsLength+'[type="text"][name="arrData[settings][form]['+a8rId+']['+eltsLength+'][static_value]"][placeholder="write value"]')
				.set( 'style',"width:20%;display:inline-block;");
		if( addDefaultFormElementsStaticValue != false ){
			newDataElement.set('value',addDefaultFormElementsStaticValue);
			addDefaultFormElementsStaticValue=false;
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
		if( addDefaultFormElementsHide || a8rId == 'emailfunnels' ){
			_return.hide();
		}
		return _return;
	};
	
	var addFormFiled=function(eltsLength, flgDefault=false, selectType=false){ /// добавляем в список для генерации формы
		var haveInFormFields=false;
		$$('select.form_names').each(function( elt ){
			if( typeof selectType.name != 'undefined' && selectType.name==elt.get('value') && elt.get('value') !== 'use_as_tag' ){
				haveInFormFields=true;
			}
		});

		if( haveInFormFields ){
			return false;
		}
		
		var newElt = [
			// Select with type field
			new Element('select.form_names.btn-group.mooptin-select.selectpicker.show-tick[name="arrData[settings][form][add]['+eltsLength+'][name]"]')
				.set('style',"width:40%;display:inline-block;")
				.addEvent('change', function(event){
					/** 
					 * Use as tag
					*/
					var $container = jQuery(`#new_elt_${eltsLength}`);
					var value = event.target.value;

					if (['use_as_tag'].indexOf(event.target.value) !== -1) {
						$container
							.children('input[type="text"], input[type="hidden"], div.checkbox-hidden')
							.each(function() {
								jQuery(this).remove();
							});

						var element = new Element('input.form-control[type="text"]')
							.set('style', "width:21%;margin-left:5px;display:inline-block;")
							.set('name', 'arrData[settings][form][add][' + eltsLength + '][placeholder]')
							.set('placeholder', 'Enter name');

						var hidden = new Element('input[type="hidden"]')
							.set('name', 'arrData[settings][form][add][' + eltsLength + '][flg_hidden]')
							.set('value', '1');
						
						jQuery(element).insertBefore($container.find('.alert1'));
						jQuery(hidden).insertBefore(element);
						
						return;
					}

					/** End */

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
		// First option [Custom Field]
		newElt[0].adopt(
			new Element( 'option' )
				.set('value','')
				.set('html', 'Custom Field '+(eltsLength+1) )
		);

		// Add all type fields
		Array.each(arrAllFields, function(data){
			var addNewOption=new Element( 'option' ).set('value',data.name).set('html', data.text );
			if( typeof data.tags != 'undefined' ){
				addNewOption.set('data-tags', data.tags.join('|'));
			}
			if( flgDefault && typeof selectType.name != 'undefined' && data.name==selectType.name){
				addNewOption.set('selected', 'selected');
			}
			newElt[0].adopt(addNewOption);
			strData+='[data-'+data.name+'="'+data.placeholder+'"]';
		});

		if (['use_as_tag'].indexOf(selectType.name) !== -1) {
			newElt.include(
				new Element('input.form-control[type="text"]')
					.set('style', "width:21%;margin-left:5px;display:inline-block;")
					.set('name', 'arrData[settings][form][add][' + eltsLength + '][placeholder]')
					.set('placeholder', 'Enter name')
					.set('value', selectType.placeholder)
			);

			newElt.include(
				new Element('input[type="hidden"]')
					.set('name', 'arrData[settings][form][add][' + eltsLength + '][flg_hidden]')
					.set('value', '1')
			);
		} else {
			var setLoadedLabel = '';
			if (typeof selectType.label != 'undefined') {
				setLoadedLabel = selectType.label;
			}

			// Add label
			newElt.include(
				new Element('input.form-control.form_label[type="text"]')
					.set('style', "width:21%;margin-left:5px;display:inline-block;")
					.set('name', 'arrData[settings][form][add][' + eltsLength + '][label]')
					.set('value', setLoadedLabel)
					.set('placeholder', 'Label ' + eltsLength)
					.addEvent('change', function (elt) {
						updateNameHashs();
					})
			);
			var setLoadedTag = 'field' + eltsLength;
			if (typeof selectType.tag != 'undefined') {
				setLoadedTag = selectType.tag;
			}

			// Tags [???]
			newElt.include(
				new Element('input.form-control.new_class_add_' + eltsLength + '[type="text"][disabled]')
					.set('style', "width:10%;margin-left:5px;display:inline-block;")
					.set('name', 'arrData[settings][form][add][' + eltsLength + '][tag]')
					.set('value', setLoadedTag)
					.set('disabled', false)
					.addClass('hash_tags')
			);
			if (typeof selectType.name != 'undefined' && flgDefault) {
				newElt[2].set('value', selectType.name);
			}

			// Placeholder
			var addPhElement = new Element('input#placeholder_' + eltsLength + '.form-control[name="arrData[settings][form][add][' + eltsLength + '][placeholder]"]' + strData + '[type="text"][placeholder="Enter Placeholder"]')
				.set('style', "width:40%;margin-left:5px;display:inline-block;");
			if (typeof selectType.placeholder != 'undefined') {
				addPhElement.set('value', selectType.placeholder);
			}
			newElt.include(addPhElement);
			var setLoadedRemove = '0';
			if (typeof selectType.remove != 'undefined') {
				setLoadedRemove = selectType.remove;
			}

			// Remove field [???]
			newElt.include(
				new Element('input.form-control[name="arrData[settings][form][add][' + eltsLength + '][remove]"]' + strData + '[type="hidden"][value="' + setLoadedRemove + '"]')
					.set('style', "width:40%;margin-left:5px;display:inline-block;")
			);
			var setHiddenSelected = '';
			if (typeof selectType.flg_hidden != 'undefined' && selectType.flg_hidden == '1') {
				setHiddenSelected = '[checked]';
				addPhElement.set('placeholder', 'Add default value');
				addPhElement.set('data-save', 'Enter Placeholder');
			}

			// Hidden
			newElt.include(
				new Element('div[class="checkbox-hidden"]').adopt(
					new Element('input[name="arrData[settings][form][add][' + eltsLength + '][flg_hidden]"]' + strData + '[type="hidden"][value="0"][checked]'),
					new Element('input[name="arrData[settings][form][add][' + eltsLength + '][flg_hidden]"]' + strData + '[type="checkbox"][value="1"]' + setHiddenSelected)
						.addEvent('click', function () {
							if ($('placeholder_' + eltsLength).get('data-save') == null) {
								$('placeholder_' + eltsLength).set('data-save', $('placeholder_' + eltsLength).get('placeholder'));
								$('placeholder_' + eltsLength).set('placeholder', 'Add default value');
							} else {
								$('placeholder_' + eltsLength).set('placeholder', $('placeholder_' + eltsLength).get('data-save'));
								$('placeholder_' + eltsLength).erase('data-save')
							}
							return;
						}),
					new Element('label').set('html', 'hidden')
				).set('style', "padding:10px;display:inline-block;")
			);

		}
		// Delete
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
			if( elthash.get('value') == addDefaultFormElementsNewName ){
				haveHashValue=true;
			}
		});
		
		if( haveHashValue && addDefaultFormElementsNewName==addRunElementName ){
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
	var addRunElementName=false;
	var addDefaultFormElementsNewName=false;
	var addDefaultFormElementsHash=false;
	var addDefaultFormElementsStaticValue=false;
	var addDefaultFormElementsHide=false;
	var addDefaultFormElementsVariations=null;
	var addDefaultFormElements=function(){
		// проверка выбранных элементов основной формы
		if( addDefaultFormElementsTo != false ){
			$$('select.form_names').each(function( elt ){
				addDefaultFormElementsNewName=elt.get('value');
				addDefaultFormElementsVariations=$(elt).options[$(elt).selectedIndex].get('data-tags');
				addA8rElements( addDefaultFormElementsTo.getElements('.add_A8r_Field')[0] );
			});
		}
		addDefaultFormElementsTo=false;
	};
	
	var newA8rElement=function(parent, a8rId, a8rIntegration){
		$(parent).set('data-id', a8rId );
		$(parent).getElements('.add_A8r_Field').addEvent('click',function(elt){
			addA8rElements(elt.target);
		});
		addDefaultFormElementsTo=$(parent);
	};
	
	var editNewFilds=function( newFields, newBlock, elmtValue ){
		if( typeof newFields == 'undefined' ){
			return;
		}
		for (var l=0, iLen=newFields.length; l<iLen; l++) {
			if( newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][name]"]').length!=0 && typeof newFields[l]['name'] != 'undefined' ){
				var updateSelected=newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][name]"] option[value="'+newFields[l]['name']+'"]');
				if( updateSelected.length == 0 ){
					newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][name]"]')[0]
						.adopt( new Element( 'option' )
							.set('value',newFields[l]['name'])
							.set('html', newFields[l]['name'] )
							.set('selected',true)
						);
				}else{
					newBlock
						.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][name]"]')[0]
						.getElements('option[value="'+newFields[l]['name']+'"]')[0]
						.set('selected',true);
				}
				newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][new_name]"]')
					.hide();
			}
			if( newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][new_name]"]').length!=0 && typeof newFields[l]['new_name'] != 'undefined' ){
				newBlock
					.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][new_name]"]')
					.set('value', newFields[l]['new_name'] );
			} else {
				newBlock
					.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][new_name]"]')
					.set('value', '' );
			}
			if( newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][hash]"]').length!=0 && typeof newFields[l]['hash'] != 'undefined' ){
				newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][hash]"]')[0].getElements('[value="'+newFields[l]['hash']+'"]').set( 'selected', true );
				newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][hash]"]')[0].set( 'data-default', newFields[l]['hash'] );
				newBlock
					.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][static_value]"]')
					.set('type','hidden');
			}
			if( typeof newBlock.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][static_value]"]') != 'undefined' && typeof newFields[l]['static_value'] != 'undefined' ){
				newBlock
					.getElements('[name="arrData[settings][form]['+elmtValue+']['+l+'][static_value]"]')
					.set('value', newFields[l]['static_value'] );
			}
		}
		jQuery('.selectpicker').selectpicker();
	}
	
	var checkIntegrationCampaigns = function () {
		jQuery('.selectpicker').selectpicker();
		for(var i=$('mo_optin_integrations').childElementCount-1; i>=0; i-- ){
			var elmt=$('mo_optin_integrations')[i];
			$('integrations_local').selected=true;
			if( elmt.selected && $('mo_'+elmt.get('value'))==null && elmt.get('data-options') != null ){
				var eltOptions=JSON.decode( b64_d( elmt.get('data-options') ) );
				var eltsData=false;
				if( $('mo_optin_integrations').get('data-options') != null ){
					eltsData=JSON.decode( b64_d( $('mo_optin_integrations').get('data-options') ) );
				}
				if( typeof eltOptions.integration != 'undefined' && $('mo_type_'+eltOptions.integration)!=null ){
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
					if( typeof eltOptions.newFields != 'undefined' ){
						for (var l=0, iLen=eltOptions.newFields.length; l<iLen; l++) {
							var addDefaultFormElementsNewName=false;
							if( eltOptions.newFields[l] != null && typeof eltOptions.newFields[l].name != 'undefined' ){
								addDefaultFormElementsNewName=eltOptions.newFields[l].name;
							}
							if( eltOptions.newFields[l] != null && typeof eltOptions.newFields[l].new_name != 'undefined' ){
								addDefaultFormElementsNewName=eltOptions.newFields[l].new_name;
							}
							addDefaultFormElementsHash=false;
							if( eltOptions.newFields[l] != null && typeof eltOptions.newFields[l].hash != 'undefined' ){
								addDefaultFormElementsHash=eltOptions.newFields[l].hash;
							}
							var addDefaultFormElementsHide=false;
							if( eltOptions.newFields[l] != null && typeof eltOptions.newFields[l].value != 'undefined' ){
								addDefaultFormElementsHide=eltOptions.newFields[l].value;
							}
							if( eltOptions.newFields[l] != null && typeof eltOptions.newFields[l].hidden != 'undefined' ){
								addDefaultFormElementsHide=eltOptions.newFields[l].hidden;
							}else{
								addDefaultFormElementsHide=false;
							}
							addRunElementName=eltOptions.newFields[l].name;
							addA8rElements(newBlock.getElements('.a8r_new_element a')[0]);
						}
					}

					if( typeof newBlock.getElementsByTagName('select') != 'undefined' && newBlock.getElementsByTagName('select').length > 0 ){
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
							ontraport_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'gotowebinar' ){
							$(newBlock.getElementsByTagName('select')[0])
								.addClass('selectpicker')
								.set('id', eltSeletId );
							gotowebinar_loadwebinars( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'emailfunnels' ){
							$(newBlock.getElementsByTagName('select')[0])
								.addClass('selectpicker')
								.set('id', eltSeletId );
							emailfunnels_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'mailchimp' ){
							mailchimp_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'getresponse' ){
							getresponse_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'perkzilla' ){
							perkzilla_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'everwebinar' ){
							everwebinar_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'webinarjam' ){
							webinarjam_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'convertkit' ){
							convertkit_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'activecampaign' ){
							activecampaign_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						if( eltOptions.integration == 'aweber' ){
							aweber_loadlist( eltSeletId, eltOptions, eltsData, elmt.get('value'), newBlock );
						}
						jQuery('.selectpicker').selectpicker();
					}
					if( eltOptions.integration == 'html' ){
						var eltSeletId='select_'+elmt.get('value');
						$(newBlock.getElementsByTagName('span')[0])
							.set('id', eltSeletId );
					//	addDefaultFormElements();
						editNewFilds( eltOptions.newFields, newBlock, elmt.get('value') );
					}
					if( eltOptions.integration == 'webhook' ){
						jQuery('.selectpicker').selectpicker();
					}
				}
			}else{
				if( !elmt.selected && $('mo_'+elmt.get('value'))!=null ){
					$('mo_'+elmt.get('value')).destroy();
					// тут нужно убрать опции, если они были выбраны в предыдущем пункте
				}
			}
			addDefaultFormElementsTo=false;
		}
		jQuery('.selectpicker').selectpicker('refresh');
		$$('.mo_optin_integrations_group').hide();
		for (var i=0, iLen=$('mo_optin_integrations').options.length; i<iLen; i++) {
			opt = $('mo_optin_integrations').options[i];
			if (opt.selected) {
				$$('.mo_optin_integrations_'+( opt.value || opt.text )).show();
			}
		}
	};
	
	$('mo_optin_integrations').addEvent( 'change', function(){checkIntegrationCampaigns();});
	
	window.addEvent('domready', function(){
		setTimeout(function(){
			setTimeout(function(){
				
				$('mo_optin_type').fireEvent('change',{'target':$('mo_optin_type')});
				
				$$('.edit_form_value').each(function(elt){
					var eltOptions=jQuery.parseJSON($(elt).get('data-json'));
					var eltsLength=0;
					if( $$('.new_etl_parent').length > 0 ){
						eltsLength=$$('.new_etl_parent')[$$('.new_etl_parent').length-1].get('id').substr(8);
						eltsLength++;
					}
					var removeElement=false;
					if( typeof eltOptions.remove != 'undefined' && eltOptions.remove==1 ){
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
	
	var getFormElements=function () {
		$('autoresponder_form_settings').set('html','');
		new Request({
			url:"{/literal}{url name='site1_mooptin' action='request'}{literal}",
			method: 'post',
			onComplete: function(res){
				if( res != 'false' ){
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
		}).post({ "action": 'fetch-form', data:$('autoresponder_form_data').get('value') });
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
	
	$('create').addEvent('click',function(){
		$('no_elements_error').hide();
		if( $$('.new_etl_parent').length == 0 ){
			$('no_elements_error').show();
			return;
		}
		$('form').set( 'action',urlGenerate );
		$('form').set( 'target','_self' );
		$('form').submit();
	});

	$$('.mo_optin_sms_confirmation').addEvent('click',function(elt){
		$$('.mo_optin_sms_confirmation_block').hide();
		$$('.mo_optin_sms_confirmation_'+elt.target.get('value')).show();
	});	

	$('mo_optin_type').addEvent('change',function( elt ){
		$('gdpr-block').hide();
		$$('.mo_optin_group').hide();
		$$('.mo_optin_'+elt.target.get('value')).show();
		$('add_form_new_element').hide();
		$$('.new_elts_ar').each(function(eltdel){
			$(eltdel).destroy();
		});
		if( elt.target.get('value') == 'sms' ){
			$('autoresponder_form_data').set('html','');
			$('autoresponder_form_data').set('html','<form>\n\
	<input type="submit">\n\
</form>');
			$$('.email_form_group').destroy();
		}
		if( elt.target.get('value') == 'email' ){
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
			var addElement=addFormFiled(eltsLength, true, {'name':'email', 'remove':1});
			if( addElement !== false ){
				$('add_form_new_element').grab(addElement,'before');
			}
			eltsLength++;
			var addElement=addFormFiled(eltsLength, true, {'name':'name', 'remove':1});
			if( addElement !== false ){
				$('add_form_new_element').grab(addElement,'before');
			}
			jQuery('.selectpicker').selectpicker('refresh');
			$$('.email_form_group').hide();
			updateNameHashs();
		}
		if( elt.target.get('value') == 'optin' ){
			$('autoresponder_form_data').set('html','');
			$('autoresponder_form_data').set('html','<form>\n\
	<input type="submit">\n\
</form>');
			$('gdpr-block').show();
			$('add_form_new_element').show();
			$$('.email_form_group').destroy();
		}
		getFormElements();
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
</script>
{/literal}
