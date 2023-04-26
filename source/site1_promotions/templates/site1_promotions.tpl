{if $arrPrm.flg_tpl!=1}
<div class="heading">
	{if Core_Acs::haveRight(['site1_promotions'=>['mass_promotions']])}<a class="menu" href="{url name='site1_promotions' action='mass_promotions'}">Mass Social Campaign Creation</a> | {/if}
	<a class="menu" href="{url name='site1_promotions' action='custom_promotions'}">Social Media Campaigns</a> | 
	<a class="menu" href="{url name='site1_promotions' action='default_settings'}">Default Campaign Settings</a>
</div>
<br/>
{include file="site1_promotions_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action=='popup'}
	{include file="site1_promotions_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}