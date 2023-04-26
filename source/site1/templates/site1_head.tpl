	<title>{if $arrCurReverse}{foreach from=$arrCurReverse item='node'}{$node.title} / {/foreach}{/if}{Core_Module_Router::$domain}</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type" />
	<meta name="Robots" content="{if !$arrCurReverse[0].meta_robots}NO{/if}INDEX, FOLLOW" />
	{if $arrCurReverse[0].meta_keywords}<meta name="keywords" content="{$arrCurReverse[0].meta_keywords}" />{/if}
	{if $arrCurReverse[0].meta_description}<meta name="description" content="{$arrCurReverse[0].meta_description}" />{/if}
	{*CSS*}

	<!--{if $arrPrm.type=='reggi'}
		<link rel="stylesheet" href="/skin/_css/new/site1_reggi.css" type="text/css" media="screen" />
	{else}
		<link rel="stylesheet" href="/skin/_css/new/reset.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="/skin/_css/new/site1.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="/skin/_css/new/invalid.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="/skin/_css/new/ie.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="/skin/_css/tips.css" type="text/css" media="screen" />
		{if $arrPrm.type=='mini'}
		<link rel="stylesheet" href="/skin/_css/new/site1_mini.css" type="text/css" media="screen" />
		{/if}
	{/if}
	<!-- NEW CSS FILES -->
	<link href="/skin/light/plugins/bootstrap-select/dist/css/bootstrap-select.min.css" rel="stylesheet" />
	<link rel="stylesheet" href="/skin/light/plugins/morris/morris.css">
    <link href="/skin/light/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/skin/light/css/core.css" rel="stylesheet" type="text/css" />
    <link href="/skin/light/css/components.css" rel="stylesheet" type="text/css" />
    <link href="/skin/light/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="/skin/light/css/pages.css" rel="stylesheet" type="text/css" />
    <link href="/skin/light/css/responsive.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="/skin/_js/cerabox/style/cerabox.css" media="screen" />

	<!-- ************* -->
	<script type="text/javascript" src="/skin/_js/mootools-core.js"></script>
	<script type="text/javascript" src="/skin/_js/cerabox/cerabox.js"></script>
	<script type="text/javascript" src="/skin/_js/categories.js"></script>
	<script type="text/javascript" src="/skin/_js/xlib.js"></script>
	<script src="/skin/light/js/jquery.min.js"></script>
	<script src="/skin/light/js/modernizr.min.js"></script>
	<script>
		jQuery.noConflict();
        var resizefunc = [];
    </script>
	
	
	{*JS*}
	
	
	{*cerabox*}
	<!--link rel="stylesheet" href="/skin/_js/cerabox/style/cerabox.css" media="screen" /-->
	
	{*validator*}
	<link rel="stylesheet" type="text/css" href="/skin/_js/validator/style.css" />
	<script type="text/javascript" src="/skin/_js/validator/validator.js"></script>
	{*r.alert*}
	<link rel="stylesheet" type="text/css" href="/skin/_js/roar/roar.css" />
	<script type="text/javascript" src="/skin/_js/roar/roar.js"></script>
	{*additional js*}
	<script type="text/javascript" src="/skin/_js/site1.js"></script>
	<!--script type="text/javascript" src="/skin/_js/ui.js"></script-->
	<script type="text/javascript" src="/skin/_js/categories.js"></script>