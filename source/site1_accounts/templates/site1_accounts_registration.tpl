{if $congratulations}
Congratulations! Your account has been created. You will now receive a confirmation email with the link to activate your account.
{else}
<style type="text/css">
	body,html{ background: url(/skin/i/frontends/design/registration/bg2.jpg) left top repeat;}
	#block{ position: absolute; display: none; width:99%; height: 98%; opacity: 0.6; background: url(/skin/i/frontends/design/ajax-loader-w.gif) center center no-repeat #FFFFFF; }
</style>
<div id="block"></div>
<div align="center" class="reg-block-main">
	<div class="reg-form-block">
		<div class="in">
			<form class="wh reg_form validate" action="" method="post" id="submit_form"  >
				<input type="hidden" name="arrReg[flg_new]" value="{$arrReg.flg_new|default:0}" id="flg_new"  />
			<fieldset style="border: 0 solid #fff">
				<h1>{foreach $arrList as $v}{if $v.id==$special_offer}{$v.title}{/if}{/foreach}</h1>
				{foreach $arrList as $v}{if $v.id==$special_offer && $v.cost!=0}<div class="reg-steps">&nbsp;</div>{/if}{/foreach}
				{if $arrErr}
				<div id="message" class="message">
					<font color='red'>
						{if $strError!=''}
						<div class="red">Error: {$strError}</div>
						{/if}
					</font>
				</div>
				{/if}
				{if $forgotmessage}
				<div class="message-blue" >
					Letter was sended.
				</div>
				{/if}
				<div id="check-message" class="message-blue" style="display: none;">
					Your password will be sent to this email address after checkout is completed. Please agree to Terms and Conditions and proceed to Step 2.
				</div>
				<div id="exist-message" class="message-blue"  style="display: none;">
					Proceed to Step 2.
				</div>
				<div class="message-blue" id="start-message" style=" border: none !important;">
					To get started, please enter your email.
				</div>
				<input type="hidden" value="{$special_offer}" name="arrReg[package_id]" />
				<ol id='forgot-form' style="display: none;">
					<li>
						<label>Email:</label>
						<div class="reg-border-item"><input name="arrForgot[email]" type="text" id='forgot-email' /></div>
					</li>
					<li>
						<div align="right" class="reg-submit-block" ><input type="submit" class="submit" name="forgot" id="get-pass" value="Send" /></div>
					</li>
				</ol>
				<ol  id='reggi-form'>
					<li>
						<label>Email:&nbsp;<em>*</em></label>
						<div class="reg-border-item"><input name="arrReg[email]" type="text" id="email-login" class="required validate-email {if $arrErr.email}error{/if}" value="{$arrReg.email}"/></div>&nbsp;<img style="display: none;" src="/skin/i/frontends/design/ajax_loader_line.gif" id="ajax-loader" />
					</li>
					<div id="filds-registration" style="display: block;">
					<li>
						<center><legend><input name="arrReg[i_agree]" type="checkbox" class="required  {if $arrErr.i_agree}error{/if}" />&nbsp;I agree to
						<a style="cursor:pointer" rel="" href="{url name='site1_accounts' action='terms'}" class="popup" title="View terms">terms and conditions</a>&nbsp;<em>*</em></legend></center>
					</li>
					</div>
					<input type="hidden" value="0" id="checked" />
					<li>
						<div align="right" class="reg-submit-block" ><input type="submit" class="submit" id="submit_box" value="Submit" /></div>
					</li>
				</ol>
			</fieldset>
{*
			{foreach $arrList as $v}
			<div class="tariff_box" rel="{$v.id}" align="left"{if $arrReg.package_id!=$v.id} style="display:none;width: 300px;"{/if}>
				<h1>{$v.title}</h1>
				<div>{$v.description}</div>
				<div>Price: ${$v.cost}</div>
			</div>
			{/foreach}*}

			</form>
		</div>
	</div>
</div>
{literal}
<script type="text/javascript">
var package_id='{/literal}{if isset($smarty.get.package_id)}{$smarty.get.package_id}{elseif isset($arrReg.package_id)}{$arrReg.package_id}{/if}{literal}';
var popup={};
window.addEvent('domready',function() {
	popup=new CeraBox( $$('.popup'), {
		group: false,
		width:'80%',
		height:'80%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	var req=new Request.JSON({
		url:'{/literal}{url name='site1_accounts' action='check'}{literal}',
		onSuccess: function(res){
			$('start-message').setStyle('display','none');
			$('block').setStyle('display','none');
			$('submit_box').set('disabled',false);
			$('checked').set('value',1);
			if( res.email!=true ){ // new account
				$('check-message').setStyle('display','block');
				$('exist-message').setStyle('display','none');
				$('flg_new').set('value',1);
				$('filds-registration').setStyle('display','block');
			} else { // account exist
				$('check-message').setStyle('display','none');
				$('exist-message').setStyle('display','block');
				$('flg_new').set('value',0);
				$('filds-registration').setStyle('display','none');
			}

		},
		onRequest: function(){
			$('block').setStyle('display','block');
		}
	});
	$('email-login').addEvent('blur',function(e){
		if( $('email-login').get('value')!=''&&$('checked').get('value')==0 ){
			req.post({email:$('email-login').get('value')});
		}
	});
	$('email-login').addEvent('keypress',function(e){
		$('checked').set('value',0);
	});
	$('submit_box').addEvent('mouseover',function(e){
		if( $('email-login').get('value')!=''&&$('checked').get('value')==0 ){
			req.post({email:$('email-login').get('value')});
		}
	});
});
</script>
{/literal}
{/if}