{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
{if $msg}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if $error}{include file="../../message.tpl" type='info' message=$error}{/if}

<table class="table  table-striped">
	<tr>
		<td colspan="12">
			<form action="" id="current-form" method="get">
				Filter:
				<select name="arrType[filter]" class="small-input btn-group selectpicker show-tick">
					<option value="0"{if $arrFilter.filter=='0'} selected="selected"{/if}> All </option>
					<option value="1"{if $arrFilter.filter=='1'} selected="selected"{/if}> Running </option>
					<option value="2"{if $arrFilter.filter=='2'} selected="selected"{/if}> Closed </option>
				</select>&nbsp;
				<div class="checkbox checkbox-primary" style="display: inline-block;">
					<input type="checkbox" name="arrType[flg_posc]" value="1"{if $arrFilter.flg_posc=='1'} checked="checked"{/if}>
					<label>Corner</label>	
				</div>
				<div class="checkbox checkbox-primary" style="display: inline-block;">
					<input type="checkbox" name="arrType[flg_poss]" value="1"{if $arrFilter.flg_poss=='1'} checked="checked"{/if}>
					<label>Slide In</label>	
				</div>
				<div class="checkbox checkbox-primary" style="display: inline-block;">
					<input type="checkbox" name="arrType[flg_posf]" value="1"{if $arrFilter.flg_posf=='1'} checked="checked"{/if}>
					<label>Fix Position</label>	
				</div>
				<button type="submit" id="filter" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Filter</button>
			</form>
		</td>
	</tr>
	<thead>
	<tr>
		<th>Campaign name<br/>{if count($arrList)>1}{if $arrFilter.order!='title--up'}<a href="{url name='site1_hiam' action='manage' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>Start date<br/>{if count($arrList)>1}{if $arrFilter.order!='start_date--up'}<a href="{url name='site1_hiam' action='manage' wg='order=start_date--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='start_date--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=start_date--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>End date<br/>{if count($arrList)>1}{if $arrFilter.order!='end_date--up'}<a href="{url name='site1_hiam' action='manage' wg='order=end_date--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='end_date--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=end_date--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th style="width:120px;">Ad type</th>
		<th>On action<br/>{if count($arrList)>1}{if $arrFilter.order!='flg_action--up'}<a href="{url name='site1_hiam' action='manage' wg='order=flg_action--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_action--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=flg_action--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>Play sound<br/>{if count($arrList)>1}{if $arrFilter.order!='flg_sound--up'}<a href="{url name='site1_hiam' action='manage' wg='order=flg_sound--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_sound--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=flg_sound--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>Display mode<br/>{if count($arrList)>1}{if $arrFilter.order!='flg_display--up'}<a href="{url name='site1_hiam' action='manage' wg='order=flg_display--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_display--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=flg_display--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th># of views<br/>{if count($arrList)>1}{if $arrFilter.order!='views--up'}<a href="{url name='site1_hiam' action='manage' wg='order=views--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='views--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=views--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th># of clicks<br/>{if count($arrList)>1}{if $arrFilter.order!='clicks--up'}<a href="{url name='site1_hiam' action='manage' wg='order=clicks--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='clicks--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=clicks--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th># of effectiveness<br/>{if count($arrList)>1}{if $arrFilter.order!='effectiveness--up'}<a href="{url name='site1_hiam' action='manage' wg='order=effectiveness--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='effectiveness--dn'}<a href="{url name='site1_hiam' action='manage' wg='order=effectiveness--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th style="width:160px;"> Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='company' key='id'}
	<tr id="row{$id}"{if $id%2=='0'} class="alt-row"{/if}>
			<td align="left">{$company.title}</td>
			<td align="center">{$company.start_date|date_format:$config->date_time->dt_full_format}</td>
			<td align="center">{$company.end_date|date_format:$config->date_time->dt_full_format}</td>
			<td align="center">{if $company.flg_poss!='0'}Slide In{/if}{if $company.flg_posc!='0' and $company.flg_poss!='0' }, {/if}{if $company.flg_posc!='0'}Corner{/if}{if ($company.flg_posf!='0' and $company.flg_posc!='0') or ($company.flg_posf!='0' and $company.flg_poss!='0')  }, {/if}{if $company.flg_posf!='0'}Fix Position{/if}</td>
			<td align="center">{if $company.flg_action=='0'}On Load{else}When User Leaves the Page{/if}</td>
			<td align="center">{if $company.flg_sound=='0'}No{else}Yes{/if}</td>
			<td align="center">{if $company.flg_display=='0'}Always{else}Once Per Session{/if}</td>
			<td align="center">{$company.views}</td>
			<td align="center">{if $company.clicks > 0}<a title="View Details" style="cursor:pointer" rel="" href="{url name='site1_hiam' action='summary'}?id={$company.id}&view=clicks" class="popup">{$company.clicks}</a>{else}0{/if}</td>
			<td align="center">{if $company.effectiveness > 0}<a title="View Details" style="cursor:pointer" rel="" href="{url name='site1_hiam' action='summary' }?id={$company.id}&view=effectiveness" class="popup">{$company.effectiveness}</a>{else}0{/if}</td>
			<td>
				<a {is_acs_write} href="{url name='site1_hiam' action='create'}?id={$company.id}" title="Edit">
					<i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i>
				</a>
				<a {is_acs_write} href="{url name='site1_hiam' action='manage'}?company_del_id={$company.id}" class="alert" style="padding: 0;" alt="Do you want delete this campaign?" title="Delete">
					<i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i>
				</a>
				<a {is_acs_write} href="{url name='site1_hiam' action='manage'}?company_duplicate_id={$company.id}" class="alert" style="padding: 0;" alt="Do you want duplicate this campaign?" title="Duplicate">
					<i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i>
				</a>
				<a {is_acs_write} style="cursor:pointer" rel="" href="{url name='site1_hiam' action='getcode'}?id={$company.id}&type=company" class="popup" title="Get code">
					<i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i>
				</a>
			</td>
	</tr>
	{foreachelse}
	<tr><td align='center' colspan='12'>No campaign Found</td></tr>
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="12">
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
</div>
{include file='../../box-bottom.tpl'}
{literal}
<script>
var multibox;
var managerClass = new Class({
	initialize: function(){
		$$('.alert').each( function(el){
			el.addEvent('click', function(e) {
				return confirm( el.get('alt') )
			});
		});
		multibox=new CeraBox( $$('.popup'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
			displayTitle: true,
			titleFormat: '{title}'
		});
	}
});
window.addEvent('domready', function() {
new managerClass();
});
</script>
{/literal}