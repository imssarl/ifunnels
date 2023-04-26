<div>
<br/><label>API Link Sample:</label>
<br/><label>URL of a GET request:</label>
<br/><br/><code>{Zend_Registry::get( 'config' )->domain->url}/api/?action=&email=&member_id=&credit=&payment=&groups=<br/>&username=&first_name=&last_name=&phone=&billing_address=&billing_country=&billing_zip_code=&billing_state=&billing_city=</code>
<br/><br/><label>HTTP message body of a POST request:</label>
<br/><br/><br/><code>POST /api/ HTTP/1.1
<br/>Host: {Zend_Registry::get( 'config' )->domain->url}
<br/>action=&email=&member_id=&credit=&payment=&groups=&username=&first_name=&last_name=<br/>&phone=&billing_address=&billing_country=&billing_zip_code=&billing_state=&billing_city=</code>
<br/>
<br/>Required Parameters:
<br/><code>&action=</code>
<br/><code>&email=</code>
{*<br/><code>&member_id=</code>*}
<br/>
<br/>Action Parameters:
<br/><code>member_add</code>
<br/><code>member_delete</code>
<br/>
<br/>Add parameter <code>&credit=</code> with the number of credits to add credits to the user.
<br/>Add parameter <code>&payment=</code> with the number of credits to remove credits from the user's account.

<br/>Add parameters <code>&zonterest_limit=#integer# to add zonterest sites limit. If sended "unlim" - add unlimit zonterest sites.
<br/>Add parameters <code>&hosting_limit=#integer# to add free hosting sites limit.

<br/>Add parameters <code>&automation_limit=#integer# to set Automation limit.
<br/>Add parameters <code>&subaccounts_limit=#integer# to set Sub Accounts limit.

<br/>Add parameters <code>&lpb_limits=#string# to add or remove ( send less that 0 ) lpb limit credits. If sended "unlim" - add unlimit credits. If sended "-all" - remove all credits (and unlim). 
<br/>Add parameters <code>&lpb_limits_type= 1 - for non-renewable limit added once, or 0 - for monthly renewable limit (default=0)
<br/>Add parameters <code>&traffic_credits=#integer# to add extra traffic credits.

<br/>Add parameters <code>&contact_limit=#integer# to set contacts limit.

<br/>Add parameters <code>&groups=#ID#,#ID#... to update user's groups list. Get <code>#ID#</code> from this table:
</div>
<br/>
<table class="info glow" style="width:98%">
<thead>
	<tr>
		<th>ID</th>
		<th>Title</th>
		<th>System name</th>
		<th>Description</th>
	</tr>
</thead>
<tbody>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<td>{$v.id}</td>
		<td valign="top">{$v.title}</td>
		<td valign="top">{$v.sys_name}</td>
		<td>{$v.description}</td>
	</tr>
	{/foreach}
</tbody>
</table>