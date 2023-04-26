
<div class="card-box">
	<form action="" method="POST" class="wh validate" id="post_form" >
		<p>
		This module allows you to create affiliate redirect page (cloaked
		or not) with enhanced capabilities (ability to add an optin form, or a scarcity message, or a coupon code...) with the click of a button.<br />

		Basically, whenever you have an affiliate program to promote you can come here and create your affiliate redirect page. You can even add your optin form and display your optin form on a website that is not yours...
		</p>
		<fieldset>
			<legend>Creat/Edit page</legend>
			<div class="radio radio-primary">
				<input type="radio"  value="edit" name="edit[type]" id="get_file">
				<label>I want to edit an existing link</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" value="creat" name="edit[type]" id="get_file_affiliate">
				<label>I want to create a new link</label>
			</div>
			<div class="form-group" style="display:none;" id="cloack_settings">
				<div class="radio radio-primary">
					<input type="radio" name="cloack" value="redirect" id="cloack_redirect" />
					<label>Simple redirect</label>	
				</div>
				<div class="radio radio-primary">
					<input type="radio" name="cloack" value="cloaked" id="cloack_cloaced" />
					<label>Cloaked link with enhanced capabilities</label>	
				</div>
			</div>

			<div id="ftp-block" style="height:100%; display:none;">
				{module name='site1_hosting' action='select'  arrayName='arrTransport' show_browse=0 with_file=1}
				<div id="convert_block"  style="display:none;" >
					<div class="form-group">
						<input type="hidden" name="convert_page" value="0">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" name="convert_page" value="1"  id="warning"/>
							<label>Convert this page to affiliate redirect page with list building capability.</label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<button type="button" class="btn btn-success waves-effect waves-light" name="open_file" id="open_file">Open file</button>
				</div>
			</div>
		</fieldset>
		<fieldset id="cloack_redirect_block" style="display:none;">
			<legend>Page settings</legend>
			<div class="form-group">
				<label><span>Destination URL <em>*</em></span></label>
				<input type="text" name="redirect_url" id="redirect_url" class="required form-control"/>
			</div>
			<div class="form-group">
				<label><span>Link Name (example: go.php) <em>*</em></span></label>
				<input type="text" name="file_name" id="file_name" class="required form-control"/>
			</p>
			<div class="form-group">
				<div id="cloack_redirect_block_message"></div>
				<img id="ajax_loader_save_page" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
				<input type="button" class="button" value="Save" id="save_page" />
				<input type="button" class="button" value="Get Code" id="get_code" />
			</div>
		</fieldset>
		<fieldset id="cloack_cloaced_block" style="display:none;">
			<legend>Page settings</legend>
			<div class="form-group">
				<label><span>Destination URL <em>*</em></span> </label>
				<input type="text" name="redirect_url2" id="redirect_url2" class="required form-control"/>
			</div>
			<div class="form-group">
				<label>Page Title</label>
				<input type="text" name="page_title" id="page_title" class=" form-control" />
			</div>
			<div class="form-group">
				<label>Meta tags (keywords)</label>
				<input type="text" name="meta_tag" class=" form-control" id="meta_tag"/>
			</div>
			<div class="form-group" style="display:block;" id="file_name_block">
				<label>Link Name (example: go.php) <em>*</em></label>
				<input type="text" name="file_name_ad"  id="file_name_ad" class="required form-control"/>
			</div>
			
			<div class="form-group">
				<input type="hidden" name="dams_add" value="0">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="dams_add" id="dams_add" value="1">
					<label>Do you want to add a list building subscrpition form, or a scarcity message or any other High Impact Ad Manager Campaign to your tracking page?</label>
				</div>
				<small>(Warning: this option could be responsible for big improvements to your bottom line!)</small>
			</div>
			<div class="form-group" style="display:none;" id="dams_select">
				<div class="radio radio-primary">
					<input type="radio"  class="dams" value="2" name="headlines_spot1">
					<label>Campaigns</label>
				</div>
				<div class="radio radio-primary">
					<input type="radio" class="dams" value="1" name="headlines_spot1" >
					<label>Split</label>
				</div>
			</div>
			<div class="form-group">
				<div id="dams_container"  style="display:none;"></div>
			</div>
			
			<div class="form-group">
				<input type="hidden" name="rt_link_add" value="0">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="rt_link_add" id="rt_link_add" value="1">
					<label>Add 3rd party scripts (Facebook retargeting pixel, Retargeting Tags, Analytics snippet, Google Tag Manager, Cookie, conversion pixel…)</label>
				</div>
			</div>
			<p style="display:none;" id="rt_link_block">
				<label>Facebook Javascript Code</label>
				<textarea style="width:100%; height:400px;" class="form-control" name="rt_link_content" id="rt_link_content"></textarea>
			</p>
			
			{if Core_Acs::haveAccess( array( 'PopUps IO' ) )}
			<div class="form-group">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="ep_link_add" id="ep_link_add" value="1">
					<label>Add any of your POPUPS.IO</label>
				</div>
			</div>
			<div style="display:none;" id="ep_link_block">
				<label>Select Popups.IO</label>
				{module name='site1_exquisite_popups' action='select' elementsName='ep_link_id'}
			</div>
			{/if}

			<div class="form-group">
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="ep_link_rewrite" id="ep_link_rewrite" value="1">
					<label>Rewrite Links</label>
				</div>
			</div>
			<div style="display:none;" id="ep_link_rewrite_block">
				<label>Custom Link</label>
				<input type="text" name="custom_rewrite_link"  class="required form-control"/>
			</div>
			
			<p>
				<div id="cloack_cloaced_block_message"></div>
				<img id="ajax_loader_save_page2" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
				<input type="button" class="button" value="Save" id="save_page2"/>
				<input type="button" class="button" value="Get Code" id="get_code2" />
			</p>
			
		</fieldset>
		<img id="ajax_loader" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
		<div id="editor_message"></div>
		<fieldset id="editor" style="display:none;">
			<legend>Editor</legend>
				<p>
					<div style="width:100%; height: auto;border:2px solid #222222;padding:5px; overflow:auto;" contenteditable="true" id="file_content"></div>
					<input type="hidden" id="file_content_input" name="file_content" value="">
				</p>
				<p>
					<input type="button" id="save_file" class="button" value="Save" /><img id="ajax_loader_save" src='/skin/i/frontends/design/ajax-loader_new.gif' alt='processing' style="display:none"/>
				</p>
		</fieldset>
	</form>
