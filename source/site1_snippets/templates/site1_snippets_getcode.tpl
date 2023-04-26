<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<fieldset>
		<legend>Include Code</legend>
			<div>
				{if !empty($show_id)}
				<div id="code" style="display:block;">
					<textarea class="clipboard-text clipboard-id-1" rows="12" cols="80">{Project_Widget_Adapter_Copt_Snippets::getCode({$show_id})}</textarea>
					<br/>
					<center><a class="clipboard-click clipboard-id-1" href="#">Copy to clipboard</a></center>
					<br/> 
					<div class="message">
						The code needs to be copied and then pasted into the page between the body tags.
					</div>
					<div id="clipboard_content"></div>
				</div>
				{else}
					Invalid request
				{/if}
		</div>
		<p><input type="button" value="Close" id="close" class="button" {is_acs_write} ></p>
	</fieldset>
	<script type="text/javascript" src="/skin/_js/clipboard/clipboard.js"></script>
{literal}
<script>
var _clipboard = {};
$('close').addEvent( 'click', function() {
	window.parent.multibox.boxWindow.close();
});
window.addEvent("domready", function(){
	_clipboard=new Clipboard($$('.clipboard-click'));
});
</script>
{/literal}
</div>
</body>
</html>