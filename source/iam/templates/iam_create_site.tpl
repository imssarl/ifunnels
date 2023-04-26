<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<form action="" method="POST" enctype="multipart/form-data" class="wh" >
<input type="hidden" name="arrOpt[id]" value="{$arrOpt.id}">
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label>Site Url</label>
			<input type="text" name="arrData[site_url]" value="{$arrData.site_url}" />
		</li>
		<li>
			<label>Title</label>
			<input type="text" name="arrData[title]" value="{$arrData.title}" />
		</li>
		<li>
			<label>Keyword</label>
			<input type="text" name="arrData[keyword]" value="{$arrData.keyword}" />
		</li>
		<li>
			<label>Header Teaser</label>
			<input type="text" name="arrData[header_teaser]" value="{$arrData.header_teaser}" />
		</li>
		<li>
			<label>Author Text</label>
			<input type="text" name="arrData[author_text]" value="{$arrData.author_text}" />
		</li>
		<li>
			<label>Form Title</label>
			<input type="text" name="arrData[form_title]" value="{$arrData.form_title}" />
		</li>
		<li>
			<label>Form Text</label>
			<input type="text" name="arrData[form_text]" value="{$arrData.form_text}" />
		</li>
		<li>
			<label>Awlist</label>
			<input type="text" name="arrData[awlist]" value="{$arrData.awlist}" />
		</li>
		<li>
			<label>Tags</label>
			{if isset($arrData.tags) && !empty($arrData.tags)}
			{foreach from=$arrData.tags key='tag_key' item='tag_value'}
				{if $tag_key != 0}
				<label>&nbsp;</label>
				{/if}
			<input type="text" name="arrData[tags][{$tag_key}]" id="tag-{$tag_key+1}" rel="{$tag_key}" class="tags_count" value="{$tag_value}" /><br/>
			{/foreach}
			{else}
			<input type="text" name="arrData[tags][0]" id="tag-1" rel="0" class="tags_count" /><br/>
			{/if}
			<input type="button" id="add_tag" value="Add tag">
		</li>
	</ol>
	<ol id="article_box">
		{if isset($arrData.article_title) && !empty($arrData.article_title)}
		{foreach from=$arrData.article_title key='article_key' item='article_value'}
		<li>
			<label>Article Title</label>
			<input type="text" name="arrData[article_title][{$article_key}]" id="article_title-{$article_key+1}" rel="{$article_key}" class="articles_count" value="{$article_value}" />
		</li>
		<li>
			<label>Vendor ID</label>
			<input type="text" name="arrData[article_vendorid][{$article_key}]" value="{$arrData.article_vendorid.{$article_key}}" />
		</li>
		<li>
			<label>Article Summary</label>
			<textarea name="arrData[article_summary][{$article_key}]">{$arrData.article_summary.{$article_key}}</textarea>
		</li>
		<li>
			<label>Article Full Text</label>
			<textarea name="arrData[article_text][{$article_key}]" id="article-{$article_key+1}" class="article_text">{$arrData.article_text.{$article_key}}</textarea>
		</li>
		<li>
			<label>Article Tags</label>
			<select multiple name="arrData[article_tags][{$article_key}][]" class="article_tags">
				{if isset($arrData.tags) && !empty($arrData.tags)}
				{foreach from=$arrData.tags key='tag_all_key' item='tag_all_value'}
				<option value="{$tag_all_key}" rel="{$tag_all_key}"{if isset($arrData.article_tags.{$article_key}) && !empty($arrData.article_tags.{$article_key})}{foreach from=$arrData.article_tags.{$article_key} key='tag_article_number' item='tag_article_key'}{if $tag_article_key == $tag_all_key} selected{/if}{/foreach}{/if}>{$tag_all_value}</option>
				{/foreach}
				{/if}
			</select>
		</li>
{literal}
<script type="text/javascript">

CKEDITOR.replace( 'article-{/literal}{$article_key+1}{literal}', {
	toolbar : 'Basic',
	height:"300",
	width:"900"
});

</script>	
{/literal}
		{/foreach}
		{else}
		<li>
			<label>Article Title</label>
			<input type="text" name="arrData[article_title][0]" id="article_title-1" rel="0" class="articles_count" />
		</li>
		<li>
			<label>Vendor ID</label>
			<input type="text" name="arrData[article_vendorid][0]" />
		</li>
		<li>
			<label>Article Summary</label>
			<textarea name="arrData[article_summary][0]"></textarea>
		</li>
		<li>
			<label>Article Full Text</label>
			<textarea name="arrData[article_text][0]" id="article-1" class="article_text"></textarea>
		</li>
		<li>
			<label>Article Tags</label>
			<select multiple name="arrData[article_tags][0][]" class="article_tags">
				{if isset($arrData.tags) && !empty($arrData.tags)}
				{foreach from=$arrData.tags key='t' item='a'}
				<option value="{$t}" rel="{$t}">{$a}</option>
				{/foreach}
				{/if}
			</select>
		</li>
{literal}
<script type="text/javascript">

