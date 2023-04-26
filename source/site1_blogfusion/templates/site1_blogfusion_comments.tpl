{include file="site1_blogfusion_general_menu.tpl"}
{include file='../../error.tpl'}
<p><a href="#" id="comment_add">Add new comment</a></p>
<div style="display:none;"  id="comment_div_add" align="left">
	<form action="" method="POST" class="wh validate" id="comment_form_add" >
	<input type="hidden" id="comment_id" name="arrComment[0][id]" />
	<input type="hidden" id="comment_ext_id" name="arrComment[0][ext_id]" />
		<fieldset>
			<p>
				<label>Post</label><select id="comment_post_id" class="medium-input" name="arrComment[0][ext_post_id]">{foreach from=$arrPosts item=i}<option value="{$i.ext_id}">{$i.title}{/foreach}</select>
			</p>
			<p>
				<label>Comment <em>*</em></label><textarea name="arrComment[0][content]" title="Comment" id="comment_content" class="required" style="height:200px;"></textarea>
			</p>
			<p>
				<label>&nbsp;</label><input type="submit" name="" class="button"  id="submit_comment" value="Add comment" {is_acs_write} />
			</p>
		</fieldset>
	</form>
</div>
<div align="right">

</div>
<br />
<form action="" method="POST" id="comment_form_delete">
<table>
	<tr>
		<td colspan="3">
			<p>Posts: <select name="post" id="filter_post" class="medium-input"><option value=""> -- {foreach from=$arrPosts item=i}<option {if $smarty.get.post_id == $i.ext_id}selected='1'{/if} value="{$i.ext_id}">{$i.title}{/foreach}</select></p>
		</td>
	</tr>
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px"><input type="checkbox" id="delete_all" ></th> 
		<th align="center">Comments</th>
		<th align="center" width="100">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i key=k}
	<input type="hidden" name="arrComment[{$i.id}][id]" value="{$i.id}" />
	<input type="hidden" name="arrComment[{$i.id}][ext_id]" value="{$i.ext_id}" />
	<input type="hidden" name="arrComment[{$i.id}][ext_post_id]" value="{$i.ext_post_id}" />
	<tr {if $k%2=='0'} class="alt-row"{/if}>
		<td style="padding-right:0;"><input type="checkbox" name="arrComment[{$i.id}][del]"  class="delete_checkbox" id="del_{$i.id}"/></td>
		<td>{$i.content|ellipsis:"50"}</td>
		<td align="center">
			<a {is_acs_write} href="#" rel="{$i.id}:{$i.ext_id}:{$i.ext_post_id}"  class="edit_comment"><img title="Edit" src="/skin/i/frontends/design/newUI/icons/pencil.png"/></a>  <textarea name="arrComment[{$i.id}][content]" style="display:none;">{$i.content}</textarea>
			<a {is_acs_write} href="#" class="delete" rel="{$i.id}"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png"/></a>
		    <a  target="_blank" href="{$arrBlog.url}?p={$i.ext_post_id}#comment-{$i.ext_id}"><img title="View" src="/skin/i/frontends/design/buttons/view.gif"/></a>
		</td>
	</tr>
	{/foreach}
	</tbody>
	<tfoot>
	<tr>
		<td colspan="3">
			<div class="bulk-actions align-left">
				<input type="submit" class="button" name="delete" value="Delete">
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
				$('comment_form_delete').submit();
			}
		});
	});
	if($('filter_post'))
	$('filter_post').addEvent('change', function(){
		if(!this.value) {
			location.href = './?id='+{/literal}{$arrBlog.id}{literal};
		} else {
			location.href = './?id='+{/literal}{$arrBlog.id}{literal}+'&post_id='+this.value;
		}
	});
	$$('.edit_comment').each(function(el){
		el.addEvent('click', function(a){
			a.stop();
			var rel = el.rel;
			var post_id = rel.substitute({},/[0-9]+:[0-9]+:/);
			var id = rel.substitute({},/:[0-9]+:[0-9]+/);
			var ext_id = rel.substitute({},/[0-9]+:/).substitute({},/:[0-9]+/);
			$('comment_id').set('value',id);
			$('comment_ext_id').set('value',ext_id);
			$('comment_content').set('value',el.getNext('textarea').value);
			$('submit_comment').value = 'Update Comment';
			Array.each($('comment_post_id').options,function(option){
				if(option.value == post_id){
					option.selected = true;
				}
			});
			$('comment_div_add').style.display='block';
		});
	});
	$('comment_add').addEvent('click',function(e){
		e.stop();
		if($('comment_div_add').style.display == 'none') {
			$('comment_div_add').style.display='block';
			$('comment_content').set('value','');
			$('submit_comment').value = 'Add Comment';
		} else {
			$('comment_div_add').style.display='none';
		}
	});

	$('comment_form_add').addEvent('submit', function(e){
		if($('comment_content').value == ''){
			e.stop(); 
			r.alert('ERROR', 'Comment - This filed is required!','roar_error'); 
			return false;
		}
		$('submit_comment').disabled = true;
	});
});
</script>
{/literal}