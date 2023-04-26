<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<span id="waite_creation" class="grn" style="display:none;">We're generating your Website, adding content and scheduling new content publishing. It all will be ready in a few seconds.You can close the popup now.</span>
	<span id="waite_creation_download" class="grn" style="display:none;">We're generating your Website. It all will be ready in a few seconds.</span>
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
	<input type="hidden" name="arrData[type]" id="arr_data_type" value="{Project_Wizard_Domain_Rules::R_CONTENTPRO}"  />
	<!-- start step 1 -->
	<fieldset id="step1">
		<legend>Select type</legend>
		<div class="form-group">
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ContentPro::NEW_DOMAIN}" /> 
				<label>I want to register a new domain and create website <a href="" class="tooltip" title="Hosted on servers">?</a></label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ContentPro::EXIST_DOMAIN}" />
				<label>I already have a domain name I want to use <a href="" class="tooltip" title="Hosted on servers">?</a></label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ContentPro::MULTI_DOMAIN}" />
				<label>Mass Generate Websites <a href="" class="tooltip" title="Domain names are automatically registered by our system and hosted on our servers">?</a></label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ContentPro::SUBFOLDERS}" />
				<label>Create Sites in Subfolders <a href="" class="tooltip" title="">?</a></label>
			</div>
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
	<fieldset id="step2" style="display:none;">
		<legend>Select category and main keyword</legend>
		<div class="form-group">
			<label>Select Category <em>*</em></label>
			<select id="category" name="arrData[category_pid]" class="required btn-group selectpicker show-tick validate-custom-required emptyValue:'0' medium-input">
				<option value="0"> - select -</option>
				{foreach from=$arrCategories item=i}<option value="{$i.id}">{$i.title}</option>
				{/foreach}
			</select>
		</div>
		<div class="form-group">
			<label>&nbsp;</label>
			<select id="category_child" name="arrData[category_id]" class="medium-input btn-group selectpicker show-tick" >
			</select>
			<a href="#" id="select-sub-categories" style="display:none;">Select subcategories manually (optional)</a>
		</div>
		<div class="form-group">
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword][]" type="text" id="main_keyword" value="{$arrData.main_keyword}" class="main_keywords required text-input  medium-input form-control"/> <a href="#" style="display: none; font-size: 24px;" id="multi-keywords">+</a>
		</div>
		<div class="form-group" id="social">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" value="1" name="arrData[promotion]" id="promotion" />
				<label>Create Social Signals</label>	
			</div>
		</div>
		<div id="promotion-block" style="display: none;">
			<div>
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
			<div class="form-group">
				<label>Or you may also enter any domain name you want to register</label>
				<input type="text" name="arrData[domain_text]" id="domain_text" value="{$arrData.domain_http}" style="width:200px;"><input type="button" id="check_domein" value="check">
			</div>
			<div class="form-group">
				<label>
				<span id="domain_check_wait" style="display:none;">Please wait..</span>
				<span class="grn" id="domain_available" style="display:none;">Available</span>
				<span class="red" id="domain_notavailable" style="display:none;">Not Available</span></label>
			</div>
			<div class="form-group">
				<button type="button" id="submit_button" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Voila</button>
			</div>
		</fieldset>
	</div>
	<!-- end step 3 -->
</form>
{/if}

