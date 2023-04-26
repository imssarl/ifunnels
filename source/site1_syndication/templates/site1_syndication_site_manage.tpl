
{if $msg == 'delete'}
{include file='../../message.tpl' type='info' messages='Site has been deleted'}
	{elseif $msg=='delete_error'}
<div class="red">Site can't be deleted</div>
{include file='../../message.tpl' type='error' messages='Site can\'t be deleted'}
	{elseif $msg=='added'}
{include file='../../message.tpl' type='info' messages='Site has been added'}
	{elseif $msg=='add_error'}
{include file='../../message.tpl' type='error' messages='Site can\'t be added'}
{/if}
{if $error}
{include file='../../message.tpl' type='error' messages=$error}
{/if}
<br/>
Add site
{if Core_Acs::haveAccess( 'email test group','CNM1.0' )}
<a href="{url name='site1_ncsb' action='multiboxlist'}" class="mb" rel="">NCSB</a>
&nbsp;&nbsp;&nbsp;<a href="{url name='site1_nvsb' action='multiboxlist'}" class="mb" rel="">NVSB</a>
{/if}
&nbsp;&nbsp;&nbsp;<a href="{url name='site1_blogfusion' action='multiboxlist'}?noversion=1" class="mb" rel="">Blog
    fusion</a>
<br/>
<br/>
<table>
	<tr>
		<td colspan="3">
			    <form action="" method="GET" id="filter-form">
			        Site type: <select name="site_type" id="filter_type" class="small-input">
			    <option value="">- select -
				{if Core_Acs::haveAccess( 'email test group','CNM1.0' )}
			        <option {if $smarty.get.site_type == 2}selected='1'{/if} value="2">NCSB
			    <option {if $smarty.get.site_type == 3}selected='1'{/if} value="3">NVSB
				{/if}
			        <option {if $smarty.get.site_type == 5}selected='1'{/if} value="5">Blog Fusion
			    </select> <input type="button" id="filter" value="Filter" class="button"/>
			    </form>
		</td>
	</tr>
    <thead>
    <tr>
        <th>Site title
		{if $arrPg.recall>1}
			{if $arrFilter.order!='title--up'}<a
                    href="{url name='site1_syndication' action='site_manage' wg='order=title--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='title--dn'}<a
                href="{url name='site1_syndication' action='site_manage' wg='order=title--dn'}"><img
                src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}
		{/if}
        </th>
        <th align="center" width="10%">Site Type
		{if $arrPg.recall>1}
			{if $arrFilter.order!='flg_type--up'}<a
                    href="{url name='site1_syndication' action='site_manage' wg='order=flg_type--up'}"><img
                    src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                    src="/skin/i/backend/up_off.gif" width="5" height="11"
                    alt=""/>{/if}{if $arrFilter.order!='flg_type--dn'}<a
                href="{url name='site1_syndication' action='site_manage' wg='order=flg_type--dn'}"><img
                src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}
		{/if}
        </th>
        <th width="10%">Options</th>
    </tr>
    </thead>
    <tbody>
	{foreach from=$arrList key='k' item='v'}
    <tr {if $k%2=='0'} class="alt-row"{/if}>
        <td><a href="{$v.url}" target="_blank">{$v.title}</a></td>
        <td align="center">{if $v.flg_type == 5}BF{*elseif $v.flg_type == 4}CNB*}{elseif $v.flg_type==3}
            NVSB{elseif $v.flg_type==2}NCSB{*elseif $v.flg_type==1}PSB*}{/if}</td>
        <td align="center" class="option">
            <a href="{url name='site1_syndication' action='site_manage'}?del={$v.id}"><img title="Delete" src="/skin/i/frontends/design/buttons/delete.png"/></a>
        </td>
    </tr>
	{/foreach}
    </tbody>
    <tfoot>
    <tr>
        <td colspan="3">
		{include file="../../pgg_frontend.tpl"}
        </td>
    </tr>
    </tfoot>
</table>
<form action="" method="POST" id="form-add">
    <input type="hidden" id="jsonSiteList" name="jsonSite" value='{$jsonSites}'/>
</form>
{literal}

<script type="text/javascript">
var withUrl = true;
var jsonSites ={/literal}{$jsonSites}{literal};
var siteMultiboxDo = function () {
    var arr = jsonSites;
    var arrSites = JSON.decode($('jsonSiteList').value);
    var i = 0;
    var temp = new Array();
    arrSites.each(function (item) {
        if (item == null || item.site_id == null) {
            return;
        }
        if (!arr.some(function (v) {
            return item.site_id == v.site_id && item.flg_type == v.flg_type;
        })) {
            temp[i] = item;
            i++;
        }
    });
    if (temp.length) {
        $('jsonSiteList').value = JSON.encode(temp);
        $('form-add').submit();
    }
};
var multibox = {};
        window.addEvent('domready', function(){
    $('filter').addEvent('click', function () {
        var myURI = new URI();
        if ($('filter_type').value) {
            myURI.setData({'site_type': $('filter_type').value});
        } else {
            myURI.clearData();
        }
        myURI.go();
    });
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