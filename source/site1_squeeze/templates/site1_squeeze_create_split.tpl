<div class="card-box">
<div class="heading">
	<!--<a class="menu" href="{url name='site1_squeeze' action='manage_campaigns'}">Manage Campaigns</a> |
	<a class="menu" href="{url name='site1_squeeze' action='create'}">Create Campaign</a> |-->
	<a class="menu" href="{url name='site1_squeeze' action='create_split'}">Create Split Test</a> |
	<a class="menu" href="{url name='site1_squeeze' action='manage_split'}">Manage Split Tests</a> 
</div>
{if count($arrErr) > 0}
	{foreach from=$arrErr item=err key=val}{include file="../../message.tpl" type='info' message="Error in $val"}{/foreach}
{/if}
{include file='../../error.tpl'}
<form action="" method="post" class="wh validate" id="newsplit">
<fieldset>
		<div class="form-group">
			<label>Test Name: <em>*</em></label>
			<input type="text" class="required text-input medium-input form-control" maxlength="255" size="50" value="{$arrSplit.title}" name="arrSplit[title]"/>
		</div>
		<div class="form-group">
			<label>Redirect URL (if split test is put on PAUSE): <em>*</em></label>
			<input type="text" class="required text-input medium-input form-control" maxlength="255" size="50" value="{if (empty($arrSplit.url))}{Project_Widget_Adapter_Squeeze_Split::urlPaused()}{else}{$arrSplit.url}{/if}" name="arrSplit[url]"/>
		</div>
		<div>
			<label>Pages: <em>*</em></label>
			{foreach from=$arrSplit.compains item='compain' key='id'}
				{if !empty($compain.url)}
				<div class="checkbox checkbox-primary">
					<input type="checkbox" class="com_chose" value="{$compain.id}" name="arrSplit[arrCom][]"{foreach from=$arrSplit.arrCom item='checked_com_id'}{if $checked_com_id.id == $compain.id} checked="checked"{/if}{/foreach} />
					<label class="img-visible">
						{$compain.url} {if !empty($compain.tags)}<span>&laquo;{$compain.tags}&raquo;</span>{/if}
						<img src="{img src=$compain.image w=200 h=200}">
					</label>	
				</div>
				{/if}
			{foreachelse}
			<label>Please crate two or more campaignes</label>
			{/foreach}
			<div style="display:none" id="com_chose_error" class="validation-advice input-notification error png_bg">Error: Please check two or more pages.</div>
		</div>
		<div class="form-group">
			<label>Do you want to limit split test duration? </label>
			<div class="checkbox checkbox-primary">
				<input id="select_flg_duration" type="checkbox" {if $arrSplit.flg_duration !='0' && !empty($arrSplit.flg_duration) } checked="checked"{/if}/>
				<label>Yes</label>
			</div>
		</div>
		<div class="flg_duration"{if $arrSplit.flg_duration !='1' && $arrSplit.flg_duration !='2'} style="display:none;"{/if}>
			<label>Select duration type: <em>*</em></label>
			<div class="radio radio-primary">
				<input type="radio" value="1" id="flg_duration_day" name="arrSplit[flg_duration]"{if $arrSplit.flg_duration =='1'} checked="checked"{/if}/>
				<label>In Days</label>	
			</div>
			<div class="radio radio-primary">
				<input type="radio" value="2" id="flg_duration_hit" class="validate-one-required" name="arrSplit[flg_duration]"{if $arrSplit.flg_duration =='2'} checked="checked"{/if}/>
				<label>In Views</label>	
			</div>
		</div>
		<div class="flg_duration_type"{if $arrSplit.flg_duration !='1' && $arrSplit.flg_duration !='2'} style="display:none;"{/if}>
			<label><span class="flg_duration_1"{if $arrSplit.flg_duration !='1'} style="display:none;"{/if}>Duration: </span>
				<span class="flg_duration_2"{if $arrSplit.flg_duration !='2'} style="display:none;"{/if}>No. of Views (for ALL selected pages): </span>
				<em>*</em></label>
			<input type="text" id="duration" class="text-input small-input validate-natural-number" value="{$arrSplit.duration}" name="arrSplit[duration]"/>&nbsp;
				<span class="flg_duration_1"{if $arrSplit.flg_duration !='1'} style="display:none;"{/if}>Days</span>
				<span class="flg_duration_2"{if $arrSplit.flg_duration !='2'} style="display:none;"{/if}></span>
		</div>
</fieldset>
<br />
	<div>
		<button type="submit" {is_acs_write} class="button btn btn-success waves-effect waves-light" name="Submit" id="save">{if !empty({$arrSplit.id})}Edit{else}Create{/if} split test</button>
		<input type="hidden" value="{$arrSplit.id}" name="arrSplit[id]"/>
	</div>
</form>
</div>
{include file='../../box-bottom.tpl'}
{literal}
<script>
window.addEvent('domready', function() {
	$( 'select_flg_duration' ).addEvent( 'change',function(){
		if ( $(this).checked ) {
			$$('.flg_duration').setStyle('display','');
		}else {
			$('flg_duration_hit').checked = false;
			$('flg_duration_day').checked = false;
			$$('.flg_duration_type').setStyle('display','none');
			$$('.flg_duration').setStyle('display','none');
		}
	});
	$( 'flg_duration_day' ).addEvent( 'click',function(){
		$$('.flg_duration_type').setStyle('display','');
		$$('.flg_duration_2').setStyle('display','none');
		$$('.flg_duration_1').setStyle('display','');
	});
	$( 'flg_duration_hit' ).addEvent( 'click',function(){
		$$('.flg_duration_type').setStyle('display','');
		$$('.flg_duration_1').setStyle('display','none');
		$$('.flg_duration_2').setStyle('display','');
	});
	$$( '.button' ).addEvent( 'click',function(e){
		e&&e.stop();
		var checked_campaiggns=0;
		$$('.com_chose').each( function( elt ){
			if( elt.checked ){
				checked_campaiggns++;
			}
		});
		//var validate=validator.checker.validate();
		if( checked_campaiggns>1 /*&& validate*/ ){
			$('newsplit').submit();
		}else{
			if( checked_campaiggns<2 )
				$('com_chose_error').show();
		}
	});
	$$('.com_chose').addEvent( 'click',function(){
		$('com_chose_error').hide();
	});
});
</script>
{/literal}