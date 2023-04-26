<form action="#res" method="POST" class="wh validate">
	<fieldset>
		<div class="form-group">
			<label>Words <em>*</em>:</label>
			<textarea id="words" name="word" class="required medium-input form-control" style="height:100px;">{$smarty.post.word}</textarea>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="regular" checked='1' name="output[regular]" value="1"/>
				<label>Regular</label>
			</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="quotes" {if $output.quotes} checked='1' {/if} name="output[quotes]" value="2"/>
				<label>Quotes</label>
			</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="brackets"  {if $output.brackets} checked='1'{/if} name="output[brackets]" value="3"/>
				<label>Brackets</label>
			</div>
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" id="generate" name="submit" {is_acs_write}>Generate</button>
		</div>
	</fieldset>
	<fieldset id="field_res" {if empty($arrRes)} style="display:none;" {/if}>
		<div class="form-group">
			<label>Result</label>
			<textarea id="res" name="result" class="medium-input form-control" style="height:200px;">{foreach from=$arrRes item=i}{foreach from=$i item=j}{$j}{/foreach}{/foreach}</textarea>
		</div>
		<div class="form-group">
			<label>File name</label>
			<input type="text" class="text-input medium-input form-control" name="name" />
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" name="export" {is_acs_write}>Export</button>
		</div>
	</fieldset>
</form>