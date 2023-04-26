<br/>
{if !$popup&&!$arrPrm.popup}
<div align="center">
    <div class="" style="width:50%;">
        <a class="" href="{url name='site1_blogfusion' action='manage'}">Manage blogs</a> |
        <a class="" href="{url name='site1_blogfusion' action='upgrade'}">Upgrade WP</a>
    </div>
</div>
	{if $msg == 'delete'}
		{include file='../../message.tpl' type='info' message='Delete successfully.'}
	{/if}
	{if $msg == 'stored'}
		{include file='../../message.tpl' type='info' message='Stored successfully.'}
	{/if}
	{if $msg == 'changed'}
		{include file='../../message.tpl' type='info' message='Directory changed successfully.'}
	{/if}
	{if $msg == 'error'}
		{include file='../../message.tpl' type='error' message='Can\'t delete blog.'}
	{/if}
	{include file='../../error.tpl'}
{/if}
<form action="" id="current-form" method="post">
    <input type="hidden" name="mode" value="store-settings" id="mode"/>
    <table class="table  table-striped">
		{if !$popup&&!$arrPrm.popup}
		<tr>
			<td colspan="7">
				Category: <select id="category" class="small-input btn-group selectpicker show-tick">
				    <option value=""> - select -</option>
					{foreach from=$arrCategories item=i}
				        <option {if $smarty.get.cat == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}</option>
					{/foreach}
				</select>
				<select id="category_child" name="category" class="small-input btn-group selectpicker show-tick">
					<option value=""> - select -</option>
				</select>
				Blog title: <input type="text" name="title" value="{$smarty.get.blog_title}" id="blog_title" class="text-input small-input" /> <input type="button" value="Filter" id="filter" class="button"/>
			</td>
		</tr>
		{/if}
        <thead>
        <tr>
		{if !$popup&&!$arrPrm.popup}
            <th style="padding-right:0;" width="1px">
                <div class="checkbox checkbox-primary" style="margin: 0;">
                    <input type="checkbox" id="del" class="tooltip" title="mass delete" rel="check to select all"/>
                    <label style="min-height: 14px;"></label>
                </div>
            </th>
            <th style="padding-right:0;" width="1px">
                <div class="checkbox checkbox-primary" style="margin: 0;">
                    <input type="checkbox" id="set" class="tooltip" title="mass store settings" rel="check to select all"/>
                    <label style="min-height: 14px;"></label>
                </div>
            </th>
		{/if}
            <th>Blog{if count($arrList)>1}
				{if $arrFilter.order!='title--up'}<a
                        href="{url name='site1_blogfusion' action='manage' wg='order=title--up'}"><img
                        src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                        src="/skin/i/backend/up_off.gif" width="5" height="11"
                        alt=""/>{/if}{if $arrFilter.order!='title--dn'}<a
                        href="{url name='site1_blogfusion' action='manage' wg='order=title--dn'}"><img
                        src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                        src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}
			{/if}</th>
            <th>Category{if count($arrList)>1}
				{if $arrFilter.order!='category--up'}<a
                        href="{url name='site1_blogfusion' action='manage' wg='order=category--up'}"><img
                        src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                        src="/skin/i/backend/up_off.gif" width="5" height="11"
                        alt=""/>{/if}{if $arrFilter.order!='category--dn'}<a
                        href="{url name='site1_blogfusion' action='manage' wg='order=category--dn'}"><img
                        src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                        src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}
			{/if}</th>
		{if !$popup&&!$arrPrm.popup}
            <th>Dashboad (username/password)</th>
            <th>Version{if count($arrList)>1}
				{if $arrFilter.order!='version--up'}<a
                        href="{url name='site1_blogfusion' action='manage' wg='order=version--up'}"><img
                        src="/skin/i/backend/up.gif" width="5" height="11" alt=""/></a>{else}<img
                        src="/skin/i/backend/up_off.gif" width="5" height="11"
                        alt=""/>{/if}{if $arrFilter.order!='version--dn'}<a
                        href="{url name='site1_blogfusion' action='manage' wg='order=version--dn'}"><img
                        src="/skin/i/backend/down.gif" width="5" height="11" alt=""/></a>{else}<img
                        src="/skin/i/backend/down_off.gif" width="5" height="11" alt=""/>{/if}
			{/if}</th>
            <th width="160">Options</th>
		{/if}
        </tr>
        </thead>
        <tbody>
		{foreach from=$arrList item=i key=k}
        <tr{if $k%2=='0'} class="alt-row"{/if}>
            <input type="hidden" name="ids[]" value="{$i.id}"/>
			{if !$popup&&!$arrPrm.popup}
                <td style="padding-right:0;">
                    <div class="checkbox checkbox-primary">
                        <input type="checkbox" name="del[{$i.id}]" class="check-me-del" id="check-{$i.id}"/>
                        <label></label>
                    </div>
                </td>
                <td style="padding-right:0;">
                    <div class="checkbox checkbox-primary">
                        <input type="checkbox" name="set[{$i.id}]" class="check-me-set"{if $i.flg_settings} checked=""{/if} />
                        <label></label>
                    </div>
                </td>
			{/if}
            <td>{if !$popup&&!$arrPrm.popup}{$i.title}<br/>{/if}<a href="{$i.url}" target="_blank">{$i.url}</a></td>
            <td width="{if $arrPrm.flg_tpl}360{else}150{/if}">{if $i.category}{$i.category}{else}<a
                    class="mb select-category" href="#mb" title="Select category" rel="type:element,width:400"
                    rev="{$i.id}">Select category</a>{/if}</td>
			{if !$popup&&!$arrPrm.popup}
                <td><a target="_blank" href="{$i.url}wp-login.php">Dashboard</a> ({$i.dashboad_username}
                    /{$i.dashboad_password})
                </td>
                <td align="center">{$i.version}</td>
                <td align="center">
                    <a {is_acs_write} href="{url name='site1_blogfusion' action='multiboxwidget'}?id={$i.id}"
                       target="_blank" title="Widgets"><i class="ion-ios7-photos-outline" style="font-size: 20px; vertical-align: bottom; color: #A8C7EC; margin: 0 5px;"></i></a>
                    {if !Core_Acs::haveAccess( array( 'DFY' ) )}
					<a {is_acs_write} href="{url name='site1_blogfusion' action='blogclone'}?id={$i.id}" title="Clone"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></a>
                    {/if}
					<a {is_acs_write} href="{url name='site1_blogfusion' action='general'}?id={$i.id}" title="Edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
                    <a {is_acs_write} href="#mb" rel="type:element,width:400" rev="{$i.id}" title="Change category" class="mb select-category"><i class="ion-ios7-compose" style="font-size: 20px; vertical-align: bottom; color: #34d3eb; margin: 0 5px;"></i></a>
                    <a {is_acs_write} href="#" rel="{$i.category_id}" class="click-me-del" id="{$i.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
                </td>
			{/if}
        </tr>
		{/foreach}
        </tbody>
        <tfoot>
        <tr>
            <td colspan="7">
				{if !$popup&&!$arrPrm.popup}
				<div class="bulk-actions align-left">
				    <button type="submit" class="button btn btn-success waves-effect waves-light" id="delete" {is_acs_write}>Delete</button>
				    <button type="submit" class="button btn btn-success waves-effect waves-light" id="store-settings" {is_acs_write}>Store settings</button>
				</div>
				{/if}
			{include file="../../pgg_backend.tpl"}
            </td>
        </tr>
        </tfoot>
    </table>
