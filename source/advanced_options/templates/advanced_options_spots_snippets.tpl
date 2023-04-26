<table>
	<thead>
    <tr>
        <th>Snippet #</th>
        <th>Title</th>
        <th>Description</th>
        <th># of parts</th>
        <th>Date created</th>
        <th>Intelligent<br/>tracking management<br/> enabled</th>
        <th># of impressions</th>
        <th># of clicks</th>
        <th>
            <input type="checkbox" value="snippets-{$spot_index}" class="select-all">
        </th>
    </tr>
	</thead>
	<tbody>
{foreach from=$arrList key=iKey item=i}
	{if 'Y' == $i.is_itm_enabled}
		{assign var=sItm value='Yes'}
		{else}
		{assign var=sItm value='No'}
	{/if}
    <tr  {if $iKey%2=='0'} class="alt-row"{/if}>
        <td>{$i.id}</td>
        <td>{$i.title}</td>
        <td>{$i.description}</td>
        <td>{$i.noofparts}</td>
        <td>{$i.created_date}</td>
        <td>{$sItm}</td>
        <td>{$i.noofimpression}</td>
        <td>{$i.noofclicks}</td>
        <td>
			{if $i.noofparts > 0}
                <input type="checkbox" name="arrOpt[spots][{$spot_index}][snippets][]"
                       class="item-snippets-{$spot_index}" type="checkbox" {if  in_array($i.id,$ids)} checked='1'{/if}
                       value="{$i.id}"/>
				{else}
                <img src="./images/denied.png" border="0" title="Please add a part before generate code">
			{/if}
			{foreachelse}
    <tr>
        <td colspan="12">No Save selection Found</td>
    </tr>
{/foreach}
	</tbody>
</table>