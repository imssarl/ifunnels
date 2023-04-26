{if $arrPrm.action=="manage"||$arrPrm.action=="create"||$arrPrm.action=="manage_split"||$arrPrm.action=="create_split"}
<div class="heading">
	<a class="menu" href="{url name='site1_hiam' action='manage'}">Manage Campaigns</a> |
	<a class="menu" href="{url name='site1_hiam' action='create'}">Create Campaign</a> |
	<a class="menu" href="{url name='site1_hiam' action='manage_split'}">Split Tests</a> |
	<a class="menu" href="{url name='site1_hiam' action='create_split'}">Create Split Test</a>
</div>
<br/>
{elseif $arrPrm.action=='manage_corners'||$arrPrm.action=='manage_sounds'||$arrPrm.action=='manage_backgrounds'}
<h1>{$arrPrm.title}</h1>
{/if}
{if substr($arrPrm.action, 0, 5)=='hiam_'}
	{include file="site1_hiam_files_popup.tpl"}
{elseif $arrPrm.action}
	{include file="site1_hiam_{$arrPrm.action}.tpl"}
{else}
	wrong action!
{/if}