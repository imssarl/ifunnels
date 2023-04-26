<div class="form-group">
	<label>Category: <em>*</em></label>
	<select class="required validate-custom-required btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][category_id]" alt="You have not chosen category." class="required">
		<option value=''> - select - </option>
		{html_options options=$video selected={$arrCnt.{$i.flg_source}.settings.category_id}}
	</select>
</div>
<div class="from-group">
	<label>Search by tags:</label>
	<input size="40" type="text" name="arrCnt[{$i.flg_source}][settings][tags]" class="form-control" value="{if !empty($arrCnt.{$i.flg_source}.settings.tags) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.tags}{/if}" alt="You have not written tags."/>
</div>
{literal}
<script type="text/javascript">
SourceTypeObject[2] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 2;
	},
});
</script>
{/literal}