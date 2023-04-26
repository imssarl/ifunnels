{if empty($arrPrm.action)}
	wrong action!
{else}
	{if $arrPrm.action==$arrNest.action&&$arrPrm.flg_tpl==0}{*если у нас ниже инклюдится шаблон ссылочного экшена*}
		<div class="heading">
			{if !Core_Acs::haveAccess( 'Zonterest' )&&!Core_Acs::haveAccess( 'Zonterest LIGHT' )}
				<span style="background-color:#FF1111; color:#FFFFFF;">&nbsp;Beta Version&nbsp;</span>&nbsp;&nbsp;&nbsp;
				{if Core_Acs::haveRight( ['site1_publisher'=>['project_create']] )}
				<a class="menu" href="{url name='site1_publisher' action='project_create'}">Create Content Project</a> |
				<a class="menu" href="{url name='site1_publisher' action='projects_manage'}">Projects manage</a> |
				{/if}
				<a class="menu" href="{url name='site1_publisher' action='source_settings'}">Source Settings</a>
			{else}
				<a class="menu" href="{url name='site1_accounts' action='info'}">Information</a>
				{if Core_Acs::haveRight( ['menu'=>['accounts']] )} | <a class="menu" href="{url name='site1_accounts' action='details'}">Account Details</a>{/if}
				{if Core_Acs::haveRight( ['menu'=>['accounts']] )} | <a class="menu" href="{url name='site1_accounts' action='profile'}">Profile Settings</a>{/if}
				{if Core_Acs::haveRight( ['menu'=>['accounts']] )} | <a class="menu" href="{url name='site1_publisher' action='source_settings'}">Source Settings</a>{/if}
				| <a class="menu" href="{url name='site1_accounts' action='payment'}">Payment</a>
			{/if}
		</div>
		<br />
	{/if}
	{include file="site1_publisher_`$arrPrm.action`.tpl"}
{/if}