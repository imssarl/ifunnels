{if $arrPrm.flg_tpl==1}
{include file="site1_squeeze_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	{if $arrPrm.action!='learnq_script'}
	{include file='../../box-top.tpl' title=$arrNest.title}
	{/if}
	{include file="site1_squeeze_`$arrPrm.action`.tpl"}
	{if $arrPrm.action!='learnq_script'}
	{include file='../../box-bottom.tpl'}
	{/if}
{else}
	wrong action!
{/if}