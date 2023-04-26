{include file='../../box-top.tpl' title=$arrNest.title}
<form action="./?id={$smarty.get.id}{if $smarty.get.page}&page={$smarty.get.page}{/if}" method="POST" class="wh" >
<fieldset>
	<legend>Edit Saved Selection</legend>
	<p>
		<label>Title</label>
		<input type="text" class="text-input medium-input" name="name" value="{$arrItem.name}" />
	</p>
	<p>
		<label>Description</label>
		<textarea name="description" class="text-input textarea"  >{$arrItem.description}</textarea>
	</p>
	<p>
		<label>Code</label>
		<textarea name="code" class="text-input textarea" rows="30" >{$arrItem.code}</textarea>
	</p>
	<p>
		<input type="submit" value="Submit" name="save"  class="button" {is_acs_write} />
	</p>
</fieldset>
</form>
{include file='../../box-bottom.tpl'}