<div class="wrap ulp">
	{if !empty($error_message)}
		{include file='../../message.tpl' type='error' message={$error_message}}
	{elseif !empty($ok_message)}
		{include file='../../message.tpl' type='success' message={$ok_message}}
	{elseif !empty($message)}
		{include file='../../message.tpl' type='warning' message={$message}}
	{/if}
	{*<form action="" method="get" style="margin-bottom: 10px;">
	<input type="hidden" name="page" value="subscribers" />
	Search: <input type="text" name="s" value="{$search_query}">
	<input type="submit" class="btn btn-secondary ulp-button" value="Search" />
	{if strlen($search_query) > 0}<input type="button" class="btn btn-secondary ulp-button" value="Reset search results" onclick="window.location.href='{url name='site1_exquisite_popups' action='subscribers'}';" />{/if}
	</form>*}
	<div class="ulp_buttons"><a class="btn btn-primary ulp-button" href="{url name='site1_exquisite_popups' action='ajax'}?action=export-subscribers">CSV Export</a></div>
	<div class="ulp_pageswitcher">{include file="../../pgg_backend.tpl"}</div>
	<table class=" table  table-striped">
	<tr>
		<th>Name</th>
		<th>E-mail</th>
		<th>Phone #</th>
		<th>Popup</th>
		<th style="width: 120px;">Created</th>
		<th style="width: 50px;"></th>
	</tr>
	{if sizeof($rows) > 0}
	{foreach from=$rows item='row'}
	<tr>
		<td>{if empty($row['name'])}-{else}{$row['name']}{/if}</td>
		<td>{$row['email']}</td>
		<td>{if empty($row['phone'])}-{else}{$row['phone']}{/if}</td>
		<td>{$row['title']}</td>
		<td>{$row['added']|date_local:$config->date_time->dt_full_format}</td>
		<td style="text-align: center;">
			{if !empty($row['message'])}
			<a data-toggle="modal" href="#ulp-message-{$row['id']}" title="View message"><img src="/skin/i/frontends/design/newUI/exquisite_popups/message.png" alt="View message" border="0"></a>
			{/if}
			<a href="{url name='site1_exquisite_popups' action='ajax'}?action=delete-subscriber&id={$row['id']}" title="Delete record" onclick="return ulp_submitOperation();"><img src="/skin/i/frontends/design/newUI/exquisite_popups/delete.png" alt="Delete record" border="0"></a>
		</td>
	</tr>
	{/foreach}
	{else}
	<tr><td colspan="6" style="padding: 20px; text-align: center;">{if strlen($search_query) > 0}No results found for "<strong>{$search_query}</strong>"{else}List is empty{/if}</td></tr>
	{/if}
	</table>
	<div class="ulp_buttons">
		<a class="btn btn-primary ulp-button" href="{url name='site1_exquisite_popups' action='ajax'}?action=delete-subscribers" onclick="return ulp_submitOperation();">Delete All</a>
		<a class="btn btn-primary ulp-button" href="{url name='site1_exquisite_popups' action='ajax'}?action=export-subscribers">CSV Export</a>
	</div>
	<div class="ulp_pageswitcher">{include file="../../pgg_backend.tpl"}</div>
</div>
{if sizeof($rows) > 0}
{foreach from=$rows item='row'}
{if !empty($row['message'])}
<div class="modal fade" data-toggle="modal" id="ulp-message-{$row['id']}" tabindex="-1" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Message from {$row['email']}</h4>
			</div>
			<div class="modal-body">
				{str_replace(array("\r", "\n"), array('', '<br />'), $row['message'])}
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
{/if}
{/foreach}
{/if}
<script type="text/javascript">{literal}
	function ulp_submitOperation() {
		var answer = confirm("Do you really want to continue?")
		if (answer) return true;
		else return false;
	}
{/literal}</script>