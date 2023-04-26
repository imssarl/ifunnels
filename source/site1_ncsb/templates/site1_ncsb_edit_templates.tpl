<br />
{if $error}
{include file="../../message.tpl" type='error' message="Error. Template has not been saved"}
{/if}
<div align="center">
	<h3>{$arrTemplate.title}</h3>
	<img src="{$arrTemplate.preview}" >
</div>
<br /><br />
<form class="wh" action=""  method="POST" enctype="multipart/form-data">
<input type="hidden" name="arr[id]" value="{$arrTemplate.id}">
<fieldset>
	<legend>Edit templates</legend>
	<p><label>Select file:</label>
		<select name="arr[file]" id="select-file" class="medium-input">
			<option value=""> - select -
			{foreach from=$arrFiles item=files key=dir}
			{foreach from=$files item=file}
			<option value="{$dir}/{$file}">{$file}
			{/foreach}
			{/foreach}
		</select>
	</p>
	<p>
		<label>Header Image:</label><input type="file" name="header" >
	</p>
	<p>
		File:<br /><textarea style="height:300px; width:100%;" class="text-input textarea" id="editor"></textarea>
	</p>
	<p>
		<input type="button" value="Update file" class="button" id="save-file" {is_acs_write} > <input {is_acs_write} type="submit" class="button" value="Save Template" id="save-template">
	</p>
	<p id="messages-block" style="display:none;">
		<p class="red" id="error-message"></p>
		<p class="grn" id="success-message"></p>
	</p>
</fieldset>
</form>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	$('select-file').addEvent('change', function(){
		$('messages-block').setStyle('display','none');
		var r=new Request.RAW({url:"{/literal}{url name='site1_nvsb' action='ajax_edit_template'}{literal}?open_file=true", onSuccess:function(raw){
			$('editor').set('value',raw);
		}}).post({'file': $('select-file').value});
	});
	$('save-file').addEvent('click', function(){
		$('messages-block').setStyle('display','none');
		$('success-message').set('html','');
		$('error-message').set('html','');
		var r = new Request({  url:"{/literal}{url name='site1_ncsb' action='ajax_edit_template'}{literal}?save_file=true", method:'post', onSuccess: function(response){
			response = JSON.decode(response);
			if( response.result == 1 ){
				$('success-message').set('html','File has been saved successfully');
			} else {
				$('error-message').set('html','File has not been saved');
			}
			$('messages-block').setStyle('display','block');
		}}).post({'file': $('select-file').value, 'strContent':$('editor').value });
	});
});
</script>
{/literal}