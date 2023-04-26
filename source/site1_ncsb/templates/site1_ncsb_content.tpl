<br/>
{if !empty($msg)}{include file="../../message.tpl" type='info' message=$msg}{/if}
{if !empty($error)}{include file="../../message.tpl" type='error' message=$error}{/if}
<div align="center">
	<div  style="width:58%;">
		<a class="" href="{url name='site1_ncsb' action='edit'}?id={$smarty.get.id}"   rel="create_form">General</a> |
		<a class="" href="{url name='site1_ncsb' action='content'}?id={$smarty.get.id}"   rel="create_form">Posts</a>
	</div>
</div>
<br/>
{if isset($arrEditContent)}
<form action="" method="POST" class="wh" style="width:60%;">
	<fieldset>
		<input type="hidden" name="arrPost[site_id]" value="{$smarty.get.id}" />
		<input type="hidden" name="arrPost[id]" value="{$smarty.get.post_id}" />
		<input type="hidden" name="arrPost[old_file]" value="{$arrEditContent.old_file}" />
		<legend>Edit post</legend>
		<div class="form-group">
			<label>Post title </label>
			<input type="text" title="Post title" class="text-input medium-input" name="arrPost[title]" value="{$arrEditContent.title}"/>
		</div>
		<div class="form-group">
			<label>Post author </label>
			<input type="text" title="Post author" name="arrPost[poster]" class="text-input medium-input" value="{$arrEditContent.poster}"/>
		</div>
		<div class="form-group">
			<label>Description </label>
			<textarea name="arrPost[description]" class="textarea text-input" style="height:200px;" >{$arrEditContent.description}</textarea>
		</div>
		<div class="form-group">
			<input type="submit" name="edit" class="button btn btn-success waves-effect waves-light" value="Edit post" {is_acs_write} />
		</div>

	</fieldset>
</form>
{/if}
<table width="100%" border="0">
	<tr>
		<td width="200" valign="top" align="left">
			<h3>Sites</h3>
			<ul class="v-menu">
				{foreach from=$menuSites item=i}
				<li> <a href="./?id={$i.id}">{$i.main_keyword|ellipsis:"30"}</a> </li>
				{/foreach}
			</ul>
		</td>
		<td align="left" valign="top">
<div class="grn">{$delete}</div>
{include file='../../error.tpl' fields=[]}
<form action="" method="POST" id="form_delete">
<table class="table  table-striped">
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px">
			<div class="checkbox checkbox-primary" style="margin: 0;">
				<input type="checkbox" id="delete_all">
				<label style="min-height: 14px;"></label>	
			</div>
		</th>
		<th align="center">Content{if count($arrContent)>1}{if $arrFilter.order!='title--up'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center" width="12%">Content From{if count($arrContent)>1}{if $arrFilter.order!='flg_from--up'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=flg_from--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_from--dn'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=flg_from--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center" width="15%">Content Type{if count($arrContent)>1}{if $arrFilter.order!='flg_source--up'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=flg_source--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_source--dn'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=flg_source--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center" width="12%">Date created{if count($arrContent)>1}{if $arrFilter.order!='added--up'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_ncsb' action='content' wg='orderPost=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center" width="80"></th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrContent item=i key=k}
	<tr{if $k%2=='0'} class="matros"{/if}>
		<td style="padding-right:0;">
			<div class="checkbox checkbox-primary">
				<input type="checkbox"  name="contentIds[]" value="{$i.id}" class="delete_checkbox">
				<label></label>	
			</div>
		</td>
		<td>{$i.title}</td>
		<td align="center">{if $i.flg_from == '1'}Self{elseif $i.flg_from == '2'}Publisher{/if}</td>
		<td align="center">{$contentTypeName=""}{foreach Project_Content::toLabelArray() item=name key=ids}{if {$name.flg_source}=={$i.flg_source}}{$contentTypeName = $name.title}{/if}{/foreach}{$contentTypeName}</td>
		<td align="center">{$i.added|date_format:$config->date_time->dt_full_format}</td>
		<td align="center">
			<a href="{$arrSite.url}{$i.link}.html" target="_blank"><img src="/skin/i/frontends/design/buttons/view.gif"/></a>
			<a {is_acs_write} href="?id={$smarty.get.id}&post_id={$i.id}"><img title="Edit" src="/skin/i/frontends/design/newUI/icons/pencil.png" /></a>
		</td>
	</tr>
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4">
			<button type="submit" class="button btn btn-success waves-effect waves-light">Delete</button>
			{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>

</form>
			

		</td>
	</tr>
</table>
{literal}
<script type="text/javascript">
	window.addEvent('domready', function(){
		$('delete_all').addEvent('click',function(){
			$$('.delete_checkbox').each(function(el){
				el.checked=$('delete_all').checked;
			});
		});
	});
</script>
{/literal}