{include file="site1_blogfusion_general_menu.tpl"}
{include file='../../error.tpl'}
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<br />
<p><a href="#" id="add">Add new page</a></p>
<form action="" method="POST" class="wh validate" id="page_add" >
<div style="display:none;"  id="form_add" align="left">
	<input type="hidden" name="arrPage[0][id]" id="page_id" value="" />
	<input type="hidden" name="arrPage[0][ext_id]" id="page_ext_id" value="" />	
		<fieldset>
			<p>
				<label>Page title <em>*</em></label><input type="text" class="required text-input medium-input" id="page_title" title="Post title" name="arrPage[0][title]">
			</p>
			<p>
				<label>Page Content <em>*</em></label><textarea name="arrPage[0][content]" title="Content" id="page_content" class="required" style="height:200px;"></textarea>
			</p>
			<p>
				<input type="submit" id="submit_page"  class="button" value="Add page" {is_acs_write} />
			</p>
		</fieldset>
</div>
</form>
<br />
<form action="" method="POST" id="form_delete">
<table >
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px"><input type="checkbox" id="delete_all"></th>
		<th align="center">Page title</th>
		<th align="center" width="100">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i key=k}
	<input type="hidden" name="arrPage[{$i.id}][id]" value="{$i.id}" />
	<input type="hidden" name="arrPage[{$i.id}][ext_id]" value="{$i.ext_id}" />
	<input type="hidden" name="arrPage[{$i.id}][title]" value="{$i.title}">
	<tr {if $k%2=='0'} class="alt-row"{/if}>
		<td style="padding-right:0;"><input type="checkbox" name="arrPage[{$i.id}][del]" id="del_{$i.id}" class="delete_checkbox"></td>
		<td>{$i.title}</td>
		<td align="center">
			<a {is_acs_write} href="#"  rel="{$i.ext_id}:{$i.id}" class="edit_page"><img title="Edit" src="/skin/i/frontends/design/newUI/icons/pencil.png"/></a><textarea style="display:none;">{$i.content|replace:"\n":"<br/>"}</textarea>
			<a {is_acs_write} href="" class="delete" rel="{$i.id}"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png"/></a>
			<a href="{$arrBlog.url}?p={$i.ext_id}" target="_blank"><img title="View" src="/skin/i/frontends/design/buttons/view.gif"/></a>
		</td>
	</tr>
	{/foreach}
	</tbody>
	<tfoot>
	<tr>
		<td colspan="3">
			<div class="bulk-actions align-left">
				<input type="submit" name="delete" id="delete_items" class="button" value="Delete" {is_acs_write} />
			</div>
			{include file="../../pgg_frontend.tpl"}
		</td>
	</tr>
	</tfoot>
</table>
</form>

</td>
</tr>
</table>

{literal}

<script type="text/javascript">
window.addEvent('domready', function(){
	CKEDITOR.replace( 'page_content', {
		toolbar : 'Basic_Posts'
	});
	
	$$('.pg_handler').each(function(el){
		el.addEvent('click',function(a){
			a.stop();
			var href = el.href+{/literal}'&id={$arrBlog.id}'{literal};
			href.toURI().go();
		});
	});

	$('delete_all').addEvent('click', function(){
		$$('.delete_checkbox').each(function(el){
			el.checked = $('delete_all').checked;
		});
	});
	$$('.delete').each(function(el){
		el.addEvent('click', function(a){
			a.stop();
			$('del_'+el.rel).checked = ($('del_'+el.rel).checked)? 0:1;
			if($('del_'+el.rel).checked) {
				$('form_delete').submit();
			}
		});
	});
	$('add').addEvent('click',function(e){
		e.stop();
		if($('form_add').style.display == 'none') {
			$('form_add').style.display='block';
			$('page_title').set('value','');
			CKEDITOR.instances.page_content.setData('');
			$('submit_page').value = 'Add Page';
		} else {
			$('form_add').style.display='none';
		}
	});
	$$('.edit_page').each(function(el){
		el.addEvent('click', function(a){
			a.stop();
			var rel = el.rel;
			var id = rel.substitute({},/[0-9]+:/);
			var ext_id = rel.substitute({},/:[0-9]+/);
			$('page_id').set('value',id);
			$('page_ext_id').set('value',ext_id);
			$('page_title').set('value',el.getParent().getPrevious().get('html'));
			CKEDITOR.instances.page_content.setData(el.getNext('textarea').value);
			$('submit_page').value = 'Update Page';
			$('form_add').style.display='block';
		});
	});
});
</script>
{/literal}