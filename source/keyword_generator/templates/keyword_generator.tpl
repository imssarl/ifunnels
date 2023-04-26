<div class="card-box">
{if $arrPrm.flg_tpl==1 || in_array( $arrPrm.action, array('multiboxplace','getcode','importpopup','multiboxlist') )}
	{include file="keyword_generator_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	<div class="heading">
		<a class="menu" href="{url name='keyword_generator' action='combine_keywords'}">Keyword Mixer</a> | 
		<a class="menu" href="{url name='keyword_generator' action='combine_url'}">URL Mixer</a> | 
		<a class="menu" href="{url name='keyword_generator' action='typo_generator'}">Typo Generator</a> 
	</div>
	{include file='../../box-top.tpl' title=$arrNest.title}
	{include file="keyword_generator_`$arrPrm.action`.tpl"}
	{include file='../../box-bottom.tpl'}
{/if}
</div>