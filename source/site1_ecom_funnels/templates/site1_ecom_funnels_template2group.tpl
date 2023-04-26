<div>
	<form method="post" action="{Core_Module_Router::$uriFull}" name="r_set" id="r_set">
		<input type="hidden" name="change_group" value="" id="change_group">
		<div>
			<b>Select Group</b>: 
			<select name="arrR[group_id]" class="elogin form-control" style="width:50%;" onchange="$('change_group').value=1;r_set.submit();">
				<option value="0"> - select - </option>
				{html_options options=$arrG selected=$smarty.request.group_id}
			</select>
			<input type="submit" name="save" value="Save changes">
		</div>

		<div>
			<legend>
				Select what is available 
				<div class="checkbox-button inline-block m-l-20">
					<input type="checkbox" onClick="toggle_checkbox('r_set',this);" id="g_sel_all" />
					<label for="g_sel_all"> select all</label>
				</div>
			</legend>

			{foreach from=$arrTemplates item=template}
			<div class="efunnel">
				<div class="checkbox-button inline-block v-a-top m-t-3">
					<input type="checkbox" class="{$type}-checkbox" id="id-{$template.id}" value="{$template.id}" {if in_array($template.id,$selectedTemplates)} checked="checked" {/if} name="arrT[]" />
					<label for="id-{$template.id}"></label>
				</div>&nbsp;
				<div class="inline-block">
					<h2>{$template.sites_name}</h2>
				</div>
			</div>
			{/foreach}
		</div>
	</form>
</div>
	
{literal}
<script type="text/javascript">
	window.addEvent('domready', function(){
		$$('.select-all').each(function(input){
			input.addEvent('click',function(){
				$$('.'+input.get('value')+'-checkbox').each(function(el){
					el.set('checked',input.get('checked'));
				});
			});
		});
	});
</script>
{/literal}