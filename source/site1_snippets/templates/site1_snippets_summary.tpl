<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<table>
		<thead>
		<tr>
			<th>Part ID{if count($arrList)>1}{if $arrFilter.order!='id--up'}<a href="{url name='site1_snippets' action='summary' wg='order=id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='id--dn'}<a href="{url name='site1_snippets' action='summary' wg='order=id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>IP address{if count($arrList)>1}{if $arrFilter.order!='ip_address--up'}<a href="{url name='site1_snippets' action='summary' wg='order=ip_address--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='ip_address--dn'}<a href="{url name='site1_snippets' action='summary' wg='order=ip_address--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Referers URL{if count($arrList)>1}{if $arrFilter.order!='url_shown--up'}<a href="{url name='site1_snippets' action='summary' wg='order=url_shown--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url_shown--dn'}<a href="{url name='site1_snippets' action='summary' wg='order=url_shown--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Link Clicked{if count($arrList)>1}{if $arrFilter.order!='url--up'}<a href="{url name='site1_snippets' action='summary' wg='order=url--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url--dn'}<a href="{url name='site1_snippets' action='summary' wg='order=url--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Link Text{if count($arrList)>1}{if $arrFilter.order!='txt--up'}<a href="{url name='site1_snippets' action='summary' wg='order=txt--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='txt--dn'}<a href="{url name='site1_snippets' action='summary' wg='order=txt--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Date/Time{if count($arrList)>1}{if $arrFilter.order!='added--up'}<a href="{url name='site1_snippets' action='summary' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_snippets' action='summary' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		</tr>
		</thead>
		<tbody>
		{foreach from=$arrList item='record' key='id'}
		<tr id="row{$id}"{if $id%2=='0'} class="matros"{/if}>
			{*<td align="center">{$id}</td>*}
			<td align="center">{$record.part_id}</div>
			</td>
			<td align="center">{$record.ip_address}</td>
			<td align="left">{$record.url_shown}</td>
			<td align="left">{$record.url}</td>
			<td align="left">{$record.txt}</td>	
			<td align="center">{$record.added|date_format:$config->date_time->dt_full_format}</td>
		</tr>
		{foreachelse}
		<tr><td colspan="7" align="center">No Detail Available</td></tr>
		{/foreach}
		</tbody>
		<tfoot>
			<tr>
				<td colspan="6"><div class="bulk-actions align-left"><input type="button" value="Close" class="button" {is_acs_write} id="close" ></div> {include file="../../pgg_frontend.tpl"}</td>
			</tr>
		</tfoot>
	</table>
{literal}
<script>
$('close').addEvent( 'click', function() {
	window.parent.multibox.boxWindow.close();
});
</script>
{/literal}
</div>
</body>
</html>