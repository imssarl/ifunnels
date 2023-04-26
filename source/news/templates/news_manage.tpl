<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Title{include file="../../ord_backend.tpl" field='title'}</th>
	<th style="width:250px;">Added{include file="../../ord_backend.tpl" field='added'}</th>
	<th>Edited{include file="../../ord_backend.tpl" field='edited'}</th>
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
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
	<td class="option">
		<a href="{url name='news' action='add' wg="id={$v.id}"}">edit</a>
		<a href="{url name='news' action='manage'}?delete={$v.id}" onclick="return confirm('Delete News?');">delete</a>
	</td>
</tr>
{/foreach}
	<tr>
		<td colspan="5">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
</form>