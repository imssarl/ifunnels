{if $arrPrm.flg_tpl==1}
{include file="site1_domain_parking_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
<div class="heading" style="margin: 0 0 20px 0;">
	<a class="menu" href="{url name='site1_domain_parking' action='create'}">Create</a> |
	<a class="menu" href="{url name='site1_domain_parking' action='manage'}">Manage Project</a> |
	<a class="menu" href="{url name='site1_domain_parking' action='manage_domain'}">Manage your Parked Domains</a>
</div>
	{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="site1_domain_parking_`$arrPrm.action`.tpl"}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}