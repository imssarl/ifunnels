HEADER RELOADING






<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
	{*<script type="text/javascript">{literal}
		//document.domain = '{/literal}{$linkDomain}{literal}';
	{/literal}</script>*}
</head>
<body>
	<style type="text/css">{literal}
		body, html {
			margin: 0; padding: 0;
			height: 100%; width: 100%;
		}

		iframe { width: 100%; height: 100%; }
	{/literal}</style>
	<iframe src="{url name='site1_squeeze' action='splittest_check'}?link={$link}" id="iframe_id" frameBorder="0"></iframe>
	{*<script type="text/javascript" src="/skin/light/js/jquery.min.js"></script>
	<script type="text/javascript">{literal}
		
		$('#iframe_id').load(function(){
			var iframe = document.getElementById('iframe_id');
			
			console.log( iframe.contentWindow.getElementsByClassName('get-button') );
			
		//	var innerDoc = iframe.contentDocument || iframe.contentWindow.document;
		//	console.log( innerDoc.getElementsByClassName('get-button') );
		});
		
		window.squeezeOnClick = function(){ 
			$.ajax({
				type: "POST",
				url: "{url name='site1_squeeze' action='splittest_check'}",
				data: {
					splittest : {$splittest},
					campaign_id : {$campaign_id}
				}
			}).done(function(msg){
				console.log(msg);
			});
		};
	{/literal}</script>*}
</body>
</html>


