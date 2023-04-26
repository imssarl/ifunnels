{literal}<style>.non-caret .caret{display: none;}.bootstrap-select.input-group-btn{display:table-cell!important;}.input-group-btn .btn{padding: 6px 12px;}</style>{/literal}
<h3>{$arrPrm.title}</h3>
<div class="row">
	<div class="col-lg-12">
		{if $msg!=''}
		<div class="alert alert-success alert-dismissable">
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
			<div>{$msg}</a></div>
		</div>
		{/if}
		{if $error!=''}
			{include file='../../message.tpl' type='error' message=$error}
		{/if}
	</div>
	{if isset(Core_Users::$info['contact_limit']) && $arrPg.recall >= Core_Users::$info['contact_limit']}
		<div class="col-lg-12">
			<div class="notification error png_bg">
				<a href="#" class="close"><img src="/skin/i/frontends/design/newUI/icons/cross_grey_small.png" title="Close this notification" alt="close" /></a>
				<div>You have reached your contact limit amount: {Core_Users::$info['contact_limit']}<br/>Please upgrade your account, or delete the excessive contacts.</div>
			</div>
		</div>
	{/if}
</div>   

<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Search by tags</h3>
	</div>
	<div class="panel-body">
		<form action="" method="get">
			<div class="input-group">
				<span class="input-group-btn">
					<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
				</span>
				<input type="text" name="search" class="form-control" placeholder="Search by tags:" value="{$smarty.get.search}">
			</div>
		</form>
		<form action="" method="get" class="m-t-20">
			<div class="input-group">
				<span class="input-group-btn">
					<button type="submit" class="btn waves-effect waves-light btn-primary"><i class="fa fa-search"></i></button>
				</span>
				<input type="text" name="email" class="form-control" placeholder="Search by email:" value="{$smarty.get.email}">
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
			{if !empty( $sFilter.EF )}
			<select id="saved_filters" class="btn-group selectpicker show-tick pull-left m-r-10">
				<option value="">- Saved Filters -</option>
				{foreach from=$sFilter.EF item=i}
				<option value='{json_encode($i)}'{if 
					$i.ef == $smarty.get.arrFilter.email_funnels 
					&& $i.status == $smarty.get.arrFilter.status 
					&& $i.lead_channels == $smarty.get.arrFilter.lead_channels
					&& $i.tags == $smarty.get.arrFilter.tags
					&& $i.validation == $smarty.get.arrFilter.validation
					&& $i.time == $smarty.get.arrFilter.time
					&& $i.membership == $smarty.get.arrFilter.membership
					&& $i.ft_membership == $smarty.get.arrFilter.ft_membership
					&& $i.ft_ef == $smarty.get.arrFilter.ft_email_funnels
					&& $i.ft_status == $smarty.get.arrFilter.ft_status
					&& $i.ft_lead_channels == $smarty.get.arrFilter.ft_lead_channels
					&& $i.ft_tags == $smarty.get.arrFilter.ft_tags
					&& $i.ft_validation == $smarty.get.arrFilter.ft_validation
				} selected="selected"{/if}>{$i.name}</option>
				{/foreach}
			</select>
			{/if}

			<div class="pull-left m-r-10 m-b-10">
				<div class="input-group">
					<div class="input-group-btn pull-left">
						<select name="arrFilter[ft_email_funnels]" class="selectpicker non-caret" data-style="btn-muted" data-width="75px">
							<option value="1" {if $smarty.get.arrFilter.ft_email_funnels == '1'}selected{/if}>IS</option>
							<option value="2" {if $smarty.get.arrFilter.ft_email_funnels == '2'}selected{/if}>IS NOT</option>
						</select>
					</div>

					<select name="arrFilter[email_funnels]" class="btn-group selectpicker show-tick w-auto" data-width="200px">
						<option value="">- select Email Funnel -</option>
						<option value="ns"{if 'ns' == $smarty.get.arrFilter.email_funnels} selected="selected"{/if}>No Subscription</option>
						{foreach from=$arrEFunnels item=i}
						<option value="{$i.id}"{if $i.id == $smarty.get.arrFilter.email_funnels} selected="selected"{/if}>{$i.title}</option>
						{/foreach}
					</select>
				</div>		
			</div>
			
			<div class="pull-left m-r-10 m-b-10">
				<div class="input-group">
					<div class="input-group-btn pull-left">
						<select name="arrFilter[ft_lead_channels]" class="selectpicker non-caret" data-style="btn-muted" data-width="75px">
							<option value="1" {if $smarty.get.arrFilter.ft_lead_channels == '1'}selected{/if}>IS</option>
							<option value="2" {if $smarty.get.arrFilter.ft_lead_channels == '2'}selected{/if}>IS NOT</option>
						</select>
					</div>

					<select name="arrFilter[lead_channels]" class="btn-group selectpicker show-tick w-auto" data-width="200px">
						<option value="">- select Lead Channel -</option>
						{foreach from=$mo_campaigns key=id item=v}
						<option value="{$id}" {if $id == $smarty.get.arrFilter.lead_channels}selected="selected"{/if}>{$v.name}</option>
						{/foreach}
					</select>
				</div>
			</div>

			<div class="pull-left m-r-10 m-b-10">
				<div class="input-group">
					<div class="input-group-btn pull-left">
						<select name="arrFilter[ft_membership]" class="selectpicker non-caret" data-style="btn-muted" data-width="75px">
							<option value="1" {if $smarty.get.arrFilter.ft_membership == '1'}selected{/if}>IS</option>
							<option value="2" {if $smarty.get.arrFilter.ft_membership == '2'}selected{/if}>IS NOT</option>
						</select>
					</div>

					<select name="arrFilter[membership]" class="btn-group selectpicker show-tick w-auto">
						<option value="">- select Membership -</option>
						{foreach from=$arrMembership item=m}
						<option value="{$m.id}" {if $m.id == $smarty.get.arrFilter.membership}selected="selected"{/if}>[{$m.site_name}] {$m.name}</option>
						{/foreach}
					</select>
				</div>
			</div>

			<div class="pull-left m-r-10 m-b-10">
				<div class="input-group">
					<div class="input-group-btn pull-left">
						<select name="arrFilter[ft_tags]" class="selectpicker non-caret" data-style="btn-muted" data-width="75px">
							<option value="1" {if $smarty.get.arrFilter.ft_tags == '1'}selected{/if}>IS</option>
							<option value="2" {if $smarty.get.arrFilter.ft_tags == '2'}selected{/if}>IS NOT</option>
						</select>
					</div>

					<select name="arrFilter[tags]" class="btn-group selectpicker show-tick w-auto" data-live-search="true">
						<option value="">- select Tag -</option>
						{foreach from=$arrTags item=i}
						{if strpos( $i.tag, "'" ) === false && strpos( $i.tag, "\\" ) === false && !empty(trim($i.tag))}<option value="{$i.tag}"{if $i.tag == $smarty.get.arrFilter.tags} selected="selected"{/if}>{$i.tag}</option>{/if}
						{/foreach}
					</select>
				</div>
			</div>

			<div class="pull-left m-r-10 m-b-10">
				<div class="input-group">
					<div class="input-group-btn pull-left">
						<select name="arrFilter[ft_status]" class="selectpicker non-caret" data-style="btn-muted" data-width="75px">
							<option value="1" {if $smarty.get.arrFilter.ft_status == '1'}selected{/if}>IS</option>
							<option value="2" {if $smarty.get.arrFilter.ft_status == '2'}selected{/if}>IS NOT</option>
						</select>
					</div>

					<select name="arrFilter[status]" class="btn-group selectpicker show-tick w-auto">
						<option value="">- select Funnel Status -</option>
						<option value="delivered"{if $smarty.get.arrFilter.status == 'delivered'} selected="selected"{/if}>Delivered</option>
						<option value="bounced"{if $smarty.get.arrFilter.status == 'bounced'} selected="selected"{/if}>Bounced</option>				
						<option value="spam"{if $smarty.get.arrFilter.status == 'spam'} selected="selected"{/if}>Spam</option>				
						<option value="opened"{if $smarty.get.arrFilter.status == 'opened'} selected="selected"{/if}>Opened</option>
						<option value="clicked"{if $smarty.get.arrFilter.status == 'clicked'} selected="selected"{/if}>Clicked</option>
						<option value="notopened"{if $smarty.get.arrFilter.status == 'notopened'} selected="selected"{/if}>Did Not Open</option>
						<option value="notclicked"{if $smarty.get.arrFilter.status == 'notclicked'} selected="selected"{/if}>Did Not Click</option>
						{if Core_Acs::haveAccess( array( 'email test group' ) )}<option value="unsubscribe"{if $smarty.get.arrFilter.status == 'unsubscribe'} selected="selected"{/if}>Global Unsubscribe</option>{/if}
					</select>
				</div>
			</div>

			<div class="pull-left m-r-10 m-b-10">
				<div class="input-group">
					<div class="input-group-btn pull-left">
						<select name="arrFilter[ft_validation]" class="selectpicker non-caret" data-style="btn-muted" data-width="75px">
							<option value="1" {if $smarty.get.arrFilter.ft_validation == '1'}selected{/if}>IS</option>
							<option value="2" {if $smarty.get.arrFilter.ft_validation == '2'}selected{/if}>IS NOT</option>
						</select>
					</div>

					<select name="arrFilter[validation]" class="btn-group selectpicker show-tick w-auto">
						<option value="">- select Validation Status -</option>
						<option value="deliverable"{if $smarty.get.arrFilter.validation == 'deliverable'} selected="selected"{/if}>Deliverable</option>
						<option value="risky"{if $smarty.get.arrFilter.validation == 'risky'} selected="selected"{/if}>Risky</option>				
						<option value="undeliverable"{if $smarty.get.arrFilter.validation == 'undeliverable'} selected="selected"{/if}>Undeliverable</option>				
						<option value="unknown"{if $smarty.get.arrFilter.validation == 'unknown'} selected="selected"{/if}>Unknown</option>
						<option value="not_valid"{if $smarty.get.arrFilter.validation == 'not_valid'} selected="selected"{/if}>Not Valid</option>
						<option value=" "{if $smarty.get.arrFilter.validation == ' '} selected="selected"{/if}>Not Validated</option>
					</select>
				</div>
			</div>

			<select name="arrFilter[time]" class="btn-group selectpicker show-tick pull-left m-r-10 m-b-10">
				<option value="">- select Date Added -</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_ALL} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_ALL}">All</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_TODAY} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_TODAY}">Today</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_YESTERDAY} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_YESTERDAY}">Yesterday</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_LAST_7_DAYS} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_LAST_7_DAYS}">Last 7 days</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_THIS_MONTH} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_THIS_MONTH}">This month</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_LAST_MONTH} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_THIS_MONTH}">Last month</option>
				<option {if $smarty.get.arrFilter.time==Project_Efunnel_Subscribers::TIME_CUSTOM} selected="1" {/if} value="{Project_Efunnel_Subscribers::TIME_CUSTOM}">Custom</option>
			</select>

			<input type="hidden" name="arrFilter[timezone]" value="0" />
			<div class="form-group pull-left filter_date_custom" style="{if $smarty.get.arrFilter.time!=Project_Efunnel_Subscribers::TIME_CUSTOM}display:none;{/if}padding-right: 5px; position: relative;">
				<input type="text" value="{$smarty.get.arrFilter.time_start|date_format:$config->date_time->dt_full_format}" id="view-filter-start" class="not_started completed meio medium-input text-input form-control" data-meiomask="fixed.DateTime"    />
				<input type="hidden" name="arrFilter[time_start]" value="{$smarty.get.arrFilter.time_start}" id="element-start" />
				<img src="/skin/_js/jscalendar/img.gif" id="filter-start" style="cursor: pointer; position: absolute; right: 12px; top: 12px;" alt="" />
			</div>
			<div class="form-group pull-left filter_date_custom" style="{if $smarty.get.arrFilter.time!=Project_Efunnel_Subscribers::TIME_CUSTOM}display:none;{/if}padding-right: 5px; position: relative;">
				<input type="text" value="{$smarty.get.arrFilter.time_end|date_format:$config->date_time->dt_full_format}" id="view-filter-end" class="not_started completed meio medium-input text-input form-control" data-meiomask="fixed.DateTime"    />
				<input type="hidden" name="arrFilter[time_end]" value="{$smarty.get.arrFilter.time_end}" id="element-end" />
				<img src="/skin/_js/jscalendar/img.gif" id="filter-end" style="cursor: pointer; position: absolute; right: 12px; top: 12px;" alt="" />
			</div>
			<div class="checkbox checkbox-primary pull-left m-r-10">
				<input type="checkbox" value="1" name="arrFilter[filter_save]" id="save" />
				<label for="save">Save Filter</label>
			</div>
			<div class="col-md-2 p-0 m-r-10" style="display: none" id="filter-name">
				<input type="text" name="arrFilter[filter_name]" placeholder="Enter Filter Name" value="" class="form-control" />
			</div>
			<div class="pull-left m-r-10">
				<button type="submit" class="btn btn-default waves-effect waves-light pull-left" id="filter">Filter</button>
			</div>
		</form>
	</div>
