<div class="content-box-header">
	<h3>{$arrPrm.title}</h3>
</div>

{if $msg !== true}
{foreach from=$msg item=m}
<div class="alert alert-danger m-b-20">
	<strong>Warning!</strong> {$m}
</div>
{/foreach}
{/if}

<div class="card-box">
	<div class="form-group">
		<a href="https://help.ifunnels.com/collection/47-email-funnels" target="_blank" class="btn btn-info btn-rounded waves-effect waves-light">
			<span class="btn-label"><i class="fa fa-exclamation"></i></span>Getting Started: watch the video tutorials here
		</a>
	</div>
	<div class="form-group">
		<a href="{url name='email_funnels' action='frontend_settings_set'}" class="btn btn-default waves-effect waves-light popup_mb">Add new SMTP integration</a>
	</div>

	<table class="table table-striped">
		<thead>
			<tr>
				<th width="60%">Title</th>
				<th width="10%">Activate</th>
				<th width="10%">Edited</th>
				<th width="10%">Added</th>
				<th width="10%">Options</th>
			</tr>
		</thead>
		<tbody>
			{if !empty($arrData)}
			<tr><td colspan="6">{include file="../../pgg_backend.tpl"}</td></tr>
			{/if}
			{foreach $arrData as $item}
			<tr{if ($item@iteration-1) is div by 2} class="matros"{/if}>
				<td><a href="{url name='email_funnels' action='frontend_settings_set' wg="id={$item.id}"}" class="popup_mb">{$item.title}</a></td>
				<td>
					{if $item.flg_active=='1'}
						<a href="?flg_active=0&id={$item.id}" class="label label-success">ACTIVE</a>
					{else}
						<a href="?flg_active=1&id={$item.id}" class="label label-warning">INACTIVE</a>
					{/if}
				</td>
				<td>{$item.edited|date_local:$config->date_time->dt_full_format}</td>
				<td>{$item.added|date_local:$config->date_time->dt_full_format}</td>
				<td class="option">
					<a href="{url name='email_funnels' action='frontend_settings_set' wg="id={$item.id}"}" class="popup_mb"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a> <a href="{url name='email_funnels' action='frontend_settings' wg="delete={$item.id}"}" class="resend"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				</td>
			</tr>
			{foreachelse}
			<tr class="matros"><td colspan="6" style="text-align: center;">Empty</td></tr>
			{/foreach}
			{if !empty($arrData)}
			<tr><td colspan="6">{include file="../../pgg_backend.tpl"}</td></tr>
			{/if}
		</tbody>
	</table>
</div>

{literal}
<script type="text/javascript">
var multibox;
window.addEvent('domready', function(){
	multibox=new CeraBox( $$('.popup_mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}