<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
{if $smarty.get.flg_type=='buttons'}
<div id="buttons">
	<div style="width:100%;float:left;padding:8px;">
		<label>Upload:&nbsp;</label><input type="file" style="display:inline;"/><a href="#" class="btn btn-success btn-rounded waves-effect waves-light select-button" rel="upload" style="display:inline;">Select</a>&nbsp;&nbsp;
	</div>
	<div style="width:100%;float:left;padding:8px;">
		Search by tag:&nbsp;<input type="text" value="" class="search-input" rel="b" />
	</div>
	<div style="width:100%;float:left;"></div>
	{foreach from=Project_Squeeze::getButtons() item=i key=k}
		<div style="float:left;padding:5px;" class="btag- {foreach from=explode(',', $i.tags) item=t key=s}btag-{str_replace(' ','_',trim( $t ))} {/foreach}clear-btags"><a href="#" class="select-button" rel="admin"><img src="{$i.preview}" title="{$i.name}"/></a></div>
	{/foreach}
</div>
{/if}
{if $smarty.get.flg_type=='phone_buttons'}
<div id="phone_buttons">
	<div style="float:left;padding:5px;">
		<label>Upload:</label><input type="file" /><a href="#" class="btn btn-success btn-rounded waves-effect waves-light select-button" rel="phone">Select</a>&nbsp;Search by tag:&nbsp;<input type="text" value="" class="search-input" rel="p" />
	</div>
	<div style="width:100%;float:left;"></div>
	{foreach from=Project_Squeeze::getPhoneButtons() item=i key=k}
		{if $k%8==0}<div style="clear: both; width: 100%;"></div>{/if}
		<div style="float:left;padding:5px;" class="ptag- {foreach from=explode(',', $i.tags) item=t key=s}ptag-{str_replace(' ','_',trim( $t ))} {/foreach}clear-ptags"><a href="#" class="select-button" rel="phone"><img src="{$i.preview}" title="{$i.name}"/></a></div>
	{/foreach}
</div>
{/if}
{literal}
<script type="text/javascript">
window.parent.$('cerabox').getChildren('.cerabox-content')[0].setStyle('overflow','none');
$$('.select-backgrounds').each(function(el){
	el.addEvent('click',function(e){
		e.stop();
		window.parent.$('default_background').set('src',el.getChildren('img')[0].get('src'));
		window.parent.$('background-select').set('value',el.getChildren('img')[0].get('title'));
		window.parent.$('background-select-google').set('value',0);
		window.parent.CeraBoxWindow.close();
	});
});
$$('.select-button').each(function(el){
	el.addEvent('click',function(e){
		e.stop();
		if( el.get('rel') != 'upload' ){
			window.parent.$('default_button').show(0);
			window.parent.$('button-file-box').hide(0);
			window.parent.$('default_button').set('src',el.getChildren('img')[0].get('src'));
			window.parent.$('button-select').set('value',el.getChildren('img')[0].get('title'));
		}else{
			var moveInput=el.getPrevious('input');
			moveInput.set('name', 'button' );
			moveInput.set('id', 'button-file' );
			window.parent.$('button-file-box').empty().grab(moveInput).show(0);
			window.parent.$('default_button').hide(0);
		}
		window.parent.$('button-type').set('value',el.get('rel'));
		window.parent.CeraBoxWindow.close();
	});
});
$$('.search-input').each(function(el){
	el.addEvent( 'keyup', function ( event ) {
		$$('.clear-'+el.get('rel')+'tags').hide(0);
		$$('.clear-'+el.get('rel')+'tags').each( function( elt ){
			var flg_have_all_tags=true;
			el.get('value').split(',').each( function( tag ){
				if( elt.hasClass( el.get('rel')+'tag-'+tag.trim().replace(' ','_') ) && flg_have_all_tags!=false ){
					flg_have_all_tags=true;
				}else{
					flg_have_all_tags=false;
				}
			});
			if( flg_have_all_tags ){
				elt.show(0);
			}
		});
	});
});
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
				if(data.responseData.results.length<1){
					container.set('html','Not found');
					return;
				}
				Object.each(data.responseData.results,function(item){
					console.dir(item);
					var div=new Element('div').inject(container);
					div.setStyles({
						'float':'left',
						'padding':'5px'
					});
					var a=new Element('a',{href:'#',class:'google-link-image'}).inject(div);
					new Element('img',{src:item.url,width:item.tbWidth,height:item.tbHeight}).inject(a);
				});
				$$('.google-link-image').each(function(el){
					el.addEvent('click',function(e){
						e.stop();
						window.parent.$('default_background').set('src',el.getChildren('img')[0].get('src'));
						window.parent.$('background-select').set('value',el.getChildren('img')[0].get('src'));
						window.parent.$('background-select-google').set('value',1);
						window.parent.$('default_background').set('width',el.getChildren('img')[0].get('width'));
						window.parent.$('default_background').set('height',el.getChildren('img')[0].get('height'));
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