<script>
	var j = jQuery;
</script>
{$limitEnd=0}
{if isset(Core_Users::$info['automation_limit']) && Core_Users::$info['automation_limit']-$intAutomationsCount <= 0}{$limitEnd=1}<div class="alert alert-danger">You have reached your limit for Automations you can create.</div>{/if}
<div class="card-box"> 
	<form method="POST">
		<input type="hidden" name="arrData[id]" value="{$arrData.id}" />
		<div class="panel-group" id="accordion-test-2"> 
			<!-- Accordion Tab Events -->
			<div class="panel panel-default">
				<div class="form-group">
					<label for="">Project Name</label>
					<input type="text" class="form-control" name="arrData[title]" value="{$arrData.title}" />
				</div>
				<div class="panel-heading"> 
					<h4 class="panel-title"> 
						<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">
							Step 1: Select a Trigger (event)
						</a> 
					</h4> 
				</div> 
				<div id="collapseOne-2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
					<div class="panel-body">
						<span>Note: when you select multiple events, any of those would trigger an action, so it's, for example, "If contact visited landing page X" OR "If contact was added to Lead Channel Y" further action will be taken.</span>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_CREATED']}][id]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_CREATED']].id}">
							<input type="checkbox" id="event-1" name="arrData[events][{Project_Automation_Event::$type['CONTACT_CREATED']}][value]" value="1"{if isset($arrData.events[Project_Automation_Event::$type['CONTACT_CREATED']])} checked="checked"{/if} />
							<label for="event-1">Contact created</label>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_TAGGED']}][id]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_TAGGED']].id}">
							<input type="checkbox" class="has-field" id="event-2"{if isset($arrData.events[Project_Automation_Event::$type['CONTACT_TAGGED']])} checked="checked"{/if} />
							<label for="event-2">Contact tagged</label>
							<div class="form-group m-t-10" {if !isset($arrData.events[{Project_Automation_Event::$type['CONTACT_TAGGED']}])} style="display: none"{/if}>
								<input type="text" class="form-control" placeholder="Enter tags" name="arrData[events][{Project_Automation_Event::$type['CONTACT_TAGGED']}][value]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_TAGGED']].event_values}" />
							</div>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['REMOVE_TAG']}][id]" value="{$arrData.events[Project_Automation_Event::$type['REMOVE_TAG']].id}">
							<input type="checkbox" class="has-field" id="event-2"{if isset($arrData.events[Project_Automation_Event::$type['REMOVE_TAG']])} checked="checked"{/if} />
							<label for="event-2">Tag removed</label>
							<div class="form-group m-t-10" {if !isset($arrData.events[{Project_Automation_Event::$type['REMOVE_TAG']}])} style="display: none"{/if}>
								<input type="text" class="form-control" placeholder="Enter tags" name="arrData[events][{Project_Automation_Event::$type['REMOVE_TAG']}][value]" value="{$arrData.events[Project_Automation_Event::$type['REMOVE_TAG']].event_values}" />
							</div>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_ADDED_EF']}][id]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_EF']].id}">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_ADDED_EF']}][value]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_EF']].event_values}" />
							<input type="checkbox" id="event-3"{if isset($arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_EF']])} checked="checked"{/if} />
							<label for="event-3">
								Contact added to Email Funnel 
							</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[{Project_Automation_Event::$type['CONTACT_ADDED_EF']}])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-email-funnels-modal" data-element="arrData[events][{Project_Automation_Event::$type['CONTACT_ADDED_EF']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[{Project_Automation_Event::$type['CONTACT_ADDED_EF']}])}0{else}{count(explode(',',$arrData.events[{Project_Automation_Event::$type['CONTACT_ADDED_EF']}].event_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_ADDED_LC']}][id]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_LC']].id}">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_ADDED_LC']}][value]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_LC']].event_values}" />
							<input type="checkbox" id="event-4"{if isset($arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_LC']])} checked="checked"{/if} />
							<label for="event-4">Contact added to Lead Channel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_LC']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-lead-channels-modal" data-element="arrData[events][{Project_Automation_Event::$type['CONTACT_ADDED_LC']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_LC']])}0{else}{count(explode(',',$arrData.events[Project_Automation_Event::$type['CONTACT_ADDED_LC']].event_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']}][id]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']].id}">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']}][value]" value="{$arrData.events[Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']].event_values}" />
							<input type="checkbox" id="event-5"{if isset($arrData.events[Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']])} checked="checked"{/if} />
							<label for="event-5">Contact completed Email Funnel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[events][{Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']])}0{else}{count(explode(',',$arrData.events[Project_Automation_Event::$type['CONTACT_COMPLEATED_EF']].event_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['OPEN_EMAIL']}][id]" value="{$arrData.events[Project_Automation_Event::$type['OPEN_EMAIL']].id}">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['OPEN_EMAIL']}][value]" value="{$arrData.events[Project_Automation_Event::$type['OPEN_EMAIL']].event_values}" />
							<input type="checkbox" id="event-6"{if isset($arrData.events[Project_Automation_Event::$type['OPEN_EMAIL']])} checked="checked"{/if} />
							<label for="event-6">Opened an email</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[Project_Automation_Event::$type['OPEN_EMAIL']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-messages-modal"  data-element="arrData[events][{Project_Automation_Event::$type['OPEN_EMAIL']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[Project_Automation_Event::$type['OPEN_EMAIL']])}0{else}{count(explode(',',$arrData.events[Project_Automation_Event::$type['OPEN_EMAIL']].event_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CLICK_EMAIL_LINK']}][id]" value="{$arrData.events[Project_Automation_Event::$type['CLICK_EMAIL_LINK']].id}">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['CLICK_EMAIL_LINK']}][value]" value="{$arrData.events[Project_Automation_Event::$type['CLICK_EMAIL_LINK']].event_values}" />
							<input type="checkbox" id="event-7"{if isset($arrData.events[Project_Automation_Event::$type['CLICK_EMAIL_LINK']])} checked="checked"{/if} />
							<label for="event-7">Clicked in an email</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[Project_Automation_Event::$type['CLICK_EMAIL_LINK']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-messages-modal"  data-element="arrData[events][{Project_Automation_Event::$type['CLICK_EMAIL_LINK']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[Project_Automation_Event::$type['CLICK_EMAIL_LINK']])}0{else}{count(explode(',',$arrData.events[Project_Automation_Event::$type['CLICK_EMAIL_LINK']].event_values))}{/if}</span>
							</button>
						</div>
						{if Core_Acs::haveAccess( array( 'iFunnels Studio Starter', 'iFunnels LTD Studio Starter' ) )}
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['INITIATED_CHECKOUT']}][id]" value="{$arrData.events[Project_Automation_Event::$type['INITIATED_CHECKOUT']].id}">
							<input type="checkbox" id="event-8" name="arrData[events][{Project_Automation_Event::$type['INITIATED_CHECKOUT']}][value]" value="{$arrData.events[Project_Automation_Event::$type['INITIATED_CHECKOUT']].event_values}"{if isset($arrData.events[Project_Automation_Event::$type['INITIATED_CHECKOUT']])} checked="checked"{/if} />
							<label for="event-8">Initiated checkout</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[{Project_Automation_Event::$type['INITIATED_CHECKOUT']}])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-pay-memberships-modal" data-element="arrData[events][{Project_Automation_Event::$type['INITIATED_CHECKOUT']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[{Project_Automation_Event::$type['INITIATED_CHECKOUT']}])}0{else}{count(explode(',',$arrData.events[{Project_Automation_Event::$type['INITIATED_CHECKOUT']}].event_values))}{/if}</span>
							</button>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['COMPLETED_CHECKOUT']}][id]" value="{$arrData.events[Project_Automation_Event::$type['COMPLETED_CHECKOUT']].id}">
							<input type="checkbox" id="event-9" name="arrData[events][{Project_Automation_Event::$type['COMPLETED_CHECKOUT']}][value]" value="{$arrData.events[Project_Automation_Event::$type['COMPLETED_CHECKOUT']].event_values}"{if isset($arrData.events[Project_Automation_Event::$type['COMPLETED_CHECKOUT']])} checked="checked"{/if} />
							<label for="event-9">Completed checkout</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.events[{Project_Automation_Event::$type['COMPLETED_CHECKOUT']}])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-pay-memberships-modal" data-element="arrData[events][{Project_Automation_Event::$type['COMPLETED_CHECKOUT']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.events[{Project_Automation_Event::$type['COMPLETED_CHECKOUT']}])}0{else}{count(explode(',',$arrData.events[{Project_Automation_Event::$type['COMPLETED_CHECKOUT']}].event_values))}{/if}</span>
							</button>
						</div>
						{/if}
						{*
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[events][{Project_Automation_Event::$type['VISIT_PAGE']}][value]" value="0" />
							<input type="checkbox" id="event-8" class="has-field" name="arrData[events][{Project_Automation_Event::$type['VISIT_PAGE']}][value]" value="1"{if isset($arrData.events[Project_Automation_Event::$type['VISIT_PAGE']])} checked="checked"{/if} />
							<label for="event-8">Visited a landing page</label>
							<div class="form-group m-t-10" style="display: none">
								<textarea class="form-control" data-widget=""></textarea>
							</div>
						</div>
						*}
					</div> 
				</div> 
			</div>
			<!-- End Accordion Tab -->

			<!-- Accordion Tab Filters -->
			<div class="panel panel-default"> 
				<div class="panel-heading"> 
					<h4 class="panel-title"> 
						<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" class="collapsed" aria-expanded="false">
							Step 2 (optional): Filters (when should this event fire the automation)
						</a> 
					</h4> 
				</div> 
				<div id="collapseTwo-2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;"> 
					<div class="panel-body">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-1" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['HAVE_TAGS']])}checked="checked"{/if} />
							<label for="filter-1">Contact has / does not have tag</label>
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['HAVE_TAGS']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['HAVE_TAGS']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<div class="col-md-2">
										<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_TAGS']}][id]" value="{$i.id}" />
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_TAGS']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_TAGS']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_TAGS']}][settings][is_not]" value="0" />
											<label for="">Does Not Have</label>
										</div>
									</div>
									<div class="col-md-9">
										<input type="text" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_TAGS']}][value]" class="form-control" placeholder="Enter tags" value="{$i.filter_values}" />
									</div>
									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][1][{Project_Automation_Filter::$type['HAVE_TAGS']}][name]" data-name="F1" value="F1" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][1][{Project_Automation_Filter::$type['HAVE_TAGS']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][1][{Project_Automation_Filter::$type['HAVE_TAGS']}][settings][is_not]" value="0" />
											<label for="">Does Not Have</label>
										</div>
									</div>
									<div class="col-md-9">
										<input type="text" name="arrData[filters][1][{Project_Automation_Filter::$type['HAVE_TAGS']}][value]" class="form-control" placeholder="Enter tags" value="" />
									</div>
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-2" name="" value="" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['OPEN_EMAILS']])}checked="checked"{/if} />
							<label for="filter-2">Has opened Email</label>
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['OPEN_EMAILS']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['OPEN_EMAILS']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['OPEN_EMAILS']}][id]" value="{$i.id}" />
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['OPEN_EMAILS']}][value]" value="{$i.filter_values}" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['OPEN_EMAILS']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['OPEN_EMAILS']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['OPEN_EMAILS']}][settings][is_not]" value="0" />
											<label for="">Has Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-messages-modal" data-element="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['OPEN_EMAILS']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">{if !empty($i.filter_values)}{count(explode(',', $i.filter_values))}{else}0{/if}</span>
										</button>
									</div>
									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<input type="hidden" name="arrData[filters][2][{Project_Automation_Filter::$type['OPEN_EMAILS']}][value]" value="" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][2][{Project_Automation_Filter::$type['OPEN_EMAILS']}][name]" data-name="F2" value="F2" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][2][{Project_Automation_Filter::$type['OPEN_EMAILS']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][2][{Project_Automation_Filter::$type['OPEN_EMAILS']}][settings][is_not]" value="0" />
											<label for="">Has Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-messages-modal"  data-element="arrData[filters][2][{Project_Automation_Filter::$type['OPEN_EMAILS']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">0</span>
										</button>
									</div>
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-3" name="" value="" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['CLICK_EMAIL_LINK']])}checked="checked"{/if} />
							<label for="filter-3">Has clicked Email link</label>
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['CLICK_EMAIL_LINK']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['CLICK_EMAIL_LINK']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][id]" value="{$i.id}" />
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][value]" value="{$i.filter_values}" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][settings][is_not]" value="0" />
											<label for="">Has Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-messages-modal"  data-element="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">{if !empty($i.filter_values)}{count(explode(',', $i.filter_values))}{else}0{/if}</span>
										</button>
									</div>
									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<input type="hidden" name="arrData[filters][3][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][value]" value="" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][3][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][name]" data-name="F3" value="F3" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][3][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][3][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][settings][is_not]" value="0" />
											<label for="">Has Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-messages-modal"  data-element="arrData[filters][3][{Project_Automation_Filter::$type['CLICK_EMAIL_LINK']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">0</span>
										</button>
									</div>
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-4" name="" value="" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['HAVE_EF']])}checked="checked"{/if} />
							<label for="filter-4">Is / Is Not in Email Funnel</label>
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['HAVE_EF']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['HAVE_EF']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_EF']}][id]" value="{$i.id}" />
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_EF']}][value]" value="{$i.filter_values}" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_EF']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_EF']}][settings][is_not]" value="1" />
											<label for="">Is</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_EF']}][settings][is_not]" value="0" />
											<label for="">Is Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['HAVE_EF']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">{if !empty($i.filter_values)}{count(explode(',', $i.filter_values))}{else}0{/if}</span>
										</button>
									</div>
									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<input type="hidden" name="arrData[filters][4][{Project_Automation_Filter::$type['HAVE_EF']}][value]" value="" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][4][{Project_Automation_Filter::$type['HAVE_EF']}][name]" data-name="F4" value="F4" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][4][{Project_Automation_Filter::$type['HAVE_EF']}][settings][is_not]" value="1" />
											<label for="">Is</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][4][{Project_Automation_Filter::$type['HAVE_EF']}][settings][is_not]" value="0" />
											<label for="">Is Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[filters][4][{Project_Automation_Filter::$type['HAVE_EF']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">0</span>
										</button>
									</div>
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-5" name="" value="" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['COMPLEAT_EF']])}checked="checked"{/if} />
							<label for="filter-5">Has completed Email Funnel</label>
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['COMPLEAT_EF']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['COMPLEAT_EF']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['COMPLEAT_EF']}][id]" value="{$i.id}" />
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['COMPLEAT_EF']}][value]" value="{$i.filter_values}" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['COMPLEAT_EF']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['COMPLEAT_EF']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['COMPLEAT_EF']}][settings][is_not]" value="0" />
											<label for="">Has Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['COMPLEAT_EF']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">{if !empty($i.filter_values)}{count(explode(',', $i.filter_values))}{else}0{/if}</span>
										</button>
									</div>
									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<input type="hidden" name="arrData[filters][5][{Project_Automation_Filter::$type['COMPLEAT_EF']}][value]" value="" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][5][{Project_Automation_Filter::$type['COMPLEAT_EF']}][name]" data-name="F5" value="F5" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][5][{Project_Automation_Filter::$type['COMPLEAT_EF']}][settings][is_not]" value="1" />
											<label for="">Has</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][5][{Project_Automation_Filter::$type['COMPLEAT_EF']}][settings][is_not]" value="0" />
											<label for="">Has Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[filters][5][{Project_Automation_Filter::$type['COMPLEAT_EF']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">0</span>
										</button>
									</div>
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-6" name="" value="" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['PAUSE_EF']])}checked="checked"{/if} />
							<label for="filter-6">Is paused in Email Funnel</label>
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['PAUSE_EF']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['PAUSE_EF']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['PAUSE_EF']}][id]" value="{$i.id}" />
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['PAUSE_EF']}][value]" value="{$i.filter_values}" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['PAUSE_EF']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['PAUSE_EF']}][settings][is_not]" value="1" />
											<label for="">Is</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['PAUSE_EF']}][settings][is_not]" value="0" />
											<label for="">Is Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['PAUSE_EF']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">{if !empty($i.filter_values)}{count(explode(',', $i.filter_values))}{else}0{/if}</span>
										</button>
									</div>
									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<input type="hidden" name="arrData[filters][6][{Project_Automation_Filter::$type['PAUSE_EF']}][value]" value="" />
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][6][{Project_Automation_Filter::$type['PAUSE_EF']}][name]" data-name="F6" value="F6" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][6][{Project_Automation_Filter::$type['PAUSE_EF']}][settings][is_not]" value="1" />
											<label for="">Is</label>
										</div>
										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][6][{Project_Automation_Filter::$type['PAUSE_EF']}][settings][is_not]" value="0" />
											<label for="">Is Not</label>
										</div>
									</div>
									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[filters][6][{Project_Automation_Filter::$type['PAUSE_EF']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">0</span>
										</button>
									</div>
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="filter-7" name="" value="" class="has-field" {if isset($arrData.filters[Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']])}checked="checked"{/if} />
							<label for="filter-7">Is / Is Not in Membership</label>
							
							<div class="form-group m-t-10" {if !isset($arrData.filters[Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']])}style="display: none"{/if}>
								{foreach from=$arrData.filters[Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']] name=filters item=i}
								<div class="row{if $smarty.foreach.filters.iteration > 1} m-t-20{/if}">
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][id]" value="{$i.id}" />
									<input type="hidden" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][value]" value="{$i.filter_values}" />
									
									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][name]" data-name="{$i.name}" value="{$i.name}" style="width: 60px;" />
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" {if $i.settings.is_not == 1}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][settings][is_not]" value="1" />
											<label for="">Is</label>
										</div>

										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" {if $i.settings.is_not == 0}checked="checked"{/if} name="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][settings][is_not]" value="0" />
											<label for="">Is Not</label>
										</div>
									</div>

									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-memberships-modal"  data-element="arrData[filters][{$i.id}][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">{if !empty($i.filter_values)}{count(explode(',', $i.filter_values))}{else}0{/if}</span>
										</button>
									</div>

									<div class="col-md-1">
										{if $smarty.foreach.filters.iteration == 1}
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
										{else}
										<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>
										{/if}
									</div>
								</div>
								{foreachelse}
								<div class="row">
									<input type="hidden" name="arrData[filters][7][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][value]" value="" />

									<div class="col-md-2">
										<input type="text" class="form-control pull-left m-r-10 text-primary text-center input-name-filter" name="arrData[filters][7][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][name]" data-name="F7" value="F7" style="width: 60px;" />
										
										<div class="radio radio-primary pull-left m-r-10">
											<input type="radio" checked="checked" name="arrData[filters][7][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][settings][is_not]" value="1" />
											<label for="">Is</label>
										</div>

										<div class="radio radio-primary pull-left m-t-10">
											<input type="radio" name="arrData[filters][7][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][settings][is_not]" value="0" />
											<label for="">Is Not</label>
										</div>
									</div>

									<div class="col-md-9">
										<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-t-10" title="" data-toggle="modal" data-target="#select-memberships-modal"  data-element="arrData[filters][7][{Project_Automation_Filter::$type['IS_NOT_IN_MEMBERSHIP']}][value]">
											Choose
											<span class="btn-label m-r-0 m-l-5">0</span>
										</button>
									</div>
									
									<div class="col-md-1">
										<a href="#" class="btn btn-icon btn-success waves-effect waves-light m-r-5 btn-add-filter" title="Add"><i class="ion-plus"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>

						<div class="form-group">
							<label>Logical Diagram</label>
							<input type="text" class="form-control" name="arrData[settings][logical_diagram]" value="{$arrData.settings.logical_diagram}" />
							<span>Note: you can edit logical diagram to adapt to your goals. For example, you can update it to ( F1 AND F2 ) OR F5 or, for example, F1 OR (F2 AND NOT F3) or any other combinations.</span>
						</div>
					</div> 
				</div> 
			</div> 
			<!-- End Accordion Tab -->
			
			<!-- Accordion Actions -->
			<div class="panel panel-default"> 
				<div class="panel-heading"> 
					<h4 class="panel-title"> 
						<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseThree-2" class="collapsed" aria-expanded="false">
							Step 3: Actions
						</a> 
					</h4> 
				</div> 
				<div id="collapseThree-2" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
					<div class="panel-body">
						<p>Note: when you select multiple actions, ALL of them will be executed when any of the triggers are discovered and if it corresponds to the selected filters.</p>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['ADD_TAG']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['ADD_TAG']].id}" />
							<input type="checkbox" id="action-1" class="has-field" name="" value=""{if isset($arrData.actions[Project_Automation_Action::$type['ADD_TAG']])} checked="checked"{/if} />
							<label for="action-1">Add tag</label>
							<div class="form-group m-t-10"{if !isset($arrData.actions[Project_Automation_Action::$type['ADD_TAG']])} style="display: none"{/if}>
								<input type="text" name="arrData[actions][{Project_Automation_Action::$type['ADD_TAG']}][value]" class="form-control" value="{$arrData.actions[Project_Automation_Action::$type['ADD_TAG']].action_values}" />
							</div>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['REMOVE_TAG']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['REMOVE_TAG']].id}" />
							<input type="checkbox" id="action-1" class="has-field" name="" value=""{if isset($arrData.actions[Project_Automation_Action::$type['REMOVE_TAG']])} checked="checked"{/if} />
							<label for="action-1">Remove tag</label>
							<div class="form-group m-t-10"{if !isset($arrData.actions[Project_Automation_Action::$type['REMOVE_TAG']])} style="display: none"{/if}>
								<input type="text" name="arrData[actions][{Project_Automation_Action::$type['REMOVE_TAG']}][value]" class="form-control" value="{$arrData.actions[Project_Automation_Action::$type['REMOVE_TAG']].action_values}" />
							</div>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['PAUSE_EF']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['PAUSE_EF']].id}" />
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['PAUSE_EF']}][value]" value="{$arrData.actions[Project_Automation_Action::$type['PAUSE_EF']].action_values}" />
							<input type="checkbox" id="action-2" name="" value=""{if isset($arrData.actions[Project_Automation_Action::$type['PAUSE_EF']])} checked="checked"{/if} />
							<label for="action-2">Pause from Email Funnel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.actions[Project_Automation_Action::$type['PAUSE_EF']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[actions][{Project_Automation_Action::$type['PAUSE_EF']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.actions[Project_Automation_Action::$type['PAUSE_EF']])}0{else}{count(explode(',',$arrData.events[Project_Automation_Action::$type['PAUSE_EF']].action_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['REMOVE_EF']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['REMOVE_EF']].id}" />
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['REMOVE_EF']}][value]" value="{$arrData.actions[Project_Automation_Action::$type['REMOVE_EF']].action_values}" />
							<input type="checkbox" id="action-3" name="" value=""{if isset($arrData.actions[Project_Automation_Action::$type['REMOVE_EF']])} checked="checked"{/if} />
							<label for="action-3">Remove from Email Funnel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.actions[Project_Automation_Action::$type['REMOVE_EF']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[actions][{Project_Automation_Action::$type['REMOVE_EF']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.actions[Project_Automation_Action::$type['REMOVE_EF']])}0{else}{count(explode(',',$arrData.actions[Project_Automation_Action::$type['REMOVE_EF']].action_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['RESUME_EF']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['RESUME_EF']].id}" />
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['RESUME_EF']}][value]" value="{$arrData.actions[Project_Automation_Action::$type['RESUME_EF']].action_values}" />
							<input type="checkbox" id="action-4" name="" value=""{if isset($arrData.actions[Project_Automation_Action::$type['RESUME_EF']])} checked="checked"{/if} />
							<label for="action-4">Resume Email Funnel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.actions[Project_Automation_Action::$type['RESUME_EF']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[actions][{Project_Automation_Action::$type['RESUME_EF']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.actions[Project_Automation_Action::$type['RESUME_EF']])}0{else}{count(explode(',',$arrData.actions[Project_Automation_Action::$type['RESUME_EF']].action_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['ADD_EF']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['ADD_EF']].id}" />
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['ADD_EF']}][value]" value="{$arrData.actions[Project_Automation_Action::$type['ADD_EF']].action_values}" />
							<input type="checkbox" id="action-5" name="" value=""{if isset($arrData.actions[Project_Automation_Action::$type['ADD_EF']])} checked="checked"{/if} />
							<label for="action-5">Add to Email Funnel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.actions[Project_Automation_Action::$type['ADD_EF']])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-email-funnels-modal"  data-element="arrData[actions][{Project_Automation_Action::$type['ADD_EF']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.actions[Project_Automation_Action::$type['ADD_EF']])}0{else}{count(explode(',',$arrData.actions[Project_Automation_Action::$type['ADD_EF']].action_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['UPDATE_CONTACT']}][id]" value="{$arrData.actions[Project_Automation_Action::$type['UPDATE_CONTACT']].id}" />
							<input type="checkbox" id="action-6" class="has-field" name="arrData[actions][{Project_Automation_Action::$type['UPDATE_CONTACT']}][value]" value="1"{if isset($arrData.actions[Project_Automation_Action::$type['UPDATE_CONTACT']])} checked="checked"{/if} />
							<label for="action-6">Update Contact</label>
							<div class="form-group m-t-10"{if !isset($arrData.actions[Project_Automation_Action::$type['UPDATE_CONTACT']])} style="display: none"{/if}>
								{foreach from=$arrData.actions[Project_Automation_Action::$type['UPDATE_CONTACT']].settings.name key=k item=i}
								<div class="row m-b-20" data-fields="">
									<div class="col-md-3">
										<input type="text" name="arrData[actions][{Project_Automation_Action::$type['UPDATE_CONTACT']}][settings][name][{$k}]" placeholder="Name" class="form-control" value="{$i}" />
									</div>
									<div class="col-md-3 p-l-0">
										<input type="text" name="arrData[actions][{Project_Automation_Action::$type['UPDATE_CONTACT']}][settings][value][{$k}]" placeholder="Value" class="form-control" value="{$arrData.actions[Project_Automation_Action::$type['UPDATE_CONTACT']].settings.value[$k]}" />
									</div>
									<div class="col-md-1" style="padding-top: 2px;">
										<a href="#" data-action="add" class="btn btn-icon btn-success waves-effect waves-light m-r-5" title="Add" onclick="addActions(this);return false;"><i class="ion-plus"></i></a><a href="#" data-action="delete" class="btn btn-icon btn-danger waves-effect waves-light" title="Delete" onclick="addActions(this);return false;"><i class="ion-trash-a"></i></a>
									</div>
								</div>
								{foreachelse}
								<div class="row m-b-20" data-fields="">
									<div class="col-md-3">
										<input type="text" name="arrData[actions][{Project_Automation_Action::$type['UPDATE_CONTACT']}][settings][name][]" placeholder="Name" class="form-control" />
									</div>
									<div class="col-md-3 p-l-0">
										<input type="text" name="arrData[actions][{Project_Automation_Action::$type['UPDATE_CONTACT']}][settings][value][]" placeholder="Value" class="form-control" />
									</div>
									<div class="col-md-1" style="padding-top: 2px;">
										<a href="#" data-action="add" class="btn btn-icon btn-success waves-effect waves-light m-r-5" title="Add" onclick="addActions(this);return false;"><i class="ion-plus"></i></a><a href="#" data-action="delete" class="btn btn-icon btn-danger waves-effect waves-light" title="Delete" onclick="addActions(this);return false;"><i class="ion-trash-a"></i></a>
									</div>
								</div>
								{/foreach}
							</div>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['SEND_TO_LC']}][id]" value="{$arrData.actions[{Project_Automation_Action::$type['SEND_TO_LC']}].id}" />
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['SEND_TO_LC']}][value]" value="{$arrData.actions[{Project_Automation_Action::$type['SEND_TO_LC']}].action_values}" />
							<input type="checkbox" id="action-7" name="" value=""{if isset($arrData.actions[{Project_Automation_Action::$type['SEND_TO_LC']}])} checked="checked"{/if} />
							<label for="action-7">Send to Lead Channel</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.actions[{Project_Automation_Action::$type['SEND_TO_LC']}])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-lead-channels-modal" data-element="arrData[actions][{Project_Automation_Action::$type['SEND_TO_LC']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.actions[{Project_Automation_Action::$type['SEND_TO_LC']}])}0{else}{count(explode(',',$arrData.actions[{Project_Automation_Action::$type['SEND_TO_LC']}].action_values))}{/if}</span>
							</button>
						</div>
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['PING_URL']}][id]" value="{$arrData.actions[{Project_Automation_Action::$type['PING_URL']}].id}">
							<input type="checkbox" id="action-8" class="has-field" name="arrData[actions][{Project_Automation_Action::$type['PING_URL']}][value]" value="1"{if isset($arrData.actions[{Project_Automation_Action::$type['PING_URL']}])} checked="checked"{/if} />
							<label for="action-8">Ping URL</label>
							<div class="form-group m-t-10"{if !isset($arrData.actions[{Project_Automation_Action::$type['PING_URL']}])} style="display: none"{/if}>
								<p>URL</p>
								<textarea name="arrData[actions][{Project_Automation_Action::$type['PING_URL']}][settings][url]" class="form-control m-b-20">{$arrData.actions[{Project_Automation_Action::$type['PING_URL']}].settings.url}</textarea>

								<p>Post Data</p>
								<textarea name="arrData[actions][{Project_Automation_Action::$type['PING_URL']}][settings][post_data]" class="form-control m-b-20">{$arrData.actions[{Project_Automation_Action::$type['PING_URL']}].settings.post_data}</textarea>

								<div class="checkbox checkbox-primary">
									<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['PING_URL']}][settings][send_json]" value="0" />
									<input type="checkbox" name="arrData[actions][{Project_Automation_Action::$type['PING_URL']}][settings][send_json]" id="send_json" value="1"{if $arrData.actions[{Project_Automation_Action::$type['PING_URL']}].settings.send_json == 1} checked="checked"{/if} />
									<label for="send_json">Send as JSON</label>
								</div>
							</div>
						</div>		

						{if Core_Acs::haveAccess( array( 'iFunnels Studio Starter', 'iFunnels LTD Studio Starter' ) )}
						<div class="checkbox checkbox-primary">
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['ADD_MEMBERSHIP']}][id]" value="{$arrData.actions[{Project_Automation_Action::$type['ADD_MEMBERSHIP']}].id}" />
							<input type="hidden" name="arrData[actions][{Project_Automation_Action::$type['ADD_MEMBERSHIP']}][value]" value="{$arrData.actions[{Project_Automation_Action::$type['ADD_MEMBERSHIP']}].action_values}" />
							<input type="checkbox" id="action-10" name="" value=""{if isset($arrData.actions[{Project_Automation_Action::$type['ADD_MEMBERSHIP']}])} checked="checked"{/if} />
							<label for="action-10">Add Membership</label>
							<button type="button" class="btn btn-success waves-effect waves-light btn-xs p-l-10 p-r-0 m-l-10" {if !isset($arrData.actions[{Project_Automation_Action::$type['ADD_MEMBERSHIP']}])}style="display: none;"{/if} title="" data-toggle="modal" data-target="#select-memberships-modal" data-element="arrData[actions][{Project_Automation_Action::$type['ADD_MEMBERSHIP']}][value]">
								Choose
								<span class="btn-label m-r-0 m-l-5">{if !isset($arrData.actions[{Project_Automation_Action::$type['ADD_MEMBERSHIP']}])}0{else}{count(explode(',',$arrData.actions[{Project_Automation_Action::$type['ADD_MEMBERSHIP']}].action_values))}{/if}</span>
							</button>
						</div>
						{/if}
					</div> 
				</div> 
			</div> 
			<!-- End Accordion Tab-->
		</div> 
		{if $limitEnd==0 || isset( $arrData )}<div class="form-group">
			<button type="submit" class="btn btn-default waves-effect waves-light">Save</button>
		</div>{/if}
	</form>
