<div class="wrap ulp">
	{if !empty($error_message)}
		{include file='../../message.tpl' type='error' message={$error_message}}
	{/if}
	{if !empty($ok_message)}
		{include file='../../message.tpl' type='success' message={$ok_message}}
	{/if}
	{if !empty($message)}
		{include file='../../message.tpl' type='warning' message={$message}}
	{/if}
	{*<form action="" method="get" style="margin-bottom: 10px;">
	<input type="hidden" name="page" value="popups" />
	Search: <input type="text" name="s" value="{$search_query}">
	<input type="submit" class="btn btn-secondary ulp-button" value="Search" />
	{if strlen($search_query) > 0}<input type="button" class="btn btn-secondary ulp-button" value="Reset search results" onclick="window.location.href='{url name='site1_exquisite_popups' action='manage'}';" />{/if}
	</form>*}
	<div class="ulp_buttons"><a class="btn btn-primary ulp-button" href="{url name='site1_exquisite_popups' action='create'}">Create New Popup</a></div>
	<div class="ulp_pageswitcher">{include file="../../pgg_backend.tpl"}</div>
	<table class="table table-striped"><!--table table-striped-->
	<tr>
		<th>Title</th>
		<th style="width: 120px;">Get Code</th>
		<th style="width: 80px;">Layers</th>
		<th style="width: 130px;"></th>
	</tr>
	{if (sizeof($rows) > 0)}
	{foreach from=$rows item='row'}
	<tr{if $row['blocked'] == 1} style="background: #FFF8F8"{/if}>
		<td>{if $row['blocked'] == 1}Template: {/if}{$row['title']}</td>
		<td>{if $row['user_id'] != 0}
			<a style="cursor:pointer" rel="" href="{url name='site1_exquisite_popups' action='getcode'}?id={$row['str_id']}" class="popup" title="Exquisite On Load Popups">
				Get Code
			</a>
		{/if}</td>
		<td style="text-align: right;">{count($row['layers'])}</td>
		<td style="text-align: center;">
			<a  href="#" onclick="{$row['source_action']}" title="Preview popup"><img src="/skin/i/frontends/design/newUI/exquisite_popups/preview.png" alt="Preview popup" border="0"></a>
			{$row['source_script']}
			<a href="{url name='site1_exquisite_popups' action='ajax'}?action=copy&id={$row['id']}" title="Duplicate popup" onclick="return ulp_submitOperation();"><img src="/skin/i/frontends/design/newUI/exquisite_popups/copy.png" alt="Duplicate popup" border="0"></a>
			{if $row['user_id'] != 0 || Core_Acs::haveAccess( array( 'Popup IO Admins' ) )}
			<a href="{url name='site1_exquisite_popups' action='create'}?id={$row['id']}" title="Edit popup details"><img src="/skin/i/frontends/design/newUI/exquisite_popups/edit.png" alt="Edit popup details" border="0"></a>
			{if $row['user_id'] != 0}
			<a href="{url name='site1_exquisite_popups' action='ajax'}?action=export&id={$row['id']}" title="Export popup details"><img src="/skin/i/frontends/design/newUI/exquisite_popups/export.png" alt="Export popup details" border="0"></a>
			{if $row['blocked'] == 1}
			<a href="{url name='site1_exquisite_popups' action='ajax'}?action=unblock&id={$row['id']}" title="Unblock popup"><img src="/skin/i/frontends/design/newUI/exquisite_popups/unblock.png" alt="Unblock popup" border="0"></a>
			{else}
			<a href="{url name='site1_exquisite_popups' action='ajax'}?action=block&id={$row['id']}" title="Block popup"><img src="/skin/i/frontends/design/newUI/exquisite_popups/block.png" alt="Block popup" border="0"></a>
			{/if}
			{/if}
			<a href="{url name='site1_exquisite_popups' action='ajax'}?action=delete&id={$row['id']}" title="Delete popup" onclick="return ulp_submitOperation();"><img src="/skin/i/frontends/design/newUI/exquisite_popups/delete.png" alt="Delete popup" border="0"></a>
			{/if}
		</td>
	</tr>
	{/foreach}
	{else}
	<tr><td colspan="4" style="padding: 20px; text-align: center;">{if strlen($search_query) > 0}No results found for "<strong>{$search_query}</strong>{else}List is empty{/if}</td></tr>
	{/if}
	</table>
	{*if (sizeof($rows) > 0)}
	{foreach from=$rows item='row'}
	<div class="ulp-preload" data-id="{$row['str_id']}"></div>
	{/foreach}
	{/if*}
	<div class="ulp_buttons">
		<form id="ulp-import-form" enctype="multipart/form-data" method="post" action="{url name='site1_exquisite_popups' action='ajax'}?action=import">
			<div style="position: relative; padding: 10px 20px;">
				<a class="ulp-import-form-close" href="#" onclick="jQuery('#ulp-import-form').fadeOut(350); return false;">×</a>
				<input type="file" name="ulp-file[]" multiple onchange="jQuery('#ulp-import-form').submit();">
			</div>
		</form>
		<a class="btn btn-primary ulp-button" href="#" onclick="jQuery('#ulp-import-form').fadeIn(350); return false;">Import Popup</a>
		<a class="btn btn-primary ulp-button" href="{url name='site1_exquisite_popups' action='create'}">Create New Popup</a>
	</div>
	<div class="ulp_pageswitcher">{include file="../../pgg_backend.tpl"}</div>
</div>
<script type="text/javascript">{literal}
	function ulp_submitOperation() {
		var answer = confirm("Do you really want to continue?")
		if (answer) return true;
		else return false;
	}
	var multibox;
	var managerClass = new Class({
		initialize: function(){
			multibox=new CeraBox( $$('.popup'), {
				group: false,
				width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
				height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
				displayTitle: true,
				titleFormat: '{title}'
			});
		}
	});
	window.addEvent('domready', function() {
	new managerClass();
	});
{/literal}</script>