{if $arrPrm.action}
	{include file="site1_automations_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}