{if $arrPrm.action}
	<h1>{$arrPrm.title}</h1>
	{include file="api_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}
