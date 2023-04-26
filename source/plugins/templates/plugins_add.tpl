<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label></label>
			{if $arrData.id}<input type="submit" name="" value="Edit Plugin" />{else}
			<input type="submit" name="" value="Create Plugin" />{/if}
		</li>
		
		<li>
			<label>Plugin File: </label>
			<input type="file" name="plugin" />
			<br/><small>input your plugin file name</small>
		</li>

		<li>
			<label>Version: </label>
			<input name="arrData[version]" type="text" class="required" value="{$arrData.version}" />
			<br/><small>version</small>
		</li>
		<li>
			<label>Slug: </label>
			<input name="arrData[slug]" type="text" class="required" value="{$arrData.slug}" />
			<br/><small>slug</small>
		</li>
		<li>
			<label>requires: </label>
			<input name="arrData[requires]" type="text" class="required" value="{$arrData.requires}" />
			<br/><small>requires</small>
		</li>
		<li>
			<label>tested: </label>
			<input name="arrData[tested]" type="text" class="required" value="{$arrData.tested}" />
			<br/><small>tested</small>
		</li>
		<li>
			<label>rating: </label>
			<input name="arrData[rating]" type="text" class="required" value="{$arrData.rating}" />
			<br/><small>rating
		<li>
			<label>homepage: </label>
			<input name="arrData[homepage]" type="text" class="required" value="{$arrData.homepage}" />
			<br/><small>homepage</small>
		</li>
		<li>
			<label>description: </label>
			<input name="arrData[description]" type="text" class="required" value="{$arrData.description}" />
			<br/><small>description</small>
		</li>
		<li>
			<label>changelog: </label>
			<input name="arrData[changelog]" type="text" class="required" value="{$arrData.changelog}" />
			<br/><small>changelog</small>
		</li>

	</ol>
</fieldset>
</form>