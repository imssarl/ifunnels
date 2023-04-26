<link rel="stylesheet" href="/skin/ifunnels-studio/dist/css/member.bundle.css" />

<h4 class="page-title m-b-20">
	Members
	<a href="" data-show-modal class="btn btn-default btn-rounded waves-effect waves-light m-l-15">
		<span class="btn-label">
			<i class="fa fa-plus"></i>
		</span>
		Add new Member
	</a>
</h4>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Search</h3>
	</div>

	<div class="panel-body">
		<form action="" method="get">
			<div class="input-group">
				<span class="input-group-btn">
					<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
				</span>
				<input type="text" name="email" class="form-control" placeholder="Search by email:" value="{$smarty.get.email}">
			</div>
		</form>
	</div>
</div>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Filters</h3>
	</div>

	<div class="panel-body">
		<form action="" method="get">
			<select name="filter[membership_pay_id]" class="btn-group selectpicker pull-left m-r-10">
				<option value="">- Select Membership -</option>
				{foreach from=$arrMemberships item=membership}
				<option value="{$membership.id}" {if $smarty.get.filter.membership_pay_id == $membership.id}selected="selected"{/if}>[{$membership.site_name}] {$membership.name}</option>
				{/foreach}
			</select>

			<div class="pull-left m-r-10">
				<button type="submit" class="btn btn-default waves-effect waves-light pull-left" id="filter">Filter</button>
			</div>
		</form>
	</div>
</div>

<div class="card-box">
	<style>.btn-group { display: inline-block !important;}</style>

	<div class="row">
		<div class="col-md-6 col-md-offset-6 text-right m-b-10">
			<div class="">Showing {$arrPg.recfrom} to {$arrPg.recto} of {$arrPg.recall} entries</div>
		</div>
	</div>

	<table class="table table-striped">
		<tr>
			<th>Email</th>
			<th>Memberships</th>
			<th width="150">Added</th>
			<th>Option</th>
		</tr>
		{foreach from=$arrMembers item=member}
		{if ! empty($member.arrPlans)}
		<tr>
			<td>{$member.email}</td>
			<td>
				{if ! empty( $member.arrPlans )}
				{foreach from=$member.arrPlans item=plan}
					<div class="btn-group" style="display: inline-block !important;">
						<button type="button" class="btn {if $plan.type == '0'}btn-primary{else}btn-default{/if} dropdown-toggle waves-effect waves-light btn-xs" data-toggle="dropdown" aria-expanded="false">
							<strong>[{$plan.site_name}] {$plan.name}</strong> <span class="caret"></span>
						</button>

						<ul class="dropdown-menu" role="menu">
							<li><a href="#" data-remove data-membership-id="{$plan.id}" data-mid="{$member.id}">Remove from membership</a></li>
							{if $plan.frequency == '1'}
								{if ! empty( $plan.status ) && in_array( $plan.status, array( 'active', 'trial', 'succeeded' ) )}
								<li><a href="#" data-subsciption-id="{$plan.subscription_id}" data-membership-id="{$plan.id}" data-payment-id="{$plan.payment_id}" data-unsubscribe="">Unsubscribe</a></li>
								{/if}
							{/if}
						</ul>
					</div>
				{/foreach}
				{else}
				-
				{/if}
			</td>
			<td>{date('d-m-Y', $member.added)}</td>
			<td style="display: flex; align-items: center;">
				{if Core_Acs::haveAccess( [ 'email test group' ] )}
				<a href="?delete={$member.id}" class="delete m-l-5 m-r-5" title="Delete this user"><i class="ion-trash-a text-danger" style="font-size: 20px;"></i></a>
				{/if}
				<a href="#" data-resend="" data-mid="{$member.id}" title="Resend login details" class="m-l-5 m-r-5"><i class="md md-sync text-custom" style="font-size: 18px;"></i></a>
				<a href="#" data-set-password="" data-mid="{$member.id}" title="Set password" class="m-l-5 m-r-5"><i class="md md-vpn-key text-warning" style="font-size: 18px;"></i></a>
				<a href="#" data-add="" data-added='{json_encode( array_unique( array_column( $member.arrPlans, "id" ) ) )}' data-mid="{$member.id}" title="Add member to another membership" class="m-l-5 m-r-5"><i class="md md-add-circle text-primary" style="font-size: 18px;"></i></a>
			</td>
		</tr>
		{/if}
		{foreachelse}
		<tr><td colspan="5" align="center">Empty</td></tr>
		{/foreach}
	</table>

	{include file="../../pgg_backend.tpl"}
</div>

<script>
	var ajaxURL = '{url name="site1_deliver" action="request"}';
	var membershipList = {json_encode( $arrMemberships )};
</script>

<script src="/skin/ifunnels-studio/dist/js/member.bundle.js"></script>

<div class="modal micromodal-slide" id="add-new-member" aria-hidden="true">
    <div class="modal__overlay" tabindex="-1">
      	<div class="modal__container" role="dialog" aria-modal="true" aria-labelledby="modal-1-title">
			<header class="modal__header">
				<h2 class="modal__title" id="modal-1-title">
					Add New Member
				</h2>
				
				<button class="modal__close" aria-label="Close modal" data-micromodal-close></button>
			</header>
	   
			<main class="modal__content" id="modal-1-content">
				<div class="alerts"></div>
				
				<div class="form-group">
					<label class="control-label">Enter Email <span class="text-danger">*</span></label>
					<input type="text" name="email"s class="form-control" placeholder="Enter Email" />

					<div class="text-danger"><small>asd</small></div>
				</div>

				<div class="form-group">
					<label class="control-label">Membership <span class="text-danger">*</span></label>
					
					<select name="membership" class="selectpicker m-l-15">
						<option value="">-- select --</option>
						{foreach from=$arrMembershipsGroup key=group item=memberships}
						<optgroup label="{$group}">
							{foreach from=$memberships item=m}
							<option value="{$m.id}">{$m.name}</option>
							{/foreach}
						</optgroup>
						{/foreach}
					</select>

					<div class="text-danger"><small>asd</small></div>
				</div>
			</main>
		
			<footer class="modal__footer text-right">
				<button class="btn btn-primary waves-effect waves-light" id="add-member">Save</button>
				<button class="btn waves-effect waves-light" data-micromodal-close aria-label="Close this dialog window">Close</button>
        	</footer>
      	</div>
    </div>
</div>
