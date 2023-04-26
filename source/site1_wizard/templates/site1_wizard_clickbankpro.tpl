<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
<p id="waite_creation" class="grn" style="display:none;">We're generating your Clickbank Affiliate Website, adding content and scheduling new content publishing. It all will be ready in a few seconds.You can close the popup now.</p>
<p id="end_creation" class="grn" style="display:none;">Process is finished and you can view the site:</p>
<p id="end_warning" class="red" style="display:none;">There is few content on Clickbank related to the keyword(s) you specified for the site. You might want to create a new content project with a different keyword to make sure your site is updated with new content regularly.</p>
<p id="ajax_errors" class="red" style="display:none;"></p>
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
	<input type="hidden" name="arrData[type]" id="arr_data_type" value="{Project_Wizard_Domain_Rules::R_CLICKBANKPRO}"  />
	<!-- start step 1 -->
	<fieldset id="step1">
		<legend>Select type</legend>
		<div class="form-group">
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ClickbankPro::NEW_DOMAIN}" />
				<label>Create site in a new domain</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ClickbankPro::EXIST_DOMAIN}" />
				<label>Create site in an existing domain</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="type_create" name="arrData[type_create]" value="{Project_Wizard_Adapter_ClickbankPro::MULTI_DOMAIN}" />
				<label>Create multiple ClickBank</label>
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
		<legend>Select {*language,*} category and main keyword</legend>
		<div class="form-group" style="display:none;">
			<label>Language<em>*</em></label>
			<select name="arrData[flg_language]" id="language"  class="required medium-input btn-group selectpicker show-tick">
				<option value="">-select-</option>
				{foreach from=Core_Language::$flags item=flags key=lang_id}
					<option {if $settings.flg_language==$lang_id} selected="selected" {/if} value="{$lang_id}">{$flags.title}</option>
				{/foreach}
			</select>
		</div>
		<div class="form-group">
			<label>Category <em>*</em></label>
			<select name="arrData[category_pid]" id="category_clickbank"  class="required medium-input category-select btn-group selectpicker show-tick"></select>
			<select name="arrData[category_id]" id="category_clickbank_child"   class="medium-input category-select btn-group selectpicker show-tick"></select>
		</div>
		<div class="form-group">
			<label>Content selection <em>*</em></label>
			<div class="radio radio-primary">
				<input type="radio" name="arrData[mode]" checked="1" class="content-selection" value="0" />
				<label>Automatic</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrData[mode]" value="1"  class="content-selection"  />
				<label>Manual</label>
			</div>
		</div>
		<img id="content-load" src="/skin/i/frontends/design/ajax-loader-big.gif" style="display:none;">
		<div style="display:none;" id="content">

		</div>
		<div class="form-group">
			<label><span>Search tags </span></label>
			<input name="arrData[tags]" type="text" value="{$arrData.tags}" class="medium-input form-control"/>
		</div>
		<div class="form-group">
			<label for="main_keyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrData[main_keyword][]" type="text" id="main_keyword" value="{$arrData.main_keyword}" class="main_keywords required text-input  medium-input form-control"/> <a href="#" style="display: none; font-size: 24px;" id="multi-keywords">+</a>
		</div>
		{*<p>*}
			{*<label></label>*}
			{*<input type="checkbox" value="1" name="arrData[promotion]" id="promotion" /> Create Social Signals*}
		{*</p>*}
		<div class="form-group">
			<button type="button" id="step2-next" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Step 3</button>
		</div>
	</fieldset>
	<!-- end step 2 -->

	<div align="center">
		<img id="ajax_loader" src="/skin/i/frontends/design/ajax-loader-big.gif" style="display:none;">
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
			<input type="hidden" name="arrData[thumb]" value="">
		</fieldset>
	</div>
	<!-- end step 3 -->
</form>
{/if}

