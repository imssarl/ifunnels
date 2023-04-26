<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
<!--<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/steel/steel.css" />-->
<script type="text/javascript" src="/skin/_js/jscalendar/js/jscal2.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/unicode-letter.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/lang/en.js"></script>
<div class="card-box">
<div class="content-box"><!-- Start Content Box -->
	<div class="content-box-header">
		<h3>Creative Niche Manager Call Service</h3>
	</div>
	<div class="content-box-content">
		<p>Here is the number to use for incoming calls and SMS messages:<br/>
		<h3>+1 415-658-6177</h3>
		</p>
		<p>
		When calling on the above number, the system will suggest you the following:<br/>
		<i>"If you want to create a site, press 1, if you would like to check your balance, press 2."</i><br/>
		Select an option, and proceed as instructed. For creating a site, you will need to select the type of site you would like created, and say the keyword to be used for your website. The rest will be handled by the system automatically.
		</p>
		<p>
		Here is what you can do through sending us an SMS message:<br/>
			<b>"credits"</b> - request your credit balance notification;<br/>
			<b>"social: http://host.com/"</b> - create a Social Bookmarking promotion campaign for 50 bookmarks for http://host.com/<br/>
			<b>"zonterest create: keyword"</b> - create a AzonFunnels site with "keyword" keyword<br/>
			<b>"zonterest create+: keyword"</b> - create a AzonFunnels site with "keyword" keyword (with Social Media campaign)<br/>
			<b>"nvsb create: keyword"</b> - create a Niche Video site with "keyword" keyword<br/>
			<b>"nvsb create+: keyword"</b> - create a Niche Video site with "keyword" keyword (with Social Media campaign)<br/>
			<b>"ncsb create: keyword"</b> - create a Niche Content site with "keyword" keyword<br/>
			<b>"ncsb create+: keyword"</b> - create a Niche Content site with "keyword" keyword (with Social Media campaign)<br/>
		</p>
		<p>
		You can also schedule an outgoing call from the Creative Niche Manager to let you create a site or learn your balance on a specified date.
		To schedule a call, go to <i>Manage Your Account -> Call Settings</i> section. Select a call topic:<br/>
		<b>Create sites</b> - lets you create a AzonFunnels, Niche Video, or Niche Content site<br/>
		<b>Learn Balance</b> - notifies you about your credit balance.<br/>
		Then, select a date and time, when the call should be made, and click <i>"Schedule new call"</i> button.
		At the specified date and time, you will receive a call from +1 415-658-6177 guiding you through the process of creating a site, or notifying you about your account balance.
		</p>
		<form action="" method="post">
			{if $msg}4
				[pi5
				{include file="../../message.tpl" type='info' message=$msg}
			{/if}
			{include file='../../error.tpl' fields=['action'=>'What you would like to do','start'=>'Date']}
		<fieldset>
			<div class="form-group">
				<label>What you would like to do: <em>*</em> </label>
				<select name="arrData[action]" class="medium-input btn-group selectpicker show-tick">
					<option value="">-select a call topic-</option>
					<option value="{Project_Ccs_Arrange::ACTION_CALL_CREATE_SITE}">Create Sites</option>
					<option value="{Project_Ccs_Arrange::ACTION_CALL_BALANCE}">Learn Balance</option>
				</select>
			</div>
			<div class="form-group">
				<label>Date: <em>*</em></label>
				<input type="text" id="date-call-view" class="form-control" readonly="1" />
				<input type="hidden" name="arrData[start]" id="date-call" />
				<img src="/skin/_js/jscalendar/img.gif" id="trigger-call" style="cursor:pointer;" alt="" />
			</div>
			<div class="form-group">
				<button type="submit" class="button btn btn-success waves-effect waves-light">Schedule new call</button>
			</div>
		</fieldset>
		</form>
		<table class="table table-striped">
			<thead>
			<tr>
				<th>Scheduled Calls</th>
				<th width="100" align="center">Status</th>
				<th width="100" align="center">Date</th>
				<th width="10%" align="center">Action</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$arrList key='k' item='i'}
			<tr{if $k%2=='0'} class="matros"{/if}>
				<td align="center">
					{if $i.action==Project_Ccs_Arrange::ACTION_CALL_CREATE_SITE}Create Sites
					{elseif $i.action==Project_Ccs_Arrange::ACTION_CALL_BALANCE}Learn Balance
					{elseif $i.action==Project_Ccs_Arrange::ACTION_CALL_CONFIRM}Confirm Phone Number
					{/if}</td>
				<td align="center">{if $i.flg_status==0}
						not started
					{elseif $i.flg_status==1}
						in progress
					{elseif $i.flg_status==2}
						completed
					{elseif $i.flg_status==3}
						error
					{/if}</td>
				<td align="center">{$i.start|date_local:$config->date_time->dt_full_format}</td>
				<td align="center">
					<a {is_acs_write} href="{url name='site1_accounts' action='calls'}?del={$i.id}" class="delete"><img title="Delete" src="/skin/i/frontends/design/newUI/icons/cross.png" /></a>
				</td>
			</tr>
			{/foreach}
			</tbody>
			<tfoot>
				<tr>
					<td colspan="12">
						{include file="../../pgg_backend.tpl"}
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>
</div>

{literal}
<script type="text/javascript">
	window.addEvent('load',function(){
		Calendar.setup({
			trigger    : "trigger-call",
			inputField : "date-call",
			dateFormat: "%s",
			showTime : true,
			disabled: function(date) {
				if (date < Date.parse(new Date())) {
					return true;
				} else {
					return false;
				}
			},
			onSelect : function() {
				var date = new Date ();
				date.parse( $( 'date-call' ).get( 'value' ) * 1000 );
				$( 'date-call-view' ).set( 'value',date.format('%d.%m.%Y %H:%M') );
				this.hide();
			}
		});
	});
</script>
{/literal}