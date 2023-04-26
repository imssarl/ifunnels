<div class="form-group">
	<label>Article Language: <em>*</em></label>
	<select name="arrCnt[{$i.flg_source}][settings][flg_language]" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" id="article_language"{if $arrPrj.flg_status==1} disabled="disabled"{/if} >
		<option value="0"> - select - </option>
		{foreach from=Project_Content_Adapter_Purearticles::$flags item=flags key=lang_id}<option {if $arrCnt.{$i.flg_source}.settings.flg_language==$lang_id && !empty($arrData.id)} selected="selected" {/if} value="{$lang_id}">{$flags.title}</option>
		{/foreach}
	</select>
</div>
<div id="search_types" {if $arrCnt.{$i.flg_source}.settings.flg_language == '1' || empty($arrCnt.{$i.flg_source}.settings.flg_language)}style="display:none;"{/if} class="use_in_publisher">
	<div class="form-group">
		<legend>Select Search Type: <em>*</em></legend>
		<div class="radio radio-primary">
			<input type="radio" id="search_category_select" name="arrCnt[{$i.flg_source}][settings][type]" {if $arrCnt.{$i.flg_source}.settings.type == '1' && !empty($arrData.id)}checked="checked"{/if} value="1"/>
			<label>by categories</label>
		</div>
		<div class="radio radio-primary">
			<input type="radio" id="search_keyword_select" name="arrCnt[{$i.flg_source}][settings][type]" {if $arrCnt.{$i.flg_source}.settings.type == '0' && !empty($arrData.id)}checked="checked"{/if} value="0" class="validate-one-required"/>
			<label>by keywords</label>
		</div>
	</div>
</div>
<div id="search_category" {if (($arrCnt.{$i.flg_source}.settings.flg_language != '1')&&($arrCnt.{$i.flg_source}.settings.type == '0') && !empty($arrData.id) || empty($arrCnt.{$i.flg_source}.settings.flg_language))}style="display:none;"{/if} class="use_in_publisher">
	<div class="form-group">
		<label>Category <em>*</em></label>
			<select class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][category_pid]" id="category_articles">
				 <option value="0"> - select - </option>
				 {foreach from=$arrPureArtCategories item=value}<option {if $arrCnt.{$i.flg_source}.settings.category_pid==$value.id && !empty($arrData.id)}selected='selected'{/if} value="{$value.id}">{$value.title}</option>{/foreach}
			</select>
	</div>
	<div class="form-group">
		<label></label>
		<select name="arrCnt[{$i.flg_source}][settings][category_id]" class="required medium-input validate-custom-required emptyValue:'0' btn-group selectpicker show-tick" id="category_articles_child" >
			<option value="0"> - select - </option>
		</select>
	</div>
</div>
<div id="search_keywords" {if (($arrCnt.{$i.flg_source}.settings.flg_language != '1')&&($arrCnt.{$i.flg_source}.settings.type == '1') || empty($arrCnt.{$i.flg_source}.settings.flg_language))}style="display:none;"{/if} class="use_in_publisher">
	<div class="form-group">
		<label>Keywords: </label>
		<input size="40" type="text" id="keywords_for_pure_articles" class="text-input medium-input form-control" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{/if}"/>
	</div>
</div>
{literal}
<script type="text/javascript">
var categoryPureArtId = {/literal}{if  !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.category_id|default:'null'}{else}null{/if}{literal};
var jsonCategoryPureArt = {/literal}{$arrCatArtTree|json|default:'null'}{literal};
var PureArticlesCategories;
SourceTypeObject[4] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 4;
		if ( PureArticlesCategories != null ) {
			return false;
		}
		PureArticlesCategories = new CategoriesSelects({
			language: 'article_language',
			category_parent :'category_articles',
			category_child :'category_articles_child',
			post_settings :{}, // post action
			request_url :'{/literal}{url name="site1_publisher" action="ajax_get"}{literal}', // request url
			selected :{
				parent_id: 0,
				child_id: categoryPureArtId
			}
		});
		new Categories({
			firstLevel:'category_articles',
			secondLevel:'category_articles_child',
			intCatId: categoryPureArtId,
			jsonTree: jsonCategoryPureArt
		});
		var stringElement = '.lang_'+$('article_language').value;
		$$(stringElement).setStyle('display', 'inline');
		$('article_language').addEvent('change',function(event){
			if (event!= undefined) {
				if ( $('article_language').get('value') == '1' ) {
					$('search_types').setStyle('display','none');
					$('search_category').setStyle('display','');
					$('search_keywords').setStyle('display','');
				} else {
					if ( $('article_language').get('value') == '0' ) {
						$('search_types').setStyle('display','none');
						$('search_category').setStyle('display','none');
						$('search_keywords').setStyle('display','none');
						$('search_category_select').erase('checked');
						$('search_keyword_select').erase('checked');
					} else {
						$('search_types').setStyle('display','');
						$('search_category').setStyle('display','none');
						$('search_keywords').setStyle('display','none');
						$('search_category_select').erase('checked');
						$('search_keyword_select').erase('checked');
					}
				}
			}
		});
		$('search_category_select').addEvent('change',function(event){
			$('search_category').setStyle('display','');
			$('search_keywords').setStyle('display','none');
		});
		$('search_keyword_select').addEvent('change',function(event){
			$('search_category').setStyle('display','none');
			$('search_keywords').setStyle('display','');
		});
	}
});
</script>
{/literal}