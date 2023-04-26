{if !empty($arrSubscr)}
<div class="card-box">
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Subscriptions</h3>
	</div>
	<div class="content-box-content">
		<table class="table  table-striped">
			<thead>
			<tr>
				<th>Package name</th>
				<th width="15%" align="center">Expiry</th>
				<th width="10%" align="center">Price</th>
				<th width="15%" align="center">Status</th>
				<th width="10%" align="center">Actions</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrSubscr item='s'}
			{foreach from=$arrPackages key='k' item='i'}
			{if $s.package_id==$i.id}
			<tr{if $k%2=='0'} class="matros"{/if}>
				<td><a href="#description-{$i.id}" class="popup">{$i.title}</a><div style="display: none;"><div id="description-{$i.id}" style="padding: 20px;">{$i.description}</div></div></td>
				<td align="center">{if $s.flg_lifetime==1}&infin;{else}{$s.expiry|date_local:$config->date_time->dt_full_format}{/if}</td>
				<td align="center">${$i.cost}</td>
				<td align="center">{if $s.flg_lifetime==1}lifetime{else}{if $s.flg_expiry==1}<span class="red">expiry</span>{else}active{/if}{/if}</td>
				<td align="center">{if $s.flg_expiry==1&&$i.cost>0&&$s.flg_lifetime==0}<a href="?id={$s.id}">delete</a> | <a href="{$i.click2sell_url}" target="_blank">buy</a>{/if}</td>
			</tr>
			{/if}
			{/foreach}
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

<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Packages</h3>
	</div>
	<div class="content-box-content">
		<table class="table  table-striped">
			<thead>
			<tr>
				<th>Package name</th>
				<th width="10%" align="center">Price</th>
				<th width="15%" align="center">Description</th>
				<th width="10%" align="center">Purchase link</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrPackages key='k' item='i'}
			{if !in_array($i.id,$arrIdsSubscr)&&$i.flg_hide==0}
			<tr{if $k%2=='0'} class="matros"{/if}>
				<td><a href="#description{$i.id}" class="popup">{$i.title}</a></td>
				<td align="center">${$i.cost}</td>
				<td align="center"><a href="#description{$i.id}" class="popup">read</a><div style="display: none;"><div id="description{$i.id}" style="padding: 20px;">{$i.description}</div></div></td>
				<td align="center">{if $i.cost>0}
					<a href="{$i.click2sell_url}" target="_blank">buy</a>
					{else}
					<a href="{$i.click2sell_url}">add</a>
				{/if}</td>
			</tr>
			{/if}
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

{if !empty($arrCredits)}
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Credits</h3>
	</div>
	<div class="content-box-content">
		<table class="table  table-striped">
			<thead>
			<tr>
				<th>Package name</th>
				<th width="10%" align="center">Price</th>
				<th width="15%" align="center">Description</th>
				<th width="10%" align="center">Purchase link</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrCredits key='k' item='i'}
			{if !in_array($i.id,$arrIdsSubscr)&&$i.flg_hide==0}
			<tr{if $k%2=='0'} class="matros"{/if}>
				<td><a href="#description{$i.id}" class="popup">{$i.title}</a></td>
				<td align="center">${$i.cost}</td>
				<td align="center"><a href="#description{$i.id}" class="popup">read</a><div style="display: none;"><div id="description{$i.id}" style="padding: 20px;">{$i.description}</div></div></td>
				<td align="center"><a href="{$i.click2sell_url}" target="_blank">buy</a></td>
			</tr>
			{/if}
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