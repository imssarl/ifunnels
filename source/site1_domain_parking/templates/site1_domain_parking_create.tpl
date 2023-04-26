{include file='../../error.tpl' fields=['title'=>'Title']}
<div class="card-box">
<form action="" class="wh validate" method="post"  enctype="multipart/form-data" >
	<fieldset>
		<legend>Settings</legend>
		<p>
			<label>Project Name: <em>*</em></label>
			<input type="text" class="required form-control" name="arr[title]" value="" />
		</p>
	</fieldset>
	<fieldset>
		<legend>Enter Domains</legend>
		<div class="form-group">
			<label>Domain:</label>
			<input type="text" class="form-control" name="arr[domains][]" />
		</div>
		<div class="form-group">
			<label>Keyword:</label>
			<input type="text" class="form-control" name="arr[keywords][]" />
		</div>
		<div id="container"></div>
		<div class="form-group">
			<label>&nbsp;</label>
			<a href="#" id="add-more">more domains</a>
		</div>
		<div class="form-group">
			<small class="helper">You can add domains manually, and / or you can import your domains and keywords in a CSV file.</small>
		</div>
	</fieldset>
	<fieldset>
		<legend>Import Domains</legend>
		<div class="form-group">
			<label>File CSV:</label>
			<input type="file" name="file_csv" class="filestyle" id="filestyle-0" tabindex="-1" style="position: absolute; clip: rect(0px 0px 0px 0px);" />
			<div class="bootstrap-filestyle input-group"><input type="text" class="form-control " placeholder="" disabled=""> <span class="group-span-filestyle input-group-btn" tabindex="0"><label for="filestyle-0" class="btn btn-white "><span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> <span class="buttonText">Choose file</span></label></span></div>
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" {is_acs_write} >Submit</button>
		</div>
	</fieldset>
</form>

{literal}
<script type="text/javascript">
	var index=0;
	window.addEvent('domready',function(){
		$('add-more').addEvent('click',function(e){
			e.stop();
			index++;
			var li=new Element('p');
			var li2=new Element('p');
			var label1=new Element('label',{html:'Domain'+index+':'});
			var label2=new Element('label',{html:'Keyword'+index+':'});
			var input1=new Element('input',{type:'text',name:'arr[domains][]',class:'form-control'});
			var input2=new Element('input',{type:'text',name:'arr[keywords][]',class:'form-control'});
			label1.inject(li);
			input1.inject(li);
			li.inject($('container'));
			label2.inject(li2);
			input2.inject(li2);
			li2.inject($('container'));
		});
	});
</script>
{/literal}
</div>