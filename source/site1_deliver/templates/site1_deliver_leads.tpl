<h4 class="page-title m-b-20">Leads</h4>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Search</h3>
	</div>

	<div class="panel-body">
		<form action="" method="get">
			<div class="input-group">
				<span class="input-group-btn">
					<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
				</span>
				<input type="text" name="email" class="form-control" placeholder="Search by email:" value="{$smarty.get.email}">
			</div>
		</form>
	</div>
</div>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Filters</h3>
	</div>

	<div class="panel-body">
		<form action="" method="get">
			<select name="filter[membership_id]" class="btn-group selectpicker pull-left m-r-10">
				<option value="">- Select Membership -</option>
				{foreach from=$arrMemberships item=membership}
				<option value="{$membership.id}" {if $smarty.get.filter.membership_id == $membership.id}selected="selected"{/if}>[{$membership.site_name}] {$membership.membership_name}</option>
				{/foreach}
			</select>

			<div class="pull-left m-r-10">
				<button type="submit" class="btn btn-default waves-effect waves-light pull-left" id="filter">Filter</button>
			</div>
		</form>
	</div>
</div>

<div class="card-box">
	<table class="table table-striped">
		<tr>
			<th>Email</th>
			<th>Membership</th>
			<th>Added</th>
			<th>Option</th>
		</tr>
		{foreach from=$arrMembers item=member}
		<tr>
			<td>{$member.email}</td>
			<td>
				{if ! empty( $member.membership_name )}
				<span class="label label-primary">[{$member.site_name}] {$member.membership_name}</span>
				{else}
				-
				{/if}
			</td>
			<td>{date('d-m-Y', $member.added)}</td>
			<td>
				{if Core_Acs::haveAccess( [ 'email test group' ] )}
				<a href="?delete={$member.id}" class="delete" title="Delete this user"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				{/if}
			</td>
		</tr>
		{foreachelse}
		<tr>
			<td colspan="4" align="center">Empty</td>
		</tr>
		{/foreach}
	</table>

	{include file="../../pgg_backend.tpl"}
</div>