<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<span id="waite_creation" class="grn" style="display:none;">We're generating your Amazon Affiliate Website, adding content and scheduling new content publishing. Hold on, you will get your website URL in a few seconds!</span>
	<span id="waite_creation_download" class="grn" style="display:none;">We're generating your Amazon Affiliate Website. It all will be ready in a few seconds.</span>
	<span id="end_creation" class="grn" style="display:none;">Process is finished and you can view the site:</span>
	<span id="end_creation_download" class="grn" style="display:none;">Process is finished and you can download the site:</span>
	<span id="end_warning" class="red" style="display:none;">There is few content on Amazon related to the keyword(s) you specified for the site. You might want to create a new content project with a different keyword to make sure your site is updated with new content regularly.</span>
	<span id="ajax_errors" class="red" style="display:none;"></span>
{if isset($arrErr)}
	{if $arrErr.errFlow.0=='empty_settings'}
	<span class="red">Please fill in your personal details in Amazon <a href="{url name='site1_publisher' action='source_settings'}" target="_blank">Source Settings</a> to enable the Wizard. </span>
	{else}
		{if $arrErr.errFlow.0=='empty_credits'}
		<span class="red">You don't have enough credits on your balance for this project. You can purchase additional credits</span> <a href="{url name='site1_accounts' action='payment'}" target="_blank">here</a>.
		{/if}
	{/if}
{/if}
{if !isset($arrErr) || isset($arrData) }
<form method="post" action="" class="wh validate" id="post_form">
	<input type="hidden" name="arrData[type]" id="arr_data_type" value="{Project_Wizard_Domain_Rules::R_ZONTEREST}"  />
	<input type="hidden" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestLight::DOWNLOAD}" />
	<!-- start step 2 -->
	<div id="hosting_settings" style="display:none;">
		{module name='site1_hosting' action='select' arrayName='arrData'}
	</div>
	<fieldset id="step2" style="display:block;">
		<legend>Select category and main keyword</legend>
		<p style="display:none;">
			<label>Select Marketplace <em>*</em></label>
			<select name="arrData[marketplacedomain]" class="required medium-input" id="marketplacedomain" >
				<option value="Amazon">Amazon</option>
			</select>
		</p>
		<p style="display:none;">
			<label>Amazon Website <em>*</em></label>
			<select name="arrData[site]" id="country"  class="required medium-input">
				<option value="US" {if $settings.site == "US"||Core_Acs::haveAccess( 'Zonterest LIGHT' )}selected="selected"{/if}>Amazon.com</option>
			</select>
		</p>
		<p>
			<label>Category <em>*</em></label>
			<select name="arrData[category]" id="category" disabled="1"  class="required medium-input"></select>
		</p>
		<p>
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword][]" type="text" id="main_keyword" value="{$arrData.main_keyword}" class="main_keywords required text-input  medium-input"/> <a href="#" style="display: none; font-size: 24px;" id="multi-keywords">+</a>
		</p>
		<p id="social">
			<label></label>
			<input type="checkbox" value="1" name="arrData[promotion]" id="promotion" /> Create Social Signals
		</p>
		<p>
			<input type="button" id="step2-next" value="Step 3" class="button" {is_acs_write} />
		</p>
	</fieldset>
	<!-- end step 2 -->

	<div align="center">
		<img id="ajax_loader" src="/skin/i/frontends/design/ajax-loader-big.gif" style="display:none; margin: 20px 0 0 0;">
	</div>

	<!-- start step 3 -->
	<div id="step3"{if !isset($arrData)} style="display:none;"{/if}>
		<fieldset>
			<legend>Select Domain</legend>
			<fieldset id="domains"></fieldset>
			<label><img id="ajax_loader_small" src="/skin/i/frontends/design/ajax_loader_line.gif" style="display:none;"></label>
		</fieldset>
		<p><a href="#" id="more_domains"style="{if isset($arrData)} display:none;{/if}padding:3px;">Suggest more</a></p>
		<fieldset>
			<p>
				<label>Or you may also enter any domain name you want to register</label>
				<input type="text" name="arrData[domain_text]" id="domain_text" value="{$arrData.domain_http}" style="width:200px;"><input type="button" id="check_domein" value="check">
			</p>
			<p>
				<label>
				<span id="domain_check_wait" style="display:none;">Please wait..</span>
				<span class="grn" id="domain_available" style="display:none;">Available</span>
				<span class="red" id="domain_notavailable" style="display:none;">Not Available</span></label>
			</p>
			<p>
				<input type="button" id="submit_button" value="Voila" class="button" {is_acs_write} >
			</p>
		</fieldset>
	</div>
	<!-- end step 3 -->
