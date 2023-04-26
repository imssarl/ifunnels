{if $arrList}
	<table>
	<thead>
	<tr>
		<th>Id</th>
		<th>Title</th>
		<th>Category</th>
		<th><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr  {if $k%2=='0'} class="alt-row"{/if}>
		<td align="center">&nbsp;{$v.id}</td>
		<td>{$v.title}</td>
		<td align="center">{$v.category}</td>
		<td align="center">
			<input type="checkbox" class="chk_item" value="{$v.title}" id="{if !empty({$v.id})}{$v.id}{else}{$k}{/if}" key="{$k}"/>
		</td>
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