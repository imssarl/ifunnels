{if $strError}{include file='../../message.tpl' type='error' message=$strError}{/if}
{if $congratulations}{include file='../../message.tpl' type='success' message='Profile is saved'}{/if}

{include file='../../error.tpl' fields=['buyer_phone'=>'Phone']}
{include file='../../box-top.tpl' title=$arrNest.title}

<link rel="stylesheet" href="/skin/light/plugins/lada/ladda.min.css" />
<script src="/skin/light/plugins/lada/spin.min.js"></script>
<script src="/skin/light/plugins/lada/ladda.min.js"></script>

<div class="card-box">
	<div class="tab-content default-tab">
		<form method="post" action="" class="validate">
		<input name="arrReg[id]" type="hidden" value="{$arrReg.id}"/>
		<input name="arrReg[email]" type="hidden" value="{$arrReg.email}"/>
			<fieldset>
				<div class="form-group">
					<label>API Client ID</label>
					<input type="text" class="required text-input medium-input form-control" value="{$apiKey}" readonly />
				</div>
				<div class="form-group">
					<label>API Client Secret</label>
					<input type="text" class="required text-input medium-input form-control" value="{$apiSecret}" readonly />
				</div>
				<div class="form-group">
					<label>Redirect URL</label>
					<input type="text" class="required text-input medium-input form-control" value="{$redirectUrl}" name="redirectUrl" />
				</div>
				<div class="form-group">
					<button type="submit" class="button btn btn-success waves-effect waves-light">Submit</button>
				</div>
			</fieldset>
			<div class="clear"></div>
		</form>
	</div>
	<div class="tab-content default-tab">
	{literal}

<h3>Authorization</h3>
<h4>Authorization Code flow</h4>
<p>First, your application must redirect the resource owner to the following URL:</p>

<code>http://api.ifunnels.com/v1/authorize?response_type=code&client_id=CLIENT_ID&state=xyz</code>
<br/><span>Remember to replace <code>CLIENT_ID</code> with your OAuth application credentials.</span>
<p>The <code>state</code> parameter is there for security reasons and should be a random string. When the resource owner grants your application access to the resource, we will redirect the browser to the redirect URL you specified in the application settings and attach the same state as the parameter. Comparing the state parameter value ensures that the redirect was initiated by our system.</p>

<h4>Example response</h4>
<code>AUTHORIZATION_CODE: 3cbfd4d7e56222f571c4d8be4298967d6ca8c390</code>

<h4>Exchanging authorization code for the access token</h4>
<p>Here's an example request to exchange authorization code for the access token:</p>

<code>$  curl -u CLIENT_ID:CLIENT_SECRET http://api.ifunnels.com/v1/token -d "grant_type=authorization_code&code=AUTHORIZATION_CODE"</code>
<br/><span>Remember to replace <code>CLIENT_ID</code> and <code>CLIENT_SECRET</code> with your OAuth application credentials.</span>
<br/><span>Remember to replace <code>AUTHORIZATION_CODE</code> from authorization Code flow step.</span>

<h4>Example response</h4>
<code>{"access_token":"dcf5c934e122394fced5c786c3a9d48b0d2b1fa6","expires_in":3600,"token_type":"Bearer","scope":null,"refresh_token":"122b5581d2ff4d313d85f9cca635f92e161ce77e"}</code>

<h4>Client Credentials flow</h4>
<p>This flow is suitable for development purposes, especially in cases when you need to quickly access API to create some functionality. You can get the access token with a single request:</p>

<h4>Request</h4>
<code>$  curl -u CLIENT_ID:CLIENT_SECRET http://api.ifunnels.com/v1/token -d 'grant_type=client_credentials'</code>
<br/><span>Remember to replace <code>CLIENT_ID</code> and <code>CLIENT_SECRET</code> with your OAuth application credentials.</span>

<h4>Response</h4>
<code>{"access_token":"f02b7f875ca7175747b133d2b84577a75e322275","expires_in":3600,"token_type":"Bearer","scope":null}</code>

<p>You can then use the access token to authenticate your requests, for example:</p>

<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/RESOURCE</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>
<br/><span>Remember to replace <code>RESOURCE</code> to request a resource that interests you.</span>

<h4>Refresh Token flow</h4>
<p>You need to refresh your access token if you receive this error message as a response to your request:</p>

<code>{"error":"invalid_token","error_description":"The client token provided has expired"}</code>

<p>If you are using the Authorization Code flow, you need to use the refresh token to issue a new access token/refresh token pair by making the following request:</p>

<code>$  curl -u CLIENT_ID:CLIENT_SECRET http://api.ifunnels.com/v1/token -d 'grant_type=refresh_token&refresh_token=REFRESH_TOKEN'</code>
<br/><span>Remember to replace <code>CLIENT_ID</code> and <code>CLIENT_SECRET</code> with your OAuth application credentials.</span>
<br/><span>Remember to replace <code>REFRESH_TOKEN</code> from authorization Code flow step.</span>

