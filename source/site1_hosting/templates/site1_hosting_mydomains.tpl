<link rel="stylesheet" href="/skin/site/dist/css/domains.bundle.css" />
<h2>Domains & Hosting</h2>
<p id="page-intro"></p>
{if $view_message}
{include file='../../message.tpl' type='warning' message='To get started, change the DNS for this domain at your registrar. If you don\'t know how to do it, please contact them and tell them to update your DNS to the following:<br/>
	<br/>
	DNS1: {Project_Placement_Domen_Availability::$_NS1}<br/>
	DNS2: {Project_Placement_Domen_Availability::$_NS2}<br/>
	<br/>
	For domains registered through Namecheap, please follow this <a href="http://www.namecheap.com/support/knowledgebase/article.aspx/767/10/how-can-i-change-the-nameservers-for-my-domain">online tutorial</a> to change the nameservers.<br/>'}
{/if}
<div class="content-box card-box">
	<div class="content-box-header">
		<h3>Domains hosted with us</h3>
	</div>

	<div class="content-box-content">
		<div class="tab-content default-tab">
			{include file='../../error.tpl'}
			{if Project_Acs_Hosting::haveAccess(Project_Acs_Hosting::LOCAL_ID)}
				{if Core_Acs::haveRight( ['site1_hosting'=>['addomain']] )}
				<a href="{url name='site1_hosting' action='addomain'}?flg_type=1" class="popup btn btn-success waves-effect waves-light" title="Add new domain" >Add new domain</a>
				{/if}
				<table class="table  table-striped">
					<thead>
						<tr>
							<th>Domain</th>
							<th>Auto.&nbsp;Renewal</th>
							<th>Status</th>
							<th>Added</th>
							<th>Expiry</th>
							<th width="100">Action</th>
						</tr>
					</thead>

					<tbody>
					{foreach from=$arrList item=i}
					{if $i.flg_type==Project_Placement::LOCAL_HOSTING||$i.flg_type==Project_Placement::LOCAL_HOSTING_DOMEN||$i.flg_type==Project_Placement::IFUNELS_HOSTING||$i.flg_type==Project_Placement::LOCAL_HOSTING_SUBDOMEN}
					{assign var=k value=$k+1}
					<tr {if $k%2=='0'} class="alt-row"{/if}>
						<td{if $i.expiry_domain != 0}
							{if $i.expiry_domain+25*24*60*60 <= time()} style="color:#cccccc;"{/if}
							{if $i.expiry_domain+25*24*60*60 >= time() && time() >= $i.expiry_domain } style="color:#ff0000;"{/if}
						{/if}>{$i.domain_http}</td>
						<td align="center">
						{if $i.flg_type==Project_Placement::LOCAL_HOSTING_DOMEN}
							{if $i.expiry_domain == 0}
							{else}
								{if $i.flg_auto==1}
									<a href="?flg_auto=0&id={$i.id}">Turn Off</a>
								{else}
									<a href="?flg_auto=1&id={$i.id}">Turn On</a>
								{/if}
							{/if}
						{/if}</td>
						<td align="center">{if $i.flg_checked==Project_Placement_Domen_Availability::AVAILABLE}<span class="grn">available</span>{elseif $i.flg_checked==Project_Placement_Domen_Availability::NOT_VERIEFIED}<span class="red cursor-help Tips" title="Please make sure DNS were propery set for your domain.">not verified</span>{elseif $i.flg_checked==Project_Placement_Domen_Availability::IMPORTED}<span class="green cursor-help Tips" title="Domain is registered and we're checking DNS transfer to CNM Hosting.<br/> In the meantime, you can generate websites on this domain, even<br/>  though there might be some delay before you can browse them from your location.">imported</span>{/if}</td>
						<td align="center">{$i.added|date_format:$config->date_time->dt_full_format}</td>
						<td align="center">{if $i.flg_type==3||$i.flg_type==4}Not Applicable{else}{if $i.expiry_domain != 0}{$i.expiry_domain|date_format:$config->date_time->dt_full_format}{else}{if $i.flg_type==1 && $i.expiry_hosting == 0}Free{else}External{/if} Hosting{/if}{/if}</td>
						<td>
							{if Core_Acs::haveAccess( array( 'iFunnels Studio Performance' ) ) && count(explode( '.', $i.domain_http ))==2 }
							<a href="{url name='site1_hosting' action='addomain'}?subdomain={$i.id}&flg_type=4" title="Add subdomain" class="popup"><i class="ion-ios7-folder-outline" style="font-size: 20px; vertical-align: bottom; color: #22AC11; margin: 0 5px;"></i></a>
							{/if}
							<a href="?del={$i.id}" confirm='Delete domain?' class="confirm-delete" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
							{if isset( $i.flgSslCertificate ) && $i.flgSslCertificate === true}
							<a href="?ssl={$i.id}" class="confirm-ssl {if $i.flg_ssl == '1'}disabled{/if}" title="Install SSL"><i class="fa fa-expeditedssl text-primary" style="font-size: 18px; vertical-align: bottom; margin: 0 5px;"></i></a>
							{/if}
							{if $i.expiry_domain != 0}
								{if time() < $i.expiry_domain }
									<a href="?renew={$i.id}" class="confirm-delete" confirm='Renew domain?' title="Renew domain">
										<i class="ion-arrow-return-left" style="transform: rotate(-90deg); font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i>
										<!--<img src="/skin/i/frontends/design/buttons/resume.gif" alt="Renew" />-->
									</a>
								{/if}
								{if $i.expiry_domain+25*24*60*60 >= time() && time() >= $i.expiry_domain }
									<a href="?reactivate={$i.id}" class="confirm-delete" confirm='Reactivate domain?' title="Reactivate domain">
										<i class="ion-refresh" style="font-size: 20px; color: green;"></i>
										<!--<img src="/skin/i/frontends/design/buttons/arrow_refresh.png" alt="Reactivate" />-->
									</a>
								{/if}
							{/if}
						</td>
					</tr>
					{/if}
					{/foreach}
					</tbody>
				</table>
			{/if}
		</div>
	</div>
</div>

{literal}
<script type="text/javascript">
var poup = {};
window.addEvent('domready', function() {
	var optTips = new Tips('.Tips', { className: 'tips' });
	$$('.Tips').each( function(a) {
		a.addEvent('click', function(e) {
			if (e.get('href') != null)
				e.stop()
		})
	});

	popup = new CeraBox( $$('.popup'), {
		group: false,
		width: '{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height: '{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}

<script src="/skin/site/dist/js/domains.bundle.js"></script>