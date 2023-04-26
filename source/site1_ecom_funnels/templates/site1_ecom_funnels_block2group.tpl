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

			{foreach from=$arrBlocks item=block}
			<div class="efunnel">
				<div class="checkbox-button inline-block v-a-top m-t-3">
					<input type="checkbox" class="{$type}-checkbox" id="id-{$block.id}" value="{$block.id}" {if in_array($block.id,$selectedBlocks)} checked="checked" {/if} name="arrB[]" />
					<label for="id-{$block.id}"></label>
				</div>&nbsp;
				<div class="inline-block">
					<img src="{Zend_Registry::get('config')->path->html->pagebuilder}{$block.blocks_thumb}" alt="" style="max-width: 600px;" />
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