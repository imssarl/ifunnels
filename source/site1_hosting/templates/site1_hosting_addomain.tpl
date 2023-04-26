<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div style="padding: 50px;">
{if !empty($smarty.get.close)}
	<script type="text/javascript">
		window.addEvent('domready',function(){
			window.parent.location.reload();
			window.parent.popup.boxWindow.close();
		});
	</script>
{else}
{if $smarty.get.flg_type==1||$smarty.get.flg_type==4}
{* Local hosting *}
<form action="./?flg_type=1" class="validate" method="post">
	{include file='../../error.tpl'}
	<div class="notification error png_bg" style="display: none;">
		<div id="js-errors" class="red"></div>
	</div>
	<input type="hidden" name="arrData[flg_type]" value="{$smarty.get.flg_type}"/>
	<fieldset>
		<legend>Add {if isset( $smarty.get.subdomain ) && !empty( $smarty.get.subdomain )}sub{/if}domain</legend>
		<div class="form-group">
		{if !isset( $smarty.get.subdomain ) || empty( $smarty.get.subdomain )}
			<label></label>
			<div class="radio radio-primary">
				<input type="radio" name="arrData[flg_type]" {if $arrData.flg_type==Project_Placement::LOCAL_HOSTING_DOMEN}checked="1"{/if} value="{Project_Placement::LOCAL_HOSTING_DOMEN}" class="select-type" />
				<label>Register and Host a new domain <a class="tooltip" href="" title="We will register a domain of your choice and host it on our Cloud servers">?</a></label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrData[flg_type]" {if $arrData.flg_type==Project_Placement::LOCAL_HOSTING}checked="1"{/if} value="{Project_Placement::LOCAL_HOSTING}" class="select-type" />
				<label>Host one of your existing domain <a class="tooltip" href="" title="We will create a hosting account for your domain on our Cloud servers">?</a></label>
			</div>
			{if !( Core_Acs::haveAccess( array( 'Studio Free' ) ) && !( Core_Acs::haveAccess( array( 'iFunnels Studio Starter' ) ) || Core_Acs::haveAccess( array( 'iFunnels LTD Studio Starter' ) ) || Core_Acs::haveAccess( array( 'iFunnels Studio Elite' ) ) ) )}
			<div class="radio radio-primary">
				<input {if $arrIfunnel!==false && !in_array(Core_Users::$info['id'], array(100010826, 1, 100010872))}disabled{/if} type="radio" name="arrData[flg_type]" {if $arrData.flg_type==Project_Placement::IFUNELS_HOSTING}checked="1"{/if} value="{Project_Placement::IFUNELS_HOSTING}" class="select-type" />
				<label>Create subdomain in ifunnels.com <a class="tooltip" href="" title="We will create a create subdomains (like: jpschoeffel.ifunnels.com for hosting landing pages)">?</a></label>
			</div>
			{/if}
		</div>
		<div style="display: {if !empty($arrData.domain_http)}block{else}none{/if};" id="check-domain">
		{else}
		<input type="hidden" name="arrData[parent_domain_id]" value="{$smarty.get.subdomain}" id="parent_domain_id" />
		<input type="hidden" name="arrData[flg_type]" value="{Project_Placement::LOCAL_HOSTING_SUBDOMEN}" class="select-type" checked="1" />
		{/if}
			<div class="form-group">
				<label class="no_sub" style="display: {if $arrData.flg_type==Project_Placement::IFUNELS_HOSTING || isset( $smarty.get.subdomain)}none{else}block{/if};">Domain <em>*</em></label>
				<label class="sub_domain" style="display: {if $arrData.flg_type==Project_Placement::IFUNELS_HOSTING || isset( $smarty.get.subdomain)}block{else}none{/if};">Sub Domain Name<em>*</em></label>
				<input type="text"  name="arrData[domain_http]" pattern="{if $arrData.flg_type==Project_Placement::IFUNELS_HOSTING || isset( $smarty.get.subdomain)}^[a-z0-9_-]+${else}^[a-z0-9_.-]+${/if}" value="{$arrData.domain_http}" id="domain" class="required form-control"/><span id="message"></span>
				<small class="no_sub" style="display: {if $arrData.flg_type==Project_Placement::IFUNELS_HOSTING || $arrData.flg_type==Project_Placement::LOCAL_HOSTING || isset( $smarty.get.subdomain)}none{else}block{/if};"><br/>Only <b>.com</b>, <b>.info</b>, <b>.org</b>, <b>.net</b>, <b>.biz</b>, <b>.us</b> domain names can be purchased.</small>
				<small class="sub_domain" style="display: {if $arrData.flg_type==Project_Placement::IFUNELS_HOSTING || isset( $smarty.get.subdomain)}block{else}none{/if};"><br/>Only letters and numbers.</small>
			</div>
			<div id="auto-renew" style="display: {if $arrData.flg_type==Project_Placement::LOCAL_HOSTING_DOMEN}block{else}none{/if};">
				<input type="hidden" value="0" name="arrData[flg_auto]" />
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arrData[flg_auto]" {if $arrData.flg_auto==1||!isset($arrData.flg_auto)}checked="1"{/if} value="1" />
					<label>Automatic Renewal </label>
				</div>
			</div>
			<p id="dns-block" style="display: none;">
				<label></label><p id="dns" class="helper"></p>
			</p>
			<p>
				<button type="button" class="button btn btn-success waves-effect waves-light" id="check" {is_acs_write}>Check</button>
			</p>
		</div>
	</fieldset>
	<div class="clear"></div>
