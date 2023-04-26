{if $arrList}
	<table width="100%">
		<thead>
		<tr>
			<th {if ({$smarty.get.arrFlt.flg_language}!=1)}rowspan="2"{/if} style="display:none;">Id</th>
			<th {if ({$smarty.get.arrFlt.flg_language}!=1)}rowspan="2"{/if}>Title</th>
			<th {if ({$smarty.get.arrFlt.flg_language}!=1)}rowspan="2"{/if}>Autor</th>
			{*{if ({$smarty.get.arrFlt.flg_language}==1)}<th {if ({$smarty.get.arrFlt.flg_language}!=1)}rowspan="2"{/if}>Summary</th>{/if}*}
			{if ({$smarty.get.arrFlt.flg_language}!=1)}<th colspan="2">Category</th>{/if}
			<th align="center" {if ({$smarty.get.arrFlt.flg_language}!=1)}rowspan="2"{/if}><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
		</tr>
		{if ({$smarty.get.arrFlt.flg_language}!=1)}<tr>
			<th>Main</th>
			<th>Secondary</th>
		</tr>{/if}
		</thead>
		<tbody>
	{foreach from=$arrList key=k item=i}
		<tr {if $k%2=='0'} class="alt-row"{/if}>
			<td align="center" style="display:none;">{$k}</td>
			<td><span id="content_{$k}_title">{$i.title}</span></td>
			<td><span id="autor_{if !empty({$i.id})}{$i.id}{else}{$k}{/if}">{$i.author}</span></td>
			{*{if ({$smarty.get.arrFlt.flg_language}==1)}<td align="center"><span id="summary_{if !empty({$i.id})}{$i.id}{else}{$k}{/if}">{$i.summary}</span></td>{/if}*}
			{if ({$smarty.get.arrFlt.flg_language}!=1)}<td align="center"><span id="category_{if !empty({$i.id})}{$i.id}{else}{$k}{/if}">{$i.category_title_main}</span></td>
			<td align="center"><span id="category_{if !empty({$i.id})}{$i.id}{else}{$k}{/if}">{$i.category_title_secondary}</span></td>{/if}
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