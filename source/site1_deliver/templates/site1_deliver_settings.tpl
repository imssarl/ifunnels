<h4 class="page-title m-b-20">Settings</h4>
<style>
	.widget-style-2 i {
		display: flex;
		align-items: center;
	}
</style>

{if ! empty( $smarty.get.error )}
<div class="alert alert-danger">
	<strong>Error!</strong> {$smarty.get.error_description}
</div>
{/if}

{if ! empty( $connect_link )}
<div class="card-box">
	<a href="{$connect_link}" class="btn btn-primary waves-effect waves-light">
		<span class="btn-label text-uppercase"><strong>s</strong></span>
		Connect to Stripe
	</a>
</div>
{else}
<div class="row">
	<div class="col-lg-4">
		<div class="widget-panel widget-style-2 bg-white">
			<i class="md md-account-child text-custom"></i>
			<h2 class="m-0 text-dark font-600">Connected to {$stripe.company_data.business_name}</h2>
			<div class="text-muted m-t-5"><a class="text-muted" href="mailto:{$stripe.company_data.support_email}">{$stripe.company_data.support_email}</a></div>
			<div class="text-muted m-t-5"><a class="text-muted" href="{$stripe.company_data.support_url}" target="_blank">{$stripe.company_data.support_url}</a></div>

			<form method="POST">
				<input type="hidden" name="disconnect" value="1" />
				<button class="btn btn-primary waves-effect waves-light m-t-10">Disconnect</button>
			</form>
		</div>
	</div>

	<div class="col-lg-4">
		<div class="widget-panel widget-style-2 bg-white">
			<i><img width="50" src="/skin/i/frontends/design/icons/rewardful-logo.svg" alt="Rewardful"></i>

			<h2 class="m-0 text-dark font-600">Connect{if !empty($stripe.rewardful_api_key)}ed{/if} to Rewardful</h2>
			<form method="POST" style="max-width: 70%;">
				<div class="input-group m-t-10">
					<input type="text" name="rewardful_api_key" class="form-control" placeholder="Rewardful API Key" value="{$stripe.rewardful_api_key}" />

					<span class="input-group-btn">
						<button type="submit" class="btn waves-effect waves-light btn-primary">Submit</button>
					</span>
				</div>

				<small class="text-muted"><span class="text-danger">*</span> Can be found on the <a href="https://app.getrewardful.com/company/edit" target="_blank">Company settings</a> page in your Rewardful dashboard.</small>

				<p class="m-t-10 m-b-0" style="border-left:3px solid #5d9cec;padding-left:10px;background:rgb(93 156 236 / 11%);padding:5px 10px;">Join Rewardful <a href="https://www.getrewardful.com/?via=ifunnels" target="_blank" style="font-weight:bold;">Here</a></p>
			</form>
		</div>
	</div>
</div>
{/if}