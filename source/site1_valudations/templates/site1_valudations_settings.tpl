{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
<form method="post">
	<div class="form-group">
		<div class="checkbox checkbox-custom">
			<input type="hidden" class="form-control" name="arrData[validation_realtime]" value="0" />
			<input type="checkbox" class="form-control" name="arrData[validation_realtime]" id="validation_realtime" value="1" {if Project_Validations_Realtime::check( Core_Users::$info['id'], Project_Validations_Realtime::USER, 1 )} checked{/if} />
			<label for="validation_realtime">Enable Real Time Email Validation</label>
		</div>
	</div>
	<div class="form-group">
		<div class="checkbox checkbox-custom">
			<input type="hidden" class="form-control" name="arrData[validation_mounthly]" value="0" />
			<input type="checkbox" class="form-control" name="arrData[validation_mounthly]" id="validation_mounthly" value="{if !isset( Core_Users::$info['validation_mounthly'] ) || Core_Users::$info['validation_mounthly']+60*60*24*30.25>time() || Core_Users::$info['validation_mounthly']==0}{time()}{else}{Core_Users::$info['validation_mounthly']}{/if}" {if isset( Core_Users::$info['validation_mounthly'] ) && Core_Users::$info['validation_global']!=0} checked{/if} />
			<label for="validation_mounthly">Incremental Monthly Validate</label>
		</div>
	</div>
	<div class="form-group">
		<div class="checkbox checkbox-custom">
			<input type="hidden" class="form-control" name="arrData[validation_global]" value="0" />
			<input type="checkbox" class="form-control" name="arrData[validation_global]" id="validation_global" value="{if !isset( Core_Users::$info['validation_global'] ) || Core_Users::$info['validation_global']+60*60*24*30.25*6>time() || Core_Users::$info['validation_global']==0}{time()}{else}{Core_Users::$info['validation_global']}{/if}" {if isset( Core_Users::$info['validation_global'] ) && Core_Users::$info['validation_global']!=0} checked{/if} />
			<label for="validation_global">Global Regular Validate</label>
		</div>
	</div>
	<div class="form-group">
		<input type="submit" value="Save" />
	</div>
</form>
</div>
{include file='../../box-bottom.tpl'}