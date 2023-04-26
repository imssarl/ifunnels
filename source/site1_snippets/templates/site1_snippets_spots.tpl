<table>
	<thead>
	<tr>
		<th>Snippet #</th>
		<th>Title</th>
		<th>Description</th>
		<th># of parts</th>
		<th>Date created</th>
		<th>Intelligent<br />tracking management<br /> enabled</th>
		<th># of impressions</th>
		<th># of clicks</th>
		<th>
			<input type="checkbox" value="snippets-{$spot_index}" class="select-all">
		</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i key=k}
		<tr {if $k%2=='0'} class="alt-row"{/if}>
			<td >{$i.id}</td>
			<td align="left">{$i.title}</td>
			<td align="left">{$i.description}</td>
			<td >{$i.parts}</td>
			<td >{$i.added|date_format:$config->date_time->dt_full_format}</td>
			<td >{if ($i.flg_enabled == '1')}Yes{else}No{/if}</td>
			<td >{$i.views}</td>
			<td >{$i.clicks}</td>
			<td >
		{if $i.parts > 0}
				<input type="checkbox" name="arrOpt[spots][{$spot_index}][snippets][]" class="item-snippets-{$spot_index}" type="checkbox" {if  in_array($i.id,$ids)} checked='1'{/if} value="{$i.id}" />
			{else}
				<img src="/skin/i/frontends/design/buttons/denied.png" border="0" title="Please add a part before generate code">
			{/if}
		{foreachelse}
		<tr>
			<td  colspan="12">No Save selection Found</td>
		</tr>
		{/foreach}
	</tbody>
</table>