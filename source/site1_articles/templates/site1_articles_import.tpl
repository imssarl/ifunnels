{include file='../../box-top.tpl' title=$arrNest.title}
{if $save_article_true == 1}
	{include file='../../message.tpl' type='info' message='Articles saved successfully'}
{elseif $save_article_true == 2}
	{include file='../../message.tpl' type='error' message='Process Aborted. Unable to upload articles. Check format file!'}
{/if}
<form class="validate" action="" method="POST" enctype="multipart/form-data" id="import_form">
	<small>Please complete the form below. Mandatory fields are marked with <em>*</em></small>
	<fieldset>
		<div class="form-group">
			<label>Source <em>*</em> </label>
			<select name="import[source]" id="import_source" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick">
				<option value="0"> - select source - </option>
				{html_options options=$arrSelect.source}
			</select>				
		</div>
		<div class="form-group">
			<label>Author</label>
			<input type="text" name="import[author]" id="import_author" class="text-input medium-input form-control" />
		</div>
		<div class="form-group">
			<label>Article source <em>*</em></label>

			<div class="radio radio-primary">
				<input type="radio" name="import[article_source]" class="article_source" value="text_file" />
				<label>Text file (new line separated)</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="import[article_source]" class="article_source {if $return_type == 'form'}validate-one-required{/if}" value="manually" />
				<label>Manually</label>
			</div>
			{if $return_type != 'form'}
			<div class="radio radio-primary">
				<input type="radio" name="import[article_source]" class="validate-one-required article_source" value="zip_file" />
				<label>Zip file</label>
			</div>
			{/if}
		</div>
		<div class="form-group">
			<label>Status</label>
			<div class="radio radio-primary">
				<input type="radio" name="import[status]"  value="1" checked='1' />
				<label>Active</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="import[status]"  value="0" />
				<label>InActive</label>
			</div>
		</div>
	</fieldset>
	<fieldset id="fieldset_manually" style="display:none;">
		<div class="from-group">
			<label>Category <em>*</em></label>
			<input type="text" name="import[manually][new_category]" style="display:none;" class="required text-input medium-input">
			<select name="import[manually][category]" id="manually_category" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick">
				<option value="0"> - select category -
				{foreach from=$arrSelect.category item=i key=k name=cat}
				<option value="{$k}">{$i}
				{/foreach}
			</select> <input type="checkbox" class="create_new_category"> Create new
		</div>
		<div class="form-group">
			<label>Title <em>*</em></label>
			<input type="text" name="import[manually][title]" id="manually_title" class="required text-input medium-input form-control" />
		</div>
		<div class="form-group">
			<label>Enter article <em>*</em></label>
			<textarea style="height:150px;" name="import[manually][text]" id="manually_text" class="required text-input textarea form-control"></textarea>
		</div>
	</fieldset>

	<fieldset id="fieldset_file" style="display:none;">
		<legend>{if $return_type != 'form'}<a href="#" id="add">+ Add</a>{/if}</legend>
			<div class="form-group">
				<label>Category <em>*</em></label>
				<input type="text" name="import[file][new_category]" style="display:none;" class="required medium-input form-control">
				<select name="import[category][0]" class="category_file required validate-custom-required emptyValue:'0'  medium-input btn-group selectpicker show-tick">
					<option value="0"> - select category -
					{foreach from=$arrSelect.category item=i key=k name=cat}
					<option value="{$k}">{$i}
					{/foreach}
				</select> 
				<div class="checkbox checkbox-primary">
					<input type="checkbox" class="create_new_category">
					<label>Create new</label>
				</div>
			</div>
			<div class="form-group">
				<label>File <em>*</em></label>
				<input type="file" name="import[file][0]" class="file required filestyle" data-buttonname="btn-white" id="filestyle-0" tabindex="-1" style="position: absolute; clip: rect(0px 0px 0px 0px);">
				<div class="bootstrap-filestyle input-group"><input type="text" class="form-control " placeholder="" disabled=""> <span class="group-span-filestyle input-group-btn" tabindex="0"><label for="filestyle-0" class="btn btn-white "><span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> <span class="buttonText">Choose file</span></label></span></div>
			</div>
	</fieldset>
	<fieldset>
		<div class="form-group">
			<button type="submit" name="save" id="save_botton" class="button btn btn-success waves-effect waves-light">Save</button>
			<!--<input type="submit" name="save" id="save_botton" value="Save" class="button" {is_acs_write}/>-->
		</div>
	</fieldset>
