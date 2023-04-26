{include file='../../box-top.tpl' title=$arrNest.title}
<p><center>Total {$arrPg.recall} record(s) found. Showing 15 record(s) per page <br/><br/></center></p>
{if isset($deleteResult) && $deleteResult == true}
<p><center>Deleted Successfully</center></p>
{/if}
<table style="width:100%;" border="0" class="table  table-striped">
<thead>
	<tr>
		<th width="50">ID</th>
		<th>Title</th>
		<th>Description</th>
		<th width="80">&nbsp;</th>
	</tr>
</thead>
<tbody>
{if $arrItems!=false}{foreach from=$arrItems item=i name=j}
	<tr {if $smarty.foreach.j.iteration%2=='0'} class="alt-row"{/if}>
		<td>{$i.id}</td>
		<td>{$i.name}</td>
		<td>{$i.description}</td>
		<td align="center">
			<a {is_acs_write} href="{url name='site1_articles' action='getcode'}?id={$i.id}" class="mb" rel=""><img title="View" src="/skin/i/frontends/design/buttons/view.gif" /></a>
			<a {is_acs_write} href="{url name='site1_articles' action='savedselections_edit'}?id={$i.id}{if $smarty.get.page}&page={$smarty.get.page}{/if}"><img title="Edit" src="/skin/i/frontends/design/newUI/icons/pencil.png" /></a>
			<a {is_acs_write} class="delete_action" href="{url name='site1_articles' action='savedselections'}?del={$i.id}{if $smarty.get.page}&page={$smarty.get.page}{/if}"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png" /></a>
		</td>
	</tr>
{/foreach}{/if}
</tbody>
<tfoot>
	<tr>
		<td colspan="3" align="center">{include file="../../pgg_frontend.tpl"}</td>
		<td></td>
	</tr>
</tfoot>
</table>

{include file='../../box-bottom.tpl'}
{literal}
<script>
window.addEvent("domready", function(){
	$$('.delete_action').each(function(el){
		el.addEvent('click', function(e){
			if( confirm("Are you sure you want to delete the saved selection?") ) {
				return true;
			} else {
				e.stop();
			}
		});
	});

	$$('.mb').cerabox({
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});

});
</script>
{/literal}