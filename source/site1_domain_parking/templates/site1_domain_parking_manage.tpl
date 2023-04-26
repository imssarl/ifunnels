<div class="card-box">
{$msg}
<table class="table  table-striped">
	<thead>
	<tr>
		<th width="5%" align="center">Id</th>
		<th align="center">Project Name</th>
		<th width="10%" align="center">Status</th>
		<th width="15%" align="center">Added</th>
		<th width="10%"></th>
	</tr>
	</thead>
	<tbody>
		{foreach from=$arrList key='k' item='i'}
		<tr{if $k%2=='0'} class="alt-row"{/if}>
			<td align="center">{$i.id}</td>
			<td>{$i.title}</td>
			<td align="center">
				{if $i.flg_status==0}not started
				{elseif $i.flg_status==1}in pogress
				{elseif $i.flg_status==2}completed
				{elseif $i.flg_status==3}error
				{/if}
			</td>
			<td align="center">{$i.added|date_local:$config->date_time->dt_full_format}</td>
			<td align="center">
				{if $i.flg_status==0}<a href="?del={$i.id}" title="Delete"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>{/if}
				{if $i.flg_status>1} <a class="mb" title="Statistics for {$i.title}" href="{url name='site1_domain_parking' action='stat'}?id={$i.id}"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>{/if}
			</td>
		</tr>
		{/foreach}
	</tbody>
</table>
{literal}
<script type="text/javascript">
	window.addEvent('domready',function(){
		var multibox=new CeraBox( $$('.mb'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
			displayTitle: true,
			titleFormat: '{title}'
		});
	});
</script>
{/literal}
</div>