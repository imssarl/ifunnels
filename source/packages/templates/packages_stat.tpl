<div>
	<form action="" method="get" class="wh">
		Select statistics period: <select name="arrFilter[time]">
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::TIME_ALL} selected="1" {/if} value="{Project_Statistics_Package::TIME_ALL}">All</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::TIME_TODAY} selected="1" {/if} value="{Project_Statistics_Package::TIME_TODAY}">Today</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::TIME_YESTERDAY} selected="1" {/if} value="{Project_Statistics_Package::TIME_YESTERDAY}">Yesterday</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::TIME_LAST_7_DAYS} selected="1" {/if} value="{Project_Statistics_Package::TIME_LAST_7_DAYS}">Last 7 days</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::TIME_THIS_MONTH} selected="1" {/if} value="{Project_Statistics_Package::TIME_THIS_MONTH}">This month</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::THIS_YEAR} selected="1" {/if} value="{Project_Statistics_Package::THIS_YEAR}">This year</option>
		<option {if $smarty.get.arrFilter.time==Project_Statistics_Package::TIME_LAST_YEAR} selected="1" {/if} value="{Project_Statistics_Package::TIME_LAST_YEAR}">Last year</option>
	</select>
	<input type="submit" value="Filter">
	</form>
</div>
<br>
<table  class="info glow" style="width:98%">
	<thead>
	<tr>
		<th>Package</th>
		<th>Impressions</th>
		<th>Clicks</th>
		<th>Sales</th>
	</tr>
	</thead>
	<tbody>
{foreach from=$arrPackages item=package}
	<tr>
		<td>{$package.title}</td>
		<td>{count($arrStats[$package.id].impressions)}</td>
		<td>{count($arrStats[$package.id].clicks)}</td>
		<td>{count($arrStats[$package.id].sales)}</td>
	</tr>
{/foreach}
	</tbody>
</table>