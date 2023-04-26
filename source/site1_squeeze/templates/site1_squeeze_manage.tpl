<form method="post" action="" id="users-filter">
{if $upload==true}<div class="grn">File was uploaded</div>{/if}
{if $delete==true}<div class="grn">File was deleted</div>{/if}
<table class="info glow" style="width:98%">
<thead>
<tr>
	<th>Name</th>
	<th>Preview</th>
	<th width="180">Options</th>
</tr>
</thead>
<tbody>
{foreach $arrList as $v}
<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
	<td>{$v.name}</td>
	<td><img src="{$v.preview}" /></td>
	<td class="option">
		<a href="{url name='site1_squeeze' action='manage' wg="del={$v.name}"}">del</a>
	</td>
</tr>
{/foreach}
	<tr>
		<td colspan="7">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
</form>