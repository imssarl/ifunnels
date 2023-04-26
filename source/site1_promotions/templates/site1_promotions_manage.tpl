{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
{if $strMsg}{include file="../../message.tpl" type='info' message="Campaign is saved"}{/if}
{foreach from=$errFlow item=strError}
{include file="../../message.tpl" type='error' message=$strError}
{/foreach}
<form action="" id="current-form" method="post">
	<table class="table  table-striped"  id="promotion">
		<thead>
		<tr>
			<th style="padding-right:0;" width="1px">
				<div class="checkbox checkbox-primary" style="margin: 0;">
					<input type="checkbox" id="del" class="tooltip" title="mass delete" rel="check to select all" />
					<label style="min-height: 14px;"></label>
				</div>
				
			</th>
			<th>Promotion url</th>
			<th align="center" width="140">Options</th>
		</tr>
		</thead>
		<tbody>
			{foreach from=$arrList key='k' item='v'}
			<tr {if $k%2=='0'} class="alt-row"{/if}{if isset($v.flg_errors)} style="background: none repeat scroll 0 0 #F3aaaa;"{/if}>
				<td style="padding-right:0;">
					<div class="checkbox checkbox-primary" style='margin: 0;'>
						<input type="checkbox" name="del[{$v.id}]" value="{$v.id}" class="check-me-del" id="check-{$v.id}" />
						<label style="min-height: 14px;"></label>
					</div>
				</td>
				<td><a href="{if stripos($v.settings.url,'://')===false}http://{/if}{$v.settings.url}" target="_blank">{$v.settings.title}</a></td>
				<td align="left">
					<a {is_acs_write} style="cursor:pointer" href="{url name='site1_promotions' action='popup'}?id={$v.id}&schedule=1" class="popup_pr" title="Schedule" ><i class="ion-pie-graph" style="font-size: 16px; vertical-align: middle; color: #6F98CE; margin: 0 5px;"></i></a>
					<a {is_acs_write} style="cursor:pointer" href="{url name='site1_promotions' action='popup'}?id={$v.id}" class="popup_pr" title="Promote Again" ><i class="ion-loop" style="font-size: 20px; vertical-align: bottom; color:#8FCA87;"></i></a>
					{*<a {is_acs_write} style="cursor:pointer" href="{url name='site1_promotions' action='popup'}?id={$v.id}&promotions=1" class="popup_pr" title="Report" ><img alt="Report" src="/skin/i/frontends/design/buttons/report.png" width="16px" height="16px" /></a>*}
					{if $v.flg_type!=0}<a style="cursor:pointer" href="{$v.id}" rel="{$v.flg_pause}" class="ajax_pause" title="{if $v.flg_pause==0}Pause{else}Resume{/if}" >{if $v.flg_pause==0}<i class="ion-ios7-pause" style="font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i>{else}<i class="ion-ios7-play" style="font-size: 20px; vertical-align: bottom; margin: 0px 5px;" title="Split test is over and a winning campaign is now running.Click here to view."></i>{/if}</a>{/if}
					{*{if isset( $v.settings.synndCampaignId)}
					<a {is_acs_write} style="cursor:pointer" href="{url name='site1_promotions' action='manage'}?id={$v.id}" title="Download CSV Report" ><img alt="Download CSV Report" src="/skin/i/frontends/design/buttons/download.png" width="16px" height="16px" /></a>
					{/if}*}
					<a {is_acs_write} href="#" rel="{$v.id}" class="click-me-del" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				</td>
			</tr>
			{/foreach}
		</tbody>
		<tfoot>
			<tr>
				<p>
					<button type="submit" id="delete" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Delete</button>
				</p>
				<td colspan="2">{include file="../../pgg_backend.tpl"}</td>
			</tr>
		</tfoot>
	</table>
</form>
</div>
{literal}
<script type="text/javascript">
var promotion_multibox={};
window.addEvent('domready',function(){
	promotion_multibox=new CeraBox( $$('.popup_pr'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	$$('.ajax_pause').each(function(el){
		el.addEvent('click', function(e) {
			e.stop();
			var flgType=e.target.getParent().get('rel');
			var campaignId=e.target.getParent().get('href');
			if(flgType==0)flgType=1;else flgType=0;
			new Request.JSON({
				url: "{/literal}{url name='site1_promotions' action='ajax_pause'}{literal}",
				onRequest: function(){
					var img=new Element( 'img[src="/skin/i/frontends/design/ajax_loader_line.gif"][id="loader"]' );
					img.inject(e.target.getParent().getParent('td'),'bottom');
				},
				onSuccess: function( returnText ){
					if( returnText==false ){
						return;
					}
					if(flgType==1){
						e.target.getParent().set('rel','1').set('title','Resume').getChildren('i').set('alt','Resume').set('class','ion-ios7-play');
					}else{
						e.target.getParent().set('rel','0').set('title','Pause').getChildren('i').set('alt','Pause').set('class','ion-ios7-pause');
					}
				},
				onComplete: function(){
					if($('loader')){
						$('loader').destroy();
					}
				},
				onError:function(){
					if($('loader')){
						$('loader').destroy();
					}
				}
			}).post({'action':flgType,'id':campaignId});
		});
	});
	$$('.click-me-del').each(function(el){
		el.addEvent('click', function(e) {
			e && e.stop();
			$('check-'+el.rel).checked = true;
			$('current-form').submit();
		});
	});
	$('del').addEvent('click',function(){
		$$('.check-me-del').each(function(el){
			el.checked = $('del').checked;
		});
	});
	$('delete').addEvent('click',function(){
		$('current-form').submit();
	});
});
</script>
{/literal}