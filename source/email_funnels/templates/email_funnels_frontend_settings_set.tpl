<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
{if $msg=='saved'}
{include file='../../message.tpl' type='success' message="SMTP setting was saved."}
{/if}
{if $msg=='created'}
{include file='../../message.tpl' type='success' message="SMTP setting was created."}
{/if}
	<h3>New SMTP Integration</h3>
	<div class="card-box">
		<form action="{url name='email_funnels' action='frontend_settings_set'}" method="post" enctype="multipart/form-data">
			<input type="hidden" name="arrData[id]"{if isset($arrData.id)} value="{$arrData.id}"{/if} />
			<div class="form-group">
				<label>Title<span class="text-danger">*</span></label>
				<input type="text" class="form-control" parsley-trigger="change" required name="arrData[title]"{if isset($arrData.title)} value="{$arrData.title}"{/if} />
			</div>
			<div class="form-group">
				<label>From Name<span class="text-danger">*</span></label>
				<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][from_name]"{if isset($arrData.settings.from_name)} value="{$arrData.settings.from_name}"{/if} />
			</div>
			<div class="form-group">
				<label>From Email<span class="text-danger">*</span></label>
				<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][from_email]"{if isset($arrData.settings.from_email)} value="{$arrData.settings.from_email}"{/if} />
			</div>
			<div class="form-group">
				<label>Reply-To</label>
				<input type="text" class="form-control" name="arrData[settings][replay_to]"{if isset($arrData.settings.replay_to)} value="{$arrData.settings.replay_to}"{/if} />
			</div>
			<div class="form-group">
				<div class="row">
					<div class="col-md-6">
						<label>SMTP Server<span class="text-danger">*</span></label>
						<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][smtp_server]"{if isset($arrData.settings.smtp_server)} value="{$arrData.settings.smtp_server}"{/if} />
						<span>If you use Sendgrid on port 25, NO SSL, input smtp.sendgrid.net in the above field</span>
					</div>
					<div class="col-md-6">
						<label>SMTP Port<span class="text-danger">*</span></label>
						<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][smtp_port]"{if isset($arrData.settings.smtp_port)} value="{$arrData.settings.smtp_port}"{/if} />
					</div>
					<div class="col-md-6">

					</div>
				</div>
			</div>
			<div class="form-group">
				<div class="row">
					<div class="col-md-6">
						<label>SMTP User<span class="text-danger">*</span></label>
						<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][smtp_user]"{if isset($arrData.settings.smtp_user)} value="{$arrData.settings.smtp_user}"{/if} />
					</div>
					<div class="col-md-6">
						<label>SMTP Password<span class="text-danger">*</span></label>
						<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][smtp_pass]"{if isset($arrData.settings.smtp_pass)} value="{$arrData.settings.smtp_pass}"{/if} />
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>Address 1<span class="text-danger">*</span></label>
				<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][addr1]"{if isset($arrData.settings.addr1)} value="{$arrData.settings.addr1}"{/if} />
			</div>
			<div class="form-group">
				<label>Address 2<span class="text-danger">*</span></label>
				<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][addr2]"{if isset($arrData.settings.addr2)} value="{$arrData.settings.addr2}"{/if} />
			</div>
			<div class="form-group">
				<div class="row">
					<div class="col-md-6">
						<label>City<span class="text-danger">*</span></label>
						<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][city]"{if isset($arrData.settings.city)} value="{$arrData.settings.city}"{/if} />
					</div>
					<div class="col-md-6">
						<label>State<span class="text-danger">*</span></label>
						<input type="text" class="form-control" parsley-trigger="change" required name="arrData[settings][state]"{if isset($arrData.settings.state)} value="{$arrData.settings.state}"{/if} />
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>SMTP Footer<span class="text-danger">*</span></label>
				<textarea class="form-control" parsley-trigger="change" required name="arrData[settings][smtp_footer]">{if isset($arrData.settings.smtp_footer)}{$arrData.settings.smtp_footer}{else}{/if}</textarea>
			</div>
			<div class="form-group">
				<label>Referral Link:</label>
				<input type="text" class="form-control" name="arrData[settings][referral_link]" value="{if isset($arrData.settings.referral_link)}{$arrData.settings.referral_link}{else}{/if}" />
			</div>
			
			<div class="form-group">
				<button type="submit" class="btn btn-success waves-effect waves-light save_button" style="display: none;">Save</button>
				<button type="button" class="btn btn-success waves-effect waves-light test_connection">Test connection</button>
			</div>
			
			<div class="alert alert-success alert-dismissable" id="success_smtp" style="display:none;">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
				<div>Connection was established properly</a></div>
			</div>
			
			<div class="alert alert-danger alert-dismissable" id="error_smtp" style="display:none;">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
				<div>Couldn't connect to your SMTP server, please re-check your settings</a></div>
			</div>
			
		</form>
	</div>
	<script type="text/javascript" src="/skin/light/plugins/parsleyjs/dist/parsley.min.js"></script>
{literal}
<script type="text/javascript">
jQuery( document ).ready( function(){
	jQuery( 'form' ).parsley();

	var flg_change = false;
	jQuery( '[name="arrData[settings][from_name]"],[name="arrData[settings][addr1]"],[name="arrData[settings][addr2]"]' ).on( 'change', function(){
		if( flg_change ) return;
		jQuery( '[name="arrData[settings][smtp_footer]"]' ).prop( 'value', 
			jQuery( '[name="arrData[settings][from_name]"]' ).prop( 'value' ) + '\n' +
			jQuery( '[name="arrData[settings][addr1]"]' ).prop( 'value' ) + '\n' +
			jQuery( '[name="arrData[settings][addr2]"]' ).prop( 'value' ) );
	} );

	jQuery( '[name="arrData[settings][smtp_footer]"]' ).on( 'change', function(){
		flg_change = true;
	} );

	jQuery( '.test_connection' ).on( 'click', function(){
		jQuery('#success_smtp').hide();
		jQuery('#error_smtp').hide();
		if( jQuery( '[name="arrData[settings][smtp_server]"]' ).prop( 'value' )=='' || jQuery( '[name="arrData[settings][smtp_server]"]' ).prop( 'value' )=='' || jQuery( '[name="arrData[settings][smtp_server]"]' ).prop( 'value' )=='' || jQuery( '[name="arrData[settings][smtp_server]"]' ).prop( 'value' )=='' ){
			jQuery('#error_smtp').show();
			alert('Fill in all required fields.');
			return;
		}
		jQuery( '.test_connection' ).html('Connect...');
		jQuery.post( "{/literal}{url name='email_funnels' action='request'}{literal}", {
			action : 'test_connection',
			server : jQuery( '[name="arrData[settings][smtp_server]"]' ).prop( 'value' ),
			port : jQuery( '[name="arrData[settings][smtp_port]"]' ).prop( 'value' ),
			user : jQuery( '[name="arrData[settings][smtp_user]"]' ).prop( 'value' ),
			pass : jQuery( '[name="arrData[settings][smtp_pass]"]' ).prop( 'value' )
		} ).done( function( data ){
			data = JSON.parse( data );
			if( typeof data.error != 'undefined' ){
				jQuery('#error_smtp').show();
				jQuery( '.test_connection' ).html('Test connection');
				alert( data.error );
			}else{
				jQuery('#success_smtp').show();
				jQuery( '.save_button' ).show();
				jQuery( '.test_connection' ).hide();
			}
		});
		
	} );
	{/literal}{if isset( $msg ) && ( $msg=='saved' || $msg=='created' ) }{literal}
	setTimeout(
		function(){
			window.parent.multibox.boxWindow.close();
			window.parent.location.reload();
		}, 
		2000
	);
	{/literal}{/if}{literal}
} );
</script>
{/literal}
</body>
</html>