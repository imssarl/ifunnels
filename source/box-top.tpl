<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>
			{$title}
			{if $arrNest.name=='site1_squeeze'&&$arrNest.action=='reporting'&&!empty($smarty.get.id)}
				{foreach $arrList as $v}
				<span>{$v.url}</span>
				{/foreach}
			{/if} 
		</h3>
	</div>
	<div class="content-box-content">
