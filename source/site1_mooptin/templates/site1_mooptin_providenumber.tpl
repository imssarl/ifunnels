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

<div class="card-box">
<form action="" method="post" id="form" class="wh validate" enctype="multipart/form-data">
	<div class="form-group mo_optin_sms_number_provision">
		<label class="control-label">Select Country: </label>
		<select name="arrData[sms_number_counry]" class="btn-group selectpicker show-tick" id="mo_optin_sms_number_counry">
			{foreach from=Project_Squeeze::getCountries() item=i key=k}
			<option value="{$k}"{if $arrData.sms_number_counry==$k} selected="selected"{/if}>{$i.country}</option>
			{/foreach}
		</select>
	</div>
	<div class="form-group">
		<label class="control-label">Select New Phone Number: </label>
		<select name="arrData[sms_number]" class="btn-group selectpicker show-tick" id="mo_optin_sms_number_phone"></select>
	</div>
	
	<fieldset class="m-t-10">
		<button class="btn btn-success btn-rounded waves-effect waves-light" type="button" value="Provision a New Number" id="create">Provision a New Number</button>
		<input type="submit" style="display: none;" value="Submit">
	</fieldset>

</form>
</div>

<script src="/skin/light/js/bootstrap.min.js"></script>
<script src="/skin/light/js/detect.js"></script>
<script src="/skin/light/js/jquery.slimscroll.js"></script>
<script src="/skin/light/js/fastclick.js"></script>
<script src="/skin/light/js/waves.js"></script>
<script src="/skin/light/js/wow.min.js"></script>
<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
<script src="/skin/light/js/jquery.app.js"></script>

{literal}<script type="text/javascript">
	{/literal}{if isset( $arrData )}{literal}
	setTimeout(function(){
		if( typeof window.mooptinpopup != undefined ){
			window.parent.placeNewNumber( '{/literal}{$arrData.phone}{literal}' );
			window.parent.mooptinpopup.boxWindow.close()
		}
	}, 1000);
	{/literal}{/if}{literal}
	
	$('create').addEvent('click',function(){
		$('form').set( 'action','{/literal}{url name="site1_mooptin" action="providenumber"}{literal}' );
		$('form').set( 'target','_self' );
		$('form').submit();
	});

	$('mo_optin_sms_number_counry').addEvent('change',function( elt ){
		var r=new Request({
			url: '{/literal}{url name="site1_mooptin" action="request"}{literal}',
			onSuccess: function(data){
				var dataSettings=JSON.decode(data);
				jQuery('#mo_optin_sms_number_phone').selectpicker();
				$('mo_optin_sms_number_phone').empty();
				for (var i=0; i<dataSettings.length; i++) {
					$('mo_optin_sms_number_phone').adopt( new Element('option', {'value':dataSettings[i],'html':dataSettings[i]}) );
				}
				jQuery('#mo_optin_sms_number_phone').selectpicker('refresh');
			}
		}).post( { 'country_code':elt.target.get('value'), 'type': 'new' } );
	});
	
</script>
{/literal}


<br>
<br>
<br>
</body>
</html>