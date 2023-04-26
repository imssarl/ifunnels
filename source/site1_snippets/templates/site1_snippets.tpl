{if $arrPrm.action <> "summary" and $arrPrm.action <> "getcode" and $arrPrm.action <> "show" and $arrPrm.action <> "spots"}
<div class="heading">
	<a class="menu" href="{url name='site1_snippets' action='manage'}">Manage Snippets</a> |
	<a class="menu" href="{url name='site1_snippets' action='create'}">Create Snippet</a>
</div>
<br/>
{include file='../../box-top.tpl' title=$arrNest.title}
{/if}
{if $arrPrm.action}
	{include file="site1_snippets_{$arrPrm.action}.tpl"}
	{if $arrPrm.action <> "summary" and $arrPrm.action <> "getcode" and $arrPrm.action <> "show" and $arrPrm.action <> "spots"}
		{include file='../../box-bottom.tpl'}
	{/if}
{else}
	wrong action!
{/if}