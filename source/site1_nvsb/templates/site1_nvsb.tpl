<div class="card-box">
{if $arrPrm.flg_tpl==1 || $arrPrm.action=='admin_templates'}
{include file="site1_nvsb_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	<div class="heading">
		{if !Core_Acs::haveAccess( array( 'DFY' ) )}<a class="menu" href="{url name='site1_nvsb' action='create'}">Create NVSB site</a> | 
		<a class="menu" href="{url name='site1_nvsb' action='import'}">Import NVSB site</a> | {/if}
		<a class="menu" href="{url name='site1_nvsb' action='manage'}">Manage NVSB Sites</a> | 
		<a class="menu" href="{url name='site1_nvsb' action='templates'}">Manage Template</a>
		{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}{module name='site1_accounts' action='manage' strCurrent='site1_nvsb'}{/if}
	</div>
	{include file='../../box-top.tpl' title=$arrNest.title}
	{if in_array( $arrPrm.action, array('create','edit') )}
		{include file="site1_nvsb_create.tpl"}
	{else}
		{include file="site1_nvsb_`$arrPrm.action`.tpl"}
	{/if}
{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}
</div>