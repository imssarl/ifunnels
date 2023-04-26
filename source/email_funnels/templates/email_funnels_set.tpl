<h1>{$arrPrm.title}</h1>
<script type="text/javascript" src="/skin/light/js/jquery.min.js"></script>
<form action="" method="post">
	<input type="hidden" name="arrData[id]" value="{$arrData.id}" />
	<input type="hidden" name="arrData[flg_template]" value="1" />
	<input type="hidden" name="arrData[delete_message]" value="" />
	<div class="form-group">
		<label for="title">Title</label>
		<input type="text" id="title" class="form-control" name="arrData[title]" value="{$arrData.title}" />
	</div>
	<div class="form-group">
		<label for="description">Description</label>
		<input type="text" id="description" class="form-control" name="arrData[description]" value="{$arrData.description}" />  
	</div>	
	<div class="form-group">
		<label for="type">Type:</label>
		<div class="radio-button">
			<input type="radio" id="type_0" name="arrData[type]" value="1"{if empty($arrData.type) || $arrData.type == '1'} checked=""{/if} />
			<label for="type_0">Broadcast</label>
		</div>
		<div class="radio-button">
			<input type="radio" id="type_1" name="arrData[type]" value="2"{if $arrData.type == '2'} checked=""{/if} />
			<label for="type_1">Sequence</label>
		</div>
	</div>
	<div class="form-group">
		<h4>Message:</h4>
	</div>
	<div id="messages">
		<ul id="sortable" class="connectedSortable">
		{assign var=index_message value=0}
		{assign var=position value=0}
		{if !empty($arrData.message) }
		{foreach from=$arrData.message item=message}
		<li class="form-group" data-block="message" data-index="{$index_message}">
			<span class="btn-delete" data-messageid="{$message.id}" title="Delete this message"></span>
			<input type="hidden" name="arrData[message][{$index_message}][position]" value="{$message.position}">
			<div>
				<label>Name</label>
				<input type="text" name="arrData[message][{$index_message}][name]" class="form-control" value="{$message.name}" />
				<input type="hidden" name="arrData[message][{$index_message}][id]" class="form-control" value="{$message.id}" />
			</div>
			<div>
				<label>Subject</label>
				{if is_array($message.subject)}
				{foreach from=$message.subject key=s_id item=s_value}
				<p class="main_subject_block">
					<input type="text" name="arrData[message][{$index_message}][subject][{$s_id}]" class="form-control" value="{$s_value}" />
					{if $s_id==0}
					<a href="#" style="font-size: 24px;" class="multi-subject" data-key="{$key}">+</a>
					{else}
					<a href="#" class="delete-subject" style="font-size:20px"> -</a>
					{/if}
				</p>
				{/foreach}
				{else}
				<p class="main_subject_block">
					<input type="text" name="arrData[message][{$index_message}][subject][]" class="form-control" value="{$message.subject}" />
				</p>
				{/if}
			</div>
			<div>
				<label>Body HTML</label>
				<textarea name="arrData[message][{$index_message}][body_html]" id="body_html_{$message@iteration-1}" class="form-control">{$message.body_html}</textarea>
			</div>
			<div>
				<label>Body Plain Text</label>
				<textarea name="arrData[message][{$index_message}][body_plain_text]" class="form-control">{$message.body_plain_text}</textarea>	 
			</div>
			<div>
				<label>Header Title</label>
				<input type="text" name="arrData[message][{$index_message}][header_title]" class="form-control" value="{$message.header_title}" />
			</div>
			<div {if $index_message!=0}data-type="sequence"{/if} class="for_sequence"{if $arrData.type == '1' || $message@iteration-1 == 0} style="display: none;"{/if}>
				<label>Wait Period</label>
				<select name="arrData[message][{$index_message}][flg_period]" class="form-control">
					<option value="0">- select -</option>
					<option value="1"{if $message.flg_period == 1} selected="selected"{/if}>Hours</option>
					<option value="2"{if $message.flg_period == 2} selected="selected"{/if}>Days</option>
				</select>
				<input type="text" name="arrData[message][{$index_message}][period_time]" class="form-control" value="{$message.period_time}" rel="{$index_message++}{$position++}" />
			</div>
		</li>
		{/foreach}
		{else}
		<li class="form-group" data-block="message" data-index="0">
			<input type="hidden" name="arrData[message][0][position]" value="0">
			<div>
				<label>Name</label>
				<input type="text" name="arrData[message][0][name]" class="form-control" />
			</div>
			<div>
				<label>Subject</label>
				<input type="text" name="arrData[message][0][subject]" class="form-control" />
			</div>
			<div>
				<label>Body HTML</label>
				<textarea id="body_html_0" name="arrData[message][0][body_html]" class="form-control"></textarea>
			</div>
			<div>
				<label>Body Plain Text</label>
				<textarea name="arrData[message][0][body_plain_text]" class="form-control"></textarea>	 
			</div>
			<div>
				<label>Header Title</label>
				<input type="text" name="arrData[message][0][header_title]" class="form-control" />
			</div>
			<div {if $index_message!=0}data-type="sequence"{/if} class="for_sequence" style="display: none;">
				<label>Wait Period</label>
				<select name="arrData[message][0][flg_period]" class="form-control">
					<option value="0">- select -</option>
					<option value="1">Hours</option>
					<option value="2">Days</option>
				</select>
				<input type="text" name="arrData[message][0][period_time]" class="form-control" rel="{$index_message++}" />
			</div>
		</li>
		{/if}
		</ul>
	</div>
	<div class="form-group copy-radio" data-type="sequence" {if empty($arrData) || $arrData.type == '1'} style="display: none;"{/if}>
		<div class="radio-button">
			<input type="radio" class="copy" id="copy_1" checked="" />
			<label for="copy_1">Create from Scratch</label>
		</div>
		<div class="radio-button">
			<input type="radio" class="copy" id="copy_2" />
			<label for="copy_2">Copy Existing Message</label>
		</div>
	</div>
	<div class="form-group copy-setting" data-type="sequence" style="display: none;">
		<select class="form-control" id="email_funnel">
			<option value="current">From This</option>
			{foreach from=$arrEFunnels item=funnel}
			<option value="{$funnel.id}">{$funnel.title}</option>
			{/foreach}
		</select>
		<select class="form-control" id="email_funnel_messages">
			<option value="">- select -</option>
		</select>
	</div>
	<div class="form-group">
		<input type="button" class="add_new"{if $arrData.type == '2'} style="display: inline;"{else} style="display: none;"{/if} value="Add new message" />
		<button type="submit">Save</button>
	</div>
