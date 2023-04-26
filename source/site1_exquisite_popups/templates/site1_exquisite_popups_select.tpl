{foreach from=$arrayPopups item='popup'}
	<div class="radio radio-primary">
		<input type="radio" name="{$elementsName}" value="{$popup.str_id}"{if $arrPrm.checkedId == $popup.str_id} checked{/if} />
		<label>{$popup.title}</label>	
	</div>
{/foreach}