</form>
<div style="display:none;">
    <div id="mb">
        <form action="" class="wh" style="padding:10px" method="POST">
            <input type="hidden" name="arrNewCat[id]" value="" id="change-cat-id">
            <select id="cat-id" class="first medium-input">
                <option value="">- select -</option>
			{foreach from=$arrCategories item=i}
                <option value="{$i.id}">{$i.title}</option>
			{/foreach}
            </select><br/><br/>
            <select class="second medium-input" name="arrNewCat[category_id]">
                <option value="">- select -</option>
            </select><br/><br/>
            <input type="submit" class="button" value="Change" {is_acs_write}>
            <br/><br/>
        </form>
    </div>
</div>

{if !$popup&&!$arrPrm.popup}
	{literal}
    <script>

    var categoryId = {/literal}{$smarty.get.cat|default:'null'}{literal};
var jsonCategory = {/literal}{$treeJson}{literal};

var Categories = new Class({
    Implements: Options,
    options: {
        firstLevel: 'category',
        secondLevel: 'category_child',
        intCatId: categoryId
    },
    initialize: function (options) {
        this.setOptions(options);
        this.arrCategories = new Hash(jsonCategory);
        $(this.options.firstLevel).addEvent('change', function () {
            this.setFromFirstLevel($(this.options.firstLevel).value);
        }.bind(this));
        if ($chk(this.options.intCatId) && this.checkLevel(this.options.intCatId)) {
            this.setFromFirstLevel(this.options.intCatId);
        } else if (this.options.intCatId != null) {
            this.setFromSecondLevel(this.options.intCatId);
        }
    },
    checkLevel: function (id) {
        var bool = false;
        this.arrCategories.each(function (el) {
            if (el.id == id) {
                bool = true;
            }
        });
        return bool;
    },
    setFromFirstLevel: function (id) {
        this.arrCategories.each(function (item) {
            if (item.id == id) {
                Array.each($(this.options.firstLevel).options, function (i) {
                    if (i.value == id) {
                        i.selected = 1;
                    }
                });

                $(this.options.secondLevel).empty();
                var option = new Element('option', {'value': '', 'html': '- select -'});
                option.inject($(this.options.secondLevel));
                var hash = new Hash(item.node);
                hash.each(function (i, k) {
                    var option = new Element('option', {'value': i.id, 'html': i.title});
                    if (i.id == this.options.intCatId) {
                        option.selected = 1;
                    }
                    option.inject($(this.options.secondLevel));
                }, this);
                jQuery('#category_child').selectpicker('refresh');
            }
        }, this);
    },
    setFromSecondLevel: function (id) {
        this.arrCategories.each(function (item) {
            var hash = new Hash(item.node);
            hash.each(function (el) {
                if (id == el.id) {
                    this.setFromFirstLevel(el.pid);
                }
            }, this);
        }, this);
    }
});

