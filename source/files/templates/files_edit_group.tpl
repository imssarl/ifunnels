<script src="/skin/_js/player/swfobject.js" type="text/javascript"></script>
<script src="/skin/_js/player/nonverblaster.js" type="text/javascript"></script>
{literal}
<style type="text/css">
	.item {width:230px;height:180px;padding:3px;float:left;}
</style>
{/literal}
{if (!empty({$arrPrm.sysname}))}
	{module name='files' action='upload_file' hide='1' prefix=$arrPrm.prefix sysname=$arrPrm.sysname}
{/if}
{if $arrList}
	<div style="display: inline;">
		{foreach from=$arrList item=file}
		<div class="item">
			<span style="margin:0px"><span style="margin:0px" id="item_name_{$file.id}" alt="{$file.title}">{$file.title|truncate:30:"..."}</span></span>
			<div class="object_{$file.id}" align="center">
			{include file="files_view_file.tpl"}
			</div>
			<center><a href="" class="edit_files" uid="{$file.id}" description="{$file.description}">Edit</a>&nbsp;<a href="?delete={$file.id}" class="delete_file" uid="{$file.id}">Delete</a>&nbsp;<a href="" class="chose_files" uid="{$file.id}">Choose</a></center>
			<br/>
		</div>
		{/foreach}
	</div>
	<br style="clear:both;"/>
	<div align="right">
		{include file="../../pgg_frontend.tpl"}
	</div>
{else}
	<div align="center">
		no files found
	</div>
{/if}
{literal}
<script src="/skin/_js/player/adapter.js" type="text/javascript"></script>
<script type="text/javascript">
	$$('.edit_files').each( function (elt) {
		elt.addEvent('click' , function(elm){
			elm.stop();
				if ( $('view_file_').get('style') != '' ) {
					$('view_file_').set('style','');
					$$('.hide_button.add_hide').removeClass('add_hide');
				}
				$('file_upload').removeClass('required validate-file');
				if ( $$('input.not_edit').length == 0 ){
					new Element ('input.not_edit[type="button"][value="Close"]',{events: {
						click: function(){
							$('form_upload_file_div').empty();
							$$('input[name="file[title]"]').set('value','');
							$$('textarea[name="file[description]"]').set('html','');
							$$('input[name="file[id]"]').set('value','');
							$('view_file_').setStyle('display','none');
							$$('.hide_button').addClass('add_hide');
							this.destroy();
						}
					}}).inject(
						$('submit_file'),
						'after'
					)
				}
				var image_obj = $$('.object_'+elt.get('uid'))[0].cloneNode(true);
				image_obj.getChildren('#object_'+elt.get('uid')).set('id','edit_file_0');
				$('form_upload_file_div').set('html','');
				$('form_upload_file_div').grab( image_obj );
				$$('input[name="file[title]"]').set('value', $('item_name_'+elt.get('uid')).get('alt') );
				$$('input[name="file[id]"]').set('value',elt.get('uid'));
				$$('textarea[name="file[description]"]').set('html', elt.get('description'));
			validator=new WhValidator({className:'validate'});
		})
	});
	$$('.delete_file').each( function (elt) {
		elt.addEvent('click' , function() {
			return confirm('Do you want delete this file?')
		})
	});
</script>
{/literal}