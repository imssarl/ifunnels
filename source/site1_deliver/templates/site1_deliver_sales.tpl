<h4 class="page-title m-b-20">Sales</h4>

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

<div class="card-box">
	<div class="row">
        <div class="col-md-6">
            <div class="form-group" style="display: flex; align-items: center;">
				Show
				<form class="">
					<select name="arrFilter[show]" class="selectpicker m-l-10 w-auto">
						<option value="all" {if $smarty.get.arrFilter.show == 'all'}selected="selected"{/if}>All</option>
						<option value="only_rebills" {if $smarty.get.arrFilter.show == 'only_rebills'}selected="selected"{/if}>Only Rebills</option>
						<option value="only_payments" {if $smarty.get.arrFilter.show == 'only_payments'}selected="selected"{/if}>Only Payments</option>
					</select>

					<select name="arrFilter[transactions]" class="selectpicker m-l-10 w-auto">
						<option value="all" {if $smarty.get.arrFilter.transactions == 'all'}selected="selected"{/if}>All Transactions</option>
						<option value="failed" {if $smarty.get.arrFilter.transactions == 'failed'}selected="selected"{/if}>Failed Transactions</option>
						<option value="successful" {if $smarty.get.arrFilter.transactions == 'successful'}selected="successful"{/if}>Successful Transactions</option>
					</select>

					<button class="btn btn-default waves-effect m-l-10" type="submit">Show</button>
				</form>
			</div>
        </div>

		<div class="col-md-6">
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
			<th>Options</th>
		</tr>
		{foreach from=$arrPayments item=payment}
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
				<span class="label label-{if in_array( $payment.status, array( 'succeeded', 'active' ) )}success{elseif in_array( $payment.status, array( 'refunded' ) )}warning{elseif in_array( $payment.status, array( 'canceled' ) )}danger{elseif in_array( $payment.status, array( 'trialing' ) )}primary{else}inverse{/if}">{$payment.status}</span>
			</td>
			<td>{Project_Deliver_Currency::getCode($payment.currency)}{if !empty($payment.total_amount)}{$payment.total_amount / 100}{else}{$payment.amount / 100}{/if}</td>
			<td>{date('d-m-Y H:i:s', $payment.added)}</td>
			<td>
				<a data-modal href="{url name='site1_deliver' action='sale_detail'}?id={$payment.id}{if $payment.type == 2}&rebill=true{/if}" title="Payment Detail"><i class="fa fa-file-text-o" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				{if Core_Acs::haveAccess( [ 'email test group' ] ) && $payment.type == 1}
				<a href="?delete={$payment.id}" class="delete" title="Delete this payment"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				{/if}
			</td>
		</tr>
		{foreachelse}
		<tr><td colspan="6" align="center">Empty</td></tr>
		{/foreach}
	</table>

	{include file="../../pgg_backend.tpl"}
</div>