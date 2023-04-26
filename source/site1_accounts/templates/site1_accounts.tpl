
{if $arrPrm.action}
{if $arrPrm.action=='settings' || $arrPrm.action=='info' || $arrPrm.action=='details' || $arrPrm.action=='profile' || $arrPrm.action=='payment'|| $arrPrm.action=='api'|| $arrPrm.action=='payment_history'|| $arrPrm.action=='calls'}
<div class="heading">
	<a class="menu" href="{url name='site1_accounts' action='info'}">Information</a>
	{if Core_Acs::haveRight( ['menu'=>['accounts']] )} | <a class="menu" href="{url name='site1_accounts' action='details'}">Account Details</a>{/if}
	{if Core_Acs::haveRight( ['menu'=>['accounts']] )} | <a class="menu" href="{url name='site1_accounts' action='profile'}">Profile Settings</a>{/if}
	{if Core_Acs::haveRight( ['menu'=>['accounts']] )} | <a class="menu" href="{url name='site1_publisher' action='source_settings'}">Source Settings</a>{/if}
	
	{if Core_Acs::haveAccess( array('email test group') )} | <a class="menu" href="{url name='site1_accounts' action='api'}">iFunnels API</a>{/if}
	
	{*if Core_Acs::haveRight( ['menu'=>['accounts']] ) && Core_Acs::haveAccess( array( 'email test group' ) )} | <a class="menu" href="{url name='site1_exquisite_popups' action='settings'}">Autoresponder Parameters</a>{/if}
	{if Core_Acs::haveAccess( array('email test group') )&&$arrUser.flg_phone==1} | <a class="menu" href="{url name='site1_accounts' action='calls'}">Call Settings</a>{/if*}
</div>
<br/>
{/if}
{if $arrPrm.action=='settings'}{$arrPrm.action='info'}{/if}
{include file="site1_accounts_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}
