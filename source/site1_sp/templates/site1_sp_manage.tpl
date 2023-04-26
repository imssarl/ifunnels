{include file="../../error.tpl"}
{if isset(Core_Users::$info['subaccounts_limit']) && Core_Users::$info['subaccounts_limit']>0}<div class="alert alert-info">Number of Subaccounts You Can Create: {Core_Users::$info['subaccounts_limit']-$intSubaccountCount}</div>{/if}
<table class="table table-striped">
	<thead>
	<tr>
		<th>Name{include file="../../ord_frontend.tpl" field="buyer_name"}</th>
		<th width="300">Email{include file="../../ord_frontend.tpl" field="email"}</th>
		<th width="130">Added{include file="../../ord_frontend.tpl" field="added"}</th>
		<th width="130">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList key='k' item='v'}
	<tr{if $k%2=='0'} class="alt-row"{/if}>
		<td>{$v.buyer_name}</td>
		<td>{$v.email}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td class="option">
			<a href="{url name='site1_sp' action='create'}?id={$v.id}" ><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>&nbsp;
			<a href="{url name='site1_sp' action='manage'}?del={$v.id}" class="confirm-delete" confirm="Delete account?"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>&nbsp;
			<a href="{url name='site1_sp' action='manage'}?login={$v.id}&code={$v.link}" title="Login as {$v.email}"><i class="ion-log-in" style="font-size: 18px; vertical-align: bottom; color: #5fbeaa; margin: 0 5px;"></i></a>
		</td>
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