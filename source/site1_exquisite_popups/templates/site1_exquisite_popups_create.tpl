{literal}
<script type="text/javascript">
jQuery.noConflict();
var objAccordion = {};

window.addEvent('domready', function() {
	objAccordion = new myAccordion($('accordion'), $$('.toggler'), $$('.element'), { fixedHeight:false });
});

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
		jQuery('create_form').show();
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
</script>
{/literal}
{if !empty($error_message)}
	{include file='../../message.tpl' type='error' message={$error_message}}
{elseif !empty($ok_message)}
	{include file='../../message.tpl' type='success' message={$ok_message}}
{/if}
<form class="ulp-popup-form" enctype="multipart/form-data" method="post" style="margin: 0px" action="">
<div class="ulp-preview-container">
	<div class="ulp-preview-window">
		<div class="ulp-preview-content">
		</div>
	</div>
</div>
<div class="panel-group" id="accordion-test-2"> 
    <div class="panel panel-default"> 
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">General Parameters</a> 
            </h4> 
        </div> 
        <div id="collapseOne-2" class="panel-collapse collapse"> 
            <div class="panel-body">
            	<fieldset>
					<div class="form-group">
						<label>Title: </label>
						<input type="text" name="ulp_title" value="{if !empty($popup_details['title'])}{$popup_details['title']}{else}{Project_Exquisite_Popups::$defaultOptions['title']}{/if}" class="form-control" placeholder="Enter the popup title..." />
						<br><small>Enter the popup title. It is used for your reference.</small>
					</div>
					<div class="form-group">
						<label>Basic size width[px]: </label>
						<input type="text" name="ulp_width" value="{if !empty($popup_options['width'])}{$popup_options['width']}{else}{Project_Exquisite_Popups::$defaultOptions['width']}{/if}" class="form-control" placeholder="Width" onblur="ulp_build_preview();" onchange="ulp_build_preview();">
						<br><small>Enter the size of basic frame. This frame will be centered and all layers will be placed relative to the top-left corner of this frame.</small>
					</div>
					<div class="form-group">
						<label>Position:</label>
						<div>
							<div id="ulp-position-top-left" class="ulp-position-box{if $popup_options['position'] == 'top-left'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-top-left"></div></div>
							<div id="ulp-position-top-center" class="ulp-position-box{if $popup_options['position'] == 'top-center'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-top-center"></div></div>
							<div id="ulp-position-top-right" class="ulp-position-box{if $popup_options['position'] == 'top-right'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-top-right"></div></div>
							<br />
							<div id="ulp-position-middle-left" class="ulp-position-box{if $popup_options['position'] == 'middle-left'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-middle-left"></div></div>
							<div id="ulp-position-middle-center" class="ulp-position-box{if $popup_options['position'] == 'middle-center'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-middle-center"></div></div>
							<div id="ulp-position-middle-right" class="ulp-position-box{if $popup_options['position'] == 'middle-right'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-middle-right"></div></div>
							<br />
							<div id="ulp-position-bottom-left" class="ulp-position-box{if $popup_options['position'] == 'bottom-left'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-bottom-left"></div></div>
							<div id="ulp-position-bottom-center" class="ulp-position-box{if $popup_options['position'] == 'bottom-center'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-bottom-center"></div></div>
							<div id="ulp-position-bottom-right" class="ulp-position-box{if $popup_options['position'] == 'bottom-right'} ulp-position-selected{/if}" onclick="ulp_set_position(this);"><div class="ulp-position-element ulp-position-bottom-right"></div></div>
							<input type="hidden" id="ulp_position" name="ulp_position" value="{if !empty($popup_options['position'])}{$popup_options['position']}{else}{Project_Exquisite_Popups::$defaultOptions['position']}{/if}">
							<br /><em>Select popup position on browser window.</em>
							<script>
								function ulp_set_position(object) {
									var position = jQuery(object).attr("id");
									position = position.replace("ulp-position-", "");
									jQuery("#ulp_position").val(position);
									jQuery(".ulp-position-box").removeClass("ulp-position-selected");
									jQuery(object).addClass("ulp-position-selected");
								}
							</script>
						</div>
					</div>
					<div class="form-group">
						<label>Basic size height[px]: </label>
						<input type="text" name="ulp_height" value="{if !empty($popup_details['height'])}{$popup_details['height']}{else}{Project_Exquisite_Popups::$defaultOptions['height']}{/if}" class="form-control" placeholder="Height" onblur="ulp_build_preview();" onchange="ulp_build_preview();">
						<br><small>Enter the size of basic frame. This frame will be centered and all layers will be placed relative to the top-left corner of this frame.</small>
					</div>
					<div class="form-group">
						<label>Overlay color: </label>
						<input type="text" name="ulp_overlay_color" value="{if !empty($popup_options['overlay_color'])}{$popup_options['overlay_color']}{else}{Project_Exquisite_Popups::$defaultOptions['overlay_color']}{/if}" class="form-control" placeholder="">
						<br><small>Set the overlay color.</small>
					</div>
					<div class="form-group">
						<label>Overlay opacity: </label>
						<input type="text" name="ulp_overlay_opacity" value="{if !empty($popup_options['overlay_opacity'])}{$popup_options['overlay_opacity']}{else}{Project_Exquisite_Popups::$defaultOptions['overlay_opacity']}{/if}" class="form-control" placeholder="Opacity">
						<br><small>Set the overlay opacity. The value must be in a range [0...1].</small>
					</div>
					<div class="form-group">
						<label>Overlay opacity: </label>
						<input type="text" name="ulp_overlay_opacity" value="{if !empty($popup_options['overlay_opacity'])}{$popup_options['overlay_opacity']}{else}{Project_Exquisite_Popups::$defaultOptions['overlay_opacity']}{/if}" class="form-control" placeholder="Opacity">
						<br><small>Set the overlay opacity. The value must be in a range [0...1].</small>
					</div>
					<div class="form-group">
						<label>Extended closing: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" name="ulp_enable_close"{if $popup_options['enable_close'] == "on"} checked="checked"{/if}>
							<label>Close popup window on ESC-button click and overlay click</label>	
						</div>
						<br><small>
						<em>Please tick checkbox to enable popup closing on ESC-button click and overlay click.<br/>
						You can add and customize "close" icon as you wish. Create new layer with content like that: <br/>
						<code>&lt;a href="#" onclick="return ulp_self_close();"&gt;&lt;img src="http://url-to-my-wonderful-close-icon" alt=""&gt;&lt;/a&gt;</code><br/>
						The important part of the this string is onclick handler: <code>onclick="return ulp_self_close();"</code>. It runs JavaScript function called ulp_self_close() which closes popup.</em>
						</small>
					</div>
				</fieldset>
            </div> 
        </div> 
    </div>
    <div class="panel panel-default"> 
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" class="collapsed" aria-expanded="false">Layers</a> 
            </h4> 
        </div> 
        <div id="collapseTwo-2" class="panel-collapse collapse"> 
            <div class="panel-body">
               <fieldset>
					<div id="ulp-layers-data">
					{if sizeof($layers) > 0}
					{foreach from=$layers item='layer'}
						<section class="ulp-layers-item" id="ulp-layer-{$layer['id']}">
							<div class="ulp-layers-item-cell ulp-layers-item-cell-info">
								<h4>{$layer['options']['title']}</h4>
								<p>{$layer['show_content']}</p>
							</div>
							<div class="ulp-layers-item-cell" style="width: 70px;">
								<a href="#" title="Edit layer details" onclick="return ulp_edit_layer(this);"><img src="/skin/i/frontends/design/newUI/exquisite_popups/edit.png" alt="Edit layer details" border="0"></a>
								<a href="#" title="Duplicate layer" onclick="return ulp_copy_layer(this);"><img src="/skin/i/frontends/design/newUI/exquisite_popups/copy.png" alt="Duplicate details" border="0"></a>
								<a href="#" title="Delete layer" onclick="return ulp_delete_layer(this);"><img src="/skin/i/frontends/design/newUI/exquisite_popups/delete.png" alt="Delete layer" border="0"></a>
							</div>
							{$layer['show_html']}
						</section>
						<div class="ulp-edit-layer" id="ulp-edit-layer-{$layer['id']}"></div>
					{/foreach}
					{/if}						
					</div>
					<div id="ulp-new-layer"></div>
					<button type="button" class="submit btn btn-success waves-effect waves-light" onclick="return ulp_add_layer();">Add New Layer</button>
				</fieldset>
            </div> 
        </div> 
    </div> 
    <div class="panel panel-default"> 
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseThree-2" class="collapsed" aria-expanded="false">Subscription/Contact Form Parameters</a> 
            </h4> 
        </div> 
        <div id="collapseThree-2" class="panel-collapse collapse"> 
            <div class="panel-body">
               <fieldset>
					<br><small>The parameters below are used for subscription/contact form only.</small>
					<div class="form-group">
						<label>"Name" field placeholder: </label>
						<input type="text" id="ulp_name_placeholder" name="ulp_name_placeholder" value="{$popup_options['name_placeholder']}" class="form-control">
						<small>Enter the placeholder for "Name" input field. Insert shortcode <code>{literal}{subscription-name}{/literal}</code> into popup layers.</small>
					</div>
					<div class="form-group">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_name_mandatory" name="ulp_name_mandatory" {if $popup_options['name_mandatory'] == "on"}checked="checked"{/if} />
							<label>"Name" field is mandatory</label>		
						</div>
						<small>Please tick checkbox to set "name" field as mandatory.</small>
					</div>
					<div class="form-group">
						<label>"Phone number" field placeholder: </label>
						<input type="text" id="ulp_phone_placeholder" name="ulp_phone_placeholder" value="{$popup_options['phone_placeholder']}" class="form-control">
						<small>Enter the placeholder for "Phone number" input field. Insert shortcode <code>{literal}{subscription-phone}{/literal}</code> into popup layers.</small>
					</div>
					<div class="form-group">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_phone_mandatory" name="ulp_phone_mandatory" {if $popup_options['phone_mandatory'] == "on"}checked="checked"{/if} />
							<label>"Phone number" field is mandatory</label>
						</div>
						<small>Please tick checkbox to set "phone number" field as mandatory.</small>
					</div>
					<div class="form-group">
						<label>"Message" text area placeholder: </label>
						<input type="text" id="ulp_message_placeholder" name="ulp_message_placeholder" value="{$popup_options['message_placeholder']}" class="form-control">
						<small>Enter the placeholder for "Message" text area. Insert shortcode <code>{literal}{subscription-message}{/literal}</code> into popup layers.</small>
					</div>
					<div class="form-group">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_message_mandatory" name="ulp_message_mandatory" {if $popup_options['message_mandatory'] == "on"}checked="checked"{/if} />
							<label>"Message" text area is mandatory</label>
						</div>
						<small>Please tick checkbox to set "message" text area as mandatory.</small>
					</div>
					<div class="form-group">
						<label>"E-mail" field placeholder: </label>
						<input type="text" id="ulp_email_placeholder" name="ulp_email_placeholder" value="{$popup_options['email_placeholder']}" class="form-control">
						<small>Enter the placeholder for "E-mail" input field. Insert shortcode <code>{literal}{subscription-email}{/literal}</code> into popup layers.</small>
					</div>
					<div class="form-group">
						<label>"Subscribe" button label: </label>
						<input type="text" id="ulp_button_label" name="ulp_button_label" value="{$popup_options['button_label']}" class="form-control">
						<small>Enter the label for "Subscribe" button.</small>
					</div>
					{if $options['fa_enable'] == 'on'}
					<div class="form-group">
						<label>"Subscribe" button icon: </label>
						<span id="ulp-button-icon-image" class="ulp-icon ulp-icon-active" title="Icons" onclick="jQuery('#ulp-button-icon-set').slideToggle(300);"><i class="fa {$popup_options['button_icon']}"></i></span><br />
						<div id="ulp-button-icon-set" class="ulp-icon-set">
						{foreach from=Project_Exquisite::$arrFontAwesome item='value'}
						<span class="ulp-icon{if $popup_options['button_icon'] == $value} ulp-icon-active{/if}" title="{$value}" onclick="ulp_seticon(this, 'ulp-button-icon');"><i class="fa {$value}"></i></span>
						{/foreach}
						</div>
						<input type="hidden" name="ulp_button_icon" id="ulp-button-icon" value="{$popup_options['button_icon']}">
						<br><small>Select "Subscribe" button icon.</small>
					</div>{/if}
					<div class="form-group">
						<label>"Loading" button label: </label>
						<input type="text" id="ulp_button_label_loading" name="ulp_button_label_loading" value="{$popup_options['button_label_loading']}" class="form-control">
						<small>Enter the label for "Subscribe" button which appears once users click it. Insert shortcode {literal}{subscription-submit}{/literal} into popup layers.</small>
					</div>
					<div class="form-group">
						<label>"Subscribe" button color: </label>
						<input type="text" name="ulp_button_color" value="{$popup_options['button_color']}" class="form-control" placeholder="">
						<small>Set the "Subscribe" button color.</small>
					</div>
					<div class="form-group">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_button_gradient" name="ulp_button_gradient" {if $popup_options['button_gradient'] == "on"}checked="checked"{/if} />
							<label>Add color gradient</label>
						</div>
						<small>Please tick checkbox to want to add color gradient to "Subscribe" button.</small>
					</div>
					<div class="form-group">
						<label>"Subscribe" button size: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_button_inherit_size" name="ulp_button_inherit_size" {if $popup_options['button_inherit_size'] == "on"}checked="checked"{/if} />
							<label>Inherit layer size</label>
						</div>
						<small>Please tick checkbox to want to inherit layer size for button size.</small>
					</div>
					<div class="form-group">
						<label>"Subscribe" button border radius: </label>
						<input type="text" id="ulp_button_border_radius" name="ulp_button_border_radius" value="{$popup_options['button_border_radius']}" class="form-control" placeholder="pixels"> pixels
						<small>Set the border radius of "Subscribe" button.</small>
					</div>
					<div class="form-group">
						<label>Button CSS: </label>
						<input type="text" id="ulp_button_css" name="ulp_button_css" value="{$popup_options['button_css']}" class="form-control" placeholder="Custom button CSS">
						<small>Customize CSS for "Subscribe" button.</small>
					</div>
					<div class="form-group">
						<label>Button:hover CSS: </label>
						<input type="text" id="ulp_button_css_hover" name="ulp_button_css_hover" value="{$popup_options['button_css_hover']}" class="form-control" placeholder="Custom button:hover CSS">
						<small>Customize CSS for "Subscribe" button when pointer is over the button.</small>
					</div>
					<div class="form-group">
						<label>Input field border color: </label>
						<input type="text" name="ulp_input_border_color" value="{$popup_options['input_border_color']}" class="form-control" placeholder="">
						<small>Set the border color of "Name" and "E-mail" input fields.</small>
					</div>
					<div class="form-group">
						<label>Input field border width: </label>
						<input type="text" id="ulp_input_border_width" name="ulp_input_border_width" value="{$popup_options['input_border_width']}" class="form-control" placeholder="pixels"> pixels
						<small>Set the border width of "Name" and "E-mail" input fields.</small>
					</div>
					<div class="form-group">
						<label>Input field border radius: </label>
						<input type="text" id="ulp_input_border_radius" name="ulp_input_border_radius" value="{$popup_options['input_border_radius']}" class="form-control" placeholder="pixels"> pixels
						<small>Set the border radius of "Name" and "E-mail" input fields.</small>
					</div>
					<div class="form-group">
						<label>Input field background color: </label>
						<input type="text" name="ulp_input_background_color" value="{$popup_options['input_background_color']}" class="form-control" placeholder="">
						<small>Set the background color of "Name" and "E-mail" input fields.</small>
					</div>
					<div class="form-group">
						<label>Input field background opacity: </label>
						<input type="text" name="ulp_input_background_opacity" value="{$popup_options['input_background_opacity']}" class="form-control" placeholder="[0...1]">
						<small>Set the background opacity of "Name" and "E-mail" input fields. The value must be in a range [0...1].</small>
					</div>
					{if $options['fa_enable'] == 'on'}
					<div class="form-group">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_input_icons" name="ulp_input_icons"{if $popup_options['input_icons'] == "on"} checked="checked"{/if} />
							<label>Add icons to input fields</label>
						</div>
						<small>Please tick checkbox to want to add icons to "Name" and "E-mail" input fields.</small>
					</div>{/if}
					<div class="form-group">
						<label>Input field CSS: </label>
						<input type="text" id="ulp_input_css" name="ulp_input_css" value="{$popup_options['input_css']}" class="form-control" placeholder="Custom input field CSS">
						<small>Customize CSS for input fields.</small>
					</div>
					<div class="form-group">
						<label>Autoclose delay: </label>
						<input type="text" id="ulp_close_delay" name="ulp_close_delay" value="{$popup_options['close_delay']}" class="form-control" placeholder="seconds"> seconds
						<small>When subscription is succesfull, the popup will be automatically closed after this delay.</small>
					</div>
					<div class="form-group">
						<label>Redirect URL: </label>
						<input type="text" id="ulp_return_url" name="ulp_return_url" value="{$popup_options['return_url']}" class="form-control">
						<small>Enter the redirect URL. After successfull subscribing user is redirected to this URL. Leave blank to stay on the same page.</small>
					</div>
				</fieldset>
            </div> 
        </div> 
    </div>
    <div class="panel panel-default"> 
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFour-2" class="collapsed" aria-expanded="false">Social Buttons Parameters</a> 
            </h4> 
        </div> 
        <div id="collapseFour-2" class="panel-collapse collapse"> 
            <div class="panel-body">
               <fieldset>
					<div class="form-group">
						<label>URL to share/like/etc.: </label>
						<input type="text" id="ulp_social_url" name="ulp_social_url" value="{$popup_options['social_url']}" class="form-control">
						<small>Enter the URL attached to social buttons. This URL will be shared/liked/etc.</small>
					</div>
					<div class="form-group">
						<label>Social Buttons: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_social_google_plusone" name="ulp_social_google_plusone" {if $popup_options['social_google_plusone'] == "on"}checked="checked"{/if} />
							<label>Enable Google +1 button</label>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_social_facebook_like" name="ulp_social_facebook_like" {if $popup_options['social_facebook_like'] == "on"}checked="checked"{/if} />
							<label>Enable Facebook Like button</label>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_social_twitter_tweet" name="ulp_social_twitter_tweet" {if $popup_options['social_twitter_tweet'] == "on"}checked="checked"{/if} />
							<label>Enable Twitter Tweet button</label>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_social_linkedin_share" name="ulp_social_linkedin_share" {if $popup_options['social_linkedin_share'] == "on"}checked="checked"{/if} />
							<label>Enable LinkedIn Share button</label>
						</div>
						<small>
							Enable desired social buttons.<br />
							Use these shortcodes to insert relevant social button: <br />
							<code>{literal}{social-panel}{/literal}</code> - insert all social buttons <br />
							<code>{literal}{social-facebook-like}{/literal}</code> - insert Facebook Like button <br />
							<code>{literal}{social-google-plusone}{/literal}</code> - insert Google +1 button <br />
							<code>{literal}{social-twitter-tweet}{/literal}</code> - insert Twitter Tweet button <br />
							<code>{literal}{social-linkedin-share}{/literal}</code> - insert LinkedIn Share button <br />
							All you have to do is to insert shortcodes into popup layers.
						</small>
					</div>
					<div class="form-group">
						<label>Button left/right margin: </label>
						<input type="text" id="ulp_social_margin" name="ulp_social_margin" value="{$popup_options['social_margin']}" class="form-control" > pixels
						<br><small>Enter left/right margin of social buttons.</small>
					</div>
				</fieldset>
            </div> 
        </div> 
    </div> 
    <div class="panel panel-default"> 
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFive-2" class="collapsed" aria-expanded="false">"Subscribe with Social Media" Parameters <span class="ulp-badge ulp-badge-beta">Beta</span></a> 
            </h4> 
        </div> 
        <div id="collapseFive-2" class="panel-collapse collapse"> 
            <div class="panel-body">
               <fieldset>
					<div class="form-group">
						<label>Facebook Button label: </label>
						<input type="text" id="ulp_social2_facebook_label" name="ulp_social2_facebook_label" value="{$popup_options['social2_facebook_label']}" class="form-control">
						<small>Enter the label for "Subscribe with Facebook" button. Use shortcode <code>{literal}{subscription-facebook}{/literal}</code> to insert "Subscribe with Facebook" button into layer.</small>
					</div>
					<div class="form-group">
						<label>Facebook Button color: </label>
						<input type="text" name="ulp_social2_facebook_color" value="{$popup_options['social2_facebook_color']}" class="form-control" placeholder=""> 
						<small>Set the "Subscribe with Facebook" button color.</small>
					</div>
					<div class="form-group">
						<label>Google Button label: </label>
						<input type="text" id="ulp_social2_google_label" name="ulp_social2_google_label" value="{$popup_options['social2_google_label']}" class="form-control">
						<small>Enter the label for "Subscribe with Google" button. Use shortcode <code>{literal}{subscription-google}{/literal}</code> to insert "Subscribe with Google" button into layer.</small>
					</div>
					<div class="form-group">
						<label>Google Button color: </label>
						<input type="text" name="ulp_social2_google_color" value="{$popup_options['social2_google_color']}" class="form-control" placeholder="">
						<small>Set the "Subscribe with Google" button color.</small>
					</div>
				</fieldset>
            </div> 
        </div> 
    </div>
    <div class="panel panel-default"> 
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFix-2" class="collapsed" aria-expanded="false">Autoresponder Parameters</span></a> 
            </h4> 
        </div> 
        <div id="collapseFix-2" class="panel-collapse collapse"> 
            <div class="panel-body">
               	<fieldset>
					<br><small>The parameters below are used for subscription/contact form only.</small>
					{if $options['mailchimp_enable'] == "on"}
					<input type="hidden" id="ulp_mailchimp_api_key" name="ulp_mailchimp_api_key" value="{$options['mailchimp_api_key']}">
					<div class="form-group">
						<label>Enable MailChimp: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_mailchimp_enable" name="ulp_mailchimp_enable" {if $popup_options['mailchimp_enable'] == "on"}checked="checked"{/if} />
							<label>Submit contact details to MailChimp</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to MailChimp.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<input type="text" id="ulp_mailchimp_list_id" name="ulp_mailchimp_list_id" value="{$popup_options['mailchimp_list_id']}" class="form-control">
						<small>Enter your List ID. You can get it <a href="https://admin.mailchimp.com/lists/" target="_blank">here</a> (click <strong>Settings</strong>).</small>
					</div>
					<div class="form-group">
						<label>Double opt-in: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_mailchimp_double" name="ulp_mailchimp_double" {if $options['mailchimp_double'] == "on"}checked="checked"{/if} />
							<label>Ask users to confirm their subscription</label>
						</div>
						<small>Control whether a double opt-in confirmation message is sent.</small>
					</div>
					<div class="form-group">
						<label>Send Welcome: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_mailchimp_welcome" name="ulp_mailchimp_welcome" {if $options['mailchimp_welcome'] == "on"}checked="checked"{/if} />
							<label>v</label>
						</div>
						<small>If your <strong>Double opt-in</strong> is disabled and this is enabled, MailChimp will send your lists Welcome Email if this subscribe succeeds. If <strong>Double opt-in</strong> is enabled, this has no effect.</small>
					</div>
					{/if}
					{if $options['icontact_enable'] == "on"}
					<input type="hidden" id="ulp_icontact_appid" name="ulp_icontact_appid" value="{$options['icontact_appid']}">
					<input type="hidden" id="ulp_icontact_apiusername" name="ulp_icontact_apiusername" value="{$options['icontact_apiusername']}">
					<input type="hidden" id="ulp_icontact_apipassword" name="ulp_icontact_apipassword" value="{$options['icontact_apipassword']}">
					<div class="form-group">
						<label>Enable iContact: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_icontact_enable" name="ulp_icontact_enable" {if $popup_options['icontact_enable'] == "on"}checked="checked"{/if} onblur="icontact_loadlist();"/>
							<label>Submit contact details to iContact</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to iContact.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<select id="ulp_icontact_listid" name="ulp_icontact_listid" class="btn-group selectpicker show-tick">
							<option>-- Select List --</option>
						</select>
						<br><small>Select your List ID.</small>
					</div>
					{/if}
					{if $options['getresponse_enable'] == "on"}
					<input type="hidden" id="ulp_getresponse_api_key" name="ulp_getresponse_api_key" value="{$options['getresponse_api_key']}">
					<div class="form-group">
						<label>Enable GetResponse: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_getresponse_enable" name="ulp_getresponse_enable" {if $popup_options['getresponse_enable'] == "on"}checked="checked"{/if} onblur="getresponse_loadlist();" />
							<label>Submit contact details to GetResponse</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to GetResponse.</small>
					</div>
					<div class="form-group">
						<label>Campaign ID: </label>
						<select id="ulp_getresponse_campaign_id" name="ulp_getresponse_campaign_id" class="btn-group selectpicker show-tick">
							<option>-- Select Campaign --</option>
						</select>
						<br><small>Select your Campaign ID.</small>
					</div>
					{/if}
					{if $options['campaignmonitor_enable'] == "on"}
					<input type="hidden" id="ulp_campaignmonitor_api_key" name="ulp_campaignmonitor_api_key" value="{$options['campaignmonitor_api_key']}">
					<div class="form-group">
						<label>Enable Campaign Monitor: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_campaignmonitor_enable" name="ulp_campaignmonitor_enable" {if $popup_options['campaignmonitor_enable'] == "on"}checked="checked"{/if} />
							<label>Submit contact details to Campaign Monitor</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to Campaign Monitor.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<input type="text" id="ulp_campaignmonitor_list_id" name="ulp_campaignmonitor_list_id" value="{$popup_options['campaignmonitor_list_id']}" class="form-control">
						<small>Enter your List ID. You can get List ID from the list editor page when logged into your Campaign Monitor account.</small>
					</div>
					{/if}
					{if $options['madmimi_enable'] == "on"}
					<input type="hidden" id="ulp_madmimi_login" name="ulp_madmimi_login" value="{$options['madmimi_login']}">
					<input type="hidden" id="ulp_madmimi_api_key" name="ulp_madmimi_api_key" value="{$options['madmimi_api_key']}">
					<div class="form-group">
						<label>Enable Mad Mimi: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_madmimi_enable" name="ulp_madmimi_enable" {if $popup_options['madmimi_enable'] == "on"}checked="checked"{/if} onblur="madmimi_loadlist();"/>
							<label>Submit contact details to Mad Mimi</label>
						</div>
						<br><small>Please tick checkbox if you want to submit contact details to Mad Mimi.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<select id="ulp_madmimi_list_id" name="ulp_madmimi_list_id" class="btn-group selectpicker show-tick">
							<option>-- Select List --</option>
						</select>
						<br><small>Select desired list.</small>
					</div>
					{/if}
					{if $options['sendy_enable'] == "on"}
					<input type="hidden" id="ulp_sendy_url" name="ulp_sendy_url" value="{$options['sendy_url']}">
					<div class="form-group">
						<label>Enable Sendy: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_sendy_enable" name="ulp_sendy_enable" {if $popup_options['sendy_enable'] == "on"}checked="checked"{/if} />
							<label>Submit contact details to Sendy</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to Sendy.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<input type="text" id="ulp_sendy_listid" name="ulp_sendy_listid" value="{$popup_options['sendy_listid']}" class="form-control">
						<small>Enter your List ID. This encrypted & hashed id can be found under View all lists section named ID.</small>
					</div>
					{/if}
					{if $options['benchmark_enable'] == "on"}
					<input type="hidden" id="ulp_benchmark_api_key" name="ulp_benchmark_api_key" value="{$options['benchmark_api_key']}">
					<div class="form-group">
						<label>Enable Benchmark: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_benchmark_enable" name="ulp_benchmark_enable"{if $popup_options['benchmark_enable'] == "on"} checked="checked"{/if} onblur="benchmark_loadlist();" />
							<label>Submit contact details to Benchmark Email</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to Benchmark Email.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<select id="ulp_benchmark_list_id" name="ulp_benchmark_list_id" class="btn-group selectpicker show-tick">
							<option>-- Select List --</option>
						</select>
						<br><small>Select desired list.</small>
					</div>
					{/if}
					{if $options['activecampaign_enable'] == "on"}
					<input type="hidden" id="ulp_activecampaign_url" name="ulp_activecampaign_url" value="{$options['activecampaign_url']}">
					<input type="hidden" id="ulp_activecampaign_api_key" name="ulp_activecampaign_api_key" value="{$options['activecampaign_api_key']}">
					<div class="form-group">
						<label>Enable ActiveCampaign: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_activecampaign_enable" name="ulp_activecampaign_enable" {if $popup_options['activecampaign_enable'] == "on"}checked="checked"{/if} onblur="activecampaign_loadlist();" />
							<label>Submit contact details to ActiveCampaign</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to ActiveCampaign.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<select id="ulp_activecampaign_list_id" name="ulp_activecampaign_list_id" class="btn-group selectpicker show-tick">
							<option>-- Select List --</option>
						</select>
						<br><small>Select desired list.</small>
					</div>
					{/if}
					{if $options['interspire_enable'] == "on"}
					<input type="hidden" id="ulp_interspire_url" name="ulp_interspire_url" value="{$options['interspire_url']}">
					<input type="hidden" id="ulp_interspire_username" name="ulp_interspire_username" value="{$options['interspire_username']}">
					<input type="hidden" id="ulp_interspire_token" name="ulp_interspire_token" value="{$options['interspire_token']}">
					<div class="form-group">
						<label>Enable Interspire: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_interspire_enable" name="ulp_interspire_enable" {if $popup_options['interspire_enable'] == "on"}checked="checked"{/if} onblur="interspire_loadlist();" />
							<label>Submit contact details to Interspire</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to Interspire.</small>
					</div>
					<div class="form-group">
						<label>List ID: </label>
						<select id="ulp_interspire_listid" name="ulp_interspire_listid" class="btn-group selectpicker show-tick" onchange="interspire_loadfield();">
							<option>-- Select List --</option>
						</select>
						<br><small>Select desired list.</small>
					</div>
					<div class="form-group">
						<label>"Name" field ID: </label>
						<select id="ulp_interspire_nameid" name="ulp_interspire_nameid" class="btn-group selectpicker show-tick">
							<option>-- Select List --</option>
						</select>
						<br><small>Select your "Name" field.</small>
					</div>
					{/if}
					{if !empty($aweber_account->lists)}
					<div class="form-group">
						<label>Use AWeber: </label>
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="ulp_aweber_enable" name="ulp_aweber_enable" {if $popup_options['aweber_enable'] == "on"}checked="checked"{/if} />
							<label>Submit contact details to AWeber</label>
						</div>
						<small>Please tick checkbox if you want to submit contact details to AWeber.</small>
					</div>
					<div class="form-group">
						<label>AWeber List ID: </label>
						<select name="ulp_aweber_listid" class="btn-group selectpicker show-tick">
							{foreach from=$aweber_account->lists item='list'}
							<option value="{$list->id}"{if $list->id == $popup_options['aweber_listid']} selected="selected"{/if}>{$list->name}</option>
							{/foreach}
						</select>
						<br><small>Select your List ID.</small>
					</div>
					<div class="form-group">
						<label>AWeber List ID: </label>
						<select name="ulp_aweber_listid" class="btn-group selectpicker show-tick">
							{foreach from=$aweber_account->lists item='list'}
							<option value="{$list->id}"{if $list->id == $popup_options['aweber_listid']} selected="selected"{/if}>{$list->name}</option>
							{/foreach}
						</select>
						<br><small>Select your List ID.</small>
					</div>
					{/if}
				</fieldset>
            </div> 
        </div> 
    </div>
