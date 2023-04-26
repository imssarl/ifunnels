<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<div class="card-box">
	{if $arrRes.setdata==1}
		{include file='../../message.tpl' type='info' message='Data saved successfully'}
	{elseif $arrRes.setdata == 2}
		{include file='../../message.tpl' type='error' message='Process Aborted. Unable to upload data. Check format file!'}
	{/if}
	{if isset($error) && !empty($error)}
		{include file='../../message.tpl' type='error' message=$error}
	{/if}
	{foreach from=Project_Content::toLabelArray() item=name key=ids}{if {$name.flg_source}=={$smarty.get.flg_source}}{$arrOfSource = $name}{/if}{/foreach}
	{if $arrOfSource.flg_source!=1}
	<form action="" method="post" class="wh validate" id="filter_form" style="width:95%">
		{module name='site1_publisher' action='source_settings' modelSettings='1' selectedSource={$smarty.get.flg_source} settings=$smarty.get.arrFlt flg_status='1' arrPrj=$arrPrj}
		<div class="text-center m-b-10">
			<button type="button" id="content-filter" class="button btn btn-default waves-effect waves-light">Filter</button>
		</div>
	</form>
	{/if}
	
	<div class="card-box">
	{if $smarty.get.label}
	{include file="selectcontents/{$smarty.get.label}.tpl"}
	{else}
	{include file="selectcontents/{$arrOfSource.label}.tpl"}
	{/if}
	</div>
	<textarea id="json_inputs" style="display:none;">{if !empty($smarty.post.json_inputs)}{$smarty.post.json_inputs}{/if}</textarea>
</div>
{literal}<script type="text/javascript">
var popupURI = new URI(window.location);
var arrChk = new Array();
// page turning
if ( $$('.pg_handler') != null ) {
	$$('.pg_handler').addEvent('click',function(e){
		e.stop();
		var arrquery_get = new Hash();
		var arrquery_post = new Hash();
		$('content_'+popupURI.getData()['flg_source']).getElements('input, select, textarea').each(function(el){
			if  ( ((el.type == "radio")&(el.checked))||(el.type!="radio") ) 
				arrquery_get.set( (el.name).replace( /arrCnt\[\d{1,}\]\[settings\]/ , 'arrFlt') , el.value);
		});
		if ( window.parent.visual.jsonValue != null ) {
			arrChk.append(window.parent.visual.jsonValue);// неработает combine в многомерном массиве 
		}
		var i = arrChk.length;
		$$('.chk_item').each( function( v ) {
			if( v.checked && !v.disabled && !arrChk.contains( [v.id, v.value] ) ) {
				arrChk[i] = [v.id, v.value];
				i++;
			}
		});
		$('json_inputs').html = JSON.encode( arrChk );
		window.parent.visual.jsonValue = arrChk;
		arrquery_get.set( 'flg_source',popupURI.getData()['flg_source'] );
		arrquery_get.set( 'id',true);
		var pageUri = new URI(this.get( 'href' ));
		arrquery_get.set( 'page', pageUri.get('data').page );
		popupURI.setData( arrquery_get );
		window.location=popupURI.toString();
		
	//	$('filter_form').set( 'action',  );
	//	$('filter_form').submit();
	});
}

if( $('choose') != null ) {
var jsonArrList={/literal}{$arrList|json}{literal};
	$$('.chk_item').each( function( v ){
		if  ( window.parent.visual.options.jsonShedule != null ) {
			(window.parent.visual.options.jsonShedule).each( function( c ){
				if ( c.title == jsonArrList[v.get('key')].title ) {
					v.set ({'checked':'checked','disabled':'disabled'});
				}
			});
		}
		if( window.parent.visual.placeParam != null ){
			Object.each(window.parent.visual.placeParam, function( i ){
				if ( i.title == v.value ) {
					v.set ({'checked':'checked'});
				}
			});
		}
		if ( window.parent.visual.jsonValue!=null && window.parent.visual.jsonValue.length>0 ) {
			Object.each(window.parent.visual.jsonValue, function( k ) {
				if( k[1] == v.value ) {
					v.set ({'checked':'checked'});
				}
			});
		}
	});
	$('choose').addEvent('click', function(e){
		if ( window.parent.visual.jsonValue != null ) {
			arrChk.append( window.parent.visual.jsonValue );
		}
		var i = arrChk.length;
		$$('.chk_item').each( function( v ) {
			if( v.checked && !v.disabled && !arrChk.contains( [v.id, v.value] ) ) {
					arrChk[i] = [v.id, v.value];
			i++;
			}
		});
		$('json_inputs').html = JSON.encode( arrChk );
		var arrChked = new Array();
		arrChk.each ( function (values , keys) {
			arrChk.each ( function ( values_eq, key_eq ) {
				if ( values_eq[0] == values[0] && keys!=key_eq ) {
					arrChk.erase(arrChk[key_eq]);
				}
			});
		});
		arrChk.each ( function (v) {
			arrChked.include({'id':v[0], 'title':v[1]});
		});
		var popupUrlData=popupURI.getData();
		window.parent.visual.placingContent(arrChked);
		window.parent.document.getElementById('content_'+popupUrlData['flg_source']).getElements('select').each(function(selectoptions){
			if( document.getElementsByName(selectoptions.getProperty('name')).length > 0  )
				selectoptions.set('html',document.getElementsByName(selectoptions.getProperty('name'))[0].get('html'));
		});
		window.parent.document.getElementById('content_'+popupUrlData['flg_source']).getElements('div.use_in_publisher').each(function(selectoptions){
			selectoptions.setStyle('display',document.getElementById(selectoptions.getProperty('id')).getStyle('display'));
		});
		window.parent.document.getElementById('content_'+popupUrlData['flg_source']).getElements('input').each(function(selectoptions){
			if ( document.getElementById(selectoptions.getProperty('id')) != null ) {
				selectoptions.set('checked',document.getElementById(selectoptions.getProperty('id')).get('checked'));
			}
		});
		var arrquery = new Hash();
		$('content_'+popupUrlData['flg_source']).getElements('input, select, textarea').each(function(el){
			if  ( ((el.type == "radio")&&(el.checked))||el.type!="radio" ) {
					arrquery.set( (el.name).replace( /arrCnt\[\d{1,}\]\[settings\]/ , 'arrFlt') , el.value);
			}
		});
		arrquery.set('flg_source',popupUrlData['flg_source']);
		window.parent.visual.jsonPopupEdit( arrquery );
		window.parent.multiboxnoerrors.boxWindow.close();
	});
	$('select_all').addEvent( 'click', function() {
		$$('.chk_item').each( function( el ){
			el.checked = this.checked;
		},this );
	});
}
</script>
{/literal}
</div>
</body>
</html>