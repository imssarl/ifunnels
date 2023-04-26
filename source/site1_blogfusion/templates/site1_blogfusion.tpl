<div class="card-box">
{if $arrPrm.flg_tpl==1 || $arrPrm.local||$arrPrm.action=='warning'}
	{include file="site1_blogfusion_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}

	<div class="heading">
		{if !Core_Acs::haveAccess( array( 'DFY' ) )}<a class="menu" href="{url name='site1_blogfusion' action='create'}">Create blog</a> | {/if}
		<a class="menu" href="{url name='site1_blogfusion' action='manage'}">Manage blogs</a> | 
		<a class="menu" href="{url name='site1_blogfusion' action='plugins'}">Plugins</a> | 
		<a class="menu" href="{url name='site1_blogfusion' action='themes'}">Themes</a>
		{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}{module name='site1_accounts' action='manage' strCurrent='site1_blogfusion'}{/if}
	</div>
{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="site1_blogfusion_`$arrPrm.action`.tpl"}
{include file='../../box-bottom.tpl'}
{/if}
</div>