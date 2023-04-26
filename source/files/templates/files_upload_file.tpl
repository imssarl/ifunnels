<script src="/skin/_js/player/swfobject.js" type="text/javascript" charset="utf-8"></script>
<script src="/skin/_js/player/nonverblaster.js" type="text/javascript" charset="utf-8"></script>
{*validator*}
<script type="text/javascript" src="/skin/_js/validator/validator.js"></script>
<link rel="stylesheet" type="text/css" href="/skin/_js/validator/style.css">
{*/validator*}
{if $arrPrm.hide=='1'}{literal}
<style type="text/css">
	.add_hide{display:none}
</style>
{/literal}{/if}
{if $msg=='edited'}<p style="color:green">File and settings edited.</p>
{elseif $msg=='saved'}<p style="color:green">File and settings saved.</p>{/if}
{if !empty($arrErrors)}
	<p style="color:red">
	{foreach from=$arrErrors item=err key=k}
		Error: 
		{if $k=='file_bigger_than'}File is bigger than possible importance!<br/>{/if}
		{if $k=='wrong_media_type'}Wrong media type!<br/>{/if}
		{if $k=='no_file_data'}No file data!<br/>{/if}
		{if $k=='upload_error'}Upload error!<br/>{/if}
		{if $k=='have_no_extension'}Have no file extension!<br/>{/if}
		{if $k=='have_no_name'}Have no file name!{/if}
	{/foreach}
	</p>
{/if}
<form class="wh validate" style="width:100%" action="" method="post" enctype="multipart/form-data" id="form_upload_file">
<fieldset width="70%" style="border-top-width: 0px;margin-bottom: 0px">
	{if $arrPrm.hide=='1'}<legend><a class="open_hide" href="">Add new File</a></legend>{/if}
	<ol{if $arrPrm.hide=='1'} class="hide_button add_hide"{/if}>
		{if !empty($file) || $arrPrm.hide=='1'}
		<li id="view_file_{$file.id}" {if empty({$file.id})}style="display:none;"{/if}>
			<div id="form_upload_file_div">
			<table border="0">
			<tr>
				<td valign="top">
					{include file="files_view_file.tpl"}
				</td>
				<td valign="top">
					Title: {if !empty($file.title)}&quot;{$file.title}&quot;{else}no title{/if}<br/><br/>
					Original Name: {$file.name_original}<br/><br/>
					Description: {if !empty($file.description)}&quot;{$file.description}&quot;{else}no description{/if}
				</td>
			</tr>
			</table>
			</div>
		</li>
		{/if}
		<li>
			<label>File: <em>*</em></label>
			<input type="file" name="name" class="{if empty($file)}required validate-file{/if} file" id="file_upload"/>
		</li>
		<li>
			<label>Title: </label>
			<input type="text" name="file[title]" value="{$file.title}"/>
		</li>
		<li>
			<label>Description: </label>
			<textarea name="file[description]" rows="5" style="width:300px;">{$file.description}</textarea>
		</li>
		<li><label></label>
			<input type="hidden" name="file[id]" value="{$file.id}" id="file_id"/>
			<p {if $arrPrm.hide=='1'}class="hide_button add_hide"{/if} style="margin: 0px">
				<input type="submit" value="{if empty($file.id)}Submit{else}Save{/if}" id="submit_file">
			</p>
		</li>
	</ol>
</fieldset>
</form>
{literal}
<script src="/skin/_js/player/adapter.js" type="text/javascript"></script>
<script type="text/javascript">
	window.addEvent('domready',function(){
	{/literal}{if $arrPrm.hide=='1'}{literal}
		$$('.open_hide').addEvent('click',function(e){
			e.stop();
			if( $('form_upload_file_div').get('html')=='' ){
				$$('.hide_button').toggleClass('add_hide');
			}
			$('form_upload_file_div').empty();
			$$('input[name="file[title]"]').set('value','');
			$$('textarea[name="file[description]"]').set('html','');
			$$('input[name="file[id]"]').set('value','');
			$$('input.not_edit').destroy();
			$('file_upload').removeClass('required').removeClass('validate-file').addClass('required').addClass('validate-file');
			validator=new WhValidator({className:'validate'});
		});
	{/literal}{/if}{literal}
	{/literal}{if !empty($msg) && $arrPrm.hide!='1'}{literal}
		window.parent.location.reload();
	{/literal}{/if}{literal}
		Form.Validator.add('validate-file', {
			errorMsg: 'Select file to upload',
			test: function(element){
				if (element.value == '') return false;
				else return true;
			}
		});
		validator=new WhValidator({className:'validate'});
	});
</script>
{/literal}