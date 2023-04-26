<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
<div id="main-content">
	<div class="card-box">
	{if $arrList}
	<table class="table table-striped">
		<tr>
			<td colspan="6">
				<form method="post" action="" id="video-filter">
					<div style="float:left;">Category <select name="category" id='category-filter' class="btn-group selectpicker show-tick">
						<option value=''> - select - </option>
						{html_options options=$arrSelect.category selected=$smarty.get.category}
					</select></div>
					<div style="float:left;padding-left:3px;"><button type="submit" class="button btn btn-default waves-effect waves-light">Filter</button></div>
				</form>
			</td>
		</tr>
	<thead>
	<tr>
		<th>Category{if count($arrList)>1}
			{if $arrFilter!='category_id--up'}<a href="{url name='site1_video_manager' action='multibox' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='category_id--dn'}<a href="{url name='site1_video_manager' action='multibox' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Source{if count($arrList)>1}
			{if $arrFilter!='source_id--up'}<a href="{url name='site1_video_manager' action='multibox' wg='order=source_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='source_id--dn'}<a href="{url name='site1_video_manager' action='multibox' wg='order=source_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Title{if count($arrList)>1}
			{if $arrFilter!='title--up'}<a href="{url name='site1_video_manager' action='multibox' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='title--dn'}<a href="{url name='site1_video_manager' action='multibox' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Edited{if count($arrList)>1}
			{if $arrFilter!='edited--up'}<a href="{url name='site1_video_manager' action='multibox' wg='order=edited--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='edited--dn'}<a href="{url name='site1_video_manager' action='multibox' wg='order=edited--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Added{if count($arrList)>1}
			{if $arrFilter!='added--up'}<a href="{url name='site1_video_manager' action='multibox' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='added--dn'}<a href="{url name='site1_video_manager' action='multibox' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>{if !$smarty.get.multiselect}place{else}<input type="checkbox" id="select-all">{/if}</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="alt-row"{/if}>
		<td>&nbsp;{$arrSelect.category[$v.category_id]}</td>
		<td>{$arrSelect.source[$v.source_id]}</td>
		<td>{$v.title}</td>
		<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td align="center">
			<div style="display:none;" id="video_{$v.id}_video_title">{$v.title}</div>
			<div style="display:none;" id="video_{$v.id}_body">{$v.body}</div>
			<div style="display:none;" id="video_{$v.id}_url_of_video">{$v.url_of_video}</div>		
			<div {if $smarty.get.multiselect}style="display:none;"{/if}>
			<a href="#" class="place_full" rel="video_{$v.id}">All</a> |
			<a href="#" class="place_url" rel="video_{$v.id}">URL</a> |
			<a href="#" class="place_embed" rel="video_{$v.id}">Embed Code</a>			
			</div>
			<input type="checkbox" {if $smarty.get.multiselect}style="display:block;"{else}style="display:none;"{/if} class="chk_item" value="{$v.id}">
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr><td colspan="{$arrFilter.fields_num+3}">{include file="../../pgg_frontend.tpl"}</td></tr>
	</tfoot>
	</table>
	{if $smarty.get.multiselect}<input type="button" value="Choose" id="choose" >{/if}
	{else}
		<p>no videos found</p>
	{/if}
	</div>
	<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="/skin/_js/ui.js"></script>
	<script src="/skin/light/js/bootstrap.min.js"></script>
	<script src="/skin/light/js/detect.js"></script>
	<script src="/skin/light/js/fastclick.js"></script>
	<script src="/skin/light/js/jquery.slimscroll.js"></script>
	<script src="/skin/light/js/jquery.blockUI.js"></script>
	<script src="/skin/light/js/waves.js"></script>
	<script src="/skin/light/js/wow.min.js"></script>
	<script src="/skin/light/js/jquery.nicescroll.js"></script>
	<script src="/skin/light/js/jquery.scrollTo.min.js"></script>
	<script src="/skin/light/plugins/peity/jquery.peity.min.js"></script>
	<!-- jQuery  -->
	<script src="/skin/light/plugins/waypoints/lib/jquery.waypoints.js"></script>
	<script src="/skin/light/plugins/counterup/jquery.counterup.min.js"></script>
	<script src="/skin/light/plugins/jquery-knob/jquery.knob.js"></script>
	<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
	<script src="/skin/light/js/jquery.core.js"></script>
	<script src="/skin/light/js/jquery.app.js"></script>
<script type="text/javascript">
{literal}
window.addEvent('domready', function(){
	$('video-filter').addEvent('submit',function(e){
		e.stop();
		var myURI=new URI(window.location);
		if ( $('category-filter').value=='' ) {
			myURI.setData(new Hash(myURI.getData()).filter(function(value, key){return key!='category';}));
		} else {
			myURI.setData({category:$('category-filter').value}, true);
		}
		myURI.go();
	});
	$$('.place_full').each(function(el){
		el.addEvent('click',function(e,el){
			el&&el.stop();
			window.parent.placeParam={
				body: $(e.rel+'_body').get('html'),
				url_of_video: $(e.rel+'_url_of_video').get('html'),
				video_title: $(e.rel+'_video_title').get('html')
			};
			window.parent.placeDo();
			window.parent.multibox.boxWindow.close();
		}.bind(this, el));
	});
	$$('.place_url').each(function(el){
		el.addEvent('click',function(e,el){
			el&&el.stop();
			window.parent.placeParam={url_of_video: $(e.rel+'_url_of_video').get('html')};
			window.parent.placeDo();
			window.parent.multibox.boxWindow.close();
		}.bind(this, el));
	});
	$$('.place_embed').each(function(el){
		el.addEvent('click',function(e,el){
			el&&el.stop();
			window.parent.placeParam={body: $(e.rel+'_body').get('html')};
			window.parent.placeDo();
			window.parent.multibox.boxWindow.close();
		}.bind(this, el));
	});
	if( $('choose') ) {
		// initialized list
		if( window.parent.placeParam ){
			$$('.chk_item').each( function( v ){
				window.parent.placeParam.each( function( i ){
					if ( i.id == v.value ) {
						v.checked = true;
						if ( window.parent.flgStatus != 0) {
							var arrList = JSON.decode(window.parent.jsonContentList);
							if( arrList.some(function(item){ return item.id == v.value;})) {
								v.disabled = true;
							}
						}
					}
				});
			});
		}
		
		$('select-all').addEvent( 'click', function() {
			$$('.chk_item').each( function( el ){
				el.checked = this.checked;
			},this );
		});
		
		$('choose').addEvent('click', function() {
			var arrChk = new Array();
			var i = 0;
			$$('.chk_item').each( function( v ) {
				if( v.checked ) {
					arrChk[i] = {'id':v.value, 'title':$('video_'+v.value+'_video_title').get('html')};
					i++;
				}
			});
			window.parent.placeParam = arrChk;
			window.parent.placeDo();
			window.parent.multibox.boxWindow.close();
		});
		
	}
});
jQuery(document).ready(function() {

	jQuery('.selectpicker').selectpicker({
		style: 'btn-info',
		size: 4
	});
});
{/literal}
</script>
</div>
</body>
</html>