{if $msg}{include file='../../message.tpl' type='info' message=$msg}{/if}
{if $error}{include file='../../message.tpl' type='info' message=$error}{/if}
<div class="card-box">
<form action="" id="current-form" method="post">
	<table class="table  table-striped">
		<thead>
		<tr class="tableheading">
			<th>Title{if count($arrList)>1}{if $arrFilter.order!='title--up'}<a href="{url name='site1_snippets' action='manage' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Description{if count($arrList)>1}{if $arrFilter.order!='description--up'}<a href="{url name='site1_snippets' action='manage' wg='order=description--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='description--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=description--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th># of parts{if count($arrList)>1}{if $arrFilter.order!='parts--up'}<a href="{url name='site1_snippets' action='manage' wg='order=parts--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='parts--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=parts--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Date created{if count($arrList)>1}{if $arrFilter.order!='added--up'}<a href="{url name='site1_snippets' action='manage' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th>Tracking management{if count($arrList)>1}{if $arrFilter.order!='flg_enabled--up'}<a href="{url name='site1_snippets' action='manage' wg='order=flg_enabled--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_enabled--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=flg_enabled--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th># of impressions{if count($arrList)>1}{if $arrFilter.order!='views--up'}<a href="{url name='site1_snippets' action='manage' wg='order=views--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='views--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=views--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th># of clicks{if count($arrList)>1}{if $arrFilter.order!='clicks--up'}<a href="{url name='site1_snippets' action='manage' wg='order=clicks--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='clicks--dn'}<a href="{url name='site1_snippets' action='manage' wg='order=clicks--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
			<th style="width:190px;"> Options</th>
		</tr>
		</thead>
		<tbody>
		{foreach from=$arrList item='snippet' key='id'}
		<tr id="row{$id}"{if $id%2=='0'} class="matros"{/if}>
				<td align="left">{$snippet.title}</td>
				<td align="left" title="" >{$snippet.description}</td>
				<td align="center">{if ( ($snippet.parts gt 0) or ( !empty( $_GET.snippet_id ) and ($_GET.snippet_id == $snippet.id ) ) )}<a href="" class="open_div" id_num="{$id}" title="Click Here To Expand" style="cursor:pointer">{$snippet.parts}</a>{else}0{/if}</td>
				<td align="center">{$snippet.added|date_format:$config->date_time->dt_full_format}</td>
				<td align="center">{if ($snippet.flg_enabled == '1')}Enabled{else}Disabled{/if}</td>
				<td align="center" class="views_summ_{$snippet.id}">{if !empty({$snippet.views})}{$snippet.views}{else}0{/if}</td>
				<td align="center" class="clicks_summ_{$snippet.id}">
					{if $snippet.clicks != 0}<a {is_acs_write} title="View Details" style="cursor:pointer" rel="" href="{url name='site1_snippets' action='summary'}?snippet_id={$snippet.id}" class="popup">{$snippet.clicks}</a>{else}0{/if}
				</td>
				<td>
					<a {is_acs_write} href="{url name='site1_snippets' action='partcreate'}?snippet_id={$snippet.id}" title="Add snippet part(s)">
						<i class="ion-android-add" style="font-size: 15px; margin: 0 5px; color: #7ADA3F;"></i>
					</a>
					<a {is_acs_write} href="{url name='site1_snippets' action='create'}?id={$snippet.id}" title="Edit">
						<i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i>
					</a>
					<a {is_acs_write} href="{url name='site1_snippets' action='manage'}?snippet_del_id={$snippet.id}" title="Delete">
						<i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i>
					</a>
					<a {is_acs_write} href="{url name='site1_snippets' action='manage'}?snippet_duplicate_id={$snippet.id}" title="Duplicate">
						<i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i>
					</a>

					{*if $snippet.parts != 0*}
					<a {is_acs_write} style="cursor:pointer" rel="" href="{url name='site1_snippets' action='getcode'}?id={$snippet.id}" class="popup" title="Get code">
						<i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i>
					</a>
					{*else}
					<img src="/skin/i/frontends/design/buttons/denied.png" border="0" title="Please add a part before generate code">
					{/if*}

					<a href="" class="open_div" id_num="{$id}" title="Click Here To Expand" style="cursor:pointer">
						<i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i>
					</a>
				</td>
		</tr>
		<tr>
			<td colspan="9">
			<div id="part{$id}" style="display:none;">
				<table style="width:98%;" align="center" >
					<thead>
					<tr >
						<th style="width:520px;">Source Code</th>
						<th>Date created</th>
						<th># of impressions</th>
						<th># of links</th>
						<th># of clicks</th>
						<th>C.T.R.</th>
						<th style="width:123px;">Options</th>
					</tr>
					</thead>
					<tbody>
					{foreach from=$snippet.arrParts item=part key=pid}
					<tr{if $pid%2=='0'} class="matros"{/if}>
						<td align="left">
							{$part.content|truncate:200:"...":true|escape:'htmlall'}
						</td>
						<td align="center" valign="top">{$part.added|date_format:$config->date_time->dt_full_format}</td>
						<td align="center" valign="top" class="replaced_{$part.id} views_{$snippet.id}">{$part.views}</td>
						<td align="center" valign="top">{$part.count_link}</td>
						<td align="center" valign="top" class="replaced_{$part.id}">
							{if $part.clicks != 0}<a title="View Details" style="cursor:pointer" rel="" href="{url name='site1_snippets' action='summary'}?part_id={$part.id}" class="popup clicks_{$snippet.id}">{$part.clicks}</a>{else}0{/if}
						</td>
						<td align="center" valign="top" class="replaced_{$part.id}">{if !empty({$part.ctr})}{$part.ctr}{else}0{/if}</td>
						<td valign="top">
							<a {is_acs_write} style="cursor:pointer" rel="" href="{url name='site1_snippets' action='show'}?id={$part.id}" class="popup" title="View Part">
								<img src="/skin/i/frontends/design/buttons/see.png" border="0" title="View link" style="cursor:pointer">
							</a>
							<a {is_acs_write} href="{url name='site1_snippets' action='partcreate'}?id={$part.id}&snippet_id={$snippet.id}">
								<img src="/skin/i/frontends/design/buttons/edit.png" border="0" title="Edit" style="cursor:pointer">
							</a>
							<a {is_acs_write} href="{url name='site1_snippets' action='manage'}?part_del_id={$part.id}">
								<img src="/skin/i/frontends/design/buttons/delete.png" border="0" title="Delete" style="cursor:pointer">
							</a>
							<a {is_acs_write} href="{url name='site1_snippets' action='manage'}?part_duplicate_id={$part.id}&snippet_id={$snippet.id}">
								<img src="/skin/i/frontends/design/buttons/duplicate.png" border="0" title="Duplicate" style="cursor:pointer">
							</a>
							<a {is_acs_write} href="#" class="request" rel="resume" part_id="{$part.id}" snip_id="{$snippet.id}">
								<img src="/skin/i/frontends/design/buttons/resume.gif" border="0" title="Reset" style="cursor:pointer">
							</a>
							{if ( empty( $part.flg_pause ) )}
							<a {is_acs_write} href="#" class="request" rel="pause" part_id="{$part.id}">
								<img src="/skin/i/frontends/design/buttons/pause.png" border="0" title="Set to pause" style="cursor:pointer">
							{else}
							<a  {is_acs_write} href="#" class="request" rel="start" part_id="{$part.id}">
								<img src="/skin/i/frontends/design/buttons/play.png" border="0" title="Set to play" style="cursor:pointer">
							{/if}
							</a>
						</td>
					</tr>
					{foreachelse}
					<tr{if $pid%2=='0'} class="matros"{/if}>
					<td colspan="11" align="center">No Snnipet Part Found</td>
					</tr>
					{/foreach}
					</tbody>
				<tr class="subtableheading" >
				<td colspan="11" height="2"></td>
				</tr>	
			</table>
			</div>
			</td>
		</tr>
		{foreachelse}
		<tr><td align='center' colspan='12'>No Snippet Found</td></tr>
		{/foreach}
		</tbody>
	</table>
</form>
</div>
{literal}
<script>
var multibox;
var managerClass = new Class({
	initialize: function(){
		multibox=new CeraBox( $$('.popup'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
			displayTitle: true,
			titleFormat: '{title}'
		});
		$$('.open_div').each(function(el){
			el.addEvent('click', function(e) {
				e.stop();
				if ($('part'+el.get('id_num')).getStyle('display') == 'none') {
					$('part'+el.get('id_num')).setStyle('display','inline');
					el.set({'title':'Click Here To Collapse'});
					el.getParent('tr').addClass('backcolor3');
				} else {
					$('part'+el.get('id_num')).setStyle('display','none');
					el.set({'title':'Click Here To Expand'});
					el.getParent('tr').removeClass('backcolor3');
				}
			});
		});
		$$('.request').each( function(el){
			el.addEvent('click', function(e) {
				e.stop();
				if (confirm("Are you sure to "+el.get('rel')+" this snippet?")){
					this.requestRel(el);
				}
			}.bind(this));
		}.bind(this));
	},
	requestRel: function (el) {
		this_class = this;
		var r=new Request({
			url: '{/literal}{url name="site1_snippets" action="request"}{literal}',
			onRequest: function(){
				el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/ajax-loader_new.gif','title':'Work'});
			},
			onSuccess: function(json){
				arr=JSON.decode(json);
				if ( arr == true ) {
					this_class.trueRequest(el);
				} else {
					this_class.falseRequest(el);
				}
			}		
		}).post( {'rel':el.get('rel'),'id':el.get('part_id')} );
	},
	trueRequest: function (el) {
		if ( el.get('rel') == 'pause' ) {
			el.set({'rel':'start'}).getChildren('img').set({'src':'/skin/i/frontends/design/buttons/play.png','title':'Set to play'});
		} else if ( el.get('rel') == 'start' ) {
			el.set({'rel':'pause'}).getChildren('img').set({'src':'/skin/i/frontends/design/buttons/pause.png','title':'Set to pause'});
		} else {
			el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/resume.gif'});
			$$('.replaced_'+el.get('part_id')).each( function(et) {
				et.erase('html').set({'html':'0'});
			});
			clicks_summ = 0;
			$$('.clicks_'+el.get('snip_id')).each( function(elt) {
				clicks_summ+=parseInt(elt.get('html'));
			});
			if ( clicks_summ > 0 ) {
				$$('.clicks_summ_'+el.get('snip_id')).getChildren('a')[0].set({'html':clicks_summ});
			} else {
				$$('.clicks_summ_'+el.get('snip_id'))[0].set({'html':clicks_summ});
			}
			views_summ = 0;
			$$('.views_'+el.get('snip_id')).each( function(elt) {
				views_summ+=parseInt(elt.get('html'));
			});
		$$('.views_summ_'+el.get('snip_id'))[0].set({'html':views_summ});
		}
	},
	falseRequest: function (el) {
		alert("Faled operation!");
		if ( el.get('rel') == 'pause' ) {
			el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/pause.png','title':'Set to pause'});
		} else if ( el.get('rel') == 'start' ) {
			el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/play.png','title':'Set to play'});
		} else {
			el.getChildren('img').set({'src':'/skin/i/frontends/design/buttons/resume.gif'});
		}
	}
});
window.addEvent('domready', function() {
new managerClass();
});
</script>
{/literal}
<div align="right">
{include file="../../pgg_frontend.tpl"}
</div>