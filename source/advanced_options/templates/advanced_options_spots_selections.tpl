<table>
	<thead>
		<tr>
			<th>Title</th>
			<th>Description</th>
			<th><input type="checkbox" class="select-all" value="articles-{$spot_index}"></th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$arrList key=iKey item=i}
		<tr {if $iKey%2=='0'} class="alt-row"{/if}>
			<td align="center" width="20%">{$i.name}</td>
			<td align="left">{$i.description|stripslashes}</td>			
			<td align="center">
				<input name="arrOpt[spots][{$spot_index}][articles][]" class="item-articles-{$spot_index}" type="checkbox" {if  in_array($i.id,$ids)} checked='1'{/if} value="{$i.id}" />
			</td>
		</tr>
		{foreachelse}
		<tr>
			<td align="center" colspan="3">No Save selection Found</td>
		</tr>
		{/foreach}
	</tbody>
</table>