<div class="card-box">
	<div class="change_password">
		{if $strError!=''}
		<div class="red">Error: {$strError}</div>
		{/if}
		{if $strError}
		<div id="end_of_date">This temporary link is out of date. <a href="#" class="forgot_password">Try again!</a></div>
		{else}
		<div id="end_of_date">Congratulations! You have successfully confirmed your account. Please <a href="/">login</a> now.</div>
		{/if}
	</div>
	{literal}
	<script type="text/javascript">
		$$('.forgot_password').addEvent('click',function(event){
			event&&event.stop();
			$('user_login').hide();
			$('forgot_data').show();
		});
	</script>
	{/literal}
</div>