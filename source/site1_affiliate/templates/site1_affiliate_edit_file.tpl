<br />
<br />
<form class="wh" action="" method="POST" style="width:60%;" id="post_form">
	<input type="hidden" name="page_id" value="{$arrItem.page_id}">
	<input type="hidden" name="file_name"  value="{$arrItem.page_name}" />
	<input type="hidden" name="edit[type]"  value="edit" />
	<div style="display:none;">
		{module name='site1_hosting' action='select' selected=$arrItem.arrFtp arrayName='arrTransport' show_browse=0 with_file=1}
	</div>
	<fieldset>
		<legend>Edit file {$arrItem.page_name}</legend>
		<ol>
			<li>
			 	<img id="ajax_loader" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
				<!-- textarea style="width:100%; height:400px; display:none;" id="file_content" name="file_content"></textarea -->
				<div style="width:100%; height:auto;display:none;border:2px solid #222222;padding:5px; overflow:auto;" contenteditable="true" id="file_content">{$arrItem.code}</div>
				<input type="hidden" id="file_content_input" name="file_content" value="{$arrItem.code}">
			</li>
			<li>
			<li>
				<div id="editor_message"></div>
				<input type="button" id="save_file" value="Save" /><img id="ajax_loader_save" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
			</li>
		</ol>	
	</fieldset>
</form>

{literal}
<script type="text/javascript">
window.addEvent('domready', function() {
	$$('.mb').cerabox({
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
window.addEvent('domready', function() {
	var req = new Request({
		url: "{/literal}{url name='site1_affiliate' action='get'}{literal}",
		evalScripts: true,
		evalResponse: true,
		onRequest: function(){
			$('ajax_loader').style.display="block";
		},
		onSuccess: function( responseText, responseXML ){
			console.log( responseText, responseXML );
			$('file_content').innerHTML=responseText;
			$('file_content').style.display='block';
			$('file_content_input').value=responseText;
		},
		onComplete: function(){
			$('ajax_loader').style.display="none";
		}
	}).post($('post_form'));	
});

$('save_file').addEvent('click', function(){
	$('file_content_input').value=$('file_content').innerHTML;
	var req = new Request({
		url: "{/literal}{url name='site1_affiliate' action='save'}{literal}",
		onRequest: function(){
			$('ajax_loader_save').style.display="inline";
		},
		onSuccess: function(responseText){
			if(responseText != '0') {
				$('editor_message').set('html','File has been saved successfully {/literal}<a href="{$arrItem.page_address}{$arrItem.page_name}" target="_blank">View</a>{literal}');
			}
		},
		onComplete: function(){
			$('ajax_loader_save').style.display="none";
		}
	}).post($('post_form'));	
});
</script>
{/literal}