{if $arrPrm.action}
	<div class="heading">
		<a class="menu" href="{url name='site1_affiliate' action='create'}">Create Links</a> | 
		<a class="menu" href="{url name='site1_affiliate' action='manage'}">Manage Links</a> 
	</div>
{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="site1_affiliate_`$arrPrm.action`.tpl"}
{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}