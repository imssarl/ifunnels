{if $flg_content == 1}
<table>
	<thead>
	<tr  class="tableheading">
	<th >Test&nbsp;Name</th>
	<th >Campaigns&nbsp;Included</th>
	<th >Date&nbsp;Created</th>
	<th >Duration</th>
	<th >Status</th>
	<th><input type='checkbox' class="select-all" value="dams"></th>
</tr>
	</thead>
	<tbody>
	{if !empty($arrList)}
		{foreach from=$arrList item=i name=i}
		<tr class='{if $smarty.foreach.i.iteration%2==0}alt-row{/if}' >
			<td align="left">{$i.title}</td>
			<td align="left" title="" >{foreach from=$i.arrCom item=company key=pid name=companies}{$company.title}{if !$smarty.foreach.companies.last },&nbsp;{/if}{/foreach}</td>
			<td align="left">{$i.added|date_format:$config->date_time->dt_full_format}</td>
			<td align="left" nowrap="true">{if $i.flg_duration=='1'}{$i.duration} days{elseif $i.flg_duration=='2'}{$i.duration} hits{else}Not Restricted{/if}</td>
			<td align="left">{if $i.flg_enabled!='0'}Completed{else}Running{/if}</td>
			<td><input class="item-dams" name='arrOpt[dams][ids][]' type='checkbox' value='{$i.id}' {if in_array($i.id,$ids)} checked='1' {/if} /></td>
		</tr>
		{/foreach}
	{/if}
	</tbody>
	<tfoot>
		<tr>
			<td align='center' colspan='7'  class="heading">&nbsp;</td>
		</tr>
	<tfoot>
</table>
{elseif $flg_content == 2}
<table>
<thead>
<tr  class="tableheading">
	<th>Campaign name</th>
	<th>Start date</th>
	<th>End date</th>
	<th>Ad type</th>
	<th>On action</th>
	<th>Play sound</th>
	<th>Mode</th>
	<th>Impressions</th>
	<th>Clicks</th>
	<th>Effectiveness</th>
	<th><input type='checkbox' class="select-all" value="dams"></th>
</tr>
</thead>
<tbody>
{if !empty($arrList)}
{foreach from=$arrList item=i name=j}
	<tr  class='{if $smarty.foreach.j.iteration%2==0}alt-row{/if}' >
		<td align="left">{$i.title}</td>
		<td align="left" title="" >{if $i.start_date} {$i.start_date|date_format:$config->date_time->dt_full_format} {else} - {/if}</td>
		<td align="center" class="general">{if $i.end_date} {$i.end_date|date_format:$config->date_time->dt_full_format} {else} - {/if}</td>
		<td align="center" nowrap="true">{if $i.flg_poss==1}Slide In{/if}{if $i.flg_posc==1}{if $i.flg_poss==1},{/if} Corner{/if}{if $i.flg_posf==1}{if $i.flg_posc==1 || $i.flg_poss==1},{/if} Fix Position{/if}</td>
		<td align="center">{if $i.flg_action=='0'}On Load{else}Leaving the page{/if}</td>
		<td align="center">{if $i.flg_sound=='0'}No{else}Yes{/if}</td>
		<td align="center">{if $i.flg_display=='0'}Always{else}Once Per Session{/if}</td>
        <td align="center">{$i.views}</td>
        <td align="center">{if $i.clicks > 0}<a title="View Details" style="cursor:pointer" rel="" href="{url name='site1_hiam' action='summary'}?id={$i.id}&view=clicks" class="popup">{$i.clicks}</a>{else}0{/if}</td>
        <td align="center">{if $i.effectiveness > 0}<a title="View Details" style="cursor:pointer" rel="" href="{url name='site1_hiam' action='summary' }?id={$i.id}&view=effectiveness" class="popup">{$i.effectiveness}</a>{else}0{/if}</td>
		<td><input class="item-dams" name='arrOpt[dams][ids][]' type='checkbox' value='{$i.id}' {if in_array($i.id,$ids)} checked='1' {/if} /></td>
	</tr>
	{/foreach}	
	{else}
		<tr><td align='center' colspan='12'>No Campaign Found</td></tr>
	{/if}
</tbody>
	<tfoot>
		<tr ><td align='center' colspan='15'  class="heading">&nbsp;</td></tr>
	</tfoot>
</table>	
{/if}

