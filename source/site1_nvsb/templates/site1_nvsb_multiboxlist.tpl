<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
<table width="100%">
<thead>
<tr>
	<th>Main Keyword
		{if $arrPg.recall>1}
			{if $arrFilter.order!='main_keyword--up'}<a href="{url name='site1_nvsb' action='multiboxlist' wg='order=main_keyword--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='main_keyword--dn'}<a href="{url name='site1_nvsb' action='multiboxlist' wg='order=main_keyword--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th>Category
		{if $arrPg.recall>1}
			{if $arrFilter.order!='category_id--up'}<a href="{url name='site1_nvsb' action='multiboxlist' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category_id--dn'}<a href="{url name='site1_nvsb' action='multiboxlist' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>	
	<th>Site URL
		{if $arrPg.recall>1}
			{if $arrFilter.order!='url--up'}<a href="{url name='site1_nvsb' action='multiboxlist' wg='order=url--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url--dn'}<a href="{url name='site1_nvsb' action='multiboxlist' wg='order=url--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}
	</th>
	<th><input type="checkbox" id="select_all" /></th>
</tr>
</thead>
<tbody>
{foreach from=$arrList key='k' item='v'}
{if $v.category_id>0}
{assign var=foundSite value=1}
<input type="hidden" value="{$v.url}" id="url_{$v.id}" />
<input type="hidden" value="{$v.category_id}" id="category_{$v.id}" />
<input type="hidden" value="{$v.category}" id="category_title_{$v.id}" />
<input type="hidden" value="{$v.main_keyword}" id="title_{$v.id}" />
<tr{if $k%2=='0'} class="matros"{/if}>
	<td>{$v.main_keyword}</td>
	<td width="150">{if $v.category}{$v.category}{/if}</td>
	<td><a href="{$v.url}" target="_blank">{$v.url}</a></td>
	<td class="option">
	<input class="check_site" type="checkbox" value="{$v.id}">
	</td>
</tr>
{/if}
{/foreach}
</tbody>
<tfoot>
	<tr>
		<td colspan="5">
			<div class="bulk-actions align-left">
				<input type="button" value="Choose" id="choose" class="button">
			</div>
			{include file="../../pgg_frontend.tpl"}
		</td>
	</tr>
</tfoot>
</table>
</div>
{literal}
<script type="text/javascript">
var CONST_SITE_TYPE=3;
	window.addEvent('domready', function(){
		$('select_all').addEvent('click',function(){
			$$('.check_site').each(function(el){
				el.checked = this.checked;
			},this);
		});
				
		if ( window.parent.$('jsonSiteList') ) {
			var arrList = JSON.decode(window.parent.$('jsonSiteList').value);
			if( arrList )
			arrList.each(function(item){
				if(item==null){
					return;
				}
				$$('.check_site').each(function(el){
					if( window.parent.withUrl ){
						var v= ( item.flg_type == CONST_SITE_TYPE)?item.site_id:0;
					} else {
						var v=item;
					}
					if( el.value == v ){
						el.checked = true;
					}
				});
			});
		}	

		$('choose').addEvent('click', function(){
			var arrChecked = new Array();
			var arrCheckedWhithCategories = new Array();
			var i=0;
			$$('.check_site').each(function(el){
				if ( el.checked&&el.value ) {
					if( window.parent.withUrl ){
						arrChecked[i] = {'site_id':el.value,'flg_type':CONST_SITE_TYPE,'title':$('title_'+el.value).value,'url':$('url_'+el.value).value,'category_id':$('category_'+el.value).value,'category_title':$('category_title_'+el.value).value};
					} else {
						arrChecked[i] = el.value;
					}
					i++;
				}
			});
			if( window.parent.withUrl && arrList ){
			arrList.each(function(item){
				if( item!=null && item.flg_type != CONST_SITE_TYPE ){
					i++;
					arrChecked[i]=item;
				}
			});console.dir(arrChecked);
			}
			if( window.parent.$('jsonSiteList') ) {
				window.parent.$('jsonSiteList').value = JSON.encode( arrChecked ); 
			}
			window.parent.siteMultiboxDo();
			window.parent.multibox.boxWindow.close();
		});
	});
</script>
{/literal}
</body>
</html>