{include file='../../box-top.tpl' title='Create Campaign'}
<div class="card-box">
{if $msg}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if $error}{include file="../../message.tpl" type='error' message=$error}{/if}
<div class="red" style="padding:10px;">
<form action="" method="post" class="wh validate">
	<input type="hidden" value="{if isset( $arrCampaign.user_id) }{$arrCampaign.user_id}{/if}" name="arrData[user_id]">
	<input type="hidden" value="{if isset( $arrCampaign.id) }{$arrCampaign.id}{/if}" name="arrData[id]">
	<fieldset>
		<div class="form-group">
			<label>URL: <em>*</em></label>
			<input type="text" size="50" id="input_select" autocomplete="off" class="medium-input text-input required form-control" value="{if isset( $arrCampaign.url) }{$arrCampaign.url}{/if}" name="arrData[url]"/>
			{if count($arrDomains)>0 }
			<div id="select_box">
				<ul>
					{foreach from=$arrDomains item=i}
					<li>{if $i.domain_http!=null}{$i.domain_http}{else}{$i.domain_ftp}{/if}</li>
					{/foreach}
				</ul>
			</div>
			{/if}
		</div>
		<div class="form-group">
			<label>Category: <em>*</em></label>
			<select id="first_category" class="add_category required btn-group selectpicker show-tick" name="arrData[category_id]"{if isset( $arrCampaign.category_id) } rel="{$arrCampaign.category_id}"{/if}></select>
		</div>
		<div class="form-group">
			<label>Allowed credits: <em>*</em></label>
			<input type="number" min="1" max="{$trafficCredits}" size="10" class="medium-input text-input required form-control" value="{if isset( $arrCampaign.credits) }{$arrCampaign.credits}{else}1{/if}" name="arrData[credits]"/>
		</div>
		<div class="form-group">
			<button type="submit" class="submit button btn btn-success waves-effect waves-light" name="submit">Create</button>
		</div>
	</fieldset>
</form>
</div>
<script type="text/javascript">{literal}
window.addEvent('domready', function(){
	$('input_select').addEvents({
		'focus': function(){
			if( $('input_select').get('value') == '' ){
				$('select_box').show();
			}
		},
		'keydown': function(){
			$('select_box').hide();
		}
	});
	$$('#select_box ul li').addEvent('click',function(e){
		$('input_select').set('value', e.target.get('html') );
		$('select_box').hide();
	});
	var addAfter='add_category';
	var replace_name='';
	var openItems = function( id, json ){
		if( id != '' ){
			if( json.node != undefined && JSON.encode( json.node ) != '[]' ){
				new Hash( json.node ).each(function(item){
					openItems( id, item );
				});
			}else{
				$$('.item[rel="'+json.id+'"]').show();
			}
		}
	};
	var addCategories = function( selected_element, node_json ){
		new Element('option[value=""][html="- select -"]')
			.inject( $(selected_element) );
		new Hash( node_json ).each(function(item){
			var newOption = new Element('option[value="'+item.id+'"][html="'+item.title+'"]')
				.inject( $(selected_element) );
			$( selected_element ).addEvent('change',function(event){
				if( event.target.value == '' ){
					$( selected_element ).getAllNext('.'+addAfter).destroy();
					$$('#list_box .item').hide();
					if( $$('.'+addAfter)[$$('.'+addAfter).length-2] != null )
						openItems( $$('.'+addAfter)[$$('.'+addAfter).length-2].value, {id:$$('.'+addAfter)[$$('.'+addAfter).length-2].value, node: node_json} );
					return;
				}
				if( event.target.value != item.id ){
					return;
				}
				$$('#list_box .item').hide();
				openItems( event.target.value, item );
				$( selected_element ).getAllNext('.'+addAfter).destroy();
				if( item.node != undefined && JSON.encode( item.node ) != '[]' ){
					if( replace_name=='' ){
						replace_name=$( selected_element ).get('name');
					}
					$( selected_element ).erase('name');
					new Element('select[id="'+item.level+'_category"][class="'+addAfter+'"][name="arrData[category_id]"]')
						.inject($$('.'+addAfter)[$$('.'+addAfter).length-1], 'after');
					addCategories( item.level+'_category', item.node );
				}
			});
			// check for selected category
			if( $( selected_element ).get('rel') == item.id ){
				newOption.set('selected','selected');
				$( selected_element ).fireEvent('change', {'target':newOption} );
			}
		});
	};
	addCategories( 'first_category', JSON.decode( '{/literal}{$arrCategoryTree|json}{literal}' ) );
});
</script>
{/literal}
{include file='../../box-bottom.tpl'}