</form>
{literal}
<script type="text/javascript">
	Array.prototype.in_array = function(p_val) {
		for(var i = 0, l = this.length; i < l; i++)	{
			if(this[i] == p_val) {
				return true;
			}
		}
		return false;
	}
	Form.Validator.add('tld', {
		errorMsg: 'Only .com, .info, .org, .net, .biz, .us domain names can be purchased.',
		test: function(element){
			return (element.value.test('.com')
					||element.value.test('.info')
					||element.value.test('.net')
					||element.value.test('.biz')
					||element.value.test('.us')
					||element.value.test('.org'));
		}
	});
	window.addEvent('domready',function(){
		$$('.select-type').addEvent('click',function(e){
			$('check-domain').setStyle('display','block');
			$('check').setStyle('display','block');
			$$('.no_sub').setStyle('display','block');
			$$('.sub_domain').setStyle('display','none');
			$('message').set('html', '');
			$('domain').set('pattern', '^[a-zA-Z0-9_\-.]+$');
			$('dns-block').setStyle('display','none');
			$('js-errors').set('html', '');
			$$('.notification').setStyle('display','none');
			if( $('add-button') ){
				$('add-button').destroy();
			}
			if( this.value=={/literal}{Project_Placement::LOCAL_HOSTING_DOMEN}{literal} ){
				$('auto-renew').setStyle('display','block');
				$$('.helpers').setStyle('display','block');
				$('check-domain').setStyle('display','block');
				$('check').setStyle('display','block');
				$('domain').addClass('tld');
			} else if( this.value=={/literal}{Project_Placement::LOCAL_HOSTING}{literal} ){
				$('auto-renew').setStyle('display','none');
				$$('.helpers').setStyle('display','none');
				$$('.no_sub').setStyle('display','none');
				$('check-domain').setStyle('display','block');
				$('check').setStyle('display','block');
				$('domain').removeClass('tld');
			} else {
				$('auto-renew').setStyle('display','none');
				$$('.helpers').setStyle('display','none');
				$$('.no_sub').setStyle('display','none');
				$$('.sub_domain').setStyle('display','block');
				$('domain').set('pattern', '^[a-zA-Z0-9-_]+$');
				$('domain').removeClass('tld');
			}
		});
		if( $('domain').length > 0 ){
			$('domain').addEvent('keyup',function(e){
				e.stop();
				$('check-domain').setStyle('display','block');
				$('check').setStyle('display','none');
				$('message').set('html', '');
				$('dns-block').setStyle('display','none');
				$('js-errors').set('html', '');
				$$('.notification').setStyle('display','none');
				if( $('add-button') ){
					$('add-button').destroy();
				}
				var re = new RegExp(this.get('pattern'));
				if( re.test(this.value) ){
					$('check').setStyle('display','block');
				}
			});
		}
		$('check').addEvent('click',function(e){
			e.stop();
			$('message').setStyle('color','black');
			$('message').set('html', '');
			$('js-errors').set('html', '');
			$$('.notification').setStyle('display','none');
			if(!validator.checker.validate()){
				return;
			}
			$('message').set('html',' Please wait...');
			var flg_type=0;
			$$('.select-type').each(function(el){
				if( el.checked ){
					flg_type=el.get('value');
				}
			});
			var parent_id=false;
			if( $('parent_domain_id') != null ){
				parent_id=$('parent_domain_id').get('value');
			}
			var req=new Request.JSON({
				url:'{/literal}{url name='site1_hosting' action='checkdomain'}{literal}',
				onSuccess: function( r ){
					$('domain').set('disabled', false);
					if( r.flg_checked==true ){
						$('dns-block').setStyle('display','none');
						var parent=$('check').getParent();
						$('check').setStyle('display','none');
						var button=new Element('input',{type:'submit',value:'Add domain',id:'add-button',class:'button btn btn-success waves-effect waves-light'}).addEvent('click',function(e){$('domain').set('disabled', false);}).inject( parent );
						$('domain').set('disabled', true);
						$('add-button').addEvent('click',function(e){
							$('add-button').setStyle('display','none');
							new Element('span',{html:'Please wait...'}).inject( parent );
						});
						$('message').set('html',' Available');
						$('message').setStyle('color','green');
						if( r.dns1&&r.dns2 ){
							$('dns-block').setStyle('display','block');
							$('dns').set('html', 'To get started, change the DNS for this domain at your registrar. If you don\'t know how to do it, please contact them and tell them to update your DNS to the following:<br/>DNS1: <b>'+r.dns1 + '</b><br/> DNS2: <b>' + r.dns2 +'</b>' );
						}
					} else {
						$('dns-block').setStyle('display','none');
						$('message').set('html',' Not Available');
						$('message').setStyle('color','red');
						$('check').set('disabled',false);
						if( r.error ){
							var errors='Errors: <br/>';
							Object.each(r.error.errFlow,function(error){
								errors+=' - '+error+'<br/>';
							});
							$('js-errors').set('html', errors);
							$$('.notification').setStyle('display','block');
						}

					}
				}
			}).post({'domain':$('domain').get('value'),'parent_domain_id':parent_id,'flg_type':flg_type});
		});
	});
