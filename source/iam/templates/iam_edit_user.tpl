{include file='../../error.tpl' fields=['email'=>'Email','clickbank_id'=>'Clickbank Id']}
<form action="" method="POST" enctype="multipart/form-data" class="wh" >
{if $arrData.id}<input type="hidden" name="arrData[id]" value="{$arrData.id}" />{/if}
<input type="hidden" name="arrData[form_id]" value="{if $arrData.id}{$arrData.form_id}{else}0{/if}"/>

<input type="hidden" name="arrData[sid]" value="{if $arrData.id}{$arrData.sid}{/if}"/>

<fieldset>
	<legend></legend>
	<ol>
		<li>
			<label></label>
			{if $arrData.id}<input type="submit" name="" value="Edit" />{else}
			<input type="submit" name="" value="Add" />{/if}
		</li>
		<li>
			<label>Email: <em>*</em></label>
			<input name="arrData[email]" type="text"  class="required" value="{$arrData.email}" />
		</li>
		<li>
			<label>Clickbank Id: <em>*</em></label>
			<input name="arrData[clickbank_id]" type="text"  class="required" value="{$arrData.clickbank_id}" />
		</li>
		<li>
			{if !empty( $arrSites ) }
			<label>Accessible Websites:</label>
			<div style="display:block; float:left;width:50%;">
			<input type="checkbox" value="" id="select_all" />Select All <input type="button" value="Clear All" id="clear_all" /> <input type="button" value="Return" id="return_btn"  style="display:none;" /><br/><br/>

			{foreach $arrSites as $k=>$v}{if $v.flg_iam >0 }
			<input name="arrData[arrLinks][{$k}]" type="hidden" value="0"/>
			<input name="arrData[arrLinks][{$k}]" type="checkbox" value="{$v.link_id}" class="select_elt" {if in_array($v.link_id, $arrData.links_selected)}checked{/if} />
			<a href="{$v.url}">{$v.name}</a> [ {$v.category_name} ]<br/>
			{/if}{/foreach}
			</div>
			{else}
			<label>Activate websites <a href="{url name='iam' action='manage_site'}">HERE</a></label>
			{/if}
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
</script>
{/literal}