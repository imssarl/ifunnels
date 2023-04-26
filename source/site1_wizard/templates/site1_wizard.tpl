<div class="card-box">
{if $arrPrm.action}
	{include file="site1_wizard_{$arrPrm.action}.tpl"}
{else}
	wrong action!
{/if}
</div>
