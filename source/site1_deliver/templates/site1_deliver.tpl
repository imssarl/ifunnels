{if $arrPrm.action}
	{include file="site1_deliver_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}