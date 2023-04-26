<h3>{$arrPrm.title}</h3>
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
			{foreach from=$arrTemplates item=template}
			<tr>
				<td>{$template.sites_name}</td>
				<td>{$arrCategories[$template.category_id]}</td>
				<td><a href="{url name='site1_ecom_funnels' action='create_template'}?id={$template.id}&p=index">Edit</a> 
				<a href="{url name='site1_ecom_funnels' action='manage_template'}?del={$template.id}" onclick="return pb_remove();">Delete</a> 
				<a href="{url name='site1_ecom_funnels' action='manage_template'}?duplicate={$template.id}">Duplicate</a>
			</tr>
			{/foreach}
		</tbody>
	</table>
</div>