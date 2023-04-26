{if !isset($arrList)}
{if count($arrErr) > 0}<div class="red" style="padding:10px;">{foreach from=$arrErr item=err key=val}Error in {$val}<br />{/foreach}</div>{/if}
<div class="card-box">
	<form action="" method="get" class="wh validate" id="newsplit" style="width:67%;">
		<p>Please enter a keyword in the field on the right and we will return a list of the most relevant niche related :<br />
		- Forums<br />
		- Blogs<br />
		- Social Networks<br />
		- Directories</p>
		<fieldset>
			<div class="form-group">
				<label>Keyword</label>
				<input type="text" size="50" class="form-control" value="{$smarty.get.keyword}" name="arrData[keyword]"/>
			</div>
			<div class="form-group">
				<label>Datacenter</label>
				<select name="arrData[datacenter]"  class="btn-group selectpicker show-tick not_started in_progress cross_linking completed required validate-custom-required">
					{foreach from=$arrDatacenters item=i key=k}
					<option value="{$k}">{$i.name}</option>
					{/foreach}
				</select>
			</div>
			<div class="form-group">
				<label>Type</label>
				<select name="arrData[type]" class="btn-group selectpicker show-tick not_started in_progress cross_linking completed required validate-custom-required">
					{foreach from=$arrTypes item=i}
					<option value="{$i}">{$i}</option>
					{/foreach}
				</select>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-success waves-effect waves-light" id="search">Search</button>
			</div>
		</fieldset>
	</form>
	{else}
	<div class="heading">
		<a class="menu" href="{url name='site1_traffic' action='create'}">New search</a>&nbsp;|&nbsp;
		{foreach from=$arrTypes item=i}{if $i!=$smarty.get.arrData.type}{$query=$smarty.get}{$query.arrData.type=$i}
		<a class="menu" href="{url name='site1_traffic' action='create' wg=$query }">{$i}</a>&nbsp;|&nbsp;
		{/if}{/foreach}
		{$query=$smarty.get}{if !isset($smarty.get.arrData.expand) || $smarty.get.arrData.expand=='false'}{$query.arrData.expand='true'}{else}{$query.arrData.expand='false'}{/if}
		<a class="menu" href="{url name='site1_traffic' action='create' wg=$query }">{if $smarty.get.arrData.expand=='true'}No {/if}Expand</a>
		&nbsp;|&nbsp;
		<a class="menu" href="{url name='site1_traffic' action='create' wg=$smarty.get }&file=true" target="_blank">Export</a>
	</div>
		<br/>
		<br/>
	<div>
		<b>Keyword:</b> {$smarty.get.arrData.keyword}
	</div>
	<table style="width:100%;" align="center" >
		<thead>
		<tr class="tableheading">
			<th width="40%" align="center">Title</th>
			<th width="60%">Description</th>
		</tr>
		</thead>
		<tbody>
		{foreach from=$arrList item=i key=k}
		<tr id="row{$k}"{if $k%2=='0'} class="alt-row"{/if}>
			<td align="left"><a href="{$i.url}" target="_blank">{strip_tags($i.title)|wordwrap:80:'<br/>':false}</a><br/>{$i.url|wordwrap:60:'<br/>':true}</td>
			<td align="left">{strip_tags($i.description)}</td>
		</tr>{foreachelse}
		<tr><td align='center' colspan='12'>No data</td></tr>
		{/foreach}
		</tbody>
	</table>
	<div align="right">
	{include file="../../pgg_frontend.tpl"}
	</div>
</div>
{/if}
