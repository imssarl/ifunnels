<h3>{$arrPrm.title}</h3>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Search</h3>
	</div>
	<div class="panel-body">
		<form action="" method="get">
			<div class="input-group">
				<span class="input-group-btn">
					<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
				</span>
				<input type="text" name="title" class="form-control" placeholder="Search by title:" value="{$smarty.get.title}">
			</div>
		</form>
	</div>
</div>

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Filters</h3>
	</div>
	<div class="panel-body">
		<form action="" method="get">
			<select name="arrFilter[type]" class="btn-group selectpicker show-tick pull-left m-r-10">
				<option value="">- select Funnel Type -</option>
				<option value="1"{if $smarty.get.arrFilter.type == 1} selected="selected"{/if}>Broadcast</option>
				<option value="0"{if isset($smarty.get.arrFilter.type) && $smarty.get.arrFilter.type == 0} selected="selected"{/if}>Sequence</option>				
			</select>
			<button type="submit" class="btn btn-default waves-effect waves-light pull-left" id="filter">Filter</button>
		</form>
	</div>
</div>

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
					<th width="35%">Title</th>
					<th width="10%">Type</th>
					<th width="10%">Tags</th>
					<th width="15%">Edited</th>
					<th width="15%">Added</th>
					<th width="15%">Options</th>
				</tr>
			</thead>
			<tbody>
				{if !empty($arrData)}
				<tr><td colspan="7">{include file="../../pgg_backend.tpl"}</td></tr>
				{/if}
				{foreach $arrData as $item}
				<tr{if ($item@iteration-1) is div by 2} class="matros"{/if}>
					<td><a href="{url name='email_funnels' action='frontend_set' wg="id={$item.id}"}" target="_blank">{$item.title}</a></td>
					<td>{if $item.type == 1}Broadcast{else}Sequence{/if}</td>
					<td>{$item.options.tags}</td>
					<td>{$item.edited|date_local:$config->date_time->dt_full_format}</td>
					<td>{$item.added|date_local:$config->date_time->dt_full_format}</td>
					<td class="option">
						<a href="{url name='email_funnels' action='frontend_set' wg="id={$item.id}"}"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
						<a href="{url name='email_funnels' action='getcode' wg="getcode={$item.id}"}" title="Get Code" class="popup_mb"><i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i></a>
						<a href="?duplicate={$item.id}" class="duplicate"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></a>
						<a href="{url name='email_funnels' action='frontend_manage' wg="flg_pause={if $item.flg_pause == 0}1{else}0{/if}&id={$item.id}"}" title="{if $item.flg_pause == 0}Pause{else}Resume{/if}"><i class="{if $item.flg_pause == 0}ion-pause{else}ion-play{/if}" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
						{if isset( $item.log_text ) && !empty( $item.log_text )}<a href="#error" title="Error: {$item.log_text}"><i class="ion-alert-circled" style="font-size: 20px; vertical-align: bottom; color: #ff0000; margin: 0 5px;"></i></a>{/if}
						<a href="{url name='email_funnels' action='popup_messages' wg="id={$item.id}"}" class="popup_mb"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
						<a href="{url name='email_funnels' action='frontend_manage' wg="delete={$item.id}"}" class="delete"><i class="ion-trash-a" style="color: #AC1111; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
					</td>
				</tr>
				{foreachelse}
				<tr class="matros"><td colspan="7" class="text-center">Empty</td></tr>
				{/foreach}
				{if !empty($arrData)}
				<tr><td colspan="7">{include file="../../pgg_backend.tpl"}</td></tr>
				{/if}
			</tbody>
		</table>
	</form>
</div>

<script src="/skin/site/dist/js/ef_manage.bundle.js"></script>

{literal}
<script type="text/javascript">
	window.addEvent('domready', function(){
		multibox=new CeraBox( $$('.popup_mb'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
			displayTitle: true,
			titleFormat: '{title}'
		});
	});
</script>
{/literal}
