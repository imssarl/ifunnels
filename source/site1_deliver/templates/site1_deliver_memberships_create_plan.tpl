<h4 class="page-title m-b-20">Create New Membership for <span class="label label-default">{$siteData.name}</span> site</h4>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/components/icon.min.css">
<link rel="stylesheet" href="/skin/ifunnels-studio/dist/css/deliver.bundle.css">

<div class="card-box">
	{if ! empty( $errorLists )}
		{foreach from=$errorLists.errFlow item=errorMessage}
		<div class="alert alert-danger">
			<strong>Error!</strong> {$errorMessage}
		</div>
		{/foreach}
	{/if}

	{if ! empty($arrPlan) && strcmp( $stripe_account, $arrPlan.stripe_account ) !== 0}
	<div class="alert alert-warning">
		<strong>Warning!</strong> This membership was created using a different Stripe account. You can re-create this membership with your current account, or re-add the corresponding account to further manage this membership.
	</div>
	{/if}

	<form method="POST" enctype="multipart/form-data" class="membership-form">
		<input type="hidden" name="arrData[site_id]" value="{$siteData.id}" />
		<input type="hidden" name="arrData[id]" value="{$arrPlan.id}">

		<div class="form-group">
			<label for="name" class="label-control">Name of your membership plan</label>
			<input type="text" class="form-control" name="arrData[name]" value="{$arrPlan.name}" />
			<span class="text-muted small">This is what customers will see during checkout, in their invoice and profile</span>
		</div>

		<div class="form-group">
			<label class="label-control">Membership Home Page URL</label>
			<input name="arrData[home_page_url]" type="text" class="form-control" value="{$arrPlan.home_page_url}" />
		</div>

		<div class="form-group">
			<label class="label-control">Description</label>
			<textarea name="arrData[description]" class="form-control">{$arrPlan.description}</textarea>
		</div>

		<div class="form-group">
			<label class="label-control">Is this a free or paid product</label>&nbsp;
			<input type="hidden" name="arrData[type]" value="0" />
			<input id="type" {if $arrPlan.type == 1}checked{/if} type="checkbox" name="arrData[type]" data-plugin="switchery" data-color="#5d9cec" value="1" />
		</div>

		<div class="panel panel-default {if empty( $arrPlan.type ) || $arrPlan.type == 0}hidden{/if}">
			<div class="panel-footer">
				Pricing of your plan
			</div>

			<div class="panel-body">
				<div class="row">
					<div class="col-md-6">
						<div class="form-group">
							<label class="label-control">Amount <span class="text-danger">*</span></label>
							<div class="input-group">
								<span class="input-group-addon"><b>{$siteData.currency}</b></span>
								<input type="text" name="arrData[amount]" class="form-control" value="{$arrPlan.amount}">
							</div>
						</div>
				
						<div class="form-group">
							<label class="label-control">Frequency</label>&nbsp;
							{if ! empty( $arrPlan.id ) && ! is_null( $arrPlan.frequency ) }
							<input type="hidden" name="arrData[frequency]" id="frequency" value="{$arrPlan.frequency}" />
							<span class="label label-default">{if $arrPlan.frequency == 0}One Time{else}Recurring{/if}</span>
							{else}
							<select name="arrData[frequency]" id="frequency" class="selectpicker">
								<option value="0" {if $arrPlan.frequency == 0 || empty( $arrPlan.frequency )}selected="selected"{/if}>One Time</option>
								<option value="1" {if $arrPlan.frequency == 1}selected="selected"{/if}>Recurring</option>
							</select>
							{/if}
						</div>

						<div class="form-group {if $arrPlan.frequency == 0}hidden{/if}" data-frequency="1">
							<label class="label-control">Billing frequency</label>&nbsp;
							<select name="arrData[billing_frequency]" id="frequency" class="selectpicker">
								<option value="week" {if $arrPlan.billing_frequency == 'week'}selected="selected"{/if}>Weekly</option>
								<option value="month" {if $arrPlan.billing_frequency == 'month' || empty( $arrPlan.billing_frequency )}selected="selected"{/if}>Monthly</option>
								<option value="year" {if $arrPlan.billing_frequency == 'year'}selected="selected"{/if}>Yearly</option>
							</select>
						</div>
				
						<div class="form-group {if $arrPlan.frequency == 0}hidden{/if}" data-frequency="1">
							<label class="label-control">Offer Trial Amount</label>
							<div class="input-group">
								<span class="input-group-addon"><b>{$siteData.currency}</b></span>
								<input name="arrData[trial_amount]" type="text" class="form-control" value="{$arrPlan.trial_amount}" />
							</div>
							
							<span class="text-muted small">Enter the amount and duration (in days) or leave empty for no trial</span>
						</div>
				
						<div class="form-group {if $arrPlan.frequency == 0}hidden{/if}" data-frequency="1">
							<label class="label-control">Offer Trial Duration</label>
							<div class="input-group">
								<span class="input-group-addon"><b>Day</b></span>
								<input name="arrData[trial_duration]" type="text" class="form-control" value="{$arrPlan.trial_duration}" />
							</div>
						</div>
				
						<div class="form-group {if $arrPlan.frequency == 0}hidden{/if}" data-frequency="1">
							<label class="label-control">Limit nubmer of rebills</label>
							<input name="arrData[limit_rebills]" type="text" class="form-control" value="{$arrPlan.limit_rebills}" />
							<span class="text-muted small">For payment plans or limited plans (leave empty for unlimited)</span>
						</div>

						<div class="form-group">
							<div class="checkbox checkbox-primary">
								<input type="hidden" name="arrData[require_shipping]" value="0" />
								<input id="require_shipping" type="checkbox" name="arrData[require_shipping]" value="1" {if $arrPlan.require_shipping == 1}checked{/if} />
								<label for="require_shipping">Require Shipping</label>
							</div>

							<label class="label-control">Allowed countries</label>&nbsp;
							<select class="selectpicker" name="arrData[allowed_contries][]" data-style="custom" data-live-search="true" multiple {if empty( $arrPlan.require_shipping )} disabled{/if}>
								<option value="ALL" {if in_array( 'ALL', $arrPlan.allowed_contries )}selected="selected"{/if}>All</option>
								{foreach from=$arrCountries item=country}
								<option value="{$country.iso}" {if in_array( $country.iso, $arrPlan.allowed_contries )}selected="selected"{/if}>{$country.name}</option>
								{/foreach}
							</select>
						</div>
				
						<div class="form-group">
							<div class="row">
								<div class="col-md-6">
									<label class="label-control">Additional Charges</label>
									<div class="input-group">
										<span class="input-group-addon"><b>{$siteData.currency}</b></span>
										<input name="arrData[add_charges]" type="text" class="form-control" value="{$arrPlan.add_charges}" />
									</div>
								</div>
								<div class="col-md-6 {if $arrPlan.frequency == 0}hidden{/if}" data-frequency="1">
									<label class="label-control" style="margin-bottom: 8px;">&nbsp;</label> <br>
									<select name="arrData[add_charges_frequency]" class="selectpicker">
										<option value="0" {if $arrPlan.add_charges_frequency == 0 || empty( $arrPlan.add_charges_frequency )}selected="selected"{/if}>One Time</option>
										<option value="1" {if $arrPlan.add_charges_frequency == 1}selected="selected"{/if}>Recurring</option>
									</select>
								</div>
							</div>
							
							<span class="text-muted small">For setup fees or shipping fees for example</span>
						</div>

						<div class="form-group">
							<label class="label-control">Label for the Additional Charge</label>
							<input name="arrData[label_charges]" type="text" class="form-control" value="{$arrPlan.label_charges}" />
							<span class="text-muted small">For example: Shipping & Handling, Onboarding, Setup, etc.</span>
						</div>
				
						<div class="form-group">
							<label class="label-control">Add Taxes (%)</label>
							<input name="arrData[add_taxes]" type="text" class="form-control" value="{$arrPlan.add_taxes}" />
							<span class="text-muted small">Leave empty to not charge taxes</span>
						</div>

						{if Core_Acs::haveAccess( [ 'Automate' ] )}
						<div class="form-group">
							{if ! isset( $arrPlan['id'] ) && isset(Core_Users::$info.automation_limit) && (intval(Core_Users::$info.automation_limit) <= intval($count_automate) || intval(Core_Users::$info.automation_limit) - intval($count_automate) == 1)}
							<div class="text-danger">
								<strong><i class="ion-alert m-r-10"></i></strong> <small>Your limit of automation campaigns has been exhausted. Please renew it so you could continue using Automations.</small>
							</div>
							{/if}

							<div class="checkbox checkbox-primary">
								<input type="hidden" name="arrData[enable_automate]" value="0">
								<input id="integrate_with_automation" type="checkbox" {if $arrPlan.enable_automate === '1'}checked{/if} name="arrData[enable_automate]" value="1" {if ! isset( $arrPlan['id'] ) && isset(Core_Users::$info.automation_limit) && (intval(Core_Users::$info.automation_limit) <= intval($count_automate) || intval(Core_Users::$info.automation_limit) - intval($count_automate) == 1)}disabled{/if}>
								<label for="integrate_with_automation">Integrate with Automation</label>
							</div>

							<input type="hidden" name="arrData[aic]" value="{$arrPlan.aic}" />
							<input type="hidden" name="arrData[acc]" value="{$arrPlan.acc}" />
						</div>
						{/if}
					</div>

					<div class="col-md-6">
						<div class="panel panel-default no-controll">
							<div class="panel-heading">
								<h3 class="panel-title">Preview payment form</h3>
							</div>
							<div class="panel-body" id="preview" style="padding-bottom: 50px;">
							</div>
						</div>
					</div>
				</div>
				
			</div>
		</div>

		{if empty($arrPlan) || strcmp( $stripe_account, $arrPlan.stripe_account ) === 0}
		<div class="form-group">
			<button type="submit" class="btn btn-default waves-effect waves-light btn-md">
				Save
			</button>
		</div>
		{/if}
	</form>