</script>
{/literal}
{else}
{* Externally *}
<form action="./?flg_type=0" class="wh validate"  method="post">
	{include file='../../error.tpl' fields=['domain_ftp'=>'FTP Address','username'=>'FTP Username','password'=>'FTP Password']}
	<input type="hidden" name="arrData[flg_type]" value="{Project_Placement::REMOTE_HOSTING}"/>
	{if !empty($arrData)}
	<input type="hidden" value="{$arrData.id}" name="arrData[id]" />
	{/if}
	<fieldset>
		<legend>{if empty($arrData.id)}Add{else}Edit{/if} ftp settings</legend>
			<div class="form-group">
				<label>FTP Address <em>*</em></label>
				<input type="text" name="arrData[domain_ftp]" class="required form-control" value="{$arrData.domain_ftp}" />
			</div>
			<div class="form-group">
				<label>FTP Username <em>*</em></label>
				<input type="text" name="arrData[username]" class="required form-control"  value="{$arrData.username}" />
			</div>
			<div class="form-group">
				<label>FTP Password <em>*</em></label>
				<input type="text" name="arrData[password]" class="required form-control"  value="{$arrData.password}" />
			</div>
			<div class="form-group">
				<button type="submit" class="button btn btn-success waves-effect waves-light" {is_acs_write}>{if !empty($arrData.id)}Save{else}Add{/if}</button>
			</div>
	</fieldset>
</form>
{/if}
{/if}
</div>
</body>
</html>