</div>



{literal}
<script type="text/javascript">
$('dams_add').addEvent('click', function(){
	if( !$('dams_add').checked ) {
		$('dams_select').style.display = 'none';
		$('dams_container').style.display= 'none';
	} else {
		$('dams_container').style.display= 'block';
		$('dams_select').style.display = 'block';
	}
});

$('rt_link_add').addEvent('click', function(){
	if( !$('rt_link_add').checked ) {
		$('rt_link_block').style.display= 'none';
	} else {
		$('rt_link_block').style.display= 'block';
	}
});
{/literal}{if Core_Acs::haveAccess( array( 'PopUps IO' ) )}{literal}
$('ep_link_add').addEvent('click', function(){
	if( !$('ep_link_add').checked ) {
		$('ep_link_block').style.display= 'none';
	} else {
		$('ep_link_block').style.display= 'block';
	}
});
{/literal}{/if}{literal}

$('ep_link_rewrite').addEvent('click', function(){
	if( !$('ep_link_rewrite').checked ) {
		$('ep_link_rewrite_block').style.display= 'none';
	} else {
		$('ep_link_rewrite_block').style.display= 'block';
	}
});

$('warning').addEvent('click', function(){
	if( $('warning').checked ){
		if( confirm('Warning! your old content will  be replaced') ) {
			$('warning').checked = true;
			$('cloack_cloaced_block').style.display='block';
			$('open_file').style.display='none';
			$('editor').style.display='none';
			$('file_name').value = '';
			$('redirect_url2').value = '';
			$('redirect_url').value = '';
			$('meta_tag').value = '';
			$('page_title').value = '';
			$('file_name_ad').type='hidden';
			$('file_name_block').style.display='none';
		} else {
			$('warning').checked = false;
		}
	} else {
			$('cloack_cloaced_block').style.display='none';
			$('redirect_url2').value='';
			$('page_title').value='';
			$('meta_tag').value='';
			$('file_name_ad').value='';
			
			$$('.dams').each(function(el){ el.checked=false; });
			$('dams_add').checked = false;
			$('rt_link_add').checked = false;
			$('dams_select').style.display = 'none';
			$('dams_container').set('html', '');	
			$('dams_container').style.display= 'none';	
			$('file_name_ad').type='text';
			$('open_file').style.display='block';	
	}
});
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

