<script type="text/javascript" src="/skin/_js/typedtags.js"></script>
{include file='../../box-top.tpl' title=$arrNest.title}
{include file='../../error.tpl'}
<form method="post" action="" class="wh validate" id="create_article">
<input type="hidden" name="arrArticle[id]" value="{$arrArticle.id}" />
	<small>Please complete the form below. Mandatory fields are marked with <em>*</em></small>
	<fieldset>
		<div class="form-group">
			<label for="source"><span{if $arrErr.source} class="red"{/if}>Source <em>*</em></span></label>
			<select name="arrArticle[source_id]" id="source" class="required  medium-input btn-group selectpicker show-tick">
				<option value=''> - select - </option>
				{html_options options=$arrSelect.source selected=$arrArticle.source_id}
			</select>
		</div>
		<div class="form-group">
			<label for="category"><span{if $arrErr.category_id} class="red"{/if}>Category <em>*</em></span></label>
			<select name="arrArticle[category_id]" id="category" class="required medium-input btn-group selectpicker show-tick">
				<option value=''> - select - </option>
				{html_options options=$arrSelect.category selected=$arrArticle.category_id}
			</select>
		</div>
		<div class="form-group"><label for="title"><span{if $arrErr.title} class="red"{/if}>Title <em>*</em></span></label>
			<input name="arrArticle[title]" type="text" id="title" value="{$arrArticle.title|escape:"html"}" maxlength="150" class="required text-input  medium-input form-control" />
			<br/><small>(insert character width less then 150)</small>
		</div>
		<div class="form-group">
			<label for="author"><span{if $arrErr.author} class="red"{/if}>Author <em>*</em></span></label>
			<input name="arrArticle[author]" type="text" id="author" value="{$arrArticle.author|escape:"html"}" class="required text-input  medium-input form-control"/>
		</div>
		<div class="form-group">
			<label for="summary"><span{if $arrErr.summary} class="red"{/if}>Summary <em>*</em></span></label>
			<textarea name="arrArticle[summary]" id="summary" rows="2" cols="50" class="required text-input textarea form-control">{$arrArticle.summary|escape:"html"}</textarea>
		</div>
		<div class="form-group">
			<label for="body"><span{if $arrErr.body} class="red"{/if}>Body <em>*</em></span></label>
			<textarea name="arrArticle[body]" id="body" rows="5" cols="50" class="required text-input textarea form-control">{$arrArticle.body|escape:"html"}</textarea>
		</div>
		<div class="form-group">
			<div class="form-group"><label>Tags</label></div>
			{module name='tags' action='getlist' type='articles' item_id=$arrArticle.id textarea_name='arrArticle[tags]' search_href='./'}
		</div>
		<div class="form-group">
			<label>Status</label>
			<div class="radio radio-primary">
				<input name="arrArticle[flg_status]" value="1" type="radio"{if !isset($arrArticle.flg_status)||$arrArticle.flg_status=='1'} checked{/if}>
				<label>Active</label>
			</div>
			<div class="radio radio-primary">
				<input name="arrArticle[flg_status]" value="0" type="radio"{if $arrArticle.flg_status=='0'} checked{/if}>
				<label>InActive</label>
			</div>
		</div>
		<div class="form-group">
			<button class="btn btn-success waves-effect waves-light" type="submit">{if $arrArticle.id}Update{else}Add{/if} article</button>
			<!--<input value="" class="button" {is_acs_write} type="submit">-->
		</div>
	</fieldset>

</form>
{include file='../../box-bottom.tpl'}