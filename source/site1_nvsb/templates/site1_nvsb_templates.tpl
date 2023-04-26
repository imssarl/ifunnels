{if $msg == 'saved'}
<p class="grn">Template has been saved successfully</p>
{/if}
{if $msg == 'copy'}
<p class="grn">Template has been duplicated successfully</p>
{/if}
{if $msg == 'added'}
<p class="grn">Uploaded successfully</p>
{/if}
{if $msg == 'restore'}
<p class="grn">Restored successfully</p>
{/if}
{if $msg == 'delete'}
<p class="grn">The Theme was deleted successfully</p>
{/if}
<br />
{include file='../../error.tpl' fields=['zip'=>'Zip File']}
<br />

<a href="#" id="upload" rel="block">Upload New Template</a>&nbsp;|&nbsp;
<a href="{url name='site1_nvsb' action='templates' wg='restore=default'}" rel="<font color='red'>Note:</font> it won't affect the themes you uploaded" class="tips">Restore default themes</a>

<div id="theme_form" style="display:none;"> 
<form class="wh validate" action="" method="POST" enctype="multipart/form-data">
	<fieldset>
		<p>
			<label>Zip File <em>*</em></label><input type="file" class="required" name="zip"/>
		</p>
		<p>
			<input type="submit" name="upload" value="Upload" class="button" {is_acs_write} />
		</p>
	</fieldset>
</form>
</div>
<form id="copy_form"  action="" method="POST" class="wh validate"  style="display:none;">
<input type="hidden" name="arrCopy[id]" id="copy_id">
<fieldset>
	<legend>Copy template</legend>
	<p>
		<label>Old Name:</label><b id="old_name"></b>
	</p>
	<p>
		<label>New Name <em>*</em> </label><input type="text" name="arrCopy[name]" id="copy_new_name" class="required medium-input text-input"/>
	</p>
	<p>
		<input type="submit" name="copy" value="Copy" class="button" {is_acs_write} />
	</p>
</fieldset>
</form>
<table>
	<thead>
	<tr>
		<th>Title
		{if count($arrList)>1}
			{if $arrFilter.order!='title--up'}<a href="{url name='site1_nvsb' action='templates' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_nvsb' action='templates' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}		
		</th>
		<th width="24%">Description</th>
		<th width="25%">Installed on URLs</th>
		<th width="12%">Added
		{if count($arrList)>1}
			{if $arrFilter.order!='added--up'}<a href="{url name='site1_nvsb' action='templates' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_nvsb' action='templates' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
		{/if}		
		</th>
		<th width="100">Action</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i}
	<tr>
		<td>{if $i.url}<a href="{$i.url}" target="_blank">{/if}{$i.title}{if $i.url}</a>{/if} {if $i.preview}(<a href="#" class="screenshot" rel="<img src='{$i.preview}'>" style="text-decoration:none">preview</a>){/if}</td>
		<td>{$i.description}</td>
		<td>
		{foreach from=$arrSites item=j}
		{if $j.template_id == $i.id}
		<a href="{$j.url}" target="_blank">{$j.url}</a><br />
		{/if}
		{/foreach}
		</td>
		<td align="center">{$i.added|date_local:$config->date_time->dt_full_format}</td>
		
		<td align="center">
		{if $i.flg_belong==1}
		<a href="{url name='site1_nvsb' action='templates'}?delete={$i.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
		<a href="{url name='site1_nvsb' action='edit_templates'}?id={$i.id}" title="Edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
		{/if}
		<input type="hidden" id="title_{$i.id}" value="{$i.title}">
		<a href="#" rel="{$i.id}" class="copy-link"  {is_acs_write} ><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></a>
		</td>
	</tr>	
	{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
				{include file="../../pgg_frontend.tpl"}
			</td>
		</tr>
	</tfoot>
</table>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	$$('.copy-link').each(function( a ){
		a.addEvent('click', function( e ){
			e && e.stop();
			$('copy_form').setStyle('display','block');
			$('copy_id').value = a.rel;
			$('old_name').set('html', $('title_'+a.rel).value );
		});
	});
	$('upload').addEvent('click', function(e){
		e.stop();
		if($('theme_form').style.display == 'block')
			$('theme_form').style.display = 'none';
		else 
			$('theme_form').style.display = 'block'
	});
	var optTips2 = new Tips('.tips');
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){ el.addEvent('click',function(e){ e.stop(); }); });
});	
</script>
{/literal}