{if !empty($arrErr)}{include file='../../message.tpl' type='error' message='Error: {$arrErr}'}{/if}
{if !empty($msg)}
	{if $msg == 'delete'}
		{include file='../../message.tpl' type='success' message='Deleted successfully.'}
	{elseif $msg == 'create'}
		{include file='../../message.tpl' type='success' message='Project created.'}
	{elseif $msg == 'edit'}
		{include file='../../message.tpl' type='success' message='Project edited.'}
	{/if}
{/if}

{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
<div align="center" style="padding:10px 0 0 0; ">
	<a href="{url name='site1_publisher' action='projects_manage'}">Manage</a> | <a href="{url name='site1_publisher' action='project_create'}">Create</a>
</div>

<form action="" id="current-form" method="post">
<input type="hidden" name="mode" value="store-settings" id="mode" />
<table width="100%" class="table  table-striped">
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px"><input type="checkbox" id="del" class="tooltip" title="mass delete" rel="check to select all" /></th>
		<th>Project{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_publisher' action='blog' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_publisher' action='blog' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Posting Status</th>
		<th width="10%">Project Status{if count($arrList)>1}
			{if $arrFilter.order!='flg_status--up'}<a href="{url name='site1_publisher' action='blog' wg='order=flg_status--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_status--dn'}<a href="{url name='site1_publisher' action='blog' wg='order=flg_status--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Project Type{if count($arrList)>1}
			{if $arrFilter.order!='flg_source--up'}<a href="{url name='site1_publisher' action='blog' wg='order=flg_source--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_source--dn'}<a href="{url name='site1_publisher' action='blog' wg='order=flg_source--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="15%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i key=k}
	<tr{if $k%2=='0'} class="alt-row"{/if}>
		<input type="hidden" name="ids[]" value="{$i.id}" />
		<td style="padding-right:0;">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="del[{$i.id}]" value="{$i.id}" class="check-me-del" id="check-{$i.id}" />	
				<label></label>
			</div>
			
		</td>
		<td>{$i.title}</td>
		<td align="center">{if $i.flg_mode == 1}{$i.count_posted_content}/{$i.count_content}{else}{$i.counter}{/if}</td>
		<td align="center">{if $i.flg_status == 0}not started{elseif $i.flg_status == 1}in progress{elseif $i.flg_status == 2}cross linking{elseif $i.flg_status == 3}completed{else}error{/if}</td>
		<td align="center">{foreach Project_Content::toLabelArray() item=name key=ids}{if {$name.flg_source}=={$i.flg_source}}{$contentTypeName = $name.title}{/if}{/foreach}
		{$contentTypeName}</td>
		<td align="center">
			<a {is_acs_write} href="{url name='site1_publisher' action='statistic'}?id={$i.id}" title="Stats"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
			<a {if $i.flg_status!=3}{is_acs_write}{/if} href="{url name='site1_publisher' action='project_create'}?id={$i.id}">{if $i.flg_status == 3}<i class="ion-eye" title="View" style="color:#34d3eb; vertical-align: middle; font-size:20px;"></i>{else}<i class="ion-edit" title="Edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i>{/if}</a>
			<a {is_acs_write} href="#" rel="{$i.id}" class="click-me-del" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
				<p>
					<button type="submit" id="delete" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Delete</button>
				</p>
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
</form>
</div>
{literal}
<script>
$$('.click-me-del').each(function(el){
	el.addEvent('click', function(e) {
		e && e.stop();
		$('check-'+el.rel).checked = true;
		$('current-form').submit();
	});
});
$('del').addEvent('click',function(){
	$$('.check-me-del').each(function(el){
		el.checked = $('del').checked;
	});
});
$('delete').addEvent('click',function(){
	$('current-form').submit();
});
</script>
{/literal}
{include file='../../box-bottom.tpl'}