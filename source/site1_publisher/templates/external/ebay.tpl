{$mode=$arrPrm.modelSettings}
<div class="form-group">
	<label>eBay Affiliate ID (CampID): {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][app_id]" value="{if !empty($arrCnt.{$i.flg_source}.settings.app_id)}{$arrCnt.{$i.flg_source}.settings.app_id}{else}{/if}" alt="You have not writen eBay Affiliate ID (CampID)."/>
	<a style="text-decoration:none" class="Tips" title="You will only earn affiliate commission if you enter your Ebay affiliate ID."><b> ?</b></a>
</div>
<div class="form-group">
	<label>Country: {if $mode==1}<em>*</em>{/if}</label>
	<select class="required validate-custom-required emptyValue:'0' btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][global_id]" alt="You have not chosen Country.">
		<option value="0" {if empty($arrCnt.{$i.flg_source}.settings.global_id )}selected="selected"{/if}> - select - </option>
		<option value="EBAY-US" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-US"}selected="selected"{/if} >United States</option>
		<option value="EBAY-ENCA" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-ENCA"}selected="selected"{/if} >Canada</option>
		<option value="EBAY-GB" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-GB"}selected="selected"{/if} >United kingdom</option>
		<option value="EBAY-AU" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-AU"}selected="selected"{/if} >Australia</option>
		<option value="EBAY-AT" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-AT"}selected="selected"{/if} >Austria</option>
		<option value="EBAY-FRBE" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-FRBE"}selected="selected"{/if} >Belgium (French)</option>
		<option value="EBAY-FR" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-FR"}selected="selected"{/if} >France</option>
		<option value="EBAY-DE" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-DE"}selected="selected"{/if} >Germany</option>
		<option value="EBAY-MOTOR" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-MOTOR"}selected="selected"{/if} >eBay Motors</option>
		<option value="EBAY-IT" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-IT"}selected="selected"{/if} >Italy</option>
		<option value="EBAY-NLBE" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-NLBE"}selected="selected"{/if} >Belgium (Dutch)</option>
		<option value="EBAY-NL" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-NL"}selected="selected"{/if} >Netherlands</option>
		<option value="EBAY-ES" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-ES"}selected="selected"{/if} >Spain</option>
		<option value="EBAY-CH" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-CH"}selected="selected"{/if} >Switzerland</option>
		<option value="EBAY-IN" {if $arrCnt.{$i.flg_source}.settings.global_id == "EBAY-IN"}selected="selected"{/if} >India</option>
	</select>
</div>
{if $mode==1}<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required  form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{else}{/if}" alt="You have not writen Keywords."/>
</div>{/if}
<div class="form-group">
	<label>Sort results by: {if $mode==1}<em>*</em>{/if}</label>
	<select class="required validate-custom-required emptyValue:'0' btn-group selectpicker show-tick " name="arrCnt[{$i.flg_source}][settings][order]" alt="You have not chosen Sort results order.">
		<option value="0" {if empty($arrCnt.{$i.flg_source}.settings.order)}selected="selected"{/if}> - select - </option>
		<option value="BestMatch" {if $arrCnt.{$i.flg_source}.settings.order == "BestMatch"}selected="selected"{/if} >Best Match</option>
		<option value="EndTimeSoonest" {if $arrCnt.{$i.flg_source}.settings.order == "EndTimeSoonest"}selected="selected"{/if} >Time: ending soonest</option>
		<option value="StartTimeNewest" {if $arrCnt.{$i.flg_source}.settings.order == "StartTimeNewest"}selected="selected"{/if} >Time: newly listed</option>
		<option value="PricePlusShippingLowest" {if $arrCnt.{$i.flg_source}.settings.order == "PricePlusShippingLowest"}selected="selected"{/if} >Price + Shipping: lowest first</option>
		<option value="PricePlusShippingHighest" {if $arrCnt.{$i.flg_source}.settings.order == "PricePlusShippingHighest"}selected="selected"{/if} >Price + Shipping: highest first</option>
		<option value="CurrentPriceHighest" {if $arrCnt.{$i.flg_source}.settings.order == "CurrentPriceHighest"}selected="selected"{/if} >Price: highest first</option>
	</select>
</div>
{literal}<script type="text/javascript">
SourceTypeObject[11] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id=11;
	}
});
</script>{/literal}