<br />
<br />
<form class="wh" action="" method="POST" style="width:60%;" id="post_form">
	<input type="hidden" name="page_id" value="{$arrItem.page_id}">
	<input type="hidden" name="file_name"  value="{$arrItem.page_name}" />
	<input type="hidden" name="edit[type]"  value="edit" />
	{module name='ftp_tools' action='set' selected=$arrItem.arrFtp  with_file=true}
	<fieldset >
		<legend>Edit</legend>
		<ol>
			<li>
				<input type="button" value="Open file" id="open" />
				<img id="ajax_loader" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
			</li>
			<li id="editor" style="display:none;">
				<textarea style="width:100%; height:400px;" id="file_content" name="file_content"></textarea>
			</li>
			<li id="save_botton" style="display:none;">
				<div id="editor_message"></div>
				<input type="button" id="save_file" value="Save" />
				<img id="ajax_loader_save" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
			</li>
		</ol>	
	</fieldset>
</form>


{literal}
<script type="text/javascript">
var multibox={};

window.addEvent('domready', function() {
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
$('open').addEvent('click',function(){
	if( !$('ftp_directory').value  ) {
		r.alert( 'Client side error', 'Fill FTP Address, Username, Password field and Homepage folder.', 'roar_error' );
		return false;
	}		
	$('editor_message').set('html','');
	$('editor').style.display = 'none';
	$('save_botton').style.display = 'none';
	$('file_content').value = '';
	var req = new Request({url: "{/literal}{url name='site1_affiliate' action='get'}{literal}",onRequest: function(){$('ajax_loader').style.display="block";}, onSuccess: function(responseText){
			$('file_content').value = responseText;
			$('editor').style.display = 'block';
			$('save_botton').style.display = 'block';
			$('file_content').style.display = 'block';
	}, onComplete: function(){$('ajax_loader').style.display="none"; }}).post($('post_form'));	
});

$('save_file').addEvent('click', function(){
	var req = new Request({url: "{/literal}{url name='site1_affiliate' action='save'}{literal}",onRequest: function(){$('ajax_loader_save').style.display="inline";}, onSuccess: function(responseText){
		$('editor_message').set('html','File has been saved successfully');
	}, onComplete: function(){$('ajax_loader_save').style.display="none"; }}).post($('post_form'));	
});
</script>
{/literal}