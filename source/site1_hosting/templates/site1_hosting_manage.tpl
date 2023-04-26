<form action="" method="get">
	<div style="padding: 0 0 10px 0;">
		Domains to be renewed:
		<input style="width:50px;" type="text" name="arrFilter[renewed][number]" value="{$smarty.get.arrFilter.renewed.number}" />
		<select style="width:100px;" name="arrFilter[renewed][type]">
			<option value="">-select-</option>
			<option value="day"{if $smarty.get.arrFilter.renewed.type == 'day'} selected{/if}>days</option>
			<option value="week"{if $smarty.get.arrFilter.renewed.type == 'week'} selected{/if}>weeks</option>
		</select>
		&nbsp;
		User name: <input style="width:150px;" type="text" name="arrFilter[search][user_name]" value="{$smarty.get.arrFilter.search.user_name}" />
		User email: <input style="width:150px;" type="text" name="arrFilter[search][user_email]" value="{$smarty.get.arrFilter.search.user_email}" />
		Domain name: <input style="width:150px;" type="text" name="arrFilter[search][domain_http]" value="{$smarty.get.arrFilter.search.domain_http}" />
		<input type="submit" value="Search">
	</div>
</form>



{include file='../../error.tpl'}
{if $arrList}

<form method="post" action="">
<div style="margin-bottom:10px;">
		<select class="elogin" style="width:150px;" name="arrFilter[action]" id="go-action" >
			<option value="">-- Select an Action --</option>
			<option value="delete">Push domain and remove hosting from CNM</option>
			<option value="exteral">Push domain and keep hosting on CNM</option>
		</select> <input type="submit" value="Go" id="go">
</div>

<table class="info glow" style="width:98%">
<thead>
<tr>
	<th><input type="checkbox" id="sel" title="mass select" class="tooltip" rel="check to select all" /></th>
	<th>Domain{include file="../../ord_backend.tpl" field='d.domain_http'}</th>
	<th>Date of Registration{include file="../../ord_backend.tpl" field='d.added'}</th>
	<th>Renewal Status{include file="../../ord_backend.tpl" field='d.flg_auto'}</th>
	<th style="width:270px;">User(email){include file="../../ord_backend.tpl" field='d.user_id'}</th>
	<th>Credit balance</th>
	<th>Renewal Due Date{include file="../../ord_backend.tpl" field='d.expiry_domain'}</th>
	<th>Options</th>
</tr>
</thead>
<tbody>
	<tr>
		<td colspan="8">{include file="../../pgg_backend.tpl"}</td>
	</tr>
{foreach $arrList as $i}
<tr{if ($i@iteration-1) is div by 2} class="matros"{/if}>
	<td style="padding-right:0;width:1px;"><input type="checkbox" name="arrList[{$i.id}]" class="check-me-sel" id="check-{$i.id}" /></td>
	<td
		{if $i.expiry_domain != 0}
			{if $i.expiry_domain+25*24*60*60 <= time()} style="color:#cccccc;"{/if}
			{if $i.expiry_domain+25*24*60*60 >= time() && time() >= $i.expiry_domain } style="color:#ff0000;"{/if}
		{/if}
	>{$i.domain_http}</td>
	<td align="center">{$i.added|date_format:$config->date_time->dt_full_format}</td>
	<td align="center">
	{if $i.expiry_domain == 0}
		
	{else}
		{if $i.expiry_domain <= time()}
			Expired&nbsp;|&nbsp;Autorenew {if $i.flg_auto==1}On{else}Off{/if}
		{else}
			{if $i.flg_auto==1}
				<a href="?flg_auto=0&id={$i.id}">Turn Off</a>
			{else}
				<a href="?flg_auto=1&id={$i.id}">Turn On</a>
			{/if}
		{/if}
	{/if}
	</td>
	<td>
		<a href="{url name='members' action='set' wg="id={$i.user_id}"}" target="_blank">{$arrUsers[$i.user_id].name} {$arrUsers[$i.user_id].surname} ({$arrUsers[$i.user_id].email})</a>&nbsp;|&nbsp;
		<a href="{url name='members' action='manage'}?auth={Core_Payment_Encode::encode($i.user_id)}" target="_blank">Login</a>
	</td>
	<td align="center">{$arrUsers[$i.user_id].amount}</td>
	<td align="center">
		{if $i.expiry_domain != 0}
			{$i.expiry_domain|date_format:$config->date_time->dt_full_format}
		{/if}
	</td>
	<td align="center">
		<a href="?del={$i.id}" confirm='Delete domain?' class="confirm-delete" title="Delete">Delete</a>
		{if $i.expiry_domain != 0}
			{if time() < $i.expiry_domain }
				<a href="?renew={$i.id}" class="confirm-delete" confirm='Renew domain?' title="Renew domain">
					<img src="/skin/i/frontends/design/buttons/resume.gif" alt="Renew" />
				</a>
			{/if}
			{if $i.expiry_domain+25*24*60*60 >= time() && time() >= $i.expiry_domain }
				<a href="?reactivate={$i.id}" class="confirm-delete" confirm='Reactivate domain?' title="Reactivate domain">
					<img src="/skin/i/frontends/design/buttons/arrow_refresh.png" alt="Reactivate" />
				</a>
			{/if}
		{/if}
	</td>
</tr>
{/foreach}
	<tr>
		<td colspan="8">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>

</form>
<script>
window.addEvent('domready',function(){
	checkboxFullToggle($('sel'));
	$('go').addEvent('click',function(e){
		if( $('go-action').get('value')=='delete'&&!confirm('WARNING! All data will be deleted!') ){
			e.stop();
			return false;
		}
		if( $('go-action').get('value')=='delete'&&!confirm('You are sure? We can\'t recover the data!') ){
			e.stop();
			return false;
		}
	});
});
</script>

{else}
<div>No domains finded</div>
{/if}
