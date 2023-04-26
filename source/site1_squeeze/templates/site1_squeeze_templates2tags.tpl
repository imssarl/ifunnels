<form method="post" class="wh" action="{Core_Module_Router::$uriFull}" name="r_set" id="r_set">
<input type="submit" name="update" value="Update all changes"></div>
<fieldset>
	<table>
		{foreach from=$arrTemplates item=template}
		<tr>
			<td width="350px">
				<div class="item_description_full">{$template.settings.template_description}</div>
			</td>
			<td>
				<img src="{$templates_link}{$template.settings.template_hash}.jpg" width="130" height="80" class="image_item" />
			</td>
			<td width="550px">
				<input type="hidden"  value="{$template.settings.template_tags}" name="arrTags[{$template.id}][old]" />
				<textarea style="width:550px;height:100px;" name="arrTags[{$template.id}][new]">{$template.settings.template_tags}</textarea>
			</td>
		</tr>
		{/foreach}
	</table>
</fieldset>
</form>

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