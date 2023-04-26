<div class="form-group">
	<label>Add RSS links: <em>*</em></label>
	<textarea id="keyword-conteiner" name="arrCnt[{$i.flg_source}][settings][rss_links]" style="height:50px;" {if $arrPrm.flg_status == 3}disabled="disabled"{/if} alt="You have not written rss links." class="required form-control" cols="5">{if !empty($arrCnt.{$i.flg_source}.settings.rss_links) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.rss_links}{/if}</textarea>
</div>
<div class="form-group">
	
	<div class="checkbox checkbox-primary">
		<input name="arrCnt[{$i.flg_source}][settings][flg_insert_links]" type="checkbox" {if $arrCnt.{$i.flg_source}.settings.flg_insert_links == '1' && !empty($arrData.id)}checked="checked"{/if} value="1" {if $arrPrm.flg_status == 3}disabled="disabled"{/if} />
		<label> Don't insert link to content</label>
	</div>
</div>
{literal}
<script type="text/javascript">
SourceTypeObject[6] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id=6;
	}
});
</script>
{/literal}