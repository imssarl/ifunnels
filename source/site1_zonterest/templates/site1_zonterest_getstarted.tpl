<link rel="stylesheet" href="/skin/light/plugins/lada/ladda.min.css" />
<script src="/skin/light/plugins/lada/spin.min.js"></script>
<script src="/skin/light/plugins/lada/ladda.min.js"></script>

<script type="text/javascript" src="/skin/_js/categories.js"></script>	
{literal}<script type="text/javascript">
var arrErrors = new Hash();
var multiboxnoerrors;
var SourceObject = new Class({
	seeErrors: function(e) {
		if ( this.errors.getLength() > 0 ) {
			this.errors = '';
			this.add_event();
			return false;
		}
		if ( e.target.id != 'create' && e.target.id != 'content-filter' ) {
			$(e.target.id).erase('class');
			$(e.target.id).set('class', 'noerrors');
			validator.checker.reset();
			var arrquery = new Hash();
			$('content_'+this.source_id).getElements('input, select, textarea').each(function(el){
				if  ( ((el.type == "radio")&&(el.checked))||el.type!="radio" ) {
					arrquery.set( (el.name).replace( /arrCnt\[\d{1,}]\[settings\]/ , 'arrFlt') , el.value);
				}
			});
			arrquery.set('flg_source',this.source_id);
			arrquery.set('id',true);
			var newURI = new URI($(e.target.id).get('href'));
			$(e.target.id).set('href', newURI.setData(arrquery).toString());
			multiboxnoerrors=new CeraBox( $(e.target.id), {
				group: false,
				width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
				height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
				fullSize:true
			});
			multiboxnoerrors.currentItem=0;
			multiboxnoerrors.boxWindow.loading(multiboxnoerrors);
			multiboxnoerrors.showIframe();
			this.add_event();
			return true;
		}else{
			this.add_event();
			return true;
		}
	},
	checkErrors: function(e){
		e.stop();
		validator.checker.reset();
		validator.reinit($$('form.validate')[0]);
		$(e.target.id).removeEvents('click');
		this.errors = new Hash();
		$('content_'+this.source_id).getElements('input.required, textarea.required').each(function(el){
			if  ( (((el.type == "radio")&&(el.checked))||el.type!="radio" ) && (el.value == "") ) {
				validator.checker.validateField( el , true);
				this.errors.set( el.getProperty('alt') );
			}
		},this);
		$('content_'+this.source_id).getElements('select.required').each(function(el){
			if ( el.value == "" || el.value == "0" ) {
				validator.checker.validateField( el , true);
				this.errors.set( el.getProperty('alt') );
			}
		},this);
		return this.seeErrors(e);
	},
	add_event: function(){
		if ($('add_multibox') != null) {
			$('add_multibox').addEvent('click', function(evt) {
				window.parent.visual.jsonValue = null;
				this.source_id = $('select_content').value;
				selectedSource.checkErrors(evt);
			}.bind(this));
		}
		if ( $('content-filter') != null ) {
			$('content-filter').addEvent('click',function(evt){
				window.parent.visual.jsonValue = null;
				var popup_url = new URI(window.location);
				var arrquery = new Hash();
				$('content_'+this.source_id).getElements('input, select, textarea').each(function(el){
					if  ( ((el.type == "radio")&(el.checked))||(el.type!="radio") ) 
						arrquery.set( el.name.replace( /arrCnt\[\d{1,}\]\[settings\]/ , 'arrFlt') , el.value);
				});
				arrquery.set('flg_source',this.source_id);
				arrquery.set('id',true);
				if (selectedSource.checkErrors(evt)) {
					popup_url.setData(arrquery);
					$('filter_form').set('action', popup_url.toString());
					$('filter_form').submit();
				}
			}.bind(this));
		}
	}
});
var SourceTypeObject = new Array();
</script>{/literal}
<div class="card-box">
<div class="content-box">
	<div class="form-group">
		<label>Step 1: <a class="mb select-category" data-toggle="modal" data-target="#amazon_settings_mb" title="Add your Amazon credentials">Add your Amazon credentials</a></label>
		
		<div id="amazon_settings_mb" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none;">
			<div class="modal-dialog" style="width:55%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<h4 class="modal-title" id="custom-width-modalLabel">Amazon credentials</h4>
					</div>
					<div class="modal-body">
							<form method="post" action="">
								<div class="form-group">
									{assign var="type" value="edit"}
									{include file="../../site1_publisher/templates/external/amazon.tpl"}
								</div>
								<div class="form-group">
									<button type="submit" class="button btn btn-success waves-effect waves-light">Submit</button>
								</div>
							</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="form-group">
		<label>Step 2 (optional but recommended): Authorize your mobile phone</label>
		<input type="text" name="buyer_phone" id="buyer_phone" data-veryfy="{Core_Users::$info['flg_phone']}" class="required text-input medium-input form-control" value="{Core_Users::$info.buyer_phone}" />{if $arrErr.buyer_phone}<span class="input-notification error png_bg">{$strError}</span>{/if}
		
		<a id="buyer_phone_verify" href="" data-url="{url name='site1_accounts' action='confirmphone'}" class="popup-sidebar" style="color:red;{if Core_Users::$info['flg_phone']!=1} display: inline; {else} display: none; {/if}">Authorize your mobile phone</a>
		<a id="buyer_phone_verified" href="{url name='site1_accounts' action='calls'}" style="color:green;{if Core_Users::$info['flg_phone']==1} display: inline; {else} display: none; {/if}">Verified successfully</a>
		
		<br/><small>Example:+14156586177</small>
	</div>

	{if Core_Acs::haveRight( ['ccs'=>['facebook']] )}
	<div class="form-group">
		<label>Step 2-b (optional): Connect Your Facebook account to enable the Messenger builder</label>
		<br/>
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
	<div class="form-group">
		<label>Step 3: Create AzonFunnels site</label><br/>
		<a class="wizard_icon" href="{url name='site1_wizard' action='zonterestamazideas'}">Follow this link</a> to create AzonFunnels site through your dashboard.{if Core_Acs::haveAccess( array('Zonterest Custom 2.0') )} Or you can just text / call +1 949-485-4202 with a keyword of your choice.{/if} You can also use Facebook Messenger to create or update your AzonFunnels store.
		<br/>
	</div>
	{if Core_Acs::haveAccess( array('Zonterest Custom 2.0') )}
	<div class="form-group">
		<label>When creating AzonFunnels site through your phone, you can define a category to be used for products search. The list of allowed Amazon categories includes:</label>

		<br/><small style="width:100%;">All{foreach item='categoryData' from=$categoryTree}, {$categoryData.title}{/foreach}</small>

		<br/><br/><small>Here are some examples of SMS messages for you to create a AzonFunnels site: </small>
		<br/>SMS e.g.: Harry Potter
		<br/><small>(here "Harry Potter" is your keyword, and the category is not defined, which means products will be pulled from All Amazon categories)</small>
		
		<br/><br/>SMS e.g.: Email Marketing [Books]
		<br/><small>(here "Email Marketing" is a keyword, and the category to be used for products search is "Books")</small>
	</div>
	{/if}
	{if $zCounter!='unlimited'}
	<div class="form-group">
		<label>If you wish to get unlimited websites, click:</label>
		<br/>
		<br/>
		<script async src="//thrivecart.com/embed/v1/thrivecart.js"></script><a data-thrivecart-account="ims" data-thrivecart-product="11" class="thrivecart-button thrivecart-button-styled thrivecart-button-green ">Upgrade Now</a>
	</div>
	{/if}
	<div class="form-group">
		<label>Help Section: <a href="https://help.ifunnels.com/collection/9-azon-funnels-training" target="_blank">https://help.ifunnels.com/collection/9-azon-funnels-training</a></label>
	</div>
	
	
