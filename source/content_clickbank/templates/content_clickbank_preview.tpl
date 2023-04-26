{literal}
<style type="text/css">
	.images-block{padding:10px; float:left;}
	.border{ border: 1px solid #EEE;}
	.clear{clear: both; width: 100%;}
</style>
{/literal}
<div>
	<h3>Title: {$arrItem.title}</h3>
	<p><h3>Short description: </h3>{$arrItem.short_description}</p>
	<p><h3>Long description: </h3>{$arrItem.long_description}</p>
	{if !empty($arrItem.smallthumb_preview)}
	<div class="images-block border">
		<h4>Small thumb</h4>
		<img src='{img src=$arrItem.smallthumb_preview p=100}' />
	</div>
	{/if}
	<div class="clear"></div>
	{if !empty($arrItem.largethumb_preview)}
	<div class="images-block border" >
		<h4>Large thumb</h4>
		<img src='{img src=$arrItem.largethumb_preview p=100}' />
	</div>
	{/if}
	{assign var=index value=0}
	{section loop=10 name=j}
		{assign var=name_preview value="preview{$smarty.section.j.index}"}
		{if !empty($arrItem[$name_preview])}
			{if $index%3==0}<div class="clear"></div>{/if}
			{assign var=index value=$index+1}
		<div  class="images-block border">
			<h4>Banner {$smarty.section.j.index+1}</h4>
			<img src='{img src=$arrItem[$name_preview] p=100}' />
		</div>

		{/if}
	{/section}
</div>