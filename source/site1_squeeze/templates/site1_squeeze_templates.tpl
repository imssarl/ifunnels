<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
	{literal}
	<style type="text/css">
		.item, .delimiter{
			width:230px;
			//height:250px;
			padding:3px;
			float:left;
			border: 2px solid #f0f0f0;
			margin: 5px;
		}
		.item .item_description, .item .item_description_full {
			width:230px;
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
			width:230px;
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
	</style>
	{/literal}
</head>
<body>
<div id="templates-lpb" class="popup-block">
	{if $arrTemplates}
	<div style="float:left;padding:5px;">
		Search by tag:&nbsp;<input type="text" value="" class="search-input-mb" rel="t" />
	</div>
	<div style="display:inline;">
		{foreach from=$arrTemplates item=group}
			<div class="delimiter">{$group.name}</div>
			{foreach from=$group.node item=template}
			<div class="item ttag- {foreach from=explode(',', $template.settings.template_tags) item=t key=s}ttag-{str_replace(' ','_',trim( $t ))} {/foreach}clear-ttags">
				<div class="item_description_box">
					<div class="item_description">{$template.settings.template_description|strip_tags:true|truncate:125:'...':true:true}</div>
					<div class="item_description_full">{$template.settings.template_description}</div>
				</div>
				<div>
					<img src="{img src=".{$templates_link}{$template.settings.template_hash}.jpg" w=230 h=150}" width="230" height="150" class="image_item" />
				</div>
				<div style="margin:5px 0;width:230px;height:20px;font-size:14px;z-index:999"><center>
					<a href="{$template.url}" target="_blank">Preview</a> | 
					<a href="{url name='site1_squeeze' action='customization'}?template=1&id={$template.id}&parent={$id}" class="select_template">Select</a>
				</center></div>
				<br/>
			</div>
			{/foreach}
		{/foreach}
	</div>
	<br style="clear:both;"/>
	{/if}
</div>
{literal}
<script type="text/javascript">
window.parent.$('cerabox').getChildren('.cerabox-content')[0].setStyle('overflow','none');
$$('.select_template').addEvent('click',function( evt ){
	evt.stop();
	window.parent.location=evt.target.get('href');
	return false;
});
$$('.item').addEvent('mouseenter',function( elt ){
	$$( elt.target.getElementsByClassName('item_description_full')[0] ).show();
});
$$('.item').addEvent('mouseleave',function( elt ){
	$$( elt.target.getElementsByClassName('item_description_full')[0] ).hide();
});
$$('.search-input-mb').each(function(el){
	el.addEvent( 'keyup', function ( event ) {
		$$('.clear-'+el.get('rel')+'tags').hide(0);
		$$('.clear-'+el.get('rel')+'tags').each( function( elt ){
			var flg_have_all_tags=true;
			el.get('value').split(',').each( function( tag ){
				if( elt.hasClass( el.get('rel')+'tag-'+tag.trim().replace(' ','_') ) && flg_have_all_tags!=false ){
					flg_have_all_tags=true;
				}else{
					flg_have_all_tags=false;
				}
			});
			if( flg_have_all_tags ){
				elt.show(0);
			}
		});
	});
});
</script>
{/literal}

</body>
</html>