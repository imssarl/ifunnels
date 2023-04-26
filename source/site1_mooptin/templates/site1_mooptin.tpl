{if $arrPrm.flg_tpl==1 || $arrPrm.action=='select'}
{include file="site1_mooptin_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="site1_mooptin_`$arrPrm.action`.tpl"}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}