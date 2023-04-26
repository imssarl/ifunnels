{if count( $arrList )>0}
{assign var=arrPg value=$arrPgOrder}
{assign var=arrFilter value=$arrFilterOrder}
<div class="card-box">
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Order history</h3>
	</div>
	<div class="content-box-content">
		<table class="table  table-striped">
			<thead>
			<tr>
				<th>Package name{include file="../../ord_frontend.tpl" field='d.package_id'}</th>
				<th width="10%" align="center">Price{include file="../../ord_frontend.tpl" field='d.amount'}</th>
				<th width="15%" align="center">Added{include file="../../ord_frontend.tpl" field='d.added'}</th>
				<th width="10%" align="center">Confirm{include file="../../ord_frontend.tpl" field='d.flg_confirm'}</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrList key='k' item='v'}
			<tr{if $k%2=='0'} class="matros"{/if}>
				<td>{foreach from=$arrPackages item='i'}
					{if $i.id==$v.package_id}
						{$i.title}
					{/if}
					{/foreach}{foreach from=$arrCredits item='i'}
					{if $i.id==$v.package_id}
						{$i.title}
					{/if}
					{/foreach}</td>
				<td align="center">${$v.amount}</td>
				<td align="center">{$v.added|date_local:$config->date_time->dt_full_format}</td>
				<td align="center">{if $v.flg_confirm==0}not confirmed{else}confirmed{/if}</td>
			</tr>
			{/foreach}
			</tbody>
			<tfoot>
				<tr>
					<td colspan="12">
						{include file="../../pgg_backend.tpl"}
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>
{/if}

{if count( $arrBalance )>0}
{assign var=arrPg value=$arrPgBalance}
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Balance history</h3>
	</div>
	<div class="content-box-content">
		<table class="table  table-striped">
			<thead>
			<tr>
				<th>Description</th>
				<th width="15%" align="center">Amount</th>
				<th width="15%" align="center">Credit Balance</th>
				<th width="15%" align="center">Added</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrBalance key='k' item='v'}
			<tr{if $k%2=='0'} class="matros"{/if}>
				<td>{$v.description}</td>
				<td align="center">{if $v.flg_status==1}+{else}-{/if} {$v.amount}</td>
				<td align="center">{$onPageBalance}{$onPageBalance=$onPageBalance+( ($v.flg_status==1)?-$v.amount :$v.amount ) }</td>
				<td align="center">{$v.added|date_local:$config->date_time->dt_full_format}</td>
			</tr>
			{/foreach}
			</tbody>
			<tfoot>
				<tr>
					<td colspan="12">
						{include file="../../pgg_backend.tpl"}
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>
</div>
{/if}

{literal}
<script type="text/javascript">
var popup={};
	window.addEvent('domready',function(){
		popup=new CeraBox( $$('.popup'), {
				group: false,
				width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
				height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
				displayTitle: true,
				titleFormat: '{title}'
			});
	});
</script>
{/literal}