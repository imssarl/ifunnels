{if $arrPrm.action}
	{include file="site1_funnels_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}