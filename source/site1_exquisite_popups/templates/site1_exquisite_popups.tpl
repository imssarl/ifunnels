<div class="card-box">
{if $arrPrm.action=='select'||$arrPrm.action=='getcode'}
{include file="site1_exquisite_popups_`$arrPrm.action`.tpl"}
{else}
{if $arrPrm.flg_tpl==1}
{include file="site1_exquisite_popups_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	<link href="/usersdata/exquisite_popups/css/admin.css" rel="stylesheet" type="text/css"> 
	<link href="/usersdata/exquisite_popups/css/font-awesome.min.css" rel="stylesheet" type="text/css"> 

	<script src="/usersdata/exquisite_popups/js/jquery-1.10.2.min.js"></script>
	<script src="/usersdata/exquisite_popups/js/bootstrap-dropdown.js"></script>
	<script src="/usersdata/exquisite_popups/js/bootstrap-modal.js"></script>
	
	<div class="heading">
		<a class="menu" href="{url name='site1_exquisite_popups' action='settings'}">Settings</a> | 
		<a class="menu" href="{url name='site1_exquisite_popups' action='create'}">Create Popup</a> | 
		<a class="menu" href="{url name='site1_exquisite_popups' action='manage'}">Manage Popups</a> | 
		<a class="menu" href="{url name='site1_exquisite_popups' action='subscribers'}">Subscribers</a>
	</div>
	{include file='../../box-top.tpl' title=$arrNest.title}
	{if in_array( $arrPrm.action, array('create','edit') )}
		{include file="site1_exquisite_popups_create.tpl"}
	{else}
		{include file="site1_exquisite_popups_`$arrPrm.action`.tpl"}
	{/if}
	{include file='../../box-bottom.tpl'}
{else}
	wrong action!
{/if}
{/if}
</div>