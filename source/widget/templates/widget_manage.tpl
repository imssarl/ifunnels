{if $msg == 'delete'}
<div class="grn">Item has been deleted</div>
{elseif $msg=='delete_error'}
<div class="red">Item can't be deleted</div>
{elseif $msg=='created'}
<div class="grn">Item has been created</div>
{elseif $msg=='saved'}
<div class="grn">Item has been saved</div>
{/if}

<table class="info glow" width="100%">
<thead>
<tr>
	<th width="30%">Primary keyword{include file="../../ord_backend.tpl" field='d.primary_keyword'}</th>
	<th align="center">Edited{include file="../../ord_backend.tpl" field='d.edited'}</th>
	<th width="10%">Action</th>
</tr>
</thead>
	<tr>
		<td colspan="5"><a href="{url name='widget' action='create'}" class="mb" rel="" title="Create item">Add</a> new item</td>
	</tr>
<tbody>
{foreach from=$arrList key='k' item='v'}
<tr {if $k%2=='0'} class="matros"{/if}>
	<td>{$v.primary_keyword}</td>
	<td align="center" width="120">{$v.edited|date_format:'%Y-%m-%d'}</td>
	<td class="option">
		<a href="{url name='widget' action='manage'}?delete={$v.id}" class="delete" rel="{$v.primary_keyword}">del</a>&nbsp;&nbsp;
		<a href="{url name='widget' action='create'}?id={$v.id}">edit</a>
	</td>
</tr>
{/foreach}
</tbody>
</table>
<br/>
<div align="right" style="padding:0 20px 0 0;">
{include file="../../pgg_frontend.tpl"}
</div>

