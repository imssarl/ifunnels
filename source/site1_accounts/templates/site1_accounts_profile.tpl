{if $strMsg}{include file="../../message.tpl" type='info' message=$strMsg}{/if}
{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
<div class="tab-content default-tab">
	<form method="post" action="" class="validate">
	<input type="hidden" name="arr[id]" value="{$arrProfile.id}" />
		<fieldset>
			<div class="form-group">
				<label>Page links in pagination</label>
				<input type="text" name="arr[pagging_links]" class="validate-integer validate-minmax min:1 max:30 text-input medium-input form-control" value="{$arrProfile.arrSettings.pagging_links|default:'5'}"/>{if $arrErr.pagging_links}<span class="input-notification error png_bg">{$strMsg}</span>{/if}
			</div>
			<div class="form-group">
				<label>Total rows per page</label>
				<input type="text" name="arr[pagging_rows]" class="validate-integer validate-minmax min:1 max:50 text-input medium-input form-control" value="{$arrProfile.arrSettings.pagging_rows|default:'15'}"/>{if $arrErr.pagging_rows}<span class="input-notification error png_bg">{$strMsg}</span>{/if}
			</div>
			<div class="form-group">
				<label>Google Adsense ID</label>
				<input type="text" name="arr[adsenseid]" class="text-input medium-input form-control" value="{$arrProfile.adsenseid}"/>
			</div>
			<div class="form-group">
				<label>Popup width in percent</label>
				<input type="text" name="arr[popup_width]" class="validate-integer validate-minmax min:20 max:90 text-input medium-input form-control" value="{$arrProfile.arrSettings.popup_width|default:'80'}"/>{if $arrErr.popup_width}<span class="input-notification error png_bg">{$strMsg}</span>{/if}
			</div>
			<div class="form-group">
				<label>Popup Height in percent</label>
				<input type="text" name="arr[popup_height]" class="validate-integer validate-minmax min:20 max:90 text-input medium-input form-control" value="{$arrProfile.arrSettings.popup_height|default:'80'}"/>{if $arrErr.popup_height}<span class="input-notification error png_bg">{$strMsg}</span>{/if}
			</div>
			<div class="form-group">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arr[flg_unsubscribe]" value="1"{if $arrProfile.flg_unsubscribe!=0} checked="checked"{/if} />
					<label>Unsubscribe from email lists</label>
				</div>
			</div>
{*			<div class="form-group">
				<input type="hidden" name="arr[flg_maintenance]" value="0" />
				<div class="checkbox checkbox-primary">
					<input type="checkbox" id="maintenance" name="arr[flg_maintenance]" value="1"{if $arrProfile.flg_maintenance!=0} checked="checked"{else} readonly="true" disabled="true" {/if} />
					<label>Support &amp; Maintenance</label>
				</div>
			</div>
*}
			<div class="form-group">
				<button type="submit" class="button btn btn-success waves-effect waves-light">Submit</button>
			</div>
		</fieldset>
		<div class="clear"></div>
	</form>
</div>
</div>
{include file='../../box-bottom.tpl'}

{*literal}
<script type="text/javascript">
	window.addEvent('domready',function(){
		$('maintenance').addEvent('click',function(e){
			if( !confirm('Are you sure you want to opt out of the Support & Maintenance program with no possibility to later rejoin?') ){
				e.stop();
				return;
			}
			this.set('disabled',1);
		});
	});
</script>
{/literal*}