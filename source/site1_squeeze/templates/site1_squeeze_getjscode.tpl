<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<br/>
	<table width="90%" align="center">
		<tr align="center"><td align="center" class="heading">Javascript code "view"</td></tr>
		<tr>
			<td align="center">
				<div id="code" style="display:block;">
					<textarea class="clipboard-text clipboard-id-2 form-control" rows="5" cols="80">
<script type="text/javascript">
	window.onload = function(){
		var url = 'http://fasttrk.net/'; 
		if(window.location.protocol == 'https:') {
			url = 'https://fasttrk.net/'
		}
		xhttp=new XMLHttpRequest();
		xhttp.onreadystatechange=function(){
		if (xhttp.readyState==4 && xhttp.status==200)
			console.log(xhttp.responseText);
		}
		xhttp.open('GET',url+"services/conversionpixel.php?param=view&squeeze_id={$split_id}",true);
		xhttp.send();
	}
</script></textarea>
					<br/>
					<center><a class="clipboard-click clipboard-id-2 btn btn-success waves-effect waves-light" href="#">Copy to clipboard</a></center>
					<br/> 
					<div id="clipboard_content"></div>
				</div>
			</td>
		</tr>

		<tr align="center"><td align="center" class="heading">Javascript code "lead"</td></tr>
		<tr>
			<td align="center">
				<div id="code" style="display:block;">
					<textarea class="clipboard-text clipboard-id-3 form-control" rows="5" cols="80">
<script type="text/javascript">
	window.onload = function(){
		var url = 'http://fasttrk.net/'; 
		if(window.location.protocol == 'https:') {
			url = 'https://fasttrk.net/'
		}
		xhttp=new XMLHttpRequest();
		xhttp.onreadystatechange=function(){
		if (xhttp.readyState==4 && xhttp.status==200)
			console.log(xhttp.responseText);
		}
		xhttp.open('GET', url+"services/conversionpixel.php?param=lead&squeeze_id={$split_id}",true);
		xhttp.send();
	}
</script></textarea>
					<br/>
					<center><a class="clipboard-click clipboard-id-3 btn btn-success waves-effect waves-light" href="#">Copy to clipboard</a></center>
					<br/> 
					<div id="clipboard_content"></div>
				</div>
			</td>
		</tr>

		<tr align="center"><td align="center" class="heading">Javascript code "sale"</td></tr>
		<tr>
			<td align="center">
				<div id="code" style="display:block;">
					<textarea class="clipboard-text clipboard-id-4 form-control" rows="5" cols="80">
<script type="text/javascript">
	window.onload = function(){
		var url = 'http://fasttrk.net/'; 
		if(window.location.protocol == 'https:') {
			url = 'https://fasttrk.net/'
		}
		xhttp=new XMLHttpRequest();
		xhttp.onreadystatechange=function(){
		if (xhttp.readyState==4 && xhttp.status==200)
			console.log(xhttp.responseText);
		}
		xhttp.open('GET', url+"services/conversionpixel.php?param=sale&squeeze_id={$split_id}",true);
		xhttp.send();
	}
</script></textarea>
					<br/>
					<center><a class="clipboard-click clipboard-id-4 btn btn-success waves-effect waves-light" href="#">Copy to clipboard</a></center>
					<br/> 
					<div id="clipboard_content"></div>
				</div>
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