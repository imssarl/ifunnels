{if $arrList}
	<table style="width:100%;">
	<thead>
	<tr>
		<th>Title</th>
		<th>Short description</th>	
		{*<th>Edited</th>	
		<th>Added</th>*}
		<th><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList key=k item=v}
	<tr {if $k%2=='0'} class="alt-row"{/if}>
		<td><span id="content_{$v.id}_title">{$v.title}</span></td>
		<td><span id="content_{$v.id}_title">{$v.short_description}</span></td>
		{*<td align="center"><span id="content_{$v.id}_title">{$v.edited|date_format:"%Y-%m-%d"}</span></td>
		<td align="center"><span id="content_{$v.id}_title">{$v.added|date_format:"%Y-%m-%d"}</span></td>*}
		<td align="center" class="option"> 
		<input type="checkbox" value="{$v.title}" id="{if !empty({$v.id})}{$v.id}{else}{$k}{/if}" key="{$k}" class="chk_item" />
		</td>
	</tr>
	{/foreach}
	</tbody>
		<tfoot>
		<tr>
			<td colspan="3">
				<div align="center" class="bulk-actions align-left">
					<input type="button" value="Choose" class="button" id="choose"/>
				</div>
				{include file="../../../pgg_frontend.tpl"}
			</td>
		</tr>
		</tfoot>
	</table>
{else}
	<div align="center"><p>no content found</p></div>
{/if}