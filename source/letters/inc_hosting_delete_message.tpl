Dear {$user.buyer_name} {$user.buyer_surname},<br/>
<br/>
Your hosting(s) is about to expire. Please make sure you have enough credits on your balance so the hosting can be renewed automatically. Otherwise, THEY WILL EXPIRE.
<br/>
<br/>
<table style="border-collapse: collapse; border: 1px solid #999;" cellpadding="5" width="100%">
<tr>
	<th bgcolor="#CCC" align="center" width="25%"><b>Hosting</b></th>
	<th bgcolor="#CCC" align="center"><b>Renews</b></th>
	<th bgcolor="#CCC" align="center"><b>Automatic Renewal</b></th>
	<th bgcolor="#CCC" align="center"><b>Renewal Rate</b></th>
</tr>
{foreach from=$arrList item=i}
<tr>
	<td align="left">&nbsp;{$i.domain_http}</td>
	<td align="center">{$i.expiry_hosting|date_local:$config->date_time->dt_full_format}</td>
	<td align="center">{if $i.flg_auto==1}On{else}Off{/if}</td>
	<td align="center">{$settings.credits} credit(s)</td>
</tr>
{/foreach}
</table>
<br/>
Regards,<br/>
iFunnels Team