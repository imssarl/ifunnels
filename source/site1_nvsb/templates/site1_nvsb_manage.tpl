<br />
{if !$arrPrm.flg_tpl}
{if $msg}
	{include file="../../message.tpl" type='info' message="Site successful $msg"}
{/if}
{if $error}
	{include file="../../message.tpl" type='error' message=$error}
{/if}
{/if}
{include file='../../error.tpl'}
<table class="table  table-striped">
<thead>
<tr>
	{if !$arrPrm.flg_tpl}
	<th  width="130">Last Modify
		{if $arrPg.recall>1}
			{if $arrFilter.order!='edited--up'}<a href="{url name='site1_nvsb' action='manage' wg='order=edited--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='edited--dn'}<a href="{url name='site1_nvsb' action='manage' wg='order=edited--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th  width="130">Template Used
		{if $arrPg.recall>1}
			{if $arrFilter.order!='template_id--up'}<a href="{url name='site1_nvsb' action='manage' wg='order=template_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='template_id--dn'}<a href="{url name='site1_nvsb' action='manage' wg='order=template_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th  width="130">Main Keyword
		{if $arrPg.recall>1}
			{if $arrFilter.order!='main_keyword--up'}<a href="{url name='site1_nvsb' action='manage' wg='order=main_keyword--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='main_keyword--dn'}<a href="{url name='site1_nvsb' action='manage' wg='order=main_keyword--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	{/if}
	<th>Site URL
		{if $arrPg.recall>1}
			{if $arrFilter.order!='url--up'}<a href="{url name='site1_nvsb' action='manage' wg='order=url--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url--dn'}<a href="{url name='site1_nvsb' action='manage' wg='order=url--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th>Category
		{if $arrPg.recall>1}
			{if $arrFilter.order!='category_id--up'}<a href="{url name='site1_nvsb' action='manage' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category_id--dn'}<a href="{url name='site1_nvsb' action='manage' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>	
	{if !$arrPrm.flg_tpl}
	<th style="width:200px;">&nbsp;</th>
	{/if}
</tr>
</thead>
<tbody>
{foreach from=$arrList key='k' item='v'}
<tr{if $k%2=='0'} class="matros"{/if}>
	{if !$arrPrm.flg_tpl}
	<td>{$v.edited|date_format:$config->date_time->dt_full_format}</td>
	{foreach from=$arrTemplates item=i}{if $i.id == $v.template_id}{assign var=image value=$i.image}{assign var=preview value=$i.preview}{/if}{/foreach}
	<td><img{if $preview} class="screenshot" rel="<div style='border:2px solid #000000;'><img src='{$preview}{assign var=preview value=''}' /></div>"{/if} src="{img src=$image w=95 h=60}{assign var=image value=''}" /><br />{$arrTemplates[$v.temp_id].temp_name}</td>
	<td>{$v.main_keyword}</td>
	{/if}
	<td><a href="{$v.url}" target="_blank">{$v.url}</a></td>
	<td width="{if $arrPrm.flg_tpl}360{else}150{/if}">{if $v.category}{$v.category}{else}<a class="mb select-category"  href="#mb"  title="Select category" rel="type:element,width:400" rev="{$v.id}">Select category</a>{/if}</td>
	{if !$arrPrm.flg_tpl}
	<td class="option">
		<a  {is_acs_write} href="{url name='site1_nvsb' action='edit'}?id={$v.id}" id="{$v.id}" rel="{$v.category_id}" title="Edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
		<a  {is_acs_write} href="{url name='site1_nvsb' action='edit'}?id={$v.id}&template=change"><img title="Change template" src="/skin/i/frontends/design/buttons/template.png" /></a>
		<a {is_acs_write} href="{url name='site1_nvsb' action='manage'}?del={$v.id}" class="delete" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
		{if !Core_Acs::haveAccess( array( 'DFY' ) )}
		<a {is_acs_write} href="{url name='site1_blogfusion' action='create'}?nvsb={$v.id}" title="Install Wordpress"><i class="ion-social-wordpress" style="font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
		{/if}
		<a {is_acs_write} href="{url name='site1_sbookmarking' action='gadget'}?title={$v.main_keyword}&url={$v.url}" title="Social Bookmarking"><i class="ion-social-buffer" style="font-size: 20px; vertical-align: bottom; color: #8AC52A; margin: 0 5px;"></i></a>
		<a {is_acs_write} href="#mb" rel="type:element,width:400" rev="{$v.id}" title="Change category" class="mb select-category" title="Change category"><i class="ion-ios7-compose" style="font-size: 20px; vertical-align: bottom; color: #34d3eb; margin: 0 5px;"></i></a>
		<a {is_acs_write} href="{url name='site1_nvsb' action='log'}?id={$v.id}" rel="" title="URL Log" class="mb" title="URL Log"><i class="ion-link" style="color: #91B8E8; font-size: 24px; vertical-align: middle;"></i></a>
	</td>
	{/if}
</tr>
{/foreach}
</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
<div  style="display:none;">
<div id="mb">
	<form action="" class="wh" style="padding:10px" method="POST" >
		<input type="hidden" name="arrNewCat[id]" value="" id="change-cat-id" >
		<select  id="cat-id" class="first" >
			<option value="">- select -</option>
			{foreach from=$arrCategories item=i}
			<option value="{$i.id}">{$i.title}</option>
			{/foreach}
		</select><br /><br />
		<select class="second" name="arrNewCat[category_id]"><option value="">- select -</option></select><br /><br />
		<input type="submit" value="Change" {is_acs_write}>
		<br /><br />
	</form>
</div>
</div>
<br />

{if !$arrPrm.flg_tpl}
{literal}
<script type="text/javascript">

var categoryId = {/literal}{$smarty.get.cat|default:'null'}{literal};
var jsonCategory = {/literal}{$treeJson}{literal};

var Categories = new Class({
	Implements: Options,
	options: {
		firstLevel: 'category',
		secondLevel: 'category_child',
		intCatId: categoryId
	},
	initialize: function( options ){
		this.setOptions(options);
		this.arrCategories = new Hash(jsonCategory);
		$(this.options.firstLevel).addEvent('change',function(){
			this.setFromFirstLevel( $(this.options.firstLevel).value );
		}.bind( this ) );
		if( $chk( this.options.intCatId ) && this.checkLevel( this.options.intCatId ) ) {
			this.setFromFirstLevel( this.options.intCatId );
		} else if( $chk( this.options.intCatId ) ) {
			this.setFromSecondLevel( this.options.intCatId );
		}
	},
	checkLevel: function(id){
		var bool=false;
		this.arrCategories.each(function(el){
			if( el.id == id ) { bool=true; }
		}); 
		return bool;
	},
	setFromFirstLevel: function( id ){
		this.arrCategories.each( function(item){
			if( item.id == id ) {
				Array.each( $(this.options.firstLevel).options,function(i){
					if(i.value == id){
						i.selected=1;
					}
				});					

				$(this.options.secondLevel).empty();
				var option = new Element('option',{'value':'','html':'- select -'});
				option.inject( $(this.options.secondLevel) );
				var hash = new Hash(item.node);
				hash.each(function(i,k){
					var option = new Element('option',{'value':i.id,'html':i.title});
					if( i.id == this.options.intCatId ){
						option.selected=1;
					}
					option.inject( $(this.options.secondLevel) );
				},this);
			}
		},this);
	},
	setFromSecondLevel: function( id ) {
		this.arrCategories.each(function( item ){
			var hash = new Hash(item.node);
			hash.each(function(el){
				if ( id == el.id ) {
					this.setFromFirstLevel( el.pid );
				}
			},this);
		},this);
	}
});
var multibox = {};
var siteId=0;
window.addEvent('domready', function(){
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		displayTitle: true,
		titleFormat: '{title}',
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%'
	});
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){ el.addEvent('click',function(e){ e.stop(); }); });
	
	$$('.delete').addEvent('click',function(e){
		if(!confirm('Are you sure you want to delete this site? Please note that it will only be deleted from the Manage Sites table of the Creative Niche Manager. If you want to delete your site completely, you will need to delete the site folder directly on your server.')) {
			e.stop();
		}
	});
	$$('.select-category').addEvent('click', function(e){
		e && e.stop();
		var id = this.get('rev');
		siteId = id;
		categoryId = $(id).rel;
		setTimeout("initMultiboxCat()",1000);
	});		
	
});

var initMultiboxCat = function(){
	var el = $$('.wh').getLast().elements;
	var first = null;
	var last = null;
	Array.each(el,function(e){
		if(e.tagName == 'SELECT'){
			if(e.hasClass('first')){first = e;}
			if(e.hasClass('second')){last = e;}
		}
		if(e.get('name')=='arrNewCat[id]'){
			e.value=siteId;
		}
	});
	first.id = 'cat';
	last.id = 'cat_child';
	new Categories({firstLevel:'cat',secondLevel:'cat_child',intCatId: categoryId});
}
</script>
{/literal}
{/if}