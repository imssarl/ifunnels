{if !empty($strError)}<div class="red">Error: {$strError}</div>{/if}
<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<fieldset>
	<legend></legend>
	<div><b>Select Group</b>: <select name="arrData[group_id]" class="elogin" style="width:50%;">
		<option value="0"> - select - </option>
		{html_options options=$arrG selected=$smarty.request.group_id}
	</select></div>
	<ol>
		<li>
			<label>Stripe Transaction Fee <br/></label>
			<input name="arrData[stripe_fee]" type="number" value="0" />%
		</li>
		<li>
			<label></label>
			<input type="submit" name="" value="Submit" />
		</li>
	</ol>
</fieldset>
</form>