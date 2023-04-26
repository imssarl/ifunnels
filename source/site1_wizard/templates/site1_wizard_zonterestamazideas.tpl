<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content" class="card-box">
	<span id="waite_creation" class="grn" style="display:none;">We're generating your Amazon Affiliate Website, adding content and scheduling new content publishing. Hold on, you will get your website URL in a few seconds!</span>
	<span id="end_creation" class="grn" style="display:none;">Process is finished and you can view the site:</span>
	<span id="end_warning" class="red" style="display:none;">There is few content on Amazon related to the keyword(s) you specified for the site. You might want to create a new content project with a different keyword to make sure your site is updated with new content regularly.</span>
	<span id="ajax_errors" class="red" style="display:none;"></span>
	{if isset($arrErr)}
		{if $arrErr.errFlow.0=='empty_settings'}
		<span class="red">Please fill in your personal details in Amazon <a href="{url name='site1_publisher' action='source_settings'}" target="_blank">Source Settings</a> to enable the Wizard. </span>
		{else}
			{if $arrErr.errFlow.0=='empty_credits'}
			<span class="red">You don't have enough credits on your balance for this project. You can purchase additional credits</span> <a href="{url name='site1_accounts' action='payment'}" target="_blank">here</a>.
			{/if}
			{if $arrErr.errFlow.0=='site_limit'}
			<span class="red">You don't have enough site limits on your balance for this project.
			{/if}
		{/if}
		<input type="hidden" value="{serialize($arrErr)}">
		
	{/if}
	{if !isset($arrErr) || isset($arrData) }
	<form method="post" action="" class="wh validate" id="post_form">
	<input type="hidden" name="arrData[type]" value="{Project_Wizard_Domain_Rules::R_ZONTEREST}"  />
	<input type="hidden" name="arrData[flg_amazideas]" value="1"  />
	<fieldset id="first_step">
		<legend>Site Settings</legend>
		{if Core_Acs::haveAccess(array('AzonFunnels Agency'))}
		<div class="form-group">
			<label class="">Settings</label>
			<select name="arrData[setting]" class="required btn-group selectpicker show-tick">
			{foreach from=$arrSettings item=item}
				<option value="{$item.id}"{if $item.flg_default == 1} selected="selected"{/if}>{$item.settings.affiliate}</option>
			{/foreach}
			</select>
		</div>
		{else}
		<input type="hidden" name="arrData[setting]" value="{$setting_id}" />
		{/if}
		<legend>Select {*category and *}main keyword</legend>
		<input type="hidden" id="country" value="{if isset( $settings.site )}{$settings.site}{else}US{/if}" name="arrData[site]">
		{*<div class="form-group">
			<label>Amazon Website <em>*</em></label>
			<select name="arrData[site]" class="required medium-input btn-group selectpicker show-tick">
				<option value="">-select-</option>
				<option value="US" {if $settings.site == "US"}selected="selected"{/if}>Amazon.com</option>
				<option value="UK" {if $settings.site == "UK"}selected="selected"{/if}>Amazon.co.uk</option>
				<option value="DE" {if $settings.site == "DE"}selected="selected"{/if}>Amazon.de</option>
				<option value="CA" {if $settings.site == "CA"}selected="selected"{/if}>Amazon.ca</option>
				<option value="JP" {if $settings.site == "JP"}selected="selected"{/if}>Amazon.jp</option>
				<option value="FR" {if $settings.site == "FR"}selected="selected"{/if}>Amazon.fr</option>
				<option value="IT" {if $settings.site == "IT"}selected="selected"{/if}>Amazon.it</option>
				<option value="ES" {if $settings.site == "ES"}selected="selected"{/if}>Amazon.es</option>
				<option value="CN" {if $settings.site == "CN"}selected="selected"{/if}>Amazon.cn</option>
			</select>
		</div>*}
		<div class="form-group">
			<label>Category <em>*</em></label>
			<select name="arrData[category]" id="category" disabled="1"  class="required medium-input btn-group selectpicker show-tick"></select>
		</div>
		<div class="form-group">
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword][]" type="text" id="main_keyword" value="{$arrData.main_keyword}" class="required medium-input form-control"/>
			{if Core_Acs::haveAccess( array('Zonterest PRO 2.0', 'Zonterest Custom 2.0') )}
			<a href="#" style="font-size: 24px;" id="multi-keywords">+</a>
			{/if}
		</div>
		<div class="form-group">
			<button type="button" id="step_button" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Create Site</button>
		</div>
	</fieldset>
	<div align="center"><img id="ajax_loader" src="/skin/i/frontends/design/ajax-loader-big.gif" style="display:none;"></div>
			<fieldset id="domains" class="hidden"></fieldset>
	</form>
	
