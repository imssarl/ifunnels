<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
	{if $flg_access=='1'}
		{module name='files' action='edit_group' prefix='Hiam' sysname="$sysname"}
	{else}
		{module name='files' action='show_group' prefix='Hiam' sysname="$sysname"}
	{/if}
</div>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	if ( window.parent.document.getElementById('{/literal}{$set_to_item}{literal}') ) {
		var selected_item_id=window.parent.document.getElementById('{/literal}{$set_to_item}{literal}').get('value');
	}
	if ( selected_item_id!=''&&$$('.object_'+selected_item_id)[0]!=null ){
		$$('.object_'+selected_item_id)[0].getParent('.item').setStyle('background','#aaffaa');
		$$('.chose_files[uid='+selected_item_id+']')[0].setStyle('display','none');
		if ( $$('.delete_file[uid='+selected_item_id+']').length>0 ){
			$$('.delete_file[uid='+selected_item_id+']')[0].setStyle('display','none');
		}
		new Element ('a.not_chose[html="Cancel"][href="#"]',{events:{
			click: function(elt){
				elt.stop();
				window.parent.document.getElementById('{/literal}{$set_to_item}{literal}_image').set('html','');
				window.parent.document.getElementById('{/literal}{$set_to_item}{literal}').set('value','');
				$$('.chose_files[uid='+selected_item_id+']')[0].setStyle('display','');
				if ( $$('.delete_file[uid='+selected_item_id+']').length>0 ){
					$$('.delete_file[uid='+selected_item_id+']')[0].setStyle('display','');
				}
				$$('.object_'+selected_item_id)[0].getParent('.item').setStyle('background','none');
				this.destroy();
			}
		}}).inject(
			$$('.chose_files[uid='+selected_item_id+']')[0],
			'after'
		)
	}
	$$('.chose_files').each( function (elt) {
		elt.addEvent('click',function(e){
			e.stop();
			var image_obj = $$('.object_'+elt.get('uid'))[0].cloneNode(true);
			image_obj.getChildren('#object_'+elt.get('uid')).set('class','selected_file_id_'+elt.get('uid'));
			window.parent.document.getElementById('{/literal}{$set_to_item}{literal}_image').set('html','');
			window.parent.document.getElementById('{/literal}{$set_to_item}{literal}_image').grab( image_obj );
			window.parent.document.getElementById('{/literal}{$set_to_item}{literal}').set('value',elt.get('uid'));
			window.parent.multibox.boxWindow.close()
		})
	})
});
</script>
{/literal}
</body>
</html>