
<div align="right" style="padding:0 2% 0 0;">
	<form method="get" class="wh">
		File Type: 
		<select name="flg_type">
		<option {if $smarty.get.flg_type == ''}selected='selected'{/if} value=""> All types </option>
		<option {if $smarty.get.flg_type == '0'}selected='selected'{/if} value="0">Other files</option>
		<option {if $smarty.get.flg_type == '1'}selected='selected'{/if} value="1">Audio files</option>
		<option {if $smarty.get.flg_type == '2'}selected='selected'{/if} value="2">Video files</option>
		<option {if $smarty.get.flg_type == '3'}selected='selected'{/if} value="3">Images</option>
		</select><br/>
		Status:
		<select name="flg_utilization">
		<option {if $smarty.get.flg_utilization == ''}selected='selected'{/if} value=""> All files</option>
		<option {if $smarty.get.flg_utilization == '0'}selected='selected'{/if} value="0">Usual files</option>
		<option {if $smarty.get.flg_utilization == '1'}selected='selected'{/if} value="1">Utilizated files</option>
		</select><br/>
		File ID: <input type="text" name="file_id" value="{$smarty.get.file_id}"/><br/>
		File Title: <input type="text" name="file_title" value="{$smarty.get.file_title}"/><br/>
		<input type="hidden" name="sysname" value="{$smarty.get.sysname}"/>
		<table width="100%">
			<tr>
			<td align="left">
				{if !empty($arrFiles)}<input type="button" value="Submit" id="submit"/>{/if}
			</td><td align="right">
				<input type="submit" value="Filter" />
			</td>
			</tr>
		</table>
	</form>
</div>
{if !empty($arrFiles)}
<form action="" id="current-form" method="post">
<table class="info glow" style="width:98%">
<thead>
	<tr>
		<th width="10%">status</th>
		<th width="10%">handling</th>
		<th width="35%">title{include file="../../ord_backend.tpl" field='title'}</th>
		<th width="12%">added{include file="../../ord_backend.tpl" field='added'}</th>
		<th width="12%">edited{include file="../../ord_backend.tpl" field='edited'}</th>
		<th width="13%">converted{include file="../../ord_backend.tpl" field='converted'}</th>
		<th width="10%">&nbsp;</th>
	</tr>
</thead>
	{foreach from=$arrFiles key='k' item='v'}
	<tr{if $k%2=='0'} class="matros"{/if}>
		<input type="hidden" name="arrFiles[{$v.id}][id]" value="{$v.id}"/>
		<td style="padding-right:0px;" valign="top">
			<select name="arrFiles[{$v.id}][flg_utilization]" class="elogin">
				<option value="0" {if $v.flg_utilization=='0'}selected="selected"{/if}>usual file</option>
				<option value="1" {if $v.flg_utilization=='1'}selected="selected"{/if}>removed file</option>
				<option value="2" {if $v.flg_utilization=='2'}selected="selected"{/if}>ajax/flash uploaders</option>
			</select>
		</td>
		<td style="padding-right:0px;" valign="top">
			<select name="arrFiles[{$v.id}][flg_handling]" class="elogin">
				<option value="0" {if $v.flg_handling=='0'}selected="selected"{/if}>processed</option>
				<option value="1" {if $v.flg_handling=='1'}selected="selected"{/if}>processing</option>
				<option value="2" {if $v.flg_handling=='2'}selected="selected"{/if}>process</option>
				<option value="3" {if $v.flg_handling=='3'}selected="selected"{/if}>error</option>
			</select>
		</td>
		<td style="padding-right:0px;" valign="top">
			{$v.title}
		</td>
		<td style="padding-right:0px;" valign="top">
			{$v.added|date_local:$config->date_time->dt_full_format}
		</td>
		<td style="padding-right:0px;" valign="top">
			{$v.edited|date_local:$config->date_time->dt_full_format}
		</td>
		<td style="padding-right:0px;" valign="top">
			{$v.converted|date_local:$config->date_time->dt_full_format}
		</td>
		<td class="option" valign="top">
			<a rel="width:800,height:400" href="{url name='files' action='file_info'}?id={$v.id}" title="view file {$v.title}" class="popup">view</a>
			{if $arrPrm.set_name!='files'}
				&nbsp;|&nbsp;
				<a href="{url name=$arrPrm.set_name action='input_file'}?id={$v.id}&sysname={$smarty.get.sysname}" title="edit file {$v.title}" class="popup">edit</a>
			{/if}
		</td>
	</tr>
	{/foreach}
</table>
<div align="right" style="padding:0 20px 0 0;">
	{include file="../../pgg_frontend.tpl"}
</div>
</form>
{literal}
<script type="text/javascript">
$('submit').addEvent('click',function(e){
	$('current-form').submit();
});
multibox = new CeraBox( $$('.popup'), {
	group: false,
	width:'80%',
	height:'80%',,
	displayTitle: true,
	titleFormat: '{title}'
});
</script>
{/literal}
{/if}