<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="/skin/_css/site1.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="/skin/_css/style1.css" rel="stylesheet" type="text/css" media="screen" />
	<script type="text/javascript" src="/skin/_js/mootools.js"></script>
	<script src="/skin/_js/player/swfobject.js" type="text/javascript"></script>
	<script src="/skin/_js/player/nonverblaster.js" type="text/javascript"></script>
	{literal}
	<style type="text/css">
		.item {width: 300px;height:auto;padding:3px;float:left;}
	</style>
	{/literal}
</head>
<body style="padding:10px;">
<form action="" class="wh" style="width:100%;">
	<div class="item" align="center">
	{include file="files_view_file.tpl"}
	</div>
<fieldset style="border-top-width: 0px;margin-bottom: 0px">
	<ol>
		<li>
			<label>Title:</label>
				{if !empty($file.title)}&quot;{$file.title}&quot;{else}no title{/if}
		</li>
		<li>
			<label>Extension:</label>
				.{$file.extension}
		</li>
		<li>
			<label>Size:</label>
				{$file.size} b
		</li>
		<li>
			<label>Original Name:</label>
				<div>
					{$file.name_original}
				</div>
		</li>
		
		<li>
			<label>Description:</label>
				<div>
					{if !empty($file.description)}"{$file.description}"{else}no description{/if}
				</div>
		</li>
		<li>
			<label>Moderate status:</label>
			{if $v.flg_moderate=='0'}
				premoderated
			{elseif $v.flg_moderate=='1'}
				accept
			{else}
				reject
			{/if}
		</li>
		<li>
			<label>Moderate comment:</label>
			<div>
				{if !empty($file.comment)}"{$file.comment}"{else}no comments{/if}
			</div>
		</li>
		<li>
			<label>Converted date:</label>
				{$file.converted|date_local:$config->date_time->dt_full_format}
		</li>
		<li>
			<label>Added date:</label>
				{$file.added|date_local:$config->date_time->dt_full_format}
		</li>
		<li>
			<label>Edited date:</label>
				{$file.edited|date_local:$config->date_time->dt_full_format}
		</li>
	</ol>
</fieldset>
</form>
<script src="/skin/_js/player/adapter.js" type="text/javascript"></script>
</body>
</html>