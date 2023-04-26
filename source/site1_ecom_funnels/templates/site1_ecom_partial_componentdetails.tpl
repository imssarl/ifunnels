<div class="divBlockDetailsWrapper">
	<input type="hidden" name="componentID" value="{$forTemplate.component.id}">
	<div class="row">
		<div class="col-md-12 blockThumbnail">
			<img src="{Zend_Registry::get('config')->path->html->pagebuilder}{$forTemplate.component.components_thumb}" class="center-block img-responsive">
		</div><!-- /.row -->
	</div><!-- /.row -->
	<div class="row" style="margin-top: 20px; margin-bottom: 20px;">
		<div class="col-md-6">
			<label for="exampleInputEmail1">Component thumbnail</label>
			<input type="file" name="componentThumbnail">
		</div>
		<div class="col-md-6">
			<label for="exampleInputEmail1">Component category</label>
			<select class="form-control select select-default select-block select-sm mbl" name="componentCategory" style="width: 100%; min-width: 0;">
				{foreach from=$forTemplate.componentCategories item=componentCategory}
				<option {if $componentCategory.id == $forTemplate.component.components_category}selected{/if} value="{$componentCategory.id}">{$componentCategory.category_name}</option>
				{/foreach}
			</select>
		</div>
	</div><!-- /.row -->
	<div class="row">
		<div class="col-md-12">
			<div class="form-group margin-bottom-0">
				<label for="exampleInputEmail1" class="col-md-12 row">Component markup</label>
				<textarea name="componentMarkup" id="textareaComponentMarkup" style="display: none;">{$forTemplate.component.components_markup}</textarea>
				<div id="aceEditComponent" class="col-md-12"></div>
			</div>
		</div><!-- /.col -->
	</div><!-- /.row -->
</div>

<script src="{Zend_Registry::get('config')->path->html->pagebuilder}assets/js/vendor/ace/ace.js" type="text/javascript" charset="utf-8"></script>
<script>
	let editor = ace.edit( 'aceEditComponent' );
	editor.setTheme("ace/theme/twilight");
	editor.getSession().setUseWrapMode(true);
	editor.getSession().setUseWorker(false);
	editor.getSession().setMode("ace/mode/html");
	editor.getSession().setValue($('#textareaComponentMarkup').val());
	editor.getSession().on('change', function(){
		$('#textareaComponentMarkup').val(editor.getSession().getValue());
	});
	editor.setOptions({
		maxLines: Infinity
	});
</script>