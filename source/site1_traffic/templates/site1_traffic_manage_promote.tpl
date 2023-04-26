{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
{if $msg}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if $error}{include file="../../message.tpl" type='info' message=$error}{/if}

<table class="table  table-striped">
	<thead>
	<tr>
		<td colspan="5">
			<form method="post" id="sites-filter">
				Category:
				<select id="first_category" class="btn-group selectpicker show-tick"></select>
				<input type="hidden" value="{if isset( $arrFilter.with_category_id) }{$arrFilter.with_category_id}{/if}" id="with_category_id-filter" name="arrFilter[with_category_id]" />
				<button type="submit" id="filter" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Filter</>
			</form>
		</td>
	</tr>
	<tr>
		<th>Tracking Link<br/>{if count($arrList)>1}{if $arrFilter.order!='url--up'}<a href="{url name='site1_traffic' action='promote' wg='order=url--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='url--dn'}<a href="{url name='site1_traffic' action='promote' wg='order=url--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Category<br/>{if count($arrList)>1}{if $arrFilter.order!='category_id--up'}<a href="{url name='site1_traffic' action='promote' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category_id--dn'}<a href="{url name='site1_traffic' action='promote' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Received Credits<br/>{if count($arrList)>1}{if $arrFilter.order!='clicks--up'}<a href="{url name='site1_traffic' action='manager' wg='order=clicks--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='clicks--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=clicks--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		
		<th>Unique views<br/>{if count($arrList)>1}{if $arrFilter.order!='clicks--up'}<a href="{url name='site1_traffic' action='manager' wg='order=clicks--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='clicks--dn'}<a href="{url name='site1_traffic' action='manager' wg='order=clicks--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>

		<th style="width:90px;"> Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='company' key='id'}
	<tr id="row{$id}"{if $id%2=='0'} class="alt-row"{/if}>
			
			<td align="left">{if $company.flg_locking=='1'}{$company.url}{else}<a href="{$company.url}" target="_blank">{$company.url}</a>{/if}</td>
			
			<td align="center">{if {$arrCategoryTree.{$company.category_id}.pid}!=1}{$arrCategoryTree.{$arrCategoryTree.{$company.category_id}.pid}.title} {/if}{$arrCategoryTree.{$company.category_id}.title}</td>
			<td align="center">{$company.clicks}</td>
			<td align="center">{$company.clicks}</td>
			<td>
				<a {is_acs_write} href="{url name='site1_traffic' action='manage_promote'}?stop={$company.id}" class="alert" alt="Do you want {if $company.flg_locking=='1'}start{else}pause{/if} this promote campaign?">
					{if $company.flg_locking=='1'}<i class="ion-ios7-play" style="font-size: 20px; vertical-align: bottom; margin: 0px 5px;"></i>{else}<i class="ion-ios7-pause" style="font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i>{/if}
				</a>
			</td>
	</tr>
	{foreachelse}
	<tr><td align='center' colspan='5'>No campaign found</td></tr>
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="5">
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
</div>
{include file='../../box-bottom.tpl'}
<script type="text/javascript">{literal}
window.addEvent('domready', function(){
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
		new Element('option[value=""][html="All"]')
			.inject( $(selected_element) );
		new Hash( node_json ).each(function(item){
			var newOption = new Element('option[value="'+item.id+'"][html="'+item.title+'"]')
				.inject( $(selected_element) );
			$( selected_element ).addEvent('change',function(event){
				$('with_category_id-filter').value=event.target.value;
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
					new Element('select[id="'+item.level+'_category"][class="'+addAfter+'"][name="arrFilter[category_id]"]')
						.inject($$('.'+addAfter)[$$('.'+addAfter).length-1], 'after');
					addCategories( item.level+'_category', item.node );
				}
			});
			// check for selected category
			if( $('with_category_id-filter').get('value') == item.id ){
				newOption.set('selected','selected');
				$( selected_element ).fireEvent('change', {'target':newOption} );
			}
		});
	};
	addCategories( 'first_category', JSON.decode( '{/literal}{$arrCategoryTree|json}{literal}' ) );
	$('sites-filter').addEvent('submit',function(e){
		e&&e.stop();
		['with_category_id'].toURI('-filter').go();
	});
});{/literal}
</script>