$('save_page').addEvent('click', function(){
	if( !validator.checker.validate() ){
		return false;
	}
	$('cloack_redirect_block_message').set('html','');
	var req = new Request({
		url: "{/literal}{url name='site1_affiliate' action='save'}{literal}",
		onRequest: function(){
			$('ajax_loader_save_page').style.display="block";
		},
		onSuccess: function(responseText){
			if( responseText != 0 ){
				$('cloack_redirect_block_message').set('html','File has been saved successfully');
				location.href='{/literal}{url name="site1_affiliate" action="manage"}{literal}';
			} else {
				$('cloack_redirect_block_message').set('html','File can not be saved');	
			}
		}, 
		onComplete: function(){
			$('ajax_loader_save_page').style.display="none";
		}
	}).post($('post_form'));		
});

$('get_code').addEvent('click', function(){
	$('cloack_redirect_block_message').set('html','');
	var req = new Request({
		url: "{/literal}{url name='site1_affiliate' action='save'}{literal}?getcode",
		onRequest: function(){
			$('ajax_loader_save_page').style.display="block";
		},
		onSuccess: function(responseText){
			if( responseText != '' ){
				$('cloack_redirect_block_message').set('html','<div style="width:100%; height:auto;border:2px solid #222222;padding:5px; overflow:auto;">'+responseText+'</div>');
			}
		}, 
		onComplete: function(){
			$('ajax_loader_save_page').style.display="none";
		}
	}).post($('post_form'));		
});


$('get_code2').addEvent('click', function(){
	$('cloack_redirect_block_message').set('html','');
	var req = new Request({
		url: "{/literal}{url name='site1_affiliate' action='save'}{literal}?getcode",
		onRequest: function(){
			$('ajax_loader_save_page').style.display="block";
		},
		onSuccess: function(responseText){
			if( responseText != '' ){
				$('cloack_cloaced_block_message').set('html','<div style="width:100%; height:auto;border:2px solid #222222;padding:5px; overflow:auto;">'+responseText+'</div>');
			}
		}, 
		onComplete: function(){
			$('ajax_loader_save_page').style.display="none";
		}
	}).post($('post_form'));		
});


$('save_page2').addEvent('click', function(){
	if( !validator.checker.validate() ){
		return false;
	}
	$('cloack_cloaced_block_message').set('html','');
	var req = new Request({url: "{/literal}{url name='site1_affiliate' action='save'}{literal}",onRequest: function(){$('ajax_loader_save_page2').style.display="block";}, onSuccess: function(responseText){
		if( responseText != 0 ){
			$('cloack_cloaced_block_message').set('html','File has been saved successfully');
		} else {
			$('cloack_cloaced_block_message').set('html','File can not be saved');
		}
		location.href='{/literal}{url name='site1_affiliate' action='manage'}{literal}';
	}, onComplete: function(){$('ajax_loader_save_page2').style.display="none"; }}).post($('post_form'));		
});


$('cloack_cloaced').addEvent('click', function(){
	$('dams_container').style.display='none';
	$('cloack_cloaced_block').style.display='block';
	$('cloack_redirect_block').style.display='none';
	$('cloack_redirect_block_message').set('html','');
	$('cloack_cloaced_block_message').set('html','');
	$('ftp-block').style.display='block';	
	$('dams_add').checked = false;
	$('rt_link_add').checked = false;
	$('dams_select').style.display = 'none';
	$('dams_container').style.display= 'none';	
	$('file_name_ad').value = '';
	$('file_name_ad').type='text';
	$('file_name_block').style.display='block';
	clearPageSettings();
	
});

