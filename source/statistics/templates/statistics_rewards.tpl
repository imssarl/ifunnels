{if $arrList}
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:80px;">Date{include file="../../ord_backend.tpl" field='d.added'}</th>
	<th style="width:80px;">Time{include file="../../ord_backend.tpl" field='d.added'}</th>
	<th style="width:250px;">User(email){include file="../../ord_backend.tpl" field='d.bayer_name'}</th>
	<th style="width:80px;">Spent{include file="../../ord_backend.tpl" field='d.amount'}</th>
	<th>Description</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="0">{include file="../../pgg_backend.tpl"}</td>
	</tr>
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<td>{$v.added|date_format:"%Y.%m.%d"}</td>
	<td>{$v.added|date_format:"%T"}</td>
	<td><a href="{url name='members' action='set' wg="id={$v.user_id}"}">{$v.bayer_name} {$v.buyer_surname} ({$v.email})</td>
	<td>{$v.amount}</td>
	<td>{$v.description}</td>
</tr>
{/foreach}
	<tr>
		<td colspan="0">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
{else}
<div>No items finded</div>
{/if}