<style type="text/css">
	#datepicker,#datepicker2 { display: block!important; }
</style>
<div class="content-box-header">
	<h3>{$arrPrm.title}</h3>
</div>
{literal}<style type="text/css">.message {padding-bottom:20px;margin-bottom:20px;border-bottom:2px dotted #cecece}.message:last-child {border:none;margin:none}.ui-sortable-placeholder {height:40px!important;border-radius:3px!important;border: 1px dotted #cccccc!important;background:#ffffff!important;}.panel-heading:after{content:'';width:100%;clear:both;display:block}.w-97{width:97%}.w-3{width:3%}.m-t-3{margin-top:3px}
.main_subject{max-width:90%;display: inline-block;}</style>{/literal}

{include file='../../error.tpl'}

{if empty($arrSMTP)}
<div class="alert alert-warning">
	<strong>Warning!</strong> Please note that you need to add your SMTP settings first before creating an email funnel.
</div>
{/if}

<div class="card-box">
	<form action="" method="post" id="autosave_form">
		<input type="hidden" name="flg_autosave" value="0" id="autosave_flag" />
		<input type="hidden" name="arrData[id]" value="{$arrData.id}" id="set_id" />
		<input type="hidden" name="arrData[type]" value="{$arrData.type}" />
		<div class="form-group">
			{if $flgHaveTemplates}<a href="{url name='email_funnels' action='popup_email_funnels'}" class="btn btn-default waves-effect waves-light popup_mb">Select Email Funnel</a>{/if}
			<a href="#" id="new_efunnel" class="btn btn-default waves-effect waves-light">Create From Scratch</a>
		</div>
		<div class="row" id="funnel_settings">
			<div class="col-md-12">
				<div id="accordion" class="connectedSortable">
					{assign var=index_message value=0}
					{if !empty($arrData.message)}
					{foreach from=$arrData.message key=key item=v}
					<div class="panel-group funnel_scratch" rel="{$index_message++}" data-message="{$v@iteration-1}">
						<div class="panel panel-default">
							<div class="panel-heading" id="heading_{$v@iteration}">
								<h6 class="panel-title m-t-3 pull-left w-97">
									<a href="#collapse_{$v@iteration}" class="text-dark collapsed" data-hashtag="" data-toggle="collapse" aria-expanded="false" aria-controls="collapse_{$v@iteration-1}"><input type="text" class="form-control check_required" style="max-width: 20%;display:inline;" name="arrData[message][{$key}][name]" value="{if !empty($arrData.message[$key].name)}{$arrData.message[$key].name}{/if}" placeholder="Name #{$key}"></a>
									<input type="hidden" class="form-control get_for_delete" id="mess_id_{$arrData.message[$key].id}" name="arrData[message][{$key}][id]" value="{$arrData.message[$key].id}" />
									<input type="hidden" name="arrData[message][{$key}][position]" value="{$arrData.message[$key].position}" />
									<input type="hidden" name="arrData[message][{$key}][header_title]" value="{$arrData.message[$key].header_title}" />
								</h6>
								{if Core_Acs::haveAccess( array( 'Email funnels' ) )}
								<a href="#" class="pull-left w-3-20 text-right btn-delete" title="Delete message"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
								{/if}
							</div>
							<div id="collapse_{$v@iteration}" class="panel-collapse collapse" aria-labelledby="headingOne" data-parent="#accordion" style="">
								<div class="panel-body">
									<div class="form-group">
										<label>Subjects</label><br/>
										{if is_array($v.subject)}
										{foreach from=$v.subject key=s_id item=s_value}
										<p class="main_subject_block">
											<input type="text" name="arrData[message][{$key}][subject][{$s_id}]" id="subject_{$v@iteration-1}" class="subject_{$v@iteration-1} main_subject medium-input text-input form-control" data-hashtag="" value="{$s_value}" />
											{if ( !Core_Acs::haveAccess( array( 'Broadcasts' ) ) && !Core_Acs::haveAccess( array( 'Email Funnels No Testing' ) ) ) || Core_Acs::haveAccess( array( 'Email funnels' ) ) }
												{if $s_id==0}
												<a href="#" style="font-size: 24px;" class="multi-subject" data-key="{$key}">+</a>
												{else}
												<a href="#" class="delete-subject" style="font-size:20px"> -</a>
												{/if}
											{/if}
										</p>
										{/foreach}
										{else}
										<p class="main_subject_block">
											<input type="text" name="arrData[message][{$key}][subject][]" id="subject_0" class="subject_0 main_subject medium-input text-input form-control" data-hashtag="" value="{$v.subject}" />
											{if ( !Core_Acs::haveAccess( array( 'Broadcasts' ) ) && !Core_Acs::haveAccess( array( 'Email Funnels No Testing' ) ) ) || Core_Acs::haveAccess( array( 'Email funnels' ) ) }
											<a href="#" style="font-size: 24px;" class="multi-subject" data-key="{$key}">+</a>
											{/if}
										</p>
										{/if}
									</div>
									<div class="form-group">
										<label>Body HTML</label>
										<textarea class="form-control" name="arrData[message][{$key}][body_html]" id="body_html_{$v@iteration-1}" rel="{$v@iteration-1}">{$v.body_html}</textarea>
									</div>
									<div class="form-group">
										<label>Body Plain Text</label>
										<textarea class="form-control body-plain-text" id="body_plain_text_{$v@iteration-1}" name="arrData[message][{$key}][body_plain_text]">{$v.body_plain_text}</textarea>
									</div>
									<div data-type="sequence" {if $arrData.type == 1} style="display: none;"{/if} class="form-group">
										{if Core_Acs::haveAccess( array( 'Email funnels' ) ) && $index_message!=1}
										<label>Wait Period</label>
										<select name="arrData[message][{$key}][flg_period]" class="form-control">
											<option value="0">- select -</option>
											<option value="1" {if $v.flg_period == '1'}selected="selected"{/if}>Hours</option>
											<option value="2" {if $v.flg_period == '2'}selected="selected"{/if}>Days</option>
										</select>
										<input type="text" name="arrData[message][{$key}][period_time]" class="form-control" value="{$v.period_time}" />
										{else}
										<input type="hidden" name="arrData[message][{$key}][flg_period]" value="{$v.flg_period}" />
										<input type="hidden" name="arrData[message][{$key}][period_time]" value="{$v.period_time}" />
										<label>Wait Period</label>
										<span class="label label-info">{$arrData.message[$key].period_time} {if $arrData.message[$key].flg_period == '1'}Hours{else}Days{/if}</span>
										{/if}
									</div>
								</div>
							</div>
						</div>
					</div>
					{/foreach}
					{/if}
				</div>
			</div>
		</div>
		
		<div class="form-group funnel_scratch" id="copy" {if empty($smarty.get.id)}style="display:none;"{/if}>
			<div class="radio radio-custom">
				<input type="radio" id="copy_0" checked="checked" />
				<label for="copy_0">Create from Scratch</label>
			</div>
			<div class="radio radio-custom">
				<input type="radio" id="copy_1" />
				<label for="copy_1">Copy Existing Message</label>
			</div>
		</div>
		
		<div class="form-group" data-type="broadcast" style="display: none;">
			<div class="checkbox checkbox-custom">
				<input type="hidden" class="form-control" name="arrData[options][flg_override]" value="0" />
				<input type="checkbox" class="form-control" name="arrData[options][flg_override]" value="1"{if isset($arrData.options.flg_override) && $arrData.options.flg_override == '1'} checked{/if} />
				<label for="flg_override">I certify that this is a transactional email</label>
			</div>
		</div>
		
		
		<div class="form-group copy-settings" style="display: none;">
			<select class="selectpicker ef-list m-r-5" data-style="btn-info">
				<optgroup label="Custom">{foreach from=$arrEFunnels item=v}<option value="{$v.id}">{$v.title}</option>{/foreach}</optgroup>
				<optgroup label="Funnels">{foreach from=$arrTemplatesEF item=v}<option value="{$v.id}">{$v.title}</option>{/foreach}</optgroup>
			</select>
			<select class="selectpicker messages-list" data-style="btn-info"></select>
		</div>
		
		<div class="form-group funnel_scratch" id="add_new" {if empty($smarty.get.id)}style="display:none;"{/if}>
			<button type="button" class="btn btn-success waves-effect waves-light" id="add_message">Add new message</button>
			<input type="hidden" name="arrData[flg_template]" value="2" />
		</div>

		<div id="message-fields"{if empty($arrData)} style="display: none;"{/if}>
			<div class="form-group">
				<label>Title</label>
				<input type="text" class="form-control" name="arrData[title]" value="{$arrData.title}" />
			</div>
			<div class="form-group">
				<label>Tags</label>
				<input type="text" class="form-control" name="arrData[options][tags]" value="{$arrData.options.tags}" />
			</div>
			{if Core_Acs::haveAccess( array( 'Email funnels' ) )}
			<div class="form-group">
				<div class="checkbox checkbox-custom">
					<input type="hidden" class="form-control" name="arrData[options][flg_resender]" value="0" />
					<input type="checkbox" class="form-control" name="arrData[options][flg_resender]" id="flg_resender" value="1"{if !isset($arrData.options.flg_resender) || $arrData.options.flg_resender == '1'} checked{/if} />
					<label for="flg_resender" id="flg_resender_label">{if !isset( $arrData.options.type ) || $arrData.options.type == 1}Resend to non openers in xx hours{else}Resend once to non openers before moving them to the next step{/if}</label>
				</div>
			</div>
			<div id="resender_timer" class="flg_resender_box form-group"{if ( !isset($arrData.options.flg_resender) || $arrData.options.flg_resender == '1' ) && $arrData.options.type!=2}{else} style="display:none;"{/if}>
				<label>Resend time</label>
				<input type="number" class="form-control" name="arrData[options][resender_time]" value="{$arrData.options.resender_time|default:24}" min="1" />
			</div>
			{/if}
		</div>
		{if Core_Acs::haveAccess( array( 'email test group', 'Validate' ) )}
		<div class="form-group">
			<div class="checkbox checkbox-custom">
				<input type="hidden" class="form-control" name="arrData[options][validation_realtime]" value="0" />
				<input type="checkbox" class="form-control" name="arrData[options][validation_realtime]" value="1" {if Project_Validations_Realtime::check( Core_Users::$info['id'], Project_Validations_Realtime::EMAIL_FUNNEL, $arrData.id )} checked{/if} />
				<label for="validation_realtime">Enable Real Time Email Validation</label>
			</div>
		</div>
		{/if}
		<div class="form-group">
			<label>Select the SMTP integration to use with this funnel</label>&nbsp;
			{if !empty($arrSMTP)}
			<select class="selectpicker" name="arrData[smtp_id]">
			{foreach $arrSMTP as $item}
				<option value="{$item.id}"{if $arrData.smtp_id==$item.id} selected="selected"{/if}>{$item.title} [{if $item.flg_active=='1'}ACTIVE{else}INACTIVE{/if}]</option>
			{/foreach}
			</select>
			{else}
			<a href="{url name='email_funnels' action='frontend_settings'}" class="btn btn-default waves-effect waves-light">Add SMPT integration</a>
			{/if}
		</div>
		<div class="form-group">
			<button type="submit" class="btn btn-success waves-effect waves-light" id="save_button" {if empty($smarty.get.id)}disabled=""{/if}>Save</button>
			<button type="submit" class="btn btn-success waves-effect waves-light" id="save_button2" name="action_menu" value="send" {if empty($smarty.get.id)}disabled=""{/if}>Save & Exit</button>
			{if Core_Acs::haveAccess( array('email test group') )}<button type="submit" class="btn btn-success waves-effect waves-light" id="save_button2_tpl" name="action_menu" value="template" {if empty($smarty.get.id)}disabled=""{/if}>Save as template</button>{/if}
			<a href="#" class="btn btn-success waves-effect waves-light" data-toggle="modal" data-target=".bs-example-modal-lg" {if empty($arrData.id)}style="display: none;"{/if}>Preview</a>
		</div>
	</form>
</div>

<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title pull-left" id="myLargeModalLabel">Preview</h4>
                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">×</button>
            </div>
			
            <div class="modal-body"></div>
        </div>
    </div>
</div>

<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" href="/skin/_js/jquery-ui/jquery-ui.css">
<script type="text/javascript" src="/skin/_js/jquery-ui/jquery-ui.js"></script>
{literal}
<script type="text/javascript">
	var ckeditorCopyProphetLink='{/literal}{url name="site1_accounts" action="copyprophet_ajax"}{literal}';
	var sendEmailNowTest='{/literal}{url name="email_funnels" action="request"}{literal}';
	
	$$('.delete-subject').addEvent('click',function(e){
		jQuery( e.target )[0].getParent('p.main_subject_block').destroy();
	});
	if( $('flg_resender') !== null ){
		$('flg_resender').addEvent('change',function(e){
			if( (( jQuery('#type_0').length>0 && jQuery('#type_0')[0].checked )
				|| jQuery('#type_0').length==0 )
				&& $$('[name="arrData[type]"]')[0].value!=2
			){
				if( e.target.checked ){
					$$('.flg_resender_box').show();
				}else{
					$$('.flg_resender_box').hide();
				}
			}
		});
	}
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
	
	var cpfunctions={
		hexnib: function ( d ){
			if( d < 10 ) { 
				return d; 
			} else {
				return String.fromCharCode( 65 + d - 10 );
			}
		},
		hexcode: function( url ){
			var result="";
			for( var i=0; i < url.length; i++ ){
				var cc=url.charCodeAt(i);
				var hex= this.hexnib((cc&240)>>4)+""+this.hexnib(cc&15);
				result+=hex;
			}
			return result;		
		},
		convertHtmlToText: function ( returnText ) {
			returnText=returnText.replace(/<br*>/gi, "\n");
			returnText=returnText.replace(/<p*>/gi, "\n");
			returnText=returnText.replace(/<a*href="(.*?)"*>(.*?)<\/a>/gi, " $2 ($1)");
			returnText=returnText.replace(/<script*>[\w\W]{1,}(.*?)[\w\W]{1,}<\/script>/gi, "");
			returnText=returnText.replace(/<style*>[\w\W]{1,}(.*?)[\w\W]{1,}<\/style>/gi, "");
			returnText=returnText.replace(/<(?:.|\s)*?>/g, "");
			returnText=returnText.replace(/(?:(?:\r\n|\r|\n)\s*){2,}/gim, "\n\n");
			returnText = returnText.replace(/ +(?= )/g,'');
			returnText=returnText.replace(/&#39;/gi,"'");
			returnText=returnText.replace(/&nbsp;/gi," ");
			returnText=returnText.replace(/&amp;/gi,"&");
			returnText=returnText.replace(/&quot;/gi,'"');
			returnText=returnText.replace(/&lt;/gi,'<');
			returnText=returnText.replace(/&gt;/gi,'>');
			return returnText;
		}
	};
	
	jQuery( '.bs-example-modal-lg' ).on( 'show.bs.modal', function(e) {
		jQuery( '.modal-body' ).empty();
		jQuery( '.modal-body' ).append( '<div class="message"><div class="message"><input type="email" class="form-control" id="send_to_email" value="" placeholder="Provide email address to send test email to" /></div></div>' );
	  	Object.keys( CKEDITOR.instances ).forEach( function( item ){
	  		var _message = CKEDITOR.instances[item].getData();
	  		var _subject = jQuery(jQuery('#subject_'+jQuery('#'+item).attr('rel'))[0]).prop( 'value' );
	  		var _textplan = jQuery(jQuery('#body_plain_text_'+jQuery('#'+item).attr('rel'))[0]).prop( 'value' );
	  		jQuery( '[data-replace]' ).each( function(){
				_message = _message.replace( new RegExp( '%%%', 'g'), '%' );
				_message = _message.replace( new RegExp( '%%', 'g'), '%' );
	  			_message = _message.replace( new RegExp( jQuery( this ).data( 'replace' ), 'g'), jQuery( this ).prop( 'value' ) );
				_textplan = _textplan.replace( new RegExp( '%%%', 'g'), '%' );
				_textplan = _textplan.replace( new RegExp( '%%', 'g'), '%' );
	  			_textplan = _textplan.replace( new RegExp( jQuery( this ).data( 'replace' ), 'g'), jQuery( this ).prop( 'value' ) );
				_subject = _subject.replace( new RegExp( '%%%', 'g'), '%' );
				_subject = _subject.replace( new RegExp( '%%', 'g'), '%' );
	  			_subject = _subject.replace( new RegExp( jQuery( this ).data( 'replace' ), 'g'), jQuery( this ).prop( 'value' ) );
	  		} );
			var cp_length=jQuery( '.modal-body .message' ).length;
			jQuery( '.modal-body' ).append( '<div class="message">\
				Score: <span class="score_'+cp_length+'"></span>&nbsp;<a href="#cp" class="cp_test_'+cp_length+'" >Click Here</a>\
				<br/><a href="#sendnow" class="btn btn-success waves-effect waves-light sendnow_'+cp_length+'" >Send Test Email</a>&nbsp;\
				<p class="sendnowtext_'+cp_length+'" style="display:none;color:green;">Test email was sent. Check your inbox!</p>\
				<p class="emailerror_'+cp_length+'" style="display:none;color:red;">No email provided. Input your email address</p>\
				<div class="cp_subject_'+cp_length+'">'+_subject+'</div>\
				<div class="cp_body_'+cp_length+'">'+_message+'</div>\
				</div>' );
			jQuery('.cp_test_'+cp_length).click(function(){
				var stringData=_subject+' '+_message;
				if( typeof ckeditorCopyProphetLink == 'undefined' ){
					return false;
				}
				new Request({
					url: ckeditorCopyProphetLink,
					method: 'post',
					data:"s="+cpfunctions.hexcode( stringData ),
					onSuccess: function( score ){
						jQuery('.score_'+cp_length).html( score );
					}
				}).send();
			});
			jQuery('.sendnow_'+cp_length).click(function(){
				jQuery('.sendnowtext_'+cp_length).hide();
				jQuery('.emailerror_'+cp_length).hide();
				if( typeof sendEmailNowTest == 'undefined' ){
					return false;
				}
				if( jQuery('#send_to_email').prop('value') == '' ){
					jQuery('.emailerror_'+cp_length).show();
					return false;
				}
				new Request({
					url: sendEmailNowTest,
					method: 'post',
					data: {
						'action': 'send_test_email',
						'campaign': jQuery("#autosave_form").serialize(),
						'email': jQuery('#send_to_email').prop('value'),
						'subject':_subject,
						'text':_message,
						'textplan':_textplan,
					},
					onSuccess: function(){
						jQuery('.sendnowtext_'+cp_length).show();
					}
				}).send();
			});
		});
	});

	jQuery( "#accordion" ).sortable({
		connectWith: ".connectedSortable",
		placeholder: "ui-state-highlight form-group"
	});

	jQuery( "#accordion" ).bind( "sortstop", function( event, ui ){
		CKEDITOR.instances['body_html_' + jQuery( ui.item ).data( 'message' )].updateElement();
		delete CKEDITOR.instances['body_html_' + jQuery( ui.item ).data( 'message' )];
		jQuery( '#body_html_' +  jQuery( ui.item ).data( 'message' )).next().remove();
		CKEDITOR.replace( 'body_html_' + jQuery( ui.item ).data( 'message' ), {
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

		jQuery( '#accordion [data-message]' ).each( function( _index, item ){
			jQuery( item ).find( '[name*="[position]"]' ).prop( 'value', _index+1 );
			if( _index == 0 ){
				jQuery( item ).find( '[name*="[flg_period]"]' ).find( 'option' ).removeAttr( 'selected' ).eq(0).attr( 'selected', 'selected' );
				jQuery( item ).find( '[name*="[period_time]"]' ).prop( 'value', '' );
				jQuery( item ).find( '[data-type="sequence"]' ).hide();
			} else if( jQuery( item ).find( '[name*="[flg_period]"]' ).prop( 'value' ) == 0 || jQuery( item ).find( '[name*="[period_time]"]' ).prop( 'value' ) == '' ) {
				jQuery( item ).find( '[name*="[flg_period]"]' ).prop( 'value', 2 );
				jQuery( item ).find( '[name*="[period_time]"]' ).prop( 'value', 1 );
				jQuery( item ).find( '[data-type="sequence"]' ).show();

				jQuery( item ).find( '.label.label-info' ).html( jQuery( item ).find( '[name*="[period_time]"]' ).prop( 'value' ) + ' ' + ( jQuery( item ).find( '[name*="[flg_period]"]' ).prop( 'value' ) == 1 ? 'Hours' : 'Days' ) );
			}
		});
		jQuery( '.selectpicker' ).selectpicker('refresh');
	});

var ef = {/literal}{json_encode(array_merge($arrEFunnels,$arrTemplatesEF))}{literal};
var autoSavePeriod=60000;
var EfunnelsId={/literal}{if isset($arrData.id)}{$arrData.id}{else}false{/if}{literal};
var autoSave=function(){
	var flgRun=true;
	if( jQuery('.check_required').length == 0 ){
		flgRun=false;
	}
	jQuery('.check_required').each(function(){
		if( jQuery(this).prop( 'value' ) == '' ){
			flgRun=false;
		}
	});
	if( EfunnelsId != false || flgRun == true ){
		Object.keys( CKEDITOR.instances ).forEach( function( item ){
			jQuery( '#' + CKEDITOR.instances[item].name ).prop( 'value', CKEDITOR.instances[item].getData() );
		});
		jQuery("#save_button").html('Saving...');
		jQuery("#save_button2").html('Saving...');
		jQuery("#autosave_flag").prop( 'value', 1 );
		jQuery.ajax({
			type: "POST",
			url: '',
			data: jQuery("#autosave_form").serialize(),
			success: function(data){
				jQuery("#autosave_flag").prop( 'value', 0 );
				data=JSON.decode( data );
				jQuery('#set_id').prop( 'value', data.id );
				EfunnelsId=data.id;
				var keys = Object.keys( data.message );
				keys.forEach( function( item, i ){
					jQuery('#mess_id_'+data.message[item].from_id).prop( 'value', data.message[item].id );
				});
				jQuery("#save_button").html('Saved');
				jQuery("#save_button2").html('Saved');
				setTimeout(function(){
					jQuery("#save_button").html('Save');
					jQuery("#save_button").html('Save & Exit');
				}, 5000);
			},
			error: function(data){
				jQuery("#save_button").html('Save');
				jQuery("#save_button2").html('Save & Exit');
			}
		});
	}
	setTimeout(function(){ autoSave(); }, autoSavePeriod);
}
var index={/literal}{$index_message}{literal};
window.addEvent('domready', function(){
	multibox=new CeraBox( $$('.popup_mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	{/literal}{if !empty($arrData)}{literal}
	for(var i = 0; i < index; i++){
		CKEDITOR.replace( 'body_html_' + i, {
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
	setTimeout(function(){ autoSave(); }, autoSavePeriod);
});

var changeTagsValue=function( tagId ){
	var arrLinks=[];
	jQuery( '.tags_values_'+tagId ).each( function(){
		arrLinks.push( jQuery(this).prop('value') );
	});
	jQuery( '#hidden_field_'+tagId ).prop('value', arrLinks.join('|'));
}

var checkHashTags=function(){
	var hashTags=new Array();
	jQuery( '.body-plain-text' ).each( function(){
		var arrMatch=jQuery( this ).prop( 'value' ).match(/%([0-9A-Za-z_]*?)%/g);
		if( arrMatch != null ){
			for ( k= 0;k<arrMatch.length;k++ ){
				var flgAddNew=true;
				for ( i=0;i<hashTags.length;i++ ){
					if( hashTags[i]==arrMatch[k] ){
						flgAddNew=false;
					}
				}
				if( flgAddNew ){
					hashTags.push( arrMatch[k] );
				}
			}
		}
	});
	Object.keys( CKEDITOR.instances ).forEach( function( item, key ){
		var arrMatch=CKEDITOR.instances[item].getData().match(/%([0-9A-Za-z_]*?)%/g);
		if( arrMatch != null ){
			for ( k= 0;k<arrMatch.length;k++ ){
				var flgAddNew=true;
				for ( i=0;i<hashTags.length;i++ ){
					if( hashTags[i]==arrMatch[k] ){
						flgAddNew=false;
					}
				}
				if( flgAddNew ){
					hashTags.push( arrMatch[k] );
				}
			}
		}
	});

	jQuery( '[data-hashtag]' ).each( function(){
		let _str = jQuery( this ).prop( 'value' ) !== undefined ? jQuery( this ).prop( 'value' ) : jQuery( this ).text();
		var arrMatch=_str.match(/%([0-9A-Za-z_]*?)%/g);
		if( arrMatch != null ){
			for ( k= 0;k<arrMatch.length;k++ ){
				var flgAddNew=true;
				for ( i=0;i<hashTags.length;i++ ){
					if( hashTags[i]==arrMatch[k] ){
						flgAddNew=false;
					}
				}
				if( flgAddNew ){
					hashTags.push( arrMatch[k] );
				}
			}
		}
	} );

	var addHtml='',tags={/literal}{json_encode($arrData.options)}{literal};
	jQuery( '.funnel_select_show' ).remove();
	for ( i=0;i<hashTags.length;i++ ){
		var nameTag=hashTags[i].replace( /%/g, '' );
		if( nameTag == '' ){
			continue;
		}
		nameTag=nameTag.replace( /_/g, ' ' );
		nameTag=nameTag.toLowerCase();
		var f=nameTag.charAt(0).toUpperCase();
		var nameUFTag=f+nameTag.substr(1, nameTag.length-1);
		nameTag=nameTag.replace( /\s/g, '_' );

		jQuery( '#message-fields' ).show();
		if( jQuery( '#label_tags_'+nameTag ).length == 0 ){
			var strTags=( tags !== null && tags[nameTag] !== undefined ? tags[nameTag] : '' );
			var arrTags=strTags.split('|');
			jQuery( '<div></div>',{
				id: 'label_tags_'+nameTag,
				'class':'funnel_select_show'
			}).appendTo('#message-fields');
			jQuery( '<label></label>',{
				html: nameUFTag
			}).appendTo('#label_tags_'+nameTag);
			jQuery( '<p></p>',{
				'class': 'main_subject_block main_subject_block_'+i,
				id: 'random_hash_'+i,
			}).appendTo('#label_tags_'+nameTag);
			jQuery( '<input>',{
				id: 'hidden_field_'+i,
				type: 'hidden',
				name: 'arrData[options]['+nameTag+']',
				value: strTags
			}).appendTo('#random_hash_'+i);
			
			// тут цикл на формирование списка отдельных полей
			for ( t=0;t<arrTags.length;t++ ){
				jQuery( '<p></p>',{
					'class': 'main_subject_block main_subject_input_'+i+'_'+t,
					id: 'random_input_'+i+'_'+t,
				}).appendTo('#label_tags_'+nameTag);
				jQuery( '<input>',{
					'data-tagid' : i,
					'class': 'medium-input text-input form-control main_subject tags_values_'+i,
					type: 'text',
					value: arrTags[t]
				}).change(function(){
					changeTagsValue( jQuery(this).data('tagid') );
				}).appendTo('#random_input_'+i+'_'+t);
				if( t==0 ){
					jQuery( '<a></a>',{
						style: 'font-size: 24px;',
						href: '#',
						html: '+',
						'data-tagid' : i,
						'data-randomid' : t,
						'data-tagname' : nameTag,
					})
					.appendTo('#random_input_'+i+'_'+t)
					.click(function(){
						if( jQuery( '.tags_values_'+jQuery(this).data('tagid') ).length==8 ){
							jQuery(this).hide();
						}
						var scrollTop=jQuery(window).scrollTop();
						var newT=jQuery( '.tags_values_'+jQuery(this).data('tagid') ).length-1;
						jQuery( '<p></p>',{
							'class': 'main_subject_block main_subject_input_'+jQuery(this).data('tagid')+'_'+newT,
							id: 'random_input_'+jQuery(this).data('tagid')+'_'+newT,
						}).appendTo('#label_tags_'+jQuery(this).data('tagname'));
						jQuery( '<input>',{
							'data-tagid' : jQuery(this).data('tagid'),
							'class': 'medium-input text-input form-control main_subject tags_values_'+jQuery(this).data('tagid'),
							type: 'text',
							value: arrTags[t]
						}).change(function(){
							changeTagsValue( jQuery(this).data('tagid') );
						}).appendTo('#random_input_'+jQuery(this).data('tagid')+'_'+newT);
						jQuery( '<a></a>',{
							'class': 'delete-subject',
							style: 'font-size: 24px;',
							href: '#',
							html: '-',
							'data-tagid' : jQuery(this).data('tagid'),
							'data-randomid' : newT,
						}).click(function(){
							var scrollTop2=jQuery(window).scrollTop();
							jQuery('.main_subject_input_'+jQuery(this).data('tagid')+'_'+jQuery(this).data('randomid')).remove();
							changeTagsValue( jQuery(this).data('tagid') );
							jQuery('html,body').animate({
								scrollTop: scrollTop2
							}, 1);
						}).appendTo('#random_input_'+jQuery(this).data('tagid')+'_'+newT);
						jQuery('html,body').animate({
							scrollTop: scrollTop
						}, 1);
					});
				}else{
					jQuery( '<a></a>',{
						'class': 'delete-subject',
						style: 'font-size: 24px;',
						href: '#',
						html: '-',
						'data-tagid' : i,
						'data-randomid' : t,
					}).click(function(){
						var scrollTop2=jQuery(window).scrollTop();
						jQuery('.main_subject_input_'+jQuery(this).data('tagid')+'_'+jQuery(this).data('randomid')).remove();
						changeTagsValue( jQuery(this).data('tagid') );
						jQuery('html,body').animate({
							scrollTop: scrollTop2
						}, 1);
					}).appendTo('#random_input_'+i+'_'+t);
				}
			}
			// закончим цикл
			

		}
	}

	/*jQuery( '[data-replace]' ).on( 'change', function(){
		if( jQuery( this ).prop( 'value' ) == '' ) return;
		var self = this;
		jQuery( '.body-plain-text' ).each( function(){
			jQuery( this ).prop( 'value', jQuery( this ).prop( 'value' ).replace( new RegExp( jQuery( self ).data( 'replace' ), 'g') , jQuery( self ).prop( 'value' ) ) );
		});
		Object.keys( CKEDITOR.instances ).forEach( function( item, key ){
			CKEDITOR.instances[item].setData( CKEDITOR.instances[item].getData().replace( new RegExp( jQuery( self ).data( 'replace' ), 'g'), jQuery( self ).prop( 'value' ) ) );
		});
	});*/
}

var position={/literal}{count($arrData.message)}{literal};
var addNewMessage=function( flgFirst=false ){
	var indexp=index+1;
	position++;
	jQuery( '#accordion' ).append(
		'<div class="panel-group funnel_scratch'+( ( !flgFirst ) ? ' panel_box_all_delete panel_box_' +indexp+ '' : '' )+'" data-message="' +indexp+ '">' +
			'<div class="panel panel-default">' +
				'<div class="panel-heading" id="heading_' +index+ '">' +
					'<h6 class="panel-title m-t-3 pull-left w-97">' +
						'<a href="#collapse_' +indexp+ '" class="text-dark collapsed" data-toggle="collapse" data-hashtag="" aria-expanded="false" aria-controls="collapse_' +indexp+ '" style="display:inline;width:80%;">'+
							'<input type="hidden" name="arrData[message][' + indexp + '][from_id]" value="' + indexp + '" />' +
							'<input type="text" class="form-control check_required" name="arrData[message][' +indexp+ '][name]" value="" style="max-width: 20%;display:inline;" placeholder="Name #' +indexp+ '" />'+
						'</a>'+
						'<input type="hidden" class="form-control" id="mess_id_' +indexp+ '" name="arrData[message][' +indexp+ '][id]" value="" />' +
						'<input type="hidden" name="arrData[message][' +indexp+ '][position]" value="'+position+'">'+
					'</h6>' +
					{/literal}{if Core_Acs::haveAccess( array( 'Email funnels' ) )}{literal}
					'<a href="#" class="pull-left w-3-20 text-right btn-delete" title="Delete message" '+( ( flgFirst )?' style="display:none;"':'' )+'><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>' + 
					{/literal}{/if}{literal}
				'</div>' +
				'<div id="collapse_' +indexp+ '" class="panel-collapse collapse" aria-labelledby="headingOne" data-parent="#accordion" style="">' +
					'<div class="panel-body">' +
						'<div class="form-group">'+
							'<label>Subject</label><br />'+
							'<input type="text" name="arrData[message][' +indexp+ '][subject][]" data-hashtag="" id="subject_' + indexp + '" class="main_subject form-control check_required" value="" />'+
							{/literal}{if ( !Core_Acs::haveAccess( array( 'Broadcasts' ) ) && !Core_Acs::haveAccess( array( 'Email Funnels No Testing' ) ) ) || Core_Acs::haveAccess( array( 'Email funnels' ) ) }{literal}
							'<a href="#" style="font-size: 24px;" class="multi-subject multi-subject-"' +indexp+ '" data-key="' +indexp+ '">+</a>'+
							{/literal}{/if}{literal}
						'</div>'+
						'<div class="form-group"><label>Body HTML</label><textarea class="form-control" name="arrData[message][' +indexp+ '][body_html]" id="body_html_' + indexp + '" rel="' + indexp + '"></textarea></div>' +
						'<div class="form-group"><label>Body Plain Text</label><textarea class="form-control body-plain-text" name="arrData[message][' +indexp+ '][body_plain_text]" ></textarea></div>' +
						'<div data-type="sequence"'+( jQuery('[name="arrData[type]"]:checked').prop( 'value' ) == 1 && flgFirst ?'  style="display: none;"': '' )+' class="form-group">'+
							'<label>Wait Period</label>'+
							'<div>' +
								'<select name="arrData[message][' +indexp+ '][flg_period]" class="selectpicker" data-style="btn-info">' +
									'<option value="0">- select -</option>'+
									'<option value="1">Hours</option>' +
									'<option value="2"'+(!flgFirst?'selected="selected"':'')+'>Days</option>' +
								'</select>'+
								'<input type="text" name="arrData[message][' +indexp+ '][period_time]" class="form-control m-l-15 vertical-middle" style="display: inline-block; width: 500px;" value="'+(!flgFirst?1:'')+'"/>' +
							'</div>' +
						'</div>'+
					'</div>'+
				'</div>' +
			'</div>' +
		'</div>'
	);
	$$('.multi-subject-="'+indexp).addEvent('click',function(e){
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
	if( jQuery( '#copy_1' ).prop( 'checked' ) ){
		var _messageIndex = jQuery( '.messages-list' ).prop( 'value' );
		switch( jQuery( 'select.ef-list' ).prop( 'value' ) ){
			case 'current':
				jQuery( '[name="arrData[message][' +indexp+ '][name]"]' ).prop( 'value', jQuery( '[name="arrData[message][' +_messageIndex+ '][name]"]' ).prop( 'value' ) );
				jQuery( '[name="arrData[message][' +indexp+ '][subject][]"]' ).prop( 'value', jQuery( '[name="arrData[message][' +_messageIndex+ '][subject]"]' ).prop( 'value' ) );
				jQuery( '[name="arrData[message][' +indexp+ '][body_html]"]' ).prop( 'value', CKEDITOR.instances['body_html_' + _messageIndex ].getData() );
				jQuery( '[name="arrData[message][' +indexp+ '][body_plain_text]"]' ).prop( 'value', jQuery( '[name="arrData[message][' +_messageIndex+ '][body_plain_text]"]' ).prop( 'value' ) );
				jQuery( '[name="arrData[message][' +indexp+ '][flg_period]"]' ).prop( 'value', jQuery( '[name="arrData[message][' +_messageIndex+ '][flg_period]"]' ).prop( 'value' ) );
				jQuery( '[name="arrData[message][' +indexp+ '][period_time]"]' ).prop( 'value', jQuery( '[name="arrData[message][' +_messageIndex+ '][period_time]"]' ).prop( 'value' ) );
			break;
			default:
				ef.forEach( function( _ef ) {
					if( _ef.id == jQuery( 'select.ef-list' ).prop( 'value' ) ){
						_ef.message.forEach( function( _message ) {
							if( _message.id == _messageIndex ){
								jQuery( '[name="arrData[message][' +indexp+ '][name]"]' ).prop( 'value', _message.name );
								jQuery( '[name="arrData[message][' +indexp+ '][subject][]"]' ).prop( 'value', _message.subject );
								jQuery( '[name="arrData[message][' +indexp+ '][body_html]"]' ).prop( 'value', _message.body_html );
								jQuery( '[name="arrData[message][' +indexp+ '][body_plain_text]"]' ).prop( 'value', _message.body_plain_text );
								jQuery( '[name="arrData[message][' +indexp+ '][flg_period]"]' ).prop( 'value', _message.flg_period );
								jQuery( '[name="arrData[message][' +indexp+ '][period_time]"]' ).prop( 'value', _message.period_time );
							}
						} );
					}
				} );

			break;
		}
	}
	jQuery( '.selectpicker' ).selectpicker();
	CKEDITOR.replace( 'body_html_' + indexp, {
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
	if( !flgFirst ){
		jQuery('.panel_box_delete').click(function(){
			var self = this;
			jQuery( '.panel_box_' +jQuery( self ).data( 'id' ) ).remove();
		});
	}
	index=indexp+1;
	jQuery( '.btn-delete' ).off( 'click' ).on( 'click', function(){
		jQuery( this ).parent().parent().parent().fadeOut( 'fast', function(){ 
			jQuery( this ).remove(); 
		} );
		return false;
	} );

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
}
jQuery( '#copy input[type=radio]' ).on( 'click', function(){
	jQuery( '#copy input[type=radio]' ).prop( 'checked', false );
	jQuery( this ).prop( 'checked', true );
	switch( jQuery( this ).prop( 'id' ) ){
		case 'copy_0':
			jQuery( '.copy-settings' ).hide();
		break;
		case 'copy_1':
			jQuery( '.copy-settings' ).show();
			jQuery( 'select.messages-list' ).html( '' );
			jQuery( '[data-message]' ).each( function(){
				var _messageIndex = jQuery( this ).data( 'message' );
				var _messageName = ( jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) !== '' ? jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) : 'Name #' + jQuery( this ).data( 'message' ) );
				jQuery( 'select.messages-list' ).append( '<option value="' + jQuery( this ).data( 'message' ) + '">' + _messageName + '</option>' );
			} );
		break;
	}
	jQuery('.selectpicker').selectpicker('refresh');
});
jQuery( '.ef-list' ).on( 'change', function(){
	var self = this;
	jQuery( 'select.messages-list' ).empty();
	if( jQuery( this ).prop( 'value' ) == 'current' ){
		jQuery( '[data-message]' ).each( function(){
			var _messageIndex = jQuery( this ).data( 'message' );
			var _messageName = ( jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) !== '' ? jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) : 'Name #' + jQuery( this ).data( 'message' ) );
			jQuery( 'select.messages-list' ).append( '<option value="' + jQuery( this ).data( 'message' ) + '">' + _messageName + '</option>' );
		} );
	} else 
		ef.forEach( function( item ) {
			if( item.id == jQuery( self ).prop( 'value' ) ){
				item.message.forEach( function( message, i ) {
					jQuery( 'select.messages-list' ).append( '<option value="'+message.id+'">' + message.name + '</option>' );
				} );
			}
		});
	jQuery('.selectpicker').selectpicker('refresh');
} );
jQuery('#add_message').click(function(){
	addNewMessage();
	checkHashTags();
});
jQuery( '.btn-delete' ).off( 'click' ).on( 'click', function(){
	jQuery( '#funnel_settings' ).before( '<input type="hidden" name="arrData[delete_message][]" value="'+jQuery( this ).parent().parent().parent().find('.get_for_delete')[0].value+'" />' );
	jQuery( this ).parent().parent().parent().fadeOut( 'fast', function(){ 
		jQuery( this ).remove(); 
	} );
	return false;
} );
jQuery('#new_efunnel').click(function(){
	var currentEf = {/literal}{json_encode($arrData)}{literal};
	var flgAccessBroadcast={/literal}{if !Core_Acs::haveAccess( array( 'Broadcasts' ) ) }true{else}false{/if}{literal};
	var flgAccessSplitSubject={/literal}{if ( !Core_Acs::haveAccess( array( 'Broadcasts' ) ) && !Core_Acs::haveAccess( array( 'Email Funnels No Testing' ) ) ) || Core_Acs::haveAccess( array( 'Email funnels' ) ) }true{else}false{/if}{literal};
	if( currentEf !== null ){
		position = Object.keys( currentEf.message ).length;
		index = Object.keys( currentEf.message ).length;
	}
	removeOldMessages( ( currentEf !== null ? false : true ) );
	jQuery( '#copy,#add_new,.copy-settings' ).remove();
	jQuery( '.select_type' ).remove();
	jQuery( '.funnel_scratch' ).remove();
	if( currentEf === null ){
	var disablSequence='';
		if( flgAccessBroadcast!=true ){
			disablSequence=' disabled ';
		}
		jQuery( '#funnel_settings' ).before(
			'<div class="form-group funnel_scratch select_type">'+
				'<label for="type">Type:</label>'+
				'<div class="radio radio-custom">'+
					'<input type="radio" id="type_0" name="arrData[type]" value="1" checked="" />'+
					'<label for="type_0">Broadcast</label>'+
				'</div>'+
				'<div class="radio radio-custom">'+
					'<input type="radio" id="type_1" name="arrData[type]" '+disablSequence+'value="2" />'+
					'<label for="type_1">Sequence</label>'+
				'</div>'+
			'</div>'
		);	
	} else {
		jQuery( '#funnel_settings' ).before(
			'<div class="form-group funnel_scratch select_type">'+
				'<label for="type">Type:</label>'+
				'<div class="radio radio-custom">'+
					'<input type="radio" id="type_0" name="arrData[type]" value="1" ' + ( currentEf.type == 1 ? 'checked=""' : '' ) + ' />'+
					'<label for="type_0">Broadcast</label>'+
				'</div>'+
				'<div class="radio radio-custom">'+
					'<input type="radio" id="type_1" name="arrData[type]" value="2" ' + ( currentEf.type == 2 ? 'checked=""' : '' ) + ' />'+
					'<label for="type_1">Sequence</label>'+
				'</div>'+
			'</div>'
		);
	}
	jQuery('#type_1, #type_0').change(function(){
		if( jQuery('#type_0').length>0 && jQuery('#type_0')[0].checked ){
			jQuery('#flg_resender_label').html('Resend to non openers in xx hours');
			jQuery('#resender_timer').show();
			jQuery('#resender_timer').find('input').attr('value', 1);
		}else if ( jQuery('#type_1').length>0 && jQuery('#type_1')[0].checked ){ // Sequence
			jQuery('#flg_resender_label').html('Resend once to non openers before moving them to the next step');
			jQuery('#resender_timer').hide();
			jQuery('#resender_timer').find('input').attr('value', 24);
		}
	});
	jQuery( '#funnel_settings' ).after(
		'<div class="form-group funnel_scratch" id="copy"' + (currentEf === null || currentEf.type == 1 ? ' style="display: none;"' : '' ) + '>'+
			'<div class="radio radio-custom">'+
				'<input type="radio" id="copy_0" checked="" />'+
				'<label for="copy_0">Create from Scratch</label>'+
			'</div>'+
			'<div class="radio radio-custom">'+
				'<input type="radio" id="copy_1" />'+
				'<label for="copy_1">Copy Existing Message</label>'+
			'</div>'+
		'</div>'
	);
	jQuery( '#copy input[type=radio]' ).on( 'click', function(){
		jQuery( '#copy input[type=radio]' ).prop( 'checked', false );
		jQuery( this ).prop( 'checked', true );
		switch( jQuery( this ).prop( 'id' ) ){
			case 'copy_0':
				jQuery( '.copy-settings' ).hide();
			break;
			case 'copy_1':
				jQuery( '.copy-settings' ).show();
				jQuery( 'select.messages-list' ).html( '' );
				jQuery( '[data-message]' ).each( function(){
					var _messageIndex = jQuery( this ).data( 'message' );
					var _messageName = ( jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) !== '' ? jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) : 'Name #' + jQuery( this ).data( 'message' ) );
					jQuery( 'select.messages-list' ).append( '<option value="' + jQuery( this ).data( 'message' ) + '">' + _messageName + '</option>' );
				} );
			break;
		}
		jQuery('.selectpicker').selectpicker('refresh');
	});
	jQuery( '#copy' ).after(
		'<div class="form-group copy-settings">'+
			'<select class="selectpicker ef-list m-r-5" data-style="btn-info">'+
				//'<option value="current">From This</option>'+
				{/literal}
				'<optgroup label="Custom">'+
				{foreach from=$arrEFunnels item=v}
				'<option value="{$v.id}">{$v.title|escape:"htmlall"}</option>'+
				{/foreach}
				'</optgroup>'+
				'<optgroup label="Funnels">' +
				{foreach from=$arrTemplatesEF item=v}
				'<option value="{$v.id}">{$v.title|escape:"htmlall"}</option>'+
				{/foreach}
				'</optgroup>'+
				{literal}
			'</select>'+
			'<select class="selectpicker messages-list" data-style="btn-info"></select>'+
		'</div>'
	);
	jQuery( '.ef-list' ).on( 'change', function(){
		var self = this;
		jQuery( 'select.messages-list' ).empty();
		if( jQuery( this ).prop( 'value' ) == 'current' ){
			jQuery( '[data-message]' ).each( function(){
				var _messageIndex = jQuery( this ).data( 'message' );
				var _messageName = ( jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) !== '' ? jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) : 'Name #' + jQuery( this ).data( 'message' ) );
				jQuery( 'select.messages-list' ).append( '<option value="' + jQuery( this ).data( 'message' ) + '">' + _messageName + '</option>' );
			} );
		} else 
			ef.forEach( function( item ) {
				if( item.id == jQuery( self ).prop( 'value' ) ){
					item.message.forEach( function( message, i ) {
						jQuery( 'select.messages-list' ).append( '<option value="'+message.id+'">' + message.name + '</option>' );
					} );
				}
			});
		jQuery('.selectpicker').selectpicker('refresh');
	} );
	if( jQuery( '#add_new' ).length == 0 ){
		jQuery( '.copy-settings' ).after(
			'<div class="form-group funnel_scratch" id="add_new"' + (currentEf === null || currentEf.type == 1 ? ' style="display: none;"' : '' ) + '>'+
				'<input type="button" class="btn btn-success waves-effect waves-light" id="add_message" value="Add new message" />'+
				'<input type="hidden" name="arrData[flg_template]" value="2" />'+
			'</div>'
		);
	}
	if( jQuery( '#update_message' ).length == 0 ){
		jQuery( '.copy-settings' ).after(
			'<div class="form-group" id="update_message">'+
				'<input type="button" class="btn btn-success waves-effect waves-light" id="update_message" value="Update Message" />'+
			'</div>'
		);
	}
	jQuery( '#message-fields' ).show();
	jQuery( '[data-type="broadcast"]' ).show();
	jQuery( '.funnel_select_show' ).remove();
	jQuery( 'input[name="arrData[type]"]' ).on( 'change', function(){
		if( jQuery(this).prop( 'value' ) == 2 ){
			jQuery( '#add_new' ).show();
			jQuery( '#copy' ).show();
			jQuery( '[data-type="sequence"]' ).show();
			jQuery( '[data-type="broadcast"]' ).hide();
			//jQuery( '[data-type="sequence"]' ).show();
			jQuery( '[data-index]' ).show();
			jQuery( 'select.ef-list' ).prepend( '<option value="current" selected="selected">From This</option>' );
			jQuery( '.copy-settings,#update_message' ).hide();
		} else {
			jQuery( 'select.ef-list option[value="current"]' ).remove().trigger( 'change' );
			jQuery( 'select.messages-list' ).empty();			
			jQuery( '#add_new,#copy' ).hide();
			jQuery( '[data-type="sequence"]' ).hide();
			jQuery( '[data-type="broadcast"]' ).show();
			if( jQuery('[data-message]' ).length > 1 ){
				console.log( jQuery('[data-message]' ).length );
				let _countMessage = jQuery('[data-message]' ).length - 1;
				for(let i = _countMessage; i > 0; i--){
					jQuery( '[data-message]' ).eq(i).remove();
				}
			}
			jQuery( '[data-index]' ).hide();
			jQuery( '[data-index="0"],#update_message' ).show();
			jQuery( '.copy-settings' ).show();
		}
		jQuery('.selectpicker').selectpicker('refresh');
	} );
	addNewMessage( ( currentEf !== null ? false : true ) );
	jQuery('#add_message').click(function(){
		addNewMessage();
		checkHashTags();
	});
	jQuery( '#update_message' ).off( 'click' ).on( 'click', function(){
		var _messageIndex = jQuery( '.messages-list' ).prop( 'value' );
		var _index = jQuery( '[data-message]' ).eq(0).data( 'message' );
		ef.forEach( function( _ef ) {
			if( _ef.id == jQuery( 'select.ef-list' ).prop( 'value' ) ){
				_ef.message.forEach( function( _message ) {
					if( _message.id == _messageIndex ){
						jQuery( '[name="arrData[message]['+_index+'][name]"]' ).prop( 'value', _message.name );
						jQuery( '[name="arrData[message]['+_index+'][subject][]"]' ).prop( 'value', _message.subject );
						jQuery( '[name="arrData[message]['+_index+'][body_html]"]' ).prop( 'value', _message.body_html );
						jQuery( '[name="arrData[message]['+_index+'][body_plain_text]"]' ).prop( 'value', _message.body_plain_text );
						CKEDITOR.instances['body_html_'+_index+''].setData( _message.body_html );
					}
				} );
			}
		} );
		checkHashTags();
	} );
	jQuery( 'button[type="submit"]' ).removeAttr( 'disabled' );
	
	return false;
});
var removeOldMessages=function(flg=true){
	// тут выборка message для удаления
	if( !flg ) return; 
	jQuery('.get_for_delete').each(function( index ){
		if( jQuery( this ).prop( 'value' ) != '' ){
			jQuery( '#funnel_settings' ).before( '<input type="hidden" name="arrData[delete_message][]" value="'+jQuery( this ).prop( 'value' )+'" />' );
		}
	});
	CKEDITOR.instances = {};
	jQuery( '.funnel_scratch' ).remove();
}
window.setTemplate = function( ef_id ){
	removeOldMessages();
	jQuery('#update_message').hide();
	EfunnelsId=ef_id;
	jQuery.post( "{/literal}{url name='email_funnels' action='request'}{literal}", { id : ef_id } ).done( function( data ){
		data = JSON.parse( data );
		/* Вывод message полученных для выбранного email funnel */
		var keys = Object.keys( data.message );
		keys.forEach( function( item, i ){
			jQuery( '#accordion' ).append(
				'<div class="panel-group funnel_scratch" data-message="' + item + '">' +
					'<div class="panel panel-default">' +
						'<div class="panel-heading" id="heading_' + i + '">' +
							'<h6 class="panel-title' + ( data.type == 2 ? ' m-t-3 w-97 pull-left' : '' ) + '">' +
								'<a href="#collapse_' + i + '" class="text-dark collapsed" data-hashtag="" data-toggle="collapse" aria-expanded="false" aria-controls="collapse_' + i + '">' + data.message[item].name + '</a>' +
								'<input type="hidden" class="form-control get_for_delete" id="mess_id_' + data.message[item].id + '" name="arrData[message][' + data.message[item].id + '][id]" value="" />' +
								'<input type="hidden" name="arrData[message][' + data.message[item].id + '][from_id]" value="' + data.message[item].id + '" />' +
								'<input type="hidden" name="arrData[message][' + data.message[item].id + '][name]" value="' + data.message[item].name + '" />'+
								'<input type="hidden" name="arrData[message][' + data.message[item].id + '][position]" value="' + data.message[item].position + '" />'+
							'</h6>' +
							{/literal}{if Core_Acs::haveAccess( array( 'Email funnels' ) )}{literal}
							( data.type == 2 ? '<a href="#" class="pull-left w-3-20 text-right btn-delete" title="Delete message"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>' : '' ) + 
							{/literal}{/if}{literal}
						'</div>' +
						'<div id="collapse_' + i + '" class="panel-collapse collapse" aria-labelledby="headingOne" data-parent="#accordion" style="">' +
							'<div class="panel-body">' +
								'<div class="form-group"><label>Subject</label><input type="text" class="main_subject form-control" data-hashtag="" id="subject_' + item + '" name="arrData[message][' + data.message[item].id + '][subject][]" value="' + data.message[item].subject + '" />' +
								{/literal}{if ( !Core_Acs::haveAccess( array( 'Broadcasts' ) ) && !Core_Acs::haveAccess( array( 'Email Funnels No Testing' ) ) ) || Core_Acs::haveAccess( array( 'Email funnels' ) ) }{literal}
								'<a href="#" style="font-size: 24px;" class="multi-subject-' + data.message[item].id + '" data-key="' + data.message[item].id + '">+</a>' +
								{/literal}{/if}{literal}
								'</div>' +
								'<div class="form-group"><label>Body HTML</label><textarea class="form-control" name="arrData[message][' + data.message[item].id + '][body_html]" id="body_html_' + item + '" rel="' + item + '">' + data.message[item].body_html + '</textarea></div>' +
								'<div class="form-group"><label>Body Plain Text</label><textarea class="form-control body-plain-text" name="arrData[message][' + data.message[item].id + '][body_plain_text]" >' + data.message[item].body_plain_text + '</textarea></div>' +
								'<div data-type="sequence"'+( data.type == 1 || i == 0 ?'  style="display: none;"': '' )+' class="form-group">'+
									{/literal}{if Core_Acs::haveAccess( array( 'Email funnels' ) )}{literal}
									'<label>Wait Period</label>'+
									'<select name="arrData[message][' + data.message[item].id + '][flg_period]" class="form-control">' +
										'<option value="0">- select -</option>'+
										'<option value="1"'+( data.message[item].flg_period == 1 ?' selected="selected"': '' )+'>Hours</option>' +
										'<option value="2"'+( data.message[item].flg_period == 2 ?' selected="selected"': '' )+'>Days</option>' +
									'</select>'+
									'<input type="text" name="arrData[message][' + data.message[item].id + '][period_time]" class="form-control" value="' + data.message[item].period_time + '" />' +
									{/literal}{else}{literal}
									'<input type="hidden" name="arrData[message][' + data.message[item].id + '][flg_period]" value="'+data.message[item].flg_period+'" />'+
									'<input type="hidden" name="arrData[message][' + data.message[item].id + '][period_time]" value="'+data.message[item].period_time+'" />'+
									'<label>Wait Period</label> '+
									'<span class="label label-info">' + data.message[item].period_time + ( data.message[item].flg_period == 1 ? ' Hours': ' Days' ) + '</span>' + 
									{/literal}{/if}{literal}
								'</div>'+
							'</div>'+
						'</div>' +
					'</div>' +
				'</div>'
			);
			$$('.multi-subject-' + data.message[item].id).addEvent('click',function(e){
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
			
			CKEDITOR.replace( 'body_html_' + item, {
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
			index = i;
			position = i;
			checkHashTags();
		} );
		index++;
		position++;
		jQuery( '[name="arrData[title]"]' ).prop( 'value', data.title );
		jQuery( '[name="arrData[type]"]' ).prop( 'value', data.type );
		jQuery( '#message-fields' ).slideDown( 'fast' ); 
		jQuery( 'button[type="submit"]' ).removeAttr( 'disabled' );
		jQuery( '[data-toggle="modal"]' ).show();
		
		checkHashTags();
		jQuery( '.btn-delete' ).off( 'click' ).on( 'click', function(){
			jQuery( this ).parent().parent().parent().fadeOut( 'fast', function(){ 
				jQuery( this ).remove(); 
			} );
			return false;
		} );
		{/literal}{if Core_Acs::haveAccess( array( 'Email Funnels Performance' ) )}{literal}
		if( data.type == 2 ){
			jQuery( '#copy,#add_new,.copy-settings' ).remove();
			jQuery( '#funnel_settings' ).after(
				'<div class="form-group funnel_scratch" id="copy">'+
					'<div class="radio radio-custom">'+
						'<input type="radio" id="copy_0" checked="" />'+
						'<label for="copy_0">Create from Scratch</label>'+
					'</div>'+
					'<div class="radio radio-custom">'+
						'<input type="radio" id="copy_1" />'+
						'<label for="copy_1">Copy Existing Message</label>'+
					'</div>'+
				'</div>'
			);
			jQuery( '#copy input[type=radio]' ).on( 'click', function(){
				jQuery( '#copy input[type=radio]' ).prop( 'checked', false );
				jQuery( this ).prop( 'checked', true );
				switch( jQuery( this ).prop( 'id' ) ){
					case 'copy_0':
						jQuery( '.copy-settings' ).hide();
					break;
					case 'copy_1':
						jQuery( '.copy-settings' ).show();
						jQuery( 'select.messages-list' ).html( '' );
						
						jQuery( '[data-message]' ).each( function(){
							var _messageIndex = jQuery( this ).data( 'message' );
							var _messageName = ( jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) !== '' ? jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) : 'Name #' + jQuery( this ).data( 'message' ) );
							jQuery( 'select.messages-list' ).append( '<option value="' + jQuery( this ).data( 'message' ) + '">' + _messageName + '</option>' );
						} );
					break;
				}
				jQuery('.selectpicker').selectpicker('refresh');
			});
			jQuery( '#copy' ).after(
				'<div class="form-group copy-settings">'+
					'<select class="selectpicker ef-list m-r-5" data-style="btn-info">'+
						//'<option value="current">From This</option>'+
						{/literal}
						'<optgroup label="Custom">'+
						{foreach from=$arrEFunnels item=v}
						'<option value="{$v.id}">{$v.title|escape:"htmlall"}</option>'+
						{/foreach}
						'</optgroup>'+
						'<optgroup label="Funnels">' +
						{foreach from=$arrTemplatesEF item=v}
						'<option value="{$v.id}">{$v.title|escape:"htmlall"}</option>'+
						{/foreach}
						'</optgroup>'+
						{literal}
					'</select>'+
					'<select class="selectpicker messages-list" data-style="btn-info"></select>'+
				'</div>'
			);
			jQuery( '.ef-list' ).on( 'change', function(){
				var self = this;
				jQuery( 'select.messages-list' ).empty();
				if( jQuery( this ).prop( 'value' ) == 'current' ){
					jQuery( '[data-message]' ).each( function(){
						var _messageIndex = jQuery( this ).data( 'message' );
						var _messageName = ( jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) !== '' ? jQuery( '[name="arrData[message]['+_messageIndex+'][name]"]' ).prop( 'value' ) : 'Name #' + jQuery( this ).data( 'message' ) );
						jQuery( 'select.messages-list' ).append( '<option value="' + jQuery( this ).data( 'message' ) + '">' + _messageName + '</option>' );
					} );
				} else 
					ef.forEach( function( item ) {
						if( item.id == jQuery( self ).prop( 'value' ) ){
							item.message.forEach( function( message, i ) {
								jQuery( 'select.messages-list' ).append( '<option value="'+message.id+'">' + message.name + '</option>' );
							} );
						}
					});
				jQuery('.selectpicker').selectpicker('refresh');
			});
			jQuery( '.copy-settings' ).after(
				'<div class="form-group funnel_scratch" id="add_new">'+
					'<input type="button" class="btn btn-success waves-effect waves-light" id="add_message" value="Add new message" />'+
					'<input type="hidden" name="arrData[flg_template]" value="2" />'+
				'</div>'
			);

			jQuery('#add_message').click(function(){
				addNewMessage();
				checkHashTags();
			});
		}
		{/literal}{/if}{literal}
	} );
}
jQuery( document ).ready( function(){
	checkHashTags();
});
</script>
{/literal}