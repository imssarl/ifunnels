<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Site Url{include file="../../ord_backend.tpl" field='site_url'}</th>
	<th>Added{include file="../../ord_backend.tpl" field='added'}</th>
	<th>Edited{include file="../../ord_backend.tpl" field='edited'}</th>
	<th>Options</th>
</tr>
</thead>

<tbody>
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<td>{$v.site_url}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td class="option">
			<a href="{url name='iam' action='create_site'}?id={$v.id}">Edit</a> | 
			<a href="{url name='iam' action='manage_sites'}?download={$v.id}">Download</a> | 
			<a href="{url name='iam' action='manage_sites'}?delete={$v.id}" onclick="return confirm('Delete Customers?');">Delete</a>
		</td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>