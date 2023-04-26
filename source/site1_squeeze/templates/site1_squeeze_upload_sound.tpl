<script src="/skin/_js/audiojs/audio.js"></script>
<form action="" method="post" class="wh" enctype="multipart/form-data">
<input type="hidden" name="arrData[id]" value="{$file.id}" />
	<fieldset>
		<legend></legend>
		<ol>
			<li>
				{if isset($file.id)}
				<label>&nbsp;</label>
				<div><audio src="{$file.path_web}{$file.name_system}" preload="none"></audio></div>
				<input type="file" name="sound" style="display:none;"/>
				{else}
				<label>File:</label>
				<input type="file" name="sound" />
				{/if}
			</li>
			<li>
				<label>Title:</label>
				<input type="text" name="arrData[title]" value="{$file.title}" />
			</li>
			<li>
				<label>Description:</label>
				<textarea name="arrData[description]">{$file.description}</textarea>
			</li>
			<li class="add_category_after">
				<label for="first_category">Select Category <em>*</em></label>
				<select id="first_category" name="arrData[category_id]"></select>
			</li>
			<li>
				<label></label>
				<input type="submit" name="" value="Upload" />
			</li>
		</ol>
	</fieldset>
</form>
{literal}<script type="text/javascript">
var jsonCategory=JSON.decode( '{/literal}{$arrCategoryTree|json}{literal}' );
var addAfter='add_category_after';
var replace_name='';
var addCategories = function( selected_element, node_json ){
	new Element('option[value=""][html="- select -"]')
		.inject( $(selected_element) );
	new Hash( node_json ).each(function(item){
		var newOption = new Element('option[value="'+item.id+'"][html="'+item.title+'"]')
			.inject( $(selected_element) );
		// add change category event
		$( selected_element ).addEvent('change',function(event){
			if( event.target.value == '' ){
				$( selected_element ).getParent('li').getAllNext('.'+addAfter).destroy();
				return;
			}
			if( event.target.value != item.id ){
				return;
			}
			$( selected_element ).getParent('li').getAllNext('.'+addAfter).destroy();
			if( item.node != undefined && JSON.encode( item.node ) != '[]' ){
				if( replace_name=='' ){
					replace_name=$( selected_element ).get('name');
				}
				$( selected_element ).erase('name');
				new Element('li[class="'+addAfter+'"]')
					.adopt([
						new Element('label[html="&nbsp;"]'),
						new Element('select[id="'+item.level+'_category"][name="arrData[category_id]"]')
					])
					.inject($$('.'+addAfter)[$$('.'+addAfter).length-1], 'after');
				addCategories( item.level+'_category', item.node );
			}
		});
		// check for selected category
		if( item.selected == true ){
			newOption.set('selected','selected');
			$( selected_element ).fireEvent('change', {'target':newOption} );
		}
	});
};
window.addEvent('domready', function(){
	addCategories( 'first_category', jsonCategory );
	audiojs.events.ready(function() {
		var as = audiojs.createAll();
	});
});
</script>{/literal}