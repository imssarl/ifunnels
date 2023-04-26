<script type="text/javascript" src="/skin/_js/typedtags.js"></script>
{include file="../../error.tpl"}
<form method="post" action="" class="wh validate" >
	<input type="hidden" name="arrData[id]" value="{$arrData.id}" />
	<fieldset>
		<p>
			<label>Category: <em>*</em></label>
			<select class="required medium-input" name="arrData[category_id]">
				<option value=''> - select - </option>
				{html_options options=$arrSelect.category selected=$arrData.category_id}
			</select>
		</p>
		<p>
			<label><span>Source:</span></label>
			<select name="arrData[source_id]" class="medium-input" id="stencil_category">
				<option value=''> - select - </option>
				{html_options options=$arrSelect.source selected=$arrData.source_id}
			</select>
		</p>
		<p>
			<label><span{if $arrErr.title} class="red"{/if}>Title: <em>*</em></span></label>
			<input type="text" name="arrData[title]" value="{$arrData.title}" id="stencil_title" class="required medium-input text-input"/>
		</p>
		<p>
			<label for="stencil_body"><span>Embed Code:</span></label>
			<textarea name="arrData[body]" class="textarea text-input" rows="6" id="stencil_body">{$arrData.body}</textarea><br/><small>(at least either Embed Code or URL cannot be empty)</small>
		</p>
		<p>
			<label><span>URL of Video:</span></label>
			<textarea name="arrData[url_of_video]" rows="6" class="textarea text-input" id="stencil_url_of_video">{$arrData.url_of_video}</textarea><br/><small>(at least either Embed Code or URL cannot be empty)</small>
		</p>
		<p>
			<label>Tags</label>{module name='tags' action='getlist' type='video' item_id=$arrData.id textarea_name='arrData[tags]' search_href='./'}
		</p>
		<p><input value="{if $arrData}Edit{else}Create{/if}" type="submit" class="button" {is_acs_write} ></p>
	</fieldset>
</form>