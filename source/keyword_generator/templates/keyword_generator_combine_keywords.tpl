<script type="text/javascript">
{literal}
/* function saveKeywords(){
	var form=document.forms[1];
	var element=document.getElementById('type');
	var value=document.getElementById('title').value;
	if  (!value) {
		alert('Keyword list title is empty !');
		return false;
	}
	element.value='save';
	form.submit();
} */
function exportKeywords() {
	$('type').value='export';
	$('combine-form').submit();
}
window.addEvent('load', function() {
	$$('.keyword-help').cerabox({
		group: false,
		width:'516px',
		height:'637px',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
{/literal}
</script>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="head_article" align="left">
			Follow these steps to combine keywords and create long-tail keywords lists:
			<br/>
			1. Add keywords that you want to combine into each of the boxes
			<br/>
			2. Check 'Include blank line' box if you want to exclude keywords from that box in one round of combining your keywords
			<br/>
			3. Click 'Combine' to combine your keywords
			<br/>
			4. Check the created long-tail keywords in the 'Results' box
			<br/>
			5. To save your keywords results into a text file, input the file name and click 'Export'
			{*<br/>
			6. To save your keywords into the Saved Keywords Selections section of the Keyword Research module, click 'Save and Export'*}
			<br/>
			<br/>
			Click <a href="/skin/i/frontends/keywordgenerator.jpg" class="keyword-help" title="Example" rel="">here</a> for some examples of words to use within the boxes
		</td>
	</tr>
</table>

<form method="post" action="./#combine-form">
<fieldset>
<legend>Step 1</legend>
		{foreach from=$arrData item=i name=box}
		<div class="form-group">
			<label> 
				Box{$smarty.foreach.box.iteration}:
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arrData[{$smarty.foreach.box.iteration}][check]" id=""> 
					<label>Include blank line </label>
				</div>
				
			</label>
			<textarea name="arrData[{$smarty.foreach.box.iteration}][keywords]" class="form-control" id="" rows="5" cols="40">{$i.keywords}</textarea>
		</div>
		{/foreach}
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="regular" {if $smarty.post.regular || empty($post)}checked="checked"{/if}  name="regular" value="1"/>
				<label>Regular</label>
			</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="quotes" {if $smarty.post.quotes}checked="checked"{/if} name="quotes" value="2"/>
				<label>Quotes</label>			
			</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" class="output" id="brackets" {if $smarty.post.brackets}checked="checked"{/if} name="brackets" value="3"/>
				<label>Brackets</label>
			</div>
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" {is_acs_write}>Combine</button>
		</div>
</fieldset>		
</form>
<form method="post" action="" id="combine-form" class="wh" >
<fieldset>
	<legend>Step 2</legend>
	<input type="text" name="type" id="type" class="form-control" value="export">
	<div class="form-group">
		<label>Result:</label>
		<textarea name="result" class="medium-input form-control" rows="5" cols="40">{$result}</textarea>
	</div>
	<div class="form-group">
		<label>File name:</label>
		<input type="text" class="text-input medium-input form-control" name="name" />
	</div>
	<div class="form-group">
		<button type="button" class="button btn btn-success waves-effect waves-light" {is_acs_write} onclick="exportKeywords()">Export</button>
	</div>
	{*<div align="center"><p><b>or</b></p></div> 
	<p>
		<label>Keyword list title:</label>
		<input type="text" id="title" class="text-input medium-input" name="title"/>
	</p>
	<p>
		<input type="button" class="button" value="Save and Export" onclick="saveKeywords()"/>
	</p>*}
	</fieldset>			
</form>
