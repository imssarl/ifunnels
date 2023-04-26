<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
	<link rel="stylesheet" href="/skin/_css/new/site1.css" type="text/css" media="screen" />
	<link href="/usersdata/exquisite_popups/css/admin.css" rel="stylesheet" type="text/css">
	<script src="/usersdata/exquisite_popups/js/jquery-1.10.2.min.js"></script>
	<script src="/usersdata/exquisite_popups/js/base64.js"></script>
</head>
<body id="main-content">
	<br/>
	<form>
		<input type="hidden" name="id" value="{$popup_details.str_id}">
		<table width="90%" align="center" class="ulp_useroptions">
			<tr>
				<th>Select where popup be displayed: </th>
				<td>
					<input type="radio" name="display_mode" value="inline"{if !isset($popup_options.display_mode) || $popup_options.display_mode == "inline"} checked="checked"{/if} /> Inline (displayed in your webpage, NOT as a popup)<br />
					<input type="radio" name="display_mode" value="onaction"{if $popup_options.display_mode == "onaction"} checked="checked"{/if} /> Triggered by a click on a link or button<br />
					<input type="radio" name="display_mode" value="onload"{if $popup_options.display_mode == "onload"} checked="checked"{/if} /> On page load<br />
					<input type="radio" name="display_mode" value="onexit"{if $popup_options.display_mode == "onexit"} checked="checked"{/if} /> On exit intent<br />
					<input type="radio" name="display_mode" value="onscroll"{if $popup_options.display_mode == "onscroll"} checked="checked"{/if} /> On scrolling down<br />
				</td>
			</tr>
			<tr class="flg_mode flg_mode_onload flg_mode_onexit flg_mode_onscroll"{if !isset($popup_options.display_mode) || $popup_options.display_mode == "inline" || $popup_options.display_mode == "onaction" } style="display:none;"{/if}>
				<th>Display mode: </th>
				<td style="line-height: 1.6;">
					<input type="radio" name="load_mode" value="every-time"{if !isset($popup_options.load_mode) ||$popup_options.load_mode == "every-time"} checked="checked"{/if}> Every time<br />
					<input type="radio" name="load_mode" value="once-session"{if $popup_options.load_mode == "once-session"} checked="checked"{/if}> Once per session<br />
					<input type="radio" name="load_mode" value="once-only"{if $popup_options.load_mode == "once-only"} checked="checked"{/if}> Only once<br />
					<em>Select popup display mode.</em>
				</td>
			</tr>
			<tr class="flg_mode flg_mode_onload"{if $popup_options.display_mode != "onload"} style="display:none;"{/if}>
				<th>Start delay: </th>
				<td style="vertical-align: middle;">
					<input type="text" name="onload_delay" value="{$popup_options.onload_delay}" class="ic_input_number" placeholder="Delay"> seconds
					<br /><em>Popup appears with this delay after page loaded. Set "0" for immediate start.</em>
				</td>
			</tr>
			<tr class="flg_mode flg_mode_onexit"{if $popup_options.display_mode != "onexit"} style="display:none;"{/if}>
				<th></th>
				<td>
					<input type="checkbox" id="onexit_limits" name="onexit_limits"{if $popup_options.onexit_limits ==  "on"} checked="checked"{/if}> Disable OnExit popup if user subscribed through another OnLoad or inline form
					<br /><em>Disable OnExit popup if user subscribed through another OnLoad or inline form.</em>
				</td>
			</tr>
			<tr class="flg_mode flg_mode_onscroll"{if $popup_options['display_mode'] != "onscroll"} style="display:none;"{/if}>
				<th>Scrolling offset:</th>
				<td style="vertical-align: middle;">
					<input type="text" name="onscroll_offset" value="{$popup_options.onscroll_offset}" class="ic_input_number" placeholder="Pixels"> pixels
					<br /><em>Popup appears when user scroll down to this number of pixels.</em>
				</td>
			</tr>
			<tr>
				<th>Get Code:</th>
				<td align="center" style="line-height:20px;">
					<div class="flg_mode flg_mode_onaction"{if $popup_options.display_mode != "onaction"} style="display:none;"{/if}>
					To raise popup by clicking certain element, add the following <code>onclick</code> handler to the element:
					<br><code>onclick="return open('{$popup_details.str_id}');"</code>
					<br>Example: <code>&lt;a href="#" onclick="return open('{$popup_details.str_id}');"&gt;Raise the popup&lt;/a&gt;</code>
					</div>
					<div class="flg_mode flg_mode_onload flg_mode_onexit flg_mode_onscroll"{if !isset($popup_options.display_mode) || $popup_options.display_mode == "inline" || $popup_options.display_mode == "onaction" } style="display:none;"{/if}>
					Add the following code to raise a popup on certain page:
					</div>
					<div class="flg_mode flg_mode_inline"{if $popup_options.display_mode != "inline"} style="display:none;"{/if}>
					To raise a popup "inline" insert the following shortcode into post/page content:
					</div>
				</td>
			</tr>
			<tr>
				<th colspan="2" align="center" style="line-height:20px;">
				<code>&lt;script type="text/javascript" src="{Zend_Registry::get( 'config' )->domain->url}/usersdata/exquisite_popups/js/ulp-jsonp.js" class="exquisite_popup" data-id="<span id="base64_code"></span>"&gt;&lt;/script&gt;</code>
				</th>
			</tr>
		</table>
	</form>
	<script>{literal}
	jQuery(document).ready(function(){
		jQuery('input[name="display_mode"]').bind("click", function() {
			jQuery(".flg_mode").hide();
			jQuery(".flg_mode_"+jQuery(this).val()).show();
		});
		var updateGetcode=function(){
			jQuery('#base64_code').html( jQuery.base64.encode( $('form').serialize() ) );
			//console.log( jQuery.base64.encode( $('form').serialize() ) );
		}
		jQuery('input').bind("change", function() {
			updateGetcode();
		});
		jQuery('input').bind("keyup", function() {
			updateGetcode();
		});
		updateGetcode();
	});
	{/literal}</script>
</body>
</html>