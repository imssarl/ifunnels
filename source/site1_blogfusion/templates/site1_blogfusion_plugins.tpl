{include file='../../error.tpl' fields=['zip'=>'Zip File']}
{if $msg == 'added'}
{include file='../../message.tpl' type='info' message='Uploaded successfully'}
{/if}
{if $msg == 'restore'}
{include file='../../message.tpl' type='info' message='Restored successfully'}
{/if}
{if $msg == 'delete'}
{include file='../../message.tpl' type='info' message='The Plug-in was deleted successfully'}
{/if}
<br />

<div id="plugin_form" style="display:none;"> 
<form class="wh validate" enctype="multipart/form-data" action="{url name='site1_blogfusion' action='plugins'}" method="POST" >
	<fieldset>
		<div class="form-group">
			<label>Zip File <em>*</em></label>
			<input type="file" class="required filestyle" data-buttonname="btn-white" id="filestyle-0" tabindex="-1" style="position: absolute; clip: rect(0px 0px 0px 0px);" name="zip"/>
			<div class="bootstrap-filestyle input-group"><input type="text" class="form-control " placeholder="" disabled=""> <span class="group-span-filestyle input-group-btn" tabindex="0"><label for="filestyle-0" class="btn btn-white "><span class="icon-span-filestyle glyphicon glyphicon-folder-open"></span> <span class="buttonText">Choose file</span></label></span></div>
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" name="upload" {is_acs_write}>Upload</button>
		</div>
	</fieldset>
</form>
</div>
<table class="table table-striped">
	<tr>
		<td colspan="6">
			<a href="{url name='site1_blogfusion' action='plugin_search'}" class="mb" rel="">Search New Plugin</a>&nbsp;|&nbsp;<a href="#" id="upload" rel="block">Upload New Plugin</a>&nbsp;|&nbsp;<a href="{url name='site1_blogfusion' action='plugins' wg='restore=default'}" rel="<font color='red'>Note:</font> it won't affect the plugins you uploaded" class="tips">Restore default plugins</a>
		</td>
	</tr>
	<thead>
	<tr>
		<th>Title
		{if count($arrPlugins)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_blogfusion' action='plugins' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_blogfusion' action='plugins' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}		
		</th>
		<th>Author
		{if count($arrPlugins)>1}
			{if $arrFilter.order!='author--up'}<a href="{url name='site1_blogfusion' action='plugins' wg='order=author--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='author--dn'}<a href="{url name='site1_blogfusion' action='plugins' wg='order=author--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}		
		</th>
		<th>Version</th>
		<th width="45%">Description</th>
		<th width="15%">Added
		{if count($arrPlugins)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_blogfusion' action='plugins' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_blogfusion' action='plugins' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}		
		</th>
		<th width="20"></th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrPlugins item=i}
	<tr>
		<td>{if $i.url}<a href="{$i.url}" target="_blank">{/if}{$i.title}{if $i.url}</a>{/if}</td>
		<td>{if $i.author_url}<a href="{$i.author_url}" target="_blank">{/if}{$i.author}{if $i.author_url}</a>{/if}</td>
		<td>{$i.version}</td>
		<td>{$i.description}</td>
		<td align="center">{$i.added|date_local:$config->date_time->dt_full_format}</td>
		<td align="center"><a {is_acs_write} href="{url name='site1_blogfusion' action='plugins'}?del_id={$i.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a></td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
				{include file="../../pgg_backend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>

{literal}
<script type="text/javascript">
	$('upload').addEvent('click', function(e){
		e.stop();
		if($('plugin_form').style.display == 'block')
			$('plugin_form').style.display = 'none';
		else 
			$('plugin_form').style.display = 'block'
	});
window.addEvent('domready', function(){ 
	$$('.mb').cerabox({
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});	
	var optTips = new Tips('.tips');
});		
</script>
{/literal}