</div>

<div class="card-box">
	<form method="post" name="contacts_update" action="" id="users-filter" enctype="multipart/form-data">
		<input type="hidden" name="arrData[withTags]" value="{$smarty.get.search}">
		<input type="hidden" name="arrData[withEF]" value="{$smarty.get.arrFilter.email_funnels}">
		<input type="hidden" name="arrData[withStatus]" value="{$smarty.get.arrFilter.status}">
		<div class="form-group pull-left m-r-10 show_csv" style="display:none;width:100%">
			<div class="alert alert-danger alert-dismissable" id="import_allert" style="display: none;">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
				<div>It's required to check the boxes below in order to be able to import contacts into your account.</div>
			</div>
			<div class="checkbox checkbox-default m-0">
				<input type="checkbox" id="legally" name="arrData[legally]" value="1" />
				<label for="legally" style="min-height: 14px;">I hereby certify that I have legally obtained the list of contacts I would like to import</label>
			</div>
			<div class="checkbox checkbox-default m-0">
				<input type="checkbox" id="terms" name="arrData[terms]" value="1" />
				<label for="terms" style="min-height: 14px;">I have read and agree to the <a href="{url name='site1_accounts' action='termspage'}" target="_blank">Terms and Conditions</a> of iFunnels Systems</label>
			</div>
			<div class="form-group pull-left m-r-10 show_csv" style="display: none;">
				<p>Please explain how you obtained the list of contacts you would like to import:</p>
				<input type="text" name="arrData[comment]" class="form-control" value="" />
			</div>
		</div>

		<div class="form-group pull-left m-r-10">
			<select class="btn-group selectpicker show-tick" name="arrData[action]">
				<option value="">- Select -</option>
				<option value="export" disabled="">Export to file</option>
				{if Core_Acs::haveAccess( array( 'Email Funnels Performance', 'Email funnels' ) )}
				<option value="csv">Import and Add to Email Funnel</option>
				<option value="csv_onlyimport">Import</option>
				{/if}
				<option value="email_funnels">Add Funnel</option>
				<option value="add_tag">Add Tag</option>
				<option value="remove_tag">Bulk Remove Tag</option>
				<option value="validate">Validate</option>
				<option value="delete">Delete</option>
				<option value="remove" disabled="">Remove</option>
				<option value="quick_broadcast"{if !Core_Acs::haveAccess( array( 'Email funnels' ) )} disabled=""{/if}>Quick Broadcast</option>
			</select>
		</div>
		<div class="form-group pull-left m-r-10 email_funnels" style="display: none;">
			<select class="btn-group selectpicker show-tick hidden" name="arrData[email_funnels]">
				<option value="">-select-</option>
				{foreach from=$arrEFunnels item=v}
				<option value="{$v.id}" {if $v.type==1}data-type="broadcast"{/if}>{$v.title}</option>
				{/foreach}
			</select>
		</div>
		
		<div class="form-group pull-left m-r-10 quick_broadcast" style="display: none;">
			<a href="{url name='email_funnels' action='quickbroadcast'}" class="btn btn-default waves-effect waves-light pull-left popup_mb" id="quick_broadcast">Create</a>
			<input type="hidden" id="quick_broadcast_ef" name="arrData[quick_broadcast]" value="">
		</div>
			
		<div class="form-group pull-left m-r-10 remove" style="display: none;">
			<select class="btn-group selectpicker show-tick hidden" name="arrData[remove_email_funnels]">
				<option value="">-select-</option>
				{foreach from=$arrEFunnels item=v}
				<option value="{$v.id}">{$v.title}</option>
				{/foreach}
			</select>
		</div>

		{if Core_Acs::haveAccess( array( 'Email Funnels Performance', 'Email funnels' ) )}
		<div class="form-group pull-left m-r-10 show_csv" style="display: none;">
			<input type="file" name="csv" data-input="false" class="filestyle" />
		</div>
		{/if}
		
		<div class="form-group pull-left m-r-10 show_csv add_tag" style="display: none;">
			<input type="text" name="arrData[tags]" class="form-control" value="" />
			<p>Note: here you can input tags that will be added to each of the imported contacts.</p>
		</div>
		
		<div class="form-group pull-left m-r-10 remove_tag" style="display: none;">
			<input type="text" name="arrData[tags_remove]" class="form-control" value="" />
			<p>Note: here you can remove tags that been added to contacts.</p>
		</div>
		
		<div class="form-group pull-left">
			<button type="submit" class="btn btn-default waves-effect waves-light" id="export">Submit</button>
		</div>
		
		<div class="form-group pull-left m-r-10 broadcast_funnels" style="display: none;">
			<select class="btn-group selectpicker show-tick hidden" name="arrData[send]">
				<option value="0">Send now</option>
				<option value="1">Later date</option>
			</select>
		</div>
		
		<div class="form-group pull-left change_date" style="display:none; padding-right: 5px; position: relative;">
			<input type="text" value="{$smarty.now|date_format:$config->date_time->dt_full_format}" id="view-date-start" class="not_started completed meio medium-input text-input form-control" data-meiomask="fixed.DateTime"    />
			<input type="hidden" name="arrData[start]" value="{$smarty.now}" id="date-start" />
			<input type="hidden" name="arrData[timezone]" value="0" />
			<img src="/skin/_js/jscalendar/img.gif" id="trigger-start" style="cursor: pointer; position: absolute; right: 12px; top: 12px;" alt="" />
		</div>
		
		<div class="form-group pull-left change_email_funnels" style="display: none;padding-right: 5px;">
			<button type="submit" name="arrData[update_selected]" value="1" class="btn btn-default waves-effect waves-light" id="update">Update Selected</button>
		</div>

		<table class="table table-striped">
			<thead>
				<tr>
					<td colspan="2">
						<div class="checkbox checkbox-default m-0">
							<input type="checkbox" id="full_all" name="arrData[update_all]" value="1" />
							<label for="full_all" style="min-height: 14px;"><strong>All</strong></label>
						</div>
					</td>
					<td colspan="5" class="text-right"><span>Total contacts: <strong>{$arrPg.recall}</strong></span></td>
				</tr>
			</thead>
			<thead>
				<tr>
					<th width="1%">
						<div class="checkbox checkbox-default m-0">
							<input type="checkbox" id="all" />
							<label for="all" style="min-height: 14px;"></label>
						</div>
					</th>
					<th>Email{include file="../../ord_frontend.tpl" field='d.email'}</th>
					<th>Email Funnel ( <span class="label label-success">Subscribed</span> | <span class="label label-warning">Unsubscribed</span> )</th>
					<th>Tags</th>
					<th>Date Added{include file="../../ord_frontend.tpl" field='d.added'}</th>
					<th>Validation Status{include file="../../ord_frontend.tpl" field='d.status'}</th>
					<th>Options</th>
				</tr>
			</thead>
			<tbody>
				{if !empty($arrList)}
				<tr><td colspan="7">{include file="../../pgg_backend.tpl"}</td></tr>
				{/if}
				{foreach $arrList as $item}
				<tr{if ($item@iteration-1) is div by 2} class="matros"{/if}>
					<td >
						<div class="checkbox checkbox-default m-0">
							<input type="checkbox" id="sub_{$item.id}" name="arrData[subscribers][]" value="{$item.id}" />
							<label for="sub_{$item.id}"></label>
						</div>
					</td>
					<td>{$item.email}
					<a data-toggle="modal" href="#ulp-details-{$item.id}" title="Edit Contact Details"><i class="ion-edit" style="color: #dddd22; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
					<div class="modal fade" data-toggle="modal" id="ulp-details-{$item.id}" tabindex="-2" style="display: none;">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
									<h4 class="modal-title" id="myModalLabel">Update [{$item.email}] Contact Details</h4>
								</div>
								<form method="post" name="details_update_{$item.id}" >
									<input type="hidden" name="arrSettings[id]" value="{$item.id}" />
									<input type="hidden" name="arrSettings[old_email]" value="{$item.email}" />
									<div class="modal-body">
										<table class="table table-striped">
											<tr>
												<th>Name</th>
												<th>Value</th>
												<th>Added</th>
												<th>Options</th>
											</tr>
											<tr>
												<td>User Email</td>
												<td><input type="text" class="form-control" name="arrSettings[email]" value="{$item.email}" /></td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td>User Name</td>
												<td><input type="text" class="form-control" name="arrSettings[name]" value="{$item.name}" /></td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
											</tr>
											{foreach $item.s8rData as $dataName=>$dataValue}
											<tr id="data-remove-{md5($dataName)}" class="old_data">
												<td><input type="text" class="form-control" name="arrAddDetails[name][]" value="{$dataName}" /></td>
												<td><input type="text" class="form-control" name="arrAddDetails[value][]" value="{$dataValue.value}" /></td>
												<td>{$dataValue.added|date_local:$config->date_time->dt_full_format}</td>
												<td>
													<a href="#" class="data_delete" rel="{md5($dataName)}" alt="Delete" title="Delete"><i class="ion-close-circled" style="color: #ff2233; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
												</td>
											</tr>
											{/foreach}
											<tr id="before_{$item.id}">
												<td><input type="text" class="form-control" id="{$item.id}_add_name" value="" /></td>
												<td><input type="text" class="form-control" id="{$item.id}_add_value" value="" /></td>
												<td>&nbsp;</td>
												<td>
													<a href="#" class="data_add" rel="{$item.id}" alt="Add" title="Add"><i class="ion-plus-circled" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
												</td>
											</tr>
										</table>
									</div>
									<div class="modal-footer">
										<input type="submit" class="btn btn-default" name="action_edit_settings" value="Save" />
										<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
									</div>
								</form>
							</div>
						</div>
					</div>
					</td>
					<td>{assign var="counter" value=0}
						{foreach $item.sender_id as $key=>$efunnelId}
							{if isset( $item.flg_subscribed[$efunnelId] ) }<span class="label label-success">{else}<span class="label label-warning">{/if}
							{if isset($arrEFunnels[$efunnelId].title)}
								{$arrEFunnels[$efunnelId].title}
							{else}
								Email Funnel #{$efunnelId}
							{/if}
							</span>
							{if $counter++ != count($item.sender_id)-1}&nbsp;{/if}
							{/foreach}</td>
					<td>
						{foreach $item.tags as $tagId=>$tagName}{if !empty(trim($tagName))}
							<span class="label label-success" style="background-color: hsl({(int)( ( ( 1-$arrTagsHeat[$tagName]/$maxTagsHeat )*$maxTagsHeat )/$maxTagsHeat*180 )}, 80%, 50%);" alt="{$arrTagsHeat[$tagName]} counts">{$tagName}</span>
						{/if}{/foreach}
						<a data-toggle="modal" href="#ulp-tags-{$item.id}" title="Edit Tags"><i class="ion-edit" style="color: #dddd22; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
						<div class="modal fade" data-toggle="modal" id="ulp-tags-{$item.id}" tabindex="-1" style="display: none;">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
										<h4 class="modal-title" id="myModalLabel">Update [{$item.email}] Tags</h4>
									</div>
									<form method="post" name="tags_update_{$item.id}" >
										<input type="hidden" name="arrTag[email]" value="{base64_encode($item.email)}" />
										<div class="modal-body">
											<table class="table table-striped">
												<tr>
													<th>Tag Name</th>
													<th>Repeated</th>
													<th>Options</th>
												</tr>
												{foreach $item.tags as $tagId=>$tagName}{if !empty(trim($tagName))}
												<tr id="tag-remove-{$item.id}-{$tagId}">
													<td><input type="text" class="form-control" name="arrTag[have][]" value="{$tagName}" /></td>
													<td>{$arrTagsHeat[$tagName]}</td>
													<td>
														<a href="#" class="tag_delete" rel="{$item.id}-{$tagId}" alt="Delete"><i class="ion-close-circled" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
													</td>
												</tr>
												{/if}{/foreach}
											</table>
											<div class="form-group row">
												<label class="col-md-12 col-form-label">Add New Tags</label>
												<input type="text" class="form-control" name="arrTag[add]" value="" />
											</div>
											<div class="form-group row">
												<label class="col-md-12 col-form-label">Select New Tags</label>
												<select name="arrTag[select][]" multiple class="btn-group selectpicker show-tick pull-left m-r-10" data-live-search="true">
													<option value="">- select Tag -</option>
													{foreach from=$arrTags item=i}
													{if strpos( $i.tag, "'" ) === false && strpos( $i.tag, "\\" ) === false}<option value="{$i.tag}"{if $i.tag == $smarty.get.arrFilter.tags} selected="selected"{/if}>{$i.tag}</option>{/if}
													{/foreach}
												</select>
											</div>
										</div>
										<div class="modal-footer">
											<input type="submit" class="btn btn-default" value="Save" />
											<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</td>
					<td>{if $item.added!=0}{$item.added|date_local:$config->date_time->dt_full_format}{/if}</td>
					<td>{if $item.status == 'deliverable' || $item.status == 'risky'}<span class="label label-success" title="{$item.status_data}">{ucfirst($item.status)}</span>{else}{if $item.status == 'undeliverable' || $item.status == 'unknown'  || $item.status == 'not_valid' || $item.status == 'Not Validated'}<span class="label label-warning" title="{$item.status_data}">{ucfirst( str_replace( '_', ' ', $item.status ) )}</span>{/if}{/if}{if !isset($item.status)}<span class="label label-warning">Not Validated</span>{/if}</td>
					<td>
						<a href="?email={base64_encode($item.email)}&action=delete" ><i class="ion-close-circled"></i></a>
						{if $item.flg_ef}
						<a data-toggle="modal" href="#ulp-message-{$item.id}" title="Details"><i class="ion-stats-bars" style="color: #5fbeaa; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a>
						<div class="modal fade" data-toggle="modal" id="ulp-message-{$item.id}" tabindex="-1" style="display: none;">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
										<h4 class="modal-title" id="myModalLabel">Details</h4>
									</div>
									<div class="modal-body">
										{if isset( $item.options.ip )}
										<div class="form-group row">
											<label class="col-md-12 col-form-label">From IP: {$item.ip}</label>
										</div>
										{/if}
									  <div class="form-group row">
											<label class="col-md-12 col-form-label">{foreach $item.sender_id as $key=>$efunnelId}{$arrEFunnels[$efunnelId].title}{if $key+1 != count($item.sender_id) && isset($arrEFunnels[$efunnelId].title)},&nbsp;{/if}{/foreach}</label>
									  </div>
										<table class=" table  table-striped">
											<tr>
												<th>Delivered</th>
												<th>Bounced</th>
												<th>Spam</th>
												<th>Opened</th>
												<th>Clicked</th>
											</tr>
											<tr>
												<td>{$item.delivered}</td>
												<td>{$item.bounced}</td>
												<td>{$item.spam}</td>
												<td>{$item.opened}</td>
												<td>{$item.clicked}</td>
											</tr>
										</table>
										{if !empty( $item.requests )}
										<table class=" table  table-striped">
											<tr>
												<th>Option</th>
												<th>Value</th>
											</tr>
											{foreach $item.requests as $opt_date=>$opt_array}
											{foreach $opt_array as $opt_name=>$opt_value}
											<tr>
												<td>{$opt_name}</td>
												<td>{$opt_value}</td>
											</tr>
											{/foreach}
											{/foreach}
										</table>
										{/if}
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
									</div>
								</div>
							</div>
						</div>
						{/if}
					</td>
				</tr>
				{foreachelse}
				<tr class="matros"><td colspan="7" class="text-center">Empty</td></tr>
				{/foreach}
				{if !empty($arrList)}
				<tr><td colspan="7">{include file="../../pgg_backend.tpl"}</td></tr>
				{/if}
			</tbody>
		</table>
	</form>
