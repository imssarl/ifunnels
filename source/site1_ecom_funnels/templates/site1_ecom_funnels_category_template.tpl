<h3>{$arrPrm.title}</h3>
<div class="card-box">
	<form method="post">
		<input type="text" name="arrData[category_name]" placeholder="Category Name" />
		<button type="submit">Add</button>
	</form>
</div>
<div class="card-box">
	<table class="info glow">
		<thead>
			<tr>
				<th>Category name</th>
				<th>Options</th>
			</tr>
		</thead>
		<tbody>
			{foreach from=$arrCategory item=category}
			<tr>
				<td>{$category.category_name}</td>
				<td><a href="{url name="site1_ecom_funnels" action="manage_category"}?del={$category.id}">Delete</a></td>
			</tr>
			{/foreach}
		</tbody>
	</table>
</div>