</div>

<link href="/skin/light/plugins/switchery/dist/switchery.min.css" rel="stylesheet" />
<script src="/skin/light/plugins/switchery/dist/switchery.min.js"></script>
<script src="/skin/ifunnels-studio/dist/js/deliver.bundle.js"></script>
<script>
	document.addEventListener("DOMContentLoaded", function(event) {
		document.getElementById('type').addEventListener('change', function(e) {
			if( e.currentTarget.checked ) {
				document.querySelector('.panel').classList.remove('hidden');
			} else {
				document.querySelector('.panel').classList.add('hidden');
			}
		});

		/** Eventlistener for select[frequency] */
		document.getElementById('frequency').addEventListener('change', function(e) {
			var elementList = document.querySelectorAll('[data-frequency="1"]');
			if( e.currentTarget.value == 1 ) {
				elementList.forEach( function(element) {
					element.classList.remove( 'hidden' );
				} );
			} else {
				elementList.forEach( function(element) {
					element.classList.add( 'hidden' );
				} );
			}
		});
	});

	var config = {
		logo: '{$siteData.logo}',
		currency: '{$siteData.currency}',
		publicKey: '{Project_Deliver_Stripe::getPublicKey()}',
		stripeAccount: '{$stripe_account}'
	};
</script>

<div style="display: none;">
	<div data-form="subscription">
		<div class="form-content">
			<div class="form-items">
				<h3 class="form-title">Registration</h3>

				<div class="steps">
					<div class="step active completed" data-step="acount" data-active="true">
						<i class="user icon"></i>
						<div class="content">
							<div class="title">Acount Details</div>
							<div class="description">Enter your information</div>
						</div>
					</div>

					<div class="step active" data-step="payment" data-active="true">
						<i class="payment icon"></i>
						<div class="content">
							<div class="title">Payment</div>
							<div class="description">Enter card information</div>
						</div>
					</div>

					<div class="step" data-step="complete" data-active="true">
						<i class="info icon"></i>
						<div class="content">
							<div class="title">Complete Order</div>
							<div class="description">Check order details</div>
						</div>
					</div>
				</div>

				<div class="steps-content">
					<div class="step-content" data-step-content="payment" style="display: block;">
						<div class="form-subtitle">Payment Information</div>

						<div id="payment-form">
							<div class="order-summary">
								<img class="lazyload" src="{$siteData.logo}">
								<h3 class="form-subtitle">Test 1</h3>
								<div>
									<div class="order-summary__detail">
										<span>Order Subtotal</span>
										<span></span>
										<span>100 <span>{Project_Deliver_Currency::getCode($siteData.currency)}</span></span>
									</div>

									<div class="order-summary__detail">
										<span>Additional Charges</span>
										<span></span>
										<span>20 <span>{Project_Deliver_Currency::getCode($siteData.currency)}</span></span>
									</div>

									<div class="order-summary__detail">
										<span>Add Taxes</span>
										<span></span>
										<span>6%</span>
									</div>

									<div class="order-summary__total-amount">
										<span>Total</span>
										<span>127.2 <span>{Project_Deliver_Currency::getCode($siteData.currency)}</span></span>
									</div>
								</div>
							</div>

							<div class="form-subtitle">Card Details</div>
							
							<div class="alerts"></div>
							
							<div id="card-element"></div>
							<div id="card-errors" role="alert"></div>

							<div class="btn-pay">
								<button id="pay" type="button">Pay &nbsp;{Project_Deliver_Currency::getCode($siteData.currency)}127.2</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div data-form="one_time">
		<div class="form-content">
			<div class="form-items">
				<h3 class="form-title">Registration</h3>

				<div class="steps">
					<div class="step active completed" data-step="acount" data-active="true">
						<i class="user icon"></i>
						<div class="content">
							<div class="title">Acount Details</div>
							<div class="description">Enter your information</div>
						</div>
					</div>

					<div class="step active" data-step="payment" data-active="true">
						<i class="payment icon"></i>
						<div class="content">
							<div class="title">Payment</div>
							<div class="description">Enter card information</div>
						</div>
					</div>

					<div class="step" data-step="complete" data-active="true">
						<i class="info icon"></i>
						<div class="content">
							<div class="title">Complete Order</div>
							<div class="description">Check order details</div>
						</div>
					</div>
				</div>

				<div class="steps-content">
					<div class="step-content" data-step-content="payment" style="display: block;">
						<div class="form-subtitle">Payment Information</div>

						<div id="payment-form">
							<div class="order-summary">
								<img class="lazyload" src="{$siteData.logo}">
								<h3 class="form-subtitle">Test 1</h3>
								<div>
									<div class="order-summary__detail">
										<span>Order Subtotal</span>
										<span></span>
										<span>100 {Project_Deliver_Currency::getCode($siteData.currency)}</span>
									</div>

									<div class="order-summary__detail">
										<span>Additional Charges</span>
										<span></span>
										<span>20 {Project_Deliver_Currency::getCode($siteData.currency)}</span>
									</div>

									<div class="order-summary__detail">
										<span>Add Taxes</span>
										<span></span>
										<span>6%</span>
									</div>

									<div class="order-summary__total-amount">
										<span>Total</span>
										<span>127.2 {Project_Deliver_Currency::getCode($siteData.currency)}</span>
									</div>
								</div>
							</div>
							<div class="form-subtitle">Card Details</div>
							
							<div class="alerts"></div>
							
							<div id="card-element"></div>
							<div id="card-errors" role="alert"></div>

							<div class="btn-pay">
								<button id="pay" type="button">Pay &nbsp;{Project_Deliver_Currency::getCode($siteData.currency)}127.2</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>