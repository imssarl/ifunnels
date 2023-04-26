<style type="text/css">
	#datepicker,#datepicker2 { display: block!important; }
</style>
<h3>Reporting {if !empty($smarty.get.id)}<span>{$arrList[0].url}</span>{/if}</h3>
{assign var='rows_per_page' value=Core_Users::$info['arrSettings']['rows_per_page']}
{if empty( $rows_per_page )}
	{assign var='rows_per_page' value=12}
{/if}
<div class="card-box">
	<form action="" method="get">
		<div class="row">
			<input type="hidden" name="id" value="{$smarty.get.id}">
			
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

		<div class="row">
			<h4 class="text-dark header-title m-l-10 m-b-20">Overall Analyzed Data</h4>

			{if empty($smarty.get.id)}
			<div class="col-md-3">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-info pull-left">
						<i class="md-content-copy text-info"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{$countSites}</b></h3>
						<p class="text-muted">Number of Pages</p>
					</div>

					<div class="clearfix"></div>
				</div>
			</div>

			<div class="col-md-3">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-success pull-left">
						<i class="md md-remove-red-eye text-success"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{$statistic.visitors}</b></h3>
						<!--<h3 class="text-dark"><b class="counter">{Core_Users::$info['statistic']['lpb_views']}</b></h3>-->
						<p class="text-muted">Visitors</p>
					</div>

					<div class="clearfix"></div>
				</div>	
			</div>

			<div class="col-md-3">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-pink pull-left">
						<i class="md md-add-shopping-cart text-pink"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{$statistic.clicks}</b></h3>
						<!--<h3 class="text-dark"><b class="counter">{Core_Users::$info['statistic']['lpb_clicks']}</b></h3>-->
						<p class="text-muted">Conversions</p>
					</div>

					<div class="clearfix"></div>
				</div>
			</div>

			<div class="col-md-3">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-purple pull-left">
						<i class="md md-equalizer text-purple"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{sprintf("%01.2f", $statistic.clicks/$statistic.visitors*100)}</b></h3>
						<!--<h3 class="text-dark"><b class="counter">{sprintf("%01.2f", Core_Users::$info['statistic']['lpb_clicks']/Core_Users::$info['statistic']['lpb_views']*100)}</b></h3>-->
						<p class="text-muted">Average Conversion Rate</p>
					</div>
					
					<div class="clearfix"></div>
				</div>
			</div>
			{else}
			{foreach $arrList as $v}
			<div class="col-md-4">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-success pull-left">
						<i class="md md-remove-red-eye text-success"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{$v.visitors}</b></h3>
						<p class="text-muted">Visitors</p>
					</div>

					<div class="clearfix"></div>
				</div>	
			</div>

			<div class="col-md-4">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-pink pull-left">
						<i class="md md-add-shopping-cart text-pink"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{$v.clicks}</b></h3>
						<p class="text-muted">Conversions</p>
					</div>

					<div class="clearfix"></div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="widget-bg-color-icon card-box fadeInDown animated">
					<div class="bg-icon bg-icon-purple pull-left">
						<i class="md md-equalizer text-purple"></i>
					</div>

					<div class="text-right">
						<h3 class="text-dark"><b class="counter">{sprintf("%01.2f", $v.rate)}</b></h3>
						<p class="text-muted">Average Conversion Rate</p>
					</div>

					<div class="clearfix"></div>
				</div>
			</div>
			{/foreach}
			{/if}
		</div>

		{if $arrList}
			<div class="row">
				<div class="col-lg-12">
					<div class="card-box">
						<h4 class="text-dark header-title m-t-0">Conversion Rate</h4>

						<div class="text-center">
							<ul class="list-inline chart-detail-list">
								<li>
									<h5><i class="fa fa-circle m-r-5" style="color: #5fbeaa;"></i>Conversions</h5>
								</li>
								<li>
									<h5><i class="fa fa-circle m-r-5" style="color: #5d9cec;"></i>Views</h5>
								</li>
							</ul>
						</div>

						<div id="morris-area-with-dotted" style="height: 500px;"></div>
					</div>
				</div>
			</div>
		
			{if count($arrList) > 0}
			<div class="card-box">
				<h4 class="text-dark header-title m-t-0">Most Visited</h4>

				<table class="table table-striped" id="visited">
					<thead>
						<tr>
							<th>Visitors{include file="../../ord_frontend3.tpl" field='view'}</th>
							<th>Clicks{include file="../../ord_frontend3.tpl" field='click'}</th>
							<th>Conversion Rate{include file="../../ord_frontend3.tpl" field='rate'}</th>
							<th colspan="2">Page URL {if count($arrList) > $rows_per_page}<i class="fa fa-expand" aria-hidden="true" data-table="visited"></i>{/if}</th>
						</tr>
					</thead>

					<tbody>
					{foreach $arrList as $v}
						{if $v.visitors > 0}
							<tr class="{if ($v@iteration-1) is div by 2}matros{/if}{if ($v@iteration) > $rows_per_page} hidden{/if}">
								<td>{$v.visitors}</td>
								<td>{$v.clicks}</td>
								<td>{sprintf("%01.2f", $v.rate)}</td>
								<td>
									{if $v.page_name=='index'}
									<a href="{$v.url}" target="_blank">{$v.url}</a>
									{else}
									<a href="{$v.url}{$v.page_name}.php" target="_blank">{$v.url}{$v.page_name}.php</a>
									{/if}
									&nbsp; {if count($v.child_pages) > 1}<a href="#" class="openpages" data-id="{$v.id}">View Report By Page</a>{/if}
								</td>
								<td><a href="{url name='site1_ecom_funnels' action='reporting'}?id={$v.id}{if !empty($sortParam)}&{$sortParam}{/if}">Report</a></td>
							</tr>

							{if count($v.child_pages) > 1}
								{foreach $v.child_pages as $w}
								<tr class="page{$v.id}" style="display:none;">
									<td>{$w.visitors}</td>
									<td>{$w.clicks}</td>
									<td>{sprintf("%01.2f", $w.rate)}</td>
									<td>
										&nbsp;&nbsp;&nbsp;&nbsp;
										{if $w.page_name=='index'}
										<a href="{$w.url}" target="_blank">{$w.url}index.php</a>
										{else}
										<a href="{$w.url}{$w.page_name}.php" target="_blank">{$w.url}{$w.page_name}.php</a>
										{/if}
									</td>
									<td><a href="{url name='site1_ecom_funnels' action='reporting'}?id={$w.id}&pagename={$w.page_name}{if !empty($sortParam)}&{$sortParam}{/if}">Report Page</a></td>
								</tr>
								{/foreach}
							{/if}
						{/if}
					{/foreach}
					</tbody>
				</table>	
			</div>
			{/if}
	
			{if count($arrCountryList) >0 }
			<div class="card-box">
				<h4 class="text-dark header-title m-t-0">Geo Location</h4>

				<table class="table table-striped" id="location">
					<thead>
						<tr>
							<th>Visitors{include file="../../ord_frontend2.tpl" field='view'}</th>
							<th>Clicks{include file="../../ord_frontend2.tpl" field='click'}</th>
							<th>Conversion Rate{include file="../../ord_frontend2.tpl" field='rate'}</th>
							<th>Geo Location{include file="../../ord_frontend2.tpl" field='country'} {if count($arrCountryList) > $rows_per_page}<i class="fa fa-expand" aria-hidden="true" data-table="location"></i>{/if}</th>
						</tr>
					</thead>

					<tbody>
					{foreach $arrCountryList as $v}
						<tr class="{if ($v@iteration-1) is div by 2}matros{/if}{if ($v@iteration)>$rows_per_page} hidden{/if}">
							<td>{$v.view}</td>
							<td>{$v.click}</td>
							<td>{sprintf("%01.2f", $v.rate)}</td>
							<td>{$v.country}</td>
						</tr>
					{/foreach}
					</tbody>
				</table>
			</div>
			{/if}
			
			{if count($arrUtmList) > 0}
			<div class="row">
				<div class="col-lg-2 col-md-4 col-sm-5 col-xs-6">
					<select name="arrFilter[utm_source]" class="btn-group selectpicker show-tick">
						<option {if !isset($smarty.get.arrFilter.utm_source) || $smarty.get.arrFilter.utm_source==''} selected="selected" {/if} value="">All</option>
						{foreach $arrUtmSourceFilter as $sourceFilter}
						<option {if $smarty.get.arrFilter.utm_source == $sourceFilter} selected="selected" {/if} value="{$sourceFilter}">{$sourceFilter}</option>
						{/foreach}
					</select>
				</div>

				<div class="col-lg-2 col-md-4 col-sm-5 col-xs-6">
					<select name="arrFilter[utm_medium]" class="btn-group selectpicker show-tick">
						<option {if !isset($smarty.get.arrFilter.utm_medium) || $smarty.get.arrFilter.utm_medium == ''} selected="selected" {/if} value="">All</option>
						{foreach $arrUtmMediumFilter as $sourceFilter}
						<option {if $smarty.get.arrFilter.utm_medium == $sourceFilter} selected="selected" {/if} value="{$sourceFilter}">{$sourceFilter}</option>
						{/foreach}
					</select>
				</div>

				<div class="col-lg-2 col-md-4 col-sm-5 col-xs-6">
					<select name="arrFilter[utm_campaign]" class="btn-group selectpicker show-tick">
						<option {if !isset($smarty.get.arrFilter.utm_campaign) || $smarty.get.arrFilter.utm_campaign==''} selected="selected" {/if} value="">All</option>
						{foreach $arrUtmCampaignFilter as $sourceFilter}
						<option {if $smarty.get.arrFilter.utm_campaign==$sourceFilter} selected="selected" {/if} value="{$sourceFilter}">{$sourceFilter}</option>
						{/foreach}
					</select>
				</div>

				<div class="col-md-3 col-sm-3 col-xs-12">
					<button type="submit" class="btn btn-success waves-effect waves-light">Filter</button>
				</div>
			</div>

			<div class="card-box">
				<h4 class="text-dark header-title m-t-0">Google Analytics</h4>

				<table class="table table-striped" id="location">
					<thead>
						<tr>
							<th>Campaign Source</th>
							<th>Campaign Medium</th>
							<th>Campaign Name</th>
							<th>Campaign Term</th>
							<th>Campaign Content</th>
							<th>Visitors</th>
							<th>Conversions</th>
							<th>Conversion Rate</th>
						</tr>
					</thead>

					<tbody>
						{foreach $arrUtmList as $v}
						<tr>
							<td>{$v.utm_source}</td>
							<td>{$v.utm_medium}</td>
							<td>{$v.utm_campaign}</td>
							<td>{$v.utm_term}</td>
							<td>{$v.utm_content}</td>
							<td>{$v.visitors}</td>
							<td>{$v.clicks}</td>
							<td>{sprintf("%01.2f", $v.clicks/$v.visitors*100)}</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
			{/if}
		{else}
			<div class="m-b-20">No items found</div>
		{/if}

		{if !empty($arrQuiz)}
		<div class="card-box">
			<h4 class="text-dark header-title m-t-0 m-b-20">Quiz Statistic</h4>

			<div class="m-t-15">
				{foreach from=$arrQuiz key=site_id item=quizs}
				<h4>URL: <span class="label label-default">{$site_id}</span></h4>

					{foreach from=$quizs item=q}
					<table class="table table-striped">
						<thead>
							<tr>
								<th>Question #</th>
								<th># of Clicks</th>
								<th>Clicks, %</th>
							</tr>
						</thead>

						<tbody>
							{foreach from=$q key=i item=a}
							{if $i == 0}
								{assign var='first' value=$a}
							{/if}
							<tr class="matros">
								<td>{$i + 1}</td>
								<td>{$a}</td>
								<td>{if $i == 0}100{else}{round($a * 100 / $first, 2)}{/if}</td>
							</tr>
							{/foreach}
						</tbody>
					</table>
					{/foreach}
				{/foreach}
			</div>
		</div>
		{/if}
	</form>
