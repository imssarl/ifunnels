<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<iframe width="100%" height="100%" src="{$url}&nopay" id="{md5($url)}"></iframe>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	setTimeout( function () {
		if( $('{/literal}{md5($url)}{literal}') !== null ){
			new Request({
				url:'{$url}&pay',
				onComplete: function(res){
					// 
				}
			}).send();
		}
	}, 10000 );
});
</script>
{/literal}
</body>
</html>