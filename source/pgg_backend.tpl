{if $arrPg.num}
	<ul class="pagination pagination-split m-t-0 m-b-0">
		{if $arrPg.urlmin}
		<li><a href="{$arrPg.urlmin}">First</a></li>
		{/if}
		{if $arrPg.urlminus}
			<li><a href="{$arrPg.urlminus}"><i class="fa fa-angle-left"></i></a></li>
		{else}
			<li class="disabled"><a><i class="fa fa-angle-left"></i></a></li>
		{/if}
		{foreach from=$arrPg.num item='v'}
			{if $v.sel}
				<li class="active"><a>{$v.number}</a></li>
			{else}
				<li><a href="{$v.url}" class="pg_handler">{$v.number}</a></li>
			{/if}
		{/foreach}
		{if $arrPg.urlplus}
			<li><a href="{$arrPg.urlplus}"><i class="fa fa-angle-right"></i></a></li>
		{else}
			<li class="disabled"><a ><i class="fa fa-angle-right"></i></a></li>
		{/if}
		{if $arrPg.urlmax}
		<li><a href="{$arrPg.urlmax}">Last</a></li>
		{/if}
	</ul>
		{if isset( $arrPg.maxpage )}
	<ul class="pagination pagination-split m-t-0 m-b-0" style="float:right;">
		<li>
			<div style="padding-top: 4px;padding-bottom: 3px;width:150px;display: inline-block;">
			Go to <input type="number" value="" min="1" max="{$arrPg.maxpage}" style="width: 60px;" /> page
			</div>
			<a data-href="{$arrPg.href}" class="go_to_page" style="cursor:pointer;display: inline-block;float: right;">Go</a>
		</li>
	</ul>{/if}
{/if}