<h3>{$arrPrm.title}</h3>
<div class="card-box">
	<div class="row">
		<div class="col-md-2 col-md-offset-10 text-right m-b-20">
			<button type="button" data-view="list" class="btn btn-icon {if $smarty.cookies.view == 'list' || empty($smarty.cookies.view)}btn-default{/if} waves-effect waves-light">
				<i class="md md-view-stream"></i>
			</button>
			<button type="button" data-view="grid" class="btn btn-icon {if $smarty.cookies.view == 'grid'}btn-default{/if} waves-effect waves-light">
				<i class="md md-view-module"></i>
			</button>
		</div>
		{if $smarty.cookies.view == 'list' || empty($smarty.cookies.view)}
		<div class="col-md-12">
			<table class="table table-striped">
				<tr>
					<th>Sites name</th>
					<th>URL</th>
					<th>Screenshot</th>
					<th>Added</th>
					<th>Visitors</th>
					<th>Options</th>
				</tr>
				{foreach from=$arrEcom item=site}
				<tr>
					<td>{$site.sites_name}</td>
					<td>{if !empty($site.url)}<a href="https:{str_replace(array('http:','https:'),'',$site.url)}" target="_blank" rel="noopener noreferrer">https:{str_replace(array('http:','https:'),'',$site.url)}</a>{else}<span
						class="label label-default">Not Published</span>{/if}</td>
					<td><img src="{Zend_Registry::get('config')->path->html->pagebuilder}{$site.sitethumb}" class="img-responsive" style="max-width: 100px; max-height: 100px;"></td>
					<td>{date('Y-m-d', $site.sites_created_on)}</td>
					<td>{if $site.visitors > 0}<span class="badge badge-primary">{$site.visitors}</span>{else}<span class="badge badge-warning">0</span>{/if}</td>
					<td>
						{if Core_Acs::haveAccess( array('iFunnels LTD Studio Pro', 'iFunnels LTD Studio Growth', 'iFunnels LTD Studio Enterprise') )}<a href="{Zend_Registry::get('config')->domain->url}{url name='site1_ecom_funnels' action='share'}?ecom={Core_Payment_Encode::encode( array( $site.id ) )}" class="clipboard_copy" data-siteid="{$site.id}" data-sitename="{$site.sites_name}"><input type="text" style="display:none;" id="clipboard_copy_{$site.id}" value="{Zend_Registry::get('config')->domain->url}{url name='site1_ecom_funnels' action='share'}?ecom={Core_Payment_Encode::encode( array( $site.id ) )}" /><i class="ion-share" style="font-size: 18px; vertical-align: bottom; color: #2929FC; margin: 0 5px;"></i></a>{/if}
						<a href="{url name='site1_ecom_funnels' action='create'}?id={$site.id}&p=index"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
						<a href="?duplicate={$site.id}" class="duplicate"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></a>
						{if !empty($site.url)}
						<a href="{url name="site1_ecom_funnels" action="reporting"}?id={$site.id}" class="download" target="_blank" title="Report"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
						{/if}
						<a href="?delete={$site.id}" class="delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
					</td>
				</tr>
				{foreachelse}
				<tr>
					<td colspan="6" align="center">Empty</td>
				</tr>
				{/foreach}
			</table>
		</div>
		{else}
		{foreach from=$arrEcom item=site}
		<div class="col-md-4">
			<div class="thumbnail">
				<img src="{Zend_Registry::get('config')->path->html->pagebuilder}{$site.sitethumb}" class="img-responsive">
				<div class="caption">
					<h3>{$site.sites_name}</h3>
					<p>Create at: {date('Y-m-d', $site.sites_created_on)}</p>
					<p>
						{if !empty($site.url)}<a href="https:{str_replace(array('http:','https:'),'',$site.url)}" target="_blank" class="btn btn-primary waves-effect waves-light m-r-5"><i class="md md-remove-red-eye"></i> VIEW</a>{/if}
						<a href="{url name='site1_ecom_funnels' action='create'}?id={$site.id}" class="btn btn-default waves-effect waves-light m-r-5"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i> EDIT</a>
						<a href="?dublicate={$site.id}" class="btn btn-default waves-effect waves-light"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i> DUBLICATE</a>
						{if !empty($site.url)}
						<a href="{url name="site1_ecom_funnels" action="reporting"}?id={$site.id}" class="btn btn-default waves-effect waves-light"><i class="ion-stats-bars" style="font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i> REPORT</a>
						{/if}
						<a href="?delete={$site.id}" class="btn btn-default waves-effect waves-light"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i> DELETE</a>
					</p>
				</div>
			</div>
		</div>
		{/foreach}
		{/if}
	</div>
	<div class="row">
		{include file="../../pgg_backend.tpl"}
	</div>
</div>
<script src="/skin/light/plugins/js-cookie/src/js.cookie.js"></script>


<script src="/skin/light/js/jquery.min.js"></script>

<script src="/skin/light/plugins/notifyjs/dist/notify.min.js"></script>
<script src="/skin/light/plugins/notifications/notify-metro.js"></script>


{literal}
<script>
	jQuery(document).ready(function(){
		jQuery('[data-view]').on('click', function(){
			Cookies.set('view', jQuery(this).data('view'), { expires: 3650 } );
			window.location.reload();
			return false;
		});
		
		jQuery('.clipboard_copy').click( function(event){
			event.stopPropagation();
			var copyText=document.getElementById( 'clipboard_copy_'+jQuery(event.target).parent().attr('data-siteid') );
			copyText.show();
			copyText.select();
			copyText.setSelectionRange(0, 99999);
			document.execCommand("copy");
			copyText.hide();
			try{
				$.Notification.notify('success','top', jQuery(event.target).parent().attr('data-sitename'), 'Your Share Link has been copied to Clipboard. Paste it and share if you like.');
			}catch(e){
				console.log( e );
			}
			return false;
		});
	});
</script>
{/literal}