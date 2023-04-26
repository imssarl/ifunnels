{if empty($arrPrm.header)}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
{/if}
<div id="main-content">
<div  style="padding:10px;">
<h1>{$item.title}</h1>
{$item.body}
</div>
{if !empty($arrPrm.header)}
{literal}
<script type="text/javascript">
var popup={};
window.addEvent('domready',function(){
	popup=new CeraBox( $$('.popup'), {
		group: false,
		width:'80%',
		height:'80%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}
{else}
</div>
</body>
</html>
{/if}