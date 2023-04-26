<br />
<div align="center">The latest stable release of WordPress (Version <b>{$newVersion}</b>)</div>
<br />
<form class="wh validate" style="width:60%" method="POST" id="form-settings" action="" enctype="multipart/form-data">
<input type="hidden" name="arrSettings[flg_status]" value="1" />
<input type="hidden" id="jsonSiteList" name="jsonBlogs" value="" />
{if $arrSettings.id}<input type="hidden" name="arrSettings[id]" value="{$arrSettings.id}" />{/if}
	<fieldset>
		{if $arrSettings.flg_status==1}
		<p>
			<label>Update is running</label><input type="submit" class="button" value="Stop updating" />
		</p>
		<input type="hidden" name="arrSettings[flg_status]" value="0" >
		{/if}
		<div class="form-group">
			<label>Mode:</label>
			<div class="radio radio-primary">
				<input{if $arrSettings.flg_status==1} disabled='1'{/if} type="radio" name="arrSettings[flg_mode]"{if $arrSettings.flg_mode==0} checked='1'{/if} value="0" class="mode" >
				<label>all</label>
			</div>
			{if empty( $intNumOldBlogs )}all blogs are updated to latest version{else}
			<div class="radio radio-primary">
				<input{if $arrSettings.flg_status==1} disabled='1'{/if} type="radio" name="arrSettings[flg_mode]"{if $arrSettings.flg_mode==1} checked='1'{/if} value="1" class="required mode" id="view-link" >
				<label>blog list</label>
			</div>
			<a{if $arrSettings.flg_status==1} disabled="disabled"{/if} id="select-link" style="display:{if $arrSettings.flg_mode==1 && $arrSettings.flg_status != 1}inline{else}none{/if};" href="{url name='site1_blogfusion' action='multiboxlist'}" class="mb" {is_acs_write} >select</a>{/if}
		</div>
		<div class="form-group">
			<input type="hidden" name="arrSettings[flg_auto]" value="0"/>
			<div class="checkbox checkbox-primary">
				<input {if $arrSettings.flg_status==1}disabled='1'{/if} type="checkbox" name="arrSettings[flg_auto]" {if $arrSettings.flg_auto==1}checked='1'{/if} value="1">
				<label>Automatic Upgrade</label>
			</div>
			
		</div>
		<div class="form-group">
			<button type="submit" id="submit" {is_acs_write} class="button btn btn-success waves-effect waves-light" {if $arrSettings.flg_status==1}disabled='1'{/if}>Save settings</button>
		</div>
	</fieldset>
</form>

{if $arrList}
<table>
	<thead>
	<tr>
		<th>Blog{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_blogfusion' action='manage' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_blogfusion' action='manage' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Category{if count($arrList)>1}
			{if $arrFilter.order!='category--up'}<a href="{url name='site1_blogfusion' action='manage' wg='order=category--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='category--dn'}<a href="{url name='site1_blogfusion' action='manage' wg='order=category--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Dashboad (username/password)</th>
		<th>Version{if count($arrList)>1}
			{if $arrFilter.order!='version--up'}<a href="{url name='site1_blogfusion' action='manage' wg='order=version--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='version--dn'}<a href="{url name='site1_blogfusion' action='manage' wg='order=version--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="70">Update&nbsp;Status</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='i' key='k'}
	<tr{if $k%2=='0'} class="alt-row"{/if}>
		<td>{$i.title}<br /><a href="{$i.url}" target="_blank">{$i.url}</a></td>
		<td>{if $i.category}{$i.category}{else}<a {is_acs_write} class="mb select-category"  href="#mb" title="Select category" rel="type:element,width:400" rev="{$i.id}">Select category</a>{/if}</td>
		<td><a target="_blank" href="{$i.url}wp-login.php">Dashboard</a> ({$i.dashboad_username}/{$i.dashboad_password})</td>
		<td align="center">{$i.version}</td>
		<td align="center">{if $arrBlogsStatus[$i.id].flg_update==0}pending{elseif $arrBlogsStatus[$i.id].flg_update==1}in process{elseif $arrBlogsStatus[$i.id].flg_update==2}error{elseif $arrBlogsStatus[$i.id].flg_update==3}updated{/if}</td>
	</tr>	
	{/foreach}
	</tbody>
</table>
{/if}


{literal}
<script type="text/javascript">
var multibox;
window.addEvent('domready', function(){
	$$('.mode').each(function(el){
		el.addEvent('click', function(){
			if( $('select-link') ) {
				$('select-link').setStyle('display',( $('view-link').checked ) ? 'inline':'none');
			}
		});
	});
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});	
var siteMultiboxDo = function(){};
</script>
{/literal}