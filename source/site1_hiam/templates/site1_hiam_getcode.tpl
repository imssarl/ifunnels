<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<br/>
	<table width="90%" align="center">
		<tr align="center"><td align="center" class="heading">Include Code</td></tr>
		<tr>
			<td align="center">
				{if !empty($showtext)}
				<div id="code" style="display:block;">
					<textarea class="clipboard-text clipboard-id-1 form-control" rows="5" cols="80">{$showtext.get}</textarea>
					<br/>
					<center><a class="clipboard-click clipboard-id-1 btn btn-success waves-effect waves-light" href="#">Copy to clipboard</a></center>
					<br/> 
					<div class="message">
						The code has to be copied and then paste inside the body tag of the page where you wants Ad to appear.
					</div>
					<div id="clipboard_content"></div>
				</div>
				<br/><br/>
				<div id="code" style="display:block;">
					<textarea class="clipboard-text clipboard-id-2 form-control" rows="5" cols="80">{$showtext.effect}</textarea>
					<br/>
					<center><a class="clipboard-click clipboard-id-2 btn btn-success waves-effect waves-light" href="#">Copy to clipboard</a></center>
					<br/> 
					<div class="message">
						The code has to be copied and then paste into the thanks page of your site.
					</div>
					<div id="clipboard_content"></div>
				</div>
				{else}
					Invalid request
				{/if}
			</td>
		</tr>
		<tr><td align='center' colspan='7' class="heading"><button type="button" {is_acs_write} id="close" class="button btn btn-success waves-effect waves-light">Close</button></td></tr>
	</table>
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
</body>
</html>