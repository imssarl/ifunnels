<link rel="stylesheet" href="/skin/_js/tabs/tabs.css" />
<div class="content-box-header">
	<ul class="content-box-tabs">
		<li><a href="#content_wizard" {if $save_article_true != 2}class="default-tab current"{/if}>Content Wizard</a></li> <!-- href must be unique and match the id of target div -->
		<li><a href="#articles_import" {if $save_article_true == 2}class="default-tab current"{/if}>Articles import</a></li>
	</ul>
	<div class="clear"></div>
</div>
<div class="content-box-content">
	<div id="content_wizard" class="tab-content{if $save_article_true != 2} default-tab{/if}"> <!-- This is the target div. id must match the href of this div's tab -->
	{if $save_article_true == 1}
		{include file='../../../message.tpl' type='info' message='Articles saved successfully'}
	{/if}
		<table>
			<tr>
				<td colspan="6" id="content_1">
					<form action="" method="post" class="wh validate" id="filter_form" style="width:95%" enctype="multipart/form-data">
						Category:&nbsp;<select id="articles_category_main" class="small-input" name="arrFlt[category_id]">
							<option value="0"> - select - </option>
							{html_options options=$articles.category selected=$smarty.get.arrFlt.category_id}
						</select>&nbsp;
						Search by tags:&nbsp;<input size="40" type="text" name="arrFlt[tags]" value="{$smarty.get.arrFlt.tags}" class="text-input small-input" />
						<input type="submit" id="content-filter" class="button" value="Filter" />
					</form>
				</td>
			</tr>
			<thead>
			<tr>
				<th>Id</th>
				<th>Category</th>
				<th>Title</th>
				<th>Summary</th>
				<th>Source</th>
				<th align="center"><input type="checkbox" id="select_all" class="tooltip" title="select all" rel="check to select all" /></th>
			</tr>
			</thead>
			<tbody>
			{if $arrList}
			{$matros=0}
			{foreach from=$arrList item=i key=k}
			<tr {if $matros%2=='0'} class="alt-row"{/if}>
				<td align="center">{$i.id}</td>
				<td align="center"><span id="category_{$i.id}">{$i.category_title|replace:'\r':' '}</span></td>
				<td><span id="content_{$i.id}_title">{$i.title|replace:"\r":" "|escape}</span></td>
				<td><span id="summary_{$i.id}">{$i.summary}</span></td>
				<td align="center"><span id="source_{$i.id}">{$i.source_title}</span></td>
				<td align="center"><input type="checkbox" value="{$i.title}" id="{if !empty({$i.id})}{$i.id}{else}{$k}{/if}" key="{$k}" class="chk_item" /></td>
			</tr>
			{$matros=$matros+1}
			{/foreach}
			{else}
			<tr><td colspan="6" align="center">no content found</td></tr>
			{/if}
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6">
						<div align="center" class="bulk-actions align-left">
							<input type="button" value="Choose" class="button" id="choose"/>
						</div>
						{include file="../../../pgg_frontend.tpl"}
					</td>
				</tr>
			</tfoot>
		</table>
	</div> <!-- End #tab1 -->
	<div id="articles_import" class="tab-content{if $save_article_true == 2} default-tab{/if}">
		{if $save_article_true == 2}
			{include file='../../../message.tpl' type='error' message='Process Aborted. Unable to upload articles. Check format file! '}
		{/if}
		<form class="wh validate" action="" method="POST" id="articles_submit_form" enctype="multipart/form-data">
			<fieldset>
				<legend>Articles import</legend>
				<p>Please complete the form below. Mandatory fields are marked with <em>*</em></p>
				<p>
					<label>Source <em>*</em> </label>
					<select name="import[source]" class="medium-input required validate-custom-required emptyValue:'0'">
						<option value='0'> - select source - </option>
						{html_options options=$articles.source}
					</select>
				</p>
				<p>
					<label>Author</label>
					<input type="text" name="import[author]" class="text-input medium-input" id="import_author" />
				</p>
				<p>
					<label>Article source <em>*</em></label>
					<input type="radio" name="import[article_source]" class="article_source" value="text_file" />&nbsp;Text file (new line separated)<br/>
					<input type="radio" name="import[article_source]" class="article_source {if $return_type == 'form'}validate-one-required{/if}" value="manually" />&nbsp;Manually <br/>
					{if $return_type != 'form'}<input type="radio" name="import[article_source]" class="article_source validate-one-required" value="zip_file" />&nbsp;Zip file <br/>{/if}
				</p>
				<p>
					<label>Status</label>
					<input type="radio" name="import[status]"  value="1" checked='1' />&nbsp;Active <br/>
					<input type="radio" name="import[status]"  value="0" />&nbsp;InActive <br/>
				</p>
			</fieldset>
			<fieldset id="fieldset_manually" style="display:none;">
				<p>
					<label>Category <em>*</em></label>
					<select name="import[manually][category]" class="medium-input required validate-custom-required emptyValue:'0'">
						<option value="0"> - select category -</option>
						{html_options options=$articles.category}
					</select>
				</p>
				<p>
					<label>Title <em>*</em></label>
					<input type="text" name="import[manually][title]"  class="required medium-input text-input"/>
				</p>
				<p>
					<label>Enter article <em>*</em></label>
					<textarea style="height:150px;" name="import[manually][text]" class="required textarea text-input"></textarea>
				</p>
			</fieldset>
			<fieldset id="fieldset_file" style="display:none;">
				<legend>{if $return_type != 'form'}<a href="#" id="add">+ Add</a>{/if}</legend>
				<div>
					<p>
						<label>Category <em>*</em></label>
						<select name="import[category][0]" class="required validate-custom-required emptyValue:'0' medium-input">
							<option value="0"> - select category -</option>
							{html_options options=$articles.category}
						</select>
					</p>
					<p>
						<label>File <em>*</em></label>
						<input type="file" name="import[file][0]" class="file required" >
					</p>
				</div>
			</fieldset>
			<fieldset>
				<p>
					<input type="submit" name="save" value="Save" id="article_save_form" class="button"/>
				</p>
			</fieldset>
		</form>
	</div> <!-- End #tab2 -->