</div>
<div style="text-align: right; margin-bottom: 5px; margin-top: 20px;">
	<input type="hidden" name="action" value="save-popup" />
	<input type="hidden" name="ulp_id" value="{$id}" />
	<img class="ulp-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
	{if Core_Acs::haveAccess( array( 'Popup IO Admins' ) )}
	<div class="checkbox checkbox-primary">
		<input type="checkbox" name="user_id" value="0" {if $user_id==0}checked{/if}/>
		<label>Make it template</label>
	</div>
	{/if}
	<input type="submit" class="submit button" name="submit" value="Save Popup Details" onclick="return ulp_save_popup();">
</div>
<div class="ulp-message"></div>
<div id="ulp-overlay"></div>

<script>{literal}
	var ulp_local_fonts = new Array("arial","verdana");
	var ulp_active_layer = -1;
	var ulp_default_layer_options = {
	{/literal}{foreach from=Project_Exquisite_Layers::$defaultOptions item='value' key='key'}
		"{$key}" : "{$value}",
	{/foreach}{literal}
		"a" : ""
	};
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
	function ulp_save_popup() {
		jQuery(".ulp-popup-form").find(".ulp-loading").fadeIn(350);
		jQuery(".ulp-popup-form").find(".ulp-message").slideUp(350);
		jQuery(".ulp-popup-form").find(".ulp-button").attr("disabled", "disabled");
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', 
			jQuery(".ulp-popup-form").serialize(),
			function(return_data) {
				//alert(return_data);
				jQuery(".ulp-popup-form").find(".ulp-loading").fadeOut(350);
				jQuery(".ulp-popup-form").find(".ulp-button").removeAttr("disabled");
				var data;
				try {
					var data = jQuery.parseJSON(return_data);
					var status = data.status;
					if (status == "OK") {
						location.href = data.return_url;
					} else if (status == "ERROR") {
						jQuery(".ulp-popup-form").find(".ulp-message").html(data.message);
						jQuery(".ulp-popup-form").find(".ulp-message").slideDown(350);
					} else {
						jQuery(".ulp-popup-form").find(".ulp-message").html("Service is not available.");
						jQuery(".ulp-popup-form").find(".ulp-message").slideDown(350);
					}
				} catch(error) {
					jQuery(".ulp-popup-form").find(".ulp-message").html("Service is not available.");
					jQuery(".ulp-popup-form").find(".ulp-message").slideDown(350);
				}
			}
		);
		return false;
	}
	function ulp_add_layer() {
		jQuery("#ulp-overlay").fadeIn(350);
		jQuery("#ulp-new-layer").append(jQuery(".ulp-layer-options"));
		jQuery.each(ulp_default_layer_options, function(key, value) {
			if (key == "confirmation_layer" || key == "inline_disable") {
				if (value == "on") jQuery("[name='ulp_layer_"+key+"']").attr("checked", "checked");
				else jQuery("[name='ulp_layer_"+key+"']").removeAttr("checked");
			} else jQuery("[name='ulp_layer_"+key+"']").val(value);
		});
		jQuery("[name='ulp_layer_id']").val("0");
		ulp_active_layer = 0;
		jQuery("#ulp-new-layer").slideDown(350);
		return false;
	}
	function ulp_edit_layer(object) {
		var layer_item_id = jQuery(object).parentsUntil(".ulp-layers-item").parent().attr("id");
		layer_item_id = layer_item_id.replace("ulp-layer-", "");
		jQuery("#ulp-overlay").fadeIn(350);
		jQuery("#ulp-edit-layer-"+layer_item_id).append(jQuery(".ulp-layer-options"));
		jQuery.each(ulp_default_layer_options, function(key, value) {
			if (key == "confirmation_layer" || key == "inline_disable") {
				if (jQuery("[name='ulp_layer_"+layer_item_id+"_"+key+"']").val() == "on") jQuery("[name='ulp_layer_"+key+"']").attr("checked", "checked");
				else jQuery("[name='ulp_layer_"+key+"']").removeAttr("checked");
			} else jQuery("[name='ulp_layer_"+key+"']").val(jQuery("[name='ulp_layer_"+layer_item_id+"_"+key+"']").val());
		});
		jQuery("[name='ulp_layer_id']").val(layer_item_id);
		ulp_active_layer = layer_item_id;
		jQuery("#ulp-preview-layer-"+layer_item_id).addClass("ulp-preview-layer-active");
		jQuery("#ulp-edit-layer-"+layer_item_id).slideDown(350);
		return false;
	}
	function ulp_delete_layer(object) {
		var answer = confirm("Do you really want to remove this layer?")
		if (answer) {
			var layer_item_id = jQuery(object).parentsUntil(".ulp-layers-item").parent().attr("id");
			layer_item_id = layer_item_id.replace("ulp-layer-", "");
			jQuery("#ulp-edit-layer-"+layer_item_id).remove();
			jQuery("#ulp-layer-"+layer_item_id).fadeOut(350, function() {
				jQuery("#ulp-layer-"+layer_item_id).remove();
				jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', 
					"action=delete-layer&ulp_layer_id="+layer_item_id,
					function(return_data) {
						ulp_build_preview();
					}
				);
			});
		}
		return false;
	}
	function ulp_copy_layer(object) {
		var answer = confirm("Do you really want to duplicate this layer?")
		if (answer) {
			var layer_item_id = jQuery(object).parentsUntil(".ulp-layers-item").parent().attr("id");
			layer_item_id = layer_item_id.replace("ulp-layer-", "");
			jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', 
				"action=copy-layer&ulp_layer_id="+layer_item_id,
				function(return_data) {
					var data = jQuery.parseJSON(return_data);
					var status = data.status;
					if (status == "OK") {
						jQuery("#ulp-layers-data").append("<section class='ulp-layers-item' id='ulp-layer-"+data.layer_id+"' style='display: none;'></section><div class='ulp-edit-layer' id='ulp-edit-layer-"+data.layer_id+"'></div>");
						jQuery("#ulp-layer-"+data.layer_id).html(jQuery("#ulp-layers-item-container").html());
						jQuery("#ulp-layer-"+data.layer_id).find("h4").html(data.title);
						jQuery("#ulp-layer-"+data.layer_id).find("p").html(data.content);
						jQuery("#ulp-layer-"+data.layer_id).append(data.options_html);
						jQuery("#ulp-layer-"+data.layer_id).slideDown(350);
						ulp_build_preview();
					}
				}
			);
		}
		return false;
	}
	function ulp_cancel_layer(object) {
		jQuery("#ulp-overlay").fadeOut(350);
		var container = jQuery(object).parentsUntil(".ulp-layer-options").parent().parent();
		jQuery("#"+jQuery(container).attr("id")).slideUp(350, function() {
			jQuery("#ulp-layer-options-container").append(jQuery(".ulp-layer-options"));
			jQuery(".ulp-preview-layer-active").removeClass(".ulp-preview-layer-active");
			ulp_active_layer = -1;
			ulp_build_preview();
		});
		return false;
	}
	function ulp_save_layer() {
		jQuery(".ulp-layer-options").find(".ulp-loading").fadeIn(350);
		jQuery(".ulp-layer-options").find(".ulp-message").slideUp(350);
		jQuery(".ulp-layer-options").find(".ulp-button").attr("disabled", "disabled");
		jQuery.post('{/literal}{url name='site1_exquisite_popups' action='ajax'}{literal}', 
			jQuery(".ulp-layer-options input, .ulp-layer-options select, .ulp-layer-options textarea").serialize(),
			function(return_data) {
				//alert(return_data);
				jQuery(".ulp-layer-options").find(".ulp-loading").fadeOut(350);
				jQuery(".ulp-layer-options").find(".ulp-button").removeAttr("disabled");
				var data;
				try {
					var data = jQuery.parseJSON(return_data);
					var status = data.status;
					if (status == "OK") {
						jQuery("#ulp-overlay").fadeOut(350);
						if(jQuery("#ulp-layers-data").find("#ulp-layer-"+data.layer_id).length == 0) {
							jQuery("#ulp-new-layer").slideUp(350, function() {
								jQuery("#ulp-layer-options-container").append(jQuery(".ulp-layer-options"));
							});
							jQuery("#ulp-layers-data").append("<section class='ulp-layers-item' id='ulp-layer-"+data.layer_id+"' style='display: none;'></section><div class='ulp-edit-layer' id='ulp-edit-layer-"+data.layer_id+"'></div>");
							jQuery("#ulp-layer-"+data.layer_id).html(jQuery("#ulp-layers-item-container").html());
							jQuery("#ulp-layer-"+data.layer_id).find("h4").html(data.title);
							jQuery("#ulp-layer-"+data.layer_id).find("p").html(data.content);
							jQuery("#ulp-layer-"+data.layer_id).append(data.options_html);
							jQuery("#ulp-layer-"+data.layer_id).slideDown(350);
							ulp_active_layer = -1;
							jQuery(".ulp-preview-layer-active").removeClass(".ulp-preview-layer-active");
							ulp_build_preview();
						} else {
							jQuery("#ulp-edit-layer-"+data.layer_id).slideUp(350, function() {
								jQuery("#ulp-layer-options-container").append(jQuery(".ulp-layer-options"));
							});
							jQuery("#ulp-layer-"+data.layer_id).fadeOut(350, function() {
								jQuery("#ulp-layer-"+data.layer_id).html(jQuery("#ulp-layers-item-container").html());
								jQuery("#ulp-layer-"+data.layer_id).find("h4").html(data.title);
								jQuery("#ulp-layer-"+data.layer_id).find("p").html(data.content);
								jQuery("#ulp-layer-"+data.layer_id).append(data.options_html);
								jQuery("#ulp-layer-"+data.layer_id).fadeIn(350);
								ulp_active_layer = -1;
								jQuery(".ulp-preview-layer-active").removeClass(".ulp-preview-layer-active");
								ulp_build_preview();
							});
						}
					} else if (status == "ERROR") {
						jQuery(".ulp-layer-options").find(".ulp-message").html(data.message);
						jQuery(".ulp-layer-options").find(".ulp-message").slideDown(350);
					} else {
						jQuery(".ulp-layer-options").find(".ulp-message").html("Service is not available.");
						jQuery(".ulp-layer-options").find(".ulp-message").slideDown(350);
					}
				} catch(error) {
					jQuery(".ulp-layer-options").find(".ulp-message").html("Service is not available.");
					jQuery(".ulp-layer-options").find(".ulp-message").slideDown(350);
				}
			}
		);
		return false;
	}
	function ulp_build_preview() {
		jQuery(".ulp-preview-window").css({
			"width" : parseInt(jQuery("[name='ulp_width']").val(), 10) + "px",
			"height" : parseInt(jQuery("[name='ulp_height']").val(), 10) + "px"
		});
		var popup_style = "";
		var from_rgb = ulp_hex2rgb(jQuery("[name='ulp_button_color']").val());
		var to_color = "transparent";
		var from_color = "transparent";
		if (from_rgb) {
			var total = parseInt(from_rgb.r, 10)+parseInt(from_rgb.g, 10)+parseInt(from_rgb.b, 10);
			if (total == 0) total = 1;
			var to = {
				r : Math.max(0, parseInt(from_rgb.r, 10) - parseInt(48*from_rgb.r/total, 10)),
				g : Math.max(0, parseInt(from_rgb.g, 10) - parseInt(48*from_rgb.g/total, 10)),
				b : Math.max(0, parseInt(from_rgb.b, 10) - parseInt(48*from_rgb.b/total, 10))
			};
			from_color = jQuery("[name='ulp_button_color']").val();
			to_color = ulp_rgb2hex(to.r, to.g, to.b);
		}
		var input_border_color = "border-color:transparent !important;";
		if (jQuery("[name='ulp_input_border_color']").val() != "") input_border_color = "border-color:"+jQuery("[name='ulp_input_border_color']").val()+" !important;";
		input_border_color = input_border_color + " border-width:"+parseInt(jQuery("[name='ulp_input_border_width']").val(), 10)+"px !important; border-radius:"+parseInt(jQuery("[name='ulp_input_border_radius']").val(), 10)+"px !important;"
		var input_background_color = "background-color: transparent !important;";
		if (jQuery("[name='ulp_input_background_color']").val() != "") {
			var bg_rgb = ulp_hex2rgb(jQuery("[name='ulp_input_background_color']").val());
			input_background_color = "background-color:rgb("+parseInt(bg_rgb.r)+","+parseInt(bg_rgb.g)+","+parseInt(bg_rgb.b)+") !important;background-color:rgba("+parseInt(bg_rgb.r)+","+parseInt(bg_rgb.g)+","+parseInt(bg_rgb.b)+", "+jQuery("[name='ulp_input_background_opacity']").val()+") !important;";
		}
		if (jQuery("#ulp_button_gradient").is(":checked")) {
			popup_style += ".ulp-preview-submit,.ulp-preview-submit:visited{background: "+from_color+";border:1px solid "+from_color+";background-image:linear-gradient("+to_color+","+from_color+"); border-radius:"+parseInt(jQuery("[name='ulp_button_border_radius']").val(), 10)+"px !important;}";
			popup_style += ".ulp-preview-submit:hover,.ulp-preview-submit:active{background: "+to_color+";border:1px solid "+from_color+";background-image:linear-gradient("+from_color+","+to_color+"); border-radius:"+parseInt(jQuery("[name='ulp_button_border_radius']").val(), 10)+"px !important;}";
		} else {
			popup_style += ".ulp-preview-submit,.ulp-preview-submit:visited{background: "+from_color+";border:1px solid "+from_color+"; border-radius:"+parseInt(jQuery("[name='ulp_button_border_radius']").val(), 10)+"px !important;}";
			popup_style += ".ulp-preview-submit:hover,.ulp-preview-submit:active{background: "+to_color+";border:1px solid "+to_color+"; border-radius:"+parseInt(jQuery("[name='ulp_button_border_radius']").val(), 10)+"px !important;}";
		}
		if (jQuery("#ulp_button_css").val() != "") {
			popup_style += ".ulp-preview-submit,.ulp-preview-submit:visited{"+jQuery("#ulp_button_css").val()+"}";
		}
		if (jQuery("#ulp_button_css_hover").val() != "") {
			popup_style += ".ulp-preview-submit:hover,.ulp-preview-submit:active{"+jQuery("#ulp_button_css_hover").val()+"}";
		}
		
		from_rgb = ulp_hex2rgb(jQuery("[name='ulp_social2_facebook_color']").val());
		to_color = "transparent";
		from_color = "transparent";
		if (from_rgb) {
			var total = parseInt(from_rgb.r, 10)+parseInt(from_rgb.g, 10)+parseInt(from_rgb.b, 10);
			if (total == 0) total = 1;
			var to = {
				r : Math.max(0, parseInt(from_rgb.r, 10) - parseInt(48*from_rgb.r/total, 10)),
				g : Math.max(0, parseInt(from_rgb.g, 10) - parseInt(48*from_rgb.g/total, 10)),
				b : Math.max(0, parseInt(from_rgb.b, 10) - parseInt(48*from_rgb.b/total, 10))
			};
			from_color = jQuery("[name='ulp_social2_facebook_color']").val();
			to_color = ulp_rgb2hex(to.r, to.g, to.b);
		}
		if (jQuery("#ulp_button_gradient").is(":checked")) {
			popup_style += "#ulp-preview-social-facebook,#ulp-preview-social-facebook:visited{background: "+from_color+";border:1px solid "+from_color+";background-image:linear-gradient("+to_color+","+from_color+");}";
			popup_style += "#ulp-preview-social-facebook:hover,#ulp-preview-social-facebook:active{background: "+to_color+";border:1px solid "+from_color+";background-image:linear-gradient("+from_color+","+to_color+");}";
		} else {
			popup_style += "#ulp-preview-social-facebook,#ulp-preview-social-facebook:visited{background: "+from_color+";border:1px solid "+from_color+";}";
			popup_style += "#ulp-preview-social-facebook:hover,#ulp-preview-social-facebook:active{background: "+to_color+";border:1px solid "+to_color+";}";
		}

		from_rgb = ulp_hex2rgb(jQuery("[name='ulp_social2_google_color']").val());
		to_color = "transparent";
		from_color = "transparent";
		if (from_rgb) {
			var total = parseInt(from_rgb.r, 10)+parseInt(from_rgb.g, 10)+parseInt(from_rgb.b, 10);
			if (total == 0) total = 1;
			var to = {
				r : Math.max(0, parseInt(from_rgb.r, 10) - parseInt(48*from_rgb.r/total, 10)),
				g : Math.max(0, parseInt(from_rgb.g, 10) - parseInt(48*from_rgb.g/total, 10)),
				b : Math.max(0, parseInt(from_rgb.b, 10) - parseInt(48*from_rgb.b/total, 10))
			};
			from_color = jQuery("[name='ulp_social2_google_color']").val();
			to_color = ulp_rgb2hex(to.r, to.g, to.b);
		}
		if (jQuery("#ulp_button_gradient").is(":checked")) {
			popup_style += "#ulp-preview-social-google,#ulp-preview-social-google:visited{background: "+from_color+";border:1px solid "+from_color+";background-image:linear-gradient("+to_color+","+from_color+");}";
			popup_style += "#ulp-preview-social-google:hover,#ulp-preview-social-google:active{background: "+to_color+";border:1px solid "+from_color+";background-image:linear-gradient("+from_color+","+to_color+");}";
		} else {
			popup_style += "#ulp-preview-social-google,#ulp-preview-social-google:visited{background: "+from_color+";border:1px solid "+from_color+";}";
			popup_style += "#ulp-preview-social-google:hover,#ulp-preview-social-google:active{background: "+to_color+";border:1px solid "+to_color+";}";
		}
		popup_style += ".ulp-preview-social,.ulp-preview-social:visited,.ulp-preview-social:hover,.ulp-preview-social:active{border-radius:"+parseInt(jQuery("[name='ulp_button_border_radius']").val(), 10)+"px !important;}";
		if (jQuery("#ulp_button_css").val() != "") {
			popup_style += ".ulp-preview-social,.ulp-preview-social:visited{"+jQuery("#ulp_button_css").val()+"}";
		}
		if (jQuery("#ulp_button_css_hover").val() != "") {
			popup_style += ".ulp-preview-social:hover,.ulp-preview-social:active{"+jQuery("#ulp_button_css_hover").val()+"}";
		}
		popup_style += ".ulp-preview-input,.ulp-preview-input:hover,.ulp-preview-input:active,.ulp-preview-input:focus{"+input_border_color+""+input_background_color+"}";
		if (jQuery("#ulp_input_css").val() != "") {
			popup_style += ".ulp-preview-input,.ulp-preview-input:hover,.ulp-preview-input:active,.ulp-preview-input:focus{"+jQuery("#ulp_input_css").val()+"}";
		}
		jQuery(".ulp-preview-content").html("<style>"+popup_style+"</style>");
		var input_name_icon_html = "";
		var input_email_icon_html = "";
		var input_phone_icon_html = "";
		{/literal}{if $options['fa_enable'] == 'on'}{literal}
		if (jQuery("#ulp_input_icons").is(":checked")) {
			input_name_icon_html = "<div class='ulp-fa-input-table'><div class='ulp-fa-input-cell'><i class='fa fa-user'></i></div></div>";
			input_email_icon_html = "<div class='ulp-fa-input-table'><div class='ulp-fa-input-cell'><i class='fa fa-envelope'></i></div></div>";
			input_phone_icon_html = "<div class='ulp-fa-input-table'><div class='ulp-fa-input-cell'><i class='fa fa-phone'></i></div></div>";
		}
		{/literal}{/if}{literal}
		jQuery(".ulp-layers-item").each(function() {
			var layer_id = jQuery(this).attr("id").replace("ulp-layer-", "");
			if (ulp_active_layer == layer_id) {//alert( jQuery("#ulp_layer_content").val() );
				var content = jQuery("#ulp_layer_content").val();
				content = content.replace("{subscription-name}", "<input class='ulp-preview-input' id='ulp-preview-input-name' type='text'>"+input_name_icon_html);
				content = content.replace("{subscription-email}", "<input class='ulp-preview-input' id='ulp-preview-input-email' type='text'>"+input_email_icon_html);
				content = content.replace("{subscription-submit}", "<a class='ulp-preview-submit' id='ulp-preview-submit'></a>");
				content = content.replace("{subscription-phone}", "<input class='ulp-preview-input' id='ulp-preview-input-phone' type='text'>"+input_phone_icon_html);
				content = content.replace("{subscription-message}", "<textarea class='ulp-preview-input' id='ulp-preview-input-message'></textarea>");
				content = ulp_social_preview_content(content);
				var style = "#ulp-preview-layer-"+layer_id+" {left:" + parseInt(jQuery("#ulp_layer_left").val(), 10) + "px;top:" + parseInt(jQuery("#ulp_layer_top").val(), 10) + "px;}";
				if (jQuery("#ulp_layer_width").val() != "") style += "#ulp-preview-layer-"+layer_id+" {width:"+parseInt(jQuery("#ulp_layer_width").val(), 10)+"px;}";
				if (jQuery("#ulp_layer_height").val() != "") style += "#ulp-preview-layer-"+layer_id+" {height:"+parseInt(jQuery("#ulp_layer_height").val(), 10)+"px;}";
				var background = "";		
				if (jQuery("#ulp_layer_background_color").val() != "") {
					var rgb = ulp_hex2rgb(jQuery("#ulp_layer_background_color").val());
					if (rgb != false) background = "background-color:"+jQuery("#ulp_layer_background_color").val()+";background-color:rgba("+rgb.r+","+rgb.g+","+rgb.b+","+jQuery("#ulp_layer_background_opacity").val()+");";
				} else background = "";
				if (jQuery("#ulp_layer_background_image").val() != "") {
					background += "background-image:url("+jQuery("#ulp_layer_background_image").val()+");background-repeat:repeat;";
				}
				var font = "font-family:'"+jQuery("#ulp_layer_font").val()+"',arial;font-weight:"+jQuery("#ulp_layer_font_weight").val()+";color:"+jQuery("#ulp_layer_font_color").val()+";font-size:"+parseInt(jQuery("#ulp_layer_font_size").val(), 10)+"px;";
				if (parseInt(jQuery("#ulp_layer_text_shadow_size").val(), 10) != 0 && jQuery("#ulp_layer_text_shadow_color").val() != "") font += "text-shadow:"+jQuery("#ulp_layer_text_shadow_color").val()+" "+jQuery("#ulp_layer_text_shadow_size").val()+"px "+" "+jQuery("#ulp_layer_text_shadow_size").val()+"px "+" "+jQuery("#ulp_layer_text_shadow_size").val()+"px";
				style += "#ulp-preview-layer-"+layer_id+",#ulp-preview-layer-"+layer_id+" p,#ulp-preview-layer-"+layer_id+" a,#ulp-preview-layer-"+layer_id+" span,#ulp-preview-layer-"+layer_id+" li,#ulp-preview-layer-"+layer_id+" input,#ulp-preview-layer-"+layer_id+" button,#ulp-preview-layer-"+layer_id+" textarea {"+font+"}";
				{/literal}{if $options['fa_enable'] == 'on'}{literal}
				if (jQuery("#ulp_input_icons").is(":checked")) {
					style += "#ulp-preview-layer-"+layer_id+" input.ulp-preview-input {padding-left:"+parseInt(4+2*parseInt(jQuery("#ulp_layer_font_size").val(), 10), 10)+"px !important;} #ulp-preview-layer-"+layer_id+" div.ulp-fa-input-cell {width: "+parseInt(2*parseInt(jQuery("#ulp_layer_font_size").val(), 10), 10)+"px !important; padding-left: 4px !important;}";
				}
				{/literal}{/if}{literal}
				style += "#ulp-preview-layer-"+layer_id+"{"+background+"z-index:"+parseInt(parseInt(jQuery("#ulp_layer_index").val(), 10)+1000, 10)+";text-align:"+jQuery("#ulp_layer_content_align").val()+"}";
				if (jQuery("#ulp_layer_style").val() != "") style += "#ulp-preview-layer-"+layer_id+"{"+jQuery("#ulp_layer_style").val()+"}";
				var font_link = "";
				if (!ulp_inarray(jQuery("#ulp_layer_font").val(), ulp_local_fonts)) font_link = "<link href='http://fonts.googleapis.com/css?family="+jQuery("#ulp_layer_font").val().replace(" ", "+")+":100,200,300,400,500,600,700,800,900&subset=latin,latin-ext,cyrillic,cyrillic-ext,greek' rel='stylesheet' type='text/css'>";
				var layer = font_link+"<style>"+style+"</style><div class='ulp-preview-layer ulp-preview-layer-active' id='ulp-preview-layer-"+layer_id+"'>"+content+"</div>";
			} else {
				var content = jQuery("#ulp_layer_"+layer_id+"_content").val();
				content = content.replace("{subscription-name}", "<input class='ulp-preview-input' id='ulp-preview-input-name' type='text'>"+input_name_icon_html);
				content = content.replace("{subscription-email}", "<input class='ulp-preview-input' id='ulp-preview-input-email' type='text'>"+input_email_icon_html);
				content = content.replace("{subscription-submit}", "<a class='ulp-preview-submit' id='ulp-preview-submit'></a>");
				content = content.replace("{subscription-phone}", "<input class='ulp-preview-input' id='ulp-preview-input-phone' type='text'>"+input_phone_icon_html);
				content = content.replace("{subscription-message}", "<textarea class='ulp-preview-input' id='ulp-preview-input-message'></textarea>");
				content = ulp_social_preview_content(content);
				var style = "#ulp-preview-layer-"+layer_id+" {left:" + parseInt(jQuery("#ulp_layer_"+layer_id+"_left").val(), 10) + "px;top:" + parseInt(jQuery("#ulp_layer_"+layer_id+"_top").val(), 10) + "px;}";
				if (jQuery("#ulp_layer_"+layer_id+"_width").val() != "") style += "#ulp-preview-layer-"+layer_id+" {width:"+parseInt(jQuery("#ulp_layer_"+layer_id+"_width").val(), 10)+"px;}";
				if (jQuery("#ulp_layer_"+layer_id+"_height").val() != "") style += "#ulp-preview-layer-"+layer_id+" {height:"+parseInt(jQuery("#ulp_layer_"+layer_id+"_height").val(), 10)+"px;}";
				var background = "";		
				if (jQuery("#ulp_layer_"+layer_id+"_background_color").val() != "") {
					var rgb = ulp_hex2rgb(jQuery("#ulp_layer_"+layer_id+"_background_color").val());
					if (rgb != false) background = "background-color:"+jQuery("#ulp_layer_"+layer_id+"_background_color").val()+";background-color:rgba("+rgb.r+","+rgb.g+","+rgb.b+","+jQuery("#ulp_layer_"+layer_id+"_background_opacity").val()+");";
				} else background = "";
				if (jQuery("#ulp_layer_"+layer_id+"_background_image").val() != "") {
					background += "background-image:url("+jQuery("#ulp_layer_"+layer_id+"_background_image").val()+");background-repeat:repeat;";
				}
				var font = "font-family:'"+jQuery("#ulp_layer_"+layer_id+"_font").val()+"',arial;font-weight:"+jQuery("#ulp_layer_"+layer_id+"_font_weight").val()+";color:"+jQuery("#ulp_layer_"+layer_id+"_font_color").val()+";font-size:"+parseInt(jQuery("#ulp_layer_"+layer_id+"_font_size").val(), 10)+"px;";
				if (parseInt(jQuery("#ulp_layer_"+layer_id+"_text_shadow_size").val(), 10) != 0 && jQuery("#ulp_layer_"+layer_id+"_text_shadow_color").val() != "") font += "text-shadow:"+jQuery("#ulp_layer_"+layer_id+"_text_shadow_color").val()+" "+jQuery("#ulp_layer_"+layer_id+"_text_shadow_size").val()+"px "+" "+jQuery("#ulp_layer_"+layer_id+"_text_shadow_size").val()+"px "+" "+jQuery("#ulp_layer_"+layer_id+"_text_shadow_size").val()+"px";
				style += "#ulp-preview-layer-"+layer_id+",#ulp-preview-layer-"+layer_id+" p,#ulp-preview-layer-"+layer_id+" a,#ulp-preview-layer-"+layer_id+" span,#ulp-preview-layer-"+layer_id+" li,#ulp-preview-layer-"+layer_id+" input,#ulp-preview-layer-"+layer_id+" button,#ulp-preview-layer-"+layer_id+" textarea {"+font+"}";
				{/literal}{if $options['fa_enable'] == 'on'}{literal}
				if (jQuery("#ulp_input_icons").is(":checked")) {
					style += "#ulp-preview-layer-"+layer_id+" input.ulp-preview-input {padding-left:"+parseInt(4+2*parseInt(jQuery("#ulp_layer_"+layer_id+"_font_size").val(), 10), 10)+"px !important;} #ulp-preview-layer-"+layer_id+" div.ulp-fa-input-cell {width: "+parseInt(2*parseInt(jQuery("#ulp_layer_"+layer_id+"_font_size").val(), 10), 10)+"px !important; padding-left: 4px !important;}";
				}
				{/literal}{/if}{literal}
				style += "#ulp-preview-layer-"+layer_id+"{"+background+"z-index:"+parseInt(parseInt(jQuery("#ulp_layer_"+layer_id+"_index").val(), 10)+1000, 10)+";text-align:"+jQuery("#ulp_layer_"+layer_id+"_content_align").val()+";}";
				if (jQuery("#ulp_layer_"+layer_id+"_style").val() != "") style += "#ulp-preview-layer-"+layer_id+"{"+jQuery("#ulp_layer_"+layer_id+"_style").val()+"}";
				var font_link = "";
				if (!ulp_inarray(jQuery("#ulp_layer_"+layer_id+"_font").val(), ulp_local_fonts)) font_link = "<link href='http://fonts.googleapis.com/css?family="+jQuery("#ulp_layer_"+layer_id+"_font").val().replace(" ", "+")+":100,200,300,400,500,600,700,800,900&subset=latin,latin-ext,cyrillic,cyrillic-ext,greek' rel='stylesheet' type='text/css'>";
				var layer = font_link+"<style>"+style+"</style><div class='ulp-preview-layer' id='ulp-preview-layer-"+layer_id+"'>"+content+"</div>";
			}
			jQuery(".ulp-preview-content").append(layer);
		});
		
		if (ulp_active_layer == 0) {
			layer_id = "0";
			var content = jQuery("#ulp_layer_content").val();
			content = content.replace("{subscription-name}", "<input class='ulp-preview-input' id='ulp-preview-input-name' type='text'>"+input_name_icon_html);
			content = content.replace("{subscription-email}", "<input class='ulp-preview-input' id='ulp-preview-input-email' type='text'>"+input_email_icon_html);
			content = content.replace("{subscription-submit}", "<a class='ulp-preview-submit' id='ulp-preview-submit'></a>");
			content = content.replace("{subscription-phone}", "<input class='ulp-preview-input' id='ulp-preview-input-phone' type='text'>"+input_phone_icon_html);
			content = content.replace("{subscription-message}", "<textarea class='ulp-preview-input' id='ulp-preview-input-message'></textarea>");
			content = ulp_social_preview_content(content);
			var style = "#ulp-preview-layer-"+layer_id+" {left:" + parseInt(jQuery("#ulp_layer_left").val(), 10) + "px;top:" + parseInt(jQuery("#ulp_layer_top").val(), 10) + "px;}";
			if (jQuery("#ulp_layer_width").val() != "") style += "#ulp-preview-layer-"+layer_id+" {width:"+parseInt(jQuery("#ulp_layer_width").val(), 10)+"px;}";
			if (jQuery("#ulp_layer_height").val() != "") style += "#ulp-preview-layer-"+layer_id+" {height:"+parseInt(jQuery("#ulp_layer_height").val(), 10)+"px;}";
			var background = "";		
			if (jQuery("#ulp_layer_background_color").val() != "") {
				var rgb = ulp_hex2rgb(jQuery("#ulp_layer_background_color").val());
				if (rgb != false) background = "background-color:"+jQuery("#ulp_layer_background_color").val()+";background-color:rgba("+rgb.r+","+rgb.g+","+rgb.b+","+jQuery("#ulp_layer_background_opacity").val()+");";
			} else $background = "";
			if (jQuery("#ulp_layer_background_image").val() != "") {
				background += "background-image:url("+jQuery("#ulp_layer_background_image").val()+");background-repeat:repeat;";
			}
			var font = "font-family:'"+jQuery("#ulp_layer_font").val()+"',arial;font-weight:"+jQuery("#ulp_layer_font_weight").val()+";color:"+jQuery("#ulp_layer_font_color").val()+";font-size:"+parseInt(jQuery("#ulp_layer_font_size").val(), 10)+"px;";
			if (parseInt(jQuery("#ulp_layer_text_shadow_size").val(), 10) != 0 && jQuery("#ulp_layer_text_shadow_color").val() != "") font += "text-shadow:"+jQuery("#ulp_layer_text_shadow_color").val()+" "+jQuery("#ulp_layer_text_shadow_size").val()+"px "+" "+jQuery("#ulp_layer_text_shadow_size").val()+"px "+" "+jQuery("#ulp_layer_text_shadow_size").val()+"px;";
			style += "#ulp-preview-layer-"+layer_id+",#ulp-preview-layer-"+layer_id+" p,#ulp-preview-layer-"+layer_id+" a,#ulp-preview-layer-"+layer_id+" span,#ulp-preview-layer-"+layer_id+" li,#ulp-preview-layer-"+layer_id+" input,#ulp-preview-layer-"+layer_id+" button,#ulp-preview-layer-"+layer_id+" textarea {"+font+"}";
			{/literal}{if $options['fa_enable'] == 'on'}{literal}
			if (jQuery("#ulp_input_icons").is(":checked")) {
				style += "#ulp-preview-layer-"+layer_id+" input.ulp-preview-input {padding-left:"+parseInt(4+2*parseInt(jQuery("#ulp_layer_font_size").val(), 10), 10)+"px !important;} #ulp-preview-layer-"+layer_id+" div.ulp-fa-input-cell {width: "+parseInt(2*parseInt(jQuery("#ulp_layer_font_size").val(), 10), 10)+"px !important; padding-left: 4px !important;}";
			}
			{/literal}{/if}{literal}
			style += "#ulp-preview-layer-"+layer_id+"{"+background+"z-index:"+parseInt(parseInt(jQuery("#ulp_layer_index").val(), 10)+1000, 10)+";text-align:"+jQuery("#ulp_layer_content_align").val()+";}";
			if (jQuery("#ulp_layer_style").val() != "") style += "#ulp-preview-layer-"+layer_id+"{"+jQuery("#ulp_layer_style").val()+"}";
			var font_link = "";
			if (!ulp_inarray(jQuery("#ulp_layer_font").val(), ulp_local_fonts)) font_link = "<link href='http://fonts.googleapis.com/css?family="+jQuery("#ulp_layer_font").val().replace(" ", "+")+":100,200,300,400,500,600,700,800,900&subset=latin,latin-ext,cyrillic,cyrillic-ext,greek' rel='stylesheet' type='text/css'>";
			var layer = font_link+"<style>"+style+"</style><div class='ulp-preview-layer ulp-preview-layer-active' id='ulp-preview-layer-"+layer_id+"'>"+content+"</div>";
			jQuery(".ulp-preview-content").append(layer);
		}
		
		jQuery("#ulp-preview-input-name").attr("placeholder", jQuery("[name='ulp_name_placeholder']").val());
		jQuery("#ulp-preview-input-email").attr("placeholder", jQuery("[name='ulp_email_placeholder']").val());
		var button_icon = "";
		if (jQuery("#ulp-button-icon").val() && jQuery("#ulp-button-icon").val() != "fa-noicon") button_icon = "<i class='fa "+jQuery("#ulp-button-icon").val()+"'></i>&nbsp; "
		jQuery("#ulp-preview-submit").html(button_icon+jQuery("[name='ulp_button_label']").val());
		if (jQuery("#ulp_button_inherit_size").is(":checked")) {
			jQuery("#ulp-preview-submit").addClass("ulp-inherited");
		} else {
			jQuery("#ulp-preview-submit").removeClass("ulp-inherited");
		}
		jQuery("#ulp-preview-input-phone").attr("placeholder", jQuery("[name='ulp_phone_placeholder']").val());
		jQuery("#ulp-preview-input-message").attr("placeholder", jQuery("[name='ulp_message_placeholder']").val());
	}
	function ulp_social_preview_content(content) {
		var social_margin = parseInt(jQuery("#ulp_social_margin").val(), 10)
		var social_panel = "";
		var social_facebook_like = "";
		var social_google_plusone = "";
		var social_twitter_tweet = "";
		var social_linkedin_share = "";
		if (jQuery("#ulp_social_google_plusone").is(":checked")) {
			social_google_plusone = "<div class='ulp-social-button ulp-social-button-google-plusone' style='margin-left:"+social_margin+"px !important;margin-right:"+social_margin+"px !important;'><img src='/skin/i/frontends/design/newUI/exquisite_popups/google-plusone.png' alt=''></div>";
			social_panel = social_panel + social_google_plusone;
		}
		if (jQuery("#ulp_social_facebook_like").is(":checked")) {
			social_facebook_like = "<div class='ulp-social-button ulp-social-button-facebook-like' style='margin-left:"+social_margin+"px !important;margin-right:"+social_margin+"px !important;'><img src='/skin/i/frontends/design/newUI/exquisite_popups/facebook-like.png' alt=''></div>";
			social_panel = social_panel + social_facebook_like;
		}
		if (jQuery("#ulp_social_twitter_tweet").is(":checked")) {
			social_twitter_tweet = "<div class='ulp-social-button ulp-social-button-twitter-tweet' style='margin-left:"+social_margin+"px !important;margin-right:"+social_margin+"px !important;'><img src='/skin/i/frontends/design/newUI/exquisite_popups/twitter-tweet.png' alt=''></div>";
			social_panel = social_panel + social_twitter_tweet;
		}
		if (jQuery("#ulp_social_linkedin_share").is(":checked")) {
			ulp_social_linkedin_share = "<div class='ulp-social-button ulp-social-button-linkedin-share' style='margin-left:"+social_margin+"px !important;margin-right:"+social_margin+"px !important;'><img src='/skin/i/frontends/design/newUI/exquisite_popups/linkedin-share.png' alt=''></div>";
			social_panel = social_panel + ulp_social_linkedin_share;
		}
		content = content.replace("{social-panel}", social_panel);
		content = content.replace("{social-facebook-like}", social_facebook_like);
		content = content.replace("{social-google-plusone}", social_google_plusone);
		content = content.replace("{social-twitter-tweet}", social_twitter_tweet);
		content = content.replace("{social-linkedin-share}", ulp_social_linkedin_share);
		{/literal}{if $options['fa_enable'] == 'on'}{literal}
		var facebook_icon_html = "<i class='fa fa-facebook'></i>&nbsp; ";
		var google_icon_html = "<i class='fa fa-google'></i>&nbsp; ";
		{/literal}{else}{literal}
		var facebook_icon_html = "";
		var google_icon_html = "";
		{/literal}{/if}{literal}
		var social2_facebook = "";
		if (jQuery("#ulp_button_inherit_size").is(":checked")) {
			social2_facebook = "<a class='ulp-preview-social ulp-inherited' id='ulp-preview-social-facebook'>"+facebook_icon_html+jQuery("#ulp_social2_facebook_label").val()+"</a>";
		} else {
			social2_facebook = "<a class='ulp-preview-social' id='ulp-preview-social-facebook'>"+facebook_icon_html+jQuery("#ulp_social2_facebook_label").val()+"</a>";
		}
		var social2_google = "";
		if (jQuery("#ulp_button_inherit_size").is(":checked")) {
			social2_google = "<a class='ulp-preview-social ulp-inherited' id='ulp-preview-social-google'>"+google_icon_html+jQuery("#ulp_social2_google_label").val()+"</a>";
		} else {
			social2_google = "<a class='ulp-preview-social' id='ulp-preview-social-google'>"+google_icon_html+jQuery("#ulp_social2_google_label").val()+"</a>";
		}
		content = content.replace("{subscription-facebook}", social2_facebook);
		content = content.replace("{subscription-google}", social2_google);
		return content;
	}
	function ulp_2hex(c) {
		var hex = c.toString(16);
		return hex.length == 1 ? "0" + hex : hex;
	}
	function ulp_rgb2hex(r, g, b) {
		return "#" + ulp_2hex(r) + ulp_2hex(g) + ulp_2hex(b);
	}
	function ulp_hex2rgb(hex) {
		var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
		hex = hex.replace(shorthandRegex, function(m, r, g, b) {
			return r + r + g + g + b + b;
		});
		var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
		return result ? {
			r: parseInt(result[1], 16),
			g: parseInt(result[2], 16),
			b: parseInt(result[3], 16)
		} : false;
	}
	function ulp_inarray(needle, haystack) {
		var length = haystack.length;
		for(var i = 0; i < length; i++) {
			if(haystack[i] == needle) return true;
		}
		return false;
	}
	function ulp_self_close() {
		return false;
	}
	function ulp_seticon(object, prefix) {
		var icon = jQuery(object).children().attr("class");
		icon = icon.replace("fa ", "");
		jQuery("#"+prefix).val(icon);
		jQuery("#"+prefix+"-image i").removeClass();
		jQuery("#"+prefix+"-image i").addClass("fa "+icon);
		jQuery("#"+prefix+"-set .ulp-icon-active").removeClass("ulp-icon-active");
		jQuery(object).addClass("ulp-icon-active");
		jQuery("#"+prefix+"-set").slideUp(300);
		ulp_build_preview();
	}

	ulp_build_preview();
	var ulp_keyuprefreshtimer;
	jQuery(document).ready(function(){
		jQuery("input, select, textarea").bind("change", function() {
			clearTimeout(ulp_keyuprefreshtimer);
			ulp_build_preview();
		});
		jQuery("input, select, textarea").bind("keyup", function() {
			clearTimeout(ulp_keyuprefreshtimer);
			ulp_keyuprefreshtimer = setTimeout(function(){ulp_build_preview();}, 1000);
		});
	});
{/literal}
</script>
</form>