CKEDITOR.replace( 'article-1', {
	toolbar : 'Basic',
	height:"300",
	width:"900"
});

</script>	
{/literal}
		{/if}
		<li id="before_article">
			<input type="button" id="add_article" value="Add article">
		</li>
	</ol>
	<ol id="menu_box">
		{if isset($arrData.menu_title) && !empty($arrData.menu_title)}
		{foreach from=$arrData.menu_title key='menu_key' item='menu_value'}
		<li>
			<label>Menu Title</label>
			<input type="text" name="arrData[menu_title][{$menu_key}]" class="menu_titles" value="{$menu_value}" />
		</li>
		<li>
			<label>Menu Articles</label>
			<select multiple name="arrData[menu_articles][{$menu_key}][]" class="menu_articles">
				{if isset($arrData.article_title) && !empty($arrData.article_title)}
				{foreach from=$arrData.article_title key='article_all_key' item='article_all_value'}
				<option value="{$article_all_key}" rel="{$article_all_key}"{if isset($arrData.menu_articles.{$menu_key}) && !empty($arrData.menu_articles.{$menu_key})}{foreach from=$arrData.menu_articles.{$menu_key} key='menu_article_number' item='menu_article_key'}{if $menu_article_key == $article_all_key} selected{/if}{/foreach}{/if}>{$article_all_value}</option>
				{/foreach}
				{/if}
			</select>
		</li>
		{/foreach}
		{else}
		<li>
			<label>Menu Title</label>
			<input type="text" name="arrData[menu_title][0]" class="menu_titles" />
		</li>
		<li>
			<label>Menu Articles</label>
			<select multiple name="arrData[menu_articles][0][]" class="menu_articles">
				{if isset($arrData.article_title) && !empty($arrData.article_title)}
				{foreach from=$arrData.article_title key='article_all_key' item='article_all_value'}
				<option value="{$article_all_key}" rel="{$article_all_key}">{$article_all_value}</option>
				{/foreach}
				{/if}
			</select>
		</li>
		{/if}
		<li id="before_menu">
			<input type="button" id="add_menu" value="Add menu">
		</li>
		
		<li>
			<label>Custom Header</label>
			<textarea name="arrData[custom_header]">{$arrData.custom_header}</textarea>
		</li>
		
		<li>
			<label>Custom Footer</label>
			<textarea name="arrData[custom_footer]">{$arrData.custom_footer}</textarea>
		</li>
		
		<li>
			<label>Sidebar ( after autor )</label>
			<textarea name="arrData[after_autor]">{$arrData.after_autor}</textarea>
		</li>
		
		<li>
			<label>Product ( bottom )</label>
			<textarea name="arrData[on_product_bottom]">{$arrData.on_product_bottom}</textarea>
		</li>
		
		<li>
			<label>Site Type</label>
			<input type="radio" name="arrData[type]" value="" {if !isset($arrData.type) || $arrData.type==''}checked{/if}> Standart
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="arrData[type]" value="master" {if isset($arrData.type) && $arrData.type=='master'}checked{/if}> Master
		</li>
		<li>
			<label>Images File Archive</label>
			<input type="file" name="images" />
			<input type="hidden" name="arrData[file_images_name]" value="{$arrData.file_images_name}">
		</li>
		<li>
			<label>Use Action</label>
			<input type="radio" name="arrData[action]" value="" {if !isset($arrData.action) || $arrData.action==''}checked{/if}> Only Save
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="arrData[action]" value="download" {if isset($arrData.action) && $arrData.action=='download'}checked{/if}> Save & Download
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="arrData[action]" value="upload" {if isset($arrData.action) && $arrData.action=='upload'}checked{/if}> Save & Upload to IAM Site
		</li>
		<li>
			<input type="submit" value="Save">
		</li>
	</ol>
</fieldset>

</form>
{literal}
<script type="text/javascript">
function addArticlesIAM(){
	$$('.articles_count').each(function(tag_elt){
			$$('.menu_articles').each(function(tag_select){
				var flgHaveTag=false;
				tag_select.getElements('option').each(function(tag_option){
					if( tag_option.get('rel') == tag_elt.get('id') ){
						flgHaveTag=true;
					}
				});
				if( tag_elt.get('value') != '' ){
					if( !flgHaveTag ){
						new Element( 'option', {'value':tag_elt.get('rel'), 'rel': tag_elt.get('id'),'html': tag_elt.get('value')} ).inject( tag_select );
					}else{
						if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'value', tag_elt.get('rel') );
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'html', tag_elt.get('value') );
						}
					}
				}else{
					if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
						tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].destroy();
					}
				}
			});
	});
}