</div>

<!-- Modal Email Funnels -->
<div id="select-email-funnels-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width:55%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="custom-width-modalLabel">Email Funnels</h4>
			</div>
			<div class="modal-body">
				{foreach from=$arrEfunnels item=ef}
				<div class="checkbox checkbox-primary">
					<input type="checkbox" id="e-ef-{$ef.id}" value="{$ef.id}">
					<label for="e-ef-{$ef.id}">{$ef.title}</label>
				</div>
				{/foreach}
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" id="save_selected_ef">Save changes</button>
			</div>
		</div>
	</div>
</div>
<!-- End Modal -->

<!-- Modal Lead Channels -->
<div id="select-lead-channels-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width:55%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="custom-width-modalLabel">Lead Channels</h4>
			</div>
			<div class="modal-body">
				{foreach from=$arrLeadChannels item=lc}
				<div class="checkbox checkbox-primary">
					<input type="checkbox" id="e-lc-{$lc.id}" value="{$lc.id}">
					<label for="e-lc-{$lc.id}">{$lc.name}</label>
				</div>
				{/foreach}
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" id="save_selected_lc" data-element="arrData[added_to_lead_channels]">Save changes</button>
			</div>
		</div>
	</div>
</div>
<!-- End Modal -->

<!-- Modal Messages Email Funnels -->
<div id="select-messages-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width:55%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="custom-width-modalLabel">Messages</h4>
			</div>
			<div class="modal-body">
				{foreach from=$arrEfunnels item=ef}
				<div class="panel panel-border panel-custom">
					<div class="panel-heading">
						<h3 class="panel-title">{$ef.title}</h3>
					</div>
					<div class="panel-body">
						{foreach from=$ef.message item=message}
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="messsage-{$message.id}" value="{$message.id}" />
							<label for="messsage-{$message.id}">{$message.name}</label>
						</div>
						{/foreach}
					</div>
				</div>
				{/foreach}
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" id="save_selected_m" data-element="arrData[opened_message]">Save changes</button>
			</div>
		</div>
	</div>
