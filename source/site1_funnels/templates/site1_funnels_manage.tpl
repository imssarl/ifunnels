{if $error=='delete'}
{include file='../../message.tpl' type='error' message="Can't delete project."}
{/if}
{if $msg=='success'}
{include file='../../message.tpl' type='success' message="Project was deleted."}
{/if}

{if $generatedLink!=''}
<div class="alert alert-success alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
	<div>Generated link is <a href="{$generatedLink}" target="_blank" >{$generatedLink}</a></div>
</div>
{/if}

{if $arrList}
<div class="card-box col-md-12">
	<table class="table table-striped">
	<thead>
		<tr>
			<th style="width:250px;" colspan="2">Url{include file="../../ord_frontend.tpl" field='d.url'}</th>
			<th>Screenshot</th>
			<th>Edited{include file="../../ord_frontend.tpl" field='d.edited'}</th>
			<th>Added{include file="../../ord_frontend.tpl" field='d.added'}</th>
			<th style="width: 83px;">Visitors{include file="../../ord_frontend.tpl" field='c.visitors'}</th>
			<th style="width: 118px;">Subscribers{include file="../../ord_frontend.tpl" field='v.subscribers'}</th>
			<th>Conversion Rate{include file="../../ord_frontend.tpl" field='cv.crt'}</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
		{foreach $arrList as $v}
		<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
			<td>
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="splitTest[]" value="{$v.id}">
					<label></label>
				</div>
			</td>
			<td>{if empty($v.url)}no url{else}<a href="{$v.url}" target="_blank">{$v.url|wordwrap:36:'<br/>':true}</a>{/if}{if !empty($v.tags)}<p class="tags">{$v.tags}</p>{/if}</td>
			<td style="text-align:center;vertical-align: middle;">
				{if is_file( $v.image )}
				<img src="{img src=$v.image w=95 h=60}" data-img="{$v.image}" data-imgh="{is_file( $v.image )}" />
				{else}{if !empty($v.url)}
				<img src="/skin/i/frontends/design/ajax_loader_line.gif" data-url="{$v.url}" class="updatescreenshots" />
				{/if}{/if}
			</td>
			<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
			<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
			<td style="text-align:center;">{$v.visitors}</td>
			<td style="text-align:center;">{$v.clicks}</td>
			<td style="text-align:center;">{$v.rate}</td>
			<td class="option">
				<a href="{url name='site1_funnels' action='create'}?id={$v.id}"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a> 
				<a href="{url}?download={$v.id}" class="download" target="_blank" title="Download"><i class="ion-ios7-download" style="color: #81c868; font-size: 21px; vertical-align: bottom;"></i></a>
				<a href="{url name='site1_funnels' action='dashboard'}?id={$v.id}" class="download" target="_blank" title="Report"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i>
				{if !empty($v.url)}<a href="#urls{$v.id}" class="popup" title="Get URLs"><i class="ion-link" style="font-size: 20px; vertical-align: middle; color: #5d9cec;"></i></a>
				<div style="display: none;">
					<div id="urls{$v.id}" class="popup-block">
						<b>Direct URL:</b><br/>
						{$v.url}<br/><br/><br/>
						<b>Pre-pop URL:</b><br/>
						{$v.url}?email=emailaddress<br/><br/>
						<b>Maropost:</b> {$v.url}?email={literal}{{contact.email}}{/literal}<br/><br/>
						<b>Aweber:</b> {$v.url}?email={literal}{!email}{/literal}<br/><br/>
						<b>Getresponse:</b> {$v.url}?email=[[email]]<br/><br/>
						<b>Mailchimp/Mandrill:</b> {$v.url}?email=*|EMAIL|*<br/><br/>
						<b>iContact:</b> {$v.url}?email=[email]<br/><br/>
						<b>Infusionsoft:</b> {$v.url}?email=~Contact.Email~<br/><br/>
						<b>Office AUtopilot:</b> {$v.url}?email=[E-Mail]<br/><br/>
						<b>Ontraport:</b> {$v.url}?email=[E-Mail]<br/><br/><br/>
						<b>One-click URL:</b><br/>
						{$v.url}?email=emailaddress&amp;auto=1<br/><br/>
						<b>Maropost:</b> {$v.url}?email={literal}{{contact.email}}{/literal}&amp;auto=1<br/><br/>
						<b>Aweber:</b> {$v.url}?email={literal}{!email}{/literal}&amp;auto=1<br/><br/>
						<b>Getresponse:</b> {$v.url}?email=[[email]]&amp;auto=1<br/><br/>
						<b>Mailchimp/Mandrill:</b> {$v.url}?email=*|EMAIL|*&amp;auto=1<br/><br/>
						<b>iContact:</b> {$v.url}?email=[email]&amp;auto=1<br/><br/>
						<b>Infusionsoft:</b> {$v.url}?email=~Contact.Email~&amp;auto=1<br/><br/>
						<b>Office AUtopilot:</b> {$v.url}?email=[E-Mail]&amp;auto=1<br/><br/>
						<b>Ontraport:</b> {$v.url}?email=[E-Mail]&amp;auto=1<br/><br/>
						<div class="clear"></div>
					</div>
				</div>
				{/if}
			</td>
		</tr>
		{/foreach}
	</tbody>
	</table>
	{include file="../../pgg_backend.tpl"}
</div>
{else}
<div class="card-box col-md-12">No items found</div>
{/if}
{literal}
<script>
var multibox;
var managerClass = new Class({
	initialize: function(){
		if( $$('.popup') !== null ){
			multibox=new CeraBox( $$('.popup'), {
				group: false,
				width:'950px',
				height:'620px',
				displayTitle: true,
				titleFormat: '{title}'
			});
		}
	}
});
window.addEvent('domready', function() {
	new managerClass();
	
	jQuery('.updatescreenshots').each(function(ekey, elmt){
		var r=new Request({
			url:'{/literal}{url name="site1_funnels" action="create"}{literal}',
			onSuccess: function(json){
				data=JSON.decode(json);
				if( data.return != 'false' ){
					jQuery(elmt).removeClass('updatescreenshots');
					jQuery(elmt).attr('src', data.responseData.results[0].url);
					jQuery(elmt).attr('width', '95px');
					jQuery(elmt).attr('height', '60px');
				}
				console.log( json );
			}
		}).post({'name': 'link','value': jQuery(elmt).attr('data-url') });
	});
});
</script>
{/literal}