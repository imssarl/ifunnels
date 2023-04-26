{if $arrPrm.action!='registration' || $arrPrm.action!='clickbank_ids'}
	{if $arrPrm.action}
		<h1>{$arrPrm.title}</h1>
		{include file="iam_`$arrPrm.action`.tpl"}
	{else}
		wrong action!
	{/if}
{else}
	{include file="iam_`$arrPrm.action`.tpl"}
{/if}