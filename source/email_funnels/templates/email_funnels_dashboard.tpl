<style type="text/css">
	#datepicker,#datepicker2 { display: block!important; }
</style>
{assign var='rows_per_page' value=Core_Users::$info['arrSettings']['rows_per_page']}
{if empty( $rows_per_page )}
	{assign var='rows_per_page' value=12}
{/if}
<div class="card-box">
<form action="" method="get">
	<div class="row">
			<div class="col-lg-2 col-md-4 col-sm-5 col-xs-6">
				<select name="arrFilter[time]" class="btn-group selectpicker show-tick">
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_ALL} selected="selected" {/if} value="{Project_Statistics_Api::TIME_ALL}">All</option>
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_TODAY} selected="selected" {/if} value="{Project_Statistics_Api::TIME_TODAY}">Today</option>
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_YESTERDAY} selected="selected" {/if} value="{Project_Statistics_Api::TIME_YESTERDAY}">Yesterday</option>
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_LAST_7_DAYS} selected="selected" {/if} value="{Project_Statistics_Api::TIME_LAST_7_DAYS}">Last 7 days</option>
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_THIS_MONTH} selected="selected" {/if} {if empty($smarty.get.arrFilter.time)}selected="selected"{/if} value="{Project_Statistics_Api::TIME_THIS_MONTH}">This month</option>
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::THIS_YEAR} selected="selected" {/if} value="{Project_Statistics_Api::THIS_YEAR}">This year</option>
					<option {if $smarty.get.arrFilter.time==Project_Statistics_Api::TIME_LAST_YEAR} selected="selected" {/if} value="{Project_Statistics_Api::TIME_LAST_YEAR}">Last year</option>
					<option {if $smarty.get.arrFilter.time==8} selected="selected" {/if} value="8">Range date</option>
				</select>
			</div>
			<div class="col-md-4 col-xs-12 row date-range{if $smarty.get.arrFilter.time!=8} hidden{/if}">
				<div class="col-md-6">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="yyyy-mm-dd" id="datepicker" name="arrFilter[date_from]" value="{$smarty.get.arrFilter.date_from}">
						<span class="input-group-addon bg-custom b-0 text-white"><i class="icon-calender"></i></span>
					</div>
				</div>
				<div class="col-md-6">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="yyyy-mm-dd" id="datepicker2" name="arrFilter[date_to]" value="{$smarty.get.arrFilter.date_to}">
						<span class="input-group-addon bg-custom b-0 text-white"><i class="icon-calender"></i></span>
					</div>
				</div>
			</div>
			<div class="col-md-3 col-sm-3 col-xs-12">
				<button type="submit" class="btn btn-success waves-effect waves-light">Filter</button>
			</div>
	</div>
</form>

{if $arrList}




