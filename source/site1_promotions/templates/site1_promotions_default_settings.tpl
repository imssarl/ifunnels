{include file='../../box-top.tpl' title="Default Campaign Settings"}
<div class="card-box">
<form class="reg_form wh validate" style="width:50%" action="" method="post">
	<div class="form-group">
		<label>Category:</label>
		<select name="arrCampaign[settings][category_id]" type="text" class="required btn-group selectpicker show-tick" >
			{foreach from=$arrCategories item=i key=k}<option value="{$i.id}"{if $arrCampaign.settings.category_id==$i.id} selected="selected"{/if}>{$i.title}</option>{/foreach}
		</select>
	</div>
	{include file="site1_promotions_types.tpl"}
	<div class="form-group">
		<span id="promote_cost"></span>
	</div>
	<div class="form-group">
		<button type="submit" class="submit button btn btn-success waves-effect waves-light" id="submit_box" {is_acs_write}>Submit</button>
	</div>
</form>
</div>
{include file='../../box-bottom.tpl'}
{literal}
<script>
var slider_var=new Array();
function checkPromotions(){
	var static_amount=0;
	$$('.check_promotion').each( function( e ){
		if( e.getStyle('display') != 'none' ){
			static_amount+=parseFloat( e.getElement('input').value) * parseFloat( e.get('rel') );
		}
	});
	$('promote_cost').set('html', 'Cost of campaign '+Math.ceil( static_amount )+' credit(s).');
}
$$('.slider_promotions').each(function(elt){
	slider_var[elt.get('id')]=new Slider( elt, elt.getElement('.knob'), {
		steps: 100,
		initialStep: elt.getNext('input').get('value'),
		onChange: function(value){
			elt.getNext('input').set('value', value);
			elt.getPrevious('label').getElement('span.text').set('html', value);
			checkPromotions();
		}
	});
});
$$('.check').addEvent('change', function(elt){
	$('checkeddiv_'+this.get('rel')).show();
	if( !this.checked ){
		$('checked_'+this.get('rel')).value=0;
		slider_var['slider_'+this.get('rel')].setKnobPosition(0);
		$('slider_'+this.get('rel')).getPrevious('label').getElement('span.text').set('html', 0);
		$('checkeddiv_'+this.get('rel')).hide();
	}
	checkPromotions();
});
$$('.check_promotion').addEvent('change', function( elt ){
	checkPromotions();
});
checkPromotions();
</script>
{/literal}