	{if $arrList}
	<table style="width:100%;">
	<thead>
	<tr>
		<th>Category{if count($arrList)>1}
			{if $arrFilter.order!='category_id--up'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category_id--dn'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Source{if count($arrList)>1}
			{if $arrFilter.order!='source_id--up'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=source_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='source_id--dn'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=source_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Title{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Edited{if count($arrList)>1}
			{if $arrFilter.order!='edited--up'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=edited--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='edited--dn'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=edited--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Added{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_publisher' action='selectcontent' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="matros"{/if}>
		<td>&nbsp;{$arrSource.category[$v.category_id]}</td>
		<td>{$arrSource.source[$v.source_id]}</td>
		<td>{$v.title}</td>
		<td align="center">{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td align="center">{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td align="center">
			<div style="display:none;" id="content_{$v.id}_title">{$v.title}</div>
			<div style="display:none;" id="video_{$v.id}_body">{$v.body}</div>
			<div style="display:none;" id="video_{$v.id}_url_of_video">{$v.url_of_video}</div>		
			<input type="checkbox" class="chk_item" value="{$v.title}" id="{if !empty({$v.id})}{$v.id}{else}{$k}{/if}" key="{$k}"/>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr><td colspan="{$arrFilter.fields_num+3}">
				<div align="center" class="bulk-actions align-left">
					<input type="button" value="Choose" class="button" id="choose"/>
				</div>
				{include file="../../../pgg_frontend.tpl"}</td></tr>
	</tfoot>
	</table>
	{else}
		<p>no content found</p>
	{/if}