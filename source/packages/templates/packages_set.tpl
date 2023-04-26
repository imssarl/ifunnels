<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label></label>
			<input type="submit" name="" value="Submit" />
			<input type="reset" name="" value="Reset" />
		</li>
	</ol>
	<ol>
		<li>
			<label>Type</label>
			<select name="arrData[flg_type]" style="width:80px;"{if $arrData.id} disabled="disabled"{/if} id="flg_type">
				{html_options options=Core_Payment_Package::$packageType selected=$arrData.flg_type}
			</select>
		</li>
		<li class="toggle">
			<label>Special offer</label>
			<input type="hidden" value="0" name="arrData[flg_hide]" />
			<input type="checkbox" value="1" {if $arrData.flg_hide==1} checked="1" {/if} name="arrData[flg_hide]" />
		</li>
		<li>
			<label>Title <em>*</em></label>
			<input type="text" name="arrData[title]" class="lang" value="{$arrData.title}" />
			{if $arrErrors.title}<span class="error">this fields can't be empty</span>{/if}
		</li>
		<li class="toggle">
			<label>Group <em>*</em></label><select name="arrData[group_id]">
			{html_options options=$arrGroups selected=$arrData.group_id}</select>
		</li>
		<li>
			<label>Price</label>
			<input type="text" name="arrData[cost]"  value="{$arrData.cost|default:0}" style="width:80px;" />
		</li>
		<li>
			<label>Credits <em>*</em></label>
			{if $arrErrors.credits}<span class="error">this fields can't be empty</span>{/if}
			<input type="text" name="arrData[credits]" value="{$arrData.credits}" style="width:80px;" />
		</li>
		<li>
			<label>Recurring price</label>
			<input type="text" name="arrData[recurring_cost]"  value="{$arrData.recurring_cost}" style="width:80px;" />
		</li>
		<li>
			<label>Recurring credits </label>
			<input type="text" name="arrData[recurring_credits]" value="{$arrData.recurring_credits}" style="width:80px;" />
		</li>
		<li class="toggle">
			<label>Length of subscriptions <em>*</em></label> 
			<input type="text" name="arrData[length]" maxlength="4" value="{$arrData.length|default:1}" style="width:80px;" />
			<select name="arrData[flg_length]" style="width:80px;">
				{html_options options=Core_Payment_Package::$periodType selected=$arrData.flg_length|default:1}
			</select>
			{if $arrErrors.length}<span class="error">this fields can't be empty</span>{/if}
		</li>
		<li  class="toggle">
			<label>Payment Cycle</label>
			<input type="text" name="arrData[cycles]" value="{$arrData.cycles}" />
			<p class="helper">
				0 - no limit<br/>
				1 - lifetime
			</p>
		</li>

		<li class="toggle">
			<label>Logo</label>
			<input type="file" name="logo"  />{if !empty($arrData.image)} <img src="{img src="`$arrData.image.path_sys``$arrData.image.name_system`" w='100' h='100'}" alt=""/> Delete <input type="checkbox" name="del" value="{$arrData.image.id}" />{/if}
		</li>
		<li>
			<label>Click2sell/Jvzoo product ID </label>
			{if $arrErrors.click2sell_id}<span class="error">this fields can't be empty</span>{/if}
			<input type="text" name="arrData[click2sell_id]"  value="{$arrData.click2sell_id}" />
		</li>
		<li>
			<label>Click2sell/Jvzoo product URL </label>
			{if $arrErrors.click2sell_url}<span class="error">this fields can't be empty</span>{/if}
			<textarea name="arrData[click2sell_url]" rows="4"  style="width:700px;">{$arrData.click2sell_url}</textarea>
		</li>
		<li>
			<label>Description</label>
			<div><textarea name="arrData[description]"  id="description" class="lang" rows="13" style="width:700px;">{$arrData.description}</textarea></div>
		</li>
	</ol>
	<ol>
		<li>
			<label></label>
			<input type="submit" name="" value="Submit" />
			<input type="reset" name="" value="Reset"  />
		</li>
	</ol>
</fieldset>
</form>
<script type="text/javascript">
CKEDITOR.replace( 'description', {
		toolbar : 'Default',
		height:"300",
		width:"700"
	});
var arrData={$arrData|json};
window.addEvent('domready',function(){
	$('flg_type').addEvent('change',function(e){
		$$('.toggle').each(function(el){
			el.toggle();
		});
	});
	if(arrData!=null&&arrData.flg_type==1){
		$$('.toggle').each(function(el){
			el.toggle();
		});
	}
});
</script>