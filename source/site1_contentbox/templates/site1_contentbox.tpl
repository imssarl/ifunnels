{if $arrPrm.action=='select'}
{include file="site1_contentbox_`$arrPrm.action`.tpl"}
{else}
	{if $arrPrm.flg_tpl==1}
		{include file="site1_contentbox_`$arrPrm.action`.tpl"}
	{elseif $arrPrm.action}
		{include file='../../box-top.tpl' title=$arrNest.title}
		<div class="card-box">
		{include file="site1_contentbox_`$arrPrm.action`.tpl"}
		</div>
		{include file='../../box-bottom.tpl'}
	{else}
		wrong action!
	{/if}
{/if}

