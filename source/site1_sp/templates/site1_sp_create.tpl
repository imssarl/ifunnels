{include file="../../error.tpl" fields=['email'=>'E-mail','passwd'=>'Password','buyer_name'=>'Name','buyer_surname'=>'Surname','buyer_address'=>'Address','buyer_city'=>'City',
'buyer_province'=>'Province','buyer_country'=>'Country','buyer_zip'=>'Zip','buyer_phone'=>'Phone']}
{$limitEnd=0}
{if isset(Core_Users::$info['subaccounts_limit']) && Core_Users::$info['subaccounts_limit']-$intSubaccountCount <= 0}{$limitEnd=1}<div class="alert alert-danger">You have reached your limit for Subaccounts you can create.</div>{/if}

<form action="" method="post" class="validate">
	{if empty($arrData.id)}
	<div class="form-group">
		<label>Email: <span class="text-danger">*</span></label><input type="text" name="arrData[email]" value="{$arrData.email}" class="required form-control" />
	</div>
	{else}
	<input type="hidden" name="arrData[id]" value="{$arrData.id}"/>
	<input type="hidden" name="arrData[email]" value="{$arrData.email}"/>
	{/if}
	<div class="form-group">
		<label>Name:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_name]" class="required form-control" value="{$arrData.buyer_name}"/>
	</div>
	<div class="form-group">
		<label>Surname:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_surname]" class="required form-control" value="{$arrData.buyer_surname}"/>
	</div>
	<div class="form-group">
		<label>Address:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_address]" class="required form-control" value="{$arrData.buyer_address}"/>
	</div>
	<div class="form-group">
		<label>City:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_city]" class="required form-control" value="{$arrData.buyer_city}"/>
	</div>
	<div class="form-group">
		<label>Province:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_province]" class="required form-control" value="{$arrData.buyer_province}"/>
	</div>
	<div class="form-group">
		<label>Country:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_country]" class="required form-control" value="{$arrData.buyer_country}"/>
	</div>
	<div class="form-group">
		<label>Zip:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_zip]" class="required form-control" value="{$arrData.buyer_zip}"/>
	</div>
	<div class="form-group">
		<label>Phone:&nbsp;<span class="text-danger">*</span></label>
		<input type="text" name="arrData[buyer_phone]" class="required form-control" value="{$arrData.buyer_phone}"/>
	</div>
	<div class="form-group">
		<label>Password: {if empty($arrData.id)}<span class="text-danger">*</span>{/if}</label><input type="text" name="arrData[passwd]" class="{if empty($arrData.id)}required {/if}form-control" />
	</div>
	<div>
		<input type="hidden" value="0" name="arrData[flg_allow_sub]" />
		<div class="checkbox checkbox-primary">
			<input type="checkbox" name="arrData[flg_allow_sub]" {if $arrData.flg_allow_sub==1}checked="1"{/if} value="1" />
			<label>Allow sub account to login </label>
		</div>
	</div>
	{if $limitEnd==0 || isset( $arrData )}<div class="form-group">
		<button type="submit" class="btn btn-default waves-effect waves-light">{if empty($arrData.id)}Create new{else}Update{/if} account</button>
	</div>{/if}
</form>