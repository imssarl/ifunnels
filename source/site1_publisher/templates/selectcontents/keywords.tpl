	<link rel="stylesheet" href="/skin/_js/tabs/tabs.css" />
		<ul id="tabs" style="display:none;">
			<li><a class="tab" href="#" id="one">Keyword Research</a></li>
			<li><a class="tab" href="#" id="two">Text file (new line separated) or CSV file</a></li>
		</ul>
		<div id="home" style="display:none;" style="width:95%; ">
			<div class="feature" style="top: 10px;width:100%; ">
				<div> <!--Keyword Research-->
			{if $arrList}
				<table style="width:100%;">
				<thead>
				<tr>
					<th style="width:10%;">Id number</th>
					<th>Title</th>	
					<th style="width:5%"><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
				</tr>
				</thead>
				<tbody>
				{foreach from=$arrList key=k item=v}
				<tr {if $k%2=='0'} class="alt-row"{/if}>
					<td align="center">{$v.id}</td>
					<td><span id="content_{$v.id}_title">{$v.title}</span></td>
					<td align="center" class="option">
					<input type="checkbox" value="{$v.title}" id="{$v.id}" key="{$k}" class="chk_item" />
					</td>
				</tr>
				{/foreach}
				</tbody>
					<tfoot>
					<tr>
						<td colspan="3">
							<div align="center" class="bulk-actions align-left">
								<input type="button" value="Choose" class="button" id="choose"/>
							</div>
							{include file="../../../pgg_frontend.tpl"}
						</td>
					</tr>
					</tfoot>
				</table>
			{else}
				<div align="center"><p>no content found</p></div>
			{/if}
				</div><!--/Keyword Research-->
			</div>
			<div class="feature" style="width:100%; ">
				<div style="left:10px;top:0px;width:100%;"><!--Text file (new line separated) or CSV file-->
					<br />
					<form class="wh validate" style="width:70%" action="" method="POST" enctype="multipart/form-data" id="import_form">
						<label>File <em>*</em></label>
						<input type="file" name="file" class="file required" >
						<div align="center"><p><input type="submit" value="Choose" id="choosefile"></p></div>
					</form>
				</div><!--/Text file (new line separated) or CSV file-->
			</div>
		</div>

{literal}
<script type="text/javascript" src="/skin/_js/tabs/rotater.js"></script>
<script type="text/javascript" src="/skin/_js/tabs/tabs.js"></script>
<script type="text/javascript">
var keywordsTable = new Class({
	initialize: function(){
		var tabs = new MGFX.Tabs('.tab','.feature',{startIndex:0});
		$('select_all').addEvent('click', function(){
			$$('.chk_item').each(function(el){
				el.checked=$('select_all').checked;
			});
		});
		$('choosekeyw').addEvent('click', function(){
			var arr=new Array();
			var i=0;
			$$('.chk_item').each(function(v){
				if(v.checked){
					arr[i]=v.id;
					i++;
				}
			});
			var strJson = JSON.encode( arr.clean() );
			var req = new Request({
					url: "{/literal}{url name='keyword_generator' action='multiboxlist'}{literal}",
					onComplete:function(r){
						var arrRes = JSON.decode(r);
						window.parent.SourceTypeObject[{/literal}{$smarty.get.flg_source}{literal}].prototype.setKeyword(arrRes);
//						window.parent.visual.jsonContentIds = JSON.decode(strJson);
						if ( window.parent.document.getElementById( 'jsonContentIds' ) ) {
						window.parent.document.getElementById( 'jsonContentIds' ).value = strJson;}
						window.parent.multibox_keywords.close();
					},
				}).get({ 'keyword':1, 'jsonIds':strJson });	
		});
		var jsonKeywordsFromFile = '{/literal}{$arrRes.filekeywords}{literal}';
		if ( jsonKeywordsFromFile != '' ) {
			var arrKeywordsFromFile = new Array( JSON.decode(jsonKeywordsFromFile) );
			window.parent.SourceTypeObject[{/literal}{$smarty.get.flg_source}{literal}].prototype.setKeyword( arrKeywordsFromFile );
			window.parent.multibox_keywords.close();
		}		
		$('home').setStyle('display','');
		$('tabs').setStyle('display','');
	}
});

window.addEvent('domready', function(){
	new keywordsTable();
});
</script>
{/literal}