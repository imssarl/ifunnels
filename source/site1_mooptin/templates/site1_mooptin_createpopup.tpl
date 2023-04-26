<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>{if $arrCurReverse}{foreach from=$arrCurReverse item='node'}{$node.title} / {/foreach}{/if}{Core_Module_Router::$domain}</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type" />
	<meta name="Robots" content="{if !$arrCurReverse[0].meta_robots}NO{/if}INDEX, FOLLOW" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	{if $arrCurReverse[0].meta_keywords}<meta name="keywords" content="{$arrCurReverse[0].meta_keywords}" />{/if}
	{if $arrCurReverse[0].meta_description}<meta name="description" content="{$arrCurReverse[0].meta_description}" />{/if}
	{*CSS*}
	<link rel="stylesheet" href="/skin/_css/new/site1_mini.css" type="text/css" media="screen" />
	{*JS*}
	<script type="text/javascript" src="/skin/_js/mootools-core.js"></script>
	<script type="text/javascript" src="/skin/_js/xlib.js"></script>
	{*cerabox*}
	<link href="/skin/light/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/icons.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/core.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/plugins/bootstrap-select/dist/css/bootstrap-select.min.css" rel="stylesheet" />
	<link href="/skin/light/css/pages.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/responsive.css" rel="stylesheet" type="text/css" />
	<link href="/skin/light/css/components.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="/skin/_js/cerabox/style/cerabox.css" media="screen" />
	<script type="text/javascript" src="/skin/_js/cerabox/cerabox.js"></script>
	<script src="/skin/light/js/jquery.min.js"></script> 
	<script>
		jQuery.noConflict();
        var resizefunc = [];
    </script>

	{*validator*}
	<link rel="stylesheet" type="text/css" href="/skin/_js/validator/style.css" />
	<script type="text/javascript" src="/skin/_js/validator/validator.js"></script>
	{*r.alert*}
	<link rel="stylesheet" type="text/css" href="/skin/_js/roar/roar.css" />
	<script type="text/javascript" src="/skin/_js/roar/roar.js"></script>
	{*additional js*}
	<script type="text/javascript" src="/skin/_js/site1.js"></script>
	<script type="text/javascript" src="/skin/_js/ui.js"></script>
	<script type="text/javascript" src="/skin/_js/categories.js"></script>

	<script type="text/javascript" src="/skin/_js/jsColorpicker/colors.js"></script>
	<script type="text/javascript" src="/skin/_js/jsColorpicker/colorPicker.data.js"></script>
	<script type="text/javascript" src="/skin/_js/jsColorpicker/colorPicker.js"></script>
	<script type="text/javascript" src="/skin/_js/jsColorpicker/jsColor.js"></script>
	
	<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>

	<link rel="stylesheet" href="/skin/_css/contentbox.css" type="text/css" />
	<link rel="stylesheet" href="/skin/_css/bootstrap.vertical-tabs.css" type="text/css" />
</head>
<body style="padding:40px;">
	{if $msg!=''}
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
		<div>{$msg}</a></div>
	</div>
	{/if}
	{if $error!=''}
		{include file='../../message.tpl' type='error' message=$error}
	{/if}
	{include file="site1_mooptin_create.tpl"}
	<script src="/skin/light/js/bootstrap.min.js"></script>
	<script src="/skin/light/js/detect.js"></script>
	<script src="/skin/light/js/jquery.slimscroll.js"></script>

	<script src="/skin/light/js/fastclick.js"></script>
	<script src="/skin/light/js/waves.js"></script>
	<script src="/skin/light/js/wow.min.js"></script>

	<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
	<script src="/skin/light/js/jquery.app.js"></script>
	{literal}<script>
	{/literal}{if isset( $arrData )}{literal}
	setTimeout(function(){
		if( typeof window.multibox != undefined ){
			window.parent.placeMoOptin( '{/literal}{$arrData.id}', '{$arrData.name}{literal}' );
			window.parent.multibox.boxWindow.close()
		}
	}, 3000);
	{/literal}{else}{literal}
	$('create').addEvent('click',function(){
		$('form').set( 'action',urlGenerate );
		$('form').set( 'target','_self' );
		$('form').submit();
	});
	{/literal}{/if}
	</script>
<br>
<br>
<br>
</body>
</html>