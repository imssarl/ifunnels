	<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
    <link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
    <!--<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/steel/steel.css" />-->
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
<div class="panel panel-default"> 
    <div class="panel-heading"> 
        <h4 class="panel-title"> 
            <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFour-2" aria-expanded="false" class="collapsed">
               Scheduling
            </a> 
        </h4> 
    </div>
     <div id="collapseFour-2" class="panel-collapse collapse"> 
        <div class="panel-body">
        	<fieldset>
				<div class="form-group contents_manual" {if $arrPrj.flg_mode == '0'||empty($arrPrj.flg_mode)}style="display:none;"{/if}>
					<div class="checkbox checkbox-primary">
						<input type="checkbox" name="arrPrj[flg_run]" value="1" id="all-at-once" {if $arrPrj.flg_run =='1'}checked="checked"{/if} class="not_started in_progress cross_linking completed"/>
						<label>All at once</label>
					</div>
				</div>

				<div {if $arrPrj.flg_run =='1'} style="display: none;" {/if} id="all-at-once-block">
					<div class="contents_automat" {if $arrPrj.flg_mode == '1'}style="display:none;"{/if}>
						<div class="form-group">
							<label>Define the frequency of posting new content, in days ( Y ): <em>*</em></label>
							<input value="{$arrPrj.post_every}" id="automat_post_content" type="text" name="arrPrj[post_every]" class="medium-input text-input required not_started in_progress cross_linking completed form-control" />
						</div>
						<div class="form-group">
							<label>How many posts should be added during the above period ( X ). So, X posts will be added every Y days: <em>*</em></label>
							<input value="{$arrPrj.post_num}" id="automat_post_number" type="text" name="arrPrj[post_num]" class="required not_started in_progress cross_linking completed  medium-input text-input form-control" />
						</div>
					</div>
					<div class="contents_manual" {if $arrPrj.flg_mode == '0'||empty($arrPrj.flg_mode)}style="display:none;"{/if}>
						<div class="form-group">
							<label>Time in between each posts (in minutes): </label>
							<input value="{$arrPrj.time_between}" type="text" name="arrPrj[time_between]" class="not_started in_progress cross_linking completed  medium-input text-input form-control" />
						</div>
						<div class="form-group">
							<label>Random factor (in minutes): </label>
							<input value="{$arrPrj.random}" type="text" name="arrPrj[random]" class="not_started in_progress cross_linking completed  medium-input text-input form-control" />
						</div>
					</div>
					<div class="form-group">
						<label>Start Date: </label>
						<input type="text" value="{if $arrPrj.start}{$arrPrj.start|date_format:$config->date_time->dt_full_format}{else}{$smarty.now|date_format:$config->date_time->dt_full_format}{/if}" id="view-date-start" class="not_started completed meio medium-input text-input" data-meiomask="fixed.DateTime"    />
						<input type="hidden" name="arrPrj[start]"  value="{if !empty($arrPrj.start)}{$arrPrj.start}{else}{$smarty.now}{/if}" id="date-start" />
						<img src="/skin/_js/jscalendar/img.gif" id="trigger-start" style="{if $arrPrj.flg_status == 3}display:none;{/if}cursor:pointer;" alt="" />
					</div>
					<div class="form-group">
						<label>End Date: </label>
						<input type="text" value="{if $arrPrj.end}{$arrPrj.end|date_format:$config->date_time->dt_full_format}{/if}" id="view-date-end" class=" medium-input text-input not_started completed meio" data-meiomask="fixed.DateTime" />
						<input type="hidden" name="arrPrj[end]"  value="{if !$arrPrj.end}{$smarty.now}{else}{$arrPrj.end}{/if}" id="date-end" />
						<img src="/skin/_js/jscalendar/img.gif" id="trigger-end" style="{if $arrPrj.flg_status == 3}display:none;{/if}cursor:pointer;" alt="" />
					</div>
				</div>
				<p style="display: none;">
					<a href="#" class="acc_prev button">Prev&nbsp;step</a>&nbsp;{if !Core_Acs::haveAccess( 'Zonterest PRO' )} <a href="#" class="acc_next button nonet"{if $arrPrj.flg_mode == '0'} style="display:none;"{/if}>Next&nbsp;step</a>{/if}
				</p>
			</fieldset>
        </div>
    </div>
</div>
{literal}
 <script type="text/javascript">
window.addEvent('domready',function(){
	$$('.meio').each(function(input){
		input.meiomask(input.get('data-meiomask'));
	});
});
var QuarterPage = new Class( {
	initialize: function () {
		$('all-at-once').addEvent('click',function(e){
			$('all-at-once-block').setStyle('display',($('all-at-once').checked)?'none':'block');
		});
		var end_calendar = Calendar.setup({
			trigger    : "trigger-end",
			inputField : "date-end",
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
				date.parse( $( 'date-end' ).get( 'value' ) * 1000 );
				$( 'view-date-end' ).set( 'value',date.format('%d.%m.%Y %H:%M') );
				this.hide();
			}
		});

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
				var newdate = Calendar.intToDate(this.selection.get());
				end_calendar.args.min = newdate;
				end_calendar.args.selection = newdate;
				end_calendar.redraw();
				this.hide();
			}
		});
	}
});

jQuery( document ).ready( function(){
	jQuery( '#submit_form' ).submit( function(){
		var flg_submit = true;
		if( ( jQuery( '#automat_post_content').prop( 'value' ) == '' 
			|| jQuery( '#automat_post_content').prop( 'value' ) == 0 
			|| jQuery( '#automat_post_number').prop( 'value' ) == '' 
			|| jQuery( '#automat_post_number').prop( 'value' ) == 0
		) || jQuery( '#all-at-once')[0].checked != true ){
			flg_submit = false;
		}
		return flg_submit;
	} );
} );
</script>

{/literal}