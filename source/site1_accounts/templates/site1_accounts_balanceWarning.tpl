{if $balanceBoolShow}
{literal}
<script type="text/javascript">
window.addEvent('domready', function() {
	r.alert(
		'Warning',
		'You have less than 5 credits. To ensure all features work correctly, make sure you always keep a +5 credit balance in your account',
		'roar_warning',
		{duration:10000}
	);
});
</script>
{/literal}
{/if}