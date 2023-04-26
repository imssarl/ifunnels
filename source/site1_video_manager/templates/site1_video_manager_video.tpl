{if $msg == 'delete'}
{include file='../../message.tpl' type='info' message='Video has been deleted'}
{elseif $msg=='delete_error'}
{include file='../../message.tpl' type='error' message='Video can\'t be deleted'}
{elseif $msg=='duplicated'}
{include file='../../message.tpl' type='info' message='Duplicate Video has been created'}
{elseif $msg=='duplicated_error'}
{include file='../../message.tpl' type='error' message='Duplicate Video can\'t be created'}
{elseif $msg=='created'}
{include file='../../message.tpl' type='info' message='Video has been created'}
{elseif $msg=='saved'}
{include file='../../message.tpl' type='info' message='Video has been saved'}
{/if}
{if $error}
{include file='../../message.tpl' type='error' message=$error}
{/if}
{include file="../../error.tpl"}
{if $arrList}
<form action="" id="current-form" method="post">
<input type="hidden" name="mode" value="" id="mode" />
<table>
	<tr>
		<td colspan="7">
			Category <select name="category" id='category-filter'>
				<option value=''> - select - </option>
				{html_options options=$arrSelect.category selected=$smarty.get.category}
			</select> <input type="submit" value="Filter" class="button" {is_acs_write} />
		</td>
	</tr>
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px"><input type="checkbox" id="del" class="tooltip" title="mass delete" rel="check to select all" /></th>
		<th>Category{if count($arrList)>1}
			{if $arrFilter!='category_id--up'}<a href="{url name='site1_video_manager' action='video' wg='order=category_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='category_id--dn'}<a href="{url name='site1_video_manager' action='video' wg='order=category_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Source{if count($arrList)>1}
			{if $arrFilter!='source_id--up'}<a href="{url name='site1_video_manager' action='video' wg='order=source_id--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='source_id--dn'}<a href="{url name='site1_video_manager' action='video' wg='order=source_id--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Title{if count($arrList)>1}
			{if $arrFilter!='title--up'}<a href="{url name='site1_video_manager' action='video' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='title--dn'}<a href="{url name='site1_video_manager' action='video' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Edited{if count($arrList)>1}
			{if $arrFilter!='edited--up'}<a href="{url name='site1_video_manager' action='video' wg='order=edited--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='edited--dn'}<a href="{url name='site1_video_manager' action='video' wg='order=edited--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Added{if count($arrList)>1}
			{if $arrFilter!='added--up'}<a href="{url name='site1_video_manager' action='video' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter!='added--dn'}<a href="{url name='site1_video_manager' action='video' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="alt-row"{/if}>
		<td style="padding-right:0;"><input type="checkbox" name="del[{$v.id}]" class="check-me-del" id="check-{$v.id}" /></td>
		<td>&nbsp;{$arrSelect.category[$v.category_id]}</td>
		<td>{$arrSelect.source[$v.source_id]}</td>
		<td>{$v.title}</td>
		<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
		<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
		<td align="center">
			<a {is_acs_write} href="{url name='site1_video_manager' action='edit'}?id={$v.id}"><img title="Edit" src="/skin/i/frontends/design/buttons/edit.png" /></a>
			<a {is_acs_write} href="{url name='site1_video_manager' action='view'}?id={$v.id}" class="vid" rel="" title="'{$v.title}' preview"><img title="View" src="/skin/i/frontends/design/buttons/view.gif" /></a>
			<a {is_acs_write} href="{url name='site1_video_manager' action='video'}?dup={$v.id}"><img title="Duplicate" src="/skin/i/frontends/design/buttons/duplicate.png" /></a>
			<a {is_acs_write} href="#" rel="{$v.id}" class="click-me-del" id="{$v.id}"><img title="Delete" src="/skin/i/frontends/design/buttons/delete.png" /></a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="7">
				<input type="submit" value="Delete" id="delete" class="button" {is_acs_write} />
				{include file="../../pgg_frontend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
</form>
{else}
	<p>no videos found</p>
{/if}

{literal}
<script type="text/javascript">

window.addEvent('domready',function(){
	$('current-form').addEvent('submit',function(e){
		e.stop();
		var myURI=new URI();
		if ( $('category-filter').value=='' ) {
			myURI.setData(new Hash(myURI.getData()).filter(function(value, key){return key!='category';}));
		} else {
			myURI.setData({category:$('category-filter').value}, true);
		}
		myURI.go();
	});

	checkboxToggle($('del'));
	$('delete').addEvent('click',function(e){
		e && e.stop();
		if (!$$('.check-me-del').some(function(item){
			return item.checked==true;
		})) {
			alert( 'Please, select one checkbox at least' );
			return;
		}
		if(!confirm('Your sure to delete selected items?')) {
			return;
		}
		$('mode').set('value','delete');
		$('current-form').submit();
	});
	$$('.click-me-del').addEvent('click',function(e){
		e && e.stop();
		var el='check-'+this.get('id');
		if ( !$(el).get('checked') ) {
			$(el).set('checked',true);
			if ($(el).get('checked')) {
				$('delete').fireEvent('click');
			}
			$(el).set('checked',false);
		}
	});
});
</script>
{/literal}

{literal}
<script>
var multibox = {};
window.addEvent("domready", function(){
	multibox=new CeraBox( $$('.vid'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}