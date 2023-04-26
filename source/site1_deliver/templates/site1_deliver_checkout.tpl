<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
	<link rel="stylesheet" href="/skin/ifunnels-studio/dist/css/stripe.bundle.css" />
</head>

<body>
	<script>var stripe_account = '{$stripe_account}'; var ajaxUrl = '{$ajaxUrl}';</script>

	{if $arrPlan.frequency == '0'}
	{if empty($status)}
	<script>var sessionId = '{$session.id}';</script>
	<button id="checkout">Checkout</button>
	{else}
	<h3>{$status}</h3>
	{/if}
	{else}
	<script>var planId = '{$arrPlan.id}';</script>
	<div class="sr-root">
		<div class="sr-main">
			<header class="sr-header">
				<div class="sr-header__logo" style="background-image: url({$arrSite.logo});"></div>

				{if ! empty( $arrPlan.trial_amount )}
				<label for="trial">
					<input type="checkbox" id="trial" />
					Trial
				</label>
				{/if}
			</header>

			<div class="sr-payment-summary payment-view">
				<h1 class="order-amount">{if $arrSite.currency == 'USD'}&dollar;{else}&euro;{/if}{$arrPlan.amount}.00</h1>
				<h4>{$arrPlan.name}</h4>
			</div>

			<form id="subscription-form">
				<div class="sr-payment-form payment-view">
					<div class="sr-form-row">
						<label for="card-element">
							Payment details
						</label>
						<div class="sr-combo-inputs">
							<div class="sr-combo-inputs-row">
								<input type="text" id="email" placeholder="Email" autocomplete="cardholder" class="sr-input" />
							</div>
							<div class="sr-combo-inputs-row">
								<div class="sr-input sr-card-element" id="card-element"></div>
							</div>
						</div>
						<div class="sr-field-error" id="card-errors" role="alert"></div>
					</div>
					<button id="submit">
						<div id="spinner" class="hidden"></div>
						<span id="button-text">Subscribe</span>
					</button>
					<div class="sr-legal-text">
						Your card will be immediately charged
						<span class="order-total">${$arrPlan.amount}.00</span>.
					</div>
				</div>
			</form>
			<div class="sr-payment-summary hidden completed-view">
				<h1>Your subscription is <span class="order-status"></span></h1>
			</div>
		</div>
		<div class="sr-content">
			<div class="pasha-image-stack">
				<img src="https://picsum.photos/280/320?random=1" width="140" height="160" />
				<img src="https://picsum.photos/280/320?random=2" width="140" height="160" />
				<img src="https://picsum.photos/280/320?random=3" width="140" height="160" />
				<img src="https://picsum.photos/280/320?random=4" width="140" height="160" />
			</div>
		</div>
	</div>
	{/if}
	<script src="/skin/ifunnels-studio/dist/js/stripe.bundle.js"></script>
</body>

</html>