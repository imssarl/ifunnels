<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
<style> {literal}
input[type="text"]{
	margin-right: 4px;
	width: 200px;
	display: inline-block;
}
 {/literal}</style>
</head>
<body>
	<div class="card-box">
		<div class="form-group">
			<label>Redirect URL (after submitting the form)</label>
			<input type="text" value="" id="redirect_url" class="get_value form-control">
			{if $flg_everwebinar_redirect}
			<div class="{if $flg_webinarjam_redirect}radio{else}checkbox{/if} {if $flg_webinarjam_redirect}radio{else}checkbox{/if}-primary" style="display: inline-block;">
				<input type="{if $flg_webinarjam_redirect}radio{else}checkbox{/if}" id="everbebinar_redirect" name="redirect_url_change" value="1"/>
				<label for="everbebinar_redirect">Redirect to EverWebinar thank you page</label>
			</div>
			{/if}
			{if $flg_webinarjam_redirect}
			<div class="{if $flg_webinarjam_redirect}radio{else}checkbox{/if} {if $flg_webinarjam_redirect}radio{else}checkbox{/if}-primary" style="display: inline-block;">
				<input type="{if $flg_webinarjam_redirect}radio{else}checkbox{/if}" id="webinarjam_redirect" name="redirect_url_change" value="1"/>
				<label for="webinarjam_redirect">Redirect to WebinarJam thank you page</label>
			</div>
			{/if}
			{if $flg_convertkit_redirect}
			<div class="{if $flg_convertkit_redirect}radio{else}checkbox{/if} {if $flg_convertkit_redirect}radio{else}checkbox{/if}-primary" style="display: inline-block;">
				<input type="{if $flg_convertkit_redirect}radio{else}checkbox{/if}" id="convertkit_redirect" name="redirect_url_change" value="1"/>
				<label for="convertkit_redirect">Redirect to ConvertKit thank you page</label>
			</div>
			{/if}
		</div>
        <div class="form-group" id="new_elements">
        	<textarea class="form-control" id="form">{$form}</textarea>
			<div id="update_form" style="width:1px;height:1px;overflow:hidden;"></div>
        </div>
        <div class="form-group">
            <button class="btn btn-default waves-effect waves-light clipboard" type="button" data-clipboard-target="#form">Copy to clipboard</button>
        </div>
		
		<div class="form-group" id="get_script">
        	<textarea class="form-control" id="getElt"><script type="text/javascript" src="{Zend_Registry::get( 'config' )->domain->url}/squeeze/moveget?formid={$smarty.get.id}"></script></textarea>
        </div>
        <div class="form-group">
            <button class="btn btn-default waves-effect waves-light clipboard" type="button" data-clipboard-target="#getElt">Copy to clipboard</button>
        </div>
	</div>
<script type="text/javascript" src="/skin/_js/clipboard.min.js"></script>
{literal}
<script type="text/javascript">
	var clipboard = new ClipboardJS('.clipboard');
	clipboard.on('success', function(e) {
		jQuery( '.clipboard' ).html( 'Copied to clipboard' );
		e.clearSelection();
	});

	jQuery( '#everbebinar_redirect' ).on( 'click', function(){
		if( jQuery( '#everbebinar_redirect' ).get(0).checked ){
			jQuery('#redirect_url').hide();
			jQuery('#redirect_url').prop( 'value', '#everwebinar_{/literal}{$everwebinar_id}{literal}' );
		}else{
			jQuery('#redirect_url').show();
			jQuery('#redirect_url').prop( 'value', '' );
		}
		jQuery('#redirect_url').keyup();
	});
	
	jQuery( '#webinarjam_redirect' ).on( 'click', function(){
		if( jQuery( '#webinarjam_redirect' ).get(0).checked ){
			jQuery('#redirect_url').hide();
			jQuery('#redirect_url').prop( 'value', '#webinarjam_{/literal}{$webinarjam_id}{literal}' );
		}else{
			jQuery('#redirect_url').show();
			jQuery('#redirect_url').prop( 'value', '' );
		}
		jQuery('#redirect_url').keyup();
	});
	
	jQuery( '#convertkit_redirect' ).on( 'click', function(){
		if( jQuery( '#convertkit_redirect' ).get(0).checked ){
			jQuery('#redirect_url').hide();
			jQuery('#redirect_url').prop( 'value', '#convertkit_{/literal}{$convertkit_id}{literal}' );
		}else{
			jQuery('#redirect_url').show();
			jQuery('#redirect_url').prop( 'value', '' );
		}
		jQuery('#redirect_url').keyup();
	});
	
	jQuery( '.get_value' ).on( 'keyup', function(){
		var _tmpForm = jQuery( jQuery( '#form' ).prop( 'value' ) );
		if( jQuery( this ).prop( 'value' ) !== '' ){
			if( _tmpForm.find( '[name="redirect_url"]' ).length == 0 ){
				_tmpForm.find( '[name="id"]' ).after( '<input type="hidden" name="redirect_url" value="' + jQuery( this ).prop( 'value' ) + '" />' );
			} else {
				_tmpForm.find( '[name="redirect_url"]' ).prop( 'value', jQuery( this ).prop( 'value' ) );
			}
		} else {
			_tmpForm.find( '[name="redirect_url"]' ).remove();
		}
		jQuery( '#form' ).prop( 'value', _tmpForm.get(0).outerHTML );
	} );
</script>
{/literal}
</body>
</html>