<div id="ulp-layers-item-container" style="display: none;">
	<div class="ulp-layers-item-cell ulp-layers-item-cell-info">
		<h4></h4>
		<p></p>
	</div>
	<div class="ulp-layers-item-cell" style="width: 70px;">
		<a href="#" title="Edit layer details" onclick="return ulp_edit_layer(this);"><img src="/skin/i/frontends/design/newUI/exquisite_popups/edit.png" alt="Edit layer details" border="0"></a>
		<a href="#" title="Duplicate layer" onclick="return ulp_copy_layer(this);"><img src="/skin/i/frontends/design/newUI/exquisite_popups/copy.png" alt="Duplicate details" border="0"></a>
		<a href="#" title="Delete layer" onclick="return ulp_delete_layer(this);"><img src="/skin/i/frontends/design/newUI/exquisite_popups/delete.png" alt="Delete layer" border="0"></a>
	</div>
</div>


<div id="ulp-layer-options-container" style="display: none;">
	<div class="ulp-layer-options">
		<div class="ulp-layer-row">
			<div class="ulp-layer-property">
				<label>Layer title</label>
				<input type="text" id="ulp_layer_title" name="ulp_layer_title" value="" class="widefat" placeholder="Enter the layer title...">
				<br /><em>Enter the layer title. It is used for your reference.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property">
				<label>Layer content</label>
				<textarea id="ulp_layer_content" name="ulp_layer_content" class="widefat" placeholder="Enter the layer content..."></textarea>
				<br /><em>Enter the layer content. HTML-code allowed.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property">
				<label>Layer size</label>
				<input type="text" id="ulp_layer_width" name="ulp_layer_width" value="" class="ic_input_number" placeholder="Width"> x
				<input type="text" id="ulp_layer_height" name="ulp_layer_height" value="" class="ic_input_number" placeholder="Height"> pixels
				<br /><em>Enter the layer size, width x height. Leave both or one field empty for auto calculation.</em>
			</div>
			<div class="ulp-layer-property">
				<label>Left position</label>
				<input type="text" id="ulp_layer_left" name="ulp_layer_left" value="" class="ic_input_number" placeholder="Left"> pixels
				<br /><em>Enter the layer left position relative basic frame left edge.</em>
			</div>
			<div class="ulp-layer-property">
				<label>Top position</label>
				<input type="text" id="ulp_layer_top" name="ulp_layer_top" value="" class="ic_input_number" placeholder="Top"> pixels
				<br /><em>Enter the layer top position relative basic frame top edge.</em>
			</div>
			<div class="ulp-layer-property">
				<label>Content alignment</label>
				<select class="ic_input_s" id="ulp_layer_content_align" name="ulp_layer_content_align">
					<option value="left">Left</option>
					<option value="right">Right</option>
					<option value="center">Center</option>
					<option value="justify">Justify</option>
				</select>
				<br /><em>Set the horizontal content alignment.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property" style="width: 25%;">
				<label>Appearance</label>
				<select class="ic_input_s" id="ulp_layer_appearance" name="ulp_layer_appearance">
					<option value="fade-in">Fade In</option>
					<option value="slide-up">Slide Up</option>
					<option value="slide-down">Slide Down</option>
					<option value="slide-left">Slide Left</option>
					<option value="slide-right">Slide Right</option>

				</select>
				<br /><em>Set the layer appearance.</em>
			</div>
			<div class="ulp-layer-property" style="width: 25%;">
				<label>Start delay</label>
				<input type="text" id="ulp_layer_appearance_delay" name="ulp_layer_appearance_delay" value="" class="ic_input_number" placeholder="[0...10000]"> milliseconds
				<br /><em>Set the appearance start delay. The value must be in a range [0...1].</em>
			</div>
			<div class="ulp-layer-property" style="width: 25%;">
				<label>Duration speed</label>
				<input type="text" id="ulp_layer_appearance_speed" name="ulp_layer_appearance_speed" value="" class="ic_input_number" placeholder="[0...10000]"> milliseconds
				<br /><em>Set the duration speed in milliseconds.</em>
			</div>
			<div class="ulp-layer-property" style="width: 25%;">
				<label>Layer index</label>
				<input type="text" id="ulp_layer_index" name="ulp_layer_index" value="" class="ic_input_number" placeholder="[0...100]">
				<br /><em>Set the stack order of the layer. A layer with greater stack order is always in front of a layer with a lower stack order.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property" style="width: 270px;">
				<label>Background color</label>
				<input type="text" class="ulp-color ic_input_number" id="ulp_layer_background_color" name="ulp_layer_background_color" value="" placeholder="">
				<br /><em>Set the background color. Leave empty for transparent background.</em>
			</div>
			<div class="ulp-layer-property" style="width: 200px;">
				<label>Background opacity</label>
				<input type="text" id="ulp_layer_background_opacity" name="ulp_layer_background_opacity" value="" class="ic_input_number" placeholder="[0...1]">
				<br /><em>Set the background opacity. The value must be in a range [0...1].</em>
			</div>
			<div class="ulp-layer-property">
				<label>Background image URL</label>
				<input type="text" id="ulp_layer_background_image" name="ulp_layer_background_image" value="" class="widefat" placeholder="Enter the background image URL...">
				<br /><em>Enter the background image URL.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property" style="width: 230px;">
				<label>Font</label>
				<select class="medium-input" id="ulp_layer_font" name="ulp_layer_font">
					<option disabled="disabled">------ LOCAL FONTS ------</option><option value="arial">Arial</option><option value="verdana">Verdana</option><option disabled="disabled">------ WEB FONTS ------</option><option value="ABeeZee">ABeeZee</option><option value="Abel">Abel</option><option value="Abril Fatface">Abril Fatface</option><option value="Aclonica">Aclonica</option><option value="Acme">Acme</option><option value="Actor">Actor</option><option value="Adamina">Adamina</option><option value="Advent Pro">Advent Pro</option><option value="Aguafina Script">Aguafina Script</option><option value="Akronim">Akronim</option><option value="Aladin">Aladin</option><option value="Aldrich">Aldrich</option><option value="Alegreya">Alegreya</option><option value="Alegreya SC">Alegreya SC</option><option value="Alex Brush">Alex Brush</option><option value="Alfa Slab One">Alfa Slab One</option><option value="Alice">Alice</option><option value="Alike">Alike</option><option value="Alike Angular">Alike Angular</option><option value="Allan">Allan</option><option value="Allerta">Allerta</option><option value="Allerta Stencil">Allerta Stencil</option><option value="Allura">Allura</option><option value="Almendra">Almendra</option><option value="Almendra Display">Almendra Display</option><option value="Almendra SC">Almendra SC</option><option value="Amarante">Amarante</option><option value="Amaranth">Amaranth</option><option value="Amatic SC">Amatic SC</option><option value="Amethysta">Amethysta</option><option value="Anaheim">Anaheim</option><option value="Andada">Andada</option><option value="Andika">Andika</option><option value="Angkor">Angkor</option><option value="Annie Use Your Telescope">Annie Use Your Telescope</option><option value="Anonymous Pro">Anonymous Pro</option><option value="Antic">Antic</option><option value="Antic Didone">Antic Didone</option><option value="Antic Slab">Antic Slab</option><option value="Anton">Anton</option><option value="Arapey">Arapey</option><option value="Arbutus">Arbutus</option><option value="Arbutus Slab">Arbutus Slab</option><option value="Architects Daughter">Architects Daughter</option><option value="Archivo Black">Archivo Black</option><option value="Archivo Narrow">Archivo Narrow</option><option value="Arimo">Arimo</option><option value="Arizonia">Arizonia</option><option value="Armata">Armata</option><option value="Artifika">Artifika</option><option value="Arvo">Arvo</option><option value="Asap">Asap</option><option value="Asset">Asset</option><option value="Astloch">Astloch</option><option value="Asul">Asul</option><option value="Atomic Age">Atomic Age</option><option value="Aubrey">Aubrey</option><option value="Audiowide">Audiowide</option><option value="Autour One">Autour One</option><option value="Average">Average</option><option value="Average Sans">Average Sans</option><option value="Averia Gruesa Libre">Averia Gruesa Libre</option><option value="Averia Libre">Averia Libre</option><option value="Averia Sans Libre">Averia Sans Libre</option><option value="Averia Serif Libre">Averia Serif Libre</option><option value="Bad Script">Bad Script</option><option value="Balthazar">Balthazar</option><option value="Bangers">Bangers</option><option value="Basic">Basic</option><option value="Battambang">Battambang</option><option value="Baumans">Baumans</option><option value="Bayon">Bayon</option><option value="Belgrano">Belgrano</option><option value="Belleza">Belleza</option><option value="BenchNine">BenchNine</option><option value="Bentham">Bentham</option><option value="Berkshire Swash">Berkshire Swash</option><option value="Bevan">Bevan</option><option value="Bigelow Rules">Bigelow Rules</option><option value="Bigshot One">Bigshot One</option><option value="Bilbo">Bilbo</option><option value="Bilbo Swash Caps">Bilbo Swash Caps</option><option value="Bitter">Bitter</option><option value="Black Ops One">Black Ops One</option><option value="Bokor">Bokor</option><option value="Bonbon">Bonbon</option><option value="Boogaloo">Boogaloo</option><option value="Bowlby One">Bowlby One</option><option value="Bowlby One SC">Bowlby One SC</option><option value="Brawler">Brawler</option><option value="Bree Serif">Bree Serif</option><option value="Bubblegum Sans">Bubblegum Sans</option><option value="Bubbler One">Bubbler One</option><option value="Buda">Buda</option><option value="Buenard">Buenard</option><option value="Butcherman">Butcherman</option><option value="Butterfly Kids">Butterfly Kids</option><option value="Cabin">Cabin</option><option value="Cabin Condensed">Cabin Condensed</option><option value="Cabin Sketch">Cabin Sketch</option><option value="Caesar Dressing">Caesar Dressing</option><option value="Cagliostro">Cagliostro</option><option value="Calligraffitti">Calligraffitti</option><option value="Cambo">Cambo</option><option value="Candal">Candal</option><option value="Cantarell">Cantarell</option><option value="Cantata One">Cantata One</option><option value="Cantora One">Cantora One</option><option value="Capriola">Capriola</option><option value="Cardo">Cardo</option><option value="Carme">Carme</option><option value="Carrois Gothic">Carrois Gothic</option><option value="Carrois Gothic SC">Carrois Gothic SC</option><option value="Carter One">Carter One</option><option value="Caudex">Caudex</option><option value="Cedarville Cursive">Cedarville Cursive</option><option value="Ceviche One">Ceviche One</option><option value="Changa One">Changa One</option><option value="Chango">Chango</option><option value="Chau Philomene One">Chau Philomene One</option><option value="Chela One">Chela One</option><option value="Chelsea Market">Chelsea Market</option><option value="Chenla">Chenla</option><option value="Cherry Cream Soda">Cherry Cream Soda</option><option value="Cherry Swash">Cherry Swash</option><option value="Chewy">Chewy</option><option value="Chicle">Chicle</option><option value="Chivo">Chivo</option><option value="Cinzel">Cinzel</option><option value="Cinzel Decorative">Cinzel Decorative</option><option value="Clicker Script">Clicker Script</option><option value="Coda">Coda</option><option value="Coda Caption">Coda Caption</option><option value="Codystar">Codystar</option><option value="Combo">Combo</option><option value="Comfortaa">Comfortaa</option><option value="Coming Soon">Coming Soon</option><option value="Concert One">Concert One</option><option value="Condiment">Condiment</option><option value="Content">Content</option><option value="Contrail One">Contrail One</option><option value="Convergence">Convergence</option><option value="Cookie">Cookie</option><option value="Copse">Copse</option><option value="Corben">Corben</option><option value="Courgette">Courgette</option><option value="Cousine">Cousine</option><option value="Coustard">Coustard</option><option value="Covered By Your Grace">Covered By Your Grace</option><option value="Crafty Girls">Crafty Girls</option><option value="Creepster">Creepster</option><option value="Crete Round">Crete Round</option><option value="Crimson Text">Crimson Text</option><option value="Croissant One">Croissant One</option><option value="Crushed">Crushed</option><option value="Cuprum">Cuprum</option><option value="Cutive">Cutive</option><option value="Cutive Mono">Cutive Mono</option><option value="Damion">Damion</option><option value="Dancing Script">Dancing Script</option><option value="Dangrek">Dangrek</option><option value="Dawning of a New Day">Dawning of a New Day</option><option value="Days One">Days One</option><option value="Delius">Delius</option><option value="Delius Swash Caps">Delius Swash Caps</option><option value="Delius Unicase">Delius Unicase</option><option value="Della Respira">Della Respira</option><option value="Denk One">Denk One</option><option value="Devonshire">Devonshire</option><option value="Didact Gothic">Didact Gothic</option><option value="Diplomata">Diplomata</option><option value="Diplomata SC">Diplomata SC</option><option value="Domine">Domine</option><option value="Donegal One">Donegal One</option><option value="Doppio One">Doppio One</option><option value="Dorsa">Dorsa</option><option value="Dosis">Dosis</option><option value="Dr Sugiyama">Dr Sugiyama</option><option value="Droid Sans">Droid Sans</option><option value="Droid Sans Mono">Droid Sans Mono</option><option value="Droid Serif">Droid Serif</option><option value="Duru Sans">Duru Sans</option><option value="Dynalight">Dynalight</option><option value="EB Garamond">EB Garamond</option><option value="Eagle Lake">Eagle Lake</option><option value="Eater">Eater</option><option value="Economica">Economica</option><option value="Electrolize">Electrolize</option><option value="Elsie">Elsie</option><option value="Elsie Swash Caps">Elsie Swash Caps</option><option value="Emblema One">Emblema One</option><option value="Emilys Candy">Emilys Candy</option><option value="Engagement">Engagement</option><option value="Englebert">Englebert</option><option value="Enriqueta">Enriqueta</option><option value="Erica One">Erica One</option><option value="Esteban">Esteban</option><option value="Euphoria Script">Euphoria Script</option><option value="Ewert">Ewert</option><option value="Exo">Exo</option><option value="Expletus Sans">Expletus Sans</option><option value="Fanwood Text">Fanwood Text</option><option value="Fascinate">Fascinate</option><option value="Fascinate Inline">Fascinate Inline</option><option value="Faster One">Faster One</option><option value="Fasthand">Fasthand</option><option value="Federant">Federant</option><option value="Federo">Federo</option><option value="Felipa">Felipa</option><option value="Fenix">Fenix</option><option value="Finger Paint">Finger Paint</option><option value="Fjalla One">Fjalla One</option><option value="Fjord One">Fjord One</option><option value="Flamenco">Flamenco</option><option value="Flavors">Flavors</option><option value="Fondamento">Fondamento</option><option value="Fontdiner Swanky">Fontdiner Swanky</option><option value="Forum">Forum</option><option value="Francois One">Francois One</option><option value="Freckle Face">Freckle Face</option><option value="Fredericka the Great">Fredericka the Great</option><option value="Fredoka One">Fredoka One</option><option value="Freehand">Freehand</option><option value="Fresca">Fresca</option><option value="Frijole">Frijole</option><option value="Fruktur">Fruktur</option><option value="Fugaz One">Fugaz One</option><option value="GFS Didot">GFS Didot</option><option value="GFS Neohellenic">GFS Neohellenic</option><option value="Gabriela">Gabriela</option><option value="Gafata">Gafata</option><option value="Galdeano">Galdeano</option><option value="Galindo">Galindo</option><option value="Gentium Basic">Gentium Basic</option><option value="Gentium Book Basic">Gentium Book Basic</option><option value="Geo">Geo</option><option value="Geostar">Geostar</option><option value="Geostar Fill">Geostar Fill</option><option value="Germania One">Germania One</option><option value="Gilda Display">Gilda Display</option><option value="Give You Glory">Give You Glory</option><option value="Glass Antiqua">Glass Antiqua</option><option value="Glegoo">Glegoo</option><option value="Gloria Hallelujah">Gloria Hallelujah</option><option value="Goblin One">Goblin One</option><option value="Gochi Hand">Gochi Hand</option><option value="Gorditas">Gorditas</option><option value="Goudy Bookletter 1911">Goudy Bookletter 1911</option><option value="Graduate">Graduate</option><option value="Grand Hotel">Grand Hotel</option><option value="Gravitas One">Gravitas One</option><option value="Great Vibes">Great Vibes</option><option value="Griffy">Griffy</option><option value="Gruppo">Gruppo</option><option value="Gudea">Gudea</option><option value="Habibi">Habibi</option><option value="Hammersmith One">Hammersmith One</option><option value="Hanalei">Hanalei</option><option value="Hanalei Fill">Hanalei Fill</option><option value="Handlee">Handlee</option><option value="Hanuman">Hanuman</option><option value="Happy Monkey">Happy Monkey</option><option value="Headland One">Headland One</option><option value="Henny Penny">Henny Penny</option><option value="Herr Von Muellerhoff">Herr Von Muellerhoff</option><option value="Holtwood One SC">Holtwood One SC</option><option value="Homemade Apple">Homemade Apple</option><option value="Homenaje">Homenaje</option><option value="IM Fell DW Pica">IM Fell DW Pica</option><option value="IM Fell DW Pica SC">IM Fell DW Pica SC</option><option value="IM Fell Double Pica">IM Fell Double Pica</option><option value="IM Fell Double Pica SC">IM Fell Double Pica SC</option><option value="IM Fell English">IM Fell English</option><option value="IM Fell English SC">IM Fell English SC</option><option value="IM Fell French Canon">IM Fell French Canon</option><option value="IM Fell French Canon SC">IM Fell French Canon SC</option><option value="IM Fell Great Primer">IM Fell Great Primer</option><option value="IM Fell Great Primer SC">IM Fell Great Primer SC</option><option value="Iceberg">Iceberg</option><option value="Iceland">Iceland</option><option value="Imprima">Imprima</option><option value="Inconsolata">Inconsolata</option><option value="Inder">Inder</option><option value="Indie Flower">Indie Flower</option><option value="Inika">Inika</option><option value="Irish Grover">Irish Grover</option><option value="Istok Web">Istok Web</option><option value="Italiana">Italiana</option><option value="Italianno">Italianno</option><option value="Jacques Francois">Jacques Francois</option><option value="Jacques Francois Shadow">Jacques Francois Shadow</option><option value="Jim Nightshade">Jim Nightshade</option><option value="Jockey One">Jockey One</option><option value="Jolly Lodger">Jolly Lodger</option><option value="Josefin Sans">Josefin Sans</option><option value="Josefin Slab">Josefin Slab</option><option value="Joti One">Joti One</option><option value="Judson">Judson</option><option value="Julee">Julee</option><option value="Julius Sans One">Julius Sans One</option><option value="Junge">Junge</option><option value="Jura">Jura</option><option value="Just Another Hand">Just Another Hand</option><option value="Just Me Again Down Here">Just Me Again Down Here</option><option value="Kameron">Kameron</option><option value="Karla">Karla</option><option value="Kaushan Script">Kaushan Script</option><option value="Kavoon">Kavoon</option><option value="Keania One">Keania One</option><option value="Kelly Slab">Kelly Slab</option><option value="Kenia">Kenia</option><option value="Khmer">Khmer</option><option value="Kite One">Kite One</option><option value="Knewave">Knewave</option><option value="Kotta One">Kotta One</option><option value="Koulen">Koulen</option><option value="Kranky">Kranky</option><option value="Kreon">Kreon</option><option value="Kristi">Kristi</option><option value="Krona One">Krona One</option><option value="La Belle Aurore">La Belle Aurore</option><option value="Lancelot">Lancelot</option><option value="Lato">Lato</option><option value="League Script">League Script</option><option value="Leckerli One">Leckerli One</option><option value="Ledger">Ledger</option><option value="Lekton">Lekton</option><option value="Lemon">Lemon</option><option value="Libre Baskerville">Libre Baskerville</option><option value="Life Savers">Life Savers</option><option value="Lilita One">Lilita One</option><option value="Limelight">Limelight</option><option value="Linden Hill">Linden Hill</option><option value="Lobster">Lobster</option><option value="Lobster Two">Lobster Two</option><option value="Londrina Outline">Londrina Outline</option><option value="Londrina Shadow">Londrina Shadow</option><option value="Londrina Sketch">Londrina Sketch</option><option value="Londrina Solid">Londrina Solid</option><option value="Lora">Lora</option><option value="Love Ya Like A Sister">Love Ya Like A Sister</option><option value="Loved by the King">Loved by the King</option><option value="Lovers Quarrel">Lovers Quarrel</option><option value="Luckiest Guy">Luckiest Guy</option><option value="Lusitana">Lusitana</option><option value="Lustria">Lustria</option><option value="Macondo">Macondo</option><option value="Macondo Swash Caps">Macondo Swash Caps</option><option value="Magra">Magra</option><option value="Maiden Orange">Maiden Orange</option><option value="Mako">Mako</option><option value="Marcellus">Marcellus</option><option value="Marcellus SC">Marcellus SC</option><option value="Marck Script">Marck Script</option><option value="Margarine">Margarine</option><option value="Marko One">Marko One</option><option value="Marmelad">Marmelad</option><option value="Marvel">Marvel</option><option value="Mate">Mate</option><option value="Mate SC">Mate SC</option><option value="Maven Pro">Maven Pro</option><option value="McLaren">McLaren</option><option value="Meddon">Meddon</option><option value="MedievalSharp">MedievalSharp</option><option value="Medula One">Medula One</option><option value="Megrim">Megrim</option><option value="Meie Script">Meie Script</option><option value="Merienda">Merienda</option><option value="Merienda One">Merienda One</option><option value="Merriweather">Merriweather</option><option value="Merriweather Sans">Merriweather Sans</option><option value="Metal">Metal</option><option value="Metal Mania">Metal Mania</option><option value="Metamorphous">Metamorphous</option><option value="Metrophobic">Metrophobic</option><option value="Michroma">Michroma</option><option value="Milonga">Milonga</option><option value="Miltonian">Miltonian</option><option value="Miltonian Tattoo">Miltonian Tattoo</option><option value="Miniver">Miniver</option><option value="Miss Fajardose">Miss Fajardose</option><option value="Modern Antiqua">Modern Antiqua</option><option value="Molengo">Molengo</option><option value="Molle">Molle</option><option value="Monda">Monda</option><option value="Monofett">Monofett</option><option value="Monoton">Monoton</option><option value="Monsieur La Doulaise">Monsieur La Doulaise</option><option value="Montaga">Montaga</option><option value="Montez">Montez</option><option value="Montserrat">Montserrat</option><option value="Montserrat Alternates">Montserrat Alternates</option><option value="Montserrat Subrayada">Montserrat Subrayada</option><option value="Moul">Moul</option><option value="Moulpali">Moulpali</option><option value="Mountains of Christmas">Mountains of Christmas</option><option value="Mouse Memoirs">Mouse Memoirs</option><option value="Mr Bedfort">Mr Bedfort</option><option value="Mr Dafoe">Mr Dafoe</option><option value="Mr De Haviland">Mr De Haviland</option><option value="Mrs Saint Delafield">Mrs Saint Delafield</option><option value="Mrs Sheppards">Mrs Sheppards</option><option value="Muli">Muli</option><option value="Mystery Quest">Mystery Quest</option><option value="Neucha">Neucha</option><option value="Neuton">Neuton</option><option value="New Rocker">New Rocker</option><option value="News Cycle">News Cycle</option><option value="Niconne">Niconne</option><option value="Nixie One">Nixie One</option><option value="Nobile">Nobile</option><option value="Nokora">Nokora</option><option value="Norican">Norican</option><option value="Nosifer">Nosifer</option><option value="Nothing You Could Do">Nothing You Could Do</option><option value="Noticia Text">Noticia Text</option><option value="Nova Cut">Nova Cut</option><option value="Nova Flat">Nova Flat</option><option value="Nova Mono">Nova Mono</option><option value="Nova Oval">Nova Oval</option><option value="Nova Round">Nova Round</option><option value="Nova Script">Nova Script</option><option value="Nova Slim">Nova Slim</option><option value="Nova Square">Nova Square</option><option value="Numans">Numans</option><option value="Nunito">Nunito</option><option value="Odor Mean Chey">Odor Mean Chey</option><option value="Offside">Offside</option><option value="Old Standard TT">Old Standard TT</option><option value="Oldenburg">Oldenburg</option><option value="Oleo Script">Oleo Script</option><option value="Oleo Script Swash Caps">Oleo Script Swash Caps</option><option value="Open Sans">Open Sans</option><option value="Open Sans Condensed">Open Sans Condensed</option><option value="Oranienbaum">Oranienbaum</option><option value="Orbitron">Orbitron</option><option value="Oregano">Oregano</option><option value="Orienta">Orienta</option><option value="Original Surfer">Original Surfer</option><option value="Oswald">Oswald</option><option value="Over the Rainbow">Over the Rainbow</option><option value="Overlock">Overlock</option><option value="Overlock SC">Overlock SC</option><option value="Ovo">Ovo</option><option value="Oxygen">Oxygen</option><option value="Oxygen Mono">Oxygen Mono</option><option value="PT Mono">PT Mono</option><option value="PT Sans">PT Sans</option><option value="PT Sans Caption">PT Sans Caption</option><option value="PT Sans Narrow">PT Sans Narrow</option><option value="PT Serif">PT Serif</option><option value="PT Serif Caption">PT Serif Caption</option><option value="Pacifico">Pacifico</option><option value="Paprika">Paprika</option><option value="Parisienne">Parisienne</option><option value="Passero One">Passero One</option><option value="Passion One">Passion One</option><option value="Patrick Hand">Patrick Hand</option><option value="Patrick Hand SC">Patrick Hand SC</option><option value="Patua One">Patua One</option><option value="Paytone One">Paytone One</option><option value="Peralta">Peralta</option><option value="Permanent Marker">Permanent Marker</option><option value="Petit Formal Script">Petit Formal Script</option><option value="Petrona">Petrona</option><option value="Philosopher">Philosopher</option><option value="Piedra">Piedra</option><option value="Pinyon Script">Pinyon Script</option><option value="Pirata One">Pirata One</option><option value="Plaster">Plaster</option><option value="Play">Play</option><option value="Playball">Playball</option><option value="Playfair Display">Playfair Display</option><option value="Playfair Display SC">Playfair Display SC</option><option value="Podkova">Podkova</option><option value="Poiret One">Poiret One</option><option value="Poller One">Poller One</option><option value="Poly">Poly</option><option value="Pompiere">Pompiere</option><option value="Pontano Sans">Pontano Sans</option><option value="Port Lligat Sans">Port Lligat Sans</option><option value="Port Lligat Slab">Port Lligat Slab</option><option value="Prata">Prata</option><option value="Preahvihear">Preahvihear</option><option value="Press Start 2P">Press Start 2P</option><option value="Princess Sofia">Princess Sofia</option><option value="Prociono">Prociono</option><option value="Prosto One">Prosto One</option><option value="Puritan">Puritan</option><option value="Purple Purse">Purple Purse</option><option value="Quando">Quando</option><option value="Quantico">Quantico</option><option value="Quattrocento">Quattrocento</option><option value="Quattrocento Sans">Quattrocento Sans</option><option value="Questrial">Questrial</option><option value="Quicksand">Quicksand</option><option value="Quintessential">Quintessential</option><option value="Qwigley">Qwigley</option><option value="Racing Sans One">Racing Sans One</option><option value="Radley">Radley</option><option value="Raleway">Raleway</option><option value="Raleway Dots">Raleway Dots</option><option value="Rambla">Rambla</option><option value="Rammetto One">Rammetto One</option><option value="Ranchers">Ranchers</option><option value="Rancho">Rancho</option><option value="Rationale">Rationale</option><option value="Redressed">Redressed</option><option value="Reenie Beanie">Reenie Beanie</option><option value="Revalia">Revalia</option><option value="Ribeye">Ribeye</option><option value="Ribeye Marrow">Ribeye Marrow</option><option value="Righteous">Righteous</option><option value="Risque">Risque</option><option value="Roboto">Roboto</option><option value="Roboto Condensed">Roboto Condensed</option><option value="Rochester">Rochester</option><option value="Rock Salt">Rock Salt</option><option value="Rokkitt">Rokkitt</option><option value="Romanesco">Romanesco</option><option value="Ropa Sans">Ropa Sans</option><option value="Rosario">Rosario</option><option value="Rosarivo">Rosarivo</option><option value="Rouge Script">Rouge Script</option><option value="Ruda">Ruda</option><option value="Rufina">Rufina</option><option value="Ruge Boogie">Ruge Boogie</option><option value="Ruluko">Ruluko</option><option value="Rum Raisin">Rum Raisin</option><option value="Ruslan Display">Ruslan Display</option><option value="Russo One">Russo One</option><option value="Ruthie">Ruthie</option><option value="Rye">Rye</option><option value="Sacramento">Sacramento</option><option value="Sail">Sail</option><option value="Salsa">Salsa</option><option value="Sanchez">Sanchez</option><option value="Sancreek">Sancreek</option><option value="Sansita One">Sansita One</option><option value="Sarina">Sarina</option><option value="Satisfy">Satisfy</option><option value="Scada">Scada</option><option value="Schoolbell">Schoolbell</option><option value="Seaweed Script">Seaweed Script</option><option value="Sevillana">Sevillana</option><option value="Seymour One">Seymour One</option><option value="Shadows Into Light">Shadows Into Light</option><option value="Shadows Into Light Two">Shadows Into Light Two</option><option value="Shanti">Shanti</option><option value="Share">Share</option><option value="Share Tech">Share Tech</option><option value="Share Tech Mono">Share Tech Mono</option><option value="Shojumaru">Shojumaru</option><option value="Short Stack">Short Stack</option><option value="Siemreap">Siemreap</option><option value="Sigmar One">Sigmar One</option><option value="Signika">Signika</option><option value="Signika Negative">Signika Negative</option><option value="Simonetta">Simonetta</option><option value="Sintony">Sintony</option><option value="Sirin Stencil">Sirin Stencil</option><option value="Six Caps">Six Caps</option><option value="Skranji">Skranji</option><option value="Slackey">Slackey</option><option value="Smokum">Smokum</option><option value="Smythe">Smythe</option><option value="Sniglet">Sniglet</option><option value="Snippet">Snippet</option><option value="Snowburst One">Snowburst One</option><option value="Sofadi One">Sofadi One</option><option value="Sofia">Sofia</option><option value="Sonsie One">Sonsie One</option><option value="Sorts Mill Goudy">Sorts Mill Goudy</option><option value="Source Code Pro">Source Code Pro</option><option value="Source Sans Pro">Source Sans Pro</option><option value="Special Elite">Special Elite</option><option value="Spicy Rice">Spicy Rice</option><option value="Spinnaker">Spinnaker</option><option value="Spirax">Spirax</option><option value="Squada One">Squada One</option><option value="Stalemate">Stalemate</option><option value="Stalinist One">Stalinist One</option><option value="Stardos Stencil">Stardos Stencil</option><option value="Stint Ultra Condensed">Stint Ultra Condensed</option><option value="Stint Ultra Expanded">Stint Ultra Expanded</option><option value="Stoke">Stoke</option><option value="Strait">Strait</option><option value="Sue Ellen Francisco">Sue Ellen Francisco</option><option value="Sunshiney">Sunshiney</option><option value="Supermercado One">Supermercado One</option><option value="Suwannaphum">Suwannaphum</option><option value="Swanky and Moo Moo">Swanky and Moo Moo</option><option value="Syncopate">Syncopate</option><option value="Tangerine">Tangerine</option><option value="Taprom">Taprom</option><option value="Tauri">Tauri</option><option value="Telex">Telex</option><option value="Tenor Sans">Tenor Sans</option><option value="Text Me One">Text Me One</option><option value="The Girl Next Door">The Girl Next Door</option><option value="Tienne">Tienne</option><option value="Tinos">Tinos</option><option value="Titan One">Titan One</option><option value="Titillium Web">Titillium Web</option><option value="Trade Winds">Trade Winds</option><option value="Trocchi">Trocchi</option><option value="Trochut">Trochut</option><option value="Trykker">Trykker</option><option value="Tulpen One">Tulpen One</option><option value="Ubuntu">Ubuntu</option><option value="Ubuntu Condensed">Ubuntu Condensed</option><option value="Ubuntu Mono">Ubuntu Mono</option><option value="Ultra">Ultra</option><option value="Uncial Antiqua">Uncial Antiqua</option><option value="Underdog">Underdog</option><option value="Unica One">Unica One</option><option value="UnifrakturCook">UnifrakturCook</option><option value="UnifrakturMaguntia">UnifrakturMaguntia</option><option value="Unkempt">Unkempt</option><option value="Unlock">Unlock</option><option value="Unna">Unna</option><option value="VT323">VT323</option><option value="Vampiro One">Vampiro One</option><option value="Varela">Varela</option><option value="Varela Round">Varela Round</option><option value="Vast Shadow">Vast Shadow</option><option value="Vibur">Vibur</option><option value="Vidaloka">Vidaloka</option><option value="Viga">Viga</option><option value="Voces">Voces</option><option value="Volkhov">Volkhov</option><option value="Vollkorn">Vollkorn</option><option value="Voltaire">Voltaire</option><option value="Waiting for the Sunrise">Waiting for the Sunrise</option><option value="Wallpoet">Wallpoet</option><option value="Walter Turncoat">Walter Turncoat</option><option value="Warnes">Warnes</option><option value="Wellfleet">Wellfleet</option><option value="Wendy One">Wendy One</option><option value="Wire One">Wire One</option><option value="Yanone Kaffeesatz">Yanone Kaffeesatz</option><option value="Yellowtail">Yellowtail</option><option value="Yeseva One">Yeseva One</option><option value="Yesteryear">Yesteryear</option><option value="Zeyada">Zeyada</option>
				</select>
				<br /><em>Select the font.</em>
			</div>
			<div class="ulp-layer-property" style="width: 270px;">
				<label>Font color</label>
				<input type="text" class="ulp-color ic_input_number" id="ulp_layer_font_color" name="ulp_layer_font_color" value="" placeholder="">
				<br /><em>Set the font color.</em>
			</div>
			<div class="ulp-layer-property" style="width: 25%;">
				<label>Font size</label>
				<input type="text" id="ulp_layer_font_size" name="ulp_layer_font_size" value="" class="ic_input_number" placeholder="Font size"> pixels
				<br /><em>Set the font size. The value must be in a range [10...64].</em>
			</div>
			<div class="ulp-layer-property" style="width: 25%;">
				<label>Font weight</label>
				<select class="ic_input_s" id="ulp_layer_font_weight" name="ulp_layer_font_weight">
					<option value="100">100 - Thin</option>
					<option value="200">200 - Extra-light</option>
					<option value="300">300 - Light</option>
					<option value="400">400 - Normal</option>
					<option value="500">500 - Medium</option>
					<option value="600">600 - Demi-bold</option>
					<option value="700">700 - Bold</option>
					<option value="800">800 - Heavy</option>
					<option value="900">900 - Black</option>
				</select>
				<br /><em>Select the font weight. Some fonts may not support selected font weight.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property" style="width: 200px;">
				<label>Text shadow size</label>
				<input type="text" id="ulp_layer_text_shadow_size" name="ulp_layer_text_shadow_size" value="" class="ic_input_number" placeholder="Shadow size"> pixels
				<br /><em>Set the text shadow size.</em>
			</div>
			<div class="ulp-layer-property" style="width: 270px;">
				<label>Text shadow color</label>
				<input type="text" class="ulp-color ic_input_number" id="ulp_layer_text_shadow_color" name="ulp_layer_text_shadow_color" value="" placeholder="">
				<br /><em>Set the text shadow color.</em>
			</div>
			<div class="ulp-layer-property">
				<label>Custom style</label>
				<input type="text" id="ulp_layer_style" name="ulp_layer_style" value="" class="widefat" placeholder="Enter the custom style string...">
				<br /><em>Enter the custom style string. This value is added to layer <code>style</code> attribute.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property">
				<input type="checkbox" id="ulp_layer_confirmation_layer" name="ulp_layer_confirmation_layer"> "Confirmation of subscription" layer
				<br /><em>This layer appears only on successful submitting of subscription/contact form.</em>
			</div>
			<div class="ulp-layer-property">
				<input type="checkbox" id="ulp_layer_inline_disable" name="ulp_layer_inline_disable"> Disable for inline mode
				<br /><em>This layer appears only in popup mode and disabled for inline mode.</em>
			</div>
			<div class="ulp-layer-property">
				<input type="checkbox" id="ulp_layer_scrollbar" name="ulp_layer_scrollbar"> Add scrollbar
				<br /><em>Add scrollbar to the layer. Layer height must be set.</em>
			</div>
		</div>
		<div class="ulp-layer-row">
			<div class="ulp-layer-property">
				<input type="hidden" name="action" value="save-layer">
				<input type="hidden" name="ulp_layer_id" value="0">
				<input type="hidden" name="ulp_popup_id" value="{$id}">
				<input type="button" class="submit button" name="submit" value="Save Layer" onclick="return ulp_save_layer();">
				<img class="ulp-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
			</div>
			<div class="ulp-layer-property" style="text-align: right;">
				<input type="button" class="submit button" name="submit" value="Cancel" onclick="return ulp_cancel_layer(this);">
			</div>
		</div>
		<div class="ulp-message"></div>
	</div>
</div>
		