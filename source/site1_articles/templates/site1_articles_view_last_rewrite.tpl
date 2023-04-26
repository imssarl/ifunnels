{if $msg}
{include file='../../message.tpl' type='info' message="Article successful $msg"}
{/if}
{include file='../../box-top.tpl' title=$arrNest.title}
<form action="" id="post_form" method="post">
    <table>
        <thead>
        <tr>
            <th width="80">Category&nbsp;{if $arrPg.recall>1}{if $arrFilter.order!='category_title--up'}<a
                    href="{url name='site1_articles' action='articles' wg='order=category_title--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='category_title--dn'}<a
                    href="{url name='site1_articles' action='articles' wg='order=category_title--dn'}"><img
                    src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}{/if}</th>
            <th>Title&nbsp;{if $arrPg.recall>1}{if $arrFilter.order!='title--up'}<a
                    href="{url name='site1_articles' action='articles' wg='order=title--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='title--dn'}<a
                    href="{url name='site1_articles' action='articles' wg='order=title--dn'}"><img
                    src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}{/if}</th>
            <th>Summary</th>
            <th>Source&nbsp;{if $arrPg.recall>1}{if $arrFilter.order!='source_title--up'}<a
                    href="{url name='site1_articles' action='articles' wg='order=source_title--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='source_title--dn'}<a
                    href="{url name='site1_articles' action='articles' wg='order=source_title--dn'}"><img
                    src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}{/if}</th>
            <th width="8%">Status&nbsp;{if $arrPg.recall>1}{if $arrFilter.order!='flg_status--up'}<a
                    href="{url name='site1_articles' action='articles' wg='order=flg_status--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='flg_status--dn'}<a
                    href="{url name='site1_articles' action='articles' wg='order=flg_status--dn'}"><img
                    src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}{/if}</th>
            <th width="8%">Added&nbsp;{if $arrPg.recall>1}{if $arrFilter.order!='added--up'}<a
                    href="{url name='site1_articles' action='articles' wg='order=added--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='added--dn'}<a
                    href="{url name='site1_articles' action='articles' wg='order=added--dn'}"><img
                    src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}{/if}</th>
            <th>&nbsp;</th>
        </tr>
        </thead>
        <tbody>

			{foreach from=$arrList key='k' item='v'}
            <tr{if $k%2=='0'} class="alt-row"{/if}>
                <td>{$v.category_title}</td>
                <td>{$v.title}</td>
                <td>{$v.summary}...</td>
                <td>{$v.source_title}</td>
                <td>{if $v.flg_status}Active{else}Inactive{/if}</td>
                <td>{$v.date}</td>
                <td width="100">
                    <a {is_acs_write} href="{url name='site1_articles' action='edit'}?id={$v.id}"><img title="Edit" src="/skin/i/frontends/design/newUI/icons/pencil.png"/></a>
                    <a {is_acs_write} href="{url name='site1_articles' action='getcode'}?id={$v.id}&type=art" style="float:left" class="mb" title="Code for '{$v.title}' article"><img title="Code for '{$v.title}' article" src="/skin/i/frontends/design/buttons/view.gif"/></a>
                    <a {is_acs_write} href="{url name='site1_articles' action='articles'}?dup={$v.id}"><img title="Duplicate" src="/skin/i/frontends/design/buttons/duplicate.png"/></a>
                    <a {is_acs_write} href="{url name='site1_articles' action='articles'}?del={$v.id}"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png"/></a>
                </td>
            </tr>
			{/foreach}
        </tbody>
        <tfoot>
        <tr>
            <td colspan="8">
                <!-- End .pagination -->
                <div class="clear"></div>
            </td>
        </tr>
        </tfoot>
    </table>

</form>
{include file='../../box-bottom.tpl'}


<script type="text/javascript">
    var exportLink = '{url name='site1_articles' action='export'}';
	{literal}
    window.addEvent("domready", function(){
       $$('.mb').cerabox({
            group:false,
        	width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
    		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
        	displayTitle:true,
        	titleFormat:'{title}'
    	});
    });
    checkboxToggle($('sel'));
	{/literal}
</script>
