<div class="card-box">
{if $arrPrm.flg_tpl==1 || $arrPrm.action=='admin_templates'}
{include file="site1_nicheresearch_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	<div class="heading">
		<a class="menu" href="{url name='site1_nicheresearch' action='main'}">Main</a> |
		<a class="menu" href="{url name='site1_nicheresearch' action='top'}">Top 1000 Niches</a> |
		<a class="menu" href="{url name='site1_nicheresearch' action='random'}">Random Idea</a>
	</div>
	{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="site1_nicheresearch_`$arrPrm.action`.tpl"}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}
</div>