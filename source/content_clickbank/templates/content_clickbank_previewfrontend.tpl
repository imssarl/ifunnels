<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content" align="center">
{literal}
<style type="text/css">
	.images-block{padding:10px; float:left;}
	.border{ border: 1px solid #EEE;}
	.clear{clear: both; width: 100%;}
	body{background: #FFF !important;}
	#preview-block{width: 1024px !important; text-align: left;}
</style>
{/literal}
<div id="preview-block">
	<h3>Title: {$arrItem.title}</h3>
	<p><h3>Short description: </h3>{$arrItem.short_description}</p>
	<p><h3>Long description: </h3>{$arrItem.long_description}</p>
	{if !empty($arrItem.smallthumb_preview)}
	<div class="images-block border">
		<h4>Small thumb</h4>
		<img src='{img src=$arrItem.smallthumb_preview p=100}' />
	</div>
	{/if}
	<div class="clear"></div>
	{if !empty($arrItem.largethumb_preview)}
	<div class="images-block border" >
		<h4>Large thumb</h4>
		<img src='{img src=$arrItem.largethumb_preview p=100}' />
	</div>
	{/if}
</div>
</div>
</body>
</html>