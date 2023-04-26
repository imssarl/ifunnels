<h4 class="page-title m-b-20">{if empty( $arrData ) }Create New Site{else}Edit {$arrData.name}{/if}</h4>

<div class="card-box">
	<form method="POST" enctype="multipart/form-data">
		{if ! empty( $arrData ) }
		<input type="hidden" name="arrData[id]" value="{$arrData.id}">

		<div class="form-group">
			<a href="{url name='site1_deliver' action='memberships_create_plan'}?site_id={$arrData.id}" class="btn btn-default btn-rounded waves-effect waves-light">
				<span class="btn-label">
					<i class="fa fa-plus"></i>
				</span>
				Add new Membership
			</a>
		</div>
		{/if}
		<div class="form-group">
			<label for="name" class="control-label">Name</label>
			<input type="text" class="form-control" name="arrData[name]" id="name" value="{$arrData.name}" />
		</div>


		{if ! empty( $arrData.logo )}
		<div class="form-group">
			<label class="label-control">Current Logo</label>
			<button class="btn btn-danger waves-effect waves-light btn-xs" id="btn-delete-logo" data-id="{$arrData.id}">Delete logo</button> <br>
			<img src="{$arrData.logo}" class="img-responsive img-thumbnail" style="max-width: 200px" alt="{$arrData.name}" />
		</div>
		{/if}

		<div class="form-group">
			<label class="control-label">Upload Logo</label>
			<input type="file" class="filestyle" name="arrData[logo]" data-buttonname="btn-white" value="{$arrData.logo}">
		</div>

		<div class="form-group">
			<label class="control-label">Currency</label>&nbsp;
			<select name="arrData[currency]" class="selectpicker">
				<option value="USD" {if $arrData.currency == 'USD'}selected="selected"{/if}>USD (United States Dollar)</option>
				<option value="EUR" {if $arrData.currency == 'EUR'}selected="selected"{/if}>EUR (Euro Member Countries)</option>
				<option value="GBP" {if $arrData.currency == 'GBP'}selected="selected"{/if}>GBP (United Kingdom Pound)</option>
				<option value="CAD" {if $arrData.currency == 'CAD'}selected="selected"{/if}>CAD (Canada Dollar)</option>
				<option value="AUD" {if $arrData.currency == 'AUD'}selected="selected"{/if}>AUD (Australia Dollar)</option>
				<option value="NZD" {if $arrData.currency == 'NZD'}selected="selected"{/if}>NZD (New Zealand Dollar)</option>
			</select>
		</div>

		<div class="form-group">
			<button type="submit" class="btn btn-default waves-effect waves-light btn-md">
				Save
			</button>
		</div>
	</form>
</div>
<script>
	var ajax = '{url name="site1_deliver" action="request"}';
</script>
<script src="/skin/light/plugins/bootstrap-filestyle/src/bootstrap-filestyle.min.js" type="text/javascript"></script>
<script src="/skin/ifunnels-studio/dist/js/deliver.bundle.js"></script>