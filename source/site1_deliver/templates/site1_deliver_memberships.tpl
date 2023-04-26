<h4 class="page-title m-b-20">
	Sites 
	<a href="{url name='site1_deliver' action='memberships_site'}" class="btn btn-default btn-rounded waves-effect waves-light m-l-15">
		<span class="btn-label">
				<i class="fa fa-plus"></i>
		</span>
		Add new Site
	</a>
</h4>

<div class="card-box">
	<div class="form-group">
		
	</div>

	<table class="table table-striped">
		<tr>
			<th>Name</th>
			<th>Logo</th>
			<th>Currency</th>
			<th>Added</th>
			<th>Edited</th>
			<th>Options</th>
		</tr>

		{foreach from=$sites item=site}
		<tr>
			<td>{$site.name}</td>
			<td><img src="{$site.logo}" alt="" style="width: 100px; height: auto; object-fit: fill;"></td>
			<td>{$site.currency}</td>
			<td>{date( 'd-m-Y', $site.added )}</td>
			<td>{date( 'd-m-Y', $site.edited )}</td>
			<td>
				<a href="{url name='site1_deliver' action='memberships_site'}?id={$site.id}" title="Edit Site"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a> 
				<a href="?delete={$site.id}" class="delete" title="Delete Site"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				<a href="{url name='site1_deliver' action='memberships_plans'}?site_id={$site.id}" class="delete" title="Memberships"><i class="ion-cube text-primary" style="font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
			</td>
		</tr>
		{foreachelse}
		<tr>
			<td colspan="6" align="center">Empty</td>
		</tr>
		{/foreach}
	</table>

	{include file="../../pgg_backend.tpl"}
</div>