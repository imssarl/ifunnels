{include file='../../box-top.tpl' title=$arrNest.title}
<div class="card-box">
{if $msg}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if $error}{include file="../../message.tpl" type='info' message=$error}{/if}
<div class="red" style="padding:10px;">
<form action="" method="post" class="wh validate">
	<fieldset>
		<div class="form-group">
			<label>CNM Credits:</label>
			<input type="number" size="50" class="medium-input text-input form-control" value="0" name="convert_credits"/>
		</div>
		<div class="form-group">
			<button type="submit" class="submit button btn btn-success waves-effect waves-light">Convert</button>
		</div>
	</fieldset>
</form>
</div>
{include file='../../box-bottom.tpl'}