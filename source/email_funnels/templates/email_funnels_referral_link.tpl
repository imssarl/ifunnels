<h3>Referral</h3>
<div class="card-box">
	<form action="" method="post" enctype="multipart/form-data">

		<div class="form-group">
			<label class="label-control">Referral Image:</label>
			{if isset($arrData.settings.referral_image)}
			<div>
				<img src="{$arrData.settings.referral_image}" width="400px" />
				<input type="hidden" name="arrData[settings][referral_image]" value="{$arrData.settings.referral_image}" />
			</div>
			{/if}
			<input type="file" name="upload" data-buttonname="btn-white" class="filestyle" />
		</div>
		
		<div class="form-group">
			<label>Referral Link:</label>
			<input type="text" class="form-control" name="arrData[settings][referral_link]" value="{if isset($arrData.settings.referral_link)}{$arrData.settings.referral_link}{else}{/if}" />
		</div>
		
		<div class="form-group">
			<button type="submit" class="btn btn-success waves-effect waves-light save_button" >Save</button>
		</div>
		
	</form>
</div>
