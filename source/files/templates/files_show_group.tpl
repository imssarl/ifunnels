<script src="/skin/_js/player/swfobject.js" type="text/javascript"></script>
<script src="/skin/_js/player/nonverblaster.js" type="text/javascript"></script>
{literal}
<style type="text/css">
	.item {width:230px;height:auto;padding:3px;float:left;}
</style>
{/literal}
{if $arrList}
	<div style="display: inline;">
		{foreach from=$arrList item=file}
		<div class="item">
			<span style="margin:0px"><span style="margin:0px" id="item_name_{$file.id}">{$file.title|truncate:30:"..."}</span></span>
			<div class="object_{$file.id}">
			{include file="files_view_file.tpl"}
			</div>
			<center><a href="" class="chose_files" uid="{$file.id}">Choose</a></center>
			<br/>
		</div>
		{/foreach}
	</div>
	<br style="clear:both;"/>
	<div align="right">
		{include file="../../pgg_frontend.tpl"}
	</div>
{else}
	<div align="center">
		no files found
	</div>
{/if}
<script src="/skin/_js/player/adapter.js" type="text/javascript"></script>