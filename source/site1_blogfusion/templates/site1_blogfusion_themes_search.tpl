<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	{if $msg == 'added'}
		{include file='../../message.tpl' type='info' message='Downloaded successfully'}
	{/if}
	{if isset($errorCode)}
		{foreach from=$errorCode item=i}
			{if $i == '011'}{include file='../../message.tpl' type='error' message='Uploaded file size is more than 5MB.Please upload below 5MB.'}{/if}
			{if $i == '012'}{include file='../../message.tpl' type='error' message='Invalid file.Please upload only zip file.'}{/if}
			{if $i == '013'}{include file='../../message.tpl' type='error' message='Invalid zip file.'}{/if}
			{if $i == '014'}{include file='../../message.tpl' type='error' message='Invalid Theme.'}{/if}
			{if $i == '002'}{include file='../../message.tpl' type='error' message='This theme is already exist.'}{/if}
		{/foreach}
	{/if}
	<form action="" method="GET" class="wh">
		<fieldset>
			<p>
				Search:&nbsp;<select style="width:50px;" name="arr[type]" class="small-input">
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
		<div style="width:auto;float:right;padding:3px;">
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
	<table>
		<tbody>
		<tr>
			{foreach from=$arrList.themes item=i name=x}
			<td class="theme-item" align="left" valign="top">
				<div class="in">
					{if !empty($i->screenshot_url)}<img src="{$i->screenshot_url}" width="220" height="225" />{/if}
					<h1>{$i->name}</h1>
					<a href="#" rel="{$i->download_link}" class="download">Download</a> | <a href="{$i->preview_url}"
																							 target="_blank">Preview</a>
					<br/>

					<p>{$i->description}</p>
					<a href="#" class="details">Details</a>

					<div class="item-details" style="display:none;">
						<p><b>Version:</b> {$i->version}</p>

						<p><b>Author:</b> {$i->author}</p>

						<p><b>Last Updated:</b> {$i->last_updated}</p>

						<p><b>Downloaded:</b> {$i->downloaded} times</p>

						<div style="width:100px;height:10px;border:1px solid #000;">
							<div style="width:{$i->rating}%;height:10px;background:red;"></div>
						</div>
					</div>
				</div>
			</td>
			{if $smarty.foreach.x.iteration%3==0}
		</tr>
		<tr>
			{/if}
			{/foreach}
		</tr>
		</tbody>
	</table>
	{if $arrList.info.results}
		<div style="width:auto;float:right;padding:3px;">
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
			.theme-item {
				width: 32%;
				border: 1px solid #AAA;
			}

			.theme-item .in {
				padding: 5px;
			}
		</style>
		<script type="text/javascript">
			window.addEvent('domready', function () {
				$$('.details').each(function (item) {
					item.addEvent('click', function (e) {
						e.stop();
						item.getNext('div').setStyle('display', (item.getNext('div').style.display == 'block') ? 'none' : 'block');
					});
				});
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
</body>
</html>