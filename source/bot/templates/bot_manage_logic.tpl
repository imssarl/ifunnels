<table class="info glow" style="width:98%">
<thead>
	<tr>
		<th>ID</th>
		<th>Query</th>
		<th>Reply</th>
		<th>Related Reply & Expected Response</th>
		<th>Options</th>
	</tr>
</thead>
<tbody>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<td>{$v.id}</td>
		<td valign="top">{$v.query}</td>
		<td valign="top">{$v.reply}</td>
		<td>{$v.related_id} &and; {$v.expected_response}</td>
		<td>
			<a href="{url name='bot' action='create_action' wg="id={$v.id}"}">edit</a> | <a href="{url name='bot' action='manage_logic' wg="del={$v.id}"}">del</a>
		</td>
	</tr>
	{/foreach}
</tbody>
</table>