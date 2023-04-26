<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
	<script src="/skin/_js/audiojs/audio.js"></script>
	{literal}<style type="text/css">
	.item {
		width:230px;
		height:60px;
		padding:3px;
		float:left;
		display:none;
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
	</style>{/literal}
</head>
<body>
	<div class="card-box">
		<div style="display: inline-block;" id="selected_files"></div>
		<div style="width:100%">
			Select Category&nbsp;<select id="first_category" class="add_category btn-group selectpicker show-tick bs-select-hidden"></select>
			<input type="button" class="btn btn-default waves-effect waves-light" value="Close" id="default_files_selected" />
		</div>
		{if $arrList}
		<div id="list_box">
			{foreach from=$arrList item=file}
			<div class="item col-md-4" rel="{$file.category_id}" id="item_{$file.id}">
				<span style="margin:0px"><span style="margin:0px" id="item_name_{$file.id}" alt="{$file.description}">{$file.title|truncate:30:"..."}</span></span>
				<audio src="{$file.path_web}{$file.name_system}" preload="none" rel="{$file.id}"></audio>
				<center>
					<a href="" class="chose_files" uid="{$file.id}">Choose</a>
					<a href="" class="remove_file" uid="{$file.id}">Remove</a>
				</center>
			</div>
			{/foreach}
		</div>
		{else}
		<div align="center">
			no files found
		</div>
		{/if}
	</div>
	<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
	<script src="/skin/light/js/bootstrap.min.js"></script>

<script type="text/javascript">{literal}
window.addEvent('domready', function(){
	audiojs.events.ready(function() {
		var as=audiojs.createAll();
	});
	var jsonCategory=JSON.decode( '{/literal}{$arrCategoryTree|json}{literal}' );
	var addAfter='add_category';
	var replace_name='';
	var openItems = function( id, json ){
		if( id != '' ){
			if( json.node != undefined && JSON.encode( json.node ) != '[]' ){
				new Hash( json.node ).each(function(item){
					openItems( id, item );
				});
			}else{
				$$('.item[rel="'+json.id+'"]').show();
			}
		}
	};
	var addCategories = function( selected_element, node_json ){
		new Element('option[value=""][html="- select -"]')
			.inject( $(selected_element) );
		new Hash( node_json ).each(function(item){
			var newOption = new Element('option[value="'+item.id+'"][html="'+item.title+'"]')
				.inject( $(selected_element) );
			// add change category event
			$( selected_element ).addEvent('change',function(event){
				if( event.target.value == '' ){
					$( selected_element ).getAllNext('.'+addAfter).destroy();
					$$('#list_box .item').hide();
					if( $$('.'+addAfter)[$$('.'+addAfter).length-2] != null )
						openItems( $$('.'+addAfter)[$$('.'+addAfter).length-2].value, {id:$$('.'+addAfter)[$$('.'+addAfter).length-2].value, node: node_json} );
					return;
				}
				if( event.target.value != item.id ){
					return;
				}
				$$('#list_box .item').hide();
				openItems( event.target.value, item );
				$( selected_element ).getAllNext('.'+addAfter).destroy();
				if( item.node != undefined && JSON.encode( item.node ) != '[]' ){
					if( replace_name=='' ){
						replace_name=$( selected_element ).get('name');
					}
					$( selected_element ).erase('name');
					new Element('select[id="'+item.level+'_category"][class="'+addAfter+' btn-group selectpicker show-tick bs-select-hidden"][name="arrData[category_id]"]')
						.inject($$('.'+addAfter)[$$('.'+addAfter).length-1], 'after');
					addCategories( item.level+'_category', item.node );
					jQuery('.selectpicker').selectpicker({
						style: 'btn-info',
						size: 4
					});
				}
			});
			// check for selected category
			if( item.selected == true ){
				newOption.set('selected','selected');
				$( selected_element ).fireEvent('change', {'target':newOption} );
			}
		});
	};
	addCategories( 'first_category', jsonCategory );

	$('default_files_selected').addEvent('click',function(e){
		window.parent.multibox.boxWindow.close();
	} );
	var activateSoundFilesOnParent=function(){
		var all_uid='';
		window.parent.document.getElementById('clear_sound_file')
			.empty();
		$$('#selected_files audio').each(function(sounds){
			var newDiv=new Element( 'div', { 'id': 'file_p'+sounds.get('rel'), 'rel': sounds.get('rel')} );
			newDiv.adopt([
				new Element( 'audio', { src: sounds.get('src'), preload: 'none'} ),
				new Element( 'br' ),
				new Element( 'div.checkbox.checkbox-primary', { html: '<input type="checkbox" name="arrData[flg_sound_loop]['+sounds.get('rel')+']" value="1" /><label>Loop</label>' }),
				//new Element( 'label', { html: ' Loop'} ),
				//new Element( 'input', { type: 'checkbox', name: 'arrData[flg_sound_loop]['+sounds.get('rel')+']', value: 1} ),
				new Element( 'br' ),
				new Element( 'a', { href: '#button', 'class':'sound_remover_button button', html: 'Remove', rel: sounds.get('rel'), 'element-data': 'p' , 'onclick': 'return false;' } ),
				new Element( 'br' )
			]);
			if( typeof oldSounds[sounds.get('rel')] != 'undefined' ){
				newDiv.adopt( new Element( 'input', {'type':'hidden', 'class':'add_value_data', 'name':'settings[flg_sound_volume]['+sounds.get('rel')+']' }).set( 'value', oldSounds[sounds.get('rel')] ) );
			}else{
				newDiv.adopt( new Element( 'input', {'type':'hidden', 'class':'add_value_data', 'name':'settings[flg_sound_volume]['+sounds.get('rel')+']', 'value':( sounds.getParent('.item').get('rel')==29?0.2:1 )} ) );
			}
			window.parent.document.getElementById('clear_sound_file').adopt( newDiv );
			if( all_uid == '' ){
				all_uid=sounds.get('rel');
			}else{
				all_uid+=":"+sounds.get('rel');
			}
		});
		window.parent.updateSoundRemover();
		window.parent.document.getElementById('file_sound').set('value',all_uid);
		window.parent.updateSoundVolume();
	};
	$$('.remove_file').each( function (elt) {
		elt.addEvent('click',function(e){
			e.stop();
			$( 'item_'+elt.get('uid') )
				.inject('list_box')
				.removeClass('selected');
			$$('#first_category option[value=""]')[0].set('selected','selected');
			$('first_category').fireEvent('change', {'target':$$('#first_category option[value=""]')[0]});
			activateSoundFilesOnParent();
		});
	} );
	$$('.chose_files').each( function (elt) {
		elt.addEvent('click',function(e){
			e.stop();
			$( 'item_'+elt.get('uid') )
				.inject('selected_files')
				.addClass('selected');
			activateSoundFilesOnParent();
		})
	});
	var oldSounds={};
	var all_uid=window.parent.document.getElementById('file_sound').get('value');
	if( all_uid != '' ){
		all_uid.split(':').each( function( eltId ){
			if( typeof $('item_'+eltId) != 'undefined' ){
				var valueElt=window.parent.document.getElementById('file_p'+eltId).getElementsByClassName('add_value_data');
				if( valueElt.length > 0 ){
					oldSounds[eltId]=valueElt[0].value;
				}
				$('item_'+eltId)
				.inject('selected_files')
				.addClass('selected');
			}
		});
		activateSoundFilesOnParent();
		$$('#selected_files .item').show();
	}
});
jQuery(document).ready(function($) {
	$('.selectpicker').selectpicker({
		style: 'btn-info',
		size: 4
	});
});
{/literal}

</script>

</body>
</html>