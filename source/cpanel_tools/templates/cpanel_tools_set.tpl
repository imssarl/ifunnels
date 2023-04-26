{if $arrPrm.type == 'database'}
<a href="{url name='cpanel_tools' action='database'}{if $arrPrm.info}?info={$arrPrm.info}{/if}{if !empty($smarty.get.placement_id)}&placement_id={$smarty.get.placement_id}{/if}" id="cpanel_{$arrPrm.type}_mb" title="Cpanel Database Creator">Create database</a>
{elseif $arrPrm.type == 'subdomain'}
<a href="{url name='cpanel_tools' action='subdomain'}?set={$arrPrm.set|default:'multi'}{if $arrPrm.info}&info={$arrPrm.info}{/if}{if !empty($smarty.get.placement_id)}&placement_id={$smarty.get.placement_id}{/if}" id="cpanel_{$arrPrm.type}_mb" title="Cpanel Subdomain Creator">Create subdomain</a>
{elseif $arrPrm.type == 'addon'}
<a href="{url name='cpanel_tools' action='addondomain'}{if $arrPrm.info}?info={$arrPrm.info}{/if}{if !empty($smarty.get.placement_id)}&placement_id={$smarty.get.placement_id}{/if}" id="cpanel_{$arrPrm.type}_mb" title="Cpanel Addon Domains Creator">Create addon domain</a>
{/if}
<script type="text/javascript">
{literal}
window.addEvent('domready', function() {
	$('cpanel_{/literal}{$arrPrm.type}{literal}_mb').cerabox({
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
{/literal}
</script>
{*module name='cpanel_tools' action='set' type='database'*}