<div class="form-group">
	<fieldset>
		<div class="form-group">
			<label>Post title</label>
			<input type="text" name="arrBlog[first_post_title]" class="text-input medium-input form-control" value="{$arrBlog.first_post_title}">
		</div>
		<div class="form-group">
			<label>Post description</label>
			<textarea name="arrBlog[first_post_description]" class="text-input textarea form-control" style="height:100px;">{$arrBlog.first_post_description}</textarea>
		</div>
		<div class="form-group">
			<label>Post tags</label>
			<input type="text" name="arrBlog[first_post_tags]" class="text-input medium-input form-control" value="{$arrBlog.first_post_tags}"/>
		</div>
		<div class="form-group">
			<a href="#" class="acc_prev button">Prev step</a>  <a href="#" class="acc_next button" rel="3">Next step</a>
		</div>
	</fieldset>
</div>
