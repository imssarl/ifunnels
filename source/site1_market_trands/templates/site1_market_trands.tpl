<div class="card-box">
{if $arrPrm.action}
	{include file="site1_market_trands_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}
</div>