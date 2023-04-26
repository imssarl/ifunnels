<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
<div class="content-box-header">
	<ul class="content-box-tabs">
		<li><a href="#bf" class="default-tab current">Blog Fusion</a></li>
		<li><a href="#nvsb">Niche Video Site Builder</a></li>
		<li><a href="#ncsb">Niche Content Site Builder</a></li>
	</ul>
	<div class="clear"></div>
</div>
<div class="content-box-content">
	<div id="bf" class="tab-content default-tab">
		{module name='site1_blogfusion' action='manage' flg_tpl=1 popup=1}
	</div>
	<div id="nvsb" class="tab-content">
		{module name='site1_nvsb' action='manage' flg_tpl=1}
	</div>
	<div id="ncsb" class="tab-content">
		{module name='site1_ncsb' action='manage' flg_tpl=1}
	</div>
</div>

{literal}<script type="text/javascript">
window.addEvent('domready',function(){
	$$('.content-box-content div.tab-content').hide();
	$$('ul.content-box-tabs li a.default-tab').addClass('current');
	$$('.content-box-content div.default-tab').show();
	$$('ul.content-box-tabs li a').addEvent('click',function(){
		$(this).getParent('li').getParent('ul').getChildren("li a").removeClass('current');
		$(this).addClass('current');
		var currentTab = $(this).get('href');
		$$('.tab-content').hide();
		$$(currentTab).show();
		return false;
	});
});
</script>{/literal}
</div>
</body>
</html>