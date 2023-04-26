{if $arrPrm.modelSettings == 0 || empty($arrPrm.modelSettings)}<form action="" method="post" class="wh" style="width:50%" id="externaldata" enctype="multipart/form-data">
	<div id="accordion" style="display:none;">
		{foreach Project_Content::toLabelArray() as $i}	
		<h3 class="toggler">{$i.title} Options</h3>
			<input class="required" type="text" name="arrCnt[{$i.flg_source}][id]" value="{if !empty($arrCnt.{$i.flg_source}.id)}{$arrCnt.{$i.flg_source}.id}{/if}" style="display:none;"/>
			<input class="required" id="input_{$i.flg_source}" type="text" name="arrCnt[{$i.flg_source}][flg_source]" value="{$i.flg_source}" style="display:none;"/>
			<div class="element initElement">
			<fieldset>
				<legend></legend>
					{include file="external/{$i.label}.tpl"}<br/>
			</fieldset>
		</div>
		{/foreach}
	</div>
<input type="submit" id="editExtend" value="Save" />
</form>
<div class="block2" id="mess"></div>
{else}
		{foreach Project_Content::toLabelArray() as $i}
			<li id="content_{$i.flg_source}" class="option_content" {if $arrPrm.selectedSource != {$i.flg_source}}style="display:none;"{/if}>
				{include file="external/{$i.label}.tpl"}
			</li>
		{/foreach}
{/if}
{literal}
<style type="text/css">
.toggler { 
padding: 5px 0px;
cursor: pointer;
position: relative;
z-index: 10;
}
</style>
<script type="text/javascript">
// Это для Keywords
var setKeyword=function(arr){
	var str=$('edit-keywords-value').value;
	arr.each(function(item){
		 str += item.keyword + '\n';
	});
	$('edit-keywords-value').value=str;
	$('edit-keywords-list').hide();
	$('edit-keywords').hide();
	$('keywords-place').show('block');
	$('edit-keywords-value').show('block');
}

var objAccordion = {};
window.addEvent('domready', function() {
	// Acordion functions
	objAccordion = new Fx.Accordion($('accordion'), $$('.toggler'), $$('.element'), { fixedHeight:false });
	// Title functions
	var optTips = new Tips('.Tips', {className: 'tips'});
	$$('.Tips').each(function(a){
			a.addEvent('click',
					function(e){
						if (!empty(e.get('href')))
						e.stop()
						})
			});		
});
$('accordion').show('block');
</script>
{/literal}