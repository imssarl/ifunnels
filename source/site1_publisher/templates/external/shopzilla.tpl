{$mode=$arrPrm.modelSettings}
<div class="form-group">
	<label>Shopzilla API Key: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][api_key]" value="{if !empty($arrCnt.{$i.flg_source}.settings.api_key)}{$arrCnt.{$i.flg_source}.settings.api_key}{else}{/if}"/>
	<a style="text-decoration:none" class="Tips" title="This setting is required for the Shopzilla module to work!"><b> ?</b></a>
</div>
<div class="form-group">
	<label>Shopzilla Publisher ID: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][pub_id]" value="{if !empty($arrCnt.{$i.flg_source}.settings.pub_id)}{$arrCnt.{$i.flg_source}.settings.pub_id}{else}{/if}"/>
	<a style="text-decoration:none" class="Tips" title="This setting is required for the Shopzilla module to work!"><b> ?</b></a>
</div>
<div class="form-group">
	<label>Number of Offers: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][offers]" value="{if !empty($arrCnt.{$i.flg_source}.settings.offers)}{$arrCnt.{$i.flg_source}.settings.offers}{/if}"/>
</div>
<div class="form-group">
	<label>Sort: {if $mode==1}<em>*</em>{/if}</label>
	<select class="required validate-custom-required emptyValue:'0' btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][sort]">
		<option value="0" {if empty($arrCnt.{$i.flg_source}.settings.sort )}selected="selected"{/if}> - select - </option>
		<option value="relevancy_desc" {if $arrCnt.{$i.flg_source}.settings.sort == "relevancy_desc"}selected="selected"{/if} >Sort by relevancy of results</option>
		<option value="price_asc" {if $arrCnt.{$i.flg_source}.settings.sort == "price_asc"}selected="selected"{/if} >Sort by price, ascending</option>
		<option value="price_desc" {if $arrCnt.{$i.flg_source}.settings.sort == "price_desc"}selected="selected"{/if} >Sort by price, descending</option>							
	</select>
</div>
{if $mode==1}<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{/if}" alt="You have not written Keywords."/>
</div>{/if}
<div class="form-group">
	<label>Minimum Price: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][minprice]" value="{if !empty($arrCnt.{$i.flg_source}.settings.minprice)}{$arrCnt.{$i.flg_source}.settings.minprice}{else}{/if}"/>
</div>
<div class="form-group">
	<label>Maximum Price: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][maxprice]" value="{if !empty($arrCnt.{$i.flg_source}.settings.maxprice)}{$arrCnt.{$i.flg_source}.settings.maxprice}{else}{/if}"/>
</div>
{if count(Project_Content_Adapter_Shopzilla::$templates)>1}<div class="form-group">
	<label>Template</label>
	<select  class="required btn-group selectpicker show-tick" alt="You have not chosen main category" name="arrCnt[{$i.flg_source}][settings][template]" id="category_clickbank">
		{foreach from=Project_Content_Adapter_Shopzilla::$templates item=template key=ids}<option {if {$arrCnt.{$i.flg_source}.settings.template} == $ids}selected="selected"{/if} value="{$ids}">{$template}</option>
		{/foreach}
	</select>
</div>{/if}
{literal}
<script type="text/javascript">
SourceTypeObject[14] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 14;
	}
});
</script>
{/literal}