<script type="text/javascript">
var jsonCategory = {$treeJson};
var categoryId = {$arrData.category_id|default:0};
{literal}
var ContentPRO=new Class({

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
					case '{/literal}{Project_Wizard_Adapter_ContentPro::NEW_DOMAIN}{literal}': this.initNewDomain(); this.initStep2NewDomain(); break;
					case '{/literal}{Project_Wizard_Adapter_ContentPro::EXIST_DOMAIN}{literal}': this.initExistingDomain(); this.initStep2ExistingDomain(); break;
					case '{/literal}{Project_Wizard_Adapter_ContentPro::MULTI_DOMAIN}{literal}': this.initMuliZonterest(); this.initStep2MuliZonterest(); break;
					case '{/literal}{Project_Wizard_Adapter_ContentPro::SUBFOLDERS}{literal}': this.initSubfolders(); this.initStep2Subfolders(); break;
				}
			}.bind(this));
		}, this);
		this.initSubmit();
	},
	initPromotion: function(){
		$('promotion').addEvent('click',function(){
			$('promotion-block').toggle();
		});
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
	initSubfolders: function(){
		this.initCategory();
		var viewLink=true;
		$('step1-next').addEvent('click',function(){
			$('step2-next').set('value','Step 3');
			$('step1').setStyle('display','none');
			$('step2').setStyle('display','block');
			$('multi-keywords').setStyle('display','none');
			$('main_keyword').removeClass('required');
			$('main_keyword').getParent().toggle();
		});
		$('category_child').addEvent('click',function(){
			if( !viewLink || $('category_child').get('value')==''||$('category_child').hasClass('schon-gemacht') ){
				return false;
			}
			$('select-sub-categories').setStyle('display','block');
		});
		$('category').addEvent('change',function(){
			$$('.clone-category').destroy();
			$('category_child').removeClass('schon-gemacht');
			viewLink=true;
		});
		$('select-sub-categories').addEvent('click',function(e){
			e.stop();
			$$('.clone-category').destroy();
			this.listCategories();
			$('category_child').addClass('schon-gemacht');
		}.bind(this));
		$('category_child').addEvent('change',function(){
			if(!$('category_child').hasClass('schon-gemacht')){
				return false;
			}
			$$('.clone-category').destroy();
			this.listCategories();
		}.bind(this));

	},
	listCategories:function(){
		var p=new Element('p',{class:'clone-category'}).inject($('category_child').getParent(),'after');
		Object.each($('category_child').options,function(option){
			if( option.text=='-select-'||$('category_child').get('value')==option.value ){
				return;
			}
			new Element('input',{type:'checkbox',name:'arrData[sub_categories][]',value:option.value}).inject( new Element('label',{html:option.text}).inject(p),'top');
		});
		viewLink=false;
		$('select-sub-categories').setStyle('display','none');
		jQuery('.selectpicker').selectpicker('refresh');
	},
	multiKeywords: function(element){
		var p=new Element('p');
		new Element('input',{type:'text',name:'arrData[main_keyword][]',class:'main_keywords medium-input text-input form-control'})
				.inject(p.inject(element.getParent(),'after'));
		var a = new Element('a',{ href:'#', class:'delete-keyword',html:' -' }).setStyles({'font-size':'20px'}).inject(p);
		jQuery('.selectpicker').selectpicker('refresh');
		a.addEvent('click',function(){
			p.destroy();
		});
	},
	initCategory: function(){
		new Categories({
			firstLevel: 'category',
			secondLevel: 'category_child',
			intCatId:categoryId,
			jsonTree:jsonCategory
		});
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
	initStep2ExistingDomain: function(){
		$('step2-next').addEvent('click',function(){
			$('submit_button').fireEvent('click');
		});
	},
	initStep2Subfolders: function(){
		$('step2-next').addEvent('click',function(){
			$('step3').hide();
			$('step2').hide();
			$('domain_text').value='';
			var self=this;
			var arrCategories = new Hash( jsonCategory );
			var main_keyword='';
			arrCategories.each(function(root){
				var node= new Hash(root.node);
				node.each(function(item){
					if( item.id==$('category_child').get('value') ){
						main_keyword=item.title;
					}
				});
			});
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
			}).post({arrData:{main_keyword:main_keyword,type:$('arr_data_type').get('value')}});
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
			}).post({checkCredits:true,count:$$('.main_keywords').length,promotion:$('promotion').checked});
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
					url: "{/literal}{url name='site1_wizard' action='contentpro'}{literal}",
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
								response.domain.each(function(domain){
									new Element('a',{href:domain,html:domain,target:'_blank'}).inject($('end_creation'));
									new Element('br').inject($('end_creation'));
								});
								jQuery('.selectpicker').selectpicker('refresh');
							}
							if(response.contentCount<7){
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
	new ContentPRO();
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
</div>
</body>
</html>