<div class="card-box">
	<h4 class="text-dark header-title m-t-0">Summary</h4>
	<p>Comparing to prior 30 Days</p>
	
	
	<div class="row">
	
		<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Campaigns Sent</span>
				</div>
				<div class="text-right">
					<span class="text-dark" style="font-size: 25px;">{$arrSummary['all']['ef_counter']}</span>
				</div>
			</div>
		</div>
		
		<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Emails Sent</span>
				</div>
				<div class="text-right">
					<span class="text-dark" style="font-size: 25px;">{$arrSummaryList['all']['delivered']}</span>
				</div>
			</div>
		</div>
		
		<div class="col-md-3 col-sm-3 col-lg-3">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Emails</span>
				</div>
				<div class="text-right">
					<span class="text-dark" style="font-size: 25px;"></span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{$allContacts['count']}</span>
					<span class="{if $allContactsPercentage > 0}text-success{else}text-danger{/if}">{if $allContactsPercentage > 0}+{/if}{$allContactsPercentage}%</span>
				</div>
				<div class="text-right">
					{$allContactsFilter['count']} added by period
				</div>
			</div>
		</div>
		
		{*<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Delivery Rate</span>
				</div>
				<div class="text-right">
					<span class="{if $arrSummary['percent']['ef_counter'] > 0}text-success{else}text-danger{/if}" style="font-size: 25px;">{if $arrSummary['percent']['ef_counter'] > 0}+{/if}{$arrSummary['percent']['ef_counter']}%</span>
				</div>
			</div>
		</div>*}
		
		<div class="col-md-3 col-sm-3 col-lg-3">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Leads</span>
				</div>
				<div class="text-right">
					<span class="text-dark" style="font-size: 25px;"></span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{$allLeads['count']}</span>
					<span class="{if $allContactsPercentage > 0}text-success{else}text-danger{/if}">{if $allLeadsPercentage > 0}+{/if}{$allLeadsPercentage}%</span>
				</div>
				<div class="text-right">
					{$allLeadsFilter['count']} added by period
				</div>
			</div>
		</div>
		
	</div>

	<div class="row">
		<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Open Rate</span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{round( 100*$arrSummaryList['all']['opened']/$arrSummaryList['all']['delivered'], 2)}%</span>
					<span class="{if $arrSummary['percent']['opened'] > 0}text-success{else}text-danger{/if}">{if $arrSummary['percent']['opened'] > 0}+{/if}{$arrSummary['percent']['opened']}%</span>
				</div>
				<div class="text-right">
					{$arrSummaryList['all']['opened']} opened
				</div>
			</div>
		</div>

		<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Click Rate</span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{round( 100*$arrSummaryList['all']['clicked']/$arrSummaryList['all']['delivered'], 2)}%</span>
					<span class="{if $arrSummary['percent']['clicked'] > 0}text-success{else}text-danger{/if}">{if $arrSummary['percent']['clicked'] > 0}+{/if}{$arrSummary['percent']['clicked']}%</span>
				</div>
				<div class="text-right">
					{$arrSummaryList['all']['clicked']} click
				</div>
			</div>
		</div>

		<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Bounce Rate</span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{round( 100*$arrSummaryList['all']['bounced']/$arrSummaryList['all']['delivered'], 2)}%</span>
					<span class="{if $arrSummary['percent']['bounced'] > 0}text-success{else}text-danger{/if}">{if $arrSummary['percent']['bounced'] > 0}+{/if}{$arrSummary['percent']['bounced']}%</span>
				</div>
				<div class="text-right">
					{$arrSummaryList['all']['bounced']} bounced
				</div>
			</div>
		</div>

		<div class="col-md-2 col-sm-2 col-lg-2">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Spam Rate</span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{round( 100*$arrSummaryList['all']['spam']/$arrSummaryList['all']['delivered'], 2)}%</span>
					<span class="{if $arrSummary['percent']['spam'] > 0}text-danger{else}text-success{/if}">{if $arrSummary['percent']['spam'] > 0}+{/if}{$arrSummary['percent']['spam']}%</span>
				</div>
				<div class="text-right">
					{$arrSummaryList['all']['spam']} spam
				</div>
			</div>
		</div> 
		
		<div class="col-md-3 col-sm-3 col-lg-3">
			<div class="mini-stat clearfix card-box">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Unsubscribe Rate</span>
				</div>
				<div class="text-right">
					<span class=" text-dark" style="font-size: 23px;">{round( 100*$arrSummaryList['all']['unsubscribe']/$arrSummaryList['all']['delivered'], 2)}%</span>
					<span class="{if $arrSummary['percent']['unsubscribe'] > 0}text-danger{else}text-success{/if}">{if $arrSummary['percent']['unsubscribe'] > 0}+{/if}{$arrSummary['percent']['unsubscribe']}%</span>
				</div>
				<div class="text-right">
					{$arrSummaryList['all']['unsubscribe']} unsubscribed
				</div>
			</div>
		</div>
	</div>


	
	