var multibox = {};
        window.addEvent('domready',function(){
    new Categories({firstLevel: 'category', secondLevel: 'category_child', intCatId: categoryId});
    checkboxToggle($('del'));
    checkboxToggle($('set'));
    $('filter').addEvent('click', function (e) {
        e && e.stop();
        var myURI = new URI();
        var catFirstLevel = $('category').value;
        var catSecondLevel = $('category_child').value;
        if (catSecondLevel != '') {
            myURI.setData({cat: catSecondLevel}, true);
        } else if ($chk(catFirstLevel)) {
            myURI.setData({cat: catFirstLevel}, true);
        } else {
            myURI.setData(new Hash(myURI.getData()).filter(function (value, key) {
                return key != 'cat';
            }));
        }
        if ($chk($('blog_title').value)) {
            myURI.setData({blog_title: $('blog_title').value}, true);
        } else {
            myURI.setData(new Hash(myURI.getData()).filter(function (value, key) {
                return key != 'blog_title';
            }));
        }
        myURI.go();
    });
    $('blog_title').addEvent('keydown', function (event) {
        if (event.key == 'enter') {
            event && event.stop();
            var myURI = new URI();
            var catFirstLevel = $('category').get('value');
            var catSecondLevel = $('category_child').get('value');
            if ($chk(catSecondLevel)) {
                myURI.setData({cat: catSecondLevel}, true);
            } else if ($chk(catFirstLevel)) {
                myURI.setData({cat: catFirstLevel}, true);
            } else {
                myURI.setData(new Hash(myURI.getData()).filter(function (value, key) {
                    return key != 'cat';
                }));
            }
            if ($chk($('blog_title').value)) {
                myURI.setData({blog_title: $('blog_title').value}, true);
            } else {
                myURI.setData(new Hash(myURI.getData()).filter(function (value, key) {
                    return key != 'blog_title';
                }));
            }
            myURI.go();
        }
    });
    $('delete').addEvent('click', function (e) {
        e && e.stop();
        if (!$$('.check-me-del').some(function (item) {
            return item.checked == true;
        })) {
            alert('Please, select one checkbox at least');
            return;
        }
        if (!confirm('Your sure to delete selected items?')) {
            return;
        }
        $('mode').set('value', 'delete');
        $('current-form').submit();
    });
    $('store-settings').addEvent('click', function (e) {
        e && e.stop();
        if (!$$('.check-me-set').some(function (item) {
            return item.checked == true;
        })) {
            alert('Please, select one checkbox at least');
            return;
        }
        $('mode').set('value', 'store-settings');
        $('current-form').submit();
    });
    $$('.click-me-del').addEvent('click', function (e) {
        e && e.stop();
        var el = 'check-' + this.get('id');
        if (!$(el).get('checked')) {
            $(el).set('checked', true);
            if ($(el).get('checked')) {
                $('delete').fireEvent('click');
            }
            $(el).set('checked', false);
        }
    });
    $$('.select-category').addEvent('click', function (e) {
        e && e.stop();
        var id = this.get('rev');
        $('change-cat-id').value = id;
        categoryId = $(id).rel;
        setTimeout("initMultiboxCat()", 700);
    });
        multibox=new CeraBox( $$('.mb'), {
    group: false,
    displayTitle: true,
    titleFormat: '{title}',
width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%'
});
});
var url = '';
var initWidgetEvents = function (strUrl) {
    url = strUrl;
//	console.dir($('cerabox').getChildren()[0].getChildren()[0]);
    var iframe = $('cerabox').getChildren()[0].getChildren()[0];
    var conteiner = $('cerabox').getChildren()[0];
    var div = new Element('div', {id: 'multiboxBlocked'});
    div.setStyle('width', '1000px');
    div.setStyle('height', '500px');
    div.setStyle('background', 'url(/skin/i/frontends/design/ajax-loader-big.gif) center center no-repeat #FFF');
    div.setStyle('position', 'absolute');
    div.setStyle('left', '0');
    div.setStyle('top', '0');
    div.inject(conteiner);
    iframe.addEvent('load', function () {
        locationIframe();
    });
}
var locationIframe = function () {
    var iframe = $('cerabox').getChildren()[0].getChildren()[0];
    iframe.contentWindow.location = url + 'wp-admin/widgets.php';
    iframe.removeEvents();
    iframe.addEvent('load', function () {
        $('multiboxBlocked').destroy();
        iframe.removeEvents();
    });
}
var initMultiboxCat = function () {
    var el = $$('.wh').getLast().elements;
    var first = null;
    var last = null;
    Array.each(el, function (e) {
        if (e.tagName == 'SELECT') {
            if (e.hasClass('first')) {
                first = e;
            }
            if (e.hasClass('second')) {
                last = e;
            }
        }
    });
    first.id = 'cat';
    last.id = 'cat_child';
    new Categories({firstLevel: 'cat', secondLevel: 'cat_child', intCatId: categoryId});
}
</script>
{/literal}
{/if}