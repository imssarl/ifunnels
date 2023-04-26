{if $arrList}
	<table style="width:100%;">
		<thead>
		<tr>
			<th>Title</th>
			<th>Category</th>
			<th align="center">
				<input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" />
			</th>
		</tr>
		</thead>
		<tbody>
	{foreach from=$arrList item=i key=k}
		<tr{if $k%2=='0'} class="alt-row"{/if}>
			<td><span id="content_{$i.id}_title">{$i.title}</span></td>
			<td><span id="category_{$i.id}">{$i.category}</span></td>
			<td align="center"><input type="checkbox" value="{$i.title}" id="{if !empty({$i.id})}{$i.id}{else}{$k}{/if}" key="{$k}" class="chk_item" /></td>
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