{literal}
<script>
var moreDomainsJson = null;
window.addEvent('domready', function(){
	{/literal}{if Core_Acs::haveAccess( array('Zonterest PRO 2.0', 'Zonterest Custom 2.0') )}{literal}
	$('multi-keywords').addEvent('click',function(e){
		e.stop();
		if( $$('.main_keywords_block').length==9 ){
			$('multi-keywords').hide();
			return;
		}
		var p=new Element('p',{class:'main_keywords_block'});
		var input=new Element('input',{type:'text',name:'arrData[main_keyword][]',class:'main_keywords medium-input text-input form-control'})
				.inject(p.inject($('multi-keywords').getParent(),'after'));
		var a = new Element('a',{ href:'#', class:'delete-keyword',html:' -' }).setStyles({'font-size':'20px'}).inject(p);
		jQuery('.selectpicker').selectpicker('refresh');
		a.addEvent('click',function(){
			$('multi-keywords').show();
			p.destroy();
		});
	}.bind(this));
	{/literal}{/if}{literal}
	
	var selectSite=function(){
		if($('country').get('value')==''){
			$('category').disabled=true;
			$('category').getChildren().each(function(option){
				option.destroy();
			});
			return;
	   }
		new Request.JSON({
			url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
			onSuccess: function(r){
				category=JSON.decode(r.treeJson);
				$('category').getChildren().each(function(option){
					option.destroy();
				});
				new Element('option',{value:'All',html:'All'}).inject($('category'));
				category.each(function(v){
					new Element('option',{value:v.title+'::'+ v.remote_id,html:v.title}).inject($('category'));
				});
				$('category').disabled=false;
				jQuery('#category').selectpicker('refresh');
			}
		}).post({'country':$('country').get('value')});
		jQuery('#category').selectpicker('refresh');
	};
	selectSite();
	
	$('step_button').addEvent('click',function(){
		if( validator.checker.validate() ){
			$('first_step').hide();
			new Request.JSON({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				headers:{'X-Request':'JSON'},
				onRequest: function(){
					$('ajax_loader').style.display="block";
				},
				onSuccess: function(responseJson,text){
					$('domains').empty();
					new Element( 'label' )
						.grab( new Element( 'input[type="hidden"][name="arrData[domain_http]"]' ).set('value',responseJson.domain_http) )
						.grab( new Element( 'input[type="hidden"][name="arrData[ftp_directory]"]' ).set('value',responseJson.ftp_directory) )
						.appendText( " "+responseJson.domain_url )
						.inject( $('domains') );
						if( validator.checker.validate() ){
							new Request({
								url: "{/literal}{url name='site1_wizard' action='zonterest'}{literal}",
								onRequest: function(){
									$('ajax_errors').empty().hide();
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
										response.domain.each(function(domain){
											new Element('a',{href:domain,html:domain,target:'_blank'}).inject($('end_creation'));
											new Element('br').inject($('end_creation'));
										});
										if(response.contentCount<10){
											$('end_warning').show('block');
										}
									}else{
										$('ajax_errors').set('html',response.error).show("inline");
									}
									$('ajax_loader').hide();
								}
							}).post($('post_form'));
						}
					$('ajax_loader').hide();
				}
			}).post($('post_form'));
		}
	});
});

</script>
	
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

    <script type="text/javascript">
        jQuery(document).ready(function($) {
            $('.counter').counterUp({
                delay: 100,
                time: 1200
            });
			$('.selectpicker').selectpicker({
			  	style: 'btn-info',
			  	size: 4
			});

			$('#category').change(function(){
				$('.selectpicker').selectpicker('refresh');
			});
            //$(".knob").knob();

        });
    </script>
{/literal}
	{/if}
</div>
</body>
</html>