{include file='../../error.tpl'}
<div class="card-box">
	<div class="heading">
		{if empty($arrSnip.id)}New{else}Edit{/if} Snippet {if !empty($arrSnip.id)}| <a href="{url name='site1_snippets' action='partcreate'}?snippet_id={$arrSnip.id}">Create part</a>{/if}
	</div>
	<form action="" method="post" class="wh validate" id="newsnippet" >
		<input type="hidden" value="{$arrSnip.id}" name="arrSnip[id]"/>
		<input type="hidden" value="{if !empty($arrSnip.added)}{$arrSnip.added}{else}{$smarty.now}{/if}" name="arrSnip[added]"/>
		<div class="form-group">
			<label>Title: <em>*</em></label>
			<input type="text" class="required form-control" alt="Writing title." maxlength="255" size="50" value="{$arrSnip.title}" name="arrSnip[title]"/>
		</div>
		<div class="form-group">
			<label>Description: <em>*</em></label>
			<textarea class="required form-control" alt="Writing description." rows="12" cols="70" name="arrSnip[description]">{$arrSnip.description}</textarea>
		</div>
		
		<div class="form-group">
			<label>Intelligent link tracking: <em>*</em></label>
			<div class="radio radio-primary">
				<input type="radio" class="validate-one-required" name="arrSnip[flg_enabled]"{if $arrSnip.flg_enabled =='1'} checked="checked"{/if} value="1"/>
				<label>Enabled</label>
				<br>
				<input type="radio" class="" value="0" name="arrSnip[flg_enabled]"{if $arrSnip.flg_enabled =='0'} checked="checked"{/if}/>
				<label>Disabled</label>
			</div>
			<div class="radio radio-primary">
				
			</div>
		</div>
		{if Core_Users::$info['id'] == '1'}
		<div class="form-group">
			<label>Show Campaign in Traffic Exchange Iframe: </label>
			<div class="radio radio-primary">
				<input type="radio" name="arrSnip[flg_traffic_exchange]"{if $arrSnip.flg_traffic_exchange =='1'} checked="checked"{/if} value="1"/>
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" class="validate-one-required" value="0" name="arrSnip[flg_traffic_exchange]"{if $arrSnip.flg_traffic_exchange =='0'} checked="checked"{/if}/>
				<label>No</label>
			</div>
		</div>
		{/if}
		<div class="form-group">
			<button type="submit" name="Submit" id="save" class="btn btn-success waves-effect waves-light" {is_acs_write}>Save</button>
		</div>
	</form>
</div>