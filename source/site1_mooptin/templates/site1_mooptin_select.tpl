<div class="form-group" id="add_new_mooptin">
	{if count($arrList)>0}
	{foreach $arrList as $v}
	<div class="radio radio-primary">
		<input type="radio" class="select" name="{$arrPrm.elementsName}" value="{$v.id}" {if $v.id==$arrPrm.checkedId}checked="checked"{/if} />
		<label>&nbsp;{$v.name}</label>
	</div>
	{/foreach}
	{/if}
</div>
{literal}<script>
window.placeMoOptin=function( id, name ){
	if( typeof id == undefined || typeof name == undefined ){
		return;
	}
	$('add_new_mooptin').adopt(
		new Element( 'div.radio.radio-primary' ).adopt([
			new Element ( 'input.select[type="radio"][name="{/literal}{$arrPrm.elementsName}{literal}"][value="'+id+'"][checked="checked"]' ),
			new Element ( 'label' ).set('html', '&nbsp;'+name)
		])
	);
}
</script>{/literal}