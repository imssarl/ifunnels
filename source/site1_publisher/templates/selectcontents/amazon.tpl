{if $arrList}
<table class="table table-striped">
	<thead>
		<tr>
			<th >Preview</th>
			<th >ASIN</th>
			<th >Title</th>
			{*<th >Autor</th>*}
			<th align="center" >
				<div class="checkbox checkbox-primary">
					<input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" />
					<label for="select_all"></label>
				</div>
			</th>
		</tr>
	</thead>
	<tbody>
	{$matros=0}
	{foreach from=$arrList key=k item=i}
		<tr {if $matros%2=='0'} class="alt-row"{/if}>
			<td align="center" style="text-align: center !important; "><a href="{$i.link2view}" target="_blank"><img src="{$i.preview}" alt=""/></a></td>
			<td valign="top"><a href="{$i.link2view}" target="_blank">{$i.asin}</a></td>
			<td valign="top"><span id="content_{$k}_title">{$i.title}</span></td>
			<td  valign="top" align="center">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" value="{$i.title}" id="{if !empty({$i.asin})}{$i.asin}{else}{$k}{/if}" key="{$i.id}" class="chk_item" />
					<label for="{if !empty({$i.id})}{$i.id}{else}{$k}{/if}"></label>
				</div>
			</td>
		</tr>
		{$matros=$matros+1}
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4">
				<div align="center" class="bulk-actions align-left">
					<button type="button" class="button btn btn-default waves-effect waves-light" id="choose">Choose</button>
				</div>
				{include file="../../../pgg_frontend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
{else}
<div align="center"><p>no content found</p></div>
{/if}