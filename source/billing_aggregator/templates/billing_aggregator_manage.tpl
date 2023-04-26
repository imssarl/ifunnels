<table class="info glow" style="width:98%">
<thead>
<tr>
	<th>Aggregator{include file="../../ord_backend.tpl" field='aggregator'}</th>
	<th>Phone{include file="../../ord_backend.tpl" field='phone'}</th>
	<th>User ID{include file="../../ord_backend.tpl" field='userid'}</th>
	<th>Status{include file="../../ord_backend.tpl" field='status'}</th>
	<th>Error Message{include file="../../ord_backend.tpl" field='errormessage'}</th>
	<th>Event Type{include file="../../ord_backend.tpl" field='event_type'}</th>
	<th>Client ID{include file="../../ord_backend.tpl" field='clientid'}</th>
	<th>Revenue Currency{include file="../../ord_backend.tpl" field='revenuecurrency'}</th>
	<th>Amount{include file="../../ord_backend.tpl" field='amount'}</th>
	<th>&nbsp;</th>
</tr>
<tr>
	<th>Service{include file="../../ord_backend.tpl" field='service'}</th>
	<th>Transaction ID{include file="../../ord_backend.tpl" field='transactionid'}</th>
	<th>End User Price{include file="../../ord_backend.tpl" field='enduserprice'}</th>
	<th>Country{include file="../../ord_backend.tpl" field='country'}</th>
	<th>MNO{include file="../../ord_backend.tpl" field='mno'}</th>
	<th>MNO code{include file="../../ord_backend.tpl" field='mnocode'}</th>
	<th>Revenue{include file="../../ord_backend.tpl" field='revenue'}</th>
	<th>Interval{include file="../../ord_backend.tpl" field='interval'}</th>
	<th>OptIn Channel{include file="../../ord_backend.tpl" field='opt_in_channel'}</th>
	<th>Added{include file="../../ord_backend.tpl" field='added'}</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="10">{include file="../../pgg_backend.tpl"}</td>
	</tr>
{if count( $arrList )>0}
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<th>{$v.aggregator}</th>
	<th>{$v.phone}</th>
	<th>{$v.userid}</th>
	<th>{$v.status}</th>
	<th>{$v.errormessage}</th>
	<th>{$v.event_type}</th>
	<th>{$v.clientid}</th>
	<th>{$v.revenuecurrency}</th>
	<th>{$v.amount}</th>
	<th>&nbsp;</th>
</tr>
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<th>{$v.service}</th>
	<th>{$v.transactionid}</th>
	<th>{$v.enduserprice}</th>
	<th>{$v.country}</th>
	<th>{$v.mno}</th>
	<th>{$v.mnocode}</th>
	<th>{$v.revenue}</th>
	<th>{$v.interval}</th>
	<th>{$v.opt_in_channel}</th>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
</tr>
{/foreach}

{else}
	<tr>
		<td colspan="10">No billings</td>
	</tr>
{/if}
	<tr>
		<td colspan="10">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>