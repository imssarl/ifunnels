{$mode=$arrPrm.modelSettings}
{if $type=="edit"}
	{assign var="flg_amazon" value="0"}
	{foreach from=$arrCnt key=k item=item}
		{if $item.flg_source == $i.flg_source}
		{assign var="flg_amazon" value="1"}
		<div class="panel panel-default m-b-20">
			<div class="panel-heading">
				<h3 class="panel-title pull-left">{$item.settings.affiliate}</h3>
				{if Core_Acs::haveAccess(array('AzonFunnels Agency'))}
				<a href="?delete={$item.id}" class="pull-right" style="font-size: 15px; color: #f00; margin-top: 5px;"><i class="ion-close-circled"></i></a>
				{/if}
			</div>
			<div class="panel-body">
				<input type="hidden" name="arrCnt[{$k}][id]" value="{$item.id}" />
				<input type="hidden" name="arrCnt[{$k}][flg_source]" value="{$i.flg_source}" />
				<input type="hidden" name="arrCnt[{$k}][settings][skip]" value="{Project_Content_Adapter_Amazon::NO_FOUND_IMAGES}" />
				<input type="hidden" name="arrCnt[{$k}][settings][length]" value="full" />
				<input type="hidden" name="arrCnt[{$k}][settings][template]" value="2" />
				<div class="form-group">
					<label>Amazon Affiliate ID: </label>
					<input size="40" type="text" name="arrCnt[{$k}][settings][affiliate]" value="{if !empty($item.settings.affiliate)}{$item.settings.affiliate}{/if}" alt="You have not written Amazon Affiliate ID." class="form-control"/>
					<a style="text-decoration:none" title="This option is not required but you will only earn affiliate commission if you enter your Amazon affiliate ID." class="Tips" ><b> ?</b></a>
				</div>
				<div class="form-group">
					<label>API Key (Access Key ID): {if $mode==1}<em>*</em>{/if}</label>
					<input size="40" class="required form-control" type="text" name="arrCnt[{$k}][settings][api_key]" value="{if !empty($item.settings.api_key)}{$item.settings.api_key}{/if}" alt="You have not written Access Key ID."/>
					<a href="https://affiliate-program.amazon.settings.com/gp/advertising/api/detail/main.html" style="text-decoration:none" class="Tips" title="This setting is required for the Amazon module to work!<br/><b>Click to get to the Amazon API sign up page!</b>" target="_blank" ><b> ?</b></a>
				</div>		
				<div class="form-group">
					<label>Secret Access Key: {if $mode==1}<em>*</em>{/if}</label>
					<input size="40" class="required form-control" type="text" name="arrCnt[{$k}][settings][secret_key]" value="{if !empty($item.settings.secret_key)}{$item.settings.secret_key}{/if}" alt="You have not written Secret Access Key."/>
					<a style="text-decoration:none" class="Tips" title="You can find this key under 'Access Identifiers' in your Product Advertising API account."><b> ?</b></a>
				</div>
				<div class="form-group">
					<label>Amazon Website: {if $mode==1}<em>*</em>{/if}</label>
						<select class="required validate-custom-required btn-group selectpicker show-tick" name="arrCnt[{$k}][settings][site]" alt="You have not chosen Amazon Website.">
							<option value="0" {if empty($item.settings.site)}selected="selected"{/if}> - select - </option>
							<option value="US" {if !isset($item.settings.site) || $item.settings.site == "US"||Core_Acs::haveAccess( 'Zonterest LIGHT' )}selected="selected"{/if}>Amazon.com</option>
							{if !Core_Acs::haveAccess( 'Zonterest LIGHT' )}
							<option value="UK" {if $item.settings.site == "UK"}selected="selected"{/if}>Amazon.co.uk</option>
							<option value="DE" {if $item.settings.site == "DE"}selected="selected"{/if}>Amazon.de</option>
							<option value="CA" {if $item.settings.site == "CA"}selected="selected"{/if}>Amazon.ca</option>
							<option value="JP" {if $item.settings.site == "JP"}selected="selected"{/if}>Amazon.jp</option>
							<option value="FR" {if $item.settings.site == "FR"}selected="selected"{/if}>Amazon.fr</option>
							<option value="IT" {if $item.settings.site == "IT"}selected="selected"{/if}>Amazon.it</option>
							<option value="ES" {if $item.settings.site == "ES"}selected="selected"{/if}>Amazon.es</option>
							<option value="CN" {if $item.settings.site == "CN"}selected="selected"{/if}>Amazon.cn</option>
							<option value="BR" {if $item.settings.site == "BR"}selected="selected"{/if}>Amazon.com.br</option>
							<option value="IN" {if $item.settings.site == "IN"}selected="selected"{/if}>Amazon.in</option>
							<option value="MX" {if $item.settings.site == "MX"}selected="selected"{/if}>Amazon.com.mx</option>
							{/if}
						</select>
				</div>
				<div class="form-group">
					{if Core_Acs::haveAccess( array( 'AzonFunnels Agency' ) )}
					<input type="hidden" name="arrCnt[{$k}][flg_default]" value="0" />
					<div class="checkbox checkbox-primary">
						<input type="checkbox" id="flg_default-{$k}" class="default" name="arrCnt[{$k}][flg_default]" value="1" {if $item.flg_default}checked=""{/if} />
						<label for="flg_default-{$k}">Default Facebook Bot & Twilio</label>
					</div>
					{else}
					<input type="hidden" name="arrCnt[{$k}][flg_default]" value="1" />
					{/if}
				</div>
			</div>
		</div>
		{/if}
	{/foreach}
	{if $flg_amazon === "0"}
	<div class="panel panel-default m-b-20">
		<div class="panel-heading">
			<h3 class="panel-title pull-left">New Setting</h3>
			{if Core_Acs::haveAccess(array('AzonFunnels Agency'))}
			<a href="?delete={$item.id}" class="pull-right" style="font-size: 15px; color: #f00; margin-top: 5px;"><i class="ion-close-circled"></i></a>
			{/if}
		</div>
		<div class="panel-body">
			<input type="hidden" name="arrCnt[0][flg_source]" value="{$i.flg_source}" />
			<input type="hidden" name="arrCnt[0][settings][skip]" value="{Project_Content_Adapter_Amazon::NO_FOUND_IMAGES}" />
			<input type="hidden" name="arrCnt[0][settings][length]" value="full" />
			<input type="hidden" name="arrCnt[0][settings][template]" value="2" />
			<div class="form-group">
				<label>Amazon Affiliate ID: </label>
				<input size="40" type="text" name="arrCnt[0][settings][affiliate]" value="" alt="You have not written Amazon Affiliate ID." class="form-control"/>
				<a style="text-decoration:none" title="This option is not required but you will only earn affiliate commission if you enter your Amazon affiliate ID." class="Tips" ><b> ?</b></a>
			</div>
			<div class="form-group">
				<label>API Key (Access Key ID): {if $mode==1}<em>*</em>{/if}</label>
				<input size="40" class="required form-control" type="text" name="arrCnt[0][settings][api_key]" value="" alt="You have not written Access Key ID."/>
				<a href="https://affiliate-program.amazon.settings.com/gp/advertising/api/detail/main.html" style="text-decoration:none" class="Tips" title="This setting is required for the Amazon module to work!<br/><b>Click to get to the Amazon API sign up page!</b>" target="_blank" ><b> ?</b></a>
			</div>		
			<div class="form-group">
				<label>Secret Access Key: {if $mode==1}<em>*</em>{/if}</label>
				<input size="40" class="required form-control" type="text" name="arrCnt[0][settings][secret_key]" value="" alt="You have not written Secret Access Key."/>
				<a style="text-decoration:none" class="Tips" title="You can find this key under 'Access Identifiers' in your Product Advertising API account."><b> ?</b></a>
			</div>
			<div class="form-group">
				<label>Amazon Website: {if $mode==1}<em>*</em>{/if}</label>
					<select class="required validate-custom-required btn-group selectpicker show-tick" name="arrCnt[0][settings][site]" alt="You have not chosen Amazon Website.">
						<option value="0"> - select - </option>
						<option value="US" {if Core_Acs::haveAccess( 'Zonterest LIGHT' )}selected="selected"{/if}>Amazon.com</option>
						{if !Core_Acs::haveAccess( 'Zonterest LIGHT' )}
						<option value="UK">Amazon.co.uk</option>
						<option value="DE">Amazon.de</option>
						<option value="CA">Amazon.ca</option>
						<option value="JP">Amazon.jp</option>
						<option value="FR">Amazon.fr</option>
						<option value="IT">Amazon.it</option>
						<option value="ES">Amazon.es</option>
						<option value="CN">Amazon.cn</option>
						<option value="BR">Amazon.com.br</option>
						<option value="IN">Amazon.in</option>
						<option value="MX">Amazon.com.mx</option>
						{/if}
					</select>
			</div>
			<div class="form-group">
				{if Core_Acs::haveAccess( array( 'AzonFunnels Agency' ) )}
				<input type="hidden" name="arrCnt[0][flg_default]" value="0" />
				<div class="checkbox checkbox-primary">
					<input type="checkbox" id="flg_default-0" class="default" name="arrCnt[0][flg_default]" value="1" />
					<label for="flg_default-0">Default Facebook Bot & Twilio</label>
				</div>
				{else}
				<input type="hidden" name="arrCnt[0][flg_default]" value="1" />
				{/if}
			</div>
		</div>
	</div>
	{/if}
{else}
	{foreach from=$arrCnt item=item}
		{if $i.flg_source == $item.flg_source && $item.flg_default}
		<input type="hidden" name="arrCnt[{$i.flg_source}][id]" value="{if !empty($item.id)}{$item.id}{/if}" />
		<input type="hidden" name="arrCnt[{$i.flg_source}][settings][affiliate]" value="{if !empty($item.settings.affiliate)}{$item.settings.affiliate}{/if}" />
		<input type="hidden" name="arrCnt[{$i.flg_source}][settings][api_key]" value="{if !empty($item.settings.api_key)}{$item.settings.api_key}{/if}" />
		<input type="hidden" name="arrCnt[{$i.flg_source}][settings][secret_key]" value="{if !empty($item.settings.secret_key)}{$item.settings.secret_key}{/if}" />
		<input type="hidden" name="arrCnt[{$i.flg_source}][settings][site]" value="{if !isset($item.settings.site) || $item.settings.site == 'US'||Core_Acs::haveAccess( 'Zonterest LIGHT' )}US{else}{$item.settings.site}{/if}" />	
		<input type="hidden" name="arrCnt[{$i.flg_source}][settings][length]" value="full" />
		<input type="hidden" name="arrCnt[{$i.flg_source}][settings][template]" value="2" />
		<div class="form-group">
			<input type="hidden" name="arrPrj[settings][skip]" value="{Project_Content_Adapter_Amazon::NO_FOUND_DESCRIPTION}" checked="checked" />
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="arrPrj[settings][skip]" value="{Project_Content_Adapter_Amazon::NO_FOUND_IMAGES}"{if !empty($smarty.get.arrPrj.settings.skip) && $smarty.get.arrPrj.settings.skip==Project_Content_Adapter_Amazon::NO_FOUND_IMAGES} checked="checked"{/if} />
				<label>Include products without description</label>
			</div>
		</div>
		{/if}
	{/foreach}
{/if}
{if $mode==1}
<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{/if}" alt="You have not written Keywords."/>
</div>
<div class="form-group">
	<label>ASIN (you can add multiple ASIN numbers, separated by comma): </label>
	<input size="40" class="form-control" type="text" name="arrCnt[{$i.flg_source}][settings][asin]" value="{if !empty($arrCnt.{$i.flg_source}.settings.asin) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.asin}{/if}" />
