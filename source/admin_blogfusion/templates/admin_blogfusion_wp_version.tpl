Current local version: {$version}<br/>
Latest version: {$new_version}<br/>
{if $new_version!=$version}
<form action="" method="POST">
	<input type="hidden" name="check" value="1">
	<input type="submit" value="Download WordPress {$new_version}">
</form>
{/if}
{$strLog}