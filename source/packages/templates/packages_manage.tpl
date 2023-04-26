{if $arrList}
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Title{include file="../../ord_backend.tpl" field='d.title'}</th>
	<th>Type{include file="../../ord_backend.tpl" field='d.flg_type'}</th>
	<th>Price{include file="../../ord_backend.tpl" field='d.cost'}</th>
	{*<th>Sites num{include file="../../ord_backend.tpl" field='d.num_sites'}</th>*}
	<th>Special offer{include file="../../ord_backend.tpl" field='d.flg_hide'}</th>
	<th>Credits{include file="../../ord_backend.tpl" field='d.credits'}</th>
	<th>Cycles{include file="../../ord_backend.tpl" field='d.cycles'}</th>
	<th>Edited{include file="../../ord_backend.tpl" field='d.edited'}</th>
	<th>Added{include file="../../ord_backend.tpl" field='d.added'}</th>
	<th>Options</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="0">{include file="../../pgg_backend.tpl"}</td>
	</tr>
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<td>{$v.title}</td>
	<td>{if $v.flg_type}Credits{else}Package{/if}</td>
	<td>${$v.cost}</td>
	{*<td>{if $v.flg_type}-{else}{if $v.num_sites==0}unlimited{else}{$v.num_sites}{/if}{/if}</td>*}
	<td>{if $v.flg_hide==1}yes{else}no{/if}</td>
	<td>{$v.credits}</td>
	<td>{$v.cycles}</td>
	<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td class="option">
			<a href="{url}?delete={$v.id}" class="delete">del</a> |
			<a href="{url name='packages' action='set'}?id={$v.id}">edit</a> | 
			<a href="{$v.click2sell_url}" target="_blank">click2sell</a> |
			<a href="http://{Core_Module_Router::$domain}/registration/?p={Core_Payment_Encode::encode($v.id)}" class="get-link">link</a>{* |
			<a href="http://{Core_Module_Router::$domain}/membermouse/?p={Core_Payment_Encode::encode($v.id)}" class="get-link">MemberMouse Link</a>*}
	</td>
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
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	$$('.get-link').addEvent('click', function(e){
		e.stop();
		alert(this.href);
	});
	$$('.delete').each(function(item){
		item.addEvent('click',function(e){
			if( !confirm('Delete package?') ){
				e.stop();
			}
		})
	});
});

</script>
{/literal}