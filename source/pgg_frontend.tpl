{if $arrPg.num}
<div class="pagination">
	{*if $arrPg.recall}
	<span>Total {$arrPg.recall} record{if $arrPg.recall>1}s{/if}</span>
	{/if*}
	{if $arrPg.recfrom!=1}
		<a href="{$arrPg.urlmin}"  title="First Page" class="pg_handler">&laquo; First</a>
	{/if}
	{if $arrPg.urlminus}
		<a href="{$arrPg.urlminus}"  title="Previous Page" class="pg_handler" >&laquo; Previous</a>
	{/if}
	{foreach from=$arrPg.num item='v'}
		<a href="{$v.url}" class="number {if $v.sel}current{/if} pg_handler">{$v.number}</a>
	{/foreach}
	{if $arrPg.urlplus}
		<a href="{$arrPg.urlplus}" title="Next Page" class="pg_handler">Next &raquo;</a>
	{/if}
	{if $arrPg.recall!=$arrPg.recto}
		<a href="{$arrPg.urlmax}"title="Last Page" class="pg_handler">Last &raquo;</a>
	{/if}
</div>
{/if}