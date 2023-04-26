{literal}
<style type="text/css">
	.item {
		width:255px;
		height:250px;
		padding:3px;
		float:left;
		border: 2px solid #f0f0f0;
		margin: 5px;
	}
	.item .item_description, .item .item_description_full {
		width:230px;
		height:70px;
		position:absolute;
		top:0;
		font-size:14px;
		line-height:16px;
		text-align:center;
	}
	.item .item_description_full {
		height:auto;
		max-height:220px;
		overflow: auto;
		background-color: #f0f0f0;
		display:none;
	}
	.item .item_description_box {
		margin:5px 0;
		width:230px;
		height:70px;
		position:relative;
	}
	.item:hover {
		background-color: #f0f0f0;
	}
</style>
{/literal}
<div>
	<form method="post" class="wh" action="{Core_Module_Router::$uriFull}" name="r_set" id="r_set">
	
		<input type="hidden" name="change_group" value="" id="change_group">
		<div>
			<b>Select Group</b>: 
			<select name="arrR[group_id]" class="elogin form-control" style="width:50%;" onchange="$('change_group').value=1;r_set.submit();">
				<option value="0"> - select - </option>
				{html_options options=$arrG selected=$smarty.request.group_id}
			</select>
		</div>
		<div>
			<input type="submit" name="save" value="Save changes">
		</div>
		
		<div>
			<b>Select Network</b>: 
			<select class="form-control" id="select_network" name="network_filter">
				<option value="">-- Select --</option>
				<option value="Warrior_Plus">Warrior Plus</option>
				<option value="Jvzoo">Jvzoo</option>
				<option value="Clickbank">Clickbank</option>
				<option value="PaykickStart">PaykickStart</option>
				<option value="Zaxaa">Zaxaa</option>
				<option value="ThriveCart">ThriveCart</option>
				<option value="JVShare">JVShare</option>
				<option value="Paydtotcom">Paydtotcom</option>
				<option value="Clickfunnels">Clickfunnels</option>
				<option value="Other">Other</option>
			</select>
		</div>

		<fieldset>
			<legend>Select Rights</legend>
			<ol>
				<li>
					<label for="g_sel_all">select all</label><input type="checkbox" onClick="toggle_checkbox('r_set',this);" id="g_sel_all" />
				</li>
				{foreach from=$arrTemplates item=template}
				<li class="item all_network network_{$template.network}">
					<div class="item_description_box">
						<div class="item_description">{$template.settings.template_description|strip_tags:true|truncate:125:'...':true:true}</div>
						<div class="item_description_full">{$template.settings.template_description}</div>
					</div>
					<div>
						<img src="{img src=".{$templates_link}{$template.settings.template_hash}.jpg" w=230 h=150}" data-img=".{$templates_link}{$template.settings.template_hash}.jpg" width="230" height="150" class="image_item" />
					</div>
					<center style="z-index:999;">
					Add <input type="checkbox" class="{$type}-checkbox all-checkboxes network-checkbox-{$template.network}" id="id-{$template.id}" value="{$template.id}" {if in_array($template.id,$selectedTemplates)} checked="checked" {/if} name="arrT[]" />
					&nbsp;<a href="{$template.url}" target="_blank">Preview</a>&nbsp;<a href="?update_image={base64_encode($template.url)}&id={$template.id}">Update Image</a>
					&nbsp;<a href="{url name='site1_squeeze' action='template_settings' wg="id={$template.id}"}" class="mb">Settings</a>
					</center>
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
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'50%',
		height:'100%',
		displayTitle: true,
		titleFormat: 'title'
	});
	
	$( 'select_network' ).addEvent('change', function(){
		$$( '.all_network' ).hide();
		$$( '.all-checkboxes' ).set('disabled', true);
		$$( '.network_'+this.get('value') ).show();
		$$( '.network-checkbox-'+this.get('value') ).set('disabled', false);
	} );
	
});
</script>
{/literal}