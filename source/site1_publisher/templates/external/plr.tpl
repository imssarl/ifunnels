<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required text-input medium-input form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{else}{/if}" alt="You have not writen Keywords."/>
</div>
<div class="form-group">
	<label>Category <em>*</em></label>
	<select  class="required validate-custom-required medium-input btn-group selectpicker show-tick" alt="You have not chosen main category" name="arrCnt[{$i.flg_source}][settings][category_pid]" id="category_plr">
		<option value="">- select -</option>
		{foreach from=$arrPlrCategories item=category}<option {if {$arrCnt.{$i.flg_source}.settings.category_pid} == $category.id && !empty($arrData.id)}selected="selected"{/if} value="{$category.id}">{$category.title}</option>
		{/foreach}
	</select>
</div>		
<div class="form-group">
	<label></label>
	<select class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" alt="You have not chosen second category" name="arrCnt[{$i.flg_source}][settings][category_id]" id="category_plr_child">
		<option value="0">- select -</option>
	</select>
		{if $arrErrors.category_id}<span class="error">this fields can't be empty</span>{/if}
</div>
{literal}
<script type="text/javascript">
var categoryPlrId = {/literal}{if  !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.category_id|default:'null'}{else}null{/if}{literal};
var jsonCategoryPlr = {/literal}{$arrPlrTree|json|default:'null'}{literal};
SourceTypeObject[7] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 7;
		new Categories({
			firstLevel:'category_plr',
			secondLevel:'category_plr_child',
			intCatId: categoryPlrId,
			jsonTree: jsonCategoryPlr
		});
	}
});
</script>
{/literal}