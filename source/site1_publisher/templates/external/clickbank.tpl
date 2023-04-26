{$mode=$arrPrm.modelSettings}
<script type="text/javascript" src="/skin/_js/typedtags.js"></script>
{if $mode==1}
<div class="form-group">
	<label>Search tags:</label>
	<input size="40" id="searching_tags_for_clickbank" class="form-control" alt="You have not written tags" type="text" name="arrCnt[{$i.flg_source}][settings][tags]" value="{if !empty($arrCnt.{$i.flg_source}.settings.tags) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.tags}{else}{/if}" {if $arrPrj.flg_status==1}disabled="disabled"{/if} />
</div>{/if}
<div class="form-group">
	<label>Language {if $mode==1}<em>*</em>{/if}</label>
	<select name="arrCnt[{$i.flg_source}][settings][flg_language]" class="required validate-custom-required btn-group selectpicker show-tick" alt="You have not chosen language" id="language" {if $arrPrj.flg_status==1}disabled="disabled"{/if}>
		<option value="">- select -</option>
		{foreach from=Core_Language::$flags item=flags key=lang_id}<option {if $arrCnt.{$i.flg_source}.settings.flg_language==$lang_id} selected="selected" {/if} value="{$lang_id}">{$flags.title}</option>
		{/foreach}
	</select>
</div>		
<div class="form-group clickbank_lang" {if empty($arrCnt.{$i.flg_source}.settings.flg_language)}style="display:none;"{/if}>
	<label>Category {if $mode==1}<em>*</em>{/if}</label>
	<select class="btn-group selectpicker show-tick" alt="You have not chosen main category" name="arrCnt[{$i.flg_source}][settings][category_pid]" id="category_clickbank">
		<option value="">- select -</option>
		{foreach from=$arrCategories item=category}<option {if {$arrCnt.{$i.flg_source}.settings.category_pid} == $category.id}selected="selected"{/if} value="{$category.id}">{$category.title}</option>
		{/foreach}
	</select>
</div>		
<div class="form-group clickbank_lang" {if empty($arrCnt.{$i.flg_source}.settings.flg_language)}style="display:none;"{/if}><label></label>
	<select class="btn-group selectpicker show-tick" alt="You have not chosen second category" name="arrCnt[{$i.flg_source}][settings][category_id]" id="category_clickbank_child">
		<option value="">- select -</option>
	</select>
</div>
<div class="form-group">
	<label>Affiliate ID {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" id="affilate_id_clickbank" class="required form-control" alt="You have not writen affilate ID" type="text" name="arrCnt[{$i.flg_source}][settings][affiliate_id]" value="{if !empty($arrCnt.{$i.flg_source}.settings.affiliate_id)}{$arrCnt.{$i.flg_source}.settings.affiliate_id}{else}{/if}" {if $arrPrj.flg_status==1}disabled="disabled"{/if}/>
</div>
{if count(Project_Content_Adapter_Clickbank::$templates)>1}<div class="form-group">
	<label>Template</label>
	<select  name="arrCnt[{$i.flg_source}][settings][template]" class="btn-group selectpicker show-tick">
		{foreach from=Project_Content_Adapter_Clickbank::$templates item=template key=ids}<option {if {$arrCnt.{$i.flg_source}.settings.template} == $ids}selected="selected"{/if} value="{$ids}">{$template}</option>
		{/foreach}
	</select>
</div>{/if}
{literal}<script type="text/javascript">
var categoryClbId = {/literal}{$arrCnt.{$i.flg_source}.settings.category_id|default:'null'}{literal};
var jsonCategoryClickbank = {/literal}{$arrCatTree|json|default:'null'}{literal};
SourceTypeObject[10] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 10;
		var ClickbankLanguage = new CategoriesSelects({
			language: 'language',
			category_parent: 'category_clickbank',
			category_child: 'category_clickbank_child',
			post_settings: {'action':'get_category'}, // post action
			request_url: '{/literal}{url name="content_clickbank" action="ajax_get"}{literal}', // request url
			selected: { // ids of selected elements
				parent_id : '{/literal}{$arrCnt.{$i.flg_source}.settings.category_pid}{literal}',
				child_id : '{/literal}{$arrCnt.{$i.flg_source}.settings.category_id}{literal}'
			}
			});
		var ClickbankSelects = new Categories({
			firstLevel:'category_clickbank',
			secondLevel:'category_clickbank_child',
			intCatId: categoryClbId,
			jsonTree: jsonCategoryClickbank
		});
		$('language').addEvent( 'change', function(){
			if(this.value==''){
				$$('.clickbank_lang').hide();
			} else {
				$$('.clickbank_lang').show();
			}
		});
    }
});
</script>{/literal}