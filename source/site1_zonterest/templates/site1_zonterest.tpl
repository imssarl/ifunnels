<div class="card-box">
{if $arrPrm.flg_tpl==1 || $arrPrm.action=='admin_templates' || $arrPrm.action=='getstarted'}
{include file="site1_zonterest_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	{if Core_Acs::haveAccess( array('Zonterest PRO 2.0', 'Zonterest 2.0') )}
	<div class="heading">
		<a class="popup-main-wizards" href="#wizards">Create AzonFunnel</a>
	</div>
	{/if}
	<h1><img src="/skin/i/frontends/design/logo-azonfunnels.png" alt="" style="width: 300px;"></h1>			
	{*include file='../../box-top.tpl' title=$arrNest.title*}
	{if in_array( $arrPrm.action, array('create','edit') )}
		{include file="site1_zonterest_create.tpl"}
	{else}
		{include file="site1_zonterest_`$arrPrm.action`.tpl"}
	{/if}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}
</div>