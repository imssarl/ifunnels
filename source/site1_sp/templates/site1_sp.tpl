<div class="card-box">
{if $arrPrm.flg_tpl==1}
{include file="site_sp_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	<div class="heading">
		<a class="menu" href="{url name='site1_sp' action='create'}">Create</a> |
		<a class="menu" href="{url name='site1_sp' action='manage'}">Manage</a>
	</div>
	{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="site1_sp_`$arrPrm.action`.tpl"}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}
</div>