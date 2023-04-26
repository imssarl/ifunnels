<p><input type="submit" value="Submit" class="subbut" /></p>
<form action="" id="current-form" method="post">
<table class="info glow" style="width:98%">
<thead>
	<tr>
		<th style="padding-right:0;"><input type="checkbox" id="del" class="tooltip no-click" title="mass delete" rel="check to select all" /></th>
		<th>Type</th>
		<th>Options</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>&nbsp;</td>
		<td valign="top"><input type="text" class="elogin" name="arrTypes[0][title]"  style="width:150px;" value="" /></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">{include file="../../pgg_backend.tpl"}</td>
	</tr>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<input type="hidden" name="arrTypes[{$v.id}][id]" value="{$v.id}"/>
		<td valign="top"><input type="checkbox" name="arrTypes[{$v.id}][del]" class="check-me-del" id="check-{$v.id}" /></td>
		<td valign="top"><input type="text" class="elogin" name="arrTypes[{$v.id}][title]" style="width:150px;" value="{$v.title}" /></td>
		<td  class="option"><a href="{url name='tags' action='manage'}?arrFilter[type]={$v.id}">tags</a></td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="4">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
</form>
<div><input type="submit" value="Submit" class="subbut" /></div>
<script type="text/javascript">
$$('.subbut').addEvent('click',function(e){
	e && e.stop();
	if ($$('.check-me-del').some(function(item){
		return item.checked==true;
	})) {
		if(!confirm('Your sure to delete selected items?')) return;
	}
	$('current-form').submit();
});
checkboxFullToggle($('del'));
</script>