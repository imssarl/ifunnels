<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<div class="card-box">
	<div class="heading">
		{if !empty($arrPart.snippet_id)}<a href="{url name='site1_snippets' action='create'}?id={$arrPart.snippet_id}">Edit snippet</a> |{/if}{if empty($arrPart.id)}New{else}Edit{/if} snippet part{if !empty($arrPart.id)} | <a href="{url name='site1_snippets' action='partcreate'}?snippet_id={$arrPart.snippet_id}">Create new part</a>{/if}
	</div>

	<form action="" method="post" class="wh validate" id="snippetpart" >
		<input type="hidden" name="arrPart[snippet_id]" value="{$arrPart.snippet_id}"/>
		<input type="hidden" name="arrPart[id]" value="{$arrPart.id}"/>
		<input type="hidden" name="arrPart[added]" value="{if !empty($arrPart.added)}{$arrPart.added}{else}{$smarty.now}{/if}"/>
		<div class="form-group">
			<label>Enter Contents: <em>*</em></label>
			<div class="radio radio-primary">
				<input type="radio" name="arrPart[flg_enabled]" value="1"{if empty($arrPart.flg_enabled) or $arrPart.flg_enabled=='1'} checked="checked"{/if} class="flg_enabled" id='text' />
				<label>TEXT</label>
				<br/>
				<input type="radio" name="arrPart[flg_enabled]" value="2"{if $arrPart.flg_enabled=='2'} checked="checked"{/if} class="flg_enabled validate-one-required article_source" id='html'/>
				<label>HTML</label>
			</div>
			{if !Core_Acs::haveAccess('Advertiser')}<br/><a href="{url name='site1_video_manager' action='multibox'}" class="popup" title="Import from Video Manager" rel="" id="popup"{if $arrPart.flg_enabled=='2'} style="display:none;"{/if}>Import from Video Manager</a>{/if}
		</div>
		<div class="form-group">
			<div id="texteditor"{if $arrPart.flg_enabled=='2'} style="display:none"{/if}>
				<textarea id="textlink"{if empty($arrPart.flg_enabled) or $arrPart.flg_enabled=='1'} name="arrPart[content]"{/if} class="form-control" rows="13" style=" width:99%">{if empty($arrPart.flg_enabled) or $arrPart.flg_enabled=='1'}{$arrPart.content}{/if}</textarea>
			</div>
			<div id="htmleditor"{if empty($arrPart.flg_enabled) or $arrPart.flg_enabled=='1'} style="display:none"{/if}>
				<textarea id="htmllink"{if $arrPart.flg_enabled=='2'} name="arrPart[content]"{/if} rows="13" class="form-control" style="width:99%">{if $arrPart.flg_enabled=='2'}{$arrPart.content}{/if}</textarea>
			</div>
			<br/>
			<div style="display:none;" id="validate_textarea" class="validation-advice input-notification error png_bg">Error: This field is required.</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" value="1" name="arrPart[flg_reset]"{if $arrPart.flg_reset == '1'} checked="checked"{/if} id="flg_reset"/>
				<label>Reset CSS styles</label>
			</div>
		</div>
		{if Core_Acs::haveAccess( array ('Campaign Opt Pro') )}
		<div class="form-group">
			<label>Clicks Limit: </label>
			<input type="number" class="required text-input medium-input form-control" value="0" name="arrPart[clicks_limit]"{if isset( $arrPart.clicks_limit )} value="{$arrPart.clicks_limit}"{/if} />
		</div>
		<div class="form-group">
			<label>Views Limit: </label>
			<input type="number" class="required text-input medium-input form-control" value="0" name="arrPart[views_limit]"{if isset( $arrPart.views_limit )} value="{$arrPart.views_limit}"{/if} />
		</div>
		<div class="form-group">
			<label class="label-control">Geo Location Traffic Redirect:</label>
			<div class="radio radio-primary">
				<input type="radio" name="arrPart[flg_geo_location]" value="1"{if $arrPart.flg_geo_location==1} checked="checked"{/if} class="flg_geo" />
				<label>Yes</label>
			</div>
			<div class="radio radio-primary">
				<input type="radio" name="arrPart[flg_geo_location]" value="0"{if !isset($arrPart.flg_geo_location) || $arrPart.flg_geo_location==0} checked="checked"{/if} class="flg_geo" />
				<label>No</label>
			</div>
		</div>

		<div class="flg_geo form-group"{if $arrPart.flg_geo_location == 1} style="display:block;"{else} style="display: none;"{/if}>
			<label class="label-control">Allowed Countries: </label>
			<div style="width: 100%; height: 210px; overflow : auto;">
			{foreach from=Project_Widget_Adapter_Copt_Parts::getCountries() item=i}
				<div class="checkbox checkbox-primary">
					<input type="checkbox" name="arrPart[geo_enabled][{$i.name}]" value="{$i.id}" rel="{$i.name}"{if isset($arrPart.geo_enabled[$i.name]) && $arrPart.geo_enabled[$i.name]==$i.id } checked="checked"{/if} class="geo_checkbox geo_changeopt"/>
					<label>{$i.name}</label>
				</div>
			{/foreach}
			</div>
		</div>
		{/if}
		
		<div class="form-group">
			<button type="submit" name="Submit" class="button button btn btn-success waves-effect waves-light"{is_acs_write}>Save</button>
		</div>
	</form>
