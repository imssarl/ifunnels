{$mode=$arrPrm.modelSettings}
<div class="form-group">
	<label>Web Services Token: {if $mode==1}<em>*</em>{/if}</label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][token]" value="{if !empty($arrCnt.{$i.flg_source}.settings.token)}{$arrCnt.{$i.flg_source}.settings.token}{else}{/if}" alt="You have not writen Web Services Token."/>
	<a target="_blank" href="http://www.linkshare.com" style="text-decoration:none" class="Tips" title="This setting is required for the Linkshare module to work!"><b> ?</b></a>
</div>
{if $mode==1}
<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keyword]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keyword) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keyword}{/if}" alt="You have not writen Keywords."/>
</div>{/if}
<div class="form-group">
	<label>Sort by:</label>
	<select id="sort_by_linkshare" class="btn-group selectpicker show-tick" name="arrCnt[{$i.flg_source}][settings][sort]">
		<option value="">- select -</option>
		<option value="retailprice" {if $arrCnt.{$i.flg_source}.settings.sort == "retailprice"}selected="selected"{/if} >Price</option>
		<option value="productname" {if $arrCnt.{$i.flg_source}.settings.sort == "productname"}selected="selected"{/if} >Product Name</option>
		<option value="categoryname" {if $arrCnt.{$i.flg_source}.settings.sort == "categoryname"}selected="selected"{/if} >Category Name</option>
		<option value="mid" {if $arrCnt.{$i.flg_source}.settings.sort == "mid"}selected="selected"{/if} >Merchant ID</option>							
	</select>
</div>
<div class="form-group" id="sort_order_linkshare" {if empty($arrCnt.{$i.flg_source}.settings.sort)}style="display:none;"{/if}>
	<label>Sort Order: {if $mode==1}<em>*</em>{/if}</label>
	<select class="btn-group selectpicker show-tick required validate-custom-required" name="arrCnt[{$i.flg_source}][settings][sorttype]" id="sort_order_linkshare_input">
		<option value="">- select -</option>
		<option value="asc" {if $arrCnt.{$i.flg_source}.settings.sorttype == "asc"}selected="selected"{/if} >Ascending</option>
		<option value="dsc" {if $arrCnt.{$i.flg_source}.settings.sorttype == "dsc"}selected="selected"{/if} >Descending</option>		
	</select>
</div>
{literal}
<script type="text/javascript">
SourceTypeObject[13] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 13;
		$('sort_by_linkshare').addEvent('change', function(element) {
			if (element.target.get('value') != "") {
				$('sort_order_linkshare').show('inline');
			}else{
				$('sort_order_linkshare').hide();
				$('sort_order_linkshare_input').set('value','');
			}
		});
	}
});
</script>
{/literal}