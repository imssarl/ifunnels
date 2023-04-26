<script type="text/javascript" src="/skin/_js/typedtags.js"></script>
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
{include file='../../error.tpl' fields=['title'=>'Title','body'=>'Body']}
<form action="" class="wh" method="post">
	<input type="hidden" name="arrData[id]" value="{$arrData.id}">
	<fieldset>
		<legend>Documents set</legend>
		<ol>
			<li>
				<label>System name:<em>*</em> </label><input type="text" name="arrData[sys_name]" {if !empty($arrData.id)&&!empty($arrData.sys_name)}readonly="true"{/if} class="required" value="{$arrData.sys_name}" />
			</li>
			<li>
				<label>Title:<em>*</em> </label><input type="text" name="arrData[title]" value="{$arrData.title}" class="required" />
			</li>
			<li>
				<label>Body:<em>*</em> </label><textarea name="arrData[body]" class="required" id="body">{$arrData.body}</textarea>
			</li>
			<li>
				<label>&nbsp;</label><input type="submit" value="Save" />
			</li>
		</ol>
	</fieldset>
</form>

{literal}
<script type="text/javascript">
	window.addEvent('domready',function(){
		CKEDITOR.replace( 'body', {
			toolbar : 'Default',
			height:"300",
			width:"700"
		});
	});
</script>
{/literal}