<div class="divBlockDetailsWrapper">
	{if isset($forTemplate.info)}{$forTemplate.info}{/if}
	<input type="hidden" name="blockID" value="{$forTemplate.block.id}" />
	<div class="row m-b-20">
		<div class="col-md-12 blockThumbnail">
			<img src="{Zend_Registry::get('config')->path->html->pagebuilder}{$forTemplate.block.blocks_thumb}" class="img-responsive center-block">
		</div><!-- /.row -->
	</div><!-- /.row -->
	<div class="row">
		<div class="col-md-3">
			<div class="form-group margin-bottom-0">
				<label for="exampleInputEmail1">Block category:</label>
				<select class="selectpicker" name="blockCategory">
					{foreach from=$forTemplate.blockCategories item=blockCategory}
					<option {if $blockCategory.id == $forTemplate.block.blocks_category}selected{/if} value="{$blockCategory.id}">
						{$blockCategory.category_name}
					</option>
					{/foreach}
				</select>
			</div><!-- /.form-group -->
		</div><!-- /.row -->
		<div class="col-md-9 blockTemplate">
			<div class="form-group margin-bottom-0">
				<label for="exampleInputEmail1">Choose an existing file:</label><br/>
				<input name="blockUrl" value="{$forTemplate.block.blocks_url}">
				{*
				{assign var="blockUrl" value="{Zend_Registry::get('config')->path->html->pagebuilder}{$forTemplate.block.blocks_url}"}
				<select name="blockUrl" placeholder="URL to HTML file" class="selectpicker">
					{foreach from=$templates item=template}
					<option value="{$template}" {if $template == substr($blockUrl, 1)}selected{/if}>
						{$template}
					</option>
					{/foreach}
				</select>
				*}
			</div><!-- /.form-group -->
			<a href="{url name="site1_ecom_funnels" action="file_edit"}?block_id={$forTemplate.block.id}" target="_blank" class="pull-right">
				Edit block markup
				<span class="fui-export"></span>
			</a>
		</div><!-- /.row -->
	</div><!-- /.row -->
	<div class="row">
		<label class="checkbox col-md-6" for="blockFullHeight">
			<input type="checkbox" value="check" name="blockFullHeight" id="blockFullHeight" data-toggle="checkbox" {if $forTemplate.block.blocks_height == '90vh'}checked{/if}>
			Block uses full height of viewport
			<span class="label label-default heightHelp" data-toggle="tooltip" title="Check this checkbox if you want this block to use the full height of the browser's viewport">?</span>
		</label>
		<label class="checkbox col-md-6" for="remakeThumb">
			<input type="checkbox" value="check" name="remakeThumb" id="remakeThumb" data-toggle="checkbox">
			Remake this block's thumbnail image?
			<span class="label label-default heightHelp" data-toggle="tooltip" title="Recreating the thumbnail here forces the application to use standard dimensions, which may result in the image looking blurry or off. For a better screenshot, use the page builder itself to re-generate the thumbnail.">?</span>
		</label>
	</div><!-- /.row -->
</div>