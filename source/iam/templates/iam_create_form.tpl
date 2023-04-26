{include file='../../error.tpl' fields=['email'=>'Email','clickbank_id'=>'Clickbank Id']}
<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<input type="hidden" name="arrData[secret_id]" value="{$arrData.secret_id}" />
<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label></label>
			{if $arrData.id}<input type="submit" name="" value="Edit Form" />{else}
			<input type="submit" name="" value="Create Form" />{/if}
		</li>
		<li>
			<label>Form Name: </label>
			<input name="arrData[name]" type="text"  class="required" value="{$arrData.name}" />
		</li>
		<li>
			<label>Activations Limit: </label>
			<input name="arrData[activations_limit]" type="text"  class="required" value="{if $arrData.activations_limit}{$arrData.activations_limit}{else}0{/if}" />
			<small>Insert "0" if activations no limit  from that form.</small>
		</li>
		<li>
			{if count( $arrSites ) > 0 }
			<label>Accessible Websites:</label>
			<div style="display:block; float:left;width:100%;">
			<input type="checkbox" value="" id="select_all" />Select All <input type="button" value="Clear All" id="clear_all" /> <input type="button" value="Return" id="return_btn"  style="display:none;" /><br/><br/>
			{foreach $arrSites as $k=>$v}{if $v.flg_iam >0 }
			<input name="arrData[sites_settings][{$k}]" type="hidden" value="0"/>
			<input name="arrData[sites_settings][{$k}]" type="checkbox" value="{$v.link_id}" class="select_elt" {if in_array(implode('_',array($v.id,$v.flg_type)), $arrData.sites_settings)}checked{/if} } />
			<a href="{$v.url}">{$v.name}</a> [ {$v.category_name} ] | 
			<a href="{$v.url}" class="open_pages" rel="{$v.id}">Pages</a>
			<div class="pages_block" style="display:none;">
				<p>{$v.url}index-z-[MM_Member_Data name='customField_1'].html</p>
			</div>
			<br/>
			{/if}{/foreach}
			</div>
			{else}
			<label>Activate websites <a href="{url name='iam' action='manage_site'}">HERE</a></label>
			{/if}
		</li>
		<li>&nbsp;</li>
		<li style="width:50%;">
			<label>Activate Sites For User Form:</label><br/><br/>
			<code>{$htmlspecialchars_form}</code><br/><br/>
			<a href="{$htmlspecialchars_activate_link}" target="_blank">{$htmlspecialchars_activate_link}</a>
		</li>
		<li>&nbsp;</li>
		<li style="width:50%;">
			<label>Remove Sites From User Form:</label><br/><br/>
			<code>{$htmlspecialchars_remove_form}</code><br/><br/>
			<a href="{$htmlspecialchars_remove_link}" target="_blank">{$htmlspecialchars_remove_link}</a>
		</li>
	</ol>
</fieldset>
</form>
{literal}
<script type="text/javascript">

	$('select_all').addEvent('change',function(e){
		$$('.select_elt').each(function(item){
			if( e.target.checked ){
				if( item.default_check == undefined ){
					item.default_check=item.checked;
				}
				item.checked=e.target.checked;
			}else{
				item.checked=item.default_check;
			}
		});
		if( e.target.checked ){
			$('return_btn').show('inline');
		}else{
			$('return_btn').hide();
		}
	});
	
	$('clear_all').addEvent('click',function(e){
		$$('.select_elt').each(function(item){
			if( item.default_check == undefined ){
				item.default_check=item.checked;
			}
			item.checked=false;
		});
		$('return_btn').show('inline');
		$('select_all').checked=false;
	});
	
	$('return_btn').addEvent('click',function(e){
		$$('.select_elt').each(function(item){
			item.checked=item.default_check;
		});
		$('return_btn').hide();
		$('select_all').checked=false;
	});

	$$('.open_pages').addEvent('click',function(e){
		e && e.stop();
		if( e.target.getNext().getStyle('display') == 'none' ){
			if( e.target.get('href') != '#' ){
				new Request({
					url: '{/literal}{url name="iam" action="manage_sites_pages"}{literal}',
					onComplete:function( string ){
						//console.log('next load ');
						//console.log($$('.home_page')[0]);
						Array.each( JSON.decode( string ), function(item){
							//console.log( $$('.home_page')[0].get('href')+item.link+"-z-[MM_Member_Data name='customField_1'].html" );
							new Element('p',{html: e.target.get('href')+item.link+"-z-[MM_Member_Data name='customField_1'].html"})
								.inject(
									e.target.getNext()
								);
						});
						e.target.getNext().show();
						e.target.set('href','#');
						e.target.empty().appendText( 'Close' );
					}
				}).post({ 'site_id':e.target.get('rel') });
			}else{
				e.target.getNext().show();
				e.target.empty().appendText( 'Close' );
			}
		}else{
			e.target.getNext().hide();
			e.target.empty().appendText( 'Pages' );
		}
	});
</script>
{/literal}