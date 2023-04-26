<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="/skin/_js/mootools.js"></script>
	<style type="text/css">{literal}
		body, html{margin: 0; padding: 0; height: 100%; overflow: hidden;}
		#content{position:absolute; left: 0; right: 0; bottom: 0; top: 50px;}
		#ads{position:absolute; left: 0; right: 0; bottom: 0; top: 0px;width:100%;height:50px;}
	{/literal}</style>
</head>
<body>
<div id="ads"><script type="text/javascript" src="{Zend_Registry::get( 'config' )->domain->url}/services/widgets.php?name=Copt&action=get&id=VFZSQk0wNVJQVDA9K0E="></script></div>
<div id="content">
	<iframe width="100%" height="100%" frameborder="0" src="{$url}" id="content_iframe"></iframe>
</div>
{if $flg_show_redirect}
<script type="text/javascript">{literal}
function activate10seconds(){
	if( $('content_iframe') != null ){
		//console.log( 'run money' );
		new Request({
			url:'{/literal}{url name="site1_traffic" action="client_trafic_exchange"}{literal}',
			onSuccess: function(text){
				//console.log( text );
			}
		}).get({'update_credits':'true','c':'{/literal}{$c}{literal}'});
	}
};
window.addEvent('domready', function(){
	setTimeout('activate10seconds();', 10000);
});{/literal}
</script>
{/if}
</body>
</html>