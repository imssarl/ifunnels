{if $arrPrm.action}
	<h1>{$arrPrm.title}</h1>
	{include file="site1_hiam_lite_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}