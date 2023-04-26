<div class="form-group">
	<label>Category: <em>*</em></label>
	<select id="articles_category_main" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][category_id]" {if $arrPrm.flg_status == 3}disabled="disabled"{/if} alt="You have not chosen Category.">
		<option value="0"> - select - </option>
		{if  !empty({$arrData.id})}
		{html_options options=$articles selected={$arrCnt.{$i.flg_source}.settings.category_id}}
		{else}
		{html_options options=$articles}
		{/if}
	</select>
</div>
<div class="form-group">
	<label>Search by tags:</label>
	<input size="40" type="text" name="arrCnt[{$i.flg_source}][settings][tags]" value="{if !empty($arrCnt.{$i.flg_source}.settings.tags) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.tags}{/if}" {if $arrPrm.flg_status == 3}disabled="disabled"{/if} alt="You have not written tags for search." class="text-input medium-input form-control" />
</div>
{literal}<script type="text/javascript">
SourceTypeObject[1] = new Class({
	Extends: SourceObject,
	initialize: function(){
		this.source_id = 1;
	}
});
</script>{/literal}