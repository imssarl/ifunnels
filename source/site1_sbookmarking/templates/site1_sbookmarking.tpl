{if $arrPrm.action}
	{include file='../../box-top.tpl' title=$arrNest.title}
	<div style="text-align:center;margin-bottom:10px;"><a href="{$config->path->html->user_files}cnm_help/socialbookmarking.pdf">Need help? Download the user's guide HERE</a></div>
	{include file="site1_sbookmarking_`$arrPrm.action`.tpl"}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}