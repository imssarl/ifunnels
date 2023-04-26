<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
    <link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
    <!--<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/steel/steel.css" />-->
    <script type="text/javascript" src="/skin/_js/jscalendar/js/jscal2.js"></script>
    <script type="text/javascript" src="/skin/_js/jscalendar/js/unicode-letter.js"></script>
    <script type="text/javascript" src="/skin/_js/jscalendar/js/lang/en.js"></script>
	{module name='site1' action='head' type='mini'}
</head>
<body>
{include file='../../error.tpl'}
{if !empty($strMsg)}
	{include file='../../message.tpl' type='info' message=$strMsg}
{/if}
<form action="" method="post">
	<fieldset>
		<p>
			<label>Your PIN-code is:</label>
			<input type="text" name="code" readonly="true" value="{Core_Users::$info['code_confirm']}" />
		</p>
</form>
<form action="" method="post">
		<p>
			<a href="?call=me" class="button" id="call_me_now">Call me now</a> <a href="#" id="schedule" class="button">Call me later</a>
		</p>
		<div id="schedule-block" style="display: none;">
			<p>
				<label>Date:</label>
				<input type="text" id="date-call-view" readonly="1" />
				<input type="hidden" name="start" id="date-call" />
				<img src="/skin/_js/jscalendar/img.gif" id="trigger-call" style="cursor:pointer;" alt="" />
			</p>
			<p>
				<input type="submit" class="button" value="Save" />
			</p>
		</div>
	</fieldset>
</form>


<script type="text/javascript">
	var start={$smarty.get.start|default:0};
	{literal}
	window.addEvent('load',function(){
		if( start==true ){
			function check(){
			new Request.JSON({
				url: "{/literal}{url name='call_service' action='ajax'}{literal}",
				onSuccess: function(r){
					if(r.result==0){
						check.delay(2000);
					} else {
						document.location.href='./?confirm=true';
						window.parent.$('verify').setStyle('display','none');
						window.parent.$('verified').setStyle('display','inline');
					}
				}
			}).post({'check':true})};
			check();
		}
		$('schedule').addEvent('click',function(e){
			e && e.stop();
			$('schedule-block').toggle();
		});
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
</body>
</html>