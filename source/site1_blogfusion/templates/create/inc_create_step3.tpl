<div class="form-group">
	<fieldset>
		<div class="form-group">
			<label>Enable Plugins</label>
			<div class="checkbox checkbox-primary">
				<input type="checkbox"  id="plugins_all" value="all" />
				<label>Select All</label>	
			</div>

			{if Core_Acs::haveAccess(array('Blog Fusion CSPP','Blog Fusion CSP'))&&!Core_Acs::haveAccess(array('email test group'))}
				{foreach from=$arrPlugins item=i}
					{if in_array($i.title,array('WordPress SEO','All in One SEO Pack','Google XML Sitemaps'))}
					<div class="checkbox checkbox-primary">
						<input type="checkbox" class="plugins" {if is_array($arrBlog.plugins) && in_array($i.id, $arrBlog.plugins)}checked='1'{/if} name="arrBlog[plugins][]" value="{$i.id}" />
						<label>{$i.title}</label>	
					</div>
					{/if}
				{/foreach}
			{else}
				{foreach from=$arrPlugins item=i}
					<div class="checkbox checkbox-primary">
						<input type="checkbox" class="plugins" {if is_array($arrBlog.plugins) && in_array($i.id, $arrBlog.plugins)}checked='1'{/if} name="arrBlog[plugins][]" value="{$i.id}" />
						<label>{$i.title}</label>	
					</div>
				{/foreach}
			{/if}
		</div>
		<div class="form-group">
			<small>All the selected plugins will be automatically activated at the time of blog creation </small>
		</div>
		<div class="form-group">
			<a href="#" class="acc_prev button">Prev step</a>  <a href="#" class="acc_next button" rel="2">Next step</a>
		</div>
	</fieldset>
</div>