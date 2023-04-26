<link href="/usersdata/exquisite_popups/css/admin.css" rel="stylesheet" type="text/css"> 
<link href="/usersdata/exquisite_popups/css/font-awesome.min.css" rel="stylesheet" type="text/css"> 

<script src="/usersdata/exquisite_popups/js/jquery-1.10.2.min.js"></script>
<script src="/usersdata/exquisite_popups/js/bootstrap-dropdown.js"></script>
<script src="/usersdata/exquisite_popups/js/bootstrap-modal.js"></script>
{literal}
<script type="text/javascript">
jQuery.noConflict();
</script>
{/literal}
<div class="alert alert-warning alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
	<div>Watch the video tutorials <a href="https://help.ifunnels.com/collection/55-lead-funnels" target="_blank">HERE</a> before you start using this module</div>
</div>
<!-- color picker -->
<link rel="stylesheet" href="/skin/_js/rainbow/mooRainbow_full.css" type="text/css" xmlns="http://www.w3.org/1999/html"/>
<script src="/skin/_js/rainbow/mooRainbow.js" type="text/javascript"></script>
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<script src="/skin/_js/audiojs/audio.js"></script>
{literal}
<script type="text/javascript">
var objAccordion = {};
var ckeditorCopyProphetLink='{/literal}{url name="site1_accounts" action="copyprophet_ajax"}{literal}';
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
window.addEvent('domready', function() {
	objAccordion = new myAccordion($('accordion'), $$('.toggler'), $$('.element'), { fixedHeight:false });
});
</script>
{/literal}
{include file="../../error.tpl" fields=['title'=>'Title','header'=>'Headline','description'=>'Description','form'=>'Form']}
<!-- /color picker -->
{if Core_Acs::haveAccess( 'Easy Optin Page Light' )}{include file='../../message.tpl' type='error' message='Try <a href="http://go.leadprofitsystems.com/thereveal" target="_blank">LPS 2.0</a> and activate unprecedented features.'}{/if}
{if $generatedLink!=''}
<div class="alert alert-success alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
	<div>Generated link is <a href="{$generatedLink}" target="_blank" >{$generatedLink}</a></div>
</div>
{/if}

{if Core_Acs::haveAccess( array( 'email test group', 'LPS Entrepreneur', 'LPS Professional', 'lps platinum', 'LPS VIP Partners Bonus', 'LPS Performance Marketer', 'LPS Elite' ) )}
<div class="alert alert-warning alert-dismissable">
	<a href="{url name='site1_squeeze' action='templates'}" class="popup_mb" title="Start from scratch using the form below or Load a real campaign of your choice by clicking here and picking the one of your choice">Start from scratch using the form below or Load a real campaign of your choice by clicking here and picking the one of your choice, or Import one if you've been provided with an Import code</a>
