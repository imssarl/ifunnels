{if $msg == 'delete'}
<div class="grn">Item has been deleted</div>
{elseif $msg=='delete_error'}
<div class="red">Item can't be deleted</div>
{elseif $msg=='created'}
<div class="grn">Item has been created</div>
{elseif $msg=='saved'}
<div class="grn">Item has been saved</div>
{/if}
<div align="right" style="padding:0 15% 0 0;"> 
<form class="wh">
	Tags: <input type="text" name="arrFilter[tags]" value="{$arrFilter.tags}" /><br/>
	Vendor ID: <input type="text" name="arrFilter[with_vendor_id]" value="{$arrFilter.with_vendor_id}" /><br/>
	Category: <select id="category" name="arrFilter[category_pid]">
	<option value=""> - select - </option>
	{foreach from=$arrCategories item=i}
	<option {if $arrFilter.category_pid == $i.id}selected='1'{/if} value="{$i.id}">{$i.title} (all:[{$i.count_all}] with img:[{$i.count}])</option>
	{/foreach}
	</select><br/>
	<select id="category_child" name="arrFilter[category_id]">
		<option value=""> - select - </option>
	</select><br /><br />
	<input type="submit" value="Filter" id="filter" />
</form>	
</div>
<table class="info glow" width="100%">
<thead>
<tr>
	<th width="30%">Title
		{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='content_clickbank' action='manage' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='content_clickbank' action='manage' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}	
	</th>
	<th>Short description</th>
	<th align="center">Edited{if count($arrList)>1}
			{if $arrFilter.order!='edited--up'}<a href="{url name='content_clickbank' action='manage' wg='order=edited--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='edited--dn'}<a href="{url name='content_clickbank' action='manage' wg='order=edited--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
	<th align="center">Added{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='content_clickbank' action='manage' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='content_clickbank' action='manage' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
	<th width="10%">Action</th>
</tr>
</thead>
	<tr>
		<td colspan="5"><a href="{url name='content_clickbank' action='create'}" class="mb" rel="" title="Create item">Add</a> new item</td>
	</tr>
<tbody>
{foreach from=$arrList key='k' item='v'}
<tr {if $k%2=='0'} class="matros"{/if}>
	<td><a href="{$v.url}" target="_blank">{$v.title}</a></td>
	<td>{$v.short_description|strip_tags|truncate:100}</td>
	<td align="center" width="120">{$v.edited|date_format:'%Y-%m-%d'}</td>
	<td align="center" width="120">{$v.added|date_format:'%Y-%m-%d'}</td>
	<td class="option">
		<a href="{url name='content_clickbank' action='manage'}?delete={$v.id}" class="delete" rel="{$v.title}">del</a>&nbsp;&nbsp;<a href="{url name='content_clickbank' action='create'}?id={$v.id}">edit</a>&nbsp;&nbsp;<a href="{url name='content_clickbank' action='preview'}?id={$v.id}" class="box">preview</a>
	</td>
</tr>
{/foreach}
</tbody>
</table>
<br/> 
<div align="right" style="padding:0 20px 0 0;">
{include file="../../pgg_backend.tpl"}
</div>

<script type="text/javascript" src="/skin/_js/categories.js"></script>
{literal}
<script type="text/javascript">

var categoryId = {/literal}{if empty($arrFilter.category_id)}{$arrFilter.category_pid|default:'null'}{else}{$arrFilter.category_id|default:'null'}{/if}{literal};
var jsonCategory = {/literal}{$treeJson}{literal};

var ClickCategories=new Class({
	Implements:Categories,
	setFromFirstLevel: function(id){
		$( this.options.secondLevel ).empty();
		var option = new Element( 'option[value="0"][html="- select -"]' );
		option.inject( $(this.options.secondLevel) );
		this.arrCategories.each( function( item ){
			if( item.id == id ) {
				Array.from( $(this.options.firstLevel).options ).each( function(i){
					if(i.value == id){
						i.selected=1;
					}
				});
				var hash = new Hash( item.node );
				hash.each(function( i,k ){
					var option = new Element( 'option[value="'+i.id+'"][html="'+i.title+' (all:\['+ i.count_all +'\] with img:\['+ i.count +'\]"])' );
					if( i.id == this.options.intCatId ){
						option.selected=1;
					}
					option.inject( $(this.options.secondLevel) );
				},this );
			}
		},this );
	}
});

window.addEvent('domready',function(){
	new ClickCategories({ intCatId: categoryId,jsonTree:jsonCategory });
	$$('.delete').each(function(a){
		a.addEvent('click',function(e){
			if( !confirm('Delete this item?') ){
				e.stop()
			}
		})
	});
	$$('a.box').cerabox({
			group:false,
			width:'80%',
			height:'80%',
			animation: 'ease',
			loaderAtItem: true
		});
});
</script>
{/literal}

