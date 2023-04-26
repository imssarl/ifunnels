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
	<!-- start step 1 -->
	<fieldset id="step1">
		<legend>Select type</legend>
		<div class="form-group">
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestPro::NEW_DOMAIN}" />
				<label>I want to register a new domain and create a AzonFunnels website <a href="" class="tooltip" title="Hosted on AzonFunnels servers">?</a><br/></label>	
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestPro::EXIST_DOMAIN}" />
				<label>I already have a domain name I want to use <a href="" class="tooltip" title="Hosted on AzonFunnels servers">?</a></label>	
			</div>
			<div class="form-group">
				<label><a href="{url name='site1_hosting' action='addomain'}?flg_type=1" title="Add New domain">Import</a> your own custom domains (you still have {if empty( Core_Users::$info['hosting_limit'] )}no{else}{Core_Users::$info['hosting_limit']}{/if} custom domains you can import and host at no extra charge)</label>	
			</div>
			
			
			{if Core_Acs::haveAccess( array('email test group') )}
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestPro::AMAZIDEAS}" />
				<label>Create site in Amazideas.net</label>	
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestPro::MULTI_DOMAIN}" />
				<label>Mass Generate AzonFunnels Websites <a href="" class="tooltip" title="Domain names are automatically registered by our system and hosted on our servers">?</a></label>	
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestPro::DOWNLOAD}" />
				<label>I just need to generate and download a AzonFunnels website <a href="" class="tooltip"
			title="I will host it myself and use one of	my existing domain.<br/>
			I understand no new content will be added automatically beyond the initial 10 products.<br/>
			Price will be updated automatically to keep your website compliant<br/>
			provided you make the /datas/articles folder writable. These websites are not supported<br/>
			beyond download issues since we provide a full integrated service and we focus on<br/>
			supporting this service">?</a></label>	
			</div>
			{if Core_Acs::haveRight( ['wizard'=>['zonterest_subfolders']] )}
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ZonterestPro::SUBFOLDERS}" />
				<label>Create Sites in Subfolders <a href="" class="">?</a></label>	
			</div>
			{/if}
			{/if}
		</div>
		<div class="form-group">
			<button type="button" id="step1-next" class="button btn btn-success waves-effect waves-light">Step 2</button>
		</div>
	</fieldset>
	<!-- end step 1 -->

	<!-- start step 2 -->
	<div id="hosting_settings" style="display:none;">
		{module name='site1_hosting' action='select' arrayName='arrData'}
	</div>
	<div class="form-group" id="step2" style="display:none;">
		<legend>Select category and main keyword</legend>
		<div class="amazon-settings form-group">
			<label>Select Marketplace <em>*</em></label>
			<select name="arrData[marketplacedomain]" class="medium-input btn-group selectpicker show-tick" id="marketplacedomain" >
				<option value="Amazon">Amazon</option>
				<option value="Supply">Amazon Supply</option>
				<option value="Javari">Javari</option>
			</select>
		</div>
		<div class="amazon-settings form-group hidden">
			<label>Amazon Website <em>*</em></label>
			<select name="arrData[site]" id="country"  class="medium-input btn-group selectpicker show-tick">
				<option value="">-select-</option>
				<option value="US" {if $settings.site == "US" || empty( $settings.site )}selected="selected"{/if}>Amazon.com</option>
				<option value="UK" {if $settings.site == "UK"}selected="selected"{/if}>Amazon.co.uk</option>
				<option value="DE" {if $settings.site == "DE"}selected="selected"{/if}>Amazon.de</option>
				<option value="CA" {if $settings.site == "CA"}selected="selected"{/if}>Amazon.ca</option>
				<option value="JP" {if $settings.site == "JP"}selected="selected"{/if}>Amazon.jp</option>
				<option value="FR" {if $settings.site == "FR"}selected="selected"{/if}>Amazon.fr</option>
				<option value="IT" {if $settings.site == "IT"}selected="selected"{/if}>Amazon.it</option>
				<option value="ES" {if $settings.site == "ES"}selected="selected"{/if}>Amazon.es</option>
				<option value="CN" {if $settings.site == "CN"}selected="selected"{/if}>Amazon.cn</option>
			</select>
		</div>
		<div class="form-group">
			<label>Category: <em>*</em></label>
			<select name="arrData[category]" id="category" disabled="1"  class="medium-input btn-group selectpicker show-tick"></select>
		</div>
		<div class="form-group amazon-settings">
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword][]" type="text" id="main_keyword" value="{$arrData.main_keyword}" class="main_keywords text-input  medium-input form-control"/> <a href="#" style="display: none; font-size: 24px;" id="multi-keywords">+</a>
		</div>
		<div id="subdirs" style="display: none;" >
		<div class="form-group">
			<label>Site:</label>
			<select name="arrData[ncsb_site]"   class="medium-input btn-group selectpicker show-tick" id="ncsb-site">
				<option value="">-select site-</option>
				{html_options options=$arrSites}
			</select>
		</div>
		<legend>OR Enter keywords</legend>
		<div class="form-group">
			<label>Keyword: </label><input type="text" id="sub-main-keyword" name="arrData[main_keyword][]" class="text-input  medium-input form-control" /> <a href="#" style="display: none; font-size: 24px;" id="subdir-multi-keywords">+</a>
		</div>
		</div>
		<!--div class="form-group" id="social">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" value="1" name="arrData[promotion]" id="promotion" />
				<label>Create Social Signals</label>
			</div>
		</div-->
		<div id="promotion-block" style="display: none;">
			<div class="form-group">
				<label>Max promotions: <span class="text"></span> </label>
				<div style="clear:both;"></div>
				<div id="slider" class="slider_promotions" >
					<div class="knob"></div>
				</div>
				<input type="hidden" name="arrData[promoteCount]" value="22" />
			</div>
			<div class="form-group">
				<label>Automatic campaign submission:</label>
				<div class="radio radio-primary">
					<input type="radio" name="arrData[promote_flg_type]" value="0" />
					<label>one time</label>	
				</div>
				<div class="radio radio-primary">
					<input type="radio" name="arrData[promote_flg_type]" value="1" checked="1" />
					<label>once a week</label>	
				</div>
				<div class="radio radio-primary">
					<input type="radio" name="arrData[promote_flg_type]" value="2" />
					<label>once a month</label>	
				</div>
			</div>
		</div>
		<div class="form-group">
			<button type="button" id="step2-next" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Step 3</button>
		</div>
	</div>
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
			<div class="form-group">
				<button type="button" id="submit_button" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Voila</button>
			</div>
		</fieldset>
	</div>
	<!-- end step 3 -->
