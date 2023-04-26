<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
</head>
<body>
<script type="text/javascript">
	window.onload = function(){
		console.log('asd');
		xhttp=new XMLHttpRequest();
		xhttp.onreadystatechange=function(){
		if (xhttp.readyState==4 && xhttp.status==200)
			console.log(xhttp.responseText);
		}
		xhttp.open('GET',"http://fasttrk.net/services/conversionpixel.php?param=view&squeeze_id=4",true);
		xhttp.send();
	}
</script>				
</body>
</html>


