{include file='../../box-top.tpl' title=$arrNest.title}
{include file='../../error.tpl'}
<form method="post" action="" id='manage_category'>
<table class="table  table-striped">
	<thead>
        <tr>
            <th width="1">Del</th>
            <th width="1">Active</th>
            <th width="1">&nbsp;</th>
            <th>Category name</th>
			{if $arrType.flg_sort}
            <th>Priority</th>
			{/if}
            <th width="70px">Number of article</th>
            <th width="70px">Show article list</th>
            <th width="70px">Get code</th>
        </tr>
	</thead>
	<tbody>
		{foreach from=$arrCats key='k' item='v'}
        <tr{if $k%2=='0'} class="alt-row"{/if}>
            <input type="hidden" name="arrCats[{$v.id}][id]" value="{$v.id}">
            <td style="padding-right:0;" valign="top">
            	<div class="checkbox checkbox-primary">
            		<input type="checkbox" name="arrCats[{$v.id}][del]" class="del-me"/>
            		<label></label>
            	</div>
            </td>
			{foreach from=$arrFlags key='fk' item='f'}
				{assign var="name" value="flag`$fk`"}
                <td style="padding-right:0;" valign="top">
                	<div class="checkbox checkbox-primary">
                		<input type="checkbox" name="arrCats[{$v.id}][flag{$fk}]"{if $v.$name}checked{/if} />
                		<label></label>
                	</div>
                </td>
			{/foreach}
			{assign var="error" value=$v.id}
            <td>{if $arrErr.$error}<span class="red">*</span>{/if}</td>
            <td valign="top">
                <input type="text" style="width:100%;" name="arrCats[{$v.id}][title]" class="form-control" value="{$v.title}"/>
                <div style="display:none;" id="items_{$v.id}">
					{foreach from=$v.items item='item'}
                        <div><a href="{url name='site1_articles' action='showarticle'}?id={$item.id}" class="mb"
                                title="'{$item.title}' preview">{$item.title}</a></div>
					{/foreach}
                </div>
            </td>
			{if $arrType.flg_sort}
                <td valign="top"><input type="text" class="elogin" name="arrCats[{$v.id}][priority]" value="{$v.priority}"/></td>
			{/if}
            <td align="center" valign="top">{$v.count}</td>
            <td align="center" valign="top">
				{if $v.items}
                    <a href="#" class="switch" rel="{$v.id}" title="Articles in '{$v.title}' category"><i class="ion-arrow-down-c" style="font-size: 20px; vertical-align: bottom; color: #ADD56A; margin: 0 5px;" id="img_{$v.id}"></i>
                        <!--<img src="/skin/i/frontends/design/go-down.gif" />--></a>
				{/if}
            </td>
            <td align="center" valign="top">
				{if $v.items}
                    <a href="{url name='site1_articles' action='getcode'}?id={$v.id}&type=cat" class="mb" title="Code for '{$v.title}' category">
                        <!--<img title="View" src="/skin/i/frontends/design/buttons/view.gif" id="get_{$v.id}"/>-->
                        <i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;" id="get_{$v.id}"></i>
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
			{foreach from=$arrFlags key='fk' item='f'}
			<td style="padding-right:0;">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arrCats[0][flag{$fk}]" checked=""/>
					<label></label>
				</div>
			</td>
			{/foreach}
			<td>&nbsp;</td>
			<td valign="top">add new:<input type="text" style="width:100%;" name="arrCats[0][title]" class="form-control" value=""/></td>
			{if $arrType.flg_sort}
			<td valign="top"><input type="text" class="elogin" name="arrCats[0][priority]" value=""/></td>
			{/if}
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<button type="submit" class="btn btn-success waves-effect waves-light">Update</button>
				<!--<input type="submit" class="button" value="Update" {is_acs_write}  />-->
			</td>
		</tr>
	</tfoot>
</table>
</form>
{include file="../../pgg_frontend.tpl"}


{include file='../../box-bottom.tpl'}
<script type="text/javascript">
	{literal}
    $$('.switch').each(function (el) {
        el.addEvent('click', function (e, el) {
            el && el.stop();
            var obj = $('items_' + e.rel);
            obj.style.display = obj.style.display == 'none' ? 'block' : 'none';
            $('img_' + e.rel).src = obj.style.display == 'none' ? '/skin/i/frontends/design/go-down.gif' : '/skin/i/frontends/design/go-up.gif';
        }.bind(this, el));
    });

    $('manage_category').addEvent('submit', function (e) {
        if ($$('.del-me').some(function (item) {
            return item.checked == true;
        })) {
            if (!confirm('Are you sure you want to delete this category?\nPlease note that all articles stored under that category will be deleted too.')) {
                e.stop();
            }
        }
    });
var multibox = {};
window.addEvent("domready", function(){
	$$('.mb').cerabox({
		group:false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle:true,
		titleFormat:'{title}'
	});
});
</script>
{/literal}