</form>
{/if}

<script type="text/javascript">
var marketplaceDomain='{Project_Content_Adapter_Amazon::$marketplaceDomain|json}';
{literal}
var objZonterestPRO=new Class({

	initialize: function(){
		this.step1();
		this.moreDomainsJson = null;
		this.initMOreDomainCheck();
		this.initPromotion();
	},
	step1: function(){
		this.download=false;
		$$('.type_create').each(function(element){
			element.addEvent('click',function(e){
				switch(element.get('value')){
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::NEW_DOMAIN}{literal}': this.initNewDomain(); this.initStep2NewDomain(); break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::EXIST_DOMAIN}{literal}': this.initExistingDomain(); this.initStep2ExistingDomain(); break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::AMAZIDEAS}{literal}': 
						this.initNewDomain(); 
						this.initStep2Amazideas();
					break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::MULTI_DOMAIN}{literal}': this.initMuliZonterest(); this.initStep2MuliZonterest(); break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::DOWNLOAD}{literal}': this.initDownload(); this.initStep2Download(); break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::SUBFOLDERS}{literal}': this.initSybfolders(); this.initStep2Sybfolders(); break;
				}
			}.bind(this));
		}, this);
		this.initSubmit();
	},
	initPromotion: function(){
		/* $('promotion').addEvent('click',function(){
			$('promotion-block').toggle();
		}); */
		var slider=new Slider( $('slider'), $('slider').getElement('.knob'), {
			steps: 100,
			initialStep: $('slider').getNext('input').get('value'),
			onChange: function(value){
				if (value) {
					$('slider').getNext('input').set('value', value);
					$('slider').getPrevious('label').getElement('span.text').set('html', value);
				}
			}
		});
	},
	initNewDomain: function(){
		this.initCategory();
		$('step1-next').addEvent('click',function(){
			$('step2-next').set('value','Step 3');
			$('step1').setStyle('display','none');
			$('step2').setStyle('display','block');
			$('multi-keywords').setStyle('display','none');
			$('hosting_settings').setStyle('display','none');
		}.bind(this));
	},
	initExistingDomain: function(){
		this.initCategory();
		$('step1-next').addEvent('click',function(){
			$('step2-next').set('value','Voila');
			$('step1').setStyle('display','none');
			$('step2').setStyle('display','block');
			$('hosting_settings').setStyle('display','block');
			$('multi-keywords').setStyle('display','none');
		});
	},
	initDownload: function(){
		this.download=true;
		this.initCategory();
		$('step1-next').addEvent('click',function(){
			$('step2-next').set('value','Voila');
			$('step1').setStyle('display','none');
			$('step2').setStyle('display','block');
			$('social').setStyle('display','none');
			$('multi-keywords').setStyle('display','none');
		});
	},
	initSybfolders: function(){
		this.initCategory();
		$('step1-next').addEvent('click',function(){
			$('step2-next').set('value','Step 2');
			$('ncsb-site').addClass('required');
			$('step1').setStyle('display','none');
			$('step2').setStyle('display','block');
			$('multi-keywords').setStyle('display','none');
			$('hosting_settings').setStyle('display','none');
			$$('.amazon-settings').setStyle('display','none');
			$('subdirs').setStyle('display','block');
			//$('legend').set('html','Select category and site');
		});
		$('subdir-multi-keywords').setStyle('display','inline');
		$('subdir-multi-keywords').addEvent('click',function(e){
			e.stop();
			var input=this.multiKeywords($('subdir-multi-keywords'));
			input.addEvent('change',function(){
				Object.each($('ncsb-site').options, function(option){
					option.set('selected','');
					if(option.value==''){
						option.set('selected','1');
					}
				});
			});
		}.bind(this));
		$('ncsb-site').addEvent('change',function(){
			$$('.main_keywords_block').destroy();
			$('sub-main-keyword').set('value','');
		});
		$('sub-main-keyword').addEvent('change',function(){
			Object.each($('ncsb-site').options, function(option){
				option.set('selected','');
				if(option.value==''){
					option.set('selected','1');
				}
			});
		});

	},
	initMuliZonterest: function(){
		this.initCategory();
		$('step1-next').addEvent('click',function(){
			$('step2-next').set('value','Voila');
			$('step1').setStyle('display','none');
			$('step2').setStyle('display','block');
			$('hosting_settings').setStyle('display','none');
			$('multi-keywords').setStyle('display','inline');
			$('multi-keywords').addEvent('click',function(e){
				e.stop();
				this.multiKeywords($('multi-keywords'));
			}.bind(this));
		}.bind(this));
	},
	multiKeywords: function(element){
		var p=new Element('p',{class:'main_keywords_block'});
		var input=new Element('input',{type:'text',name:'arrData[main_keyword][]',class:'main_keywords medium-input text-input form-control'})
				.inject(p.inject(element.getParent(),'after'));
		var a = new Element('a',{ href:'#', class:'delete-keyword',html:' -' }).setStyles({'font-size':'20px'}).inject(p);
		jQuery('.selectpicker').selectpicker('refresh');
		a.addEvent('click',function(){
			p.destroy();
		});
		return input;
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
			jQuery('.selectpicker').selectpicker('refresh');
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
				jQuery('.selectpicker').selectpicker('refresh');
			}
		}).post({'country':place+$('country').get('value')});
	},
	initStep2NewDomain: function(){
		$('step2-next').addEvent('click',function(){
			$('step3').hide();
			$('step2').hide();
			$('domain_text').value='';
			var self=this;
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
							self.wizardObjectTable( arrData );
						} else {
							self.moreDomainsJson=arrData;
						}
					});
				}
			}).post({arrData:{main_keyword:$('main_keyword').get('value'),type:$('arr_data_type').get('value')}});
		}.bind(this));
		this.initDomainCheck();
	},
	initStep2Amazideas: function(){
		$('step2-next').addEvent('click',function(){
			$('step3').hide();
			$('step2').hide();
			$('domain_text').value='';
			var self=this;
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
					$('step3').show('inline');
					$('submit_button').disabled=false;
					$('ajax_loader').hide();
					jQuery('.selectpicker').selectpicker('refresh');
				}
			}).post({arrData:{main_keyword:$('main_keyword').get('value'),type:$('arr_data_type').get('value'),'flg_amazideas':1}});
		}.bind(this));
		this.initDomainCheck();
	},
	initStep2ExistingDomain: function(){
		$('step2-next').addEvent('click',function(){
			$('submit_button').fireEvent('click');
		});
	},
	initStep2Download: function(){
		$('step2-next').addEvent('click',function(){
			$('submit_button').fireEvent('click');
		});
	},
	initStep2Sybfolders: function(){
		$('step2-next').addEvent('click',function(){
			if($('sub-main-keyword').get('value')==''){
				if( $('ncsb-site').get('value')=='' ){
					r.alert('Error','Select site','roar_error');
					return false;
				}
			}
			$('step3').hide();
			$('step2').hide();
			$('domain_text').value='';
			var self=this;
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
							self.wizardObjectTable( arrData );
						} else {
							self.moreDomainsJson=arrData;
						}
					});
				}
			}).post({arrData:{prepare:$('ncsb-site').get('value'),main_keyword:$('sub-main-keyword').get('value'),type:$('arr_data_type').get('value')}});
		}.bind(this));
		this.initDomainCheck();
	},
	initStep2MuliZonterest: function(){
		$('step2-next').addEvent('click',function(){
			// проверка средств
			new Request.JSON({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				onSuccess: function(response){
					if( response.result!=true ){
						if( !confirm('You have credits only for '+response.count+' keywords. proceed?') ){
							return false;
						}
						$$('.main_keywords').each(function(el,j){
							if( j>=response.count ){
								el.getParent().destroy();
							}
						});
					} else{
						$('submit_button').fireEvent('click');
					}
				},
				onRequest: function(){
					$('ajax_loader_small').show('inline');
				},
				onComplete: function(){
					$('ajax_loader_small').hide();
				}
			}).post({checkCredits:true,count:$$('.main_keywords').length/*,promotion:$('promotion').checked*/});
		});
	},
	initMOreDomainCheck: function(){
		$('more_domains').addEvent('click',function(e){
			e.stop();
			this.wizardObjectTable( this.moreDomainsJson );
			$('more_domains').hide();
		}.bind(this));
	},
	wizardObjectTable: function ( elt ){
		Object.each( elt, function(data, i, obj){
			var requestObjects=new Request({
				url: "{/literal}{url name='site1_wizard' action='ajax'}{literal}",
				onSuccess: function(responseFlag){
					if( responseFlag=='true' ){
						new Element( 'label' )
							.grab( new Element( 'input[type="radio"][name="arrData[domain_http]"][class="select_domain"]' ).set('value',data) )
							.appendText( " "+data )
							.inject( $('domains') );
						$('step3').show('inline');
						$('submit_button').disabled=false;
						$('ajax_loader').hide();
						jQuery('.selectpicker').selectpicker('refresh');
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
	},
	initDomainCheck: function(){
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
	},
	initSubmit: function(){
		var self=this;
		$('submit_button').addEvent('click',function(elt){
			if( validator.checker.validate() ){
				new Request({
					url: "{/literal}{url name='site1_wizard' action='zonterestpro'}{literal}",
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
								jQuery('.selectpicker').selectpicker('refresh');
							} else {
								$('end_creation').show('block');
								new Element('br').inject($('end_creation'));
								new Element('br').inject($('end_creation'));
								response.domain.each(function(domain){
									new Element('a',{href:domain,html:domain,target:'_blank'}).inject($('end_creation'));
									new Element('br').inject($('end_creation'));
								});
								jQuery('.selectpicker').selectpicker('refresh');
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
	new objZonterestPRO();
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

			$('#marketplacedomain').change(function(){
				$('.selectpicker').selectpicker('refresh');
			});
            //$(".knob").knob();

        });
    </script>
{/literal}
</div>
</body>
</html>