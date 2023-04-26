<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
	<script src="/skin/_js/audiojs/audio.js"></script>
	<style type="text/css">{literal}.item {width:230px;height:180px;padding:3px;float:left;}.add_hide{display:none}{/literal}</style>
	<script type="text/javascript" src="/skin/_js/validator/validator.js"></script>
	<link rel="stylesheet" type="text/css" href="/skin/_js/validator/style.css">
	{literal}<style type="text/css">
	.item {
		width:230px;
		height:60px;
		padding:3px;
		float:left;
	}
	.item.selected .remove_file{
		display:inline;
	}
	.item:not(.selected) .remove_file{
		display:none;
	}
	.item.selected .chose_files{
		display:none;
	}
	.item:not(.selected) .chose_files{
		display:inline;
	}
	.hide_button { list-style: none; }
	</style>{/literal}
</head>
<body>
	<div class="card-box">
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
	<div style="display: inline-block;" id="selected_user_files"></div>
	
	<form class="wh validate" style="width:100%" action="" method="post" enctype="multipart/form-data" id="form_upload_file">
		<fieldset width="50%" style="border-top-width: 0px;margin-bottom: 0px">
			<a class="open_hide btn btn-primary waves-effect waves-light" href="#">Add new File</a>
			<input type="button" value="Close" id="user_files_selected" class="btn btn-default waves-effect waves-light" />
			<ul class="hide_button add_hide">
				<li id="view_file_{$file.id}" {if empty({$file.id})}style="display:none;"{/if}>
					<div id="form_upload_file_div">
					<table border="0">
					<tr>
						<td valign="top"><div><audio src="{$file.path_web}{$file.name_system}" preload="none"></audio></div></td>
						<td valign="top">
							Title: {if !empty($file.title)}&quot;{$file.title}&quot;{else}no title{/if}<br/><br/>
							Original Name: {$file.name_original}<br/><br/>
							Description: {if !empty($file.description)}&quot;{$file.description}&quot;{else}no description{/if}
						</td>
					</tr>
					</table>
					</div>
				</li>
				<li>
					<label class="control-label">File: <em>*</em></label>
					<input type="file" name="name" class="{if empty($file)}required validate-file{/if} file filestyle" data-buttonname="btn-white" tabindex="-1" id="filestyle-0" style="position: absolute; clip: rect(0px 0px 0px 0px);" id="file_upload"/>
					<div class="bootstrap-filestyle input-group">
						<input type="text" class="form-control " placeholder="" disabled=""> <span class="group-span-filestyle input-group-btn" tabindex="0"><label for="filestyle-0" class="btn btn-white "><span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> <span class="buttonText">Choose file</span></label></span>
					</div>
				</li>
				<li>
					<label>Title: </label>
					<input type="text" name="file[title]" class="form-control" value="{$file.title}"/>
				</li>
				<li>
					<label>Description: </label>
					<textarea name="file[description]"  class="form-control" rows="5" style="width:300px;">{$file.description}</textarea>
				</li>
				<li><label></label>
					<input type="hidden" name="file[id]" value="{$file.id}" id="file_id"/>
					<p {if $arrPrm.hide=='1'}class="hide_button add_hide"{/if} style="margin: 0px">
						<input type="submit" value="{if empty($file.id)}Submit{else}Save{/if}" class="btn btn-default waves-effect waves-light" id="submit_file">
					</p>
				</li>
			</ul>
		</fieldset>
	</form>
	{if $arrList}
	<div style="display: inline;" id="list_box">
		{foreach from=$arrList item=file}
		<div class="item" rel="{$file.category_id}" id="item_{$file.id}">
			<span style="margin:0px"><span style="margin:0px" id="item_name_{$file.id}" alt="{$file.title}">{$file.title|truncate:30:"..."}</span></span>
			<audio src="{$file.path_web}{$file.name_system}" preload="none" rel="{$file.id}" class="object_{$file.id}"></audio>
			<center>
				<a href="" class="edit_files" uid="{$file.id}" description="{$file.description}">Edit</a>
				<a href="" class="chose_files" uid="{$file.id}">Choose</a>
				<a href="" class="remove_file" uid="{$file.id}">Remove</a>
			</center>
		</div>
		{/foreach}
	</div>
	<br style="clear:both;"/>
	<div align="right">
		{include file="../../pgg_backend.tpl"}
	</div>
	{else}
	<div align="center">
		no files found
	</div>
{/if}
	</div>
{literal}
<script type="text/javascript">
window.addEvent('domready',function(){
	audiojs.events.ready(function() {
		var as=audiojs.createAll();
	});
	$$('.open_hide').addEvent('click',function(e){
		e.stop();
		$$('.hide_button').toggleClass('add_hide');
		$$('input[name="file[title]"]').set('value','');
		$$('textarea[name="file[description]"]').set('html','');
		$$('input[name="file[id]"]').set('value','');
		$$('input.not_edit').destroy();
		//$('file_upload').removeClass('required').removeClass('validate-file').addClass('required').addClass('validate-file');
		validator=new WhValidator({className:'validate'});
	});
	//window.parent.location.reload();
	Form.Validator.add('validate-file', {
		errorMsg: 'Select file to upload',
		test: function(element){
			if (element.value == '') return false;
			else return true;
		}
	});
	validator=new WhValidator({className:'validate'});
	$$('.edit_files').each( function (elt) {
		elt.addEvent('click' , function(elm){
			elm.stop();
			if ( $('view_file_').get('style') != '' ) {
				$('view_file_').set('style','');
				$$('.hide_button.add_hide').removeClass('add_hide');
			}
			$('file_upload').removeClass('required validate-file');
			if ( $$('input.not_edit').length == 0 ){
				new Element ('input.not_edit[type="button"][value="Close"]',{events: {
					click: function(){
						$('form_upload_file_div').empty();
						$$('input[name="file[title]"]').set('value','');
						$$('textarea[name="file[description]"]').set('html','');
						$$('input[name="file[id]"]').set('value','');
						$('view_file_').setStyle('display','none');
						$$('.hide_button').addClass('add_hide');
						this.destroy();
					}
				}}).inject( $('submit_file'), 'after' )
			}
			var image_obj = $$('.object_'+elt.get('uid'))[0].cloneNode(true);
			image_obj.getChildren('#object_'+elt.get('uid')).set('id','edit_file_0');
			$('form_upload_file_div').set('html','');
			$('form_upload_file_div').grab( image_obj );
			$$('input[name="file[title]"]').set('value', $('item_name_'+elt.get('uid')).get('alt') );
			$$('input[name="file[id]"]').set('value',elt.get('uid'));
			$$('textarea[name="file[description]"]').set('html', elt.get('description'));
			validator=new WhValidator({className:'validate'});
		})
	});
	$$('.delete_file').each( function (elt) {
		elt.addEvent('click' , function() {
			return confirm('Do you want delete this file?')
		})
	});
	$('user_files_selected').addEvent('click',function(e){
		window.parent.multibox.boxWindow.close();
	});
	var activateUserSoundFilesOnParent=function(){
		var all_uid='';
		window.parent.document.getElementById('clear_user_sound_file')
			.empty();
		$$('#selected_user_files audio').each(function(sounds){
			var newDiv=new Element( 'div', { 'id': 'file_u'+sounds.get('rel'), 'rel': sounds.get('rel')} );
			newDiv.adopt([
				new Element( 'audio', { src: sounds.get('src'), preload: 'none'} ),
				new Element( 'br' ),
				//new Element( 'label', { html: ' Loop'} ),
				new Element( 'div.checkbox.checkbox-primary', { html: '<input type="checkbox" name="arrData[flg_sound_loop]['+sounds.get('rel')+']" value="1" /><label>Loop</label>' }),
				//new Element( 'input', { type: 'checkbox', name: 'arrData[flg_sound_loop]['+sounds.get('rel')+']', value: 1} ),
				new Element( 'br' ),
				new Element( 'a', { href: '#button', 'class':'sound_remover_button button', html: 'Remove', rel: sounds.get('rel'), 'element-data': 'u' , 'onclick': 'return false;' } ),
				new Element( 'br' )
			]);
			if( typeof oldSounds[sounds.get('rel')] != 'undefined' ){
				newDiv.adopt( new Element( 'input', {'type':'hidden', 'class':'add_value_data', 'name':'settings[flg_sound_volume]['+sounds.get('rel')+']' }).set( 'value', oldSounds[sounds.get('rel')] ) );
			}
			window.parent.document.getElementById('clear_user_sound_file').adopt( newDiv);
			if( all_uid == '' ){
				all_uid=sounds.get('rel');
			}else{
				all_uid+=":"+sounds.get('rel');
			}
		});
		window.parent.updateSoundRemover();
		window.parent.document.getElementById('file_user_sound').set('value',all_uid);
		window.parent.updateSoundVolume();
	};
	$$('.remove_file').each( function (elt) {
		elt.addEvent('click',function(e){
			e.stop();
			$( 'item_'+elt.get('uid') )
				.inject('list_box')
				.removeClass('selected');
			activateUserSoundFilesOnParent();
		});
	} );
	$$('.chose_files').each( function (elt) {
		elt.addEvent('click',function(e){
			e.stop();
			$( 'item_'+elt.get('uid') )
				.inject('selected_user_files')
				.addClass('selected');
			activateUserSoundFilesOnParent();
		})
	});
	var oldSounds={};
	var all_uid=window.parent.document.getElementById('file_user_sound').get('value');
	if( all_uid != '' ){
		all_uid.split(':').each( function( eltId ){
			if( typeof $('item_'+eltId) != 'undefined' ){
				var valueElt=window.parent.document.getElementById('file_u'+eltId).getElementsByClassName('add_value_data');
				if( valueElt.length > 0 ){
					oldSounds[eltId]=valueElt[0].value;
				}
				$('item_'+eltId)
				.inject('selected_user_files')
				.addClass('selected');
			}
		});
		activateUserSoundFilesOnParent();
	}
});
</script>
{/literal}
</body>
</html>