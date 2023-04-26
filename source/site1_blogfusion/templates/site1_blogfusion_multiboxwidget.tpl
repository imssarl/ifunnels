<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<form id="login" method="POST" action="{$arrBlog.url}wp-login.php">
<input type="hidden" name="log" value="{$arrBlog.dashboad_username}" />
<input type="hidden" name="pwd" value="{$arrBlog.dashboad_password}" />
<input type="hidden" value="Log In" name="wp-submit">
<input type="hidden" value="{$arrBlog.url}wp-admin/widgets.php" name="redirect_to">
<input type="hidden" value="1" name="testcookie">
</form>
{literal}
<script type="text/javascript">
window.addEvent('domready',function(){
	//parent.window.initWidgetEvents({/literal}'{$arrBlog.url}'{literal});
	$('login').submit();
})
</script>
{/literal}
</body>
</html>