<p>The response you'll get will look like this:</p>
<code>{"access_token":"b1cfffab69cae1d6177603fb2b60ddd2a6a1b0fe","expires_in":3600,"token_type":"Bearer","scope":null,"refresh_token":"3557752bba953267dca0c767557d24dff0429fe8"}</code>

<h3>Resources</h3>
<h4>List contacts</h4>
<p>You can then use the access token to authenticate your requests, for example:</p>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/contacts</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>

<p>Answer</p>
<code>{"data":[{"id":"12345","email":"emial@email.com","ip":"122.122.122.122","name":"Name Surname","added":"1566783002","status":"risky"},...],"meta":{"count":999,"page":{"number":"1","size":"20"}}}</code>

<h4>Create new contact</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/contacts</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>
<p>You can add contacts via the <code>POST /contacts</code> method.</p>
<p>Remember that all methods accept and return JSON data only.</p>

<p>Basic JSON payload</p>
<code>{"email":"emial@email.com","name":"Name Surname"}</code>

<p>Answer</p>
<code>{"email":"emial@email.com","name":"Name Surname","id":"12345"}</code>

<h4>List email funnels</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/emailfunnels</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>

<p>Answer</p>
<code>{"data":[{"id":"1","title":"Email Funnel","description":"description","added":"1589787185","edited":"1594191434","message":[{"id":"1","name":"First Message","subject":["Welcome"],"header_title":null,"flg_period":"0","period_time":"0","flg_pause":"0","position":"1","added":"1589787185","edited":"1594191434"},{"id":"2","name":"Second Message","subject":["Hello"],"header_title":null,"flg_period":"1","period_time":"1","flg_pause":"0","position":"2","added":"1589787185","edited":"1594191434"}]}],"meta":{"count":1,"page":{"number":"1","size":"1"}}}</code>

<h4>List lead channels</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/leadchannels</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>

<p>Answer</p>
<code>{"data":[{"id":"1","name":"Funnel URL","added":"1589534533","edited":"1594822836","tags":"ifunnel, optin"}],"meta":{"count":1,"page":{"number":"1","size":"1"}}}</code>

<h4>Add someone to an email funnel</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/emailfunnels/EMAIL_FUNNEL_ID</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>
<p>You can add someone to an email funnel via the <code>PATCH /emailfunnels/EMAIL_FUNNEL_ID</code> method.</p>
<br/><span>Find the EMAIL_FUNNEL_ID through the API</span>
<br/><span>Call the <code>GET /emailfunnels</code> method.</span>
<br/><span>Find the target campaign within the JSON response.</span>
<br/><span>API-compatible campaign IDs are returned in the <code>id</code> fields.</span>
<p>Remember that all methods accept and return JSON data only.</p>

<p>Basic JSON payload</p>
<code>{"contact_id":["1","2","3","4"]}</code>

<p>Answer</p>
<code>{"success":true,"message":"You add XXX contacts to `Funnel Title` Email Funnel campaign","data":["email@test.tst","email2@test.tst"]}</code>


<h4>Add someone to a lead channel</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/leadchannels/LEAD_CHANNEL_ID</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>
<br/><span>Find the LEAD_CHANNEL_ID through the API</span>
<br/><span>Call the <code>GET /leadchannels</code> method.</span>
<br/><span>Find the target campaign within the JSON response.</span>
<p>You can someone to a lead channel via the <code>PATCH /leadchannels/LEAD_CHANNEL_ID</code> method.</p>
<br/><span>API-compatible campaign IDs are returned in the <code>id</code> fields.</span>
<p>Remember that all methods accept and return JSON data only.</p>

<p>Basic JSON payload</p>
<code>{"contact_id":["1","2","3","4"]}</code>

<p>Answer</p>
<code>{"success":true,"message":"You add XXX contacts to `Channel Title` Lead Channel","data":["email@test.tst","email2@test.tst"]}</code>

<h4>List Delivery Memberships</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/memberships</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>

<p>Answer</p>
<code>{"data":[{"id":"1","name":"Test Memberships","logo":null,"currency":"USD","added":"1595491848","edited":"1595491848"}],"meta":{"count":1,"page":{"number":1,"size":10}}}</code>


<h4>List Delivery Sales</h4>
<code>$  curl -H "Authorization: Bearer ACCESS_TOKEN" http://api.ifunnels.com/v1/sales</code>
<br/><span>Remember to replace <code>ACCESS_TOKEN</code> from client Credentials flow.</span>

<p>Answer</p>
<code>{"data":[{"id":"1","site_id":"1","plan_id":"1","customer_id":"1","type_payment":"0","one_payment_id":null,"subscription_id":null,"payment_intent":"pl_0101020394293","status":"succeeded","added":"1595434583",<br/>"membership":"Membership","customer_email":"test@ifunnels.com"}],"meta":{"count":1,"page":{"number":1,"size":10}}}</code>

	{/literal}
	</div>
	

</div>
{literal}
<script type="text/javascript">

</script>
{/literal}
{include file='../../box-bottom.tpl'}