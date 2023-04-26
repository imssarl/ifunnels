<div class="card-box">
<table class="table table-striped">
<thead>
	<tr>
		<th width="50px">ID</th>
		<th>Page&nbsp;URL</th>
		<th>Affiliate&nbsp;URL</th>
		<th>Type</th>
		{*<th>CCP&nbsp;Tracking</th>*}
		<th>Ad&nbsp;Campaign&nbsp;</th>
		<th width="180">Date&nbsp;Created</th>
		<th width="80">&nbsp;</th>
	</tr>
</thead>
<tbody>
{if $arrItems!==false}
{foreach from=$arrItems item=i name=j}
	<tr {if $smarty.foreach.j.iteration%2=='0'} class="alt-row"{/if}>
		<td align="center">{$i.page_id}</td>
		<td><a href="{$i.page_address}{$i.page_name}" target="_blank" title="{$i.page_address}{$i.page_name}">{implode('',array({$i.page_address},{$i.page_name}))|stringwrap:30}</a></td>
		<td><a href="{$i.page_affiliate_url}" target="_blank" title="{$i.page_affiliate_url}">{$i.page_affiliate_url|stringwrap:30}</a></td>
		<td align="center">&nbsp;{if $i.page_type == 'redirect'}Redirect{else}Cloaked{/if}&nbsp;</td>
		{*<td align="center"> {if $i.is_cpp}Yes{else}No{/if} </td>*}
		<td align="center"> {if $i.is_compaign}Yes{else}No{/if} </td>
		<td align="center">{$i.page_date_created}</td>
		<td align="center">
			<a href="{$i.page_address}{$i.page_name}" target="_blank"><img title="View" src="/skin/i/frontends/design/buttons/view.gif" /></a>
			<a href="{url name='site1_affiliate' action='edit_settings'}?id={$i.page_id}{if $i.is_cpp}&cpp=1{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}"><img title="Manage" src="/skin/i/frontends/design/newUI/icons/pencil.png"/></a>
			<a href="{url name='site1_affiliate' action='edit_file'}?id={$i.page_id}{if $i.is_cpp}&cpp=1{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}"><img title="Edit file" src="/skin/i/frontends/design/buttons/edit_file.png" /></a>
			<a class="delete_action" href="{url name='site1_affiliate' action='manage'}?del={$i.page_id}{if $i.is_cpp}&cpp=1{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png"/></a>
		</td>
	</tr>
{/foreach}
{else}
&nbsp;		
{/if}
</tbody>
<tfoot>

</tfoot>
</table>
</div>