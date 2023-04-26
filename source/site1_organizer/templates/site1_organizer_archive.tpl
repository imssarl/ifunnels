<br />
{if $msg == 'delete'}
<div class="grn">Note has been deleted</div>
{elseif $msg=='delete_error'}
<div class="red">Note can't be deleted</div>
{elseif $msg=='created'}
<div class="grn">Note has been created</div>
{elseif $msg=='saved'}
<div class="grn">Note has been saved</div>
{/if}
{if $error}
<div class="red">{$error}</div>
{/if}
<form action="" class="wh" id="current-form" style="display:none; width:50%" method="post">
<input type="hidden" name="arrData[id]" id="form-id" />
<fieldset>
	<legend id="legend">Add Note</legend>
	<div class="form-group">
		<label>Title</label>
		<input type="text" id="form-title" class="form-control" name="arrData[title]" value="{$arrData.title}" />
	</div>
	<div class="form-group">
		<label>Note</label>
		<textarea rows="15" id="form-note" class="form-control" name="arrData[description]" >{$arrData.description}</textarea>
	</div>
	<div class="form-group">
		<button type="submit" class="btn btn-success waves-effect waves-light">Save</button>
	</div>
</fieldset>
</form>
<table style="width:100%" class="table  table-striped">
	<thead>
	<tr>
		<th style="padding-right:0;" width="30">S.No</th>
		<th width="30%">Title{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_organizer' action='archive' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_organizer' action='archive' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th>Note</th>
		<th width="10%">Date{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_organizer' action='archive' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_organizer' action='archive' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="15%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="matros"{/if}>
		<td style="padding-right:0;">{counter}</td>
		<td>&nbsp;{$v.title|truncate:'150':'...'}<span style="display:none;" id="title-{$v.id}">{$v.title}</span></td>
		<td>{$v.description|truncate:'150':'...'}<span style="display:none;" id="note-{$v.id}">{$v.description}</span></td>
		<td align="center">{$v.added|date_format:'Y-m-d'}</td>
		<td align="center">
			<a {is_acs_write} href="#mb"  rel="type:element,width:600,height:auto" id="{$v.id}" class="mb view"><img style="display:inline" title="Edit" src="/skin/i/frontends/design/buttons/view.gif" /></a>
			<a {is_acs_write} href="#" class="edit" rel="{$v.id}"><img title="Edit" src="/skin/i/frontends/design/buttons/edit.png" /></a>
			<a {is_acs_write} href="{url name='site1_organizer' action='archive'}?delete={$v.id}"><img title="Delete" src="/skin/i/frontends/design/buttons/delete.png" /></a>
			<a {is_acs_write} href="{url name='site1_organizer' action='archive'}?unarchive={$v.id}">Un-Archive</a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
</table>
<div  style="display:none;padding:20px;">
<div id="mb">
	<h3 id="title"></h3>
	<p id="note"></p>
</div>
</div>
<div align="right">
{include file="../../pgg_backend.tpl"}
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
});
</script>
{/literal}