{$mode=$arrPrm.modelSettings}
<div class="form-group">
	<label>Website ID (PID): {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][website_id]" value="{if !empty($arrCnt.{$i.flg_source}.settings.website_id)}{$arrCnt.{$i.flg_source}.settings.website_id}{/if}" alt="You have not writen Website ID (PID)."/>
	<a style="text-decoration:none" title="This value is your Web site ID (PID), which enables the system to generate the appropriate link code in the response. The PID must match the Web site PID which you used to register for the developer key." class="Tips" ><b> ?</b></a>
</div>
<div class="form-group">
	<label>Developer Key: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][appkey]" value="{if !empty($arrCnt.{$i.flg_source}.settings.appkey)}{$arrCnt.{$i.flg_source}.settings.appkey}{/if}" alt="You have not writen Developer Key."/>
	<a style="text-decoration:none" title="Commission Junction's REST Web Services use the standard HTTP Authorization header to pass authentication information.  You must provide your developer key to pass authentication." class="Tips" ><b> ?</b></a>
</div>
{if $mode==1}
<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{/if}" alt="You have not writen Keywords."/>
	<a style="text-decoration:none" title="This value restricts the search results based on keywords found in the advertiser’s name, the product name or the product description. This parameter may be left blank if other parameters (such as upc, isbn) are provided. You may use simple Boolean logic operators (’r;+’, ’r;-’r;) to obtain more relevant search results. By default, the system assumes basic OR logic. The examples below illustrate how these operators affect search results." class="Tips" ><b> ?</b></a>
</div>
{/if}
<div class="form-group">	
	<label>Sort by:</label>
	<select name="arrCnt[{$i.flg_source}][settings][sort_by]" class="btn-group selectpicker show-tick">
		<option value="">- select -</option>
		<option value="name" {if $arrCnt.{$i.flg_source}.settings.sort_by == "name"}selected="selected"{/if} >Name</option>
		<option value="price" {if $arrCnt.{$i.flg_source}.settings.sort_by == "price"}selected="selected"{/if} >Price</option>
		<option value="salePrice" {if $arrCnt.{$i.flg_source}.settings.sort_by == "salePrice"}selected="selected"{/if} >Sale price</option>
		<option value="manufacturer" {if $arrCnt.{$i.flg_source}.settings.sort_by == "manufacturer"}selected="selected"{/if} >Manufacturer</option>
	</select>
</div>		
<div class="form-group">	
	<label>Sort Order:</label>
	<select name="arrCnt[{$i.flg_source}][settings][sort_order]" class="btn-group selectpicker show-tick">
		<option value="">- select -</option>
		<option value="asc" {if $arrCnt.{$i.flg_source}.settings.sort_order == "asc"}selected="selected"{/if} >Ascending</option>
		<option value="desc" {if $arrCnt.{$i.flg_source}.settings.sort_order == "desc"}selected="selected"{/if} >Descending</option>		
	</select>
</div>		
<div class="form-group">
	<label>Minimum Price:</label>
	<input size="40" type="text" name="arrCnt[{$i.flg_source}][settings][low_price]" value="{if !empty($arrCnt.{$i.flg_source}.settings.low_price)}{$arrCnt.{$i.flg_source}.settings.low_price}{else}{/if}" class="form-control" />
</div>
<div class="form-group">
	<label>Maximum Price:</label>
	<input size="40" type="text" name="arrCnt[{$i.flg_source}][settings][high_price]" value="{if $arrCnt.{$i.flg_source}.settings.high_price!=''}{$arrCnt.{$i.flg_source}.settings.high_price}{else}{/if}" class="form-control" />
</div>
<div class="form-group">
	<label>Country: {if $mode==1}<em>*</em>{/if}</label>
	<select class="required btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][serviceable_area]" alt="You have not chosen Country.">
		<option value="">- select -</option>
		<option value="us" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "us"}selected="selected"{/if} >English</option>
		<option value="de" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "de"}selected="selected"{/if} >German</option>
		<option value="fr" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "fr"}selected="selected"{/if} >French</option>
		<option value="it" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "it"}selected="selected"{/if} >Italian</option>
		<option value="es" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "es"}selected="selected"{/if} >Spanish</option>
		<option value="nl" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "nl"}selected="selected"{/if} >Dutch</option>
		<option value="cn" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "cn"}selected="selected"{/if} >Chinese</option>
		<option value="tw" {if $arrCnt.{$i.flg_source}.settings.serviceable_area == "tw"}selected="selected"{/if} >Taiwanese</option>								
	</select>
</div>
{if count(Project_Content_Adapter_Cj::$templates)>1 }
<div class="form-group">
	<label>Template</label>
	<select name="arrCnt[{$i.flg_source}][settings][template]" class="btn-group selectpicker show-tick">
		{foreach from=Project_Content_Adapter_Cj::$templates item=template key=ids}
		<option {if {$arrCnt.{$i.flg_source}.settings.template} == $ids}selected="selected"{/if} value="{$ids}">{$template}</option>
		{/foreach}
	</select>
</div>
{/if}
{literal}<script type="text/javascript">
SourceTypeObject[12] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 12;
	}
});
</script>{/literal}