</div>
{literal}
<script type="text/javascript">
var multibox={};
var mode;
var placeParam={};
var placeDo=function() {};
window.addEvent('domready', function() {
	CKEDITOR.replace( 'htmllink', {
		toolbar: 'Default'
	});
	$$('.flg_enabled').each(function(el){
		el.addEvent('click',function(e){
			if ( mode==this.value ) {
				return;
			}
			$('texteditor').setStyle('display',($('texteditor').getStyle('display')=='none'? 'block':'none'));
			$('htmleditor').setStyle('display',($('htmleditor').getStyle('display')=='none'? 'block':'none'));
			$('popup').setStyle('display',($('popup').getStyle('display')=='none'? 'block':'none'));
			mode=this.value;
		});
		if ( el.checked ) {
			mode=el.value;
		}
	});
	$$('.popup').cerabox({
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	$('text').addEvent ( 'click', function () {
		$('htmllink').erase('name');
		$('textlink').set({'name':'arrPart[content]'});
	});
	$('html').addEvent ( 'click', function () {
		$('textlink').erase('name');
		$('htmllink').set({'name':'arrPart[content]'});
	});
	$('snippetpart').addEvent('submit', function(e) {
		if ( ( $('text').checked&&$('textlink').value=='' )||( ( $('html').checked )&&( CKEDITOR.instances.htmllink.getData() == '' ) ) ) {
			e.stop();
			$('validate_textarea').setStyle('display','inline');
			return;
		}
		$('validate_textarea').setStyle('display','none');
	});
	placeDo=function() {
		if ( typeof(placeParam.video_title)!='undefined' ) {
			$('textlink').value+=($('textlink').value>'')? '\n'+placeParam.video_title:placeParam.video_title;
		}
		if ( typeof(placeParam.url_of_video)!='undefined' ) {
			$('textlink').value+=($('textlink').value>'')? '\n'+placeParam.url_of_video:placeParam.url_of_video;
		}
		if ( typeof(placeParam.body)!='undefined' ) {
			$('textlink').value+=($('textlink').value>'')? '\n'+placeParam.body:placeParam.body;
		}
		placeParam={};
	}

	$$('input.flg_geo').addEvent ( 'click', function () {
		if ( $(this).get('value') == '1' ) {
			$$('div.flg_geo').setStyle('display','block');
		} else {
			$$('div.flg_geo').setStyle('display','none');
		}
	});
});
</script>
{/literal}