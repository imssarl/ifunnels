{if $flgWait==1}<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
	<script type="text/javascript" src="/skin/_js/ui.js"></script>
	<script src="/skin/light/js/bootstrap.min.js"></script>
	<script src="/skin/light/js/detect.js"></script>
	<script src="/skin/light/js/fastclick.js"></script>
	<script src="/skin/light/js/jquery.slimscroll.js"></script>
	<script src="/skin/light/js/jquery.blockUI.js"></script>
	<script src="/skin/light/js/waves.js"></script>
	<script src="/skin/light/js/wow.min.js"></script>
	<script src="/skin/light/js/jquery.nicescroll.js"></script>
	<script src="/skin/light/js/jquery.scrollTo.min.js"></script>
	<script src="/skin/light/plugins/peity/jquery.peity.min.js"></script>
	<!-- jQuery  -->
	<script src="/skin/light/plugins/waypoints/lib/jquery.waypoints.js"></script>
	<script src="/skin/light/plugins/counterup/jquery.counterup.min.js"></script>
	<script src="/skin/light/plugins/jquery-knob/jquery.knob.js"></script>
	<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
	<script src="/skin/light/js/jquery.core.js"></script>
	<script src="/skin/light/js/jquery.app.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
	<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
	<!--<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/steel/steel.css" />-->
	<script type="text/javascript" src="/skin/_js/jscalendar/js/jscal2.js"></script>
	<script type="text/javascript" src="/skin/_js/jscalendar/js/unicode-letter.js"></script>
	<script type="text/javascript" src="/skin/_js/jscalendar/js/lang/en.js"></script>
</head>
<body>
	<div class="card-box">
		<div class="form-group">
			<div id="loading">We're gathering your statistics. It might take some time, so please be patient</div>
{else}
			<div id="resend" style="display:none;">
				<form method="post" action="">
					<input type="hidden" name="action" value="resend_message" />
					<input type="hidden" name="arrData[timezone]" value="0" />
					<input type="hidden" name="arrData[id]" value="" id="message_id" />
					<div class="form-group pull-left m-r-10">
						<select class="btn-group selectpicker show-tick hidden" name="arrData[select]">
							<option value="all">All</option>
							<option value="open">Openers</option>
							<option value="nonopen">Non Openers</option>
							<option value="click">Clickers</option>
						</select>
					</div>
					<div class="form-group pull-left m-r-10">
						<select class="btn-group selectpicker show-tick hidden" name="arrData[send]">
							<option value="now">Send now</option>
							<option value="later">Later date</option>
						</select>
					</div>
					<div class="form-group pull-left change_date" style="padding-right: 5px; position: relative;display:none;">
						<input type="text" value="{$smarty.now|date_format:$config->date_time->dt_full_format}" id="view-date-start" class="not_started completed meio medium-input text-input form-control" data-meiomask="fixed.DateTime"    />
						<input type="hidden" name="arrData[start_time]" value="{$smarty.now}" id="date-start" />
						<img src="/skin/_js/jscalendar/img.gif" id="trigger-start" style="cursor: pointer; position: absolute; right: 12px; top: 12px;" alt="" />
					</div>
					<div class="form-group">
						<input type="submit" class="btn btn-success waves-effect waves-light" value="Resend" />
					</div>
				</form>
			</div>
			<table class="table">
				<thead>
					<tr>
						<th>Title</th>
						<th>Number of Subscribers</th>
						<th>Number of Subjects</th>
						<th class="text-center">Delivered</th>
						<th class="text-center">Bounced</th>
						<th class="text-center">Reported Spam</th>
						<th class="text-center">Opened</th>
						<th class="text-center">Clicked</th>
						<th class="text-center">Option</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$arrData.message item=v}
					<tr data-type="{$v.type}">
						<td>{$v.name}</td>
						<td>{$subscribersCount}</td>
						<th><a href="#" rel="{$v.id}" class="open_subjects">{count( $v.subject )}</a></th>
						<td align="center">{$v.delivered}</td>
						<td align="center">{$v.bounced}</td>
						<td align="center">{$v.spam}</td>
						<td align="center">{$v.opened}</td>
						<td align="center">{$v.clicked}</td>
						<td align="center">
							<a href="{url name='email_funnels' action='popup_messages'}?id={$smarty.get.id}&message_id={$v.id}&flg_pause={if $v.flg_pause == 0}1{else}0{/if}"><i class="{if $v.flg_pause == 0}ion-pause{else}ion-play{/if}" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
							<a href="#" class="message_resend" rel="{$v.id}"><i class="ion-arrow-return-left" style="font-size: 20px; vertical-align: bottom; color: #001111; margin: 0 5px;"></i></a>
						</td>
					</tr>
					{foreach from=$v.subject item=s}
					<tr data-type="{$v.type}" class="subjects_{$v.id}" style="display:none;">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td colspan="4">{$s.name}</td>
						<td align="center">{$s.open}</td>
						<td align="center">&nbsp;</td>
						<td align="center">&nbsp;</td>
					</tr>
					{/foreach}
					{/foreach}
				</tbody>
			</table>
			

{/if}{if $flgWait==1}
		</div>
	</div>
	{literal}
	<script type="text/javascript">
	jQuery.ajax({
		type: "GET",
		url: '',
		data: '{/literal}{$strGet}{literal}',
		success: function(data){
			jQuery("#loading").hide();
			jQuery("#loading").before(data);
			jQuery('.open_subjects').click(function(e){
				e||e.stop();
				jQuery( '.subjects_'+jQuery(this).prop('rel')).show();
			});
			jQuery('.message_resend').click( function(e){
				e||e.stop();
				jQuery("#resend").show();
				jQuery('#message_id').attr( 'value', jQuery(this).prop('rel') );
				jQuery('.selectpicker').selectpicker('refresh');
				var offset = new Date().getTimezoneOffset();
				jQuery( '[name="arrData[timezone]"]' ).prop( 'value', offset*60 )
				var start_calendar = Calendar.setup({
					trigger : "trigger-start",
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
			});
			jQuery( '[name="arrData[send]"]' ).on( 'change', function(){
				if( jQuery( this ).prop( 'value' ) == '0' ){
					jQuery('.change_date' ).hide();
				} else {
					jQuery('.change_date' ).show();		
				}
			});
			
			
		},
		error: function(data){
			jQuery("#loading").html('Error: '+data);
		}
	});
	</script>
	{/literal}
</body>
</html>
{/if}