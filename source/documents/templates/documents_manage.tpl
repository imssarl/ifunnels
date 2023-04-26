{if $arrList}
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Title{include file="../../ord_backend.tpl" field='d.title'}</th>
	<th>Sys name{include file="../../ord_backend.tpl" field='d.edited'}</th>
	<th>Edited{include file="../../ord_backend.tpl" field='d.edited'}</th>
	<th>Added{include file="../../ord_backend.tpl" field='d.added'}</th>
	<th>Options</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="4">{include file="../../pgg_backend.tpl"}</td>
	</tr>
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<td>{$v.title}</td>
	<td>{$v.sys_name}</td>
	<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td class="option">
			<a href="{url}?delete={$v.id}" class="delete">del</a> |
			<a href="{url name='documents' action='set'}?id={$v.id}">edit</a>
	</td>
</tr>
{/foreach}
	<tr>
		<td colspan="4">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
{else}
<div>No items finded</div>
{/if}
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
});
</script>
{/literal}