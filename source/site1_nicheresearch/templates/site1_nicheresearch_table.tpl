<table class="table table-striped">
	<thead>
	<tr>
		<th width="50">ID{if empty($nosort)}{include file="../../ord_frontend.tpl" field="id"}{/if}</th>
		<th>{$field_title}{if empty($nosort)}{include file="../../ord_frontend.tpl" field="word"}{/if}</th>
		<th width="10%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="alt-row"{/if}>
		<td>{$v.id}</td>
		<td>{$v.word}</td>
		<td align="center">
			{*<a {is_acs_write} href="{url name='site1_traffic' action='create'}?keyword={$v.word}">Dig It</a>&nbsp;*}
			<a {is_acs_write} href="{url name='site1_nvsb' action='create'}?keyword={$v.word}"><img src="/skin/i/frontends/design/buttons/nvsb.png" border="0" /></a>
			<a {is_acs_write} href="{url name='site1_market_trands' action='popup'}?keywords={$v.word}" class="popup"><img src="/skin/i/frontends/design/buttons/market_trands.png" border="0" /></a>
		</td>
	</tr>
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="3">
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
{literal}
<script>
window.addEvent('domready',function(){
	var cera=new CeraBox( $$('.popup'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle:true,
		titleFormat:'{title}'
	});
});
</script>
{/literal}