{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
{if $msg}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if $error}{include file="../../message.tpl" type='info' message=$error}{/if}
<table class="table  table-striped">
	<thead>
	<tr class="tableheading">
		<th>Test Name{if count($arrList)>1}{if $arrFilter.order!='title--up'}<a href="{url name='site1_hiam' action='manage_split' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_hiam' action='manage_split' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>Campaigns Included</th>
		<th style="width:120px;">Started{if count($arrList)>1}{if $arrFilter.order!='added--up'}<a href="{url name='site1_hiam' action='manage_split' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_hiam' action='manage_split' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>Duration{if count($arrList)>1}{if $arrFilter.order!='flg_duration--up'}<a href="{url name='site1_hiam' action='manage_split' wg='order=flg_duration--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_duration--dn'}<a href="{url name='site1_hiam' action='manage_split' wg='order=flg_duration--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th>Status{if count($arrList)>1}{if $arrFilter.order!='flg_enabled--up'}<a href="{url name='site1_hiam' action='manage_split' wg='order=flg_enabled--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_enabled--dn'}<a href="{url name='site1_hiam' action='manage_split' wg='order=flg_enabled--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th style="width:160px;"> Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='split' key='id'}
	<tr id="row{$id}"{if $id%2=='0'} class="matros"{/if}>
		<td align="left">
			<a href="" class="open_div" id_num="{$split.id}" title="Click Here To Expand" style="cursor:pointer">{$split.title}</a>
		</td>
		<td align="center">{foreach from=$split.arrCom item=company key=pid name=companies}{$company.title}{if !$smarty.foreach.companies.last },&nbsp;{/if}{/foreach}</td>
		<td align="center">{$split.added|date_format:$config->date_time->dt_full_format}</td>
		<td align="center">{if $split.flg_duration=='1'}{$split.duration} days{elseif $split.flg_duration=='2'}{$split.duration} hits{else}Not Restricted{/if}</td>
		<td align="center">{if $split.flg_enabled!='0'}Completed{else}Running{/if}</td>
		<td>
			<a {is_acs_write} href="{url name='site1_hiam' action='create_split'}?id={$split.id}" title="Edit">
				<i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i>
			</a>
			<a {is_acs_write} href="{url name='site1_hiam' action='manage_split'}?split_del_id={$split.id}" style="padding: 0;" class="alert" alt="Do you want to delete this Split test?" title="Delete">
				<i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i>
			</a>
			<a {is_acs_write} href="{url name='site1_hiam' action='manage_split'}?split_duplicate_id={$split.id}" style="padding: 0;" class="alert" alt="Do you want to duplicate this Split test?" title="Duplicate">
				<i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i>
			</a>
			{if ( empty( $split.flg_closed ) )}
			<a {is_acs_write} href="#" class="request" rel="pause" key="{$split.id}" title="Set to pause">
				<i class="ion-ios7-pause" style="font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i>
			{else}
			<a {is_acs_write} href="" class="open_div" id_num="{$split.id}" style="cursor:pointer">
				<i class="ion-ios7-play" style="font-size: 20px; vertical-align: bottom; margin: 0px 5px;" title="Split test is over and a winning campaign is now running.Click here to view." title="Split test is over and a winning campaign is now running.Click here to view."></i>
			{/if}
			</a>
			<a {is_acs_write} style="cursor:pointer" rel="" href="{url name='site1_hiam' action='getcode'}?type=splittest&id={$split.id}" class="popup" title="View Code">
				<i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i>
			</a>
		</td>
	</tr>
	<tr>
		<td colspan="6">
		<div id="split{$split.id}" style="display:none;">
			<table style="width:98%;" align="center" >
			<tr>
				<th>Campaign Name</th>
				<th># of impressions</th>
				<th># of clicks</th>
				<th># of effectiveness [ C.T.R. ]</th>
				<th style="width:40px;">Options</th>
			</tr>
			{foreach from=$split.arrCom item=company key=pid}
			<tr{if $pid%2=='0'} class="matros"{/if}>
				<td align="left">{$company.title}</td>
				<td align="center" valign="top">{$company.views}</td>
				<td align="center" valign="top">{$company.clicks}</td>
				<td align="center" valign="top">{$company.crt}{if !empty($company.crt)}&nbsp;%{else}0{/if}</td>
				<td align="center">
					{if $split.flg_closed!='0'&&$company.flg_winner == '1'}
					<a {is_acs_write} href="#" class="request" key="{$split.id}" cid="{$company.id}">
						<img src="/skin/i/frontends/design/buttons/winner.jpg" border="0" title="Winning Campaign">
					{elseif $split.flg_closed=='0'&&$company.flg_winner == '0'&&$company.crt==$company.maxcrt}
					<a {is_acs_write} href="#" class="request" rel="winner" key="{$split.id}" imag="ns" cid="{$company.id}">
						<img src="/skin/i/frontends/design/buttons/winner_ns.gif" border="0" title="Click here to make this campaign as winner" style="cursor:pointer">
					{else}
					<a {is_acs_write} href="#" class="request"  rel="winner_q" key="{$split.id}" imag="br" cid="{$company.id}">
						<img src="/skin/i/frontends/design/buttons/winner_br.jpg" border="0" title="Click here to make this campaign as winner" style="cursor:pointer">
					{/if}
					</a>
				</td>
			</tr>
			{/foreach}
			<tr class="subtableheading" >
				<td colspan="6" height="2"></td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
	{foreachelse}
	<tr><td align='center' colspan='6'>No split Found</td></tr>
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
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
var manage_splitrClass = new Class({
	initialize: function(){
		multibox=new CeraBox( $$('.popup'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
			displayTitle: true,
			titleFormat: '{title}'
		});
		$$('.alert').each( function(el){
			el.addEvent('click', function(e) {
				return confirm( el.get('alt') )
			});
		});
		$$('.request').each( function(el){
			el.addEvent('click', function(e) {
				e.stop();
				if ( el.get('rel') != 'stoped'){
					if ( (el.get('rel') =="winner" || el.get('rel') =="winner_q") && confirm("Do you want to make this Campaign as a winner?") ) {
						this.requestRel(el);
					} else if ( el.get('rel') =="pause" && confirm("Do you want to end this split test?\n\rIf yes then Campaign with highest CTR will be made as a winner\n\ralthough you can change it later by clicking on the winner image icon") ) {
						this.requestRel(el);
					}
				}
			}.bind(this));
		}.bind(this));
		$$('.open_div').each(function(el){
			el.addEvent('click', function(e) {
				e.stop();
				this.eventOpenDiv(el,'id_num');
			}.bind(this));
		}.bind(this));
	},
	eventOpenDiv : function(el,tag) {
		if ($('split'+el.get(tag)).getStyle('display') == 'none') {
			$('split'+el.get(tag)).setStyle('display','inline');
			el.set({'title':'Click Here To Collapse'});
			el.getParent('tr').addClass('backcolor3');
		} else {
			$('split'+el.get(tag)).setStyle('display','none');
			el.set({'title':'Click Here To Expand'});
			el.getParent('tr').removeClass('backcolor3');
		}
	},
	requestRel: function (el) {
		this_class = this;
		var r=new Request({
			url: '{/literal}{url name="site1_hiam" action="request"}{literal}',
			onRequest: function(){
				el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/ajax-loader_new.gif','title':'Work'});
			},
			onSuccess: function(json){
				arr=JSON.decode(json);
				if ( arr ) {
					this_class.trueRequest(el);
				} else {
					this_class.falseRequest(el);
				}
			}		
		}).post( {'rel':el.get('rel'),'split_id':el.get('key'),'com_id':((el.get('cid')!=null)?el.get('cid'):$$('.request[key='+el.get('key')+'][rel=winner]').get('cid'))} );
	},
	trueRequest: function (el) {
		if ( el.get('rel') == 'pause' ) {
			$$('.request[key='+el.get('key')+'][rel=winner]')[0].erase('rel').getChildren('img').set({'src':'/skin/i/frontends/design/buttons/winner.jpg','title':'Winning Campaign'});
			el.set({'rel':'stoped'})
			.getChildren('i')
			.set({'class':'ion-ios7-play','title':'Split test is over and a winning campaign is now running.Click here to view.'})
			.addEvent('click', function(e) {
				e.stop();
				this.eventOpenDiv(el,'key');
			}.bind(this));
		} else if ( (el.get('rel') == 'winner' || el.get('rel') == 'winner_q') ) {
			if ( $$('.request[key='+el.get('key')+'][rel=pause]')[0] != null ) {
				$$('.request[key='+el.get('key')+'][rel=pause]')[0]
				.set({'rel':'stoped'})
				.getChildren('i')
				.set({'class':'ion-ios7-play','title':'Split test is over and a winning campaign is now running.Click here to view.'})
				.addEvent('click', function(e) {
					e.stop();
					this.eventOpenDiv(el,'key');
				}.bind(this));
			}
			$$('.request[key='+el.get('key')+'][rel!=pause][rel!=stoped]').each ( function (elts) {
				elts.set({'rel':'winner','imag':'br'}).getChildren('img').set({'src':'/skin/i/frontends/design/buttons/winner_br.jpg','title':'Click here to make this campaign as winner'});
			});
			el.erase('rel').getChildren('img').set({'src':'/skin/i/frontends/design/buttons/winner.jpg','title':'Winning Campaign'});
		}
	},
	falseRequest: function (el) {
		alert("Faled operation!");
		if ( el.get('rel') == 'pause' ) {
			el.getChildren('i').set({'class':'ion-ios7-pause','title':'Set to pause'});
		} else if ( el.get('rel') == 'winner' ) {
			if ( el.get('imag') == 'ns' ) {
				el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/winner_ns.gif','title':'Click here to make this campaign as winner'});
			} else if ( el.get('imag') == 'br' ) {
				el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/winner_br.jpg','title':'Click here to make this campaign as winner'});
			}
		}
	}
});
window.addEvent('domready', function() {
new manage_splitrClass();
});
</script>
{/literal}