</div>
<!-- End Modal -->

<!-- Modal Memberships -->
<div id="select-memberships-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width:55%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="custom-width-modalLabel">Memberships</h4>
			</div>

			<div class="modal-body">
				<div class="row">
					{foreach from=$arrMemberships item=m}
					<div class="col-md-6">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="m-{$m.id}" value="{$m.id}">
							<label for="m-{$m.id}">{$m.name}</label>
						</div>
					</div>
					{/foreach}
				</div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" id="save_selected_membership" data-element="arrData[actions][{Project_Automation_Action::$type['ADD_MEMBERSHIP']}][value]">Save changes</button>
			</div>
		</div>
	</div>
</div>
<!-- End Modal -->

<!-- Modal Memberships -->
<div id="select-pay-memberships-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width:55%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="custom-width-modalLabel">Memberships</h4>
			</div>

			<div class="modal-body">
				<div class="row">
					{foreach from=$arrPayMemberships item=m}
					<div class="col-md-6">
						<div class="checkbox checkbox-primary">
							<input type="checkbox" id="m-{$m.id}" value="{$m.id}">
							<label for="m-{$m.id}">{$m.name}</label>
						</div>
					</div>
					{/foreach}
				</div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" id="save_selected_pay_membership" data-element="arrData[actions][{Project_Automation_Action::$type['ADD_MEMBERSHIP']}][value]">Save changes</button>
			</div>
		</div>
	</div>
