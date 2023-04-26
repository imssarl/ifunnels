<p>
	<b>Number of domains purchased:</b> {$DomainsPurchased}
</p><br/>
<p>
	<b>Number of domain hosted:</b> {$DomainsHosted}
</p><br/>
<p>
	<b>Number of members who bought credits:</b> {$BoughtCredits}
</p><br/>
<p>
	<b>Number of credits consumed:</b> {$CreditsConsumed} credits.
</p><br/>
<p>
	<b>Number of credits purchased:</b> {$CreditsPurchased} credits.
</p><br/>
<p>
	<b>Total number of members:</b> {$totalNumberOfMembers}
</p>
<br/>
<h2>Who are using CNM hosting:</h2>
<br/>
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th style="width:250px;">Nickname{include file="../../ord_backend.tpl" field='nickname'}</th>
	<th style="width:250px;">Email{include file="../../ord_backend.tpl" field='email'}</th>
	<th>Registered{include file="../../ord_backend.tpl" field='added'}</th>
	<th>Credits{include file="../../ord_backend.tpl" field='amount'}</th>
	<th>Count Sites</th>
	<th>Options</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<td><a target="_blank" href="{url name='members' action='set'  wg="id={$v.id}"}">{if empty($v.nickname)}{$v.buyer_name} {$v.buyer_surname}{else}{$v.nickname}{/if}</a></td>
	<td>{$v.email}</td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td>{$v.amount}</td>
	<td>{$v.count_hosting}</td>
	<td class="option">
		<a target="_blank" href="{url name='members' action='set' wg="id={$v.id}"}">edit</a>
	</td>
</tr>
{/foreach}
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>