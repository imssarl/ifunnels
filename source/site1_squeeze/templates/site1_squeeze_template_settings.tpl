<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
{if $save_action==true}<script>window.parent.multibox.boxWindow.close();</script>{/if}
	<div class="card-box">
		<form method="post" class="wh" action="{Core_Module_Router::$uriFull}">
			<div class="form-group">
				<h3 id="title">Offer Type:</h3>
				<div class="checkbox">
					<input type="checkbox" name="settings[flg_optin]" id="flg_optin" value="1"{if isset($template.settings.type_page) && $template.settings.type_page==2} checked{/if} disabled />
					<label for="flg_optin">Optin</label>
				</div>
				<div class="checkbox">
					<input type="checkbox" name="settings[flg_redirect]" id="flg_redirect" value="1"{if isset($template.settings.type_page) && $template.settings.type_page==1} checked{/if} disabled />
					<label for="flg_redirect">Redirect</label>
				</div>
				<div class="checkbox">
					<input type="checkbox" name="settings[flg_messanger]" id="flg_messanger" value="1"{if isset($template.settings.type_page) && $template.settings.type_page==3} checked{/if} disabled />
					<label for="flg_messanger">Messenger</label>
				</div>
			</div>
			<div class="form-group">
				<div class="form-group">
					<label class="control-label">Template Description: </label>
					<textarea name="settings[template_description]" class="form-control">{$template.settings.template_description}</textarea>
				</div>
			</div>
			<div class="form-group">
				<h3 id="title">Network:</h3>
				<select name="settings[network]" class="form-control">
					<option value="Warrior_Plus"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Warrior_Plus"} selected{/if}>Warrior Plus</option>
					<option value="Jvzoo"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Jvzoo"} selected{/if}>Jvzoo</option>
					<option value="Clickbank"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Clickbank"} selected{/if}>Clickbank</option>
					<option value="PaykickStart"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="PaykickStart"} selected{/if}>PaykickStart</option>
					<option value="Zaxaa"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Zaxaa"} selected{/if}>Zaxaa</option>
					<option value="ThriveCart"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="ThriveCart"} selected{/if}>ThriveCart</option>
					<option value="JVShare"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="JVShare"} selected{/if}>JVShare</option>
					<option value="Paydtotcom"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Paydtotcom"} selected{/if}>Paydtotcom</option>
					<option value="Clickfunnels"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Clickfunnels"} selected{/if}>Clickfunnels</option>
					
					<option value="Other"{if isset($template.tpl_settings.network) && $template.tpl_settings.network=="Other"} selected{/if}>Other</option>
				</select>
			</div>
			<div class="form-group">
				<h3 id="title">Offer Link:</h3>
				<input type="text" name="settings[offer_link]" class="form-control" value="{if isset($template.tpl_settings.offer_link)}{$template.tpl_settings.offer_link}{/if}" />
			</div>
			<div class="form-group">
				<h3 id="title">Affiliate Link:</h3>
				<input type="text" name="settings[affiliate_link]" class="form-control" value="{if isset($template.tpl_settings.affiliate_link)}{$template.tpl_settings.affiliate_link}{/if}" />
				<small>Note: link for Jvzoo is  https://jvz7.com/%JVZOOID%/12345</small>
				<small>Note: link for Warrior Plus is  https://warriorplus.com/%warrior_plusID%/12345</small>
			</div>
			<div class="form-group">
				<h3 id="title">Require Application:</h3>
				<div class="checkbox">
					<input type="hidden" name="settings[flg_require]" value="0" />
					<input type="checkbox" id="btn_flg_require" class="btn_flg_require" rel="{$template.id}" name="settings[flg_require]" value="1"{if isset($template.tpl_settings.flg_require) && $template.tpl_settings.flg_require==1} checked{/if} />
					<label for="btn_flg_require">Require Application</label>
				</div>
			</div>
			<div class="flg_require_box_{$template.id}"{if isset($template.tpl_settings.flg_require) && $template.tpl_settings.flg_require==1}{else} style="display:none;"{/if}>
				<h3 id="title">Offer Application:</h3>
				<input type="text" name="settings[offer_application]" class="form-control" value="{if isset($template.tpl_settings.offer_application)}{$template.tpl_settings.offer_application}{/if}" />
			</div>
			<div class="form-group">
				<h3 id="title">Additional Information:</h3>
				<textarea type="text" class="form-control" name="settings[info]">{if isset($template.tpl_settings.info)}{$template.tpl_settings.info}{/if}</textarea>
			</div>
			<div class="form-group">
				<input type="submit" class="btn btn-success waves-effect waves-light" id="close_popup" value="Save" />
			</div>
		</form>
	</div>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	$$('.btn_flg_require').addEvent('change',function( elt ){
		if( elt.target.checked ){
			$$('.flg_require_box_'+elt.target.get('rel')).show();
		}else{
			$$('.flg_require_box_'+elt.target.get('rel')).hide();
		}
	});
});
</script>
{/literal}
</body>
</html>