</div>
{/if}
<form action="" method="post" id="form" class="wh validate" enctype="multipart/form-data">
<input type="hidden" name="id" value="{$id}">
<input type="hidden" name="url" value="{$url}">
{if isset($settings.flg_funnels_widget) && !empty($settings.flg_funnels_widget)}<input type="hidden" name="settings[flg_funnels_widget]" value="{$settings.flg_funnels_widget}">{/if}
{if isset($settings.funnels_jvzoodid) && !empty($settings.funnels_jvzoodid)}<input type="hidden" name="settings[funnels_jvzoodid]" value="{$settings.funnels_jvzoodid}">{/if}
{if isset($settings.funnels_clickbank) && !empty($settings.funnels_clickbank)}<input type="hidden" name="settings[funnels_clickbank]" value="{$settings.funnels_clickbank}">{/if}
{if isset($flg_funnel) && !empty($flg_funnel)}<input type="hidden" name="flg_funnel" value="{$flg_funnel}">{/if}
<div id="accordion">
{if Core_Acs::haveAccess( array( 'email test group', 'LPS Professional', 'iFunnels - Business Program' ) )}
	<div class="row">
		<div class="form-group col-md-6">
			<div class="input-group">
				<input type="text" class="form-control" value="" id="import_id" placeholder="Import ID">
				<span class="input-group-btn">
					<button type="button" class="btn waves-effect waves-light btn-primary" value="Import" id="run_import">Submit</button>
				</span>
			</div>
		</div>
	</div>
{/if}
	<div class="panel-group" id="accordion-test-2">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">Content</a>
				</h4>
			</div>
			<div id="collapseOne-2" class="panel-collapse collapse in" aria-expanded="false">
				<div class="panel-body">
                	<fieldset>
						{if Core_Acs::haveAccess( array( 'LPB Admins' ) )}
						<div class="form-group">
							<div class="checkbox checkbox-primary">
								<input type="hidden" name="flg_template" value="0" />
								<input type="checkbox" name="flg_template" id="flg_template-checker" value="1"{if isset($flg_template) && $flg_template==1}checked{/if}/>
								<label for="flg_template-checker">Make it template</label>
							</div> 
						</div>

						<div id="flg_template-box"{if !isset($flg_template) || $flg_template==0} style="display:none;"{/if}>
							<div class="form-group">
								<label class="control-label">Template Description: </label>
								<textarea name="settings[template_description]" class="form-control">{$settings.template_description}</textarea>
							</div>
							<div class="form-group">
								<label class="control-label">Template Tags: </label>
								<textarea name="settings[template_tags]" class="form-control">{$settings.template_tags}</textarea>
							</div>
							<div class="form-group">
								{if isset( $settings.template_file_path ) && !empty( $settings.template_file_path ) }
								<img src="{$templates_link}{$settings.template_hash}.jpg" width="230" height="150" class="image_item" />
								{/if}
							</div>
							<div class="form-group">
								<label class="label-control">Template Screenshot: </label>
								<input type="hidden" name="settings[template_file_path]" value="{$settings.template_file_path}" />
								<input type="hidden" name="settings[template_hash]" value="{$settings.template_hash}" />
								<input type="file" class="filestyle" data-buttonname="btn-white" id="filestyle-0" tabindex="-1" style="position: absolute; clip: rect(0px 0px 0px 0px);" name="tmp_file"/>
								<div class="bootstrap-filestyle input-group">
									<input type="text" class="form-control" placeholder="" disabled=""> 
									<span class="group-span-filestyle input-group-btn" tabindex="0">
										<label for="filestyle-0" class="btn btn-white ">
											<span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> 
											<span class="buttonText">Choose file</span>
										</label>
									</span>
								</div>
							</div>
						</div>
						{/if}
						<div class="form-group">
							<label class="control-label">Tags</label>
							<input type="text" name="tags" class="form-control" value="{$tags}" />
						</div>
						{if Core_Acs::haveAccess( array( 'PopUps IO', 'LPS Professional', 'email test group' ) )}
						<div class="form-group">
							<label>Select Content Style</label>
							
							<div class="radio radio-primary">
								<input type="radio" id="popup_style_1" name="settings[popup_style]" value="content" {if !isset($settings.popup_style) || $settings.popup_style=='content' }checked{/if}> 
								<label for="popup_style_1">Content</label>
							</div>
							{if Core_Acs::haveAccess( array( 'email test group' ) )}
							<div class="radio radio-primary">
								<input type="radio" id="popup_style_4" name="settings[popup_style]" value="contentbox" {if $settings.popup_style=='contentbox' }checked{/if}> 
								<label for="popup_style_1">Content Box</label>
							</div>
							{/if}
								{*<div class="radio radio-primary">
								<input type="radio" id="popup_style_2" name="settings[popup_style]" value="popup" {if $settings.popup_style=='popup' }checked{/if}>
								<label for="popup_style_2">Content with Popups.IO</label>
								</div>*}
							
							<div class="radio radio-primary">
								<input type="radio" id="popup_style_3" name="settings[popup_style]" value="onload" {if $settings.popup_style=='onload' }checked{/if}>
								<label for="popup_style_3">Popups.IO</label>
							</div>
							
						</div>

						<div class="popup_style-contentbox"{if !isset($settings.popup_style) || $settings.popup_style=='content' || $settings.popup_style == "onload" || $settings.popup_style == "popup" || empty( $settings.contentboxId )} style="display: none;"{/if}>
							<div class="form-group">
								<label class="label-control">Select Content Box</label>
							</div>
							<span>
							{module name='site1_contentbox' action='select' elementsName='settings[contentboxId]' checkedId=$settings.contentboxId}
							</span>
						</div>
						
						<div class="select_popup_io2_box popup_style-onload popup_style-popup"{if !isset($settings.popup_style) || $settings.popup_style=='content' || $settings.popup_style == "contentbox" || empty( $settings.popupId )}style="display: none;"{/if}>
							<div class="form-group">
								<label class="label-control">Select where popup be displayed: </label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[popup_options][display_mode]" value="onload"{if !isset($settings.popup_options.display_mode) || $settings.popup_options.display_mode == "onload"} checked{/if} />
									<label>On page load</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[popup_options][display_mode]" value="onexit"{if $settings.popup_options.display_mode == "onexit"} checked{/if} />
									<label>On exit intent</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[popup_options][display_mode]" value="onscroll"{if $settings.popup_options.display_mode == "onscroll"} checked{/if} />
									<label>On scrolling down</label>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label">Display mode: </label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[popup_options][load_mode]" value="every-time"{if !isset($settings.popup_options.load_mode) ||$settings.popup_options.load_mode == "every-time"} checked{/if}>
									<label>Every time</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[popup_options][load_mode]" value="once-session"{if $settings.popup_options.load_mode == "once-session"} checked{/if}>
									<label>Once per session</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[popup_options][load_mode]" value="once-only"{if $settings.popup_options.load_mode == "once-only"} checked{/if}>
									<label>Only once</label>
								</div>
								<em>Select popup display mode.</em>
							</div>
							<div class="flg_mode flg_mode_onload form-group"{if $settings.popup_options.display_mode != "onload"} style="display:none;"{/if}>
								<label>Start delay: </label>
								<input type="text" name="settings[popup_options][onload_delay]" value="{$settings.popup_options.onload_delay}" class="ic_input_number form-control" placeholder="Delay"> seconds
								<br /><em>Popup appears with this delay after page loaded. Set "0" for immediate start.</em>
							</div>
							<div class="flg_mode flg_mode_onexit form-group"{if $settings.popup_options.display_mode != "onexit"} style="display:none;"{/if}>
								<div class="checkbox checkbox-primary">
									<input type="checkbox" id="onexit_limits" name="settings[popup_options][onexit_limits]"{if $settings.popup_options.onexit_limits ==  "on"} checked{/if}>
									<label>Disable OnExit popup if user subscribed through another OnLoad or inline form</label>
								</div>
								<br /><em>Disable OnExit popup if user subscribed through another OnLoad or inline form.</em>
							</div>
							<div class="flg_mode flg_mode_onscroll form-group"{if $settings.popup_options['display_mode'] != "onscroll"} style="display:none;"{/if}>
								<label>Scrolling offset:</label>
								<input type="text" name="settings[popup_options][onscroll_offset]" value="{$settings.popup_options.onscroll_offset}" class="ic_input_number form-control" placeholder="Pixels"> pixels
								<br /><em>Popup appears when user scroll down to this number of pixels.</em>
							</div>
						</div>
						{/if}
						<div class="popup_style-content"{if $settings.popup_style=="onload" || $settings.popup_style == "contentbox"}style="display:none;"{/if}>
							<div class="form-group">
								<label class="label-control">Headline:</label>
								<textarea name="settings[header]" id="header" class="medium-input textarea" style="height: 100px;">{$settings.header}</textarea>
							</div>
							<div class="form-group">
								<label class="label-control">Video placeholder: <br/><small>If you want to insert a video, please paste your embed code here (make sure width is no more than 550px)</small></label>
								<textarea name="settings[video_holder]" id="video_holder" class="form-control" style="height: 100px;">{$settings.video_holder}</textarea>
							</div>
							
							<div class="form-group">
								<label class="label-control">Do you want to create an optin page, a click-through page, or direct visitors to Facebook Messenger?</label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_page]" value="2"{if !isset( $settings.type_page ) || $settings.type_page == 2 } checked{/if} id="option-page" class="type-page" >
									<label>Optin page</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_page]" value="1"{if $settings.type_page == 1 } checked{/if} id="click-through" class="type-page" >
									<label>Click-through page</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_page]" value="3"{if $settings.type_page == 3 } checked{/if} id="facebook-msg" class="type-page" >
									<label>Facebook Messenger</label>
								</div>
							</div>

							<div class="form-group" {if !isset( $settings.type_page ) || $settings.type_page == 2}style="display: block;"{else}style="display: none;"{/if} id="type_event">
								<label class="label-control">Triggered by button</label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_event]" value="0" {if $settings.type_event == 0 } checked{/if}/>
									<label>Normal</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_event]" value="1" {if $settings.type_event == 1 } checked{/if}/>
									<label>Triggered by button</label>
								</div>
							</div>
							
							<div class="click-through data form-group"{if $settings.type_page == 1 } style="display: block;"{else} style="display: none;"{/if}>
								<label>Do you want to create optin, link, or use Click-To-Call feature?</label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_page_through]" value="1"{if $settings.type_page_through == 1 } checked{/if} id="click-through-optin" class="type-page-through" >
									<label>Smart Optin</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_page_through]" value="0"{if !isset( $settings.type_page_through ) || $settings.type_page_through == 0 } checked{/if} id="click-through-url" class="type-page-through" >
									<label>Url</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_page_through]" value="2"{if $settings.type_page_through == 2 } checked{/if} id="click-through-phone" class="type-page-through" >
									<label>Click-To-Call</label>
								</div>
								<div class="click-through-url data-through form-group"{if !isset( $settings.type_page_through ) || $settings.type_page_through == 0 } style="display: block;"{else} style="display:none;"{/if}>
									<label class="control-label">Url:</label>
									<input type="text" name="settings[link_url]" class="form-control" value="{str_replace('"',"'", $settings.link_url)}" />
								</div>
							</div>

							<div class="form-group click-through-optin data-through" {if $settings.type_page == 1 && $settings.type_page_through == 1}style="display: block;"{else}style="display: none;"{/if} id="type_triggered_mode">
								<label class="label-control">Triggered by button</label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_triggered_mode]" value="0" {if $settings.type_triggered_mode == 0 } checked{/if} />
									<label>Popup mode</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[type_triggered_mode]" value="1" {if $settings.type_triggered_mode == 1 } checked{/if} />
									<label>Toggle mode</label>
								</div>
							</div>							
							
							{if Core_Acs::haveAccess( array( 'PopUps IO', 'LPS Professional', 'lps platinum', 'email test group' ) )}{* MO_OPTIN_OPTIONS *}
							<div class="option-page data click-through-optin data-through"{if ( $settings.type_page == 1 && $settings.type_page_through == 1 ) || $settings.type_page == 2 || !isset( $settings.type_page ) || !empty($settings.popupOnActionId) } style="display: block;"{else} style="display:none;"{/if}>
								{if Core_Acs::haveAccess( array( 'email test group', 'lps platinum' ) )}
									<div class="form-group">
										<label>Select Campaign Type:</label>
										<select name="settings[optin][type]" class="btn-group selectpicker show-tick" id="optin_type">
											<option value="optin"{if !isset($settings.optin.type)||$settings.optin.type=='optin'} selected="selected"{/if}>Optin Form</option> 
											<option value="mooptin"{if $settings.optin.type=='mooptin'} selected="selected"{/if}>Lead Channels Campaign</option> 
										</select>
									</div>
									
									<div class="mo_optin_group mo_optin_mooptin scroll-block form-group"{if $settings.optin.type=='mooptin' } style="display: block;"{else} style="display: none;"{/if}>
										<a rel="" href="{url name='site1_mooptin' action='createpopup'}" title="Campaign Builder" class="popup_mb">Campaign Builder</a>
										{module name='site1_mooptin' action='select' elementsName='settings[mo_optin_id]' checkedId=$settings.mo_optin_id}
									</div>
									
									<div class="mo_optin_group mo_optin_mooptin form-group"{if $settings.optin.type=='mooptin' } style="display: block;"{else} style="display: none;"{/if}>
										<label>Button Action:</label>
										<div class="radio radio-primary">
											<input type="radio" class="optin_button_action_radio" name="settings[optinButtonAction]" value="message" {if empty( $settings.optinButtonAction ) || $settings.optinButtonAction=="message"} checked{/if} />
											<label>Display Message</label>
										</div>
										<div class="radio radio-primary">
											<input type="radio" class="optin_button_action_radio" name="settings[optinButtonAction]" value="redirect" {if !empty( $settings.optinButtonAction ) && $settings.optinButtonAction=="redirect"} checked{/if} />
											<label>Redirect URL</label>
										</div>
									</div>
									<div class="form-group mo_optin_group mo_optin_mooptin optin_button_action optin_button_message form-group"{if $settings.optin.type=='mooptin' && $settings.optinButtonAction=='message' } style="display: block;"{else} style="display: none;"{/if}>
										<p>
											<label>Message:</label>
											<textarea name="settings[optinButtonActionMessage]" id="optin_message_text" class="form-control" style="height: 80px;">{$settings.optinButtonActionMessage}</textarea>
										</p>
									</div>
									<div class="form-group mo_optin_group mo_optin_mooptin optin_button_action optin_button_redirect form-group"{if $settings.optin.type=='mooptin' && $settings.optinButtonAction=='redirect' } style="display: block;"{else} style="display: none;"{/if}>
										<p>
											<label>Redirect URL:</label>
											<input type="text" class="form-control" name="settings[optinButtonActionURL]" value="{$settings.optinButtonActionURL}" />
										</p>
									</div>
									
								</div>
								{/if}{* END MO_OPTIN_OPTIONS *}
							</div>
							{/if}
							<div class="form-group mo-optin option-page data click-through-optin data-through hide-autoresponder mo_optin_group mo_optin_optin popup_style-content popup_style-onload popup_style-popup"
							{if (( $settings.type_page == 1 && $settings.type_page_through == 1 )
								|| ( $settings.type_page == 2 && ( !isset($settings.optin.type)||$settings.optin.type=='optin' ) )
								|| !isset( $settings.type_page ) 
								|| !empty($settings.popupOnActionId)
								) && $settings.popup_style != 'contentbox'
							} style="display: block;height: 240px;"{else} style="display: none;height: 240px;"{/if}>
								<label class="label-control" style="float: left;width: 100%;">Autoresponder HTML Code:<br/><small>	Paste your autoresponder form code here (only HTML, no Javascript). Our engine will then take care of the rest, use the button you select below and format it properly</small> </label>
								<textarea name="settings[form]" id="autoresponder_form_data" class="form-control" style="height: 200px;width:500px;display:inline;float:left;" >{$settings.form}</textarea>
								
								<div style="height: 200px;width:450px;overflow:auto;display:inline;float:left;padding:0 5px;" id="autoresponder_form_settings">{if isset( $settings.form_autoresponder ) && !empty( $settings.form_autoresponder )}
								{foreach from=$settings.form_autoresponder key=elementId item=elementVaue}
									<input type="text" class="medium-input text-input" name="settings[form_autoresponder][{$elementId}]" value="{$elementVaue}" />
									<input type="hidden" name="settings[form_autoresponder_hide][{$elementId}]" value="0" checked />
									<input type="checkbox" name="settings[form_autoresponder_hide][{$elementId}]" value="1" {if isset($settings.form_autoresponder_hide[{$elementId}] ) && $settings.form_autoresponder_hide[{$elementId}] != 0}checked{/if} />&nbsp;Hide<br/>
								{/foreach}
							{else}&nbsp;{/if}</div>
							</div>
							
							<div class="form-group not-option-page click-through-optin hide-autoresponder"{if $settings.type_page == 1 && $settings.type_page_through == 1 } style="display: block;"{else} style="display:none;"{/if}>
								<input type="hidden" name="settings[flg_show_border]" value="0" checked />
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[flg_show_border]" value="1"{if isset( $settings.flg_show_border ) && $settings.flg_show_border == 1 } checked{/if} />
									<label>Remove the border</label>
								</div>
								
							</div>
							
							<div class="form-group option-page data click-through-optin data-through hide-autoresponder popup_style-content popup_style-onload popup_style-popup"
							{if ( $settings.type_page == 1 && $settings.type_page_through == 1 ) || $settings.type_page == 2 || !isset( $settings.type_page ) || !empty($settings.popupOnActionId) || $settings.popup_style != 'contentbox' } style="display: block;"{else} style="display: none;"{/if}>
								<label class="label-control">Display Autoresponder Fields</label>
								<div class="radio radio-primary">
									<input type="radio" name="settings[flg_fields_style]" value="2"{if !isset( $settings.flg_fields_style ) || $settings.flg_fields_style == 2 } checked{/if} >
									<label>In line</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="settings[flg_fields_style]" value="1"{if $settings.flg_fields_style == 1 } checked{/if} >
									<label>One per line</label>
								</div>
							</div>
							
							<div class="data-through facebook-options" {if $settings.type_page != 3 } style="display: none;" {/if}>
								<p>
									<label class="label-control">Messenger Username:</label>
									<input type="text" name="settings[facebook_username]" class="form-control" value="{$settings.facebook_username}" />
								</p>
							</div>
							
							<div class="form-group data click-through-phone data-through" {if $settings.type_page_through != 2 } style="display: none;" {/if}>
								<p>
									<label class="label-control">Phone:</label>
									<input type="text" name="settings[phone_number]" class="form-control" value="{$settings.phone_number}" />
									<br/><b><small>In order to activate Tap to Call feature to regular or cell phone, input "tel:phone_number" in the above field. E.g. tel:855-895-5555. <br/>Use "skype:skypeID?call" to activate click to Skype call. E.g. skype:myid?call</small></b>
								</p>
							</div>
							
							<div class="option-page data click-through-phone click-through-url click-through-optin data-through facebook-options popup_style-content popup_style-onload popup_style-popup"
							{if $settings.popup_style != 'contentbox'} style="display: block;"{else} style="display: none;"{/if}>
								<div class="form-group">
									<label class="option-page data click-through-url click-through-optin data-through facebook-options">Display Call-To-Action button:</label>
									<label class="hidden click-through-phone data-through">Display Click-To-Call button:</label>
									<div class="radio radio-primary">
										<input type="radio" name="settings[view_button]" value="1"{if !isset( $settings.view_button ) || $settings.view_button == 1 } checked{/if} class="view_button" />
										<label>Yes</label>
									</div>
									<div class="radio radio-primary">
										<input type="radio" name="settings[view_button]" value="2"{if $settings.view_button == 2 } checked{/if} class="view_button" />
										<label>No</label>
									</div>
								</div>
								<div class="form-group" id="button-block" {if !isset( $settings.view_button ) || $settings.view_button == 1 } style="display: block;"{else} style="display: none;"{/if}>
									<label>Button:</label>
										<a href="{url name='site1_squeeze' action='buttons' wp='flg_type=buttons'}" class="popup-squeeze option-page data click-through-url click-through-optin data-through facebook-options"{if $settings.type_page_through == 2 }style="display:none;"{/if}>select or upload</a>
									<a href="{url name='site1_squeeze' action='buttons' wp='flg_type=phone_buttons'}" class="popup-squeeze click-through-phone data-through"{if $settings.type_page_through != 2 } style="display:none;"{/if}>select or upload</a>
									<div>
										{if isset( $settings.button_type ) && $settings.button_type == 'upload'}
										<img src="{img src=".{$settings.button}" w='100' h='100'}" id="default_button" />
										{else}
											{if $settings.type_page_through == 2 }
										<img src="{img src="./usersdata/squeeze/phonebuttons/{$settings.button}" w='100' h='100'}" id="default_button" />
											{else}
										<img src="{img src="./usersdata/squeeze/buttons/{$settings.button}" w='100' h='100'}" id="default_button" />
											{/if}
										{/if}
									</div>
									<input type="hidden" name="settings[button]"  class="medium-input text-input" id="button-select"  value="{$settings.button}" />
									<input type="hidden" name="settings[button_type]" id="button-type" value="{$settings.button_type}" />
									<div style="display:none;" id="button-file-box">
										<input type="file" name="button" id="button-file" />
									</div>
									<div class="form-group">
										<label>Button Show Delay: </label>
										<input type="text" name="settings[button_delay]" class="form-control" value="{$settings.button_delay}"> seconds
										<br /><em>Button appears with this delay after popup show. Set "0" for immediate start.</em>
									</div>
									<div class="form-group">
										<label>Button Effect:</label>
										<select name="settings[button_effect]" class="btn-group selectpicker show-tick"{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>
											<option value="none"{if !isset($settings.button_effect)||$settings.button_effect=='none'} selected="selected"{/if}>None</option> 
											<option value="tada"{if $settings.button_effect=='tada'} selected="selected"{/if}>Tada</option> 
											<option value="flash"{if $settings.button_effect=='flash'} selected="selected"{/if}>Flash</option> 
											<option value="shake"{if $settings.button_effect=='shake'} selected="selected"{/if}>Shake</option>
											<option value="bounce"{if $settings.button_effect=='bounce'} selected="selected"{/if}>Bounce</option>
											<option value="pulse"{if $settings.button_effect=='pulse'} selected="selected"{/if}>Pulse</option>
											<option value="swing"{if $settings.button_effect=='swing'} selected="selected"{/if}>Swing</option> 
											<option value="wiggle"{if $settings.button_effect=='wiggle'} selected="selected"{/if}>Wiggle</option>
											<option value="wobble"{if $settings.button_effect=='wobble'} selected="selected"{/if}>Wobble</option>
											<option value="fadein"{if $settings.button_effect=='fadein'} selected="selected"{/if}>Fade-In</option>
										</select>
									</div>
								</div>
								<div class="" id="link-block"{if $settings.view_button == 2 } style="display: block;"{else} style="display: none;"{/if}>
									<p>
										<label>Link Text:</label>
										<textarea name="settings[link]" id="linktext" style="height: 80px;">{$settings.link}</textarea>
									</p>
								</div>
							</div>
							<p class="popup_style-content popup_style-onload popup_style-popup"
							{if $settings.popup_style != 'contentbox'} style="display: block;"{else} style="display: none;"{/if}>
								<label>Fineprint:</label>
								<textarea class="medium-input textarea" style="height: 100px;" id="fineprint"  name="settings[fineprint]">{if isset( $settings.header )}{$settings.fineprint}{else}<em>We hate spam as much as you do and we respect your <a href="privacy.php">privacy</a>. </em><em>Access links will be sent once you confirm your email address.</em>{/if}</textarea>
								<a href="#" id="revert">Revert to default</a>
							</p>
							<p>
								<label>Bottom navigation link</label>
								<textarea class="" id="nav_link" name="settings[nav_link]">{if !empty($id)}{$settings.nav_link}{else}<a href="privacy.php">Privacy Policy</a>{/if}</textarea>
							</p>
						</div>
					</fieldset>            
				</div>
			</div>
		</div> 
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" aria-expanded="false" class="collapsed">SEO</a>
				</h4>
			</div>
			<div id="collapseTwo-2" class="panel-collapse collapse" aria-expanded="false">
				<div class="panel-body">
					<fieldset>
						<div class="form-group">
							<label class="label-control">Title:</label>
							<input name="settings[title]" class="form-control" value="{$settings.title}">
						</div>
						<div class="form-group">
							<label class="label-control">Keywords:</label>
							<input name="settings[keywords]" class="form-control" value="{$settings.keywords}">
						</div>
						<div class="form-group">
							<label class="label-group">Description:</label>
							<input name="settings[description]" class="form-control" value="{$settings.description}">
						</div>
					</fieldset>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseThree-2" aria-expanded="false" class="collapsed">Design</a>
				</h4>
			</div>
			<div id="collapseThree-2" class="panel-collapse collapse" aria-expanded="false">
				<div class="panel-body">
                	<fieldset>
						<div class="form-group">
							<label>Background:</label>
							<select id="background-type" class="btn-group selectpicker show-tick" name="settings[type_background]">
								<option value="image"{if !isset($settings.type_background) || $settings.type_background=='image' } selected="selected"{/if}>Image</option>
								<option value="color"{if $settings.type_background=='color' } selected="selected"{/if}>Color</option>
								<option value="upload"{if $settings.type_background=='upload' } selected="selected"{/if}>Upload image</option>
								<option value="youtube"{if $settings.type_background=='youtube' } selected="selected"{/if}{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>Youtube Video</option>
								<option value="mp4"{if $settings.type_background=='mp4' } selected="selected"{/if}{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>MP4 Video</option>
								{if Core_Acs::haveAccess( array( 'email test group' ) )}<option value="vimeo"{if $settings.type_background=='vimeo' } selected="selected"{/if}{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>Vimeo</option>{/if}
							</select>
						</div>
						<div id="upload" class="backgrounds-types"{if $settings.type_background == 'upload' } style="display: block;"{else} style="display: none;"{/if}>
							<div class="form-group">
								<label class="label-control">Upload:</label>
								{if isset( $settings.upload )}
								<div>
									<img src="{$settings.upload}" width="200px" id="background_upload" />
									<input type="hidden" name="settings[upload]" value="{$settings.upload}" />
								</div>
								{/if}
								<input type="file" name="upload" data-buttonname="btn-white" tabindex="-1" style="position: absolute; clip: rect(0px 0px 0px 0px);" class="filestyle" id="background_upload_input" />
								<div class="bootstrap-filestyle input-group">
									<input type="text" class="form-control" placeholder="" disabled=""> 
									<span class="group-span-filestyle input-group-btn" tabindex="0">
										<label for="background_upload_input" class="btn btn-white ">
											<span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> 
											<span class="buttonText">Choose file</span>
										</label>
									</span>
								</div>
							</div>
						</div>
						<div class="background_upload background_color background_image backgrounds-types"{if !isset($settings.type_background) or $settings.type_background == 'upload' or $settings.type_background == 'color' or $settings.type_background == 'image' } style="display: block;"{else} style="display: none;"{/if}>
						<p>
							<label>Body Color:</label>
							<input type="text" name="settings[body_color]" value="{$settings.body_color}" id="body_color" class="medium-input text-input color-picker" />
							<span id="body_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
						</p>
						<p>
							<div>
								<label>Background<br/>transparency: <span class="text"></span> </label>
								<div style="clear:both;"></div>
								<div id="slider4" class="slider_promotions" >
									<div class="knob"></div>
								</div>
								<input type="hidden" name="settings[background_transparency]" value="{$settings.background_transparency|default:0}" />
							</div>
						</p>
						</div>
						<div class="background_upload background_image backgrounds-types"{if !isset($settings.type_background) or $settings.type_background == 'upload' || $settings.type_background == 'image' } style="display: block;"{else} style="display: none;"{/if}>
							<div class="form-group">
								
								<input type="hidden" name="settings[image_blur]" value="0" />
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[image_blur]" class="medium-input text-input" value="1"{if $settings.image_blur=='1' } checked{/if} />
									<label>Blur image:</label>
								</div>
								
							</div>
						</div>
						<div id="color" class="backgrounds-types"{if $settings.type_background == 'color' } style="display: block;"{else} style="display: none;"{/if}>
							<p>
								<label>Background Color:</label>
								<input type="text" name="settings[background_color]" value="{$settings.background_color}" id="background_color" class="medium-input text-input" />
								<span id="background_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							</p>
						</div>
						{if !Core_Acs::haveAccess( 'Easy Optin Page Light' )}
						<div id="youtube" class="backgrounds-types"{if $settings.type_background == 'youtube' } style="display: block;"{else} style="display: none;"{/if}>
							<div class="form-group">
								<label class="label-control">Youtube link:</label>
								<input type="text" name="settings[youtube]" class="form-control" value="{$settings.youtube}" />
							</div>
							{*<p>
								<label>Start time [sec.]:</label>
								<input type="text" name="settings[youtube_start]" value="0" class="medium-input text-input" />
							</p>*}
							<div class="form-group">
								<input type="hidden" name="settings[youtube_loop]" value="0" />
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[youtube_loop]" value="1"{if !isset( $settings.youtube_loop ) || $settings.youtube_loop==1} checked{/if} />
									<label>Loop:</label>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[youtube_pause]" value="true"{if $settings.youtube_pause=='true'} checked{/if} />
									<label>Allow to pause:</label>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[youtube_sound]" value="1"{if $settings.youtube_sound==1} checked{/if} />
									<label>Sound:</label>
								</div>
							</div>
						</div>
						<div id="vimeo" class="backgrounds-types"{if $settings.type_background == 'vimeo' } style="display: block;"{else} style="display: none;"{/if}>
							<div class="form-group">
								<label class="label-control">Vimeo link:</label>
								<input type="text" name="settings[vimeo]" class="form-control" value="{$settings.vimeo}" />
							</div>
							<div class="form-group">
								<input type="hidden" name="settings[vimeo_loop]" value="0" />
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[vimeo_loop]" value="1"{if !isset( $settings.vimeo_loop ) || $settings.vimeo_loop==1} checked{/if} />
									<label>Loop:</label>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[vimeo_pause]" value="true"{if $settings.vimeo_pause=='true'} checked{/if} />
									<label>Allow to pause:</label>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[vimeo_sound]" value="1"{if $settings.vimeo_sound==1} checked{/if} />
									<label>Sound:</label>
								</div>
							</div>
						</div>
						{/if}
						<div id="mp4" class="backgrounds-types"{if $settings.type_background == 'mp4' } style="display: block;"{else} style="display: none;"{/if}>
							<div class="form-group">
								<label class="label-control">MP4 link:</label>
								<input type="text" name="settings[mp4]" class="form-control" value="{$settings.mp4}" />
							</div>
							<div class="form-group">
								<input type="hidden" name="settings[mp4_loop]" value="0" />
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[mp4_loop]" value="1"{if !isset( $settings.mp4_loop ) || $settings.mp4_loop==1} checked{/if} />
									<label>Loop:</label>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[mp4_pause]" value="true"{if $settings.mp4_pause=='true'} checked{/if} />
									<label>Allow to pause:</label>
								</div>
								
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[mp4_sound]" value="1"{if $settings.mp4_sound==1} checked{/if} />
									<label>Sound:</label>
								</div>
							</div>
						</div>
						<div id="image" class="backgrounds-types"{if !isset($settings.type_background) || $settings.type_background == 'image' } style="display: block;"{else} style="display: none;"{/if}>
							<label>Image:</label>
							<a href="{url name='site1_squeeze' action='backgrounds'}" title="Select Image" class="popup_bg">select</a>
							<br/><br/>
							<div>
							{if $settings.background_google == 1}
							<img src="{$settings.background}" width="200px" id="default_background" />
							{else}
							<img src="{img src="./usersdata/squeeze/backgrounds/{$settings.background}" w='200' h='200'}" id="default_background" />
							{/if}
							</div>
							<input type="hidden" name="settings[background]"  class="medium-input text-input" id="background-select" value="{$settings.background}" />
							<input type="hidden" name="settings[background_google]"  class="medium-input text-input" id="background-select-google"  value="{$settings.background_google}" />
							<br/><br/>
						</div>
						<div class="popup_style-content popup_style-contentbox" {if $settings.popup_style=="onload" || $settings.popup_style=="onload"}style="display:none;"{/if}>
							<div>
								<label>Box position:</label>
								<div id="box-position-block" class="droppables">
									<div id="box-position"  ></div>
								</div>
								<input type="hidden" name="settings[box_position_left]" id="box_position_left" value="{$settings.box_position_left}" />
								<input type="hidden" name="settings[box_position_top]" id="box_position_top" value="{$settings.box_position_top}" />
								<input type="hidden" name="settings[box_position_right]" id="box_position_right" value="{$settings.box_position_right}" />
								<input type="hidden" name="settings[box_position_bottom]" id="box_position_bottom" value="{$settings.box_position_bottom}" />
							</div>
						
							<style>{literal}
								#box-position-block{
									width:350px;
									height: 165px;
									background: #BABABA;
									position: relative;
								}
								#box-position{
									width: 150px;
									height: 75px;
									background: #000;
									position: absolute;
									cursor: move;
								}
								.slider_promotions {
								    background: #CCC;
								    height: 1.5em;
								    width: 200px;
								    margin: 0 0 0 186px;
								    top: -1.5em;
								    position: relative;
								}
								.slider_promotions .knob {
								    background: #000;
								    width: 16px;
								    height: 1.5em;
								    cursor: move;
								}
							{/literal}</style>
							<div class=" popup_style-content popup_style-onload popup_style-popup"{if $settings.popup_style != 'contentbox'} style="display: block;"{else} style="display: none;"{/if}>
								<div class="form-group">
									<label class="label-control">Box width [px]:</label>
									<input type="text" name="settings[box_width]" id="width-box" value="{$settings.box_width|default:585}" class="form-control">
								</div>
								<div class="form-group">
									<label>Box background color:</label>
									<input type="text" name="settings[box_background]" value="{$settings.box_background}" id="box_background" class="medium-input text-input color-picker" />
									<span id="box_background_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</div>
								<div class="form-group">
									<label>Box border color:</label>
									<input type="text" name="settings[box_border_color]" value="{$settings.box_border_color}" id="box_border_color" class="medium-input text-input color-picker" />
									<span id="box_border_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</div>
								<div class="form-group">
									<div>
										<label>Box transparency: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div id="slider3" class="slider_promotions" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[box_transparency]" value="{$settings.box_transparency|default:0}" />
									</div>
								</div>
								<div class="form-group">
									<div>
										<label>Box border radius: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div id="slider2" class="slider_promotions" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[box_border_radius]" value="{$settings.box_border_radius|default:25}" />
									</div>
								</div>
								<div class="form-group">
									<div>
										<label>Box border width: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div id="slider" class="slider_promotions" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[box_border_width]" value="{$settings.box_border_width|default:3}" />
									</div>
								</div>
								<div class="form-group">
									<label>Box border style:</label>
									<select name="settings[box_border_style]" class="btn-group selectpicker show-tick">
										<option value="none"{if $settings.box_border_style=='none' } selected="selected"{/if}>None</option>
										<option value="dashed"{if $settings.box_border_style=='dashed' } selected="selected"{/if}>Dashed</option>
										<option value="dotted"{if $settings.box_border_style=='dotted' } selected="selected"{/if}>Dotted</option>
										<option value="double"{if $settings.box_border_style=='double' } selected="selected"{/if}>Double</option>
										<option value="groove"{if $settings.box_border_style=='groove' } selected="selected"{/if}>Groove</option>
										<option value="hidden"{if $settings.box_border_style=='hidden' } selected="selected"{/if}>Hidden</option>
										<option value="inherit"{if $settings.box_border_style=='inherit' } selected="selected"{/if}>Inherit</option>
										<option value="inset"{if $settings.box_border_style=='inset' } selected="selected"{/if}>Inset</option>
										<option value="outset"{if $settings.box_border_style=='outset' } selected="selected"{/if}>Outset</option>
										<option value="ridge"{if $settings.box_border_style=='ridge' } selected="selected"{/if}>Ridge</option>
										<option value="solid"{if !isset($settings.box_border_style) || $settings.box_border_style=='solid' } selected="selected"{/if}>Solid</option>
									</select>
								</div>
								<div class="form-group">
									<label>Box Effect:</label>
									<select name="settings[box_effect]" class="btn-group selectpicker show-tick"{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>
										<option value="none"{if !isset($settings.box_effect) || $settings.box_effect=='none' } selected="selected"{/if}>None</option> 
										<option value="tada"{if $settings.box_effect=='tada' } selected="selected"{/if}>Tada</option> 
										<option value="flash"{if $settings.box_effect=='flash' } selected="selected"{/if}>Flash</option> 
										<option value="shake"{if $settings.box_effect=='shake' } selected="selected"{/if}>Shake</option>
										<option value="bounce"{if $settings.box_effect=='bounce' } selected="selected"{/if}>Bounce</option>
										<option value="pulse"{if $settings.box_effect=='pulse' } selected="selected"{/if}>Pulse</option>
										<option value="swing"{if $settings.box_effect=='swing' } selected="selected"{/if}>Swing</option> 
										<option value="wiggle"{if $settings.box_effect=='wiggle' } selected="selected"{/if}>Wiggle</option>
										<option value="wobble"{if $settings.box_effect=='wobble' } selected="selected"{/if}>Wobble</option>
										<option value="fadein"{if $settings.box_effect=='fadein' } selected="selected"{/if}>Fade-In</option>
									</select>
								</div>
								<div class="form-group">
									<label class="label-control">Box bottom shadow:</label>
									<div class="radio radio-primary">
										<input type="radio" name="settings[box_bottom_shadow]" value="1"{if $settings.box_bottom_shadow==1 } checked{/if} />
										<label>Yes</label>
									</div>
									<div class="radio radio-primary">
										<input type="radio" name="settings[box_bottom_shadow]" value="0"{if !isset($settings.box_bottom_shadow) || $settings.box_bottom_shadow==0 } checked{/if} />
										<label>No</label>
									</div>
								</div>
							</div>
						</div>
						<div class=" popup_style-content popup_style-onload popup_style-popup"{if $settings.popup_style != 'contentbox'} style="display: block;"{else} style="display: none;"{/if}>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" id="header_color_box" class="check_color_settings" name="settings[fg_header_color]" value="1"{if isset( $settings.fg_header_color ) && $settings.fg_header_color==1} checked{/if} />
									<label>Header background</label>
								</div>
							</div>
							<div class="header_color_box" {if !isset( $settings.fg_header_color ) || $settings.fg_header_color!=1} style="display: none;"{/if}>
								<div class="form-group">
									<label>Header background color:</label>
									<input type="text" name="settings[header_color]" value="{$settings.header_color}" id="header_color" class="boxes_colors medium-input text-input color-picker" />
									<span id="header_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</div>
								<div class="form-group">
									<div>
										<label>Header background<br/>transparency: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div class="slider_promotions slider_transparents" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[header_color_transparency]" value="{$settings.header_color_transparency|default:0}" />
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" id="optin_color_box" class="check_color_settings" name="settings[fg_optin_color]" value="1"{if isset( $settings.fg_optin_color ) && $settings.fg_optin_color==1} checked{/if} />
									<label>Optin background</label>
								</div>
							</div>
							<div class="optin_color_box"{if !isset( $settings.fg_optin_color ) || $settings.fg_optin_color!=1} style="display: none;"{/if}>
								<div class="form-group">
									<label>Optin background color:</label>
									<input type="text" name="settings[optin_color]" value="{$settings.optin_color}" id="optin_color" class="boxes_colors medium-input text-input color-picker" />
									<span id="optin_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</div>
								<div class="form-group">
									<div>
										<label>Optin background<br/>transparency: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div class="slider_promotions slider_transparents" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[optin_color_transparency]" value="{$settings.optin_color_transparency|default:0}" />
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" id="video_color_box" class="check_color_settings" name="settings[fg_video_color]" value="1"{if isset( $settings.fg_video_color ) && $settings.fg_video_color==1} checked{/if} />
									<label>Video background</label>
								</div>
							</div>

							<div class="video_color_box" {if !isset( $settings.fg_video_color ) || $settings.fg_video_color!=1} style="display: none;"{/if}>
								<div class="form-group">
									<label>Video background color:</label>
									<input type="text" name="settings[video_color]" value="{$settings.video_color}" id="video_color" class="boxes_colors medium-input text-input color-picker" />
									<span id="video_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</div>
								<div class="form-group">
									<div>
										<label>Video background<br/>transparency: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div class="slider_promotions slider_transparents" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[video_color_transparency]" value="{$settings.video_color_transparency|default:0}" />
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="checkbox checkbox-primary">
									<input type="checkbox" id="fineprint_color_box" class="check_color_settings" name="settings[fg_fineprint_color]" value="1"{if isset( $settings.fg_fineprint_color ) && $settings.fg_fineprint_color==1} checked{/if} />
									<label>Fineprint background</label>
								</div>
							</div>
							<div class="fineprint_color_box" {if !isset( $settings.fg_fineprint_color ) || $settings.fg_fineprint_color!=1} style="display: none;"{/if}>
								<div class="form-group">
									<label>Fineprint background color:</label>
									<input type="text" name="settings[fineprint_color]" value="{$settings.fineprint_color}" id="fineprint_color" class="boxes_colors medium-input text-input color-picker" />
									<span id="fineprint_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</div>
								<div class="form-group">
									<div>
										<label>Fineprint background<br/>transparency: <span class="text"></span> </label>
										<div style="clear:both;"></div>
										<div class="slider_promotions slider_transparents" >
											<div class="knob"></div>
										</div>
										<input type="hidden" name="settings[fineprint_color_transparency]" value="{$settings.fineprint_color_transparency|default:0}" />
									</div>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label>Users CSS styles</label>
							<textarea name="settings[user_css_styles]" class="form-control">{$settings.user_css_styles}</textarea>
						</div>

						<div class="form-group">
							<label>Fallback Color</label>
							<input type="text" name="settings[fallback_color]" value="{$settings.fallback_color}" id="fallback_color" class="medium-input text-input color-picker" />
							<span id="fallback_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
						</div>
					</fieldset>                   
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFour-2" aria-expanded="false" class="collapsed">Sound</a>
				</h4>
			</div>
			<div id="collapseFour-2" class="panel-collapse collapse" aria-expanded="false">
				<div class="panel-body">
                	<fieldset>
						<div class="form-group">
							<label class="label-control">Play Sound? </label>
							<div class="radio radio-primary">
								<input type="radio" name="settings[flg_sound]" {if $settings.flg_sound == '0' || !isset($settings.flg_sound)}checked{/if} value="0" class="flg_sound"/>
								<label>No</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" name="settings[flg_sound]" {if $settings.flg_sound == '1'}checked{/if} value="1" class="flg_sound"/>
								<label>Yes</label>
							</div>
						</div>
						<div class="flg_sound"{if $settings.flg_sound==1 } style="display: block;"{else} style="display: none;"{/if}>
							<label>Sound File: </label>
							<div id="clear_sound_file">
							{foreach from=$settings.sound_files item=file}
								<div id="file_p{$file.id}" rel="{$file.id}">
									<audio src="{$file.path_web}{$file.name_system}" preload="none"></audio>
									<input type="hidden" class="add_value_data" name="settings[flg_sound_volume][{$file.id}]" value="{if isset($settings.flg_sound_volume[$file.id]) }{$settings.flg_sound_volume[$file.id]}{else}1{/if}" />
									<br/>
									<div class="checkbox checkbox-primary">
										<input type="checkbox" name="settings[flg_sound_loop][{$file.id}]" value="1"{if isset($settings.flg_sound_loop[$file.id]) && $settings.flg_sound_loop[$file.id]==1 } checked{/if} />
										<label>Loop</label>
									</div>
									<br/>
									<a href="#button" class="sound_remover_button button" rel="{$file.id}" element-data="p" onclick="return false;">Remove</a>
									<br/>
								</div>
							{/foreach}
							</div>
							<div id="clear_user_sound_file">{foreach from=$settings.sound_user_files item=file}
								<div id="file_u{$file.id}"  rel="{$file.id}">
									<audio src="{$file.path_web}{$file.name_system}" preload="none"></audio>
									<input type="hidden" class="add_value_data" name="settings[flg_sound_volume][{$file.id}]" value="{if isset($settings.flg_sound_volume[$file.id]) }{$settings.flg_sound_volume[$file.id]}{else}1{/if}" />
									<br/>
									<div class="checkbox checkbox-primary">
										<input type="checkbox" name="settings[flg_sound_loop][{$file.id}]" value="1"{if isset($settings.flg_sound_loop[$file.id]) && $settings.flg_sound_loop[$file.id]==1 } checked{/if} />
										<label>Loop</label>
									</div>
									<br/>
									<a href="#button" class="sound_remover_button button" rel="{$file.id}" element-data="u" onclick="return false;">Remove</a>
									<br/>
								</div><br/>
							{/foreach}
							</div>
							<p>&nbsp;Select&nbsp;{if Core_Acs::haveAccess( 'Easy Optin Page Light' )}<span >Premium</span>{else}<a rel="" href="{url name='site1_squeeze' action='default_sounds'}" title="Select Premium audio files" class="popup_mb">Premium</a>{/if}&nbsp;or&nbsp;<a rel="" href="{url name='site1_squeeze' action='user_sounds'}" title="Select Your Own Audio Files" class="popup_mb">Use&nbsp;Your&nbsp;Own</a>&nbsp;audio files</p>
							<input type="hidden" id="file_sound" value="{$settings.file_sound}" name="settings[file_sound]"/>
							<input type="hidden" id="file_user_sound" value="{$settings.file_user_sound}" name="settings[file_user_sound]"/>
						</div>
					</fieldset>                
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFive-2" aria-expanded="false" class="collapsed">Advanced Settings</a>
				</h4>
			</div>
			<div id="collapseFive-2" class="panel-collapse collapse" aria-expanded="false">
				<div class="panel-body">
                	<fieldset>
						<div class="form-group">
							<label class="label-control">Delay: </label>
							<div class="radio radio-primary">
								<input type="radio" id="no_delay" name="settings[flg_delay]" value="0"{if $settings.flg_delay == '0' || !isset($settings.flg_delay)} checked{/if} class="flg_delay"/>
								<label>No</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" id="get_delay" name="settings[flg_delay]" value="1"{if $settings.flg_delay == '1'} checked{/if} class="flg_delay"/>
								<label>Yes</label>
							</div>
						</div>
						<div class="flg_delay"{if $settings.flg_delay ==1} style="display:block;"{else} style="display: none;"{/if}>
							<label class="label-control">Delay Time (s): </label>
							<input type="text" name="settings[delay]" value="{$settings.delay|default:0}" class="form-control">
						</div>
						
						<div class="form-group">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" name="settings[flg_misc]" id="exit_pop_settings" value="1"{if $settings.flg_misc == '1'} checked{/if} />
								<label>Exit Pop</label>
							</div>
						</div>
						<div id="exit_pop-block" class=""{if $settings.flg_misc == '1'} style="display:block;"{else} style="display: none;"{/if} >
							<div class="form-group">
								<label class="label-control">Exit Pop Message:</label>
								<input type="text" name="settings[exit_pop_message]" class="form-control" value="{$settings.exit_pop_message}" />
							</div>
							<div class="form-group">
								<label class="label-control">Exit Pop Url:</label>
								<input type="text" name="settings[exit_pop_url]" class="form-control" value="{str_replace('"',"'", $settings.exit_pop_url)}" />
							</div>
						</div>

						<div class="form-group">
							<label class="label-control">Tracking (to be added in head section):</label>
							<textarea name="settings[tracking_code]" class="form-control">{$settings.tracking_code}</textarea>
						</div>
						<div class="form-group">
							<label class="label-control">Tracking (to be added in body section):</label>
							<textarea name="settings[tracking_code_body]" class="form-control">{$settings.tracking_code_body}</textarea>
						</div>
						
						<div class="form-group">
							<input type="hidden" name="settings[flg_ads_widget]" value="2" />
							{if !Core_Acs::haveAccess( 'Easy Optin Page Light' )}
								<div class="checkbox checkbox-primary">
									<input type="checkbox" name="settings[flg_ads_widget]" value="1"{if !isset( $settings.flg_ads_widget ) || $settings.flg_ads_widget == 1} checked{/if} />
									<label>Show "Powered by"</label>
								</div>
							{else}
								<div class="checkbox checkbox-primary">
									<input type="checkbox" checked disabled="disabled" />
									<label>Show "Powered by"</label>
								</div>
							{/if}
						</div>
						
						<div class="form-group">
							<label class="label-control">Geo Location Traffic Redirect:</label>
							<div class="radio radio-primary">
								<input type="radio" name="settings[flg_geo_location]"{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{else} value="1"{/if}{if $settings.flg_geo_location==1} checked{/if} class="flg_geo" />
								<label>Yes</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" name="settings[flg_geo_location]" value="0"{if !isset($settings.flg_geo_location) || $settings.flg_geo_location==0 || Core_Acs::haveAccess( 'Easy Optin Page Light' )} checked{/if} class="flg_geo" />
								<label>No</label>
							</div>
						</div>
						{if !Core_Acs::haveAccess( 'Easy Optin Page Light' )}<div class="flg_geo"{if $settings.flg_geo_location == 1} style="display:block;"{else} style="display: none;"{/if}>
							<label class="label-control">Allowed Countries: </label>
							<div style="width: 100%; height: 210px; overflow : auto;">
							{foreach from=Project_Squeeze::getCountries() item=i key=k}
							<div class="checkbox checkbox-primary">
								<input type="checkbox" name="settings[geo_enabled][{$i.country}]" value="{$k}" rel="{$i.country}"{if isset($settings.geo_enabled[$i.country]) && $settings.geo_enabled[$i.country]==$k } checked{/if} class="geo_checkbox geo_changeopt"/>
								<label>{$i.country}</label>
							</div>
							<div {if !isset($settings.geo_enabled[$i.country]) || $settings.geo_enabled[$i.country]!=$k } style="display:none;"{/if} id="open_geo_{$k}">
								<div class="checkbox checkbox-custum" style="margin-left: 20px;">
									<input type="checkbox" rel="{$k}" class="geo_changeopt_unselect geo_changeopt_{$k}_unselect" />
									<label>Unselect All {$i.country}</label>
								</div>
							{if !empty( $i.states )}
								{foreach from=$i.states item=is key=ks}
								<div class="checkbox checkbox-custum" style="margin-left: 20px;">
									<input type="checkbox" name="settings[geo_enabled][{$i.country} {$is}]" value="{$k}.{$ks}" data-unselect="{$k}" rel="{$i.country} {$is}"{if isset($settings.geo_enabled[{$i.country|cat:' '|cat:$is}]) && $settings.geo_enabled[{$i.country|cat:' '|cat:$is}]=={$k|cat:'.'|cat:$ks} } checked{/if} class="geo_state_{$k}_checkbox geo_changeopt_only" />
									<label>{$is}</label>
								</div>
								{/foreach}
							{/if}
							</div>
							{/foreach}
							</div>
							<div class="form-group">
								<label class="label-control">Alternate URL (for All Disallowed Countries):</label>
								<input type="text" name="settings[geo_redirect_url]" value="{$settings.geo_redirect_url}" class="form-control" />
							</div>
							<p>
								<label>Specify Alternate URLs for Selected Countries&nbsp;
								<img src="/skin/i/frontends/design/newUI/exquisite_popups/unblock.png" title="Add Alternate URLs for Selected Country" id="add_new_country"/></label>
							</p>
							<div style="width: 100%; height: auto;" id="alternate_urls">
								{foreach from=Project_Squeeze::getCountries() item=i key=k}
								{if !empty( {$settings.geo_redirect_urls.{$k}} )}
								<p id="alternate_{$i.country}">
									<select class="all_not_selected_countries btn dropdown-toggle btn-info" default-option="{$k}"></select>
									<input type="text" name="settings[geo_redirect_urls][{$k}]" value="{$settings.geo_redirect_urls.{$k}}" class="medium-input text-input form-control" />
									<img src="/skin/i/frontends/design/newUI/exquisite_popups/block.png" title="Remove this Alternate URLs for Selected Country" class="remove_this_country_url" rel="{$i.country}"/>
								</p>
								{/if}
								{if !empty( $i.states )}
									{foreach from=$i.states item=is key=ks}
									{if !empty( {$settings.geo_redirect_urls[{$k|cat:'.'|cat:$ks}]} )}
									<p id="alternate_{$is}">
										<select class="all_not_selected_countries btn dropdown-toggle btn-info" default-option="{$k}.{$ks}"></select>
										<input type="text" name="settings[geo_redirect_urls][{$k}.{$ks}]" value="{$settings.geo_redirect_urls[{$k|cat:'.'|cat:$ks}]}" class="medium-input text-input form-control" />
										<img src="/skin/i/frontends/design/newUI/exquisite_popups/block.png" title="Remove this Alternate URLs for Selected Country" class="remove_this_country_url" rel="{$is}"/>
									</p>
									{/if}
									{/foreach}
								{/if}
								{/foreach}
							</div>
						</div>{/if}
					</fieldset>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseSix-2" aria-expanded="false" class="collapsed">Publishing Options</a>
				</h4>
			</div>
			<div id="collapseSix-2" class="panel-collapse collapse" aria-expanded="false">
				<div class="panel-body">
                	<fieldset>
						<div class="form-group">
							<div class="radio radio-primary">
								<input type="radio" name="settings[publishing_options]" value="download"{if $settings.publishing_options == 'download'} checked{/if} class="publishing_options_select">
								<label>Download</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" name="settings[publishing_options]" value="external"{if $settings.publishing_options == 'external'} checked{/if} class="publishing_options_select"{if Core_Acs::haveAccess( 'Easy Optin Page Light', 'LPS Entrepreneur', 'Lead Funnels Starter' )} disabled="disabled"{/if}>
								<label>Publish to Domain on Your Own Server</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" name="settings[publishing_options]" value="remote"{if $settings.publishing_options == 'remote'} checked{/if} class="publishing_options_select"{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>
								<label>Publish to Domain Hosted with iFunnels</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" name="settings[publishing_options]" value="local" {if $settings.publishing_options == 'local' || !isset( $settings.publishing_options )} checked{/if} class="publishing_options_select"{if Core_Acs::haveAccess( 'Easy Optin Page Light' )} disabled="disabled"{/if}>
								<label>1-click SSL Hosting</label>
							</div>
							{if Core_Acs::haveAccess( array( 'email test group', 'LPS Professional', 'lps platinum' ) )}
							<div class="radio radio-primary">
								<input type="radio" name="settings[publishing_options]" value="local_nossl"{if $settings.publishing_options == 'local_nossl'} checked{/if} class="publishing_options_select">
								<label>1-click No SSL Hosting</label>
							</div>
							{/if}
							<input type="hidden" id="previous_publishing_options" value="{$settings.publishing_options}">
						</div>
						{if !Core_Acs::haveAccess( 'Easy Optin Page Light' )}<div id="hosting_settings" class="publishing_options publishing_options_external publishing_options_remote" style="display:{if $settings.publishing_options == 'remote' || $settings.publishing_options == 'external'}block{else}none{/if};">
							{module name='site1_hosting' action='select' selected=$settings arrayName='settings'}
						</div>{/if}
					</fieldset>
				</div>
			</div>
		</div> 
		<fieldset class="m-t-10">
			<button class="btn btn-success btn-rounded waves-effect waves-light" type="button" value="Generate" id="generate" disabled>Generate</button>
			<button class="btn btn-success btn-rounded waves-effect waves-light" type="button" value="Preview" id="preview" disabled>Preview</button>
			<input type="submit" style="display: none;" value="Submit" />
		</fieldset>
	</div>
</form>

{literal}
<script type="text/javascript">
var urlPreview='{/literal}{url name='site1_squeeze' action='example'}{literal}';
var urlGenerate='{/literal}{url name='site1_squeeze' action='customization'}{literal}';
var multibox={};
var updateSoundRemover=function(){};
var updateSoundVolume=function(){};
window.addEvent('domready',function(){

	$$('input[name="settings[popup_options][display_mode]"]').each( function(elt){
		elt.addEvent( "click", function() {
			$$(".flg_mode").hide();
			$$(".flg_mode_"+$(this).value).show();
		});
	});

	updateSoundVolume=function(){
		var as=false;
		audiojs.events.ready(function() {
			var audios=document.getElementsByTagName('audio');
			var as=new Array();
			if( audios.length > 0 ){
				for( i=0; i<=audios.length-1; i++ ){
					var elt=audios[i];
					if( !$(elt.parentElement).hasClass( 'audiojs' ) ){
						as.push( audiojs.create( elt ) );
					}
				}
				as.each( function(elt){
					elt.element.onvolumechange=function( e ){
						if( typeof e != 'undefined' ){
							var parentElt=$( e.target ).getParent( '.audiojs' );
							if( typeof parentElt != 'undefined' ){
								var oldElement=parentElt.getParent().getChildren( '.add_value_data' );
								if( oldElement.length != 0 ){
									$(oldElement[0]).set( 'value', e.target.volume );
								}else{
									parentElt.getParent().adopt( new Element( 'input', {'type':'hidden', 'class':'add_value_data', 'name':'settings[flg_sound_volume]['+parentElt.getParent().get('rel')+']' }).set( 'value', e.target.volume ) );
								}
							}
						}
						return;
					}
					var haveVolumData=elt.element.getParent( '.audiojs' ).getParent().getChildren( '.add_value_data' );
					if( haveVolumData.length > 0 ){
						elt.element.volume=haveVolumData[0].value;
						var parentElt=$( elt.element ).getParent( '.audiojs' ).getChildren( '.volume' )[0];
						parentElt.getChildren( '.volume_select' )[0].style.width=parentElt.offsetWidth*haveVolumData[0].value+'px';
					}
				} );
			}
		});
	}
	updateSoundRemover=function(){
		$$('.sound_remover_button').addEvent( 'click', function(evt){
			var fileId=evt.target.get( 'rel' );
			var dataType=evt.target.get( 'element-data' );
				var allSoundsEltId='file_user_sound';
			if( dataType=='p' ){
				allSoundsEltId='file_sound';
			}
			var allFiles=$(allSoundsEltId).value;
			if( allFiles != '' ){
				var arrFilesNumbers=allFiles.split(':');
				var index = arrFilesNumbers.indexOf( fileId );
				if (index > -1) {
					arrFilesNumbers.splice(index, 1);
				}
				$(allSoundsEltId).value = arrFilesNumbers.join(':');
			}
			$('file_'+dataType+fileId).destroy();
		});
	}
	updateSoundRemover();
	updateSoundVolume();
	$$('.type-page').addEvent('click',function(){
		$$('.data').hide();
		$$('.data-through').hide();
		$$('.'+this.get('id')).show();
		if( this.get('id') == 'click-through' ){
			$$('.type-page-through').each( function(elt){
				if( elt.checked ){
					$(elt).fireEvent( 'click' );
				}

				//elt.erase('checked')} 
			});
			
			$('type_event').hide();
		}else if( this.get('id') == 'option-page' ){
			$('type_event').show();
			$$('.not-option-page').hide();
			
			$('click-through-optin').fireEvent( 'click' );
		}else if( this.get('id') == 'facebook-msg' ){
			$('type_event').hide();
			$$('.facebook-options').show();
		//	$$('.not-option-page').hide();
		}
	});

	$('option-page').addEvent('click', function(){
		$('type_triggered_mode').hide();
	});
	$('click-through-optin').addEvent('click', function(){
		$('type_triggered_mode').show();
	});

	{/literal}{if Core_Acs::haveAccess( array( 'email test group', 'LPS Professional', 'iFunnels - Business Program' ))}{literal}
	$('run_import').addEvent('click',function(){
		if( $('import_id').get('value')!='' ){
			location.href='{/literal}{url name="site1_squeeze" action="customization"}{literal}?import_id='+$('import_id').get('value');
		}
	});
	{/literal}{/if}
	{if Core_Acs::haveAccess( array( 'email test group', 'lps platinum' ) )}{literal}
	if( $$('#optin_type').length > 0 ){
		var fireEventChangeButonAction=function(elt){
			if(  $($$('.optin_button_action_radio:checked')[0]).get('value') == 'message' ){
				$$('.optin_button_action').hide();
				$$('.optin_button_message').show();
			}else if(  $($$('.optin_button_action_radio:checked')[0]).get('value') == 'redirect' ){
				$$('.optin_button_action').hide();
				$$('.optin_button_redirect').show();
			}
			if( $($$('#optin_type option:selected')[0]).get('value') == 'optin' ){
				$$('.optin_button_action').hide();
			}
		}
		$('optin_type').addEvent('change',function( elt ){
			$$('.mo_optin_group').hide();
			$$('.mo_optin_'+elt.target.get('value')).show();
			fireEventChangeButonAction();
		});
	}
	$$('.optin_button_action_radio').addEvent('change',function(){fireEventChangeButonAction()});
	{/literal}{/if}
	{if Core_Acs::haveAccess( array( 'LPB Admins' ) )}{literal}
	$('flg_template-checker').addEvent('change',function( elt ){
		if( elt.target.checked ){
			$('flg_template-box').show();
		}else{
			$('flg_template-box').hide();
		}
		$$('.data').hide();
		$$('.data-through').hide();
		$$('.'+this.get('id')).show();
		$$('.type-page-through').each( function(elt){
			if( elt.checked ){
				$(elt).fireEvent( 'click' );
			}
			//elt.erase('checked')} 
		});
	});
	{/literal}{/if}{literal}
	$$('.type-page-through').addEvent('click',function(){
		$$('.data-through').hide();
		$$('.'+this.get('id')).show();
	});
	window.checkconfirmchangeurl=false;
	$$('.publishing_options_select').addEvent('click',function(){
		$$('.publishing_options').hide();
		$$('.publishing_options_'+this.get('value')).show();
		if( this.get('value')!=$('previous_publishing_options').get('value') && $('previous_publishing_options').get('value') != '' && !window.checkconfirmchangeurl && $('previous_publishing_options').get('value') != 'local' ){
			alert( "Duplicate this page if you want to change its hosting URL" );
			window.checkconfirmchangeurl=true;
		}
		if( this.get('value')=='remote' || this.get('value')=='external' ){
			var selectElement=$($('hosting_settings').getElementById('domain-settings-id'));
			selectElement.set('value','');
			selectElement.fireEvent('change');
			$('domain-settings-directory').set('local-value',$('domain-settings-directory').get('value'));
			var optgroupRemote=selectElement.getChildren('optgroup[label="Domains hosted with us"]');
			if( optgroupRemote.length>0 ){
				optgroupRemote[0].hide().addClass('hidden');
				if( this.get('value')=='remote' ){
					optgroupRemote[0].removeClass('hidden').show();
				}
			}
			var optgroupExternal=selectElement.getChildren('optgroup[label="Domains you host externally"]');
			if( optgroupExternal.length>0 ){
				optgroupExternal[0].hide().addClass('hidden');
				if( this.get('value')=='external' ){
					optgroupExternal[0].removeClass('hidden').show();
				}
			}
		}
		if( this.get('value')=='local' && $('domain-settings-directory').get('local-value') != undefined ){
			$('domain-settings-directory').set('value',$('domain-settings-directory').get('local-value'));
		}
		jQuery('.selectpicker').selectpicker('refresh');
	});
	$$('.view_button').addEvent('click',function(){
		if(this.get('value')==1){
			$('link-block').setStyle('display','none');
			$('button-block').setStyle('display','block');
		} else {
			$('link-block').setStyle('display','block');
			$('button-block').setStyle('display','none');
		}
	});
	var width=window.getSize().x;
	var height=window.getSize().y;
	var maxWidth='500';
	var maxHeight='500';
	if (width > height) {
	  var ratio  = maxWidth / width;
	} else {
	  var ratio = maxHeight /  height;
	}
	var newWidth=ratio*width;
	var newHeight=ratio*height;
	$('box-position-block').setStyles({
		width:newWidth,
		height:newHeight
	});
	var k=0;
	if((parseInt($('width-box').get('value')))>500){
		k=((parseInt($('width-box').get('value'))/100)-4)*15;
	}
	$('box-position').setStyles({
		width:((parseFloat($('width-box').get('value'))-k)*100/width)+'%',
		height:(270*100/height)+'%'
	});
	$('width-box').addEvent('change', function(){
		var k=0;
		if((parseInt($('width-box').get('value')))>500){
			k=((parseInt($('width-box').get('value'))/100)-4)*15;
		}
		$('box-position').setStyles({
			width:((parseFloat($('width-box').get('value'))-k)*100/width)+'%',
			height:(270*100/height)+'%'
		});
	});
	
	new Drag.Move($('box-position') , {
		droppables: $$('.droppables') ,
		container: $('box-position-block'),
		onComplete: function(dragged,event){
			$('box_position_top').set('value',(parseFloat(dragged.style.top)*100)/newHeight);
			$('box_position_left').set('value',(parseFloat(dragged.style.left)*100)/newWidth);
			$('box_position_bottom').set('value',((parseFloat(dragged.style.top)*100)/newHeight)+parseFloat(dragged.style.height));
			$('box_position_right').set('value',((parseFloat(dragged.style.left)*100)/newWidth)+parseFloat(dragged.style.width));
		}
	});
	
	$('box-position').setStyles({
		top: parseFloat( $('box_position_top').get('value') )*newHeight/100,
		left: parseFloat( $('box_position_left').get('value') )*newWidth/100
	});

	$('box_position_top').set('value',(parseFloat($('box-position').style.top)*100)/newHeight);
	$('box_position_left').set('value',(parseFloat($('box-position').style.left)*100)/newWidth);
	$('box_position_bottom').set('value',((parseFloat($('box-position').style.top)*100)/newHeight)+parseFloat($('box-position').style.height));
	$('box_position_right').set('value',((parseFloat($('box-position').style.left)*100)/newWidth)+parseFloat($('box-position').style.width));
	
	CKEDITOR.replace( 'header', {
		toolbar : '{/literal}{if Core_Module_Router::checkUrlAccess( "site1_accounts", "copyprophet_ajax" )}Basic_Squeeze_Header{else}Basic_Squeeze{/if}{literal}',
		enterMode: CKEDITOR.ENTER_BR,
		shiftEnterMode: CKEDITOR.ENTER_BR,
		fontSize_sizes: '8px/8;9px/9;10px/10;11px/11;12px/12;14px/14;16px/16;18px/18;20px/20;22px/22;24px/24;26px/26;28px/28;36px/36;48px/48;72px/72',
		fontSize_style: {
			element: 'font',
			attributes: { 'size': '#(size)' },
			styles: { 'font-size': '#(size)px', 'line-height': '100%' }
		}
	});
	CKEDITOR.replace( 'video_holder', {
		toolbar : '{/literal}{if Core_Module_Router::checkUrlAccess( "site1_accounts", "copyprophet_ajax" )}Basic_Squeeze_Header{else}Basic_Squeeze{/if}{literal}',
		enterMode: CKEDITOR.ENTER_BR,
		shiftEnterMode: CKEDITOR.ENTER_BR,
		fontSize_sizes: '8px/8;9px/9;10px/10;11px/11;12px/12;14px/14;16px/16;18px/18;20px/20;22px/22;24px/24;26px/26;28px/28;36px/36;48px/48;72px/72',
		fontSize_style: {
			element: 'font',
			attributes: { 'size': '#(size)' },
			styles: { 'font-size': '#(size)px', 'line-height': '100%' }
		},
		startupMode: 'source'
	});
	CKEDITOR.replace( 'linktext', {
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
{/literal}{if Core_Acs::haveAccess( array( 'email test group', 'lps platinum' ) )}{literal}
	CKEDITOR.replace( 'optin_message_text', {
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
{/literal}{/if}{literal}
	CKEDITOR.replace( 'fineprint', {
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
	CKEDITOR.replace( 'nav_link', {
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
	$('revert').addEvent('click', function(e){
		e && e.stop();
		CKEDITOR.instances.fineprint.setData( '<em>We hate spam as much as you do and we respect your <a href="privacy.php">privacy</a>. </em><em>Access links will be sent once you confirm your email address.</em>' );
	});
	$$('[name="settings[popup_style]"]').addEvent('change',function(elt){
		if( elt.target.get('value') == 'content' ){
			$$('.popup_style-onload').hide();
			$$('.popup_style-contentbox').hide();
			$$('.popup_style-content').show();
			$$('[name="settings[type_page]"]:checked')[0].fireEvent('click');
		}else if( elt.target.get('value') == 'contentbox' ){
			$$('.popup_style-onload').hide();
			$$('.popup_style-content').hide();
			$$('.popup_style-contentbox').show();
		}else if( elt.target.get('value') == 'popup' ){
			$$('.popup_style-contentbox').hide();
			$$('.popup_style-content').show();
			$$('.popup_style-onload').show();
		}else if( elt.target.get('value') == 'onload' ){
			$$('.popup_style-content').hide();
			$$('.popup_style-contentbox').hide();
			$$('.popup_style-onload').show();
		}
	});
	$$('[name="settings[popupOnActionId]"]').addEvent('change',function(elt){
		if( elt.target.get('value') == '' ){
			$$('.hide-autoresponder').show();
		}else{
			$$('.hide-autoresponder').hide();
		}
	});
	$('background-type').addEvent('change',function(){
		$$('.backgrounds-types').setStyle('display','none');
		$($('background-type').get('value')).setStyle('display','block');
		if( $$('.background_'+$('background-type').get('value')).length != 0 ){
			$$('.background_'+$('background-type').get('value')).each(function(elt){elt.setStyle('display','block')});
		}
		$('background-select-google').set('value',0);
	});
	$('exit_pop_settings').addEvent('change',function( elt ){
		if( elt.target.checked )
			$('exit_pop-block').setStyle('display','block');
		else
			$('exit_pop-block').setStyle('display','none');
	});
	$('preview').addEvent('click',function(){
		$('form').set( 'action',urlPreview );
		$('form').set( 'target','_blank' );
		$('form').submit();
	});
	$('generate').addEvent('click',function(){
		$('form').set( 'action',urlGenerate );
		$('form').set( 'target','_self' );
		$('form').submit();
	});

	var myColor = new Color( $('box_border_color').get('value')!=''?$('box_border_color').get('value'):'#555454' );
	new MooRainbow('box_border_color', {
		id: 'box_border_color',
		imgPath: '/skin/_js/rainbow/',
		'startColor': myColor.rgb,
		onChange: function(color) {
			$('box_border_color_span').setStyle('background-color', color.hex);
			this.element.value = color.hex;
		}
	});
	var boxBackgroundColor = new Color( $('box_background').get('value')!=''?$('box_background').get('value'):'#ffffff' );
	new MooRainbow('box_background',{
		id: 'box_background',
		imgPath: '/skin/_js/rainbow/',
		'startColor': boxBackgroundColor.rgb,
		onChange: function(color) {
			$('box_background_span').setStyle('background-color', color.hex);
			this.element.value = color.hex;
		}
	});

	var fallback_color = new Color( $('fallback_color').get('value')!=''?$('fallback_color').get('value'):'#ffffff' );
	new MooRainbow('fallback_color',{
		id: 'fallback_color',
		imgPath: '/skin/_js/rainbow/',
		'startColor': fallback_color.rgb,
		onChange: function(color) {
			$('fallback_color_span').setStyle('background-color', color.hex);
			this.element.value = color.hex;
		}
	});
	var myColor = new Color( $('body_color').get('value')!=''?$('body_color').get('value'):'#000000' );
	new MooRainbow('body_color',{
		id: 'body_color',
		imgPath: '/skin/_js/rainbow/',
		'startColor': myColor.rgb,
		onChange: function(color) {
			$('body_color_span').setStyle('background-color', color.hex);
			this.element.value = color.hex;
		}
	});
	var myColor = new Color( $('background_color').get('value')!=''?$('background_color').get('value'):'#000000' );
	new MooRainbow('background_color',{
		id: 'background_color',
		imgPath: '/skin/_js/rainbow/',
		'startColor': myColor.rgb,
		onChange: function(color) {
			$('background_color_span').setStyle('background-color', color.hex);
			this.element.value = color.hex;
		}
	});
	
	$$('.boxes_colors').each(function(elt){
		var myColor = new Color( elt.get('value')!=''?elt.get('value'):boxBackgroundColor );
		new MooRainbow(elt.get('id'),{
			id: elt.get('id'),
			imgPath: '/skin/_js/rainbow/',
			'startColor': myColor.rgb,
			onChange: function(color) {
				$(elt.get('id')+'_span').setStyle('background-color', color.hex);
				this.element.value = color.hex;
			}
		});
	});
	
	new Slider( $('slider'), $('slider').getElement('.knob'), {
		steps: 50,
		range: [0, 50],
		wheel: true,
		snap: true,
		initialStep: $('slider').getNext('input').get('value'),
		onChange: function(value){
			$('slider').getNext('input').set('value', value);
			$('slider').getPrevious('label').getElement('span.text').set('html', value+' px');
		}
	});
	new Slider( $('slider2'), $('slider2').getElement('.knob'), {
		steps: 50,
		range: [0, 50],
		wheel: true,
		snap: true,
		initialStep: $('slider2').getNext('input').get('value'),
		onChange: function(value){
			$('slider2').getNext('input').set('value', value);
			$('slider2').getPrevious('label').getElement('span.text').set('html', value+' px');
		}
	});
	new Slider( $('slider3'), $('slider3').getElement('.knob'), {
		steps: 100,
		range: [0, 100],
		wheel: true,
		snap: true,
		initialStep: $('slider3').getNext('input').get('value'),
		onChange: function(value){
			$('slider3').getNext('input').set('value', value);
			if( value==100 ){
				$('slider3').getPrevious('label').getElement('span.text').set('html', 'Full');
			} else if( value == 0 ){
				$('slider3').getPrevious('label').getElement('span.text').set('html', 'None');
			} else {
				$('slider3').getPrevious('label').getElement('span.text').set('html', value+' %');
			}

		}
	});
	new Slider( $('slider4'), $('slider4').getElement('.knob'), {
		steps: 100,
		range: [0, 100],
		wheel: true,
		snap: true,
		initialStep: $('slider4').getNext('input').get('value'),
		onChange: function(value){
			$('slider4').getNext('input').set('value', value);
			if( value==100 ){
				$('slider4').getPrevious('label').getElement('span.text').set('html', 'Full');
			} else if( value == 0 ){
				$('slider4').getPrevious('label').getElement('span.text').set('html', 'None');
			} else {
				$('slider4').getPrevious('label').getElement('span.text').set('html', value+' %');
			}
		}
	});
	$$('.slider_transparents').each(function(elt){
		new Slider( elt, elt.getElement('.knob'), {
			steps: 100,
			range: [0, 100],
			wheel: true,
			snap: true,
			initialStep: elt.getNext('input').get('value'),
			onChange: function(value){
				elt.getNext('input').set('value', value);
				if( value==100 ){
					elt.getPrevious('label').getElement('span.text').set('html', 'Full');
				} else if( value == 0 ){
					elt.getPrevious('label').getElement('span.text').set('html', 'None');
				} else {
					elt.getPrevious('label').getElement('span.text').set('html', value+' %');
				}
			}
		});
	});

	multibox=new CeraBox( $$('.popup_mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	new CeraBox( $$('.popup-squeeze'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	new CeraBox( $$('.popup_bg'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	$$('input.flg_sound').addEvent ( 'click', function () {
		if ( $(this).get('value') == '1' ) {
			$$('div.flg_sound').setStyle('display','block');
		} else {
			$$('div.flg_sound').setStyle('display','none');
		}
	});
	$$('input.flg_delay').addEvent ( 'click', function () {
		if ( $(this).get('value') == '1' ) {
			$$('div.flg_delay').setStyle('display','block');
		} else {
			$$('div.flg_delay').setStyle('display','none');
		}
	});
	$$('input.check_color_settings').addEvent( 'click', function () {
		if ( $(this).checked ) {
			$$('div.'+$(this).get('id')).setStyle('display','block');
		} else {
			$$('div.'+$(this).get('id')).setStyle('display','none');
		}
	});
	$('autoresponder_form_data').addEvent( 'change', function () {
		var container=$('autoresponder_form_settings');
		container.set('html','');
		new Request({
			url:"{/literal}{url name='site1_squeeze' action='autoresponder_ajax'}{literal}",
			method: 'post',
			onComplete: function(res){
				if( res != '' ){
					container.set( 'html', res );
				}
			}
		}).post({data:$('autoresponder_form_data').get('value')});
	});
	{/literal}{if !Core_Acs::haveAccess( 'Easy Optin Page Light' )}{literal}
	var updateAllowedCountries=function(){
		// очистить $$('all_not_selected_countries').
		$$('.all_not_selected_countries').set('html','');
		$$('.geo_checkbox').each( function( elt ){
			$$('select.all_not_selected_countries').each( function(elt_option){
				if( elt.checked ){
					if( elt_option.get('default-option') == elt.get('value') ){
						elt_option.getNext().erase( 'name' );
						elt_option.erase( 'default-option' );
					}
					$$('.geo_state_'+elt.get('value')+'_checkbox').each( function( elt_state ){
						if( elt_state.checked ){
							if( elt_option.get('default-option') == elt_state.get('value') ){
								elt_option.getNext().erase( 'name' );
								elt_option.erase( 'default-option' );
							}
						}else{
							var checkedOption = '';
							if( elt_option.get('default-option') == elt_state.get('value') ){
								checkedOption='[selected]';
							}
							elt_option.adopt( new Element('option[value="'+elt_state.get('value')+'"][html="'+elt_state.get('rel')+'"]'+checkedOption) );
						}
					} );
				}else{
					var checkedOption = '';
					if( elt_option.get('default-option') == elt.get('value') ){
						checkedOption='[selected]';
					}
					elt_option.adopt( new Element('option[value="'+elt.get('value')+'"][html="'+elt.get('rel')+'"]'+checkedOption) );
				}
			});
		});
	}
	$$('input.flg_geo').addEvent ( 'click', function () {
		if ( $(this).get('value') == '1' ) {
			$$('div.flg_geo').setStyle('display','block');
		} else {
			$$('div.flg_geo').setStyle('display','none');
		}
	});
	$$('.remove_this_country_url').addEvent( 'click', function (evt) {
		evt.target.getParent().destroy();
	});
	$('add_new_country').addEvent( 'click', function () {
		$('alternate_urls').adopt(
			new Element('p').adopt([
				new Element('select.all_not_selected_countries').addEvent( 'change', function (evt) {
					evt.target.getNext().set( 'name', "settings[geo_redirect_urls]["+evt.target.get('value')+"]" );
					evt.target.set( 'default-option', evt.target.get('value') );
				}),
				new Element('input.medium-input.text-input.form-control[type="text"]', { 'style' : 'width: 300px; display: inline-block; margin: 0 10px;'}),
				new Element('img.remove_this_country_url[src="/skin/i/frontends/design/newUI/exquisite_popups/block.png"][title="Remove this Alternate URLs for Selected Country"]').addEvent( 'click', function (evt) {
					evt.target.getParent().destroy();
				})
			])
		);
		updateAllowedCountries();
	});
	$$('.geo_changeopt').each( function( elt ){
		elt.addEvent( 'change', function(){
			updateAllowedCountries(); 
			if( elt.checked ){
				$('open_geo_'+elt.get('value')).show();
				$$('.geo_state_'+elt.get('value')+'_checkbox').each( function( elt_state ){
					elt_state.checked=true;
				});
			}else{
				$('open_geo_'+elt.get('value')).hide();
				$$('.geo_state_'+elt.get('value')+'_checkbox').each( function( elt_state ){
					elt_state.checked=false;
				});
			}
		});
	});
	$$('.geo_changeopt_only').each( function( elt ){
		elt.addEvent( 'change', function(){
			if( $$('.geo_changeopt_'+elt.get('data-unselect')+'_unselect' ).get('checked') && elt.get('checked') ){
				$$('.geo_changeopt_'+elt.get('data-unselect')+'_unselect' )[0].checked=false;
			}
			updateAllowedCountries(); 
		});
	});
	$$('.geo_changeopt_unselect').each( function( elt ){
		elt.addEvent( 'change', function(){
			if( elt.get('checked') ){
				$$('.geo_state_'+elt.get('rel')+'_checkbox').each( function( elt2 ){
					elt2.checked=false;
				});
			}else{
				$$('.geo_state_'+elt.get('rel')+'_checkbox').each( function( elt2 ){
					elt2.checked=true;
				});
			}
			updateAllowedCountries(); 
		});
	});
	updateAllowedCountries();
	{/literal}{/if}{literal}
	$('preview').disabled = false;
	$('generate').disabled = false;
});



var active_icontact_appid = "";
var active_icontact_apiusername = "";
var active_icontact_apipassword = "";
function icontact_loadlist() {
	if (active_icontact_appid != jQuery("#ulp_icontact_appid").val() || 
		active_icontact_apiusername != jQuery("#ulp_icontact_apiusername").val() ||
		active_icontact_apipassword != jQuery("#ulp_icontact_apipassword").val()) {
		jQuery("#ulp_icontact_listid").html("<option>-- Loading Lists --</option>");
		jQuery("#ulp_icontact_listid").attr("disabled", "disabled");
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
						jQuery("#ulp_icontact_listid").html(data.options);
						jQuery("#ulp_icontact_listid").removeAttr("disabled");
						active_icontact_appid = jQuery("#ulp_icontact_appid").val();
						active_icontact_apiusername = jQuery("#ulp_icontact_apiusername").val();
						active_icontact_apipassword = jQuery("#ulp_icontact_apipassword").val();
					} else jQuery("#ulp_icontact_listid").html("<option>-- Can not get Lists --</option>");
				} catch(e) {
					jQuery("#ulp_icontact_listid").html("<option>-- Can not get Lists --</option>");
				}
			}
		);
	}
}
var active_getresponse_api_key = "";
function getresponse_loadlist() {
	if (active_getresponse_api_key != jQuery("#ulp_getresponse_api_key").val()) {
		jQuery("#ulp_getresponse_campaign_id").html("<option>-- Loading Campaigns --</option>");
		jQuery("#ulp_getresponse_campaign_id").attr("disabled", "disabled");
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
				"action": 'getresponse-campaigns',
				"getresponse_api_key": jQuery("#ulp_getresponse_api_key").val(),
				"getresponse_campaign_id": "{/literal}{$popup_options['getresponse_campaign_id']}{literal}"
			},
			function(return_data) {
				try {
					data = jQuery.parseJSON(return_data);
					if (data) {
						jQuery("#ulp_getresponse_campaign_id").html(data.options);
						jQuery("#ulp_getresponse_campaign_id").removeAttr("disabled");
						active_getresponse_api_key = jQuery("#ulp_getresponse_api_key").val();
					} else jQuery("#ulp_getresponse_campaign_id").html("<option>-- Can not get Campaigns --</option>");
				} catch(e) {
					jQuery("#ulp_getresponse_campaign_id").html("<option>-- Can not get Campaigns --</option>");
				}
			}
		);
	}
}
var active_madmimi_login = "";
var active_madmimi_api_key = "";
function madmimi_loadlist() {
	if (active_madmimi_login != jQuery("#ulp_madmimi_login").val() || active_madmimi_api_key != jQuery("#ulp_madmimi_api_key").val()) {
		jQuery("#ulp_madmimi_list_id").html("<option>-- Loading Lists --</option>");
		jQuery("#ulp_madmimi_list_id").attr("disabled", "disabled");
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
						jQuery("#ulp_madmimi_list_id").html(data.options);
						jQuery("#ulp_madmimi_list_id").removeAttr("disabled");
						active_madmimi_api_key = jQuery("#ulp_madmimi_api_key").val();
					} else jQuery("#ulp_madmimi_list_id").html("<option>-- Can not get Lists --</option>");
				} catch(e) {
					jQuery("#ulp_madmimi_list_id").html("<option>-- Can not get Lists --</option>");
				}
			}
		);
	}
}
var active_benchmark_api_key = "";
function benchmark_loadlist() {
	if (active_benchmark_api_key != jQuery("#ulp_benchmark_api_key").val()) {
		jQuery("#ulp_benchmark_list_id").html("<option>-- Loading Lists --</option>");
		jQuery("#ulp_benchmark_list_id").attr("disabled", "disabled");
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
				"action": 'benchmark-lists',
				"benchmark_api_key": jQuery("#ulp_benchmark_api_key").val(),
				"benchmark_list_id": "{/literal}{$popup_options['benchmark_list_id']}{literal}"
			},
			function(return_data) {
				try {
					data = jQuery.parseJSON(return_data);
					if (data) {
						jQuery("#ulp_benchmark_list_id").html(data.options);
						jQuery("#ulp_benchmark_list_id").removeAttr("disabled");
						active_benchmark_api_key = jQuery("#ulp_benchmark_api_key").val();
					} else jQuery("#ulp_benchmark_list_id").html("<option>-- Can not get Lists --</option>");
				} catch(e) {
					jQuery("#ulp_benchmark_list_id").html("<option>-- Can not get Lists --</option>");
				}
			}
		);
	}
}
var active_activecampaign_url = "";
var active_activecampaign_api_key = "";
function activecampaign_loadlist() {
	if (active_activecampaign_api_key != jQuery("#ulp_activecampaign_api_key").val() || active_activecampaign_url != jQuery("#ulp_activecampaign_url").val()) {
		jQuery("#ulp_activecampaign_list_id").html("<option>-- Loading Lists --</option>");
		jQuery("#ulp_activecampaign_list_id").attr("disabled", "disabled");
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
						jQuery("#ulp_activecampaign_list_id").html(data.options);
						jQuery("#ulp_activecampaign_list_id").removeAttr("disabled");
						active_activecampaign_url = jQuery("#ulp_activecampaign_url").val();
						active_activecampaign_api_key = jQuery("#ulp_activecampaign_api_key").val();
					} else jQuery("#ulp_activecampaign_list_id").html("<option>-- Can not get Lists --</option>");
				} catch(e) {
					jQuery("#ulp_activecampaign_list_id").html("<option>-- Can not get Lists --</option>");
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
		jQuery("#ulp_interspire_listid").html("<option>-- Loading Lists --</option>");
		jQuery("#ulp_interspire_listid").attr("disabled", "disabled");
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
						jQuery("#ulp_interspire_listid").html(data.options);
						jQuery("#ulp_interspire_listid").removeAttr("disabled");
						active_interspire_url = jQuery("#ulp_interspire_url").val();
						active_interspire_username = jQuery("#ulp_interspire_username").val();
						active_interspire_token = jQuery("#ulp_interspire_token").val();
					} else jQuery("#ulp_interspire_listid").html("<option>-- Can not get Lists --</option>");
				} catch(e) {
					jQuery("#ulp_interspire_listid").html("<option>-- Can not get Lists --</option>");
				}
				interspire_loadfield();
			}
		);
	}
}
function interspire_loadfield() {
	if (active_interspire_url != jQuery("#ulp_interspire_url").val() || active_interspire_username != jQuery("#ulp_interspire_username").val() || active_interspire_token != jQuery("#ulp_interspire_token").val() || active_interspire_listid != jQuery("#ulp_interspire_listid").val()) {
		jQuery("#ulp_interspire_nameid").html("<option>-- Loading Fields --</option>");
		jQuery("#ulp_interspire_nameid").attr("disabled", "disabled");
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', {
				"action": 'interspire-fields',
				"interspire_url": jQuery("#ulp_interspire_url").val(),
				"interspire_username": jQuery("#ulp_interspire_username").val(),
				"interspire_token": jQuery("#ulp_interspire_token").val(),
				"interspire_listid": jQuery("#ulp_interspire_listid").val(),
				"interspire_nameid": "{/literal}{$popup_options['interspire_nameid']}{literal}"
			},
			function(return_data) {
				try {
					data = jQuery.parseJSON(return_data);
					if (data) {
						jQuery("#ulp_interspire_nameid").html(data.options);
						jQuery("#ulp_interspire_nameid").removeAttr("disabled");
						active_interspire_url = jQuery("#ulp_interspire_url").val();
						active_interspire_username = jQuery("#ulp_interspire_username").val();
						active_interspire_token = jQuery("#ulp_interspire_token").val();
						active_interspire_lsitid = jQuery("#ulp_interspire_listid").val();
					} else jQuery("#ulp_interspire_nameid").html("<option>-- Can not get Fields --</option>");
				} catch(e) {
					jQuery("#ulp_interspire_nameid").html("<option>-- Can not get Fields --</option>");
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


</script>
{/literal}