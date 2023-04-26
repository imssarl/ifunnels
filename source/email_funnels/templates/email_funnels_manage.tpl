<h1>{$arrPrm.title}</h1>
<form method="post" action="" id="users-filter">
	<div style="margin-bottom:10px;">
		<input type="submit" value="Delete selected" id="go">
	</div>
	<table class="info glow" style="width:98%">
		<thead>
			<tr>
				<th width="1%">
					<div class="checkbox-button">
						<input type="checkbox" id="sel" />
						<label for="sel"></label>
					</div>
				</th>
				<th width="40%">Title</th>
				<th width="10%">Type</th>
				<th width="10%">Tags</th>
				<th width="10%">Edited</th>
				<th width="10%">Added</th>
				<th width="10%">Options</th>
			</tr>
		</thead>
		<tbody>
			{if !empty($arrData)}
			<tr><td colspan="7">{include file="../../pgg_backend.tpl"}</td></tr>
			{/if}
			{foreach $arrData as $item}
			<tr{if ($item@iteration-1) is div by 2} class="matros"{/if}>
				<td>
					<div class="checkbox-button">
						<input type="checkbox" name="arrList[{$item.id}]" class="check-me-sel" id="check-{$item.id}">
						<label for="check-{$item.id}"></label>
					</div>
				</td>
				<td><a href="{url name='email_funnels' action='set' wg="id={$item.id}"}" target="_blank">{$item.title}</a></td>
				<td>{$item.tags}</td>
				<td>{if $item.type == 1}Broadcast{else}Sequence{/if}</td>
				<td>{$item.edited|date_local:$config->date_time->dt_full_format}</td>
				<td>{$item.added|date_local:$config->date_time->dt_full_format}</td>
				<td class="option">
					<a href="{url name='email_funnels' action='set' wg="id={$item.id}"}">edit</a> |
					<a href="{url name='email_funnels' action='manage' wg="duplicate={$item.id}"}">duplicate</a> | <a href="{url name='email_funnels' action='manage' wg="delete={$item.id}"}" class="resend">delete</a>
				</td>
			</tr>
			{foreachelse}
			<tr class="matros"><td colspan="7" style="text-align: center;">Empty</td></tr>
			{/foreach}
			{if !empty($arrData)}
			<tr><td colspan="7">{include file="../../pgg_backend.tpl"}</td></tr>
			{/if}
		</tbody>
	</table>
</form>
{literal}
<script>
window.addEvent('domready',function(){
	checkboxFullToggle($('sel'));
});
</script>
{/literal}