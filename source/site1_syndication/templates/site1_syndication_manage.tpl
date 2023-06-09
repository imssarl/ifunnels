<br/>
{if $msg == 'delete'}
{include file='../../message.tpl' type='info' messages='Project has been deleted'}
{elseif $msg=='delete_error'}
{include file='../../message.tpl' type='error' messages='Project can\'t be deleted'}
{elseif $msg=='created'}
{include file='../../message.tpl' type='info' messages='Project has been created'}
{elseif $msg=='saved'}
{include file='../../message.tpl' type='info' messages='Project has been saved'}
{/if}
{if $error}
	{include file='../../message.tpl' type='error' messages=$error}
{/if}

<form action="" id="current-form" method="post">
<input type="hidden" name="mode" value="" id="mode" />
<table style="width:100%">
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px"><input type="checkbox" id="del" class="tooltip" title="mass delete" rel="check to select all" /></th>
		<th>Title{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_syndication' action='manage' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_syndication' action='manage' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="15%">Status{if count($arrList)>1}
			{if $arrFilter.order!='flg_status--up'}<a href="{url name='site1_syndication' action='manage' wg='order=flg_status--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_status--dn'}<a href="{url name='site1_syndication' action='manage' wg='order=flg_status--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Added{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_syndication' action='manage' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_syndication' action='manage' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}</th>
		<th width="10%">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item='v' key='k'}
	<tr{if $k%2!='0'} class="alt-row"{/if}>
		<td style="padding-right:0;"><input type="checkbox" name="del[{$v.id}]" class="check-me-del" id="check-{$v.id}" /></td>
		<td>&nbsp;{$v.title}</td>
		<td align="center">{if $v.flg_status == 0}draft{elseif $v.flg_status == 1}rejected{elseif $v.flg_status == 2}pending review{elseif $v.flg_status == 3}approved{elseif $v.flg_status == 4}in progress{elseif $v.flg_status == 5}completed{/if}</td>
		<td align="center">{$v.added|date_format:"%Y-%m-%d"}</td>
		<td align="center">
			<a href="{url name='site1_syndication' action='create'}?id={$v.id}"><img title="Edit" src="/skin/i/frontends/design/buttons/edit.png" /></a>
			<a href="#" rel="{$v.id}" class="click-me-del" id="{$v.id}"><img title="Delete" src="/skin/i/frontends/design/buttons/delete.png" /></a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="5">
				<input type="submit" value="Delete" id="delete" class="button" />
				{include file="../../pgg_frontend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
</form>

{literal}
<script>
window.addEvent('domready',function(){
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