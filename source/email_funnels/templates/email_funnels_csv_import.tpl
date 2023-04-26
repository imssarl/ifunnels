<h3>{$arrPrm.title}</h3>
<div class="card-box">
	{if $msg!=''}
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
		<div>{$msg}</div>
	</div>
	{/if}
	<form method="post" action="" id="users-filter">
		<table class="table table-striped" style="width:98%">
			<thead>
				<tr>
					<th width="10%">User Id</th>
					<th width="45%">Comment</th>
					<th width="15%">Count Emails</th>
					<th width="15%">Added</th>
					<th width="15%">Options</th>
				</tr>
			</thead>
			<tbody>
				{if !empty($arrData)}
				<tr><td colspan="5">{include file="../../pgg_backend.tpl"}</td></tr>
				{/if}
				{foreach $arrData as $item}
				<tr{if ($item@iteration-1) is div by 2} class="matros"{/if}>
					<td>{$arrUsers[$item.user_id]}</td>
					<td>{$item.post.arrData.comment}</td>
					<td><a href="#" rel="{$item.id}" class="open_list">{count($item.email_list)}</a></td>
					<td>{$item.added|date_local:$config->date_time->dt_full_format}</td>
					<td class="option">
						<a href="{url name='email_funnels' action='csv_import' wg="flg_allow={$item.id}"}">Allow</a>&nbsp;
						<a href="{url name='email_funnels' action='csv_import' wg="del={$item.id}"}">Decline</a>
					</td>
				</tr>
				<tr><td colspan="5"><div id="show_list_{$item.id}" style="display:none;height:100px;width-max:99%;overflow: auto;">{foreach $item.email_list as $email} {$email.email}{/foreach}</div></td></tr>
				{foreachelse}
				<tr class="matros"><td colspan="5" class="text-center">Empty</td></tr>
				{/foreach}
				{if !empty($arrData)}
				<tr><td colspan="5">{include file="../../pgg_backend.tpl"}</td></tr>
				{/if}
			</tbody>
		</table>
	</form>
</div>

{literal}
<script type="text/javascript">
	window.addEvent('domready', function(){
		$$('.open_list').addEvent('click',function(e){
			e.stop();
			$('show_list_'+$(this).get('rel')).show();
		});
	});
</script>
{/literal}
