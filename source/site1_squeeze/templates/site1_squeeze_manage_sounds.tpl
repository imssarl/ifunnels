<script src="/skin/_js/audiojs/audio.js"></script>
<form method="post" action="" id="users-filter">
{if $upload==true}<div class="grn">File was uploaded</div>{/if}
{if $delete==true}<div class="grn">File was deleted</div>{/if}
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th>Title</th>
	<th width="230">Preview</th>
	<th>Category</th>
	<th width="180">Options</th>
</tr>
</thead>
<tbody>
{foreach $arrList as $file}
<tr{if ($file@iteration-1) is div by 2} class="matros"{/if}>
	<td><span style="margin:0px" id="item_name_{$file.id}" alt="{$file.description}">{$file.title|truncate:30:"..."}</span></td>
	<td><audio src="{$file.path_web}{$file.name_system}" preload="none" /></td>
	<td>{$arrCategoryTree.{$arrCategoryTree.{$file.category_id}.pid}.title} {$arrCategoryTree.{$file.category_id}.title}</td>
	<td class="option"><a href="{url name='site1_squeeze' action='manage_sounds' wg="del={$file.id}"}">del</a> | <a href="{url name='site1_squeeze' action='upload_sound' wg="id={$file.id}"}">edit</a></td>
</tr>
{/foreach}
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
</form>
<script src="/skin/_js/player/adapter.js" type="text/javascript"></script>

{literal}<script type="text/javascript">
  audiojs.events.ready(function() {
    var as = audiojs.createAll();
  });
</script>{/literal}