</div>

	<div class="card-box">
		<h4 class="text-dark header-title m-t-0">Engagement</h4>
		<p>Comparing to prior 30 Days</p>
		{assign var="activeValueAll" value=100*$arrSummaryList['all']['opened']/$arrSummaryList['all']['delivered']}
		{assign var="activeValueOld" value=100*$arrSummaryList['old']['opened']/$arrSummaryList['old']['delivered']}
		{assign var="unsubscribeValueAll" value=100*$arrSummaryList['all']['unsubscribe']/$arrSummaryList['all']['delivered']}
		{assign var="unsubscribeValueOld" value=100*$arrSummaryList['old']['unsubscribe']/$arrSummaryList['old']['delivered']}
		{assign var="inactiveValueAll" value=100-$activeValueAll-$unsubscribeValueAll}
		{assign var="inactiveValueOld" value=100-$activeValueOld-$unsubscribeValueOld}
		<div class="row">
			<div class="col-sm-6 col-lg-3 text-center">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Active</span>
				</div>
				<div class="progress progress-lg m-b-5" style="overflow: initial !important">
					<div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="{$activeValueAll}" aria-valuemin="0" aria-valuemax="100" style="width: {round( $activeValueAll, 0)}%;">
						{round( $activeValueAll, 2)}%
					</div>
				</div>
				<div class="progress progress-lg m-b-5" style="overflow: initial !important">
					<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="{$activeValueOld}" aria-valuemin="0" aria-valuemax="100" style="width: {round( $activeValueOld, 0)}%;">
						{round( $activeValueOld, 2)}%
					</div>
				</div>
			</div>
			
			<div class="col-sm-6 col-lg-3 text-center">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Inactive</span>
				</div>
				<div class="progress progress-lg m-b-5" style="overflow: initial !important">
					<div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="{$inactiveValueAll}" aria-valuemin="0" aria-valuemax="100" style="width: {round( $inactiveValueAll, 0)}%;">
						{round( $inactiveValueAll, 2)}%
					</div>
				</div>
				<div class="progress progress-lg m-b-5" style="overflow: initial !important">
					<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="{$inactiveValueOld}" aria-valuemin="0" aria-valuemax="100" style="width: {round( $inactiveValueOld, 0)}%;">
						{round( $inactiveValueOld, 2)}%
					</div>
				</div>
			</div>
			
			<div class="col-sm-6 col-lg-3 text-center">
				<div class="mini-stat-info text-right text-dark">
					<span class=" text-dark">Unsubscribe</span>
				</div>
				<div class="progress progress-lg m-b-5" style="overflow: initial !important">
					<div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="{$unsubscribeValueAll}" aria-valuemin="0" aria-valuemax="100" style="width: {round( $unsubscribeValueAll, 0)}%;">
						{round( $unsubscribeValueAll, 2)}%
					</div>
				</div>
				<div class="progress progress-lg m-b-5" style="overflow: initial !important">
					<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="{$unsubscribeValueOld}" aria-valuemin="0" aria-valuemax="100" style="width: {round( $unsubscribeValueOld, 0)}%;">
						{round( $unsubscribeValueOld, 2)}%
					</div>
				</div>
			</div>

		</div>
	</div>
	{*
	<div class="card-box">
		<h4 class="text-dark header-title m-t-0">Acquisition</h4>
		
		
		
		<div class="row">
			<div class="col-md-6 col-sm-6 col-lg-6">
				<div class="mini-stat clearfix card-box">
					<span class="mini-stat-icon bg-pink"><i class="ion-android-contacts text-white"></i></span>
					<div class="mini-stat-info text-right text-dark">
						<span class=" text-dark">Traffic</span>
						LPS quota
					</div>
					<div class="tiles-progress">
						<div class="m-t-20">
							<h5 class="text-uppercase">LPS Traffic Used <span class="pull-right">51%</span></h5>
							<div class="progress progress-sm m-0">
								<div class="progress-bar progress-bar-pink" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 20%">
									<span class="sr-only">12000</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	*}




	{if count($arrList) > 0 }
	<div class="card-box">
		<h4 class="text-dark header-title m-t-0">Reporting section</h4>
		<table class="table table-striped" id="open_rate">
			<thead>
				<tr>
					<th>Email Funnel</th>
					<th>Message Subject</th>
					<th>Open Rate{include file="../../ord_frontend.tpl" field='open_rate'}{if count($arrList) > $rows_per_page}<i class="fa fa-expand" aria-hidden="true" data-table="open_rate"></i>{/if}</th>
				</tr>
			</thead>
			<tbody>
			{foreach $arrList as $v}
			<tr class="{if ($v@iteration-1) is div by 2}matros{/if}{if ($v@iteration)>$rows_per_page} hidden{/if}">
				<td>{$v.title}</td>
				<td>{implode( ' | ', $v.subject )}</td>
				<td>{sprintf("%01.2f", $v.open_rate)}</td>
			</tr>
			{/foreach}
			</tbody>
		</table>	
	</div>
	{/if}


	{if count($arrClick) > 0 }
	<div class="card-box">
		<h4 class="text-dark header-title m-t-0">Click-through Rate</h4>
		<table class="table table-striped" id="click_rate">
			<thead>
				<tr>
					<th>Email Funnel</th>
					<th>Message Subject</th>
					<th>Click-through Rate{include file="../../ord_frontend.tpl" field='click_rate'}{if count($arrClick) > $rows_per_page}<i class="fa fa-expand" aria-hidden="true" data-table="click_rate"></i>{/if}</th>
				</tr>
			</thead>
			<tbody>
			{foreach $arrClick as $v}
			<tr class="{if ($v@iteration-1) is div by 2}matros{/if}{if ($v@iteration)>$rows_per_page} hidden{/if}">
				<td>{$v.title}</td>
				<td>{implode( ' | ', $v.subject )}</td>
				<td>{sprintf("%01.2f", $v.click_rate)}</td>
			</tr>
			{/foreach}
			</tbody>
		</table>	
	</div>
	{/if}
	
	{if count($arrHighest) > 0 }
	<div class="card-box">
		<h4 class="text-dark header-title m-t-0">Highest Open Rates Subject Lines</h4>
		<table class="table table-striped" id="hight_rate">
			<thead>
				<tr>
					<th>Email Funnel</th>
					<th>Message Subject</th>
					<th>Open Rate{if count($arrHighest) > $rows_per_page}<i class="fa fa-expand" aria-hidden="true" data-table="hight_rate"></i>{/if}</th>
				</tr>
			</thead>
			<tbody>
			{foreach $arrHighest as $v}
			<tr class="{if ($v@iteration-1) is div by 2}matros{/if}{if ($v@iteration)>$rows_per_page} hidden{/if}">
				<td>{$v.title}</td>
				<td>{implode( ' | ', $v.subject )}</td>
				<td>{sprintf("%01.2f", $v.open_rate)}</td>
			</tr>
			{/foreach}
			</tbody>
		</table>	
	</div>
	{/if}
	</form>
{else}
<div>No items found</div>
{/if}
<script src="/skin/light/plugins/moment/moment.js"></script>
<script src="/skin/light/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="/skin/light/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
{literal}
<script type="text/javascript">
jQuery(document).ready(function(){

	if(jQuery('table#visited tr.hidden').size() < 10){ jQuery('table#visited i.fa.fa-expand').addClass('hidden'); }
	jQuery('table th > i.fa.fa-expand').click(function(){
		if( jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.hidden').length > 0 ){
			jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.hidden').addClass('not_hidden');
			jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.hidden').removeClass('hidden');
		}else
		if( jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.not_hidden').length > 0 ){
			jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.not_hidden').addClass('hidden');
			jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.not_hidden').removeClass('not_hidden');
		}
	});

	jQuery('#datepicker,#datepicker2').datepicker({
		format: 'yyyy-mm-dd'
	});

	jQuery('select[name="arrFilter[time]"]').change(function(){
		if(jQuery(this).val() == '8'){
			jQuery('.date-range').removeClass('hidden');
		} else {
			jQuery('.date-range').addClass('hidden');
		}
	});

});
</script>
{/literal}


