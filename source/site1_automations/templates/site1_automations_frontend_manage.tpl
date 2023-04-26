{if $error=='delete'}
{include file='../../message.tpl' type='error' message="Can't delete project."}
{/if}
{if $msg=='success'}
{include file='../../message.tpl' type='success' message="Project was deleted."}
{/if}
{if isset(Core_Users::$info['automation_limit']) && Core_Users::$info['automation_limit']>0}<div class="alert alert-info">Number of Automations You Can Create: {Core_Users::$info['automation_limit']-$intAutomationsCount}</div>{/if}
{if $arrList}
<div class="card-box col-md-12">
	<table class="table table-striped">
	<thead>
		<tr>
			<th>Project Name</th>
			<th>Stats</th>
			<th>Edited{include file="../../ord_frontend.tpl" field='d.edited'}</th>
			<th>Added{include file="../../ord_frontend.tpl" field='d.added'}</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
		{foreach $arrList as $v}
		<tr>
			<td>{$v.title}</td>
			<td><a href="{url name='site1_automations' action='frontend_report'}?id={$v.id}">{$arrListCounter[$v.id]}</a</td>
			<td>{$v.edited|date_local:$config->date_time->dt_full_format}</td>
			<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
			<td>
				<a href="{url name='site1_automations' action='frontend_set'}?id={$v.id}" title="Edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
				<a href="{url name='site1_automations' action='frontend_manage'}?delete={$v.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
			</td>
		</tr>
		{/foreach}
	</tbody>
	</table>
	{include file="../../pgg_backend.tpl"}
</div>
{else}
<div class="card-box">
	<div class="row">
		<div class="col-md-12 text-center">No items found</div>
	</div>
{/if}
