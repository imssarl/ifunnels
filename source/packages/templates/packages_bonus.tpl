{if !empty($msg)}
	<div class="grn">Credits have been added.</div>
{/if}
<form action="" method="post" class="wh validate">
	<fieldset>
		<ol>
			<li>
				<label>Packages: <em>*</em></label><select style="height:300px" class="required" name="arrData[package_ids][]" multiple="1">
					{foreach from=$arrPackages item=i}
						<option value="{$i.id}">{$i.title}</option>
					{/foreach}
				</select>
			</li>
			<li>
				<label>Credits: <em>*</em></label><input type="text" name="arrData[credits]" value="" class="required" />
			</li>
			<li>
				<label></label><input type="submit" value="Add bonus" id="submit" />
			</li>
		</ol>
	</fieldset>
</form>

{literal}
<script type="text/javascript">
	window.addEvent('load',function(){
	});
</script>
{/literal}