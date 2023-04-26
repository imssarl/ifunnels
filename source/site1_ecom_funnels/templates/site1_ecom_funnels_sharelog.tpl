<h3>{$arrPrm.title}</h3>
<div class="row">
	{include file="../../pgg_backend.tpl"}
</div>
<div class="card-box">
	<table class="info glow">
		<thead>
			<tr>
				<th>Shared</th>
				<th>Imported</th>
				<th>Funnel Name</th>
			</tr>
		</thead>
		<tbody>
			{foreach from=$arrList item=pbData}
			<tr>
				<td>{$arrUsers[$pbData['i_user']]}</td>
				<td>{$arrUsers[$pbData['s_user']]}</td>
				<td>{$arrPb[$pbData['pb_id']]}</td>
			</tr>
			{/foreach}
		</tbody>
	</table>
</div>
<div class="row">
	{include file="../../pgg_backend.tpl"}
</div>