</div>{/if}
{if $type=="edit" && Core_Acs::haveAccess(array('AzonFunnels Agency'))}
<div class="form-group">
	<button class="btn btn-success waves-effect waves-light" id="new_setting">New Setting</button>
</div>
{/if}
{literal}
<script type="text/javascript">
	SourceTypeObject[9] = new Class({
		Extends: SourceObject,
		initialize: function(){
			this.source_id = 9;
		}
	});

	if( jQuery( '.panel-title.pull-left + a' ).length == 1 ) {
		jQuery( '.panel-title.pull-left + a' ).remove();
	}
	jQuery( '#new_setting' ).on( 'click', function(e){
		e.preventDefault();
		var index = jQuery( '.panel' ).eq( jQuery( '.panel' ).length - 1 ).find( '.default' ).prop( 'name' ).match(/arrCnt\[(.*)\]\[flg_default\]/);
		index = parseInt( index[1] ) + 1;
		jQuery( '.panel' ).eq( jQuery( '.panel' ).length - 1 ).after(
			'<div class="panel panel-default m-b-20">' +
					'<div class="panel-heading">' +
						'<h3 class="panel-title pull-left">New Setting</h3>' +
						'<a href="#" class="pull-right new_setting" style="font-size: 15px; color: #f00; margin-top: 5px;"><i class="ion-close-circled"></i></a>' +
					'</div>' +
					'<div class="panel-body">' +
						'<input type="hidden" name="arrCnt[' + index + '][flg_source]" value="{/literal}{$i.flg_source}{literal}" />' +
						'<input type="hidden" name="arrCnt[' + index + '][settings][skip]" value="{/literal}{Project_Content_Adapter_Amazon::NO_FOUND_IMAGES}{literal}" />' +
						'<input type="hidden" name="arrCnt[' + index + '][settings][length]" value="full" />' + 
						'<input type="hidden" name="arrCnt[' + index + '][settings][template]" value="2" />' +
						'<div class="form-group">' +
							'<label>Amazon Affiliate ID: </label>' +
							'<input size="40" type="text" name="arrCnt[' + index + '][settings][affiliate]" value="" alt="You have not written Amazon Affiliate ID." class="form-control"/>' +
							'<a style="text-decoration:none" title="This option is not required but you will only earn affiliate commission if you enter your Amazon affiliate ID." class="Tips" ><b> ?</b></a>' +
						'</div>' +
						'<div class="form-group">' +
							'<label>API Key (Access Key ID): {/literal}{if $mode==1}<em>*</em>{/if}{literal}</label>' +
							'<input size="40" class="required form-control" type="text" name="arrCnt[' + index + '][settings][api_key]" value="" alt="You have not written Access Key ID."/>' +
							'<a href="https://affiliate-program.amazon.settings.com/gp/advertising/api/detail/main.html" style="text-decoration:none" class="Tips" title="This setting is required for the Amazon module to work!<br/><b>Click to get to the Amazon API sign up page!</b>" target="_blank" ><b> ?</b></a>' +
						'</div>' +		
						'<div class="form-group">' +
							'<label>Secret Access Key: {/literal}{if $mode==1}<em>*</em>{/if}{literal}</label>' +
							'<input size="40" class="required form-control" type="text" name="arrCnt[' + index + '][settings][secret_key]" value="" alt="You have not written Secret Access Key."/>' +
							'<a style="text-decoration:none" class="Tips" title="You can find this key under \'Access Identifiers\' in your Product Advertising API account."><b> ?</b></a>' +
						'</div>' +
						'<div class="form-group">' +
							'<label>Amazon Website: {/literal}{if $mode==1}<em>*</em>{/if}{literal}</label>' +
								'<select class="required validate-custom-required btn-group selectpicker show-tick m-l-5" data-style="btn-info" name="arrCnt[' + index + '][settings][site]" alt="You have not chosen Amazon Website.">' +
									'<option value="0"> - select - </option>' +
									'<option value="US">Amazon.com</option>' +
									{/literal}{if !Core_Acs::haveAccess( 'Zonterest LIGHT' )}{literal}
									'<option value="UK">Amazon.co.uk</option>' +
									'<option value="DE">Amazon.de</option>' +
									'<option value="CA">Amazon.ca</option>' +
									'<option value="JP">Amazon.jp</option>' +
									'<option value="FR">Amazon.fr</option>' +
									'<option value="IT">Amazon.it</option>' +
									'<option value="ES">Amazon.es</option>' + 
									'<option value="CN">Amazon.cn</option>' + 
									'<option value="BR">Amazon.com.br</option>' +
									'<option value="IN">Amazon.in</option>' +
									'<option value="MX">Amazon.com.mx</option>' +
									{/literal}{/if}{literal}
								'</select>' +
						'</div>' +
						'<div class="form-group">' +
							'<input type="hidden" name="arrCnt[' + index + '][flg_default]" value="0" />' +
							'<div class="checkbox checkbox-primary">' +
								'<input type="checkbox" id="flg_default-' + index + '" class="default" name="arrCnt[' + index + '][flg_default]" value="1" />' +
								'<label for="flg_default-' + index + '">Default Facebook Bot & Twilio</label>' +
							'</div>' +
						'</div>' +
					'</div>' +
				'</div>'
		);
		jQuery( '.selectpicker' ).selectpicker( 'refresh' );
		jQuery( '.new_setting' ).off( 'click' ).on( 'click', function(){
			jQuery( this ).parent().parent().remove();
			return false;
		} );
		return false;
	} );
	
	jQuery( '.default' ).off( 'change' ).on( 'change', function(){
		jQuery( '.default' ).prop( 'checked', false );
		jQuery( this ).prop( 'checked', true );
	} );
	jQuery( '.default' ).on( 'change', function(){
		jQuery( '.default' ).prop( 'checked', false );
		jQuery( this ).prop( 'checked', true );
	} );
</script>
{/literal}