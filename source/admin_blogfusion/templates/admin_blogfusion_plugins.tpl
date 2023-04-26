{include file='../../error.tpl' fields=['zip'=>'Zip File']}
{if $msg == 'added'}
<p class="grn">Uploaded successfully</p> 
{/if}
{if $msg == 'delete'}
<p class="grn">The Plug-in was deleted successfully</p> 
{/if}
<form action="" method="POST" style="display:none;" enctype='multipart/form-data' id="add_plugin">
	<table>
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
<thead>
<tr>
	<th>Title{include file="../../ord_backend.tpl" field='title'}</th>
	<th>Author{include file="../../ord_backend.tpl" field='author'}</th>
	<th width="80">Version{include file="../../ord_backend.tpl" field='version'}</th>
	<th>Description</th>
	<th>Added{include file="../../ord_backend.tpl" field='added'}</th>
	<th>&nbsp;</th>
</tr>
</thead>
	<tr>
		<td colspan="4"><a href="#" id="link_add">Add</a> new plugin</td>
	</tr>
<tbody>
{foreach from=$arrList key='k' item='v'}
<tr {if $k%2=='0'} class="matros"{/if}>
	<td><a href="{$v.url}" target="_blank">{$v.title}</a></td>
	<td>{$v.author}</td>
	<td>{$v.version}</td>
	<td>{$v.description}</td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
	<td class="option">
			<a href="{url name='admin_blogfusion' action='plugins'}?delete={$v.id}">del</a>
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
</script>
{/literal}