{include file="../../error.tpl"}
<form method="post" action="" id='manage_category'>
<table >
<thead>
	<tr>
		<th width="1px">Del</th>
		<th width="1px">&nbsp;</th>
		<th>Category name</th>
		{if $arrType.flg_sort}
		<th width="1px">Priority</th>
		{/if}
		<th width="70px">Number of videos</th>
		<th width="70px">Show video list</th>
	</tr>
</thead>
	<tbody>
	{foreach from=$arrCats key='k' item='v'}
	<tr{if $k%2=='0'} class="alt-row"{/if}>
		<input type="hidden" name="arrCats[{$v.id}][id]" value="{$v.id}">
		<td style="padding-right:0;" valign="top"><input type="checkbox" name="arrCats[{$v.id}][del]" class="del-me" /></td>
		{assign var="error" value=$v.id}
		<td>{if $arrErr.$error}<span class="red">*</span>{/if}</td>
		<td valign="top">
			<input type="text" class="text-input large-input" style="width:100%;" name="arrCats[{$v.id}][title]" value="{$v.title}" />
			<div style="display:none;" id="items_{$v.id}">
			{foreach $v.items as $item}
				<div><a href="{url name='site1_video_manager' action='view'}?id={$item@key}" class="mb" rel="" title="'{$item}' preview">{$item}</a></div>
			{/foreach}
			</div>
		</td>
		{if $arrType.flg_sort}
		<td valign="top"><input type="text" class="elogin text-input large-input"  name="arrCats[{$v.id}][priority]" value="{$v.priority}" /></td>
		{/if}
		<td align="center" valign="top">{$v.count}</td>
		<td align="center" valign="top">
			{if $v.items}
			<a href="#" class="switch" rel="{$v.id}" title="Videos in '{$v.title}' category">
				<img src="/skin/i/frontends/design/go-down.gif" id="img_{$v.id}" />
			</a>
			{/if}
		</td>
	</tr>
	{/foreach}
	</tbody>
	<tfoot>
	<tr>
		<input type="hidden" name="arrCats[0][id]" value="0">
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td valign="top">add new:<input type="text" class=" text-input large-input" style="width:100%;" name="arrCats[0][title]" value="" /></td>
		{if $arrType.flg_sort}
		<td valign="top"><input type="text" class="elogin" name="arrCats[0][priority]" value="" /></td>
		{/if}
		<td colspan="2">{include file="../../pgg_frontend.tpl"}</td>
	</tr>
	</tfoot>
</table>
<div><input type="submit" value="Update" class="button" {is_acs_write} /></div>
</form>
<script type="text/javascript">
{literal}
$$('.switch').each(function(el){
	el.addEvent('click',function(e){
		e.stop();
		var obj=$('items_'+el.rel);
		obj.style.display=obj.style.display=='none'?'block':'none';
		$('img_'+el.rel).src=obj.style.display=='none'?'/skin/i/frontends/design/go-down.gif':'/skin/i/frontends/design/go-up.gif';
	}.bind(this));
});

$('manage_category').addEvent('submit',function(e){
	if ($$('.del-me').some(function(item){
		return item.checked==true;
	})) {
		if (!confirm('Are you sure you want to delete this category?\nPlease note that all videos stored under that category will be deleted too.')) {
			e.stop();
		}
	}
});
{/literal}
</script>


{literal}
<script>
var multibox = {};
window.addEvent("domready", function(){
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}