{$mode=$arrPrm.modelSettings}
{if $mode==1}
<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input class="required form-control" id="yahoo_answer_keyword" name="arrCnt[{$i.flg_source}][settings][query]" type="text" value="{if !empty($arrCnt.{$i.flg_source}.settings.query) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.query}{/if}" alt="You have not writen keywords."/>
	<a style="text-decoration:none" class="Tips" title="Search terms."><b> ?</b></a>
</div>{/if}
<div class="form-group">
	<label>Country: {if $mode==1}<em>*</em>{/if}</label>
	<select class="required btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][region]" alt="You have not chosen country.">
		<option value="">- select -</option>
		{foreach from=Project_Content_Adapter_Yahooanswers::$region item=region key=lang_id}<option {if $arrCnt.{$i.flg_source}.settings.region==$region.value} selected="selected" {/if} value="{$region.value}">{$region.title}</option>
		{/foreach}
	</select>
</div>
<div class="form-group">
	<label>Question status set: {if $mode==1}<em>*</em>{/if}</label>
	<select class="required validate-custom-required btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][type]" alt="You have not chosen Question status.">
		<option value="">- select -</option>
		<option value="all" {if $arrCnt.{$i.flg_source}.settings.type == "all"}selected="selected"{/if} >to all</option>
		<option value="resolved" {if $arrCnt.{$i.flg_source}.settings.type == "resolved"}selected="selected"{/if} >to resolved</option>
		<option value="open" {if $arrCnt.{$i.flg_source}.settings.type == "open"}selected="selected"{/if} >to open</option>
		<option value="undecided" {if $arrCnt.{$i.flg_source}.settings.type == "undecided"}selected="selected"{/if} >to undecided</option>
	</select>
</div>
<div class="form-group">
	<label>Sorting order of result set: {if $mode==1}<em>*</em>{/if}</label>
	<div class="radio radio-primary">
		<input type="radio" id="relevance_ya" name="arrCnt[{$i.flg_source}][settings][sort]" {if $arrCnt.{$i.flg_source}.settings.sort == 'relevance'}checked="checked"{/if} value="relevance"/>
		<label>by relevance</label>
	</div>
	<div class="radio radio-primary">
		<input type="radio" id="date_desc_ya" name="arrCnt[{$i.flg_source}][settings][sort]" {if $arrCnt.{$i.flg_source}.settings.sort == 'date_desc'}checked="checked"{/if} value="date_desc"/>
		<label>by date, newest first</label>
	</div>
	<div class="radio radio-primary">
		<input type="radio" id="date_asc_ya" name="arrCnt[{$i.flg_source}][settings][sort]" {if $arrCnt.{$i.flg_source}.settings.sort == 'date_asc'}checked="checked"{/if} value="date_asc" class="validate-one-required"/>
		<label>by date, oldest first</label>
	</div>
</div>
{literal}
<script type="text/javascript">
SourceTypeObject[8] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 8;
	}
});
</script>
{/literal}