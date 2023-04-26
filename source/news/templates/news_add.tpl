{include file='../../error.tpl' fields=['title'=>'Title','meta'=>'Meta','description'=>'Description']}
<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label>Title: <em>*</em></label>
			<input name="arrData[title]" type="text"  class="required" value="{$arrData.title}" />
		</li>
		<li>
			<label>Groups:</label>
			<select multiple="1" name="arrData[groups][]">
				{html_options options=$arrG selected=$arrData.groups}
			</select>
		</li>
		<li>
			<label>Description: <em>*</em></label>
			<textarea name="arrData[description]" id="description" >{$arrData.description}</textarea>
		</li>
	</ol>
	<ol>
		<li>
			<label></label>
			<input type="submit" name="" value="Submit" />
		</li>
	</ol>
</fieldset>
</form>
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
{literal}
<script type="text/javascript">
window.addEvent('domready',function(){
	CKEDITOR.replace( 'description', {
		toolbar : 'Default',
		height:"300",
		width:"700"
	});
});
</script>
{/literal}