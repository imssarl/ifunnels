
{if $arrPrm.action!='edit_url' && $arrPrm.action!='create' }
	{if $arrPrm.flg_tpl==1}
	{include file="site1_traffic_`$arrPrm.action`.tpl"}
	{elseif $arrPrm.action}
		<div class="heading">
			<a class="menu" href="{url name='site1_traffic' action='campaign'}">Create Campaign</a> | 
			<a class="menu" href="{url name='site1_traffic' action='manager'}">Manage Campaigns</a> | 
			<a class="menu" href="{url name='site1_traffic' action='promote'}">Promote Campaigns</a> | 
			<a class="menu" href="{url name='site1_traffic' action='manage_promote'}">Manage Promotions</a> | 
			<a class="menu" href="{url name='site1_traffic' action='browse'}">Browse Campaigns</a> | 
			<a class="menu" href="{url name='site1_traffic' action='credits'}">Credits</a>
		</div>
		<div class="heading">{if $trafficCredits>0}You have {$trafficCredits} traffic credits.{else}You don't have traffic credits.{/if}</div>
		{include file="site1_traffic_{$arrPrm.action}.tpl"}
	{else}
		wrong action!
	{/if}
{else}
	{include file="site1_traffic_{$arrPrm.action}.tpl"}
{/if}