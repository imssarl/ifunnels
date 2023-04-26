{if $arrList}
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Title{include file="../../ord_frontend.tpl" field='d.title'}</th>
	<th>Type{include file="../../ord_frontend.tpl" field='d.flg_type'}</th>
	<th>Priority{include file="../../ord_frontend.tpl" field='d.flg_priority'}</th>
	<th>Status</th>
	<th>Start{include file="../../ord_frontend.tpl" field='d.start'}</th>
	<th>End{include file="../../ord_frontend.tpl" field='d.end'}</th>
	<th>Edited{include file="../../ord_frontend.tpl" field='d.edited'}</th>
	<th>Added{include file="../../ord_frontend.tpl" field='d.added'}</th>
	<th>Options</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="8">{include file="../../pgg_frontend.tpl"}</td>
	</tr>
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<td>{$v.title}</td>
	<td>{if $v.flg_type==0}dashboard{else}popup{/if}</td>
	<td>{if $v.flg_priority}on{/if}</td>
	<td>{if ( $v.flg_type==0 && $v.end > time() ) || ( $v.flg_type==1 && $v.flg_priority ) }active{else}inactive{/if}</td>
	<td>{$v.start|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.end|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td class="option">
			<a href="{url}?delete={$v.id}" class="delete">del</a> |
			<a href="{url name='site1_hiam_lite' action='create'}?id={$v.id}">edit</a>
	</td>
</tr>
{/foreach}
	<tr>
		<td colspan="8">{include file="../../pgg_frontend.tpl"}</td>
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