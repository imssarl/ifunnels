<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>

<div id="background">
	<div style="padding: 10px;">
	{*<form action="">
			<input type="text" name="q" class="query" /><input type="button" value="Search in Google" class="search" />
	</form>*}
		<form action="">
			<input type="text" name="link" class="query" /><input type="button" value="Webpage screenshot" class="search" />
			<img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" class="loader" />
		</form>
		<div id="result" style="padding: 5px;"></div>
	</div>
	{foreach from=Project_Squeeze::getBackgrounds() item=i key=k}
		{if $k%4==0}<div style="clear: both; width: 100%;"></div>{/if}
		<div style="float:left; padding: 5px;"><a href="#" class="select-backgrounds"><img src="{$i.preview}"  title="{$i.name}" /></a></div>
	{/foreach}
</div>

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
		$('button-type').set('value',el.get('rel'));
		window.parent.CeraBoxWindow.close();
	});
});
$$('.search-input').each(function(el){
	el.addEvent( 'keyup', function ( event ) {
		window.parent.$$('.clear-'+el.get('rel')+'tags').hide(0);
		window.parent.$$('.clear-'+el.get('rel')+'tags').each( function( elt ){
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
		$$('.loader').show();
		container.set('html','');
		new Request({
			url:"{/literal}{url name='site1_squeeze' action='customization'}{literal}",
			method: 'post',
			onComplete: function(res){
				$$('.loader').hide();
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