<div class="form-group">
	<label>Keywords: <em>*</em></label>
	<input size="40" class="required not_started in_progress cross_linking completed text-input medium-input form-control" type="text" name="arrCnt[{$i.flg_source}][settings][keywords]" value="{if !empty($arrCnt.{$i.flg_source}.settings.keywords) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.keywords}{else}{/if}" alt="You have not writen Keywords."/>
</div>
<div class="form-group">
	<label>Video Size:</label>
	<div class="box_set">
		<div class="item{if $arrCnt.{$i.flg_source}.settings.width==420&&$arrCnt.{$i.flg_source}.settings.height==315} selected{/if}" align="center">
			<div class="top_text">
			<span class="width">420</span>&nbsp;x&nbsp;<span class="height">315</span>
			</div>
			<div class="box" style="width:42px;height:32px;">&nbsp;</div>
		</div>
		<div class="item{if $arrCnt.{$i.flg_source}.settings.width==480&&$arrCnt.{$i.flg_source}.settings.height==360} selected{/if}" align="center">
			<div class="top_text">
			<span class="width">480</span>&nbsp;x&nbsp;<span class="height">360</span>
			</div>
			<div class="box" style="width:48px;height:36px;">&nbsp;</div>
		</div>
		<div class="item{if $arrCnt.{$i.flg_source}.settings.width==640&&$arrCnt.{$i.flg_source}.settings.height==480} selected{/if}" align="center">
			<div class="top_text">
			<span class="width">640</span>&nbsp;x&nbsp;<span class="height">480</span>
			</div>
			<div class="box" style="width:64px;height:48px;">&nbsp;</div>
		</div>
		<div class="item{if $arrCnt.{$i.flg_source}.settings.width==960&&$arrCnt.{$i.flg_source}.settings.height==720} selected{/if}" align="center">
			<div class="top_text">
			<span class="width">960</span>&nbsp;x&nbsp;<span class="height">720</span>
			</div>
			<div class="box" style="width:96px;height:72px;">&nbsp;</div>
		</div>
	</div>
	<br style="clear:both;"/>
</div>
<div class="form-group">
	<label>Video Width:</label>
	<input type="text" name="arrCnt[{$i.flg_source}][settings][width]" value="{if !empty($arrCnt.{$i.flg_source}.settings.width) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.width}{else}{/if}" id="input_video_width" class="text-input medium-input form-control" />&nbsp;px
</div>
<div class="form-group">
	<label>Video Height:</label>
	<input type="text" name="arrCnt[{$i.flg_source}][settings][height]" value="{if !empty($arrCnt.{$i.flg_source}.settings.height) && !empty($arrData.id)}{$arrCnt.{$i.flg_source}.settings.height}{else}{/if}" id="input_video_height" class="text-input medium-input form-control" />&nbsp;px<br/>
	<p>(by default, video size is: 480x360)</p>
</div>
{literal}
<script type="text/javascript">
SourceTypeObject[5] = new Class({
	Extends: SourceObject,
    initialize: function(){
		this.source_id = 5;
		$$('.item').each( function (elt){
			elt.addEvent('click', function(){
				$('input_video_width').value=elt.getChildren('.top_text')[0].getChildren('.width')[0].get('html');
				$('input_video_height').value=elt.getChildren('.top_text')[0].getChildren('.height')[0].get('html');
			});
		});
	}
});
</script>
{/literal}