</form>
{include file='../../box-bottom.tpl'}
<script type="text/javascript">
var index = 0;
var category = JSON.decode('{$categoryJson|replace:"'":'`'}'); //"Category
var Ids =  '{$strJsonArticles}'; // Added Artlces
var saveArticleTrue = {$save_article_true}; // Status add article

{literal}
var importMass = new Class({
	initialize: function( category, index ){
		this.category = category;
		this.first = $('fieldset_file');
		this.nameLinkDelete = 'fieldset_delete';
		this.index=index;
		this.arrError = new Array();
		this.errIndex = 0;
	},
	addFieldset: function(){
		var fieldset = new Element('fieldset');
		var legend = new Element('legend');
		var a = new Element('a',{'class':this.nameLinkDelete,'href':'#'}).set('html', '- delete');
		a.inject( legend.inject( fieldset,'top' ) );
		
		var p_category = new Element('p');
		var label_category = new Element('label').set('html','Category <em>*</em>');
		var select = new Element('select',{'name':'import[category]['+this.index+']', 'class':'category_file required medium-input'});

		var option = new Element('option',{'value':'0'}).set('html','- select category -');
		option.inject(select,'top');
				
		var hash = new Hash(this.category);
		hash.each(function(value, key){
			var option = new Element('option', {'value': value.id}).set('html',value.name);
			option.inject(select,'bottom');
		});
		
		label_category.inject(p_category,'top');
		select.inject(p_category,'bottom');

		var p_file = new Element('p');
		var label_file = new Element('label').set('html', 'File <em>*</em>');
		var input = new Element('input', {'type':'file', 'name':'import[file]['+this.index+']', 'class':'file required medium-input'});
		
		label_file.inject(p_file,'top');
		input.inject(p_file,'bottom');

		p_category.inject(fieldset,'bottom');
		p_file.inject(fieldset,'bottom');
		fieldset.inject(this.first,'after');
		this.deleteFieldset();
	},
	deleteFieldset: function(){
		$$('a.'+this.nameLinkDelete).each(function(el){
			el.addEvent('click',function(e){
				e.stop();
				if(el.getParent('fieldset'))
				el.getParent('fieldset').destroy();
			});
		});
	},
	deleteAllFiledset:function(){
		$$('a.'+this.nameLinkDelete).each(function(el){
				el.getParent('fieldset').destroy();
		});		
	}, 
	displayFileBlock:function(){
		$('fieldset_file').style.display='block';
		$('fieldset_manually').style.display='none';
	},
	displayManually:function(){
		$('fieldset_file').style.display='none';
		$('fieldset_manually').style.display='block';
		this.deleteAllFiledset();
	}, 
	validateBlock:function(){
		var saveAccordion=objAccordion;
		objAccordion=undefined;
		validator.checker.reset();
		validator.reinit($$('form.validate')[0]);
		this.errIndex=0;
		$$('input.required, textarea.required').each(function(el){
			if  ( el.value == "" && el.getParent('p').getParent('fieldset').style.display!='none' ) {
				validator.checker.validateField( el , true);
				this.errIndex=this.errIndex+1;
			}
		},this);
		$$('input.validate-one-required').each(function(el){
			var isset=false;
			$$('input[name="'+el.get('name')+'"]').each(function(el_test){
				if( el_test.checked ){
					isset=true;
				}
			});
			if  ( !isset ) {
				validator.checker.validateField( el , true);
				this.errIndex=this.errIndex+1;
			}
		},this);
		$$('select.required').each(function(el){
			if ( ( el.value == "" || el.value == "0" ) && el.getParent('p').getParent('fieldset').style.display!='none' ) {
				validator.checker.validateField( el , true);
				this.errIndex=this.errIndex+1;
			}
		},this);
		objAccordion=saveAccordion;
		if ( this.errIndex > 0 ) {
			this.errIndex=0;
			return false;
		}
		return true;
	},
	deleteAllError:function(){
		$$('span.errors_span').each(function(el){
			el.destroy();
		});
	}
});

window.addEvent('domready',function(){
	var obj = new importMass(category,index);
	obj.deleteFieldset();
	$$('input.article_source').each(function(el){
		el.addEvent('click', function(){
			var obj = new importMass(category,index);
			if(el.value == 'text_file'){
				obj.displayFileBlock();
			} else if (el.value == 'manually') {
				obj.displayManually();
			} else if (el.value == 'zip_file') {
				obj.displayFileBlock();
			}
		});
	});

	if( $('add') ) {
		$('add').addEvent('click', function(e){
			e.stop();
			index++;
			var obj = new importMass(category,index);
			obj.addFieldset();
		});
	}

	$$('.create_new_category').addEvent( 'click', function(elt){
		if( elt.target.checked ){
			elt.target.getParent().getChildren('input[type="text"]').setStyle('display','inline');
			elt.target.getParent().getChildren('select').setStyle('display','none');
		}else{
			elt.target.getParent().getChildren('input[type="text"]').setStyle('display','none');
			elt.target.getParent().getChildren('select').setStyle('display','inline');
		}
	});
	
});
</script>{/literal}