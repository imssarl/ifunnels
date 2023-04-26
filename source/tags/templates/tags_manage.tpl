<h1>{$arrPrm.title}</h1>
<div>
<script type="text/javascript">
{literal}
	function set_order(field) {
		$('order').value=field;
		$('u_filter').submit();
		return false;
	}
{/literal}
</script>
<form method="get" action="" id="u_filter" name="u_filter">
<input type="hidden" name="arrFilter[order]" value="{$arrFilter.order}" id="order">
<div style="margin-bottom:10px;">
	tag with type <select name="arrFilter[type]" class="elogin" style="width:100px;" >
	{html_options options=$arrTypes selected=$arrFilter.type}
	</select> time usage and tagname is <input type="text" name="arrFilter[tagnames]" value="{$arrFilter.tagnames}" class="elogin" style="width:150px;" />
	<input type="submit" value="submit">
</div>
</form>
	<a href="#" onclick="$('add-mass').toggle(); return false;">add mass</a>
<form action="" class="wh" method="post" style="display: none;" id="add-mass">
	<fieldset>
	<ol>
		<li>
			<label>Type: </label><select name="arrData[type]">
				{foreach from=$arrTypes item=i}
				<option value="{$i}">{$i}</option>
				{/foreach}
				</select>
		</li>
		<li>
			<label>Tags:</label><textarea rows="5" name="arrData[tags]"></textarea>
		</li>
		<li>
			<input type="submit" value="Add" />
		</li>
	</ol>
	</fieldset>
</form>
{if !$arrList}
	<div style="float:left; width: 100%">
		<div class="red" style="margin: 80px auto; width: 100%; text-align:center;"><b>no tags found</b></div>
	</div>
{else}
<form method="post" action="" id="t_list" name="t_list">
<table class="info glow" style="width:90%;">
<thead>
<tr>
	<th width="1px" nowrap><input type="checkbox" onClick="toggle_multicheckbox('t_list','del',this);" />del</th>
	<th>tag{include file="../../ord_backend.tpl" field='d.tag'}</th>
	<th>added{include file="../../ord_backend.tpl" field='d.added'}</th>
</tr>
</thead>
	<tr>
		<td colspan="0">{include file="../../pgg_backend.tpl"}</td>
	</tr>
<tbody>
{foreach from=$arrList key='k' item='v'}
<input type="hidden" name="arrList[{$v.id}][id]" value="{$v.id}" />
<tr{if $k%2=='0'} class="matros"{/if}>
	<td><input type="checkbox" name="arrList[{$v.id}][del]"/></td>
	<td><input type="text" class="elogin" name="arrList[{$v.id}][tag]" style="width:300px;" value="{$v.decoded}" /></td>
	<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
</tr>
{/foreach}
</tbody>
<tfoot>
	<tr><td colspan="3">{include file="../../pgg_backend.tpl"}</td></tr>
</tfoot>
</table>
	<p><input type="submit" value="Update" /></p>
</form>
{/if}
</div>