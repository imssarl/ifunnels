<br/>
<br/>
<form class="wh" action="" style="width: 65%">
	<fieldset>
		<div class="form-group">
			<label>Keyword:</label>
			<input type="text" name="word" class="medium-input text-input form-control" value="{$word}" />
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Search Related Niches</button>
		</div>
	</fieldset>
</form>

{if !empty($arrList)}
{include file="site1_nicheresearch_table.tpl" field_title="Related Niches"}
{/if}