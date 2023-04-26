{if $arrUser.id}
<ul>
	<li{if !$arrNest.action} class="active"{/if}><a href="{Core_Module_Router::$offset}" title="Home">Home</a></li>
	<li{if $arrNest.action=='settings'} class="active"{/if}><a href="{url name='site1_accounts' action='settings'}" title="My Account">My Account</a></li>
	<li{if $arrNest.action=='credits'} class="active"{/if}><a href="{url name='site1_accounts' action='credits'}" title="Purchase Credits">Purchase Credits</a></li>
	<li{if $arrNest.action=='tutorials'} class="active"{/if}><a href="{url name='site1_accounts' action='tutorials'}" title="Tutorials and How-To Videos">Tutorials and How-To Videos</a></li>
	{if Core_Acs::haveAccess( array( 'Maintenance' ) )}
	<li><a href="http://creativenichemanager.zendesk.com/" title="Forums, Suggestions & Feedbacks" target="_blank">Support & Feedback</a>
		<ul>
			<li><a href="http://creativenichemanager.zendesk.com/" title="Support" target="_blank">Support</a></li>
			<li><a href="{if Core_Acs::haveAccess( array( 'Site Profit Bot Pro', 'Site Profit Bot Hosted' ) )}http://siteprofitbot.com/blog{else}http://creativenichemanager.feedbackhq.com{/if}" title="Forums & Feedbacks" target="_blank">Forums & Feedbacks</a></li>
		</ul>
	</li>
	{/if}
	<li><a href="{url name='site1_accounts' action='logoff'}" title="Logout">Logout</a></li>
</ul>
{else}
<ul>
	<li{if !$arrNest.action} class="active"{/if}><a href="{Core_Module_Router::$offset}" title="Login">Login</a></li>
	<li{if $arrNest.action=='registration'} class="active"{/if}><a href="http://creativenichemanager.com/plans-pricing" title="Registration">Registration</a></li>
</ul>
{/if}