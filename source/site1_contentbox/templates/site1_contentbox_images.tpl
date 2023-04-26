<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>

<div class="card-box">
	<div id="background">
		<div style="padding: 10px;">
			<form action="">
				{* GET: {$smarty.get.flg_type} *}
				<label class="control-label">Upload:</label>
				<input type="file" id="upload-input" class="filestyle" data-buttontext="Select file" data-buttonname="btn-white" tabindex="-1" style="position: absolute; clip: rect(0px 0px 0px 0px);" />

				<div class="bootstrap-filestyle input-group form-group">
					<input type="text" class="form-control" placeholder="" disabled=""> 
					<span class="group-span-filestyle input-group-btn" tabindex="0">
						<label for="upload-input" class="btn btn-white "><span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> 
							<span class="buttonText">Select file</span>
						</label>
					</span>
				</div>

				{*<a href="#" id="upload-action" rel="upload">Upload</a>*}

				<div class="form-group">
					<div class="row">
						<div class="col-md-10">
							<input type="text" name="q" class="query form-control" />
						</div>
						<input type="button" value="Search Images" class="search col-md-2 btn btn-default waves-effect waves-light" style="height: 38px;" />
					</div>
				</div>
				
				<div class="form-group">
					<div class="row">
						<div class="col-md-10">
							<input type="text" name="link" class="query form-control"/>
						</div>
						<input type="button" value="Webpage screenshot" class="search col-md-2 btn btn-default waves-effect waves-light" style="height: 38px;" />
					</div>
				</div>
				
			</form>
			<div class="row" id="result" style="padding: 5px;"></div>
		</div>
		{foreach from=Project_Contentbox::getImages($smarty.get.flg_type) item=i key=k}
			{if $k%4==0}<div style="clear: both; width: 100%;"></div>{/if}
			<div style="float:left; padding: 5px;"><a href="#" class="select-image"><img src="{$i.preview}"  title="{$i.name}" /></a></div>
		{/foreach}
	</div>
</div>

{literal}
<script type="text/javascript">
window.parent.$('cerabox').getChildren('.cerabox-content')[0].setStyle('overflow','none');
var returnDataToElementId='{/literal}{$smarty.get.flg_type}_{$smarty.get.return}_{$smarty.get.boxid}{literal}';
var returnDataToElementIdHeight='{/literal}input[name="arrSettings[{$smarty.get.boxid}][height]"]{literal}';
var returnDataToElementIdWidth='{/literal}input[name="arrSettings[{$smarty.get.boxid}][width]"]{literal}';
$$('.select-image').each(function(el){
	el.addEvent('click',function(e){
		e.stop();
		var image=new Image();
		image.src=el.getChildren('img')[0].get('src');
		image.onload=function(){
			window.parent.$$(returnDataToElementIdHeight)[0].set('value',image.height);
			window.parent.$$(returnDataToElementIdHeight)[0].fireEvent('change',{'target':window.parent.$$(returnDataToElementIdHeight)[0]});
			window.parent.$$(returnDataToElementIdWidth)[0].set('value',image.width);
			window.parent.$$(returnDataToElementIdWidth)[0].fireEvent('change',{'target':window.parent.$$(returnDataToElementIdWidth)[0]});
		};
		window.parent.$(returnDataToElementId).set('value',el.getChildren('img')[0].get('src'));
		window.parent.$(returnDataToElementId).fireEvent('change',{'target':window.parent.$(returnDataToElementId)});
		window.parent.CeraBoxWindow.close();
	});
});
$('upload-input').addEvent('change',function(evt){
	for (var i=0; i < evt.target.files.length; i++) {
		var file=evt.target.files[i];
		var div=new Element('div').inject($('result'));
		div.setStyles({
			'float':'left',
			'padding':'5px'
		});
		var a=new Element('a',{href:'#',class:'load-image'}).inject(div);
		var img=new Element('img',{src:'',width:200,height:160}).inject(a); //document.createElement("img");
		var reader=new FileReader();

		reader.onload=function(theFile) { 
			var image=new Image();
			image.src=theFile.target.result;
			image.onload=function() {
				window.parent.$$(returnDataToElementIdHeight)[0].set('value',this.height);
				window.parent.$$(returnDataToElementIdHeight)[0].fireEvent('change',{'target':window.parent.$$(returnDataToElementIdHeight)[0]});
				window.parent.$$(returnDataToElementIdWidth)[0].set('value',this.width);
				window.parent.$$(returnDataToElementIdWidth)[0].fireEvent('change',{'target':window.parent.$$(returnDataToElementIdWidth)[0]});
			}
		}
		
		reader.onloadend=function(){
			img.src=reader.result;
			$$('.load-image').each(function(el){
				el.addEvent('click',function(e){
					e.stop();
					window.parent.$(returnDataToElementId).set('value',reader.result);
					window.parent.$(returnDataToElementId).fireEvent('change',{'target':window.parent.$(returnDataToElementId)});
					window.parent.CeraBoxWindow.close();
				});
			});
		}
		reader.readAsDataURL(file);
	}
});
/*$('upload-action').addEvent('click',function(e){
	e.stop();
	if( e.target.get('rel') != 'upload' ){
		window.parent.$(returnDataToElementId).set('value',el.getChildren('img')[0].get('src'));
		window.parent.$(returnDataToElementId).fireEvent('change',{'target':window.parent.$(returnDataToElementId)});
	}else{
		var moveInput=el.getPrevious('input');
	}
	window.parent.CeraBoxWindow.close();
});*/
$$('.search').each(function(el){
	el.addEvent('click', function(ev){
		var value=el.getPrevious().get('value');
		var name=el.getPrevious().get('name');
		var container=el.getParent().getNext('div');
		container.set('html','');
		new Request({
			url:"{/literal}{url name='site1_squeeze' action='customization'}{literal}",
			method: 'post',
			onComplete: function(res){
				var data=JSON.decode(res);
				if(data.length<1){
					container.set('html','Not found');
					return;
				}
				Object.each(data,function(item){
					var div=new Element('div').inject(container);
					div.setStyles({
						'float':'left',
						'padding':'5px'
					});
					var a=new Element('a',{href:'#',class:'google-link-image'}).inject(div);
					new Element('img',{src:item.url,width:200,height:160}).inject(a);
				});
				$$('.google-link-image').each(function(el){
					el.addEvent('click',function(e){
						e.stop();
						window.parent.$(returnDataToElementId).set('value',el.getChildren('img')[0].get('src'));
						window.parent.$(returnDataToElementId).fireEvent('change',{'target':window.parent.$(returnDataToElementId)});
						window.parent.CeraBoxWindow.close();
					});
				});
			}
		}).post({name:name,value:value});
	});
});
</script>
{/literal}

</body>
</html>