</div>

{literal}
<script type="text/javascript">
	var req = new Request({
		url: "{/literal}{url name='site1_articles' action='showarticle'}{literal}",
		onComplete:function( outJson ){
			var arrArticleRes = new Hash( JSON.decode( outJson ) );
			arrArticleRes.each( function ( source , keyname ) {
				var arrArticleChildRes = new Hash(  source );
				if ( keyname == 'category' ) {
					category = arrArticleChildRes;
				}
				arrArticleChildRes.each ( function ( values , keynumber ) {
					var option = new Element('option', {'value': keynumber}).set('html', values);
					var select = $(document.body).getElements('select.input_options_to_'+keyname);
					select.each ( function (thisselect) {
						option.inject( thisselect,'bottom' );
					});
				});
			});
		}
	}).get({ 'showall':1});
	var importMass = new Class({
		initialize: function( category, index ){
			this.category = category;
			this.first = $('fieldset_file');
			this.nameLinkDelete = 'fieldset_delete';
			this.index=index;
			this.arrError = new Array();
			this.errIndex = 0;
		},
		addFieldset: function(){
			var fieldset = new Element('fieldset');
			var legend = new Element('legend');
			var a = new Element('a',{'class':this.nameLinkDelete,'href':'#'}).set('html', '- delete');
			a.inject( legend.inject( fieldset,'top' ) );
			var p = new Element('p');
			var label_category = new Element('label').set('html','Category <em>*</em>');
			var select = new Element('select',{'name':'import[category]['+this.index+']', 'class':"category_file medium-input required validate-custom-required emptyValue:'0'"});
			var option = new Element('option',{'value':'0'}).set('html','- select category -');
			option.inject(select,'top');
			var hash = this.category;
			Object.each(hash, function(value, name){
				var option = new Element('option', {'value': name}).set('html', value);
				option.inject(select,'bottom');
			});
			label_category.inject(p,'top');
			select.inject(p,'bottom');
			p.inject(fieldset,'bottom');

			var p2 = new Element('p');
			var label_file = new Element('label').set('html', 'File <em>*</em>');
			var input = new Element('input', {'type':'file', 'name':'import[file]['+this.index+']', 'class':'file required'});
			label_file.inject(p2,'top');
			input.inject(p2,'bottom');
			p2.inject(fieldset,'bottom');
			fieldset.inject(this.first,'after');
			this.deleteFieldset();
		},
		deleteFieldset: function(){
			$$('a.'+this.nameLinkDelete).each(function(el){
				el.addEvent('click',function(e){
					e.stop();
					if(el.getParent('fieldset'))
					el.getParent('fieldset').destroy();
				});
			});
		},
		deleteAllFiledset:function(){
			$$('a.'+this.nameLinkDelete).each(function(el){
					el.getParent('fieldset').destroy();
			});		
		}, 
		displayFileBlock:function(){
			$('fieldset_file').show('block');
			$('fieldset_manually').hide();
		},
		displayManually:function(){
			$('fieldset_file').hide();
			$('fieldset_manually').show('block');
			this.deleteAllFiledset();
		}, 
		validateManually:function(e){
			var saveAccordion=objAccordion;
			objAccordion=undefined;
			validator.checker.reset();
			validator.reinit($$('form.validate')[0]);
			this.errIndex=0;
			$$('input.required, textarea.required').each(function(el){
				if  ( el.value == "" && el.getParent('p').getParent('fieldset').style.display!='none' ) {
					validator.checker.validateField( el , true);
					this.errIndex=this.errIndex+1;
				}
			},this);
			$$('input.validate-one-required').each(function(el){
				var isset=false;
				$$('input[name="'+el.get('name')+'"]').each(function(el_test){
					if( el_test.checked ){
						isset=true;
					}
				});
				if  ( !isset ) {
					validator.checker.validateField( el , true);
					this.errIndex=this.errIndex+1;
				}
			},this);
			$$('select.required').each(function(el){
				if ( ( el.value == "" || el.value == "0" ) && el.getParent('p').getParent('fieldset').style.display!='none' ) {
					validator.checker.validateField( el , true);
					this.errIndex=this.errIndex+1;
				}
			},this);
			objAccordion=saveAccordion;
			if ( this.errIndex > 0 ) {
				this.errIndex=0;
				return false;
			}
			return true;
		}
	});

	var articleTable = new Class({
		Implements: Options,
		options : {
			category : '',
			index : 0
		},
		initialize: function(options){
			this.setOptions(options);
			var obj = new importMass(this.options.category,this.options.index);
			obj.deleteFieldset();
			var art_category = this.options.category;
			var art_index = this.options.index;
			$$('input.article_source').each(function(el){
				el.addEvent('click', function(){
					var obj = new importMass(art_category,art_index);
					if(el.value == 'text_file'){
						obj.displayFileBlock();
					} else if (el.value == 'manually') {
						obj.displayManually();
					} else if (el.value == 'zip_file') {
						obj.displayFileBlock();
					}
				});
			});
			if( $('add') ) {
				$('add').addEvent('click', function(e){
					e.stop();
					this.options.index++;
					var obj = new importMass(art_category,this.art_index);
					obj.addFieldset();
				}.bind(this));
			}
			JSONdata = {/literal}{if !empty({$jsonData})}{$jsonData}{else}''{/if}{literal};
			if (JSONdata != '') {
				var addData = Array.from(JSONdata);
				var arrParent = window.parent.placeParam;
				addData.append(arrParent);
				window.parent.placeParam = addData;
				window.parent.placeDo();
				window.parent.multibox.close();		
			}
		}
	});
	window.addEvent('domready',function(){
		new articleTable({category:{/literal}{$articles.category|json}{literal},index:0});
		$('article_save_form').addEvent('click', function(evt) {
			evt.stop();
			var obj=new importMass();
			if( obj.validateManually(evt) ){
				$('articles_submit_form').submit();
			}
		});
		$$('.content-box-content div.tab-content').hide();
		$$('ul.content-box-tabs li a.default-tab').addClass('current');
		$$('.content-box-content div.default-tab').show();
		$$('ul.content-box-tabs li a').addEvent('click',function(){
			$(this).getParent('li').getParent('ul').getChildren("li a").removeClass('current');
			$(this).addClass('current');
			var currentTab = $(this).get('href');
			$$('.tab-content').hide();
			$$(currentTab).show();
			return false;
		});
		$('content-filter').addEvent('click',function(evt){
			window.parent.visual.jsonValue=null;
			var popup_url = new URI(window.location);
			var arrquery = new Hash();
			$('filter_form').getElements('input, select, textarea').each(function(el){
				if  ( ((el.type == "radio")&(el.checked))||(el.type!="radio") ) 
					arrquery.set( el.name , el.value);
			});
			arrquery.set('flg_source','1');
			arrquery.set('id',true);
			popup_url.setData(arrquery);
			$('filter_form').set('action', popup_url.toString());
			$('filter_form').submit();
		});
	});
</script>
{/literal}