function updateArticlesIAM(){
	$$('.articles_count').each(function(tag_elt){
		console.log( tag_elt.get('value') );
		tag_elt.addEvent('change',function(){
			$$('.menu_articles').each(function(tag_select){
				var flgHaveTag=false;
				tag_select.getElements('option').each(function(tag_option){
					if( tag_option.get('rel') == tag_elt.get('id') ){
						flgHaveTag=true;
					}
				});
				if( tag_elt.get('value') != '' ){
					if( !flgHaveTag ){
						new Element( 'option', {'value':tag_elt.get('rel'), 'rel': tag_elt.get('id'),'html': tag_elt.get('value')} ).inject( tag_select );
					}else{
						if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'value', tag_elt.get('rel') );
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'html', tag_elt.get('value') );
						}
					}
				}else{
					if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
						tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].destroy();
					}
				}
			});
		});
	});
}
updateArticlesIAM();

function addTagsIAM(){
	$$('.tags_count').each(function(tag_elt){
			$$('.article_tags').each(function(tag_select){
				var flgHaveTag=false;
				tag_select.getElements('option').each(function(tag_option){
					if( tag_option.get('rel') == tag_elt.get('id') ){
						flgHaveTag=true;
					}
				});
				if( tag_elt.get('value') != '' ){
					if( !flgHaveTag ){
						new Element( 'option', {'value':tag_elt.get('rel'), 'rel': tag_elt.get('id'),'html': tag_elt.get('value')} ).inject( tag_select );
					}else{
						if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'value', tag_elt.get('rel') );
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'html', tag_elt.get('value') );
						}
					}
				}else{
					if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
						tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].destroy();
					}
				}
			});
	});
}

function updateTagsIAM(){
	$$('.tags_count').each(function(tag_elt){
		tag_elt.addEvent('change',function(){
			$$('.article_tags').each(function(tag_select){
				var flgHaveTag=false;
				tag_select.getElements('option').each(function(tag_option){
					if( tag_option.get('rel') == tag_elt.get('id') ){
						flgHaveTag=true;
					}
				});
				if( tag_elt.get('value') != '' ){
					if( !flgHaveTag ){
						new Element( 'option', {'value':tag_elt.get('rel'), 'rel': tag_elt.get('id'),'html': tag_elt.get('value')} ).inject( tag_select );
					}else{
						if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'value', tag_elt.get('rel') );
							tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].set( 'html', tag_elt.get('value') );
						}
					}
				}else{
					if( tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]').length != 0 ){
						tag_select.getElements('option[rel="'+tag_elt.get('id')+'"]')[0].destroy();
					}
				}
			});
		});
	});
}
updateTagsIAM();

$('add_article').addEvent('click',function(){
	var articleNumber=$$('.articles_count').length;
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Article Title'} ),
		new Element( 'input', { 'type': 'text' ,'name': 'arrData[article_title]['+articleNumber+']', 'id':'article_title-'+(articleNumber+1), 'rel': articleNumber, 'class': 'articles_count' })
	]).inject($('before_article'), 'before');
	updateArticlesIAM();
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Vendor ID'} ),
		new Element( 'input', { 'type': 'text' ,'name': 'arrData[article_vendorid]['+articleNumber+']' })
	]).inject($('before_article'), 'before');
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Article Summary'} ),
		new Element( 'textarea', { 'name': 'arrData[article_summary]['+articleNumber+']' })
	]).inject($('before_article'), 'before');
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Article Full Text'} ),
		new Element( 'textarea', { 'name': 'arrData[article_text]['+articleNumber+']', 'id': 'article-'+(articleNumber+1), 'class': 'article_text' })
	]).inject($('before_article'), 'before');
	CKEDITOR.replace( 'article-'+(articleNumber+1), {
		toolbar : 'Basic',
		height:"300",
		width:"900"
	});
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Article Tags'} ),
		new Element( 'select', { 'name': 'arrData[article_tags]['+articleNumber+'][]', 'multiple': 'multiple', 'class': 'article_tags' })
	]).inject($('before_article'), 'before');
	addTagsIAM();
});
$('add_tag').addEvent('click',function(){
	var tagNumber=$$('.tags_count').length ;
	new Element( 'label', {'html':'&nbsp;'}).inject($('add_tag'), 'before');
	new Element( 'input', { 'type': 'text' ,'name': 'arrData[tags]['+tagNumber+']', 'class': 'tags_count', 'rel': tagNumber,'id': 'tag-'+( tagNumber+1 ) } ).inject($('add_tag'), 'before');
	new Element( 'br').inject($('add_tag'), 'before');
	updateTagsIAM();
});
$('add_menu').addEvent('click',function(){
	var menuNumber=$$('.menu_articles').length ;
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Menu Title'} ),
		new Element( 'input', { 'type': 'text' ,'name': 'arrData[menu_title]['+menuNumber+']' })
	]).inject($('before_menu'), 'before');
	new Element( 'li').adopt([
		new Element( 'label', {'html': 'Menu Articles'} ),
		new Element( 'select', { 'name': 'arrData[menu_articles]['+menuNumber+'][]', 'multiple': 'multiple', 'class': 'menu_articles' })
	]).inject($('before_menu'), 'before');
	addArticlesIAM();
});
</script>
{/literal}