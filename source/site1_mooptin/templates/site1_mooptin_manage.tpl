<div class="card-box">

	<a href="{url name='site1_mooptin' action='createpopup'}" class="popup" title="Add New Integration">Add New Integration</a>

	{if $msg!=''}
	<div class="alert alert-success alert-dismissable">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
		<div>{$msg}</div>
	</div>
	{/if}
	<form method="post" action="" >
		<table class="table table-striped" style="width:98%">
			<thead>
				<tr>
					<th>Name</th>
					<th>Tags</th>
					<th width="180">Options</th>
				</tr>
			</thead>
			<tbody>{if count($arrList)>0}
				{foreach $arrList as $v}
				<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
					<td>{$v.name}</td>
					<td>{$v.tags}</td>
					<td class="option">
						<a href="{url name='site1_mooptin' action='getcode' wg="id={$v.id}"}" title="Get Code" class="popup"><i class="ion-code" style="font-size: 20px; vertical-align: bottom; color: #4E0D7A; margin: 0 5px;"></i></a>
						<a href="{url name='site1_mooptin' action='create' wg="id={$v.id}"}"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
						<a href="{url name='site1_mooptin' action='manage' wg="del={$v.id}"}"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
					</td>
				</tr>
				{/foreach}
				<tr>
					<td colspan="3">{include file="../../pgg_backend.tpl"}</td>
				</tr>
				{else}
				<tr>
					<td colspan="3">No elements</td>
				</tr>
				{/if}
			</tbody>
		</table>
	</form>
</div>
{literal}
<script type="text/javascript">
	window.placeMoOptin=function(){
		location.reload();
	}

	window.mooptinpopup=new CeraBox( $$('.popup'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}',
		fixedPosition: true
	});
</script>
{/literal}