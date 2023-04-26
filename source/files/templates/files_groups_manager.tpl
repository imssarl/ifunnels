{if $msg=='dub'}
<div class="grn">Items has been dublicated</div>
{elseif $msg=='not_dub'}
<div class="red">Items can't be dublicated</div>
{/if}
<p>
<div align="right" style="padding:0 2% 0 0;">
	<form method="get" class="wh" action="">
		<table width="100%">
			<tr>
				<td align="left">
					<input type="button" value="Submit" id="submit"/>
				</td>
				<td align="right">
					<input type="radio" name="flg_utilization" {if $smarty.get.flg_utilization=='0'||empty($smarty.get.flg_utilization)}checked='checked'{/if} value='0'>&nbsp;Exists
					<input type="radio" name="flg_utilization" {if $smarty.get.flg_utilization!='0'&&!empty($smarty.get.flg_utilization)}checked='checked'{/if} value='1'>&nbsp;Deleted
					<input type="submit" value="Filter" />
				</td>
			</tr>
		</table>
	</form>
</div>
</p>
<form action="" id="current-form" method="post">
<table class="info glow" style="width:98%">
<thead>
	<tr>
		<th style="padding-right:0;"><input type="checkbox" id="del" class="tooltip no-click" title="mass delete" rel="check to select all types" /></th>
		<th width="20%">title&nbsp;<em style="color:red">*</em>
			{if count($arrGroups)>1}
				{if $arrFilter.order!='title--up'}<a href="{url name='files' action='groups_manager' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='files' action='groups_manager' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
			{/if}	
		</th>
		<th width="20%">system name
			{if count($arrGroups)>1}
				{if $arrFilter.order!='sysname--up'}<a href="{url name='files' action='groups_manager' wg='order=sysname--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='sysname--dn'}<a href="{url name='files' action='groups_manager' wg='order=sysname--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
			{/if}	
		</th>
		<th width="30%">description</th>
		{if $smarty.get.flg_utilization=='1'}<th width="10%">deleted
			{if count($arrGroups)>1}
				{if $arrFilter.order!='deleted--up'}<a href="{url name='files' action='groups_manager' wg='order=deleted--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='deleted--dn'}<a href="{url name='files' action='groups_manager' wg='order=deleted--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
			{/if}	
		</th>{/if}
		<th width="10%">edited
			{if count($arrGroups)>1}
				{if $arrFilter.order!='edited--up'}<a href="{url name='files' action='groups_manager' wg='order=edited--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='edited--dn'}<a href="{url name='files' action='groups_manager' wg='order=edited--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
			{/if}	
		</th>
		{if $smarty.get.flg_utilization!='1'}<th width="10%">added
			{if count($arrGroups)>1}
				{if $arrFilter.order!='added--up'}<a href="{url name='files' action='groups_manager' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='files' action='groups_manager' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
			{/if}	
		</th>{/if}
		<th width="10%">&nbsp;</th>
	</tr>
</thead>
	<tr>
		<td>&nbsp;</td>
		<td style="padding-right:0px;" valign="top">
			<input type="text" name="arrGroups[0][title]" style="{if $arrErr.0.title}border-color:red;{/if}width:98%" class="elogin" value="{if empty($arrGroups.0.id)}{$arrGroups.0.title}{/if}" />
		</td>
		<td style="padding-right:0px;" valign="top">
			<input type="text" name="arrGroups[0][sysname]" style="{if $arrErr.0.sysname_exists}border-color:red;{/if}width:98%" class="elogin" value="{if empty($arrGroups.0.id)}{$arrGroups.0.sysname}{/if}"/>
		</td>
		<td><textarea name="arrGroups[0][description]" class="elogin">{if empty($arrGroups.0.id)}{$arrGroups.0.description}{/if}</textarea></td>
		{if $smarty.get.flg_utilization=='1'}<td>&nbsp;</td>{/if}
		<td>&nbsp;</td>
		{if $smarty.get.flg_utilization!='1'}<td>&nbsp;</td>{/if}
		<td>&nbsp;</td>
	</tr>
	{foreach from=$arrGroups key='k' item='v'}{if $v.id!=0}
	<tr{if $k%2=='0'} class="matros"{/if}>
		<input type="hidden" name="arrGroups[{$v.id}][id]" value="{$v.id}"/>
		<td style="padding-right:0;" valign="top">
			<input type="checkbox" name="arrGroups[{$v.id}][flg_utilization]" class="click-me-del" id="check-{$v.id}" value="1"{if $v.flg_utilization} checked="checked"{/if}/>
		</td>
		<td style="padding-right:0px;" valign="top">
			<input type="text" name="arrGroups[{$v.id}][title]" value="{$v.title}" style="{if $arrErr.{$v.id}.title}border-color:red;{/if}width:98%" class="elogin" />
		</td>
		<td style="padding-right:0px;" valign="top">
			<input type="text" name="arrGroups[{$v.id}][sysname]" value="{$v.sysname}" style="{if $arrErr.{$v.id}.sysname}border-color:red;{/if}width:98%" class="elogin" />
		</td>
		<td><textarea name="arrGroups[{$v.id}][description]" class="elogin">{$v.description}</textarea></td>
		{if $smarty.get.flg_utilization=='1'}<td style="padding-right:0px;" valign="top">
			{$v.deleted|date_local:$config->date_time->dt_full_format}
			<input type="hidden" name="arrGroups[{$v.id}][deleted]" value="{$v.deleted}"/>
		</td>{/if}
		<td style="padding-right:0px;" valign="top">
			{$v.edited|date_local:$config->date_time->dt_full_format}
			<input type="hidden" name="arrGroups[{$v.id}][edited]" value="{$v.edited}"/>
		</td>
		{if $smarty.get.flg_utilization!='1'}<td style="padding-right:0px;" valign="top">
			{$v.added|date_local:$config->date_time->dt_full_format}
			<input type="hidden" name="arrGroups[{$v.id}][added]" value="{$v.added}"/>
		</td>{/if}
		<td class="option" valign="top">
			<a href="{url name='files' action='files_manager'}?sysname={$v.sysname}" title="view group <{$v.title}>">files</a>{if $smarty.get.flg_utilization!='1'}&nbsp;|&nbsp;<a href="#" title="delete group {$v.title}" class="delete_group" uid="{$v.id}">delete</a>&nbsp;|&nbsp;<a href="{url name=$arrPrm.set_name action='input_file'}?dublicate={$v.id}" title="dublicate group {$v.title}">dublicate</a>{/if}
		</td>
	</tr>
	{/if}{/foreach}
</table>
<div align="right" style="padding:0 20px 0 0;">
	{include file="../../pgg_frontend.tpl"}
</div>
</form>
{literal}
<script type="text/javascript">
$('submit').addEvent('click',function(e){
	e && e.stop();
	if ($$('.check-me-del').some(function(item){
		return item.checked==true
	})) {
		if(!confirm('Your sure to delete selected groups?')) {
			return
		}
	}
	$('current-form').submit()
});
$$('.check-me-del').addEvent('click',function(e){
	e && e.stop();
	if ( !$('check-'+this.get('id')).get('checked') ) {
		$('check-'+this.get('id')).set('checked',true);
		if ($('check-'+this.get('id')).get('checked')) {
			$('submit').fireEvent('click');
		}
		$('check-'+this.get('id')).set('checked',false)
	}
});
$$('.delete_group').addEvent('click',function(e){
	e && e.stop();
	if ( confirm('Your sure to delete group?') ) {
		$('check-'+this.get('uid')).set('checked','checked');
		$('submit').fireEvent('click')
	}
});
</script>
{/literal}