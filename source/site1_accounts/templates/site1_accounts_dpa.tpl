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
{if !isset( Core_Users::$info['dpa_agree_date'] ) || Core_Users::$info['dpa_agree_date']<$item.edited}
<div align="center" data-userid="{Core_Users::$info['id']}">
	<form action="" method="post">
		<input type="checkbox" value="1" name="i_agree" /> <b>I have read and agree to this DPA (Data Protection Agreement)</b>
		<input type="submit" value="Next">
	</form>
</div>
{/if}

{if empty($arrPrm.header)}
</div>
{if $closePopup}
<script type="text/javascript">{literal}
window.parent.dpaBox.boxWindow.close();
{/literal}</script>
{/if}
</body>
</html>
{/if}