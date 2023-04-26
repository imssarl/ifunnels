<div>
	<form action="" method="get" class="wh">
	Select statistics period: 
	<select name="arrFilter[time]">
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_ALL} selected="1" {/if} value="{Project_Statistics_Api::TIME_ALL}">All</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_TODAY} selected="1" {/if} value="{Project_Statistics_Api::TIME_TODAY}">Today</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_YESTERDAY} selected="1" {/if} value="{Project_Statistics_Api::TIME_YESTERDAY}">Yesterday</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_LAST_7_DAYS} selected="1" {/if} value="{Project_Statistics_Api::TIME_LAST_7_DAYS}">Last 7 days</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_THIS_MONTH} selected="1" {/if} value="{Project_Statistics_Api::TIME_THIS_MONTH}">This month</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::THIS_YEAR} selected="1" {/if} value="{Project_Statistics_Api::THIS_YEAR}">This year</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_LAST_YEAR} selected="1" {/if} value="{Project_Statistics_Api::TIME_LAST_YEAR}">Last year</option>
	</select>
	IP: <input name="arrFilter[ip]" value="">
	Referer: <input name="arrFilter[referer]" value="">
	<input type="submit" value="Filter">
	</form>
</div>
<br>
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th>Request{include file="../../ord_backend.tpl" field='request'}</th>
	<th style="width:150px;">From IP{include file="../../ord_backend.tpl" field='ip'}</th>
	<th style="width:150px;">Referer{include file="../../ord_backend.tpl" field='referer'}</th>
	<th style="width:150px;">Runed{include file="../../ord_backend.tpl" field='added'}</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<td>
			{if $v.unserialized_request.action == 'member_add'}Add/update member {$v.unserialized_request.email}
				{if isset( $v.unserialized_request.credits )} with added through API {$v.unserialized_request.credits} credits {/if}
				{if isset( $v.unserialized_request.payment )} with deleted through API {$v.unserialized_request.credits} credits {/if}
				{if isset( $v.unserialized_request.groups )} with groups update to {$v.unserialized_request.groups} {/if}
			{else}{if $v.unserialized_request.action == 'member_delete'}Delete member {$v.unserialized_request.email}
			{else}Bad request sended <code>{htmlspecialchars( $v.request )}</code>{/if}{/if}
		</td>
		<td>{$v.ip}</td>
		<td>{$v.referer}</td>
		<td>{$v.date}</td>
	</tr>
	{/foreach}
</tbody>
</table>