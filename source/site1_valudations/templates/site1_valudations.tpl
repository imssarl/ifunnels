{if $arrPrm.action}
	{include file="site1_valudations_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}