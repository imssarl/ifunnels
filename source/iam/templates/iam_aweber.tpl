{if isset($error) && !empty($error)}
	{include file='../../message.tpl' type="error" message=$error}
{/if}
<form action="" method="GET" enctype="multipart/form-data" class="wh" >
	<label>Clickbank Id:</label>
	<input name="cbid" type="text"  class="required" value="{if isset($cbid)}{$cbid}{/if}" />
	<input type="submit" name="" value="Search" />
</form>