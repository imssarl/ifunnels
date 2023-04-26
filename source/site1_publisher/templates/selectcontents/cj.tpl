{if $arrList}
	<table>
		<thead>
		<tr>
			<th style="display:none;">Id</th>
			<th>Title</th>
			<th>Price</th>
			<th align="center">
				<input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" />
			</th>
		</tr>
		</thead>
		<tbody>
	{foreach from=$arrList item=i key=k}
		<tr  {if $k%2=='0'} class="alt-row"{/if}>
			<td align="center" style="display:none;">{$i.id}</td>
			<td><span id="content_{$i.id}_title">{$i.title}</span></td>
			<td align="center"><span id="category_{$i.id}">{$i.price} {$i.currency}</span></td>
			<td align="center"><input type="checkbox" value="{$i.title}" id="{if !empty({$i.id})}{$i.id}{else}{$k}{/if}" key="{$k}" class="chk_item" /></td>
		</tr>
	{/foreach}
		</tbody>
		<tfoot>
			<tr>
				<td colspan="4">
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