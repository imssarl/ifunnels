<div class="row">
	<div class="col-sm-12">
		<h4 class="page-title m-b-20">Welcome, {if !empty($arrUser.buyer_name)}{$arrUser.buyer_name}{else}Unnamed{/if}!</h4>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<!-- Default panel contents -->
			<div class="panel-heading">
				<h3 class="panel-title">Today</h3>
			</div>

			<div class="panel-body hidden">
				<div class="row widget-inline">
					<div class="col-lg-4 col-sm-6">
						<div class="widget-inline-box text-center">
							<h3><i class="text-primary md md-visibility"></i> <b>{$stats.today.visitors|number_format:0:"":" "}</b></h3>
							<h4 class="text-muted">Traffic</h4>
						</div>
					</div>
					
					<div class="col-lg-4 col-sm-6">
						<div class="widget-inline-box text-center">
							<h3><i class="text-custom md md-account-child"></i> <b>{$stats.today.leads|number_format:0:"":" "}</b></h3>
							<h4 class="text-muted">Leads</h4>
						</div>
					</div>
					
					<div class="col-lg-4 col-sm-6">
						<div class="widget-inline-box text-center b-0">
							<h3><i class="text-pink md md-add-shopping-cart"></i> <b>{Project_Deliver_Currency::getCode($stats.currency)}{$stats.today.sales|number_format:2:".":" "}</b></h3>
							<h4 class="text-muted">Sales</h4>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="col-lg-4">
		<div class="widget-bg-color-icon card-box">
			<div class="bg-icon bg-icon-info pull-left">
				<i class="md md-visibility text-info"></i>
			</div>
			<div class="text-right">
				<h3 class="text-dark"><b>{$stats.today.visitors|number_format:0:"":" "}</b></h3>
				<p class="text-muted">Traffic</p>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>

	<div class="col-lg-4">
		<div class="widget-bg-color-icon card-box">
			<div class="bg-icon bg-icon-custom pull-left">
				<i class="md md-account-child text-custom"></i>
			</div>
			<div class="text-right">
				<h3 class="text-dark"><b>{$stats.today.leads|number_format:0:"":" "}</b></h3>
				<p class="text-muted">Leads</p>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>

	<div class="col-lg-4">
		<div class="widget-bg-color-icon card-box">
			<div class="bg-icon bg-icon-danger pull-left">
				<i class="md md-add-shopping-cart text-danger"></i>
			</div>
			<div class="text-right">
				<h3 class="text-dark"><b>{Project_Deliver_Currency::getCode($stats.currency)}<span>{$stats.today.sales|number_format:2:".":" "}</span></b></h3>
				<p class="text-muted">Sales</p>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>

	<div class="col-lg-12">
		<div class="panel panel-default">
			<!-- Default panel contents -->
			<div class="panel-heading">
				<h3 class="panel-title">Last 30 days</h3>
			</div>

			<div class="panel-body">
				<div class="row widget-inline">
					<div class="col-lg-4 col-sm-6">
						<div class="widget-inline-box text-center">
							<h3><i class="text-primary md md-visibility"></i> <b>{$stats.30days.visitors|number_format:0:"":" "}</b></h3>
							<h4 class="text-muted">Traffic</h4>
						</div>
					</div>
					
					<div class="col-lg-4 col-sm-6">
						<div class="widget-inline-box text-center">
							<h3><i class="text-custom md md-account-child"></i> <b>{$stats.30days.leads|number_format:0:"":" "}</b></h3>
							<h4 class="text-muted">Leads</h4>
						</div>
					</div>
					
					<div class="col-lg-4 col-sm-6">
						<div class="widget-inline-box text-center b-0">
							<h3><i class="text-pink md md-add-shopping-cart"></i> <b>{Project_Deliver_Currency::getCode($stats.currency)}{$stats.30days.sales|number_format:2:".":" "}</b></h3>
							<h4 class="text-muted">Sales</h4>
						</div>
					</div>
				</div>
			</div>

			
		</div>
		<div class="row m-t-20">
			<div class="col-lg-4">
				<h4 class="m-t-0 header-title">Top 5 Funnels for Traffic</h4>

				<div class="card-box">
					<div class="inbox-widget">
						{foreach from=$stats.30days.top5funnel item=funnel}
						<div class="inbox-item">
							<p class="inbox-item-author">{$funnel.name}</p>
							<p class="inbox-item-text">{$funnel.url}</p>
							<!-- <p class="inbox-item-date">{date('M d, Y H:i:s', $funnel.added)}</p> -->
						</div>
						{/foreach}
					</div>
				</div>
			</div>

			<div class="col-lg-4">
				<h4 class="m-t-0 header-title">Top 5 Lead Channels for Leads</h4>

				<div class="card-box">
					<div class="inbox-widget">
						{foreach $stats.30days.top5LeadChannels item=channel}
						<div class="inbox-item">
							<p class="inbox-item-author">
								{$channel.name} 
								<p class="inbox-item-text">{$channel.tags}</p>
							</p>
						</div>
						{/foreach}
					</div>
				</div>
			</div>

			<div class="col-lg-4">
				<h4 class="m-t-0 header-title">Top 5 Products for Sales</h4>

				<div class="card-box">
					<div class="inbox-widget">
						{foreach from=$stats.30days.top5Sales item=membership}
						<div class="inbox-item">
							<p class="inbox-item-author">
								[{$membership.site_name}] {$membership.name} 
								{if $membership.type == 0}<span class="label label-default">One Time</span>{else}<span class="label label-primary">Subscription</span>{/if}
							</p>
							<p class="inbox-item-text">{$membership.home_page_url}</p>
							<!-- <p class="inbox-item-date">13:40 PM</p> -->
						</div>
						{/foreach}
					</div>
				</div>
			</div>
		</div>

	</div>
</div>