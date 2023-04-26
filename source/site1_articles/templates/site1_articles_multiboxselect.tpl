<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">

<form action="">
	<div style="padding: 0 0 5px 0; float: left;">
		<input type="text" id="random" class="small-text text-input"> <input type="button" value="Random" id="set_random" class="button" />
	</div>
	<div style="float:right;">
		<select id="content_type" class="medium-input">
			<option value='articles_content'{if $smarty.get.content_type!="pure_content"} selected="selected"{/if}>Articles</option>
			<option value='pure_content'{if $smarty.get.content_type=="pure_content"} selected="selected"{/if}>Pure Articles English</option>
		</select>
	</div>
</form>
<table class="table  table-striped">
	<tr>
		<td colspan="6">
			<form method="post" action="" id="video-filter">

				<div id="articles_filter" style="{if $smarty.get.content_type=='pure_content'}display:none;{/if}">
					&nbsp;Category: <select name="category" id='category-filter' class="small-input">
						<option value=''> - select -</option>
						{html_options options=$arrSelect.category selected=$smarty.post.category}
					</select><input type="submit" value="Filter" class="button"/>
				</div>
				<div id="purearticles_filter" style="{if $smarty.get.content_type!='pure_content'}display:none;{/if}">
					Category:<select name="arrCnt[4][settings][category_pid]" id="category_articles" class="required medium-input btn-group selectpicker show-tick">
						<option value="0"> - select -</option>
						{foreach from=$arrPureArtCategories item=value}
								<option {if $arrCnt.4.settings.category_pid==$value.id && !empty($arrData.id)}selected='selected'{/if}
								value="{$value.id}">{$value.title}</option>{/foreach}
					</select>
					Category:<select name="arrCnt[4][settings][category_id]" id="category_articles_child" class="medium-input">
						<option value="0"> - select -</option>
					</select>
					Keywords: <input size="40" type="text" class="text-input small-input" name="arrCnt[4][settings][keywords]" value="{if  !empty($arrFilter.keywords)}{$arrFilter.keywords}{else}{/if}"/>
					<input type="submit" value="Filter" class="button"/>
				</div>
			</form>
		</td>
	</tr>
	<thead>
	<tr>
		<th width="100px">Category
		{if $arrPg.recall>1}
			{if $arrFilter.order!='category_title--up'}<a href="{url name='site1_articles' action='multiboxselect' wg='order=category_title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category_title--dn'}<a href="{url name='site1_articles' action='multiboxselect' wg='order=category_title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		
		<th>Title
		{if $arrPg.recall>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_articles' action='multiboxselect' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_articles' action='multiboxselect' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		{if $smarty.get.content_type!="pure_content"}
		<th>Summary</th>
		
		<th>Source</th>
		{else}
		<th>Author</th>
		{/if}
		<th align="center">{if $type_input_element == 'checkbox'}<input type="checkbox" id="select_all" />{/if}</th>
	</tr>
	</thead>
	<tbody>
{foreach from=$arrArticles item=i}
	<tr>
		<td align="center"><span id="category_{$i.id}">{$i.category_title|replace:'\r':' '}</span></td>
		
		<td><span id="title_{$i.id}">{$i.title|replace:"\r":" "|escape}</span></td>
		{if $smarty.get.content_type!="pure_content"}
		<td><span id="summary_{$i.id}">{$i.summary}</span></td>
		
		<td align="center"><span id="source_{$i.id}">{$i.source_title}</span></td>
		{else}
		<td align="center"><span id="source_{$i.id}">{$i.author}</span></td>
		{/if}
		<td align="center"><input type="{$type_input_element}" name="{$type_check|default:'radio'}" value="{$i.id}" id="id_{$i.id}" class="check_article" ></td>
	</tr>
{/foreach}
	</tbody>
	<tfoot>
	<tr>
		<td colspan="6">
			<div class="bulk-actions align-left">
				<input type="button" value="Choose" id="close" class="button">
			</div>
			{include file="../../pgg_backend.tpl"}
		</td>
	</tr>
	</tfoot>
</table>



<script type="text/javascript">
{if $smarty.get.content_type=="pure_content"}{literal}
var place = {};
var jsonCategoryPureArt = {/literal}{$arrCatArtTree|json|default:'null'}{literal};
new Categories({
	firstLevel:'category_articles',
	secondLevel:'category_articles_child',
	intCatId: {/literal}{if  !empty($arrFilter.category_id)}{$arrFilter.category_id|default:'null'}{else}null{/if}{literal},
	jsonTree: jsonCategoryPureArt
});
{/literal}{/if}{literal}

function checkedElement(checkbox){
	var arrData = new Array({
		'id' : checkbox.value,
		'category' : $('category_' + checkbox.value).get('html'),
		'title'	: $('title_' + checkbox.value).get('html'),
		'flg_type' : '{/literal}{if $smarty.get.content_type=="pure_content"}1{else}0{/if}{literal}'
	});
	if( checkbox.checked ){
		new window.parent.addArticle( {jsonData:JSON.encode( arrData ),place:'{/literal}{$smarty.get.place}{literal}'} );
	}else{
		new window.parent.removeArticle( {jsonData:JSON.encode( arrData ),place:'{/literal}{$smarty.get.place}{literal}'} );
	}
};

$$('.check_article').each( function(el){
	el.addEvent( 'change', function(checkbox){
		checkedElement(checkbox.target);
	});
});


window.addEvent('domready', function(){
	if( window.parent.$('multibox_ids_{/literal}{$smarty.get.place}{literal}') && window.parent.$('multibox_ids_{/literal}{$smarty.get.place}{literal}').value  ) {
		var hash=JSON.decode( window.parent.$('multibox_ids_{/literal}{$smarty.get.place}{literal}').value );
		if( window.parent.disabled ) {
			var jsonDisabled=JSON.decode( window.parent.json_{/literal}{$smarty.get.place}{literal} );
		}
		if(hash != null){
			Object.each(hash,function( value, key ){
				if( $( 'id_'+value.id ) ) {
					$('id_'+value.id).checked = true;
					if ( window.parent.disabled ) {
						jsonDisabled.each( function( v ) {
							if( v.id == value.id ) {
								$('id_'+value.id).disabled = true;
							}
						});
					}
				}
			});
		}
	}

	$('close').addEvent('click', function(){
		window.parent.multibox_article.boxWindow.close();
	});
	
	if( $('select_all') ) {
		$('select_all').addEvent('click', function(){
			$$('.check_article').each(function(el){
				el.checked = $('select_all').checked;
				checkedElement(el);
			});
		});
	}
	
	$('set_random').addEvent('click', function(){
		var random = parseInt($('random').value);
		if(!random) {
			alert('Please enter numeric value!');
			return false;
		}
		var numElement = 0;
		var elements = $$('.check_article'); 
		$$('.check_article').each( function(el){
			numElement+=1;
			el.checked=false;
			checkedElement(el);
		});
		for(var i = 1; i <= random; i++){
			var n=Math.floor(Math.random()*(numElement));
			if(!elements[n].checked){	
				elements[n].checked = true;
				checkedElement(elements[n]);
			}else{
				if( elements[n+1] != null ){
					elements[n+1].checked = true;
					checkedElement(elements[n+1]);
				}
			}
		}
	});
	
	$('content_type').addEvent( 'change', function(elt){
		var myURI = new URI( document.location.href );
		myURI.set( 'query', Object.toQueryString( Object.append( myURI.get('query').parseQueryString(), {"content_type": elt.target.value}) ) );
		document.location.href=myURI.toString();
	});
});
</script>
<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
<script type="text/javascript">
        /*jQuery(document).ready(function($) {
			jQuery('.selectpicker').selectpicker({
			  	style: 'btn-info',
			  	size: 4
			});

            //$(".knob").knob();

        });*/
    </script>
{/literal}
</div>
</body>
</html>