</div>
<script src="/skin/light/plugins/raphael/raphael-min.js"></script>
<script src="/skin/light/plugins/morris/morris.min.js"></script>
<script src="/skin/light/plugins/moment/moment.js"></script>
<script src="/skin/light/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="/skin/light/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
{literal}
<script type="text/javascript">
	if(document.querySelector('#morris-area-with-dotted')) {
		Morris.Area({
			element: 'morris-area-with-dotted',
			pointSize: 0,
			lineWidth: 0,
			data: {/literal}{$strDate}{literal},
			xkey: 'y',
			ykeys: ['a', 'b'],
			labels: ['Conversions ', 'Views '],
			hideHover: 'auto',
			pointFillColors: ['#ffffff'],
			pointStrokeColors: ['#999999'],
			resize: true,
			gridLineColor: '#eef0f2',
			lineColors: ['#5fbeaa', '#5d9cec','#ebeff2']
		});
	}

	jQuery(document).ready(function(){
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

		jQuery('.openpages').click(function(e){
			e.preventDefault();
			jQuery('.page'+jQuery(this).data('id')).show();
			jQuery(this).hide();
		});

		if(jQuery('table#visited tr.hidden').size() < 10) { 
			jQuery('table#visited i.fa.fa-expand').addClass('hidden'); 
		}

		jQuery('table th > i.fa.fa-expand').click(function(){
			if(jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.hidden').length > 0) {
				jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.hidden').addClass('not_hidden');
				jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.hidden').removeClass('hidden');
			} else if(jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.not_hidden').length > 0) {
				jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.not_hidden').addClass('hidden');
				jQuery('table#' + jQuery(this).data('table') + ' > tbody > tr.not_hidden').removeClass('not_hidden');
			}
		});
	});
	
	var multibox;
	var managerClass = new Class({
		initialize: function(){
			if( $$('.popup') !== null ){
				multibox=new CeraBox( $$('.popup'), {
					group: false,
					width:'950px',
					height:'620px',
					displayTitle: true,
					titleFormat: '{title}'
				});
			}
		}
	});

	window.addEvent('domready', function(){
		new managerClass();
	});

	$$('a.traffic').cerabox({
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}',
		fixedPosition: true,
	});
	{/literal}
</script>