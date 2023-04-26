{include file='../../error.tpl' fields=['zip'=>'Zip File']}
{if $msg == 'added'}
<p class="grn">Uploaded successfully</p> 
{/if}
{if $msg == 'delete'}
<p class="grn">The Theme was deleted successfully</p> 
{/if}
<form action="" method="POST" style="display:none;" enctype='multipart/form-data' id="add_plugin">
	<table>
		<tr>
			<td>Priority</td>
			<td><input type="text" name="theme[priority]" value="0" /></td>
		</tr>
		<tr>
			<td>Proprietary</td>
			<td><input type="checkbox" value="1" name="theme[flg_prop]"></td>
		</tr>
		<tr>
			<td>Zip file</td>
			<td><input type="file" name="zip" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="add" value="Add"></td>
		</tr>
	</table>
</form>

<table class="info glow">
<thead >
<tr>
	<th width="70">Priority{include file="../../ord_backend.tpl" field='priority'}</th>
	<th width="80">Proprietary{include file="../../ord_backend.tpl" field='flg_prop'}</th>
	<th width="200">Title{include file="../../ord_backend.tpl" field='title'}</th>
	<th width="70">Author{include file="../../ord_backend.tpl" field='author'}</th>
	<th width="70">Version{include file="../../ord_backend.tpl" field='version'}</th>
	<th>Description</th>
	<th width="150">Added{include file="../../ord_backend.tpl" field='added'}</th>
	<th width="50">&nbsp;</th>
</tr>
</thead>
	<tr>
		<td colspan="5"><a href="#" id="link_add">Add</a> new theme</td>
	</tr>
<tbody>
{foreach from=$arrList key='k' item='v'}
<tr {if $k%2=='0'} class="matros"{/if}>
	<td align="center">{$v.priority}</td>
	<td align="center">{if $v.flg_prop}yes{else}no{/if}</td>
	<td>{if $v.url}<a href="{$v.url}" target="_blank">{/if}{$v.title}{if $v.url}</a>{/if} (<a href="#" class="screenshot" rel="<img src='{$v.preview}'>" style="text-decoration:none">preview</a>)</td>
	<td>{if $v.author_url}<a href="{$v.author_url}" target="_blank">{/if}{$v.author}{if $v.author_url}</a>{/if}</td>
	<td>{$v.version}</td>
	<td>{$v.description}</td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td class="option">
			<a href="{url name='admin_blogfusion' action='themes'}?delete={$v.id}">del</a>
	</td>
</tr>
{/foreach}
</tbody>
</table>
<br/>
<div align="right" style="padding:0 20px 0 0;">
{include file="../../pgg_frontend.tpl"}
</div>
{literal}
<script type="text/javascript">
$('link_add').addEvent('click', function(e){
	e.stop();
	if($('add_plugin').getStyle('display')=='none') {
		$('add_plugin').show('block')
	}else{
		$('add_plugin').hide()
	}
});
window.addEvent('domready', function(){
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){
		el.addEvent('click',function(e){
			e.stop()
		})
	})
});

</script>
{/literal}