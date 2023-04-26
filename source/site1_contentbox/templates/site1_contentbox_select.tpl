<div class="radio radio-primary">
	<input type="radio" name="{$elementsName}" value=""{if !isset( $arrPrm.checkedId ) || empty( $arrPrm.checkedId )} checked{/if} />
	<label>No box</label>	
</div>
{foreach from=$arrayContentbox item='cb'}
<div class="radio radio-primary">
	<input type="radio" name="{$elementsName}" value="{$cb.id}"{if $arrPrm.checkedId == $cb.id} checked{/if} />
	<label>{if empty($cb.name)}Box #{$cb.id}{else}{$cb.name}{/if}</label>	
</div>
{/foreach}