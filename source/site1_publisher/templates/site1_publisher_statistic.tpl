<div class="card-box">
{include file='../../box-top.tpl' title=$arrNest.title}

{if $msg == 'delete'}{include file='../../message.tpl' type='info' message='Delete successfully.'}{/if}
{if $msg == 'error'}{include file='../../message.tpl' type='error' message='Error. Can\'t delete post.'}{/if}
<form action="" id="current-form" method="post">
<input type="hidden" name="mode" value="store-settings" id="mode" />
<table width="100%" class="table  table-striped">
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" id="delete_all"/>
				<label for="delete_all"></label>
			</div>
		</th>
		<th>Title{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_publisher' action='statistic' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_publisher' action='statistic' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="12%">Publish{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_publisher' action='statistic' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_publisher' action='statistic' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i key=k}
	<tr {if $k%2=='0'} class="alt-row"{/if}>
		<td style="padding-right:0;">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="contentIds[]" value="{$i.id}" id="delete_checkbox-{$i.id}" class="delete_checkbox"/>
				<label for="delete_checkbox-{$i.id}"></label>
			</div>
		</td>
		<td>{$i.title}</td>
		<td align="center">{$i.added|date_format:$config->date_time->dt_full_format}</td>
		<td align="center">
			<a target="_blank" href="{if $i.flg_type==1}{$i.url}article/{$i.link}.html{elseif $i.flg_type==2}{$i.url}{$i.link}.html{elseif $i.flg_type==3}{$i.url}article/{$i.link}.html{elseif $i.flg_type==4}{$i.url}permalink.php?article={$i.link}.txt{else}{$i.url}?p={$i.link}{/if}" class="click-me"><img title="View" src="/skin/i/frontends/design/buttons/see.png"/></a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4">
				<div  class="bulk-actions align-left">	
					<button type="submit" id="delete" class="button btn btn-default waves-effect waves-light">Delete</button>
				</div>
				{include file="../../pgg_frontend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
</form>
</div>
{literal}
<script type="text/javascript">
	window.addEvent('domready', function(){
		$('delete_all').addEvent('click',function(){
			$$('.delete_checkbox').each(function(el){
				el.checked=$('delete_all').checked;
			});
		});
		$('delete').addEvent('click',function(){
			$('current-form').submit();
		});
	});
</script>
{/literal}
{include file='../../box-bottom.tpl'}