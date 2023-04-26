<table class="info glow" style="width:98%">
<thead>
<tr>
	<td colspan="5">
		<form action="" id="current-form" method="get">
			Website:
			<select name="arrFilter[search][siteid]" class="small-input">
				<option value="0"{if $smarty.get.arrFilter.search.siteid=='0'} selected="selected"{/if}> All </option>
				{foreach $arrSites as $k=>$v}{if $v.flg_iam >0 }
				<option value="{$v.id}"{if $smarty.get.arrFilter.search.siteid==$v.id} selected="selected"{/if}>{$v.name}</option>
				{/if}{/foreach}
			</select>&nbsp;
			Clickbank ID: <input class="elogin"  style="width:150px;" type="text" name="arrFilter[search][cbid]" value="{$smarty.get.arrFilter.search.cbid}" />
			Email: <input class="elogin"  style="width:150px;" type="text" name="arrFilter[search][email]" value="{$smarty.get.arrFilter.search.email}" />
			<input type="submit" value="Search">
		</form>
	</td>
</tr>
<tr>
	<th style="width:250px;">Email{include file="../../ord_backend.tpl" field='email'}</th>
	<th style="width:50px;">Clickbank Id{include file="../../ord_backend.tpl" field='cbid'}</th>
	<th >SID{include file="../../ord_backend.tpl" field='sid'}</th>
	<th >Forms Name</th>
	<th>Added{include file="../../ord_backend.tpl" field='added'}</th>
	<th>Edited{include file="../../ord_backend.tpl" field='edited'}</th>
	<th>Options</th>
</tr>
</thead>

<tbody>
	<tr>
		<td colspan="6">{include file="../../pgg_backend.tpl"}</td>
	</tr>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<td>{$v.email}</td>
		<td>{$v.clickbank_id}</td>
		<td>{$v.sid}</td>
		<td>{foreach $v.forms as $f}{$arrForms[$f]}<br/>{/foreach}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td class="option">
			<a href="{url name='iam' action='edit_user'}?id={$v.id}">edit</a>
			<a href="{url name='iam' action='manage_users'}?delete={$v.id}" onclick="return confirm('Delete Customers?');">delete</a>
		</td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="6">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>