</form>
{/if}

<script type="text/javascript">
var marketplaceDomain='{Project_Content_Adapter_Amazon::$marketplaceDomain|json}';
{literal}
var ZonterestLIGHT=new Class({

	initialize: function(){
		this.step1();
		this.moreDomainsJson = null;
	},
	step1: function(){
		this.download=true;
		this.initDownload();
		this.initStep2Download();
		this.initSubmit();
	},
	initDownload: function(){
		this.download=true;
		this.initCategory();
		$('step2-next').set('value','Voila');
		$('step2').setStyle('display','block');
		$('social').setStyle('display','none');
		$('multi-keywords').setStyle('display','none');
	},
	initCategory: function(){
		this.selectCategory();
		$('country').addEvent('change',function(){
			this.selectCategory();
		}.bind(this));
		this.initPlace();
	},
	initPlace: function(){
		$('marketplacedomain').addEvent('change', function(){
			var places=JSON.decode(marketplaceDomain);
			$('country').empty();
			new Element('option[value=""][html="-select-"]').inject($('country'));
			Object.each(places[this.value],function(name,key){
				new Element('option[value="'+key+'"][html="'+name+'"]').inject($('country'));
			});
		});
	},
	selectCategory: function(){
		if( $('country').get('value')=='' ){
			$('category').disabled=true;
			$('category').getChildren().each(function(option){
				option.destroy();
			});
			return;
		}
		var place=($('marketplacedomain').get('value')=='Amazon')?'':$('marketplacedomain').get('value');
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
			}
		}).post({'country':place+$('country').get('value')});
	},
	initStep2Download: function(){
		$('step2-next').addEvent('click',function(){
			$('submit_button').fireEvent('click');
		});
	},
	initSubmit: function(){
		var self=this;
		$('submit_button').addEvent('click',function(elt){
			if( validator.checker.validate() ){
				new Request({
					url: "{/literal}{url name='site1_wizard' action='zonterestlight'}{literal}",
					onRequest: function(){
						$('ajax_errors').empty().hide();
						$('step3').hide();
						$('step2').hide();
						$('hosting_settings').hide();
						if( self.download==true ){
							$('waite_creation_download').show("inline");
						} else {
							$('waite_creation').show("inline");
						}
						$('ajax_loader').show("block");
					},
					onSuccess: function(response){
						response=JSON.decode(response);
						if( self.download==true ){
							$('waite_creation_download').hide();
						} else {
							$('waite_creation').hide();
						}
						if( response.result==true ){
							if( self.download==true ){
								$('end_creation_download').show('block');
								new Element('br').inject($('end_creation_download'));
								new Element('br').inject($('end_creation_download'));
								new Element('a',{href:response.domain,html:'download',target:'_blank'}).inject($('end_creation_download'));
							} else {
								$('end_creation').show('block');
								new Element('br').inject($('end_creation'));
								new Element('br').inject($('end_creation'));
								new Element('a',{href:response.domain,html:response.domain,target:'_blank'}).inject($('end_creation'));
							}
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
		});
	}

});
var moreDomainsJson = null;
window.addEvent('domready', function(){
	new ZonterestLIGHT();
});
</script>
{/literal}
</div>
</body>
</html>