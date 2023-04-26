{include file="site1_blogfusion_general_menu.tpl"}
{include file='../../error.tpl'}
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<p><a href="#" id="add">Add new post</a></p>
<form action="" method="POST" class="wh validate" id="post_add">
<div style="display:none;"  id="form_add" align="left">
	<input type="hidden" name="arrPost[0][id]" id="post_id" value="" />
	<input type="hidden" name="arrPost[0][ext_id]" id="post_ext_id" value="" />
	<input type="hidden" name="arrPost[0][post_id]" id="post_real_id" value="" />
		<fieldset>
			<p>
				<label>Category <em>*</em></label><select name="arrPost[0][catIds][]" style="height:100px;" multiple='1' id="post_cat" class="required medium-input validate-custom-required emptyValue:'0'">
					{foreach from=$arrCats item=i}<option {if $i.flg_default}selected='1'{/if} value="{$i.ext_id}">{$i.title}</option>{/foreach}
					</select>
			</p>
			<p>
				<label>Post title <em>*</em></label><input type="text" class="required text-input medium-input" id="post_title" title="Post title" name="arrPost[0][title]"/>
			</p>
			<p>
				<label>Post tags </label><input type="text" class="text-input medium-input" id="tags_input"  title="Post title" name="arrPost[0][tags]"/>
			</p>
			<p>
				<label>Description <em>*</em></label><textarea name="arrPost[0][content]" id="post_content" class="required" style="height:200px;" ></textarea>
			</p>
			<p>
				<input type="submit" name="insert"  id="submit_post" class="button" value="Add post" {is_acs_write} />
			</p>
			<p id="commnets_link">
				<label><a href="{url name='site1_blogfusion' action='comments'}?id={$arrBlog.id}" id="view_comment">Comments</a></label>
			</p>
		</fieldset>
