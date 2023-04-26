<h4 class="page-title m-b-20">
	Memberships for <span class="label label-default">{$siteData.name}</span>
	{if $flg_add}
	<a href="{url name='site1_deliver' action='memberships_create_plan'}?site_id={$siteData.id}" class="btn btn-default btn-rounded waves-effect waves-light m-l-15">
		<span class="btn-label">
			<i class="fa fa-plus"></i>
		</span>
		Add new Membership
	</a>
	{/if}
</h4>

<div class="card-box">
	<div class="form-group">
		{if ! empty( $errors )}
			{foreach from=$errors item=error}
			<div class="alert alert-{$error.label}">
				<strong class="text-capitalize">{$error.label}!</strong> {$error.message}
			</div>
			{/foreach}
		{/if}
	</div>

	<div class="form-group">
		<table class="table table-striped">
			<tr>
				<th>Name</th>
				<th>Type product</th>
				<th>Membership Home Page URL</th>
				<th>Added</th>
				<th>Edited</th>
				<th>Options</th>
			</tr>
			{foreach from=$arrMemberships item=membership}
			<tr>
				<td>{$membership.name}</td>
				<td>{if $membership.type == 1}<span class="label label-primary">Paid</span>{else}<span class="label label-default">Free</span>{/if}</td>
				<td>{$membership.home_page_url}</td>
				<td>{date( 'd-m-Y', $membership.added )}</td>
				<td>{date( 'd-m-Y', $membership.edited )}</td>
				<td>
					<a href="{url name='site1_deliver' action='memberships_create_plan'}?site_id={$siteData.id}&id={$membership.id}" title="Edit Membership"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a> 
					<a href="?delete={$membership.id}" class="delete" title="Delete Membership"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
					<a href="{url name='site1_deliver' action='webhook'}?mid={$membership.id}" title="Webhook"><i class="ion-ios7-gear m-l-5 m-r-5 text-custom" style="font-size: 20px; vertical-align: middle;"></i></a>
					{if Core_Acs::haveAccess( [ 'Automate' ] ) && $membership.enable_automate === '1'}
					<a href="{url name='site1_deliver' action='automate'}?mid={$membership.id}" title="Automate"><i class="ti-exchange-vertical m-r-5 text-warning" style="font-size: 17px; vertical-align: middle;"></i></a>
					{/if}
				</td>
			</tr>
			{foreachelse}
			<tr>
				<td align="center" colspan="5">Empty</td>
			</tr>
			{/foreach}
		</table>

		{include file="../../pgg_backend.tpl"}
	</div>
</div>