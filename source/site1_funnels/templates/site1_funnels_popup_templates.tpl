<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
	{literal}
	<style type="text/css">
		.item, .delimiter{
			padding:3px;
			border: 2px solid #f0f0f0;
			margin-bottom: 20px;
		}
		.item .item_description, .item .item_description_full {
			width:100%;
			height:70px;
			position:absolute;
			top:0;
			font-size:14px;
			line-height:16px;
			text-align:center;
		}
		.item .item_description_full {
			height:auto;
			max-height:220px;
			overflow: auto;
			background-color: #f0f0f0;
			display:none;
		}
		.item .item_description_box {
			margin:5px 0;
			width:100%;
			height:70px;
			position:relative;
		}
		.delimiter {
			width: 100%;
			height: 10px;
			border: none;
			text-align: center;
			margin: 5px;
			background-color: #f0f0f0;
		}
		.item:hover {
			background-color: #f0f0f0;
		}
		#show_images {
			display:none;
		}
	</style>
	{/literal}
</head>
<body>
	<div class="card-box">
		<div id="templates-lpb" class="popup-block">
			{if $arrTemplates}
			<div class="form-group">
				<p>Note: here you can select what type of funnels you are interested in. For example, you might want to search for only optin funnels. For this, use the checkboxes below.</p>
			</div>

			<div id="accordion" role="tablist" aria-multiselectable="true" class="m-b-20 panel-group">
                <div class="card panel panel-default">
                    <div class="card-header panel-heading" role="tab" id="headingOne">
                        <h5 class="mb-0 mt-0 panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne" class="collapsed">Offer Type</a></h5>
                    </div>

                    <div id="collapseOne" class="collapse panel-collapse" role="tabpanel" aria-labelledby="headingOne">
                        <div class="card-body panel-body">
                            <div class="checkbox checkbox-custom">
					            <input id="optin" type="checkbox" checked="" value="2" class="offer-type" />
					            <label for="optin">Optin</label>
					        </div>
					        <div class="checkbox checkbox-custom">
					            <input id="redirect" type="checkbox" checked="" value="1" class="offer-type" />
					            <label for="redirect">Redirect</label>
					        </div>
					        <div class="checkbox checkbox-custom">
					            <input id="messenger" type="checkbox" checked="" value="3" class="offer-type" />
					            <label for="messenger">Messenger</label>
		       				</div>
                        </div>
                    </div>
                </div>
                <div class="card panel panel-default">
                    <div class="card-header panel-heading" role="tab" id="headingTwo">
                        <h5 class="mb-0 mt-0 panel-title"><a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Network</a></h5>
                    </div>
                    <div id="collapseTwo" class="collapse panel-collapse" role="tabpanel" aria-labelledby="headingTwo">
                        <div class="card-body panel-body">
                            <select class="form-control network">
                            	<option value="">All</option>
								<option value="Warrior_Plus">Warrior Plus</option>
								<option value="Jvzoo">Jvzoo</option>
								<option value="Clickbank">Clickbank</option>
								<option value="PaykickStart">PaykickStart</option>
								<option value="Zaxaa">Zaxaa</option>
								<option value="ThriveCart">ThriveCart</option>
								<option value="JVShare">JVShare</option>
								<option value="Paydtotcom">Paydtotcom</option>
								<option value="Clickfunnels">Clickfunnels</option>
								<option value="Other">Other</option>
							</select>
                        </div>
                    </div>
                </div>
                <div class="card panel panel-default">
                    <div class="card-header panel-heading" role="tab" id="headingThree">
                        <h5 class="mb-0 mt-0 panel-title"><a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">Require Application</a></h5>
                    </div>
                    <div id="collapseThree" class="collapse panel-collapse" role="tabpanel" aria-labelledby="headingThree" style="">
                        <div class="card-body panel-body">
                            <div class="checkbox checkbox-custom">
								<input type="hidden" name="require-application" value="false">
								<input type="checkbox" id="require-application" value="true" name="require-application" checked="" class="require-application" />
								<label for="require-application">Include Funnels, which Require Application</label>
							</div>
                        </div>
                    </div>
                </div>
                <div class="card panel panel-default">
                    <div class="card-header panel-heading" role="tab" id="headingFour">
                        <h5 class="mb-0 mt-0 panel-title"><a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseFour" aria-expanded="false" aria-controls="collapseThree">Search by tag</a></h5>
                    </div>
                    <div id="collapseFour" class="collapse panel-collapse" role="tabpanel" aria-labelledby="headingFour" style="">
                        <div class="card-body panel-body">
                            <div class="form-group">
								<label class="col-2 col-form-label">Search by tag</label>
				                <div class="col-10">
				                    <input type="text" class="form-control search-input-mb" value="" rel="t" />
				                </div>
							</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
            	<div class="col-md-12">
            		<a href="https://affiliatefunnels.io/packs/amazon1.html" target="_blank">Just Released: Brand New Amazon Funnels Pack #1 Promoting 10 High In Demand Smart Home Devices</a>
            	</div>
            </div>

			<div class="row" id="show_images">
				{foreach from=$arrTemplates item=group}
					<div class="col-md-12"><h4>{$group.name}</h4></div>
					{foreach from=$group.node item=template}
					<div class="col-md-3">
						<div class="item" data-offer-type="{if isset($template.settings.type_page)}{$template.settings.type_page}{/if}" data-tags="{strtolower( $template.settings.template_tags )}" data-require="{if $template.tpl_settings.flg_require == 1 && !empty($template.tpl_settings.offer_application)}true{else}false{/if}" data-network="{$template.tpl_settings.network}">
							<div class="item_description_box">
								<div class="item_description">{$template.settings.template_description|strip_tags:true|truncate:125:'...':true:true}</div>
								<div class="item_description_full">{$template.settings.template_description}</div>
							</div>
							<div>
								<img data-src="{$templates_link}{$template.settings.template_hash}.jpg" src="" width="230" height="150" class="image_item center-block" />
							</div>
							<div class="m-t-10">
								<center>
									<a href="{$template.url}" class="btn btn-default waves-effect waves-light" target="_blank">Preview</a> 
									{if !empty( $template.tpl_settings.offer_link )}
									<a href="{$template.tpl_settings.offer_link}" target="_blank" class="btn btn-default waves-effect waves-light">Review Offer</a>
									{/if}
									<a data-template-id="{$template.id}" href="{url name='site1_funnels' action='create'}?template=1&id={$template.id}&parent={$id}" class="select_template btn btn-default waves-effect waves-light">Select</a>
								</center>
							</div>
							<br/>
						</div>
					</div>
					{/foreach}
				{/foreach}
			</div>
			{/if}
		</div>
	</div>
{literal}
<script type="text/javascript">
function isVisible(elem){
	var coords = elem.getBoundingClientRect();
	var windowHeight = document.documentElement.clientHeight;
	var topVisible = coords.top > 0 && coords.top < windowHeight;
	var bottomVisible = coords.bottom < windowHeight && coords.bottom > 0;
	return topVisible || bottomVisible;
}
function showVisible(){
	var imgs = document.getElementsByClassName('image_item');
	for (var i = 0; i < imgs.length; i++){
		var img = imgs[i];
		var realsrc = jQuery( img ).data('src');
		if (!realsrc) continue;
		if (isVisible(img)){
			img.src = realsrc;
			jQuery( img ).data('src', '');
		}
	}
}
window.onscroll = showVisible;
jQuery( document ).ready( function(){
	jQuery( '#accordion .card h5 > a' ).on( 'click', function(){
		jQuery( '.collapse' ).removeClass( 'show' );
		jQuery( '#accordion .card h5 > a' ).addClass( 'collapsed' );
		jQuery( this ).removeClass( 'collapsed' );
		jQuery( jQuery( this ).attr( 'href' ) ).addClass( 'show' );
		return false;
	});
	setTimeout( function(){
		jQuery( '#show_images' ).show();
		showVisible();
	}, 500 );
});
window.parent.$('cerabox').getChildren('.cerabox-content')[0].setStyle('overflow','none');
$$('.select_template').addEvent('click',function( evt ){
	evt.stop();
	window.parent.multibox.boxWindow.close();
	window.parent.setTemplate( $( this ).get( 'data-template-id' ) );
	return false;
});
$$('.item').addEvent('mouseenter',function( elt ){
	$$( elt.target.getElementsByClassName('item_description_full')[0] ).show();
});
$$('.item').addEvent('mouseleave',function( elt ){
	$$( elt.target.getElementsByClassName('item_description_full')[0] ).hide();
});
jQuery( '.offer-type' ).on( 'change', function(){
	jQuery( '.item' ).each(function(){
		if( $$( '.offer-type:checked' ).get( 'value' ).indexOf( jQuery( this ).data( 'offer-type' ).toString() ) == -1 || 
			jQuery( this ).data( 'tags' ).toString().toLowerCase().indexOf( jQuery( self ).prop( 'value' ) ) == -1 && jQuery( '.search-input-mb' ).prop( 'value' ) !== '' || 
			!jQuery( '.require-application' ).prop( 'checked' ) && jQuery( this ).data( 'require' ) == true ||
			jQuery( '.network' ).prop( 'value' ) !== '' && jQuery( '.network' ).prop( 'value' ) != jQuery( this ).data( 'network' )
		){
			jQuery( this ).parent().hide();
		} else {
			jQuery( this ).parent().show();
		}
	});
	showVisible();
} );
jQuery( '.search-input-mb' ).on( 'keyup', function(){
	var self = this;
	jQuery( '.item' ).each(function(){
		if( jQuery( this ).data( 'tags' ).toString().toLowerCase().indexOf( jQuery( self ).prop( 'value' ) ) == -1 || $$( '.offer-type:checked' ).get( 'value' ).indexOf( jQuery( this ).data( 'offer-type' ).toString() ) == -1 || !jQuery( '.require-application' ).prop( 'checked' ) && jQuery( this ).data( 'require' ) == true || jQuery( '.network' ).prop( 'value' ) !== '' && jQuery( '.network' ).prop( 'value' ) != jQuery( this ).data( 'network' ) ){
			jQuery( this ).parent().hide();
		} else {
			jQuery( this ).parent().show();
		}
	});
	showVisible();
} );
jQuery( '.require-application' ).on( 'change', function(){
	var self = this;
	jQuery( '.item' ).each(function(){
		if( !jQuery( self ).prop( 'checked' ) && jQuery( this ).data( 'require' ) == true || $$( '.offer-type:checked' ).get( 'value' ).indexOf( jQuery( this ).data( 'offer-type' ).toString() ) == -1 || jQuery( this ).data( 'tags' ).toString().toLowerCase().indexOf( jQuery( self ).prop( 'value' ) ) == -1 && jQuery( '.search-input-mb' ).prop( 'value' ) !== '' || jQuery( '.network' ).prop( 'value' ) !== '' && jQuery( '.network' ).prop( 'value' ) != jQuery( this ).data( 'network' ) ){
			jQuery( this ).parent().hide();
		} else {
			jQuery( this ).parent().show();
		}
	});
} );
jQuery( '.network' ).on( 'change', function(){
	var self = this;
	jQuery( '.item' ).each(function(){
		if( jQuery( self ).prop( 'value' ) !== '' && jQuery( self ).prop( 'value' ) != jQuery( this ).data( 'network' ) || jQuery( this ).data( 'tags' ).toString().toLowerCase().indexOf( jQuery( '.search-input-mb' ).prop( 'value' ) ) == -1 || $$( '.offer-type:checked' ).get( 'value' ).indexOf( jQuery( this ).data( 'offer-type' ).toString() ) == -1 || !jQuery( '.require-application' ).prop( 'checked' ) && jQuery( this ).data( 'require' ) == true ){
			jQuery( this ).parent().hide();
		} else {
			jQuery( this ).parent().show();
		}
	});
});
</script>
{/literal}

</body>
</html>