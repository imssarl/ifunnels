{if $arrList}
	<table width="100%">
		<thead>
		<tr>
			<th >Id</th>
			<th >Category</th>
			<th >Title</th>
			<th >Summary</th>
			<th align="center" ><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
		</tr>
		</thead>
		<tbody>
	{foreach from=$arrList key=k item=i}
		<tr {if $k%2=='0'} class="alt-row"{/if}>
			<td>{$i.id}</td>
			<td>{$i.category_title}</td>
			<td><span id="content_{$k}_title">{$i.title}</span></td>
			<td>{$i.summary}</td>
			<td align="center"><input type="checkbox" value="{$i.title}" id="{if !empty({$i.id})}{$i.id}{else}{$k}{/if}" class="chk_item" key="{$k}"/></td>
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