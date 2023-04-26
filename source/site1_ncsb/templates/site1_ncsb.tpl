<div class="card-box">
{if $arrPrm.flg_tpl==1 || $arrPrm.action=='admin_templates'}
{include file="site1_ncsb_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	{if !Core_Acs::haveAccess( array('Zonterest PRO') )}
	<div class="heading">
		{if !Core_Acs::haveAccess( array( 'DFY' ) )}<a class="menu" href="{url name='site1_ncsb' action='create'}">Create NCSB site</a> | 
		<a class="menu" href="{url name='site1_ncsb' action='import'}">Import NCSB site</a> | {/if}
		<a class="menu" href="{url name='site1_ncsb' action='manage'}">Manage NCSB Sites</a> | 
		<a class="menu" href="{url name='site1_ncsb' action='templates'}">Manage Template</a>
		{module name='site1_accounts' action='manage' strCurrent='site1_ncsb'}
	</div>
	{/if}
	{include file='../../box-top.tpl' title=$arrNest.title}
	{if in_array( $arrPrm.action, array('create','edit') )}
		{include file="site1_ncsb_create.tpl"}
	{else}
		{include file="site1_ncsb_`$arrPrm.action`.tpl"}
	{/if}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}
</div>