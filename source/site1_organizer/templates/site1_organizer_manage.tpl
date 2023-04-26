<br />
{if $msg == 'delete'}
	{include file='../../message.tpl' type='info' message='Note has been deleted'}
{elseif $msg=='delete_error'}
	{include file='../../message.tpl' type='error' message='Note can\'t be deleted'}
{elseif $msg=='created'}
	{include file='../../message.tpl' type='info' message='Note has been created'}
{elseif $msg=='saved'}
	{include file='../../message.tpl' type='info' message='Note has been saved'}
{/if}
{if $error}
	{include file='../../message.tpl' type='error' message=$error}
{/if}
<p>
	<button type="submit" value="" id="add" class="button btn btn-success waves-effect waves-light">Add Note</button>
</p>
<form action="" class="wh" id="current-form" style="display:none;" method="post">
	<input type="hidden" name="arrData[id]" id="form-id" />
	<legend id="legend">Add Note</legend>
	<p>
		<label>Title</label><input type="text" id="form-title" class="medium-input text-input" name="arrData[title]" value="{$arrData.title}" />
	</p>
	<p>
		<label>Note</label><textarea rows="15" id="form-note" class="medium-input" name="arrData[description]" >{$arrData.description}</textarea>
	</p>
	<p>
		<input type="submit" value="Save" class="button" />
	</p>
</form>
<table class="table  table-striped">
	<thead>
	<tr>
		<th style="padding-right:0;" width="30">S.No</th>
		<th width="30%">Title{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_organizer' action='manage' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_organizer' action='manage' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Note</th>
		<th width="10%">Date{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_organizer' action='manage' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_organizer' action='manage' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="alt-row"{/if}>
		<td style="padding-right:0;">{counter}</td>
		<td>&nbsp;{$v.title|truncate:'150':'...'}<span style="display:none;" id="title-{$v.id}">{$v.title}</span></td>
		<td>{$v.description|truncate:'150':'...'}<span style="display:none;" id="note-{$v.id}">{$v.description}</span></td>
		<td align="center">{$v.added|date_format:'Y-m-d'}</td>
		<td align="center">
			<a {is_acs_write} href="#mb"  rel="type:element,width:600,height:auto" id="{$v.id}" class="mb view"><img style="display:inline" title="View" src="/skin/i/frontends/design/buttons/view.gif" /></a>
			<a {is_acs_write} href="#" class="edit" rel="{$v.id}"><img title="Edit" src="/skin/i/frontends/design/buttons/edit.png" /></a>
			<a {is_acs_write} href="{url name='site1_organizer' action='manage'}?delete={$v.id}"><img title="Delete" src="/skin/i/frontends/design/buttons/delete.png" /></a>
			<a {is_acs_write} href="{url name='site1_organizer' action='manage'}?archive={$v.id}">archive</a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="5">
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
<div style="display:none;padding:20px;">
<div id="mb" >
	<h3 id="title"></h3>
	<p id="note"></p>
</div>
</div>

{literal}
<script>
var multibox = {};
window.addEvent('domready',function(){
	$$('.view').each(function(el){ 
		el.addEvent('click',function(){
			$('title').set('html',$('title-'+el.id).get('html'));
			$('note').set('html',$('note-'+el.id).get('html'));
		});
	});
	$$('.edit').each(function(el){
		el.addEvent('click',function(e){ 
			e.stop();
			$('legend').set('html','Edit Note');
			$('form-id').set('value',el.rel);
			$('form-title').set('value',$('title-'+el.rel).get('html'));
			$('form-note').set('value',$('note-'+el.rel).get('html'));
			$('current-form').setStyle('display', 'block' );
		});
	});
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	$('add').addEvent('click',function(e){
		e.stop();
		$('form-id').set('value','');
		$('form-title').set('value','');
		$('form-note').set('value','');		
		$('legend').set('html','Add Note');
		$('current-form').setStyle('display', ($('current-form').style.display=='none')?'block':'none' );
	});
});
</script>
{/literal}