</div>
</div>

{literal}<script type="text/javascript">
var removeSEDiv=function(){
	var removeSelectpickerDiv=$('amazon_settings').getElements('.selectpicker' ).getNext('div');
	//console.log( $('amazon_settings').getElements('.selectpicker' ).getNext('div') );
	if( removeSelectpickerDiv.length > 0 && removeSelectpickerDiv[0]!=null ){
		$$(removeSelectpickerDiv[0]).destroy();
	}
}
window.addEvent('domready', function(){
	setTimeout( 'removeSEDiv();', 1000 );
});
var firstPhoneNumber=$('buyer_phone').get('value');
var updatePhoneStatus=function( eltTraget ){
	$('buyer_phone_verify').hide();
	$('buyer_phone_verified').hide();
	var strPhone=eltTraget.get('value');
	if( strPhone.search( /^\+[0-9]{9,15}$/ ) != -1 ){
		if( $('buyer_phone').get('data-veryfy')==1 && strPhone == firstPhoneNumber ){
			$('buyer_phone_verified').show();
		}else{
			var url=$('buyer_phone_verify').get('data-url');
			$('buyer_phone_verify').set('href', url+'?update_phone='+$('buyer_phone').get('value'));
			$('buyer_phone_verify').show();
		}
	}
}
$('buyer_phone_verify').addEvent('click',function(){
	if( $('buyer_phone').get('data-veryfy')==1 ){
		firstPhoneNumber=$('buyer_phone').get('value');
	}
});
$('buyer_phone').addEvents({
	'keyup':function( elt ){
		updatePhoneStatus( elt.target );
	},
	'change':function( elt ){
		updatePhoneStatus( elt.target );
	},
	'input':function( elt ){
		updatePhoneStatus( elt.target );
	}
});
new CeraBox( $$('.wizard_icon'), {
	group: false,
	width:'950px',
	height:'500px',
	displayTitle: true,
	titleFormat: '{title}'
});

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

</script>{/literal}