</div>
<!-- End Modal -->

{literal}
<script>
	j( document ).ready( function(){
		j.expr[':'].typein = function(obj, index, meta){
			return meta[3].split(',').indexOf( j(obj).prop('type') ) !== -1 ? true : false;
		};

		j( 'form input[type="checkbox"]' ).on( 'change', function(e){
			j( this ).next().next( 'button[data-toggle]' ).stop( true, true ).toggle();
			let logical_string = j('input[name="arrData[settings][logical_diagram]"]').prop('value');
			if( j( this ).prop( 'checked' ) && j( this ).hasClass( 'has-field' ) ){
				j( this ).next().next().stop( true, true ).fadeIn( 'fast' );
				if( logical_string == '' ){
					j('input[name="arrData[settings][logical_diagram]"]').prop('value', j(this).next().next().find('.input-name-filter').prop('value') );
				} else {
					if(j(this).next().next().find('.input-name-filter').length > 0)
						j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string.trim() + " AND " + j(this).next().next().find('.input-name-filter').prop('value') );
				}
			} else {
				let self = this, patern = null;
				j( this ).next().next('.form-group.m-t-10').stop( true, true ).fadeOut( 'fast', function(){
					j(self).next().next('.form-group.m-t-10').children('div.row:not(:first)').each(function(){
						patern = new RegExp('((\\s)*(AND\\s|OR\\s)*(NOT\\s)*' + j(this).find('.input-name-filter').prop('value') + '\\b(\\s)*)', 'g');
						logical_string = logical_string.trim().replace(patern, ' ');
					}).remove();
					j(self).next().next('.form-group.m-t-10').children('div.row').each(function(){
						//((NOT\\s|AND\\s|OR\\s)*' + filterName + '\\b(\\s)*)
						let filterName = j(this).find('.input-name-filter').prop('value');
						patern = new RegExp('(^(NOT\\s|AND\\s|OR\\s)*'+filterName+'\\b(\\s)*(AND |OR )|(NOT\\s|AND\\s|OR\\s)*'+filterName+'\\b(\\s)*)', 'g');
						logical_string = logical_string.trim().replace(patern, ' ');
						
						j(this).find('input:radio').prop('checked', false).eq(0).prop('checked', true);
						j(this).find('button[data-element]').each(function(){
							jQuery(this).children('span').html(0);
						});
						j(this).find('input[type="hidden"],input[type="text"]:not(.input-name-filter)').prop('value', '');
					});
					j(self).next().next('.form-group.m-t-10').children( 'input:typein(hidden,text)' ).prop('value', '').attr('value', '');
					j(self).next().next('.form-group.m-t-10').children( 'textarea:not([data-widget])' ).prop('value', '').attr('value', '');
					j(self).next().next('.form-group.m-t-10').find( 'input:checkbox' ).prop('checked', false);
					
					j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string.trim());
				} );
				j(self).next().next('button').children('span').html(0);
				j( '[name="' + j(self).next().next('button').data('element') + '"]').prop('value', '').attr('value', '');
			}
		} );

		j('#select-email-funnels-modal').on( 'show.bs.modal', function (e) {
			j( '#select-email-funnels-modal input[type="checkbox"]' ).prop( 'checked', false );
			j( '#save_selected_ef' ).data( 'element', j( e.relatedTarget ).data( 'element' ) );
			j( '[name="' + j( e.relatedTarget ).data( 'element' ) + '"]' ).prop( 'value' ).split( ',' ).forEach(function( value, index ){
				j( '#select-email-funnels-modal input[type="checkbox"][value="' + value + '"]' ).prop( 'checked', true );
			});
		});

		j('#select-messages-modal').on( 'show.bs.modal', function (e) {
			j( '#select-messages-modal input[type="checkbox"]' ).prop( 'checked', false );
			j( '#save_selected_m' ).data( 'element', j( e.relatedTarget ).data( 'element' ) );
			j( '[name="' + j( e.relatedTarget ).data( 'element' ) + '"]' ).prop( 'value' ).split( ',' ).forEach(function( value, index ){
				j( '#select-messages-modal input[type="checkbox"][value="' + value + '"]' ).prop( 'checked', true );
			});
		});

		j('#select-lead-channels-modal').on( 'show.bs.modal', function (e) {
			j( '#select-lead-channels-modal input[type="checkbox"]' ).prop( 'checked', false );
			j( '#save_selected_lc' ).data( 'element', j( e.relatedTarget ).data( 'element' ) );
			j( '[name="' + j( e.relatedTarget ).data( 'element' ) + '"]' ).prop( 'value' ).split( ',' ).forEach(function( value, index ){
				j( '#select-lead-channels-modal input[type="checkbox"][value="' + value + '"]' ).prop( 'checked', true );
			});
		});

		j('#select-memberships-modal').on( 'show.bs.modal', function (e) {
			j( '#select-memberships-modal input[type="checkbox"]' ).prop( 'checked', false );
			j( '#save_selected_membership' ).data( 'element', j( e.relatedTarget ).data( 'element' ) );
			j( '[name="' + j( e.relatedTarget ).data( 'element' ) + '"]' ).prop( 'value' ).split( ',' ).forEach(function( value, index ){
				j( '#select-memberships-modal input[type="checkbox"][value="' + value + '"]' ).prop( 'checked', true );
			});
		});

		j('#select-pay-memberships-modal').on( 'show.bs.modal', function (e) {
			j( '#select-pay-memberships-modal input[type="checkbox"]' ).prop( 'checked', false );
			j( '#save_selected_pay_membership' ).data( 'element', j( e.relatedTarget ).data( 'element' ) );
			j( '[name="' + j( e.relatedTarget ).data( 'element' ) + '"]' ).prop( 'value' ).split( ',' ).forEach(function( value, index ){
				j( '#select-pay-memberships-modal input[type="checkbox"][value="' + value + '"]' ).prop( 'checked', true );
			});
		});

		j( '#save_selected_membership, #save_selected_pay_membership' ).on( 'click', function(e){
			let  _selectedMB = [], _valuesMB = [];
			j(this).parent().prev().find( 'input:checked' ).each( function(){
				_selectedMB.push( j(this).next().text() );
				_valuesMB.push( j(this).prop( 'value' ) );
			} );

			j( '[data-element="' + j( this ).data( 'element' ) + '"]' )
				.attr( 'title', _selectedMB.join( ', ' ) )
				.children( 'span' ).html( j(this).parent().prev().find( 'input:checked' ).length );
			j( '[name="' + j( this ).data( 'element' ) + '"]' ).prop( 'value', _valuesMB.join( ',' ) );
		} );

		j( '#save_selected_ef' ).on( 'click', function(e){
			let  _selectedEF = [], _valuesEF = [];
			j(this).parent().prev().find( 'input:checked' ).each( function(){
				_selectedEF.push( j(this).next().text() );
				_valuesEF.push( j(this).prop( 'value' ) );
			} );
			j( '[data-element="' + j( this ).data( 'element' ) + '"]' )
				.attr( 'title', _selectedEF.join( ', ' ) )
				.children( 'span' ).html( j(this).parent().prev().find( 'input:checked' ).length );
			j( '[name="' + j( this ).data( 'element' ) + '"]' ).prop( 'value', _valuesEF.join( ',' ) );

			if( j( this ).data( 'element' ) == 'arrData[is_is_not_in_email_funnel]' ){
				j( 'button[data-element="arrData[is_is_not_in_email_funnel]"]' ).next().stop( true, true ).fadeIn( 'fast' );
			}
		} );

		j( '#save_selected_lc' ).on( 'click', function(e){
			let  _selectedLC = [], _valuesLC = [];
			j(this).parent().prev().find( 'input:checked' ).each( function(){
				_selectedLC.push( j(this).next().text() );
				_valuesLC.push( j(this).prop( 'value' ) );
			} );
			j( '[data-element="' + j( this ).data( 'element' ) + '"]' )
				.attr( 'title', _selectedLC.join( ', ' ) )
				.children( 'span' ).html( j(this).parent().prev().find( 'input:checked' ).length );
			j( '[name="' + j( this ).data( 'element' ) + '"]' ).prop( 'value', _valuesLC.join( ',' ) );
		} );

		j( '#save_selected_m' ).on( 'click', function(e){
			let  _selectedMessage = [], _valuesMessage = [];
			j(this).parent().prev().find( 'input:checked' ).each( function(){
				_selectedMessage.push( j(this).next().text() );
				_valuesMessage.push( j(this).prop( 'value' ) );
			} );
			j( '[data-element="' + j( this ).data( 'element' ) + '"]' )
				.attr( 'title', _selectedMessage.join( ', ' ) )
				.children( 'span' ).html( j(this).parent().prev().find( 'input:checked' ).length );
			j( '[name="' + j( this ).data( 'element' ) + '"]' ).prop( 'value', _valuesMessage.join( ',' ) );
		} );	

		j('.btn-add-filter').on('click', function(){
			let logical_string = j('input[name="arrData[settings][logical_diagram]"]').prop('value');
			let _idFilter = 0;
			j('input[name*="arrData[filters]"]:typein(hidden,text)').each(function(){
				let value = parseInt( j(this).prop('name').match(new RegExp( /[a-z]+\[[a-z]+\]\[(\d+)\]\[\d+\]\[[a-z_]+\]/i ))[1] );
				if( _idFilter < value ){
					_idFilter = value;
				}
			});
			_idFilter++;
			let _clone = j(this).parent().parent().clone();
			_clone.addClass('m-t-20');
			_clone.find('.btn-add-filter').parent().append( '<a href="#" class="btn btn-icon btn-danger waves-effect waves-light btn-delete-filter" title="Delete"><i class="ion-trash-a"></i></a>' );
			_clone.find('.btn-add-filter').remove();
			_clone.find('input:radio').prop('checked', false).eq(0).prop('checked', true);
			_clone.find('button[data-element]').each(function(){
				let elementName = j(this).data('element').replace(new RegExp( /([a-z]+\[[a-z]+\]\[)\d+(\]\[\d+\]\[[a-z_]+\])/gi ), '$1' + _idFilter + '$2');
				j(this).data('element', elementName).attr('data-element', elementName);
				jQuery(this).children('span').html(0);
			});
			_clone.find('input:not(:radio)').prop('value', '')
			_clone.find('input').each(function(){
				j(this).prop('name', j(this).prop('name').replace(new RegExp( /([a-z]+\[[a-z]+\]\[)\d+(\]\[\d+\]\[[a-z_]+\])/gi ), '$1' + _idFilter + '$2'));
			});
			_clone.find('.input-name-filter').prop('value', 'F' + _idFilter).attr('data-name', 'F' + _idFilter);
			j(this).parent().parent().parent().children( 'div:last' ).after( _clone );
			j( '.btn-delete-filter' ).off('click').on('click', function(){
				let self = this, patern = new RegExp('((\\s)+(AND\\s|OR\\s)*(NOT\\s)*' + j(this).parent().parent().find('.input-name-filter').prop('value') + '(\\s)*)', 'g');
				logical_string=j('input[name="arrData[settings][logical_diagram]"]').prop('value');
				logical_string = logical_string.replace(patern, ' ');
				j(this).parent().parent().fadeOut('fast', function(){
					j(self).parent().parent().remove();
				});
				j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string );
				return false;
			});
			if( logical_string == '' ){
				j('input[name="arrData[settings][logical_diagram]"]').prop('value', 'F' + _idFilter );
			} else {
				j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string + " AND " + 'F' + _idFilter );
			}
			j( 'input[name*="arrData[filters]"]:radio' ).off('change').on('change',function(){
				logical_string = j('input[name="arrData[settings][logical_diagram]"]').prop('value');
				let patern = null, 
					filterName = j(this).parent().parent().children('.input-name-filter').prop('value');
				if( j(this).prop('value') == 1 ){
					patern = new RegExp('(NOT)*\\s('+ filterName + ')');
					logical_string = logical_string.replace(patern, '$2');
				} else {
					patern = new RegExp('\\s('+ filterName + ')');
					logical_string = logical_string.replace(patern, ' NOT $1');
				}
				j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string );
			});

			j('.input-name-filter').on('change', function(){
				if(j(this).prop('value').trim() == ''){
					j(this).prop('value', j(this).data('name'));
					return;
				}
				j('input[name="arrData[settings][logical_diagram]"]').prop('value', j('input[name="arrData[settings][logical_diagram]"]').val().replace( new RegExp( j(this).data('name') + '\\b', 'g' ), j(this).prop('value')));
				j(this).data('name', j(this).prop('value')).attr('data-name', j(this).prop('value'));
			});

			j('.input-name-filter').off('keydown').on('keydown', function(e){
				if( !e.key.test( /[a-z0-9]/gi ) || j(this).prop('value').length > 10 && e.keyCode != 8 )
					return false;
			});

			j('.input-name-filter').off('keyup').on('keyup', function(e){
				j(this).prop('value', j(this).prop('value').toUpperCase());
			});
			return false;
		});

		j( 'input[name*="arrData[filters]"]:radio' ).on('change',function(){
			logical_string = j('input[name="arrData[settings][logical_diagram]"]').prop('value');
			let patern = null, 
				filterName = j(this).parent().parent().children('.input-name-filter').prop('value');
			if( j(this).prop('value') == 1 ){
				patern = new RegExp('(NOT)*\\s('+ filterName + ')');
				logical_string = logical_string.replace(patern, '$2');
			} else {
				patern = new RegExp('('+ filterName + ')');
				logical_string = logical_string.replace(patern, 'NOT $1');
			}
			j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string );
		});

		j('.input-name-filter').on('change', function(){
			if(j(this).prop('value').trim() == ''){
				j(this).prop('value', j(this).data('name'));
				return;
			}
			j('input[name="arrData[settings][logical_diagram]"]').prop('value', j('input[name="arrData[settings][logical_diagram]"]').val().replace( new RegExp( j(this).data('name') + '\\b', 'g' ), j(this).prop('value')));
			j(this).data('name', j(this).prop('value')).attr('data-name', j(this).prop('value'));
		});

		j('.input-name-filter').on('keydown', function(e){
			if( !e.key.test( /[a-z0-9]/gi ) || j(this).prop('value').length > 10 && e.keyCode != 8 )
				return false;
		});

		j('.input-name-filter').on('keyup', function(e){
			j(this).prop('value', j(this).prop('value').toUpperCase());
		});

		j( '.btn-delete-filter' ).on('click', function(){
			let self = this, patern = new RegExp('((\\s)+(AND\\s|OR\\s)*(NOT\\s)*' + j(this).parent().parent().find('.input-name-filter').prop('value') + '(\\s)*)', 'g');
			logical_string=j('input[name="arrData[settings][logical_diagram]"]').prop('value');
			logical_string = logical_string.replace(patern, ' ');
			j(this).parent().parent().fadeOut('fast', function(){
				j(self).parent().parent().remove();
			});
			j('input[name="arrData[settings][logical_diagram]"]').prop('value', logical_string );
			return false;
		});
	} );

	function addActions( elem ) {
		switch( j( elem ).data( 'action' ) ){
			case "add":
				j( elem ).parent().parent().after( 
					'<div class="row m-b-20" data-fields="">' +
						'<div class="col-md-3">' +
							'<input type="text" name="arrData[actions][{/literal}{Project_Automation_Action::$type['UPDATE_CONTACT']}][settings][name][]{literal}" placeholder="Name" class="form-control" />' +
						'</div>' +
						'<div class="col-md-3 p-l-0">' +
							'<input type="text" name="arrData[actions][{/literal}{Project_Automation_Action::$type['UPDATE_CONTACT']}][settings][value][]{literal}" placeholder="Value" class="form-control" />' +
						'</div>' +
						'<div class="col-md-1" style="padding-top: 2px;">' +
							'<a href="#" data-action="add" class="btn btn-icon btn-success waves-effect waves-light m-r-5" title="Add" onclick="addActions(this);return false;"><i class="ion-plus"></i></a>' +
							'<a href="#" data-action="delete" class="btn btn-icon btn-danger waves-effect waves-light" title="Delete" onclick="addActions(this);return false;"><i class="ion-trash-a"></i></a>' +
						'</div>' +
					'</div>'
				);
			break;
			case "delete":
				if( j( '[data-fields]' ).length > 1 ) {
					j( elem ).parent().parent().remove();
				}
			break;
		}
		return false;
	}
</script>
{/literal}