<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<span id="waite_creation" class="grn" style="display:none;">We're generating your Clickbank Affiliate Website, adding content and scheduling new content publishing. It all will be ready in a few seconds.You can close the popup now.</span>
	<span id="end_creation" class="grn" style="display:none;">Process is finished and you can view the site:</span>
	<span id="end_warning" class="red" style="display:none;">There is few content on Clickbank related to the keyword(s) you specified for the site. You might want to create a new content project with a different keyword to make sure your site is updated with new content regularly.</span>
	<span id="ajax_errors" class="red" style="display:none;"></span>
	{if isset($arrErr)}
		{if $arrErr.errFlow.0=='empty_settings'}
		<span class="red">Please fill in your personal details in Clickbank <a href="{url name='site1_publisher' action='source_settings'}" target="_blank">Source Settings</a> to enable the Wizard. </span>
		{else}
			{if $arrErr.errFlow.0=='empty_credits'}
			<span class="red">You don't have enough credits on your balance for this project. You can purchase additional credits</span> <a href="{url name='site1_accounts' action='payment'}" target="_blank">here</a>.
			{/if}
		{/if}
	{/if}
	{if !isset($arrErr) || isset($arrData) }
	<form method="post" action="" class="wh validate" id="post_form">
	<input type="hidden" name="arrData[type]" value="{Project_Wizard_Domain_Rules::R_CLICKBANK}"  />
	<fieldset id="first_step">
		<legend>Step 1:</legend>
		{*<legend>Select language, category and main keyword</legend>*}
		<legend>Select  category and main keyword</legend>
		<p style="display: none;">
			<label>Language<em>*</em></label>
			<select name="arrData[flg_language]" id="language"  class="required medium-input">
				<option value="">-select-</option>
				{foreach from=Core_Language::$flags item=flags key=lang_id}
					<option {if $settings.flg_language==$lang_id} selected="selected" {/if} value="{$lang_id}">{$flags.title}</option>
				{/foreach}
			</select>
		</p>
		<p>
			<label>Category <em>*</em></label>
			<select name="arrData[category_pid]" id="category_clickbank"  class="required medium-input"></select>
			<select name="arrData[category_id]" id="category_clickbank_child"   class="medium-input"></select>
		</p>
		<p>
			<label><span>Search tags </span></label>
			<input name="arrData[tags]" type="text" value="{$arrData.tags}" class="medium-input"/>
		</p><p>
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword]" type="text" id="main_keyword" value="{$arrData.main_keyword}" class="required medium-input"/>
		</p>
		<p>
			<input type="button" id="step_button" value="Step 2" class="button" {is_acs_write} >
		</p>
	</fieldset>
	<div align="center"><img id="ajax_loader" src="/skin/i/frontends/design/ajax-loader-big.gif" style="display:none;"></div>
	<div id="second_step"{if !isset($arrData)} style="display:none;"{/if}>
	<fieldset>
		<legend>Step 2: Select Domain</legend>
		<fieldset id="domains">
		</fieldset>
		<label><img id="ajax_loader_small" src="/skin/i/frontends/design/ajax_loader_line.gif" style="display:none;"></label>
	</fieldset>
	<legend><a href="#" id="more_domains"style="{if isset($arrData)} display:none;{/if}padding:3px;">Suggest more</a></legend>
	<fieldset>
		<legend></legend>
		<p>
			<label>Or you may also enter any domain name you want to register</label>
			<input type="text" name="arrData[domain_text]" class="small-input text-input" id="domain_text" value="{$arrData.domain_http}" style="width:200px;"><input type="button" class="button" id="check_domein" value="check">
		</p>
		<p>
			<label>
			<span id="domain_check_wait" style="display:none;">Please wait..</span>
			<span class="grn" id="domain_available" style="display:none;">Available</span>
			<span class="red" id="domain_notavailable" style="display:none;">Not Available</span></label>
		</p>
		<p>
			<input type="hidden" name="arrData[thumb]" value="1,2">
			<input type="button" id="submit_button" value="Voila" class="button" {is_acs_write}>
		</p>
	</fieldset>
	</div>
	</form>
	{/if}

