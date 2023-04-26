{if $strError}{include file='../../message.tpl' type='error' message=$strError}{/if}
{if $congratulations}{include file='../../message.tpl' type='success' message='Profile is saved'}{/if}

{include file='../../error.tpl' fields=['buyer_phone'=>'Phone']}
{include file='../../box-top.tpl' title=$arrNest.title}

<link rel="stylesheet" href="/skin/light/plugins/lada/ladda.min.css" />
<script src="/skin/light/plugins/lada/spin.min.js"></script>
<script src="/skin/light/plugins/lada/ladda.min.js"></script>

<div class="card-box">
<div class="tab-content default-tab">
	<form method="post" action="" class="validate">
	<input name="arrReg[id]" type="hidden" value="{$arrReg.id}"/>
	<input name="arrReg[email]" type="hidden" value="{$arrReg.email}"/>
		<fieldset>
			{if Core_Acs::haveRight( ['ccs'=>['facebook']] )}
			<div class="form-group">
				<label>Connect with Facebook</label>
				<button class="ladda-button connect" data-style="expand-right" data-color="blue">
					<span class="ladda-label">{if !empty($arrReg.fb_user_id) && isset($arrReg.settings.facebook) && is_array( $arrReg.settings.facebook )}{$arrReg.settings.facebook.first_name} {$arrReg.settings.facebook.last_name}{else}Connect{/if}</span><span class="ladda-spinner"></span>
				</button>
				{if !empty( $arrReg.settings.facebook )}
				<button class="ladda-button disconnect" data-style="expand-right" data-color="blue">
					<span class="ladda-label">Disconnect</span><span class="ladda-spinner"></span>
				</button>
				{/if}
			</div>
			{/if}
			{if Core_Acs::haveAccess( array( 'email test group' ) )}
			<div class="form-group">
				<label>Plugin Activation Code</label>
				<input type="text" class="required text-input medium-input form-control" value="{implode( '-', str_split( $arrReg.passwd, 5 ))}"/>
			</div>
			{/if}
			<div class="form-group">
				<label>Name:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_name]" class="required text-input medium-input form-control" value="{$arrReg.buyer_name}"/>{if $arrErr.buyer_name}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Surname:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_surname]" class="required text-input medium-input form-control" value="{$arrReg.buyer_surname}"/>{if $arrErr.buyer_name}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Address:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_address]" class="required text-input medium-input form-control" value="{$arrReg.buyer_address}"/>{if $arrErr.buyer_address}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>City:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_city]" class="required text-input medium-input form-control" value="{$arrReg.buyer_city}"/>{if $arrErr.buyer_city}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Province:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_province]" class="required text-input medium-input form-control" value="{$arrReg.buyer_province}"/>{if $arrErr.buyer_province}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Country:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_country]" class="required text-input medium-input form-control" value="{$arrReg.buyer_country}"/>{if $arrErr.buyer_country}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Zip:&nbsp;<em>*</em></label>
				<input type="text" name="arrReg[buyer_zip]" class="required text-input medium-input form-control" value="{$arrReg.buyer_zip}"/>{if $arrErr.buyer_zip}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Phone:</label>
				<input type="text" name="arrReg[buyer_phone]" class="text-input medium-input form-control" value="{$arrReg.buyer_phone}"/>{if $arrErr.buyer_phone}<span class="input-notification error png_bg">{$strError}</span>{/if}
				<a id="verify" href="{url name='site1_accounts' action='confirmphone'}" class="popup-sidebar" style="color:red;{if $arrReg['flg_phone']!=1&&!empty($arrReg.buyer_phone)} display: inline; {else} display: none; {/if}">Verify phone number</a>
				<a id="verified" href="{url name='site1_accounts' action='calls'}" style="color:green;{if $arrReg['flg_phone']==1} display: inline; {else} display: none; {/if}">Verified successfully</a>
				<br/><small>Example:+14156586177</small>
			</div>
			<div class="form-group">
				<label>Password:</label>
				<input type="password" name="arrReg[passwd]" class="text-input medium-input form-control" value=""/>{if $arrErr.passwd}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Confirm password:</label>
				<input type="password" name="arrReg[confirm_passwd]" class="text-input medium-input form-control" value=""/>{if $arrErr.confirm_passwd}<span class="input-notification error png_bg">{$strError}</span>{/if}
			</div>
			<div class="form-group">
				<label>Timezone</label>
				<select name="arrReg[timezone]" class="small-input btn-group selectpicker show-tick">
					{foreach $arrTimezone as $v}
					<option value="{$v}"{if $arrReg.timezone==$v||(!$arrReg.timezone&&Core_Users::$info['timezone']==$v)} selected="selected"{/if}>{$v}</option>
					{/foreach}
				</select>
			</div>
			<div class="form-group">
				<button type="submit" class="button btn btn-success waves-effect waves-light">Submit</button>
			</div>
		</fieldset>
		<div class="clear"></div>
	</form>
</div>
</div>
{literal}
<script type="text/javascript">
	window.fbAsyncInit = function() {
	    FB.init({
	        appId      : '{/literal}{Project_Ccs_Facebook::$_appId}{literal}',
	        cookie     : true,
	        xfbml      : true,
	        version    : 'v2.10'
	    });
	    FB.AppEvents.logPageView();   
	};

	(function( d,s,id ){
	    var js, fjs = d.getElementsByTagName( s )[0];
	    if ( d.getElementById( id ) ) { return; }
	    js = d.createElement( s ); js.id = id;
	    js.src = "//connect.facebook.net/en_US/sdk.js";
	    fjs.parentNode.insertBefore( js,fjs );
	}( document, 'script', 'facebook-jssdk' ) );


	jQuery( document ).ready( function(){
	    jQuery( '.ladda-button.connect' ).on( 'click', function(){
	    	var l = Ladda.create( this ), self = this;
	        FB.login(function(response){
	            if (response.status === 'connected') {
	                FB.api(
	                    '/me',
	                    'GET',
	                    { 'fields' : 'id,email,first_name,last_name,picture{url}' },
	                    function(response) {
	                    	jQuery.ajax({
			            		method : 'POST',
			            		url : window.location.href,
			            		data : {
			            			request : 'ajax',
			            			arrReg : response
			            		},
			            		beforeSend : function(){
			            			l.start();
			            		},
			            	}).done( function( data ){
			            		l.stop();
			            		jQuery( self ).children( 'span.ladda-label' ).html( response.first_name + ' ' + response.last_name );

			            	} );
	                    }
	                );
	            } else {
	                console.log( 'Not loggined!' ); 
	            }
	        }, {scope: 'public_profile,email'});
	        return false;
	    } );
	    jQuery( '.ladda-button.disconnect' ).on( 'click', function(){
	    	var l = Ladda.create( this ), self = this;
	    	jQuery.ajax({
        		method : 'POST',
        		url : window.location.href,
        		data : {
        			request : 'ajax',
        			arrReg : []
        		},
        		beforeSend : function(){
        			l.start();
        		},
        	}).done( function( data ){
        		l.stop();
        		jQuery( '.ladda-button.connect' ).children( 'span.ladda-label' ).html( 'Connect' );
        		jQuery( self ).remove();
        	} );
	    	return false;
	    } );
	} );
</script>
{/literal}
{include file='../../box-bottom.tpl'}