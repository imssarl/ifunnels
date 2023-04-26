{if $error=='delete'}
{include file='../../message.tpl' type='error' message="Can't delete project."}
{/if}
{if $msg=='success'}
{include file='../../message.tpl' type='success' message="Project was deleted."}
{/if}


<div class="col-md-12">
	<div class="row">
		<form method="get" class="form-horizontal">
			<div class="form-group">
				<!--<label class="col-md-2 control-label text-left">Search by tags:</label>-->
				<div class="col-md-8">
					<div class="input-group">
	                    <span class="input-group-btn">
	                    	<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
	                    </span>
	                    <input type="text" name="search" class="form-control" placeholder="Search by tags:" value="{$arrFilter.searchTags}">
	                </div>
				</div>
				{if Core_Users::$info['id'] == 1 || Core_Users::$info['id'] == 39180}
				<div class="col-md-8">
					<div class="input-group">
	                    <span class="input-group-btn">
	                    	<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
	                    </span>
	                    <input type="text" name="url" class="form-control" placeholder="Search by URL:" value="{$arrFilter.url}">
	                </div>
				</div>
				{/if}
			</div>
			
		</form>
	</div>
</div>
{if $arrList}
<div class="col-md-12">
	<div class="row">
		<div class="form-group">
			<button type="button" id="add_exist" class="btn btn-default waves-effect waves-light disabled">Add to existing split testing campaign</button>
			<form action="{url name='site1_squeeze' action='create_split'}" style="display: inline-block;">
				<input type="hidden" name="company_id" value="">
				<button type="submit" id="create_new" class="btn btn-success waves-effect waves-light disabled">Create new split test</button>
			</form>
		</div>

		<div class="form-group" id="exist-splittest" style="display: none;">
			<form method="post" action="">
				<input type="hidden" name="company_id" value="">
				<select class="btn-group selectpicker show-tick" name="split">
					{foreach $arrSplit as $v}
					<option value="{$v.id}">{$v.title}</option>
					{/foreach}
				</select>
				<button type="submit" class="btn btn-default waves-effect waves-light">Add</button>	
			</form>
		</div>
	</div>
</div>

<div class="card-box col-md-12">
	<table class="table table-striped">
	<thead>
		<tr>
			<th style="width:250px;" colspan="2">Url{include file="../../ord_frontend.tpl" field='d.url'}
			{if Core_Acs::haveAccess( array( 'LPB Admins' ) )}
			{if $arrFilter.where!="flg_template-1"}
			<button type="button" class="btn btn-success btn-rounded waves-effect waves-light" onclick="window.location='{url name=$arrPrm.name action=$arrPrm.action wg='where=flg_template-1'}';">Show Only Templates</button>
			{else}
			<input type="button" class="button" value="Show All Campaigns"  onclick="window.location='{url name=$arrPrm.name action=$arrPrm.action}';">
			{/if}
			{/if}
			</th>
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
		<!--<tr>
			<td colspan="8">{include file="../../pgg_backend.tpl"}</td>
		</tr>-->
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
				<a href="{url name='site1_squeeze' action='customization'}?id={$v.id}"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a> 
				<a href="{url}?duplicate={$v.id}" class="duplicate"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></a>
				{if $flgHaveVisitors}<a href="{url}?reset_stats={$v.id}" class="reset">Reset Stats</a>{/if}
				<a href="{url}?delete={$v.id}" class="delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				<a href="{url}?download={$v.id}" class="download" target="_blank" title="Download"><i class="ion-ios7-download" style="color: #81c868; font-size: 21px; vertical-align: bottom;"></i></a>
				<a href="{url name='site1_squeeze' action='reporting'}?id={$v.id}" class="download" target="_blank" title="Report"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>

				{if strpos($v.url, 'onlinenewsletters.net')===false && strpos($v.url, 'consumertips.net')===false}
				<a href="{url}?hosting={$v.id}" class="1_click_hosting" title="1-click&nbsp;Hosting&nbsp;SSL"><i class="ion-locked"></i></a>
					{if Core_Acs::haveAccess( array( 'email test group', 'LPS Professional' ) )}
				<a href="{url}?hosting_nossl={$v.id}" class="1_click_hosting" title="1-click NON SSL"><i class="ion-unlocked"></i></a>
					{/if}
				{/if}
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
				{/if}{if Core_Acs::haveAccess( array( 'email test group', 'LPS Entrepreneur', 'LPS Professional' ) )}<a href="#export{$v.id}" class="popup" title="Export Page"><i class="ion-android-storage" style="color: #ffbd4a; margin: 0 5px;"></i></a>
				<div style="display: none;">
					<div id="export{$v.id}" class="popup-block">
						<b>Export ID: {$v.export_id}
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
});
</script>
<script type="text/javascript">
	jQuery(document).ready(function(){
		var ids = [];
		jQuery('input[name="splitTest[]"]').change(function(){
			ids = [];
			if(jQuery('input[name="splitTest[]"]:checked').size() > 0) {
				jQuery('#add_exist').removeClass('disabled');
			}else{
				jQuery('#add_exist').addClass('disabled');
			}
			if(jQuery('input[name="splitTest[]"]:checked').size() > 1) {
				jQuery('#create_new').removeClass('disabled');
			} else {
				jQuery('#create_new').addClass('disabled');
			}
			jQuery('input[name="splitTest[]"]:checked').each(function(){
				ids.push(jQuery(this).val());
			});
			jQuery('input[name="company_id"]').attr('value', ids.join());
		});

		jQuery('#add_exist').click(function(){
			if(!jQuery(this).hasClass('disabled'))
				jQuery('#exist-splittest').stop(true, true).slideToggle('fast');
		});
		jQuery('#create_new').click(function(){
			if(jQuery(this).hasClass('disabled'))
				return false;
		});
		
		jQuery('.updatescreenshots').each(function(ekey, elmt){
			var r=new Request({
				url:'{/literal}{url name="site1_squeeze" action="customization"}{literal}',
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