<script type="text/javascript">
var jsonCategoryClickbank = {$arrCatTree|json|default:'null'};
{literal}
var moreDomainsJson = null;
window.addEvent('domready', function(){
	var ClickbankLanguage = new CategoriesSelects({
		language: 'language',
		category_parent: 'category_clickbank',
		category_child: 'category_clickbank_child',
		optionName1:'-select-',
		optionName2:'-All-',
		post_settings: {'action':'get_category'}, // post action
		request_url: '{/literal}{url name="content_clickbank" action="ajax_get" wg="withthumb=1,2"}{literal}', // request url
		selected: { // ids of selected elements
			parent_id : '{/literal}{$settings.category_pid}{literal}',
			child_id : '{/literal}{$settings.category_id}{literal}'
		}
		});
	var ClickbankSelects = new Categories({
		firstLevel:'category_clickbank',
		secondLevel:'category_clickbank_child',
		optionName1:'-select-',
		optionName2:'-All-',
		intCatId: {/literal}{$settings.category_id|default:'null'}{literal},
		jsonTree: jsonCategoryClickbank
	});
	$('step_button').addEvent('click',function(){
		if( validator.checker.validate() ){
			$('second_step').hide();
			$('first_step').hide();
			$('domain_text').value='';
			new Request.JSON({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				headers:{'X-Request':'JSON'},
				onRequest: function(){
					$('ajax_loader').style.display="block";
				},
				onSuccess: function(responseJson,text){
					$('domains').empty();
					Object.each( responseJson, function(arrData, key, object){
						if( key == 'x8' || key == 'x12' ){
							wizardObjectTable( arrData );
						}else{
							moreDomainsJson=arrData;
						}
					});
				}
			}).post($('post_form'));
		}
	});

	function wizardObjectTable( elt ){
		Object.each( elt, function(data, i, obj){
			var requestObjects=new Request({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				onSuccess: function(responseFlag){
					if( responseFlag=='true' ){
						new Element( 'label' )
							.grab( new Element( 'input[type="radio"][name="arrData[domain_http]"][class="select_domain"]' ).set('value',data) )
							.appendText( " "+data )
							.inject( $('domains') );
						$('second_step').show('inline');
						$('submit_button').disabled=false;
						$('ajax_loader').hide();
					}
				},
				onRequest: function(){
					$('ajax_loader_small').show('inline');
				},
				onComplete: function(){
					$('ajax_loader_small').hide();
				}
			}).post({'domenCheck':data});
		});
	}

	$('more_domains').addEvent('click',function(){
		wizardObjectTable( moreDomainsJson );
		$('more_domains').hide();
	});

	$('main_keyword').addEvent('change',function(){
		$('second_step').hide();
	});

	$('submit_button').addEvent('click',function(elt){
		if( validator.checker.validate() ){
			new Request({
				url: "{/literal}{url name='site1_wizard' action='clickbank'}{literal}",
				onRequest: function(){
					$('ajax_errors').empty().hide();
					$('second_step').hide();
					$('first_step').hide();
					$('waite_creation').show("inline");
					$('ajax_loader').show("block");
				},
				onSuccess: function(response){
					response=JSON.decode(response);
					$('waite_creation').hide();
					if( response.result==true ){
						$('end_creation').show('block');
						new Element('br').inject($('end_creation'));
						new Element('br').inject($('end_creation'));
						new Element('a',{href:response.domain,html:response.domain,target:'_blank'}).inject($('end_creation'));
						if(response.contentCount<10){
							$('end_warning').show('block');
						}
					}else{
						$('ajax_errors').set('html',response.error).show("inline");
						$('second_step').show('inline');
					}
					$('ajax_loader').hide();
				}
			}).post($('post_form'));
		}
	});

	$('domain_text').addEvent('change',function(){
		$$('.select_domain').each(function(e){e.checked=false;});
	});

	$('check_domein').addEvent('click',function(){
		$('domain_available').hide();
		$('domain_notavailable').hide();
		$$('.select_domain').each(function(e){e.checked=false;});
		if( $('domain_text').value == '' ){
			return;
		}
		$('domain_check_wait').show('block');
		new Request({
			url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
			onSuccess: function(responseFlag){
				$('domain_check_wait').hide();
				if( responseFlag=='true' ){
					$('domain_available').show('block');
				}else{
					$('domain_notavailable').show('block');
				}
			}
		}).post({'domenCheck':$('domain_text').value});
	});
});

</script>
{/literal}
</div>
</body>
</html>