</form>

<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" href="/skin/_js/jquery-ui/jquery-ui.css">
<script type="text/javascript" src="/skin/_js/jquery-ui/jquery-ui.js"></script>
{literal}
<style type="text/css">.cke{float:left;margin-bottom:20px!important;}</style>
<script type="text/javascript">
	var ckeditorCopyProphetLink='{/literal}{url name="site1_accounts" action="copyprophet_ajax"}{literal}';
	var sendEmailNowTest='{/literal}{url name="email_funnels" action="request"}{literal}';
	
	$$('.delete-subject').addEvent('click',function(e){
		jQuery( e.target )[0].getParent('p.main_subject_block').destroy();
	});
	$$('.multi-subject').addEvent('click',function(e){
		e.stop();
		if( $$('.main_subject_block').length==9 ){
			jQuery( e.target )[0].hide();
			return;
		}
		var p=new Element('p',{class:'main_subject_block'});
		var input=new Element('input',{type:'text',name:'arrData[message]['+jQuery(jQuery( e.target )[0]).data( 'key' )+'][subject][]',class:'main_subject medium-input text-input form-control'})
				.inject(p.inject(jQuery( e.target )[0].getParent(),'after'));
		var a = new Element('a',{ href:'#', class:'delete-subject',html:' -' }).setStyles({'font-size':'20px'}).inject(p);
		a.addEvent('click',function(){
			e.stop();
			jQuery( e.target )[0].show();
			p.destroy();
		});
	}.bind(this));
	
	
	jQuery( document ).ready( function(){
		jQuery( "#sortable" ).sortable({
			connectWith: ".connectedSortable",
			placeholder: "ui-state-highlight form-group"
		});

		jQuery( "#sortable" ).bind( "sortstop", function( event, ui ){
			CKEDITOR.instances['body_html_' + jQuery( ui.item ).data( 'index' )].updateElement();
			delete CKEDITOR.instances['body_html_' + jQuery( ui.item ).data( 'index' )];
			jQuery( '#body_html_' +  jQuery( ui.item ).data( 'index' )).next().remove();
			CKEDITOR.replace( 'body_html_' + jQuery( ui.item ).data( 'index' ), {
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

			jQuery( '#sortable li[data-block="message"]' ).each( function( _index, item ){
				jQuery( item ).find( '[name="arrData[message][' + jQuery( item ).data( 'index' ) + '][position]"]' ).prop( 'value', _index );
				if( _index == 0 ){
					jQuery( item ).find( '[name*="[flg_period]"]' ).find( 'option' ).removeAttr( 'selected' ).eq(0).attr( 'selected', 'selected' );
					jQuery( item ).find( '[name*="[period_time]"]' ).prop( 'value', '' );
					jQuery( item ).find( '[data-type="sequence"]' ).hide();
				} else {
					jQuery( item ).find( '[data-type="sequence"]' ).show();
				}
			});
		});

		jQuery( '.btn-delete' ).on( 'click', function(){
			jQuery( this ).parent().fadeOut( 'fast' );
			var _ids = jQuery( '[name="arrData[delete_message]"]' ).prop( 'value' );
			_ids = ( _ids === '' ? [] : _ids.split( ',' ) );
			_ids.push( jQuery( this ).data( 'messageid' ) );
			jQuery( '[name="arrData[delete_message]"]' ).prop( 'value', _ids.join( ',' ) );
			return false;
		} );

		var index = {/literal}{$index_message}{literal};
		var indexPrev = {/literal}{$index_message-1}{literal};
		var position = {/literal}{$position}{literal};
		jQuery( 'input[name="arrData[type]"]' ).on( 'change', function(){
			if( jQuery(this).prop( 'value' ) == 2 ){
				jQuery( 'input.add_new' ).show();
				jQuery( '.copy-radio' ).show();
				//jQuery( '[data-type="sequence"]' ).show();
				jQuery( '[data-index]' ).show();
				if( jQuery( '#copy_2' ).prop( 'checked' ) ){
					jQuery( '.copy-setting' ).show();
				} else {
					jQuery( '.copy-setting' ).hide();
				}
			}else{
				jQuery( 'input.add_new' ).hide();
				jQuery( '[data-index]' ).hide();
				jQuery( '[data-index="0"]' ).show();
			}
		});

		jQuery( 'input.add_new' ).on( 'click', function(){
			var _clone = null, _i = indexPrev;
			position++;
			switch( jQuery( '.copy:checked' ).attr( 'id' ) ){
				case 'copy_1':
					_clone = jQuery( '[data-block="message"]' ).eq(0).clone().show();
					_i = _clone.attr( 'data-index' );
					_clone.attr( 'data-index', index );
					_clone.find( '[name="arrData[message]['+_i+'][name]"]' ).attr( 'name', 'arrData[message][' + index + '][name]' ).prop( 'value', '' );
					_clone.find( '[name="arrData[message]['+_i+'][subject]"]' ).attr( 'name', 'arrData[message][' + index + '][subject]' ).prop( 'value', '' );
					_clone.find( '[name="arrData[message]['+_i+'][body_html]"]' ).attr( 'name', 'arrData[message][' + index + '][body_html]' ).prop( 'value', '' ).attr( 'id', 'body_html_' + index );
					_clone.find( '[name="arrData[message]['+_i+'][body_plain_text]"]' ).attr( 'name', 'arrData[message][' + index + '][body_plain_text]' ).prop( 'value', '' );
					_clone.find( '[name="arrData[message]['+_i+'][header_title]"]' ).attr( 'name', 'arrData[message][' + index + '][header_title]' ).prop( 'value', '' );
					_clone.find( '[name="arrData[message]['+_i+'][flg_period]"]' ).attr( 'name', 'arrData[message][' + index + '][flg_period]' ).prop( 'value', 0 );
					_clone.find( '[name="arrData[message]['+_i+'][period_time]"]' ).attr( 'name', 'arrData[message][' + index + '][period_time]' ).prop( 'value', '' );
					_clone.find( '[name="arrData[message]['+_i+'][position]"]' ).attr( 'name', 'arrData[message][' + index + '][position]' ).prop( 'value', position );
					_clone.find( '.for_sequence' ).attr('data-type',"sequence");
					_clone.find( '[data-type="sequence"]' ).show();
					/* Удаление ckeditor, инициализация нового */
					_clone.find( '[name="arrData[message]['+index+'][body_html]"]' ).next().remove();
					jQuery( '#messages #sortable' ).append( _clone );
					if( jQuery( '#body_html_' + index ).length > 0 ){
						CKEDITOR.replace( 'body_html_' + index, {
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
					}
					index++;
				break;
				case 'copy_2':
					var _messageId = jQuery( '#email_funnel_messages' ).prop( 'value' ), _funnelId = jQuery( '#email_funnel' ).prop( 'value' );
					if( _funnelId == 'current' ){
						_clone = jQuery( '[data-block="message"][data-index="' + _messageId + '"]' ).clone().show();
						_clone.attr( 'data-index', index );
						_clone.find( '[name="arrData[message][' + _messageId + '][name]"]' )
							.prop( 'value', _clone.find( '[name="arrData[message][' + _messageId + '][name]"]' ).prop( 'value' ) + ' Copy' )
							.attr( 'name', 'arrData[message][' + index + '][name]' );
						_clone.find( '[name="arrData[message][' + _messageId + '][name]"]' ).attr( 'name', 'arrData[message][' + index + '][name]' );
						_clone.find( '[name="arrData[message][' + _messageId + '][subject]"]' ).attr( 'name', 'arrData[message][' + index + '][subject]' );
						_clone.find( '[name="arrData[message][' + _messageId + '][body_html]"]' ).attr( 'name', 'arrData[message][' + index + '][body_html]' ).attr( 'id', 'body_html_' + index );
						_clone.find( '[name="arrData[message][' + _messageId + '][body_plain_text]"]' ).attr( 'name', 'arrData[message][' + index + '][body_plain_text]' );
						_clone.find( '[name="arrData[message][' + _messageId + '][header_title]"]' ).attr( 'name', 'arrData[message][' + index + '][header_title]' );
						_clone.find( '[name="arrData[message][' + _messageId + '][flg_period]"]' ).attr( 'name', 'arrData[message][' + index + '][flg_period]' );
						_clone.find( '[name="arrData[message][' + _messageId + '][period_time]"]' ).attr( 'name', 'arrData[message][' + index + '][period_time]' );
						_clone.find( '[name="arrData[message][' + index + '][flg_period]"]' ).prop( 'value', jQuery( '[name="arrData[message][' + _messageId + '][flg_period]"]' ).prop( 'value' ) );
						_clone.find( '[name="arrData[message][' + _messageId + '][position]"]' ).attr( 'name', 'arrData[message][' + index + '][position]' ).prop( 'value', position );
						/* Удаление ckeditor, инициализация нового */
						_clone.find( '[name="arrData[message]['+index+'][body_html]"]' ).next().remove();
						_clone.find( '[name="arrData[message]['+index+'][body_html]"]' ).prop( 'value', CKEDITOR.instances['body_html_' + _messageId ].getData() );
						_clone.find( '.for_sequence' ).attr('data-type',"sequence");
						_clone.find( '[data-type="sequence"]' ).show();
						jQuery( '#messages #sortable' ).append( _clone );
						if( jQuery( '#body_html_' + index ).length > 0 ){
							CKEDITOR.replace( 'body_html_' + index, {
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
						}
						index++;
					} else {
						methods.getOtherMessage( _funnelId, false ).done( function( data ){
							data = JSON.parse( data );
							_clone = jQuery( '[data-block="message"]' ).eq(0).clone().show();
							_i = _clone.attr( 'data-index' );
							Object.keys( data.message ).forEach( function( item ){
								if( data.message[item].id == _messageId ){
									_clone.attr( 'data-index', index );
									_clone.find( '[name="arrData[message][' + _i + '][name]"]' ).attr( 'name', 'arrData[message][' + index + '][name]' ).prop( 'value', data.message[item].name + ' Copy' );
									_clone.find( '[name="arrData[message][' + _i + '][subject]"]' ).attr( 'name', 'arrData[message][' + index + '][subject]' ).prop( 'value', data.message[item].subject );
									_clone.find( '[name="arrData[message][' + _i + '][body_html]"]' ).attr( 'name', 'arrData[message][' + index + '][body_html]' ).prop( 'value', data.message[item].body_html ).attr( 'id', 'body_html_' + index );
									_clone.find( '[name="arrData[message][' + _i + '][body_plain_text]"]' ).attr( 'name', 'arrData[message][' + index + '][body_plain_text]' ).prop( 'value', data.message[item].body_plain_text );
									_clone.find( '[name="arrData[message][' + _i + '][header_title]"]' ).attr( 'name', 'arrData[message][' + index + '][header_title]' ).prop( 'value', data.message[item].header_title );
									_clone.find( '[name="arrData[message][' + _i + '][flg_period]"]' ).attr( 'name', 'arrData[message][' + index + '][flg_period]' ).prop( 'value', data.message[item].flg_period );
									_clone.find( '[name="arrData[message][' + _i + '][period_time]"]' ).attr( 'name', 'arrData[message][' + index + '][period_time]' ).prop( 'value', data.message[item].period_time );
									_clone.find( '[name="arrData[message][' + _i + '][position]"]' ).attr( 'name', 'arrData[message][' + index + '][position]' ).prop( 'value', position );
									_clone.find( '[name="arrData[message][' + index + '][flg_period]"]' ).prop( 'value', data.message[item].flg_period );
									_clone.find( '.for_sequence' ).attr('data-type',"sequence");
									_clone.find( '[data-type="sequence"]' ).show();
									/* Удаление ckeditor, инициализация нового */
									_clone.find( '[name="arrData[message]['+index+'][body_html]"]' ).next().remove();
								}
							} );
							jQuery( '#messages #sortable' ).append( _clone );
							CKEDITOR.replace( 'body_html_' + index, {
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
							index++;
						} );
					}
				break;
			}
			if( jQuery( '#email_funnel' ).prop( 'value' ) == 'current' ){
				methods.getCurrentMessage();
			}
		} );

		jQuery( '.copy' ).on( 'change', function(){
			jQuery( '.copy' ).prop( 'checked', null );
			jQuery( this ).prop( 'checked', true );
			if( jQuery(this).prop( 'id' ) == 'copy_1' ){
				jQuery( '.copy-setting' ).hide();
			} else {
				jQuery( '.copy-setting' ).show();
				methods.getCurrentMessage();
			}
		} );

		jQuery( '#email_funnel' ).on( 'change', function(){
			if( jQuery( this ).prop( 'value' ) !== 'current' ){
				methods.getOtherMessage( jQuery( this ).prop( 'value' ), true ).done( function( data ){
					jQuery( '#email_funnel_messages' ).empty();
					data = JSON.parse( data );
					Object.keys( data.message ).forEach( function( item, i ){
						jQuery( '#email_funnel_messages' ).append( '<option value="' + data.message[item].id + '">' + data.message[item].name + '</option>' ).removeAttr( 'disabled' );
					} );
				} );
			} else {
				methods.getCurrentMessage();
			}
		} );

		var methods = {
			getCurrentMessage : function(){
				var _messageId = 0, _messageName = '';
				jQuery( '#email_funnel_messages' ).empty();
				jQuery( '[data-index]' ).each( function( item, i ){
					_messageId = jQuery( this ).data( 'index' );
					_messageName = jQuery( this ).find( '[name="arrData[message][' + _messageId + '][name]"]' ).prop( 'value' );
					jQuery( '#email_funnel_messages' ).append( '<option value="' + _messageId + '">' + (_messageName == '' ? 'Message #' + _messageId : _messageName ) +  '</option>' );
				} );
				jQuery( '#email_funnel_messages' ).off( 'change' ).on( 'change', function(){
					jQuery( this ).children( 'option[value="' + jQuery( this ).prop( 'value' ) + '"]' ).attr( 'selected', 'selected' ); 
				} );
			},
			getOtherMessage : function( idFunnel, empty ){
				if( empty ) 
					jQuery( '#email_funnel_messages' ).empty().append( '<option>Loading...</option>' ).attr( 'disabled', 'disabled' );
				return jQuery.post( '{/literal}{url name='email_funnels' action='request'}{literal}', { id : idFunnel } );
			}
		};
		{/literal}{if empty($arrData.message)}{literal}
		if( jQuery( '#body_html_0' ).length > 0 ){
			CKEDITOR.replace( 'body_html_0', {
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
		}
		{/literal}{else}{literal}
		for( var i = 0; i < index; i++ ){
			CKEDITOR.replace( 'body_html_' + i , {
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
		}
		{/literal}{/if}{literal}
	} );
</script>
{/literal}