<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Form Name{include file="../../ord_backend.tpl" field='name'}</th>
	<th style="width:50px;">Activations Limit{include file="../../ord_backend.tpl" field='activations_limit'}</th>
	<th style="width:250px;">Secret Id{include file="../../ord_backend.tpl" field='secret_id'}</th>
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
		<td>{$v.name}</td>
		<td>{if $v.activations_limit>0}{$v.activations_limit}{else}unlimit{/if}</td>
		<td>{$v.secret_id}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td class="option">
			<a href="{url name='iam' action='manage_sites_pages'}?form_id={$v.id}">All Pages</a> | 
			<a href="{url name='iam' action='create_form'}?id={$v.id}">Edit</a> | 
			<a href="{url name='iam' action='manage_forms'}?delete={$v.id}" onclick="return confirm('Delete Customers?');">Delete</a>
		</td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
<br/>
<br/>
<br/>
<div style="width:50%;">
	<p>Activate Sites For User Form:</p>
	<code>{$htmlspecialchars_form}</code>
	<br/><br/>
	<a href="{$htmlspecialchars_activate_link}" target="_blank">{$htmlspecialchars_activate_link}</a>
</div>
<br/>
<br/>
<br/>
<div style="width:50%;">
	<p>Remove Sites From User Form:</p>
	<code>{$htmlspecialchars_remove_form}</code>
	<br/><br/>
	<a href="{$htmlspecialchars_remove_link}" target="_blank">{$htmlspecialchars_remove_link}</a>
</div>