</div>
<script src="/skin/light/plugins/js-cookie/src/js.cookie.js"></script>
<script src="/skin/light/plugins/bootstrap-filestyle/src/bootstrap-filestyle.min.js" type="text/javascript"></script>

<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/cnm/cnm.css" />
<script type="text/javascript" src="/skin/_js/jscalendar/js/jscal2.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/unicode-letter.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/lang/en.js"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.js" type="text/javascript"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.Fixed.js" type="text/javascript"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.Reverse.js" type="text/javascript"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.Repeat.js" type="text/javascript"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.Reverse.js" type="text/javascript"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.Regexp.js" type="text/javascript"></script>
<script src="/skin/_js/plugins/meio/Meio.Mask.Extras.js" type="text/javascript"></script>
{literal}
<script type="text/javascript">
	var offset = new Date().getTimezoneOffset();
	jQuery( '[name="arrData[timezone]"]' ).prop( 'value', offset*60 );
	var start_calendar = Calendar.setup({
		trigger    : "trigger-start",
		inputField : "date-start",
		dateFormat: "%s",
		showTime : true,
		selection : Date.parse(new Date()),
		disabled: function(date) {
			if (date < Date.parse(new Date())) {
				return true;
			} else {
				return false;
			}
		},
		onSelect : function() {
			var date = new Date ();
			date.parse( $( 'date-start' ).get( 'value' ) * 1000 );
			$( 'view-date-start' ).set( 'value',date.format('%d.%m.%Y %H:%M') );
			this.hide();
		}
	});

	var start_filter = Calendar.setup({
		trigger    : "filter-start",
		inputField : "element-start",
		dateFormat: "%s",
		showTime : true,
		selection : Date.parse({/literal}{$smarty.get.arrFilter.time_start}{literal}),
		onSelect : function() {
			var date = new Date ();
			date.parse( $( 'element-start' ).get( 'value' ) * 1000 );
			$( 'view-filter-start' ).set( 'value',date.format('%d.%m.%Y %H:%M') );
			var newdate = Calendar.intToDate(this.selection.get());
			end_filter.args.min = newdate;
			end_filter.args.selection = newdate;
			end_filter.redraw();
			this.hide();
		}
	});

	var end_filter = Calendar.setup({
		trigger    : "filter-end",
		inputField : "element-end",
		dateFormat: "%s",
		showTime : true,
		selection : Date.parse({/literal}{$smarty.get.arrFilter.time_end}{literal}),
		onSelect : function() {
			var date = new Date ();
			date.parse( $( 'element-end' ).get( 'value' ) * 1000 );
			$( 'view-filter-end' ).set( 'value',date.format('%d.%m.%Y %H:%M') );
			this.hide();
		}
	});

	var multibox=new CeraBox( $$('#quick_broadcast'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});

	var quickBroadcastUpdate = function(EfId){
		jQuery( '[name="arrData[quick_broadcast]"]' ).prop( 'value', EfId );
		$$('#quick_broadcast').hide();
		multibox.boxWindow.close();
	};

	jQuery( document ).ready( function(){

		jQuery( '[name="arrFilter[time]"]' ).on( 'change', function(){
			if( jQuery( this ).prop( 'value' ) == '{/literal}{Project_Efunnel_Subscribers::TIME_CUSTOM}{literal}' ){
				jQuery( '.filter_date_custom' ).show();
			} else {
				jQuery( '.filter_date_custom' ).hide();		
			}
		} );

		jQuery(":file").filestyle({input: false});

		jQuery( '#all' ).on( 'change', function(){
			jQuery( '[name="arrData[subscribers][]"]' ).prop( 'checked', jQuery( this ).prop( 'checked' ) ).eq( 0 ).trigger( 'change' );
		} );

		jQuery( '#full_all' ).on( 'change', function(){
			jQuery( '[name="arrData[subscribers][]"]' ).prop( 'checked', jQuery( this ).prop( 'checked' ) ).eq( 0 ).trigger( 'change' );
		} );

		jQuery( '[name="arrData[send]"]' ).on( 'change', function(){
			if( jQuery( this ).prop( 'value' ) == '0' ){
				jQuery( '.change_date' ).hide();
			} else {
				jQuery( '.change_date' ).show();		
			}
		} );

		jQuery( '[name="arrData[subscribers][]"]' ).on( 'change', function(){
			if( jQuery( '[name="arrData[subscribers][]"]:checked' ).length > 0 ){
				jQuery( 'option[value="export"],option[value="remove"]' ).removeAttr( 'disabled' );
			} else {
				jQuery( 'option[value="export"],option[value="remove"]' ).attr( 'disabled', 'disabled' );			
			}
			// jQuery( '.selectpicker' ).selectpicker( 'refresh' );
			jQuery('select[name="arrData[action]"]').selectpicker('refresh');

		} );

		jQuery( '[name="arrData[email_funnels]"]' ).on( 'change', function(){
			if( jQuery( this ).find( 'option:selected' ).data( 'type' ) == 'broadcast' ){
				jQuery( '.broadcast_funnels' ).show();
			}else{
				jQuery( '.broadcast_funnels' ).hide();
			}
			// jQuery('select[name="arrData[action]"]').selectpicker('refresh');
		});

		jQuery('#users-filter').submit(function(e){
			if( ( jQuery( '[name="arrData[action]"]' ).val() == 'csv'
				|| jQuery( '[name="arrData[action]"]' ).val() == 'csv_onlyimport' )
				&& jQuery( '[name="arrData[legally]"]:checked' ).length == 0
				&& jQuery( '[name="arrData[terms]"]:checked' ).length == 0
				&& jQuery( '[name="arrData[comment]"]' ).val() == ''
			){
				jQuery( '#import_allert' ).show();
				e.preventDefault();
			}else{
				jQuery( '#import_allert' ).hide();
			}
		});

		jQuery( '.data_delete' ).on( 'click', function(){
			jQuery(this).parent().parent('.old_data').remove();
			return;
			jQuery( '#data-remove-'+jQuery( this ).attr( 'rel' ) ).remove();
		});

		jQuery( '.data_add' ).on( 'click', function(){
			jQuery( '#before_'+jQuery( this ).attr( 'rel' ) ).before( '<tr class="new_data"><td><input type="text" class="form-control" name="arrAddDetails[name][]" value="'+jQuery( '#'+jQuery( this ).attr( 'rel' )+'_add_name' ).prop( 'value' )+'" pattern="^[A-Za-z0-9_]+$"/></td><td><input type="text" class="form-control" name="arrAddDetails[value][]" value="'+jQuery( '#'+jQuery( this ).attr( 'rel' )+'_add_value' ).prop( 'value' )+'" /></td><td>&nbsp;</td><td><a href="#" class="data_delete_new" alt="Delete" title="Delete"><i class="ion-close-circled" style="color: #ff2233; font-size: 20px; vertical-align: bottom; margin: 0 5px;"></i></a></td></tr>' );
			jQuery( '.data_delete_new' ).on( 'click', function(){
				jQuery(this).parent().parent('.new_data').remove();
			});

			jQuery( '#'+jQuery( this ).attr( 'rel' )+'_add_name' ).prop( 'value', '' );
			jQuery( '#'+jQuery( this ).attr( 'rel' )+'_add_value' ).prop( 'value', '' );
		});

		jQuery( '.tag_delete' ).on( 'click', function(){
			jQuery( '#tag-remove-'+jQuery( this ).attr( 'rel' ) ).remove();
		});

		jQuery( '[name="arrData[action]"]' ).on( 'change', function(){
			if( jQuery( this ).prop( 'value' ) == 'email_funnels' || jQuery( this ).prop( 'value' ) == 'csv' ){
				jQuery( '.email_funnels' ).show();
				jQuery( '.change_email_funnels' ).show();
				jQuery( '#export' ).hide();
			} else {
				jQuery( '.email_funnels' ).hide();
				jQuery( '.change_email_funnels' ).hide();
				jQuery( '#export' ).show();
			}

			jQuery( '.show_csv' ).hide();

			if( jQuery( this ).prop( 'value' ) == 'add_tag' ){
				jQuery( '.add_tag' ).show();
			} else {
				jQuery( '.add_tag' ).hide();
			}

			if( jQuery( this ).prop( 'value' ) == 'remove_tag' ){
				jQuery( '.remove_tag' ).show();
			} else {
				jQuery( '.remove_tag' ).hide();
			}

			if( jQuery( this ).prop( 'value' ) == 'quick_broadcast' ){
				jQuery( '.quick_broadcast' ).show();
			} else {
				jQuery( '.quick_broadcast' ).hide();
			}

			if( jQuery( this ).prop( 'value' ) == 'csv' || jQuery( this ).prop( 'value' ) == 'csv_onlyimport' ){
				jQuery( '.show_csv' ).show();
				jQuery( '.change_email_funnels' ).hide();
				jQuery( '#export' ).show();
				if( jQuery( this ).prop( 'value' ) == 'csv_onlyimport' ){
					jQuery( '.email_funnels' ).hide();
				}
			} else if( jQuery( this ).prop( 'value' ) == 'csv_onlyimport' ){
				jQuery( '.email_funnels' ).show();
			}

			if( jQuery( this ).prop( 'value' ) == 'remove' ){
				jQuery( '.remove' ).show();
			} else {
				jQuery( '.remove' ).hide();
			}

			jQuery('.selectpicker').selectpicker('refresh');
		} );  

		jQuery( '#save' ).on( 'change', function(){
			if( jQuery( this ).prop( 'checked' ) ) {
				jQuery( '#filter-name' ).fadeIn( 'fast' );
			} else {
				jQuery( '#filter-name' ).fadeOut( 'fast' );
			}
			return false;
		} );

		jQuery('#saved_filters').on('change', function () {
			let _params = JSON.decode(jQuery(this).prop('value'));

			const query = [];
			Object
				.keys(_params)
				.forEach(name => !(name === 'name') && _params[name] !== '' && query.push(`arrFilter[${name}]=${_params[name]}`));
			window.location.assign('?' + encodeURI(query.join('&')));
		});
	} );
</script>
{/literal}