var clearPageSettings = function(){
	$('file_name').value = '';
	$('redirect_url2').value = '';
	$('redirect_url').value = '';
	$('meta_tag').value = '';
	$('page_title').value = '';
	$('warning').checked=false;
}

$('cloack_redirect').addEvent('click', function(){	
	$('dams_container').style.display='none';
	$('cloack_cloaced_block').style.display='none';
	$('cloack_redirect_block').style.display='block';
	$('cloack_redirect_block_message').set('html','');
	$('cloack_cloaced_block_message').set('html','');	
	$('ftp-block').style.display='block';
	clearPageSettings();
});


$('get_file').addEvent('click', function(){
	$('href').href='{/literal}{url name='site1_hosting' action='browse'}{literal}?mode=with_files';
	$('open_file').style.display='block';
	$('ftp-block').style.display='block';
	$('convert_block').style.display='block';
	$('warning').checked = false;
	$('cloack_cloaced_block').style.display='none';
	if( $('get_file').checked ) {
		$('cloack_settings').style.display='none';
		$('cloack_redirect_block').style.display='none';
		$('cloack_cloaced_block').style.display='none';
		$('dams_container').style.display='none';
		$('cloack_cloaced').checked = false;
		$('cloack_redirect').checked = false;
	}	
	$('cloack_redirect_block_message').set('html','');
	$('cloack_cloaced_block_message').set('html','');
	$('ftp-block').style.display='block';
});

$('open_file').addEvent('click',function(){
	if( !validator.checker.validate() ){
		return false;
	}
	var req = new Request({
		url: "{/literal}{url name='site1_affiliate' action='get'}{literal}",
		onRequest: function(){
			$('ajax_loader').style.display="block";
		},
		onSuccess: function(responseText){
			$('file_content').set('html',responseText);
			$('file_content').show();
			$('editor').style.display='block';
		},
		onComplete: function(){
			$('ajax_loader').style.display="none";
		}
	}).post($('post_form'));	
});



$('get_file_affiliate').addEvent('click', function(){	
	$('href').href='{/literal}{url name='site1_hosting' action='browse'}{literal}';
	$('convert_block').style.display='none';
	$('cloack_cloaced_block').style.display='none';
	$('open_file').style.display='none';
	if( $('get_file_affiliate').checked ) {
		$('cloack_settings').style.display='block';
		$('editor').style.display='none';
	}
	$('editor_message').set('html','');
	$('cloack_redirect_block_message').set('html','');
	$('cloack_cloaced_block_message').set('html','');
	
});

$('save_file').addEvent('click', function(){
	$('file_content_input').value=$('file_content').innerHTML;
	$('editor_message').set('html',''); 
	var req = new Request({url: "{/literal}{url name='site1_affiliate' action='save'}{literal}",onRequest: function(){$('ajax_loader_save').style.display="inline";}, onSuccess: function(responseText){
		if(responseText != '0') {
			$('editor_message').set('html','File has been saved successfully'); 
			if($('warning').checked){
				location.href='{/literal}{url name='site1_affiliate' action='manage'}{literal}';
			}
		} else {
			$('editor_message').set('html','File can not be saved'); 
		}
	}, onComplete: function(){$('ajax_loader_save').style.display="none"; }}).post($('post_form'));	
});

function get_damscode(el,type){ };
function checkUncheckAll(el,type){
	$$('.check_all_items').each(function(el){
		if( $('chkall').checked ) {
			el.checked = true;
		} else {
			el.checked = false;
		}
	});
};

window.addEvent('domready', function() {
	$$('.dams').each(function(e){
		e.addEvent('click', function(){
			var req = new Request({url: "{/literal}{url name='advanced_options' action='ad'}{literal}",onRequest: function(){$('ajax_loader').style.display="block";}, onSuccess: function(responseText){
				$('dams_container').style.display='block';
				$('dams_container').set('html', responseText);
			}, onComplete: function(){$('ajax_loader').style.display="none"; }}).post({'flg_content':$(e).value});		
		});
	});
});
</script>
{/literal}

