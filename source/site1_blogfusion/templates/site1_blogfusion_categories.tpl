{include file="site1_blogfusion_general_menu.tpl"}
<div style="padding-top:10px;margin:0 auto;width:80%;">
    <form method="post" action="" id='manage_category'>
        <table>
            <thead>
            <tr>
                <th width="1px">Del</th>
                <th>Category name</th>
            </tr>
            </thead>
            <tbody>
			{foreach from=$arrList key=k item=i}
            <input type="hidden" name="arrList[{$i.id}][id]" value="{$i.id}"/>
            <input type="hidden" name="arrList[{$i.id}][ext_id]" value="{$i.ext_id}"/>
            <input type="hidden" name="arrList[{$i.id}][flg_default]" value="{$i.flg_default}"/>
            <tr {if $k%2=='0'} class="alt-row"{/if}>
                <td valign="top">{if !$i.flg_default}<input type="checkbox" name="arrList[{$i.id}][del]" class="del-me"/>{/if}</td>
                <td valign="top">
                    <input type="text"  name="arrList[{$i.id}][title]" class="text-input large-input" value="{$i.title|escape}"/>
                </td>
            </tr>
			{/foreach}
            </tbody>
            <tfooft>
                <tr>
                    <td colspan="2" valign="top">
						<p><label>Add new:</label><input type="text" name="arrList[0][title]" class="text-input large-input" value=""/></p>
						<p>
							<input type="submit" value="Update" class="button"/>
						</p>
						{include file="../../pgg_frontend.tpl"}
					</td>
                </tr>
            </tfooft>
        </table>
    </form>
</div>

{literal}
<script type="text/javascript">
	$$('.pg_handler').each(function(el){
        el.addEvent('click',function(a){
    		a.stop();
			var href = el.href+{/literal}'&id={$arrBlog.id}'{literal};
    		href.toURI().go();
		});
	});
</script>
{/literal}
</td>
</tr>
</table>