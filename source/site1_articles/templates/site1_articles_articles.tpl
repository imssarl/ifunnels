{if $msg}
{include file='../../message.tpl' type='info' message="Article successful $msg"}
{/if}
{include file='../../box-top.tpl' title=$arrNest.title}
<form action="" id="post_form" method="post">
    <table class="table  table-striped">
		<tr>
			<td colspan="8">
				<div class="bulk-actions align-left">
					Category <select name="category" id='category-filter' class="btn-group selectpicker show-tick">
				    	<option value=''> - select -</option>
						{html_options options=$arrSelect.category selected=$smarty.get.category}
				    </select>
				    <button type="button" class="button btn btn-success waves-effect waves-light" id="filter">Filter</button>
				</div>
			</td>
		</tr>
        <thead>
        <tr>
            <th>
                
                <div class="checkbox checkbox-primary" style="margin: 0;">
                    <input type="checkbox" id="sel"/>
                    <label style="min-height: 14px;"></label>
                </div>
            </th>
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
                <td>
                    <div class="checkbox checkbox-primary">
                        <input type="checkbox" value="{$v.id}" name="ids[]" class="check-me-sel"/>
                        <label></label>
                    </div>
                    
                </td>
                <td>{$v.category_title}</td>
                <td>{$v.title}</td>
                <td>{$v.summary}...</td>
                <td>{$v.source_title}</td>
                <td>{if $v.flg_status}Active{else}Inactive{/if}</td>
                <td>{$v.date}</td>
                <td width="140">
                    <a {is_acs_write} href="{url name='site1_articles' action='edit'}?id={$v.id}" title="Edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
                    <a {is_acs_write} href="{url name='site1_articles' action='getcode'}?id={$v.id}&type=art" style="float:left" class="mb" title="Code for '{$v.title}' article"><i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i></a>
                    <a {is_acs_write} href="{url name='site1_articles' action='articles'}?dup={$v.id}" title="Duplicate"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></a>
                    <a {is_acs_write} href="{url name='site1_articles' action='articles'}?del={$v.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
                </td>
            </tr>
			{/foreach}
        </tbody>
        <tfoot>
        <tr>
            <td colspan="8">
                <div class="bulk-actions align-left">
                    <select name="action" id="actions" class="btn-group selectpicker show-tick">
                        <option value="">Choose an action...</option>
                        <option value="Export">Export</option>
                        <option value="Delete">Delete</option>
                    </select>
                    <a class="button apply-to-selected" href="#" {is_acs_write} >Apply to selected</a>
                </div>
				{include file="../../pgg_backend.tpl"}
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
	$('actions').addEvent('change',function(){
		if( this.get('value')=='Export' ){
			$('post_form').set('action',exportLink);
        } else {
			$('post_form').set('action','');
        }
    });
	$('filter').addEvent('click', function (e) {
     e.stop();
     var myURI = new URI();
     if ($('category-filter').value == '') {
         myURI.setData(new Hash(myURI.getData()).filter(function (value, key) {
             return key != 'category';
         }));
     } else {
         myURI.setData({category:$('category-filter').value}, true);
     }
     myURI.go();
 });
	{/literal}
</script>
