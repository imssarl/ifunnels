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
		<h3>Domains you host externally</h3>
	</div>
	<div class="content-box-content">
		<div class="tab-content default-tab">
			{if Project_Acs_Hosting::haveAccess(Project_Acs_Hosting::REMOTE_ID)}
				<a href="{url name='site1_hosting' action='addomain'}?flg_type=0" class="popup btn btn-success waves-effect waves-light" title="Add new domain" >Add new domain</a>
				<table class="table  table-striped">
					<thead>
						<tr>
							<th>Domain</th>
							<th>Host with us</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
					{foreach from=$arrList item=i}
					{if $i.flg_type==Project_Placement::REMOTE_HOSTING}
					{assign var=f value=$f+1}
					<tr {if $f%2=='0'} class="alt-row"{/if}>
						<td>{$i.domain_ftp}</td>
						<td align="center"><a href="?set={$i.id}">set</a></td>
						<td width="100">
							<a class="popup" title="Edit domain" href="{url name='site1_hosting' action='addomain'}?flg_type=0&id={$i.id}"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
							<a href="?del={$i.id}" confirm='Delete domain?' class="confirm-delete" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
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
var poup={};
window.addEvent('domready',function(){
	var optTips = new Tips('.Tips', {className: 'tips'});
	$$('.Tips').each(function(a){
		a.addEvent('click', function(e){
			if ( e.get('href') != null )
				e.stop()
		})
	});
	popup=new CeraBox( $$('.popup'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}