</div>
</form>
<form action="" method="POST" id="form_delete">
<table>
	<tr>
		<td colspan="6">Category: <select id="filter_category" class="small-input"><option value=""> -- {foreach from=$arrCats item=i}<option {if $smarty.get.cat_id == $i.ext_id}selected='1'{/if} value="{$i.ext_id}"> {$i.title} {/foreach}</select></td>
	</tr>
	<thead>
	<tr>
		<th style="padding-right:0;" width="1px"><input type="checkbox" id="delete_all"></th>
		<th align="center">Posts {if count($arrList)>1}{if $arrFilter.order!='title--up'}<a href="{url name='site1_blogfusion' action='posts' wg='order=title--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='title--dn'}<a href="{url name='site1_blogfusion' action='posts' wg='order=title--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center">Comments</th>
		<th align="center" width="20%">Content From {if count($arrList)>1}{if $arrFilter.order!='flg_from--up'}<a href="{url name='site1_blogfusion' action='posts' wg='order=flg_from--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='flg_from--dn'}<a href="{url name='site1_blogfusion' action='posts' wg='order=flg_from--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center" width="20%">Date created {if count($arrList)>1}{if $arrFilter.order!='added--up'}<a href="{url name='site1_blogfusion' action='posts' wg='order=added--up'}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $arrFilter.order!='added--dn'}<a href="{url name='site1_blogfusion' action='posts' wg='order=added--dn'}"><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}{/if}</th>
		<th align="center" width="80">Options</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$arrList item=i key=k}
	<input type="hidden" name="arrPost[{$i.id}][id]" value="{$i.id}"/>
	<input type="hidden" name="arrPost[{$i.id}][ext_id]" value="{$i.ext_id}"/>
	<input type="hidden" name="arrPost[{$i.id}][title]" value="{$i.title}" id="title_input_{$i.id}"/>
	<input type="hidden" name="arrPost[{$i.id}][tags]" value="{$i.tags}" id="tags_input_{$i.id}"/>
	<input type="hidden" name="arrPost[{$i.id}][post_id]" value="{$i.post_id}" id="post_real_{$i.id}"/>
	<tr {if $k%2=='0'} class="alt-row"{/if}>
		<td style="padding-right:0;"><input type="checkbox"  name="arrPost[{$i.id}][del]" class="delete_checkbox" id="del_{$i.id}"/></td>
		<td>{$i.title}</td>
		<td align="center">{if $i.comments}<a href="{url name='site1_blogfusion' action='comments'}?id={$arrBlog.id}&post_id={$i.ext_id}">{$i.comments}</a>{else}{$i.comments}{/if}</td>
		<td align="center">{if $i.flg_from == '1'}Self{elseif $i.flg_from == '2'}Publisher{/if}</td>
		<td align="center">{$i.added|date_format:$config->date_time->dt_full_format}</td>
		<td align="center">
			<a {is_acs_write} href="#" rel="{$i.id}:{$i.ext_id}" id='[{foreach from=$i.categories item=j name=cat}{if !$smarty.foreach.cat.first},{/if}{$j}{/foreach}]' class="edit_post"><img title="Edit" src="/skin/i/frontends/design/newUI/icons/pencil.png"/></a><textarea name="arrPost[{$i.id}][content]" style="display:none;">{$i.content|replace:"\n":"<br/>"}</textarea>
			<a {is_acs_write} href="" class="delete" rel="{$i.id}"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png"/></a>
			<a href="{$arrBlog.url}?p={$i.ext_id}" target="_blank"><img title="View" src="/skin/i/frontends/design/buttons/view.gif"/></a>
		</td>
	</tr>
	{/foreach}
	</tbody>
	<tfoot>
	<tr>
		<td colspan="6">
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

	CKEDITOR.replace( 'post_content', {
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
	$('view_comment').addEvent('click',function(a){
		a.stop();
	 	location.href = this.href + '&post_id=' + $('post_ext_id').value;
	});
	 
	$$('.delete').each(function(el){
		el.addEvent('click', function(a){
			a.stop();
			$('del_'+el.rel).checked = ($('del_'+el.rel).checked)? 0:1;
			if($('del_'+el.rel).checked) {
				$('delete_items').set('type','hidden');
				$('form_delete').submit();
			}
		});
	});
	$('filter_category').addEvent('change', function(){
		if(!this.value) {	
			location.href = './?id='+{/literal}{$arrBlog.id}{literal};	
		} else {
			location.href = './?id='+{/literal}{$arrBlog.id}{literal}+'&cat_id='+this.value;
		}
	});
	$('add').addEvent('click',function(e){
		e.stop();
		if($('form_add').style.display == 'none') {
			$('form_add').style.display='block';
			$('post_title').set('value','');
			$('post_id').set('value','');
			$('post_ext_id').set('value','');
			$('post_real_id').set('value','');
			CKEDITOR.instances.post_content.setData( '' );
			$('submit_post').value = 'Add Post';
			$('commnets_link').style.display='none';
		} else {
			$('form_add').style.display='none';
			$('commnets_link').style.display='block';
		}
	});
	
	$$('.edit_post').each(function(el){
		el.addEvent('click', function(a){
			a.stop();
			var rel = el.rel;
			var cat_id = JSON.decode(el.id);
			var ext_id = rel.substitute({},/[0-9]+:/);
			var id = rel.substitute({},/:[0-9]+/);
			$('post_id').set('value',id);
			$('post_ext_id').set('value',ext_id);
			$('post_title').set('value', $('title_input_'+id).value );
			$('tags_input').set('value', $('tags_input_'+id ).value );
			$('post_real_id').set('value', $('post_real_'+id ).value );
			CKEDITOR.instances.post_content.setData(el.getNext('textarea').value);
			$('submit_post').value = 'Update Post';
			Array.each($('post_cat').options,function(option){
				option.selected = false;
			});
			Array.each($('post_cat').options,function(option){
				cat_id.each(function(i){
					if(option.value == i){
						option.selected = true;
					}	
				});
			});
			$('commnets_link').style.display='block';
			$('form_add').style.display='block';
		});
	});
});

</script>
{/literal}