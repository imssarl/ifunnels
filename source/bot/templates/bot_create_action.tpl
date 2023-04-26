<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label></label>
			{if $arrData.id}<input type="submit" name="" value="Edit Request" />{else}
			<input type="submit" name="" value="Create Request" />{/if}
		</li>
		
		<li>
			<label>Related Reply: </label>
			<select name="arrData[related_id]">
				<option value="0" {if $arrData.related_id==0}selected{/if}>Not Related</option>
				{foreach $arrList as $v}
				<option value="{$v.id}" {if $v.id==$arrData.related_id}selected{/if}>{$v.reply}</option>
				{/foreach}
			</select>
			<br/><small>select related replay, user query will activated only after this replay</small>
		</li>

		<li>
			<label>Query: </label>
			<input name="arrData[query]" type="text" class="required" value="{$arrData.query}" />
			<br/><small> use {literal}{keyword}{/literal} for entering word in replay or in actions</small>
			<br/><small> for multiselect word write (word1|word2|word3) </small>
			<br/><small>if the words can not be specified (word)</small>
		</li>
		
		<li>
			<label>Reply: </label>
			<input name="arrData[reply]" type="text" class="required" value="{$arrData.reply}" />
			<br/><small>use {literal}{keyword}{/literal} for change words from catch in replay</small>
			<br/><small>for randomize answer use "|"</small>
		</li>
		
		<li>
			<label>Static Data And Actions: </label>
			<input name="arrData[static_data]" type="text" class="required" value="{$arrData.static_data}" />
			<br/><small> add static data to cache, separated by coma. Example: "category=All,action=create_site"</small>
			<br/><small> action=create_site at the end of request activate site creation process</small>
		</li>
		
		<li>
			<label>Expected Response: </label>
			<select name="arrData[expected_response]">
				<option value="0" {if $arrData.expected_response==0}selected{/if}>Not Expected</option>
				{foreach $arrList as $v}
				<option value="{$v.id}" {if $v.id==$arrData.expected_response}selected{/if}>{$v.query} [for {$v.reply}]</option>
				{/foreach}
			</select>
			<br/><small> use only {literal}{keyword}{/literal} for entering word in replay</small>
		</li>

	</ol>
</fieldset>
</form>