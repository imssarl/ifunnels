{$lastActive=''}{foreach from=Project_Synnd::$promotionTypes item=arrType key=typeId }{if $arrType.flg_active!=false}{$lastActive=$typeId}{/if}{/foreach}
{foreach from=Project_Synnd::$promotionTypes item=arrType key=typeId }
<div class="form-group">
	<label>{$arrType.name}: </label>
	<div class="checkbox checkbox-primary">
		<input type="checkbox" value="{$typeId}" class="check validate-toggle-oncheck toToggle:['checked_{$typeId}']"{if $typeId==$lastActive} data-validators="validate-one-required-class class:'check'"{/if} rel="{$typeId}" name="arrCampaign[settings][promoteTypes][{$typeId}]"{if $arrCampaign.settings.promoteTypes.$typeId==$typeId && $arrType.flg_active==true} checked="checked"{/if} {if $arrType.flg_active==false} disabled="disabled"{/if}/>
		<label>{if $arrType.flg_active==false}Coming soon{/if}</label>
	</div>
</div>
<div id="checkeddiv_{$typeId}" class="check_promotion" rel="{$arrType.amount}"{if $arrCampaign.settings.promoteTypes.$typeId!=$typeId||$arrType.flg_active==false} style="display:none;"{/if}>
	{if isset($arrType.flg_siteId)}
	<div class="form-group">
		<label>Site:</label>
		<select name="arrCampaign[settings][site_id]" type="text" class="required" >
			{foreach from=$arrSites item=i key=k}<option value="{$i.id}"{if $arrCampaign.settings.site_id==$i.id} selected="selected"{/if}>{$i.name}</option>{/foreach}
		</select>
	</div>
	{/if}
	<label>Max promotions: 
		<span class="text">{if !isset($arrCampaign.settings.promoteCount.$typeId)||empty( $arrCampaign.settings.promoteCount.$typeId)}0{else}{$arrCampaign.settings.promoteCount.$typeId}{/if}</span>
	</label>
	<div id="slider_{$typeId}" class="slider_promotions" >
		<div class="knob"></div>
	</div>
	<input type="text" style="height:0;width:0;cursor:none;border:0;" id="checked_{$typeId}" class="validate-integer validate-minmax min:1 max:100" name="arrCampaign[settings][promoteCount][{$typeId}]" value="{if !isset($arrCampaign.settings.promoteCount.$typeId)||empty( $arrCampaign.settings.promoteCount.$typeId)}0{else}{$arrCampaign.settings.promoteCount.$typeId}{/if}"/>
</div>
{/foreach}