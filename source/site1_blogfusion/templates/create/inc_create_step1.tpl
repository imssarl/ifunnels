<div class="form-group">
	<fieldset>
		<div class="form-group">
			<label>Select Category <em>*</em></label>
			<select id="category" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick">
				<option value="0"> - select -
				{foreach from=$arrCategories item=i}
				<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
				{/foreach}
			</select>
			<select name="arrBlog[category_id]" class="required validate-custom-required emptyValue:'0' medium-input btn-group selectpicker show-tick" id="category_child" ></select>
		</div>
		<div class="form-group">
			<small>You can pick up the theme of your choice using the drop down menu or our Wordpress<br/> Theme Wall directly</small>
			<label>Select Theme</label>
			<select name="arrBlog[theme_id]" id="theme" class="medium-input btn-group selectpicker show-tick">
				{foreach from=$arrThemes item=i}
				<option value="{$i.id}" title='{img src=".`$i.preview`" w=282 h=231}' {if $arrBlog.theme[0]==$i.id}selected='1'{/if}  class="theme_option test {if $i.flg_prop} prop{/if}" >{$i.title}</option>
				{/foreach}
			</select><br/>
			<label></label><a  href="{url name='site1_blogfusion' action='multiboxtheme'}" class="mb">Use Wordpress Theme Wall to select a theme VISUALLY</a>
			<div id="themeImg" align="center" style="padding:10px;"></div>
		</div>
		{if !$arrBlog.id}
		<div class="form-group">
			<label>Default Category Name</label>
			<input type="text" name="arrBlog[blog_default_category]" class="text-input medium-input form-control" value="{$arrBlog.blog_default_category}" />
		</div>
		<div class="form-group">
			<label>Enter the blog content categories</label>
			<textarea class="text-input textarea form-control" style="height:50px;" name="arrBlog[blog_categories]" >{$arrBlog.blog_categories}</textarea>
			<small>e.g. Affiliate Marketing, Social Networking, Social Bookmarking</small>
		</div>
		{/if}
		<div class="form-group">
			<label>Blog Name <em>*</em></label>
			<input class="required {if $arrErr.filtered.title}error{/if} text-input medium-input form-control"  title="Blog Name" value="{$arrBlog.title|escape}" type="text" name="arrBlog[title]" />
		</div>
		<div class="form-group">
			<label>Blog Tag Line</label>
			<input type="text" value="{$arrBlog.blogtag_line}" class="text-input medium-input form-control" name="arrBlog[blogtag_line]" />
		</div>
		<div class="form-group">
			<a href="#" class="acc_prev button">Prev step</a> <a href="#" class="acc_next button" rel="1">Next step</a>
		</div>
	</fieldset>
</div>