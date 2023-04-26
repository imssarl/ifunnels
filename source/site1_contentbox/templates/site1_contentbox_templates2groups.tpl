<div>
<form method="post" class="wh" action="{Core_Module_Router::$uriFull}" name="r_set" id="r_set">
<input type="hidden" name="change_group" value="" id="change_group">
<div><b>Select Group</b>: <select name="arrR[group_id]" class="elogin" style="width:50%;" onchange="$('change_group').value=1;r_set.submit();">
	<option value="0"> - select - </option>
	{html_options options=$arrG selected=$smarty.request.group_id}
</select></div>

<div><input type="submit" name="save" value="Save changes"></div>

<fieldset>
	<legend>Select Rights</legend>
	<ol>
		<li>
			<label for="g_sel_all">select all</label><input type="checkbox" onClick="toggle_checkbox('r_set',this);" id="g_sel_all" />
		</li>
		{foreach from=$arrTemplates item=template}
		<li class="item">
			<div class="item_description_box">
				<div class="item_description"><input type="checkbox" class="{$type}-checkbox" id="id-{$template.id}" value="{$template.id}" {if in_array($template.id,$selectedTemplates)} checked="checked" {/if} name="arrT[]" /> {$template.name}</div>
			</div>
			
		</li>
		{/foreach}
	</ol>
</fieldset>
</div>
</form>
</div>

{literal}
<script type="text/javascript">

window.addEvent('domready', function(){
	var optTips2 = new Tips('.tips');
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){ el.addEvent('click',function(e){ e.stop(); }); });
	$$('.select-all').each(function(input){
		input.addEvent('click',function(){
			$$('.'+input.get('value')+'-checkbox').each(function(el){
				el.set('checked',input.get('checked'));
			});
		});
	});
	$$('.item').addEvent('mouseenter',function( elt ){
		$$( elt.target.getElementsByClassName('item_description_full')[0] ).show();
	});
	$$('.item').addEvent('mouseleave',function( elt ){
		$$( elt.target.getElementsByClassName('item_description_full')[0] ).hide();
	});
});
</script>
{/literal}