{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
{if $msg}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if $error}{include file="../../message.tpl" type='info' message=$error}{/if}
<table class="table  table-striped">
	<thead>
	<tr>
		<th>URL<br/>{if count($arrList)>1}{if $arrFilter.order!='url--up'}<a href="{url name='site1_traffic' action='manager' wg='order=url--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=url--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Category<br/>{if count($arrList)>1}{if $arrFilter.order!='category_id--up'}<a href="{url name='site1_traffic' action='manager' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category_id--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Start Date<br/>{if count($arrList)>1}{if $arrFilter.order!='added--up'}<a href="{url name='site1_traffic' action='manager' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Allowed credits<br/>{if count($arrList)>1}{if $arrFilter.order!='credits--up'}<a href="{url name='site1_traffic' action='manager' wg='order=credits--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='credits--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=credits--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Received Clicks<br/>{if count($arrList)>1}{if $arrFilter.order!='clicks--up'}<a href="{url name='site1_traffic' action='manager' wg='order=clicks--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='clicks--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=clicks--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>

		<th style="width:120px;"> Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='company' key='id'}
	<tr id="row{$id}"{if $id%2=='0'} class="alt-row"{/if}>
			<td align="left">{$company.url}</td>
			<td align="center">{if {$arrCategoryTree.{$company.category_id}.pid}!=1}{$arrCategoryTree.{$arrCategoryTree.{$company.category_id}.pid}.title} {/if}{$arrCategoryTree.{$company.category_id}.title}</td>
			<td align="center">{$company.added|date_format:$config->date_time->dt_full_format}</td>
			<td align="center">{$company.credits}</td>
			<td align="center">{$company.clicks}</td>
			<td>
				{if $company.flg_end == 0 && $company.credits != $company.clicks}<a {is_acs_write} href="{url name='site1_traffic' action='manager'}?end={$company.id}" class="alert end_action">
					<img src="/skin/i/frontends/design/newUI/icons/end.jpg" border="0" title="End" style="cursor:pointer">
				</a>{else}Campaign Ended{/if}
			</td>
	</tr>
	{foreachelse}
	<tr><td align='center' colspan='6'>No campaign found</td></tr>
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
</div>
{include file='../../box-bottom.tpl'}
{literal}
<script type="text/javascript">
$$('.end_action').addEvent('click',function(){
	if (confirm("This will end your campaign, and it cannot be resumed.")) {
		return true;
	} else {
		return false;
	}
});
</script>
{/literal}