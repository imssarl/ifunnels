<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content" class="card-box">
	{if $msg == 'added'}
		{include file='../../message.tpl' type='info' message='Downloaded successfully'}
	{/if}
	{if isset($errorCode)}
		{foreach from=$errorCode item=i}
			{if $i == '011'}{include file='../../message.tpl' type='error' message='Uploaded file size is more than 5MB.Please upload below 5MB.'}{/if}
			{if $i == '012'}{include file='../../message.tpl' type='error' message='Invalid file.Please upload only zip file.'}{/if}
			{if $i == '013'}{include file='../../message.tpl' type='error' message='Invalid zip file.'}{/if}
			{if $i == '014'}{include file='../../message.tpl' type='error' message='Invalid Plugin.'}{/if}
			{if $i == '002'}{include file='../../message.tpl' type='error' message='This plugin is already exist.'}{/if}
		{/foreach}
	{/if}
	<form action="" method="GET" class="wh">
		<fieldset>
			<p>
				Search:&nbsp;<select style="width:50px;" name="arr[type]" class="small-input btn-group selectpicker show-tick">
					<option {if $smarty.get.arr.type=='tag'}selected='1'{/if} value="tag">tag
					<option {if $smarty.get.arr.type=='search'}selected='1'{/if} value="search">term
					<option {if $smarty.get.arr.type=='author'}selected='1'{/if} value="author">author
				</select>&nbsp;
				<input type="text" name="arr[search]" class="text-input small-input" value="{$smarty.get.arr.search}"/>
				<input type="submit" class="button" value="Search"/>
			</p>
		</fieldset>
		<fieldset></fieldset>
	</form>
	{if $arrList.info.results}
		<div>
			<span>Total {$arrList.info.results} record{if $arrList.info.results>1}s{/if}</span>&nbsp;
			{if $arrList.info.results > 21}
				{section name=i loop=$arrList.info.pages}
					{if $smarty.section.i.iteration==$arrList.info.page}
						<span><b>{$smarty.section.i.iteration}</b></span>
					{else}
						<a href="?page={$smarty.section.i.iteration}{if !empty($smarty.get.arr)}&arr[type]={$smarty.get.arr.type}&arr[search]={$smarty.get.arr.search}{/if}"
						   class="pg_handler">{$smarty.section.i.iteration}</a>
					{/if}
				{/section}
			{/if}
		</div>
	{/if}
	{if $arrList.info.results}
		<table>
			<thead>
			<tr>
				<th>Name</th>
				<th>Version</th>
				<th>Rating</th>
				<th width="450">Description</th>
				<th width="80" align="center">Actions</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrList.plugins item=i name=k}
				<tr{if $k%2=='0'} class="alt-row"{/if}>
					<td class="theme-item" align="left" valign="top">
						<a href="{$i->author_profile}" target="_blank">{$i->name}</a>
					</td>
					<td>{$i->version}</td>
					<td>
						<div style="width:100px;height:10px;border:1px solid #000;">
							<div style="width:{$i->rating}%;height:10px;background:red;"></div>
						</div>
					</td>
					<td width="350">
						{$i->description|replace:'<pre>':'<div>'|replace:'</pre>':'</div>'}
					</td>
					<td>
						<a href="#" rel="{$i->download_link}" class="download">Download</a>
					</td>
				</tr>
			{/foreach}
			</tbody>
		</table>
	{/if}
	{if $arrList.info.results}
		<div>
			<span>Total {$arrList.info.results} record{if $arrList.info.results>1}s{/if}</span>&nbsp;
			{if $arrList.info.results > 21}
				{section name=i loop=$arrList.info.pages}
					{if $smarty.section.i.iteration==$arrList.info.page}
						<span><b>{$smarty.section.i.iteration}</b></span>
					{else}
						<a href="?page={$smarty.section.i.iteration}{if !empty($smarty.get.arr)}&arr[type]={$smarty.get.arr.type}&arr[search]={$smarty.get.arr.search}{/if}"
						   class="pg_handler">{$smarty.section.i.iteration}</a>
					{/if}
				{/section}
			{/if}
		</div>
	{/if}
	<br/>
	<br/>

	<form action="" method="POST" id="form-download">
		<input type="hidden" name="arr[link]" id="download-link"/>
	</form>
	{literal}
		<style>
			.tb ul {
				padding: 2px 0 2px 15px;
			}
		</style>
		<script type="text/javascript">
			window.addEvent('domready', function () {
				$$('.download').each(function (item) {
					item.addEvent('click', function (e) {
						e.stop();
						$('download-link').value = item.rel;
						$('form-download').submit();
					});
				});
			});
		</script>
	{/literal}
</div>

<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
<script type="text/javascript">
    jQuery(document).ready(function($) {
		$('.selectpicker').selectpicker({
		  	style: 'btn-info',
		  	size: 4
		});
    });
</script>
</body>
</html>