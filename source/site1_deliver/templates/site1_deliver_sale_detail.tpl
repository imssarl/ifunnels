<h4 class="page-title m-b-20">Sale Details</h4>

<div class="card-box">	
	{if ! isset( $error )}
		<table class="table">
			<tr>
				<td>Amount</td>
				<td>{Project_Deliver_Currency::getCode(strtoupper($currency))}{$amount}</td>
			</tr>

			<tr>
				<td>Fee amount</td>
				<td>{Project_Deliver_Currency::getCode(strtoupper($currency))}{$fee_amount}</td>
			</tr>

			<tr>
				<td>Status</td>
				<td><span class="label label-{if in_array( $status, array( 'succeeded', 'active' ) )}success{elseif in_array( $status, array( 'refunded' ) )}warning{elseif in_array( $status, array( 'canceled' ) )}danger{elseif in_array( $status, array( 'trialing' ) )}primary{else}inverse{/if}">{$status}</span></td>
			</tr>

			<tr>
				<td>Created</td>
				<td>{date( 'Y-m-d', $created )}</td>
			</tr>

			<tr>
				<td>Customer</td>
				<td>{$customer['email']}</td>
			</tr>
		</table>

		{if in_array( $status, array( 'succeeded', 'active', 'trialing' ) ) && !empty($payment_id)}
		<form method="POST">
			<input type="hidden" name="arrData[payment_id]" value="{$payment_id}">
			<button type="submit" class="btn btn-warning waves-effect waves-light">
				<span class="btn-label">
					<i class="fa fa-undo"></i>
				</span>
				Refund
			</button> 
		</form>
		{/if}

	{else}
		{foreach from=$error item=i}
		<div class="alert alert-danger">
			<strong>Error!</strong> {$i.message}
		</div>
		{/foreach}
	{/if}
</div>

{if !empty($addressData)}
<div class="card-box">
	<h3>Shipping Details</h3>
	<table class="table">
		<tr>
			<td>Name</td>
			<td>{$addressData.name}</td>
		</tr>
		<tr>
			<td>Country</td>
			<td>{$addressData.country_name}</td>
		</tr>
		<tr>
			<td>City</td>
			<td>{$addressData.city}</td>
		</tr>
		<tr>
			<td>Address</td>
			<td>{$addressData.address}</td>
		</tr>
		<tr>
			<td>Zip</td>
			<td>{$addressData.zip}</td>
		</tr>
	</table>
</div>
{/if}