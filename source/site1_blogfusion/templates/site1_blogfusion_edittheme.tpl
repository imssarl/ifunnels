{include file="site1_blogfusion_general_menu.tpl"}
<form class="wh" id="post_form" method="POST">
<fieldset>
		<p>
			<label>Select file:</label>
			<select name="arr[file]" id="file" class="medium-input">
			<option value=""> --
			{foreach from=$arrDirs item=i key=dir}
			{foreach from=$i item=file}
			{assign var=path value="$dir$file"}
				<option {if $path==$arr.file}selected="1"{/if} value="{$dir}{$file}">{$file}
			{/foreach}
			{/foreach}
			</select>
		</p>
		<p>
			<label>Theme Files</label><textarea name="arr[content]" style="width:100%; height:400px;" id="editor">{$arr.content}</textarea>
		</p>
		<p>
			<input type="submit" id="save" class="button" value="Save" name="save" {is_acs_write} />&nbsp;<img src="/skin/i/frontends/design/ajax-loader_new.gif" id="loader_save" style="display:none;" >
		</p>
		<p>
			<div id="editor_message"></div>
		</p>
</fieldset>
</form>
</td>
</tr>
</table>
{literal}
<script>

$('file').addEvent('change', function(event){
	$('editor').set('value','');
	$('post_form').submit();
});
</script>
{/literal}