<script type="text/javascript">
var jsonCategoryClickbank = {$arrCatTree|json|default:'null'};
{literal}
var ZonterestPRO=new Class({

	initialize: function(){
		this.step1();
		this.moreDomainsJson = null;
		this.initMOreDomainCheck();
	},
	step1: function(){
		$$('.type_create').each(function(element){
			element.addEvent('click',function(e){
				switch(element.get('value')){
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::NEW_DOMAIN}{literal}': this.initNewDomain(); this.initStep2NewDomain(); break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::EXIST_DOMAIN}{literal}': this.initExistingDomain(); this.initStep2ExistingDomain(); break;
					case '{/literal}{Project_Wizard_Adapter_ZonterestPro::MULTI_DOMAIN}{literal}': this.initMuliZonterest(); this.initStep2MuliZonterest(); break;
				}
			}.bind(this));
		}, this);
		this.initSubmit();

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
		jQuery('.selectpicker').selectpicker('refresh');
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
		jQuery('.selectpicker').selectpicker('refresh');
	},
	multiKeywords: function(element){
		var p=new Element('p');
		new Element('input',{type:'text',name:'arrData[main_keyword][]',class:'main_keywords medium-input text-input form-control'})
				.inject(p.inject(element.getParent(),'after'));
		var a = new Element('a',{ href:'#', class:'delete-keyword',html:' -' }).setStyles({'font-size':'20px'}).inject(p);
		a.addEvent('click',function(){
			p.destroy();
		});
	},

	initCategory: function(){
		var ClickbankLanguage = new CategoriesSelects({
			language: 'language',
			category_parent: 'category_clickbank',
			category_child: 'category_clickbank_child',
			optionName1:'-select-',
			optionName2:'-All-',
			post_settings: {'action':'get_category'}, // post action
			request_url: '{/literal}{url name="content_clickbank" action="ajax_get"}{literal}', // request url
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
		jQuery('.selectpicker').selectpicker('refresh');
		$$('.category-select').each(function(el){
			el.addEvent('change',function(){
				$('content').setStyle('display','none');
				$('content').empty();
				$$('.content-selection').each(function(input){
					if(input.get('value')==0){
						input.checked=true;
					} else {
						input.checked=false;
					}
				});
			});
		});
		$$('.content-selection').each(function(el){
			el.addEvent('click',function(){
				if(el.get('value')==0){
					$('content').setStyle('display','none');
					$('content').empty();
					return true;
				}

				new Request.JSON({
					url:'{/literal}{url name='content_clickbank' action='ajax_get' wg='get-items=1'}{literal}',
					headers:{'X-Request':'JSON'},
					onRequest: function(){
						$('content-load').style.display="block";
					},
					onSuccess: function( r ){
						var table = new Element('table').inject($('content'));
						var tBody = new Element('tbody').inject(table);
						r.arr.each(function(item,i){
							var tr=new Element('tr').inject(tBody);
							if(i%2==0){	tr.addClass('alt-row'); }
							var td_input=new Element('td[width="15"]').inject(tr);
							var input=new Element('input[type="checkbox"][value="'+item.id+'"][name="arrData[content][]"]').inject(td_input);
							var td_title=new Element('td[html="'+item.title+'"]').inject(tr);
							var td_option=new Element('td[width="20"]').inject(tr);
							var a_view=new Element('a[href="{/literal}{url name='content_clickbank' action='previewfrontend'}{literal}?id='+item.id+'"][html="View"][target="_blank"]').inject(td_option);
						});
						$('content').setStyle('display','block');
					},
					onComplete: function(){
						$('content-load').style.display="none";
					}
				}).post($('post_form'));

			});
		});
		jQuery('.selectpicker').selectpicker('refresh');
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
			}).post({checkCredits:true,count:$$('.main_keywords').length,promotion:0});
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
		$('submit_button').addEvent('click',function(elt){
			if( validator.checker.validate() ){
				new Request({
					url: "{/literal}{url name='site1_wizard' action='clickbankpro'}{literal}",
					onRequest: function(){
						$('ajax_errors').empty().hide();
						$('step3').hide();
						$('step2').hide();
						$('hosting_settings').hide();
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
							if(response.contentCount<6){
								$('end_warning').show('block');
							}
						}else{
							$('ajax_errors').set('html',response.error).show("inline");
							if( type==0 ){
								$('hosting_settings').show();
								$('step2').show();
							} else {
								$('step3').show('inline');
							}
						}
						$('ajax_loader').hide();
					}
				}).post($('post_form'));
				jQuery('.selectpicker').selectpicker('refresh');
			}
		});
	}

});
var moreDomainsJson = null;
window.addEvent('domready', function(){
	new ZonterestPRO();
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

			$('select').change(function(){
				$('.selectpicker').selectpicker('refresh');
			});
            //$(".knob").knob();

        });
    </script>
{/literal}
</div>
</body>
</html>