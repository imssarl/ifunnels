<h4 class="page-title m-b-20">Subscriptions</h4>

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
				<input type="text" name="email" class="form-control" placeholder="Search by email" value="{$smarty.get.email}">
			</div>
		</form>
	</div>
</div>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Filter</h3>
	</div>

	<div class="panel-body">
		<form action="" method="get">
			<select name="arrFilter[membership]" class="selectpicker m-r-10">
				<option value="">- Select Membership -</option>
				{foreach from=$arrMemberships key=site_name item=memberships}
				<optgroup label="{$site_name}">
					{foreach from=$memberships item=membership}
					<option value="{$membership.id}" {if $smarty.get.arrFilter.membership == $membership.id}selected="selected"{/if}>{$membership.name}</option>
					{/foreach}
				</optgroup>
				{/foreach}
			</select>

			<select name="arrFilter[status]" class="selectpicker m-r-10">
				<option value="">- Select Status -</option>
				<option value="active" {if $smarty.get.arrFilter.status == 'active'}selected="selected"{/if}>Active</option>
				<option value="canceled" {if $smarty.get.arrFilter.status == 'canceled'}selected="selected"{/if}>Canceled</option>
			</select>

			<button type="submit" class="btn waves-effect waves-light btn-primary">Submit</button>
		</form>
	</div>
</div>

<div class="card-box">
	<div class="row">
		<div class="col-md-12">
			<div class="form-group text-right m-t-20">Showing {$arrPg.recfrom} to {$arrPg.recto} of {$arrPg.recall} entries</div>
		</div>
	</div>

	<table class="table table-striped m-b-20">
		<tr>
			<th>Email</th>
			<th>Memberships</th>
			<th>Type</th>
			<th>Status</th>
			<th>Amount</th>
			<th>Added</th>
		</tr>
		{foreach from=$arrPayments item=payment}
		{if !empty($payment.status)}
		<tr>
			<td>{$payment.customer_email}</td>
			<td><a href="{url name="site1_deliver" action="memberships_create_plan"}?site_id={$payment.site_id}&id={$payment.plan_id}" target="_blank">{$payment.membership}</a></td>
			<td>
				{if $payment.type == 1}
					{if $payment.type_payment == 0}
					<span class="label label-default">One Time</span>
					{else}
					<span class="label label-primary">Subscription</span>
					{/if}
				{else}
				<span class="label label-info">Rebill</span>
				{/if}
			</td>
			<td>
				<span 
					class="label label-{if in_array($payment.status, array('succeeded', 'active'))}success{elseif in_array($payment.status, array('trialing', 'trial'))}primary{else}danger{/if}"
					data-status="{$payment.status}">
					{if in_array($payment.status, ['succeeded', 'active'])}active
					{elseif in_array($payment.status, ['trialing', 'trial'])}trial
					{else}canceled{/if}
				</span>
			</td>
			<td>{Project_Deliver_Currency::getCode($payment.currency)}{if !empty($payment.total_amount)}{$payment.total_amount / 100}{else}{$payment.amount / 100}{/if}</td>
			<td>{date('d-m-Y H:i:s', $payment.added)}</td>
		</tr>
		{/if}
		{foreachelse}
		<tr><td colspan="6" align="center">Empty</td></tr>
		{/foreach}
	</table>

	{include file="../../pgg_backend.tpl"}
</div>