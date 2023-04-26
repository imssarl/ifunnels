<div class="card-box">
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Subscriptions</h3>
	</div>
	<div class="content-box-content">
		<fieldset>
			<h3>You have access to:</h3>
			{foreach from=$arrGroups item=i}
			{if $i.sys_name!='Default'}
			<p>
				<label>{$i.title}</label>
				<br/>
				<i>Description</i>:<b>{$i.description}</b>
			</p>
			{/if}
			{/foreach}
		</fieldset>

		<fieldset>
			<h3>Credits&nbsp;</h3>
			<p>Amount of remaining credits on balance: <b>{Core_Payment_Purse::getAmount()} credits</b></p>
		</fieldset>
		
		
		{if !empty($arrReward)}
		<fieldset>
			<h3 style="color:red">Rewards</h3>
				{foreach from=$arrReward item=i}
				<p>+{$i.amount} credits. {$i.description}</p>
				{/foreach}
		</fieldset>
		{/if}
		
		
		<fieldset>
			<h3>Identity&nbsp;</h3>
				<p><label>Name: </label><b>{$arrProfile['buyer_name']}</b></p>
				<p><label>Surname: </label><b>{$arrProfile['buyer_surname']}</b></p>
				<p><label>Address: </label><b>{$arrProfile['buyer_address']}</b></p>
				<p><label>City: </label><b>{$arrProfile['buyer_city']}</b></p>
				<p><label>State: </label><b>{$arrProfile['buyer_province']}</b></p>
				<p><label>Zip: </label><b>{$arrProfile['buyer_zip']}</b></p>
				<p><label>Country: </label><b>{$arrProfile['buyer_country']}</b></p>
				<p><label>Phone: </label><b>{$arrProfile['buyer_phone']}</b>
					<a id="verify" href="{url name='site1_accounts' action='confirmphone'}" class="popup-sidebar" style="color:red;{if $arrProfile['flg_phone']!=1} display: inline; {else} display: none; {/if}">Verify phone number</a>
					<a id="verified" href="{url name='site1_accounts' action='calls'}" style="color:green;{if $arrProfile['flg_phone']==1} display: inline; {else} display: none; {/if}">Verified successfully</a>
				</p>
				<p><label>Email: </label><b>{$arrProfile['email']}</b></p>
				<p><label>Language: </label><b>{Core_i18n::$lang[$arrProfile['lang']]}</b></p>
				<p><label>Timezone: </label><b>{$arrProfile['timezone']}</b></p>
				<p><a href="{url name='site1_accounts' action='details'}" class="btn btn-success waves-effect waves-light">Edit</a></p>
		</fieldset>
	</div>
</div>
</div>