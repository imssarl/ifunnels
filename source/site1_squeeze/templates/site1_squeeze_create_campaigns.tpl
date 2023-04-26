<div class="card-box">
<!-- color picker -->
<link rel="stylesheet" href="/skin/_js/rainbow/mooRainbow_full.css" type="text/css"
      xmlns="http://www.w3.org/1999/html"/>
<script src="/skin/_js/rainbow/mooRainbow.js" type="text/javascript"></script>
<!-- /color picker -->
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
<!--<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/steel/steel.css" />-->
<script type="text/javascript" src="/skin/_js/jscalendar/js/jscal2.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/unicode-letter.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/lang/en.js"></script>
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<script src="/skin/_js/player/swfobject.js" type="text/javascript"></script>
<script src="/skin/_js/player/nonverblaster.js" type="text/javascript"></script>
{literal}
<script type="text/javascript">
/*var objAccordion = {};
window.addEvent( 'domready', function() {
	objAccordion = new myAccordion( $( 'accordion' ), $$( '.toggler' ), $$( '.element' ), { fixedHeight:false } );
});*/
</script>
{/literal}
{if count($arrErr) > 0}
	{foreach from=$arrErr item=err key=val}{include file="../../message.tpl" type='error' message="Error in $val"}{/foreach}
{/if}
{include file='../../error.tpl'}
<form action="" method="post" class="wh validate" id="newcompany" >
	{if !empty($arrCom.id)}
	<input type="hidden" value="{$arrCom.id}" name="arrCom[id]"/>
	{/if}
	<div class="panel-group" id="accordion-test-2"> 
        <div class="panel panel-default"> 
            <div class="panel-heading"> 
                <h4 class="panel-title"> 
                    <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">
                        Campaign default settings
                    </a> 
                </h4> 
            </div> 
            <div id="collapseOne-2" class="panel-collapse collapse in"> 
                <div class="panel-body">
                    <fieldset>
						<div class="form-group">
							<label class="label-control">Campaign Name: <em>*</em></label>
							<input type="text" id="campaign_title" value="{$arrCom.title}" name="arrCom[title]" class="required form-control"/>
						</div>
						<div class="form-group">
							<label>Start Date: <em>*</em></label>
								<input type="text" readonly="readonly" value="{if $arrCom.start_date}{$arrCom.start_date|date_format:$config->date_time->dt_full_format}{/if}" id="view-date-start"  class="required  text-input small-input"/>
								<input type="hidden" name="arrCom[start_date]"  value="{if !empty($arrCom.start_date)}{$arrCom.start_date}{/if}" id="date-start"/>
								<img src="/skin/_js/jscalendar/img.gif" id="trigger-start" style="{if $arrCom.flg_status == 3}display:none;{/if}cursor:pointer;" alt="" />
						</div>
						<div class="form-group">
							<label>End Date: <em>*</em></label>
								<input type="text" readonly="readonly" value="{if $arrCom.end_date}{$arrCom.end_date|date_format:$config->date_time->dt_full_format}{/if}" id="view-date-end" class="required  text-input small-input" />
								<input type="hidden" name="arrCom[end_date]"  value="{if !empty($arrCom.end_date)}{$arrCom.end_date}{/if}" id="date-end" class="required"/>
								<img src="/skin/_js/jscalendar/img.gif" id="trigger-end" style="{if $arrCom.flg_status == 3}display:none;{/if}cursor:pointer;" alt="" />
						</div>
						<div class="form-group">
							<label class="label-control">Ad Type: <em>*</em></label>
							<input type="hidden" name="arrCom[flg_posc]" value="0" />
							<div class="checkbox checkbox-primary">
								<input type="checkbox" name="arrCom[flg_posc]" id="flg_posc" {if $arrCom.flg_posc == 1 || $arrCom.id == null }checked="checked"{/if} value="1"/>
								<label>Corner Ads</label>	
							</div>
							<input type="hidden" name="arrCom[flg_poss]" value="0" />
							<div class="checkbox checkbox-primary">
								<input type="checkbox" name="arrCom[flg_poss]" id="flg_poss" {if $arrCom.flg_poss == 1}checked="checked"{/if} value="1" />
								<label>Slide In</label>	
							</div>
							<input type="hidden" name="arrCom[flg_posf]" value="0" />
							<div class="checkbox checkbox-primary">
								<input type="checkbox" name="arrCom[flg_posf]" class="validate-one-required" id="flg_posf" {if $arrCom.flg_posf == 1}checked="checked"{/if} value="1" />
								<label>Fix Position Ads</label>	
							</div>
						</div>
						<div class="form-group">
							<label>Action: <em>*</em></label>
							<div class="radio radio-primary">
								<input type="radio" id="action_on_load" name="arrCom[flg_action]" {if empty($arrCom.flg_action) || $arrCom.flg_action == '0'}checked="checked"{/if} value="0"/>
								<label>On Load</label>	
							</div>
							<div class="radio radio-primary">
								<input type="radio" id="action_on_leave" name="arrCom[flg_action]" class="validate-one-required" {if $arrCom.flg_action == '1'}checked="checked"{/if} value="1"/>
								<label>When User Leaves the Page (traffic regeneration)</label>	
							</div>
						</div>
						<div class="form-group">
							<label class="label-control">Url:</label>
							<input type="text" value="{$arrCom.url}" name="arrCom[url]" alt="Writing Url." class=" form-control" />
						</div>
						<div class="form-group">
							<label class="label-control">Open Url in: </label>
							<div class="radio radio-primary">
								<input type="radio" id="open_url_new" name="arrCom[flg_window]" {if empty($arrCom.flg_window) || $arrCom.flg_window == '0'}checked="checked"{/if} value="0"/>
								<label>New Window</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" id="open_url_same" name="arrCom[flg_window]" class="validate-one-required" {if $arrCom.flg_window == '1'}checked="checked"{/if} value="1"/>
								<label>Same Window</label>
							</div>
						</div>
						<div class="form-group">
							<label class="label-control">Display Mode? </label>
							<div class="radio radio-primary">
								<input type="radio" id="display_always" name="arrCom[flg_display]" {if empty($arrCom.flg_display) || $arrCom.flg_display == '0'}checked="checked"{/if} value="0"/>
								<label>Always</label>
							</div>
							<div class="radio radio-primary">
								<input type="radio" id="display_once" name="arrCom[flg_display]" {if $arrCom.flg_display == '1'}checked="checked"{/if} value="1"/>	
								<label>Once Per Session</label>
							</div>
						</div>
						<div class="form-group">
							<label class="label-control">Delay (seconds): </label>
							<input type="text" name="arrCom[delay]" class="form-control" value="{$arrCom.delay|default:0}" />
						</div>
						<div class="form-group">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" name="arrCom[flg_reset]" {if $arrCom.flg_reset == 1}checked="checked"{/if} value="1" />	
								<label >Reset CSS styles</label>
							</div>
						</div>
					</fieldset>                
				</div> 
            </div> 
        </div>
        <div class="panel panel-default"> 
            <div class="panel-heading"> 
                <h4 class="panel-title"> 
                    <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" class="collapsed" aria-expanded="false">
                        Ads Settings
                    </a> 
                </h4> 
            </div> 
            <div id="collapseTwo-2" class="panel-collapse collapse"> 
                <div class="panel-body">
                    <fieldset>
						<div class="flg_posc" {if $arrCom.flg_posc!=1&&$arrCom.id!= null }style="display:none"{/if}>
							<div>
								<label class="label-control">Corner Ads Image: </label>
								<div id="file_corner_image">
									{if !empty($arrCom.file_corner)}{module name='files' action='view_file' file_id=$arrCom.file_corner prefix="Hiam"}{/if}
								</div>
								<p>&nbsp;Select&nbsp;
								<a rel="" href="{url name='site1_hiam' action='hiam_default_corners'}" title="Select Default Corner Image" class="popup_mb">Default</a>&nbsp;or&nbsp;<a rel="" href="{url name='site1_hiam' action='hiam_user_corners'}" title="Select User Corner Image" class="popup_mb">User</a>&nbsp;corners</p>
								<input type="text" id="file_corner" value="{$arrCom.file_corner}" name="arrCom[file_corner]" style="display:none;"/>
							</div>
							<div class="form-group">
								<label class="label-control">Select Corner Position:</label>
								<div class="radio radio-primary">
									<input type="radio" id="corn_img_tleft" name="arrCom[flg_corner_position]" {if $arrCom.flg_corner_position == '1'}checked="checked"{/if} value="1"/>
									<label>Top Left</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="corn_img_tright" name="arrCom[flg_corner_position]" {if $arrCom.flg_corner_position == '2'}checked="checked"{/if} value="2"/>
									<label>Top Right</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="corn_img_bleft" name="arrCom[flg_corner_position]" {if $arrCom.flg_corner_position == '3'}checked="checked"{/if} value="3"/>
									<label>Bottom Left</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="corn_img_bright" name="arrCom[flg_corner_position]" {if $arrCom.flg_corner_position == '4'}checked="checked"{/if} value="4" class="validate-one-required"/>
									<label>Bottom Right</label>
								</div>
							</div>
							<div class="form-group">
								<label>Play Sound? </label>
								<div class="radio radio-primary">
									<input type="radio" id="no_sound" name="arrCom[flg_sound]" {if $arrCom.flg_sound == '0' || !isset($arrCom.flg_sound)}checked="checked"{/if} value="0" class="flg_sound"/>
									<label>No</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="get_sound" name="arrCom[flg_sound]" {if $arrCom.flg_sound == '1'}checked="checked"{/if} value="1" class="flg_sound"/>
									<label>Yes</label>
								</div>
							</div>
							<div {if $arrCom.flg_sound != '1'}style="display:none;"{/if} class="flg_sound">
								<label>Sound File: </label>
								<div id="file_sound_image">
									{if !empty($arrCom.file_sound)}{module name='files' action='view_file' file_id=$arrCom.file_sound prefix="Hiam" }{/if}
								</div>
								<p>&nbsp;Select&nbsp;
								<a rel="" href="{url name='site1_hiam' action='hiam_default_sounds'}" title="Select Default Sound" class="popup_mb">Default</a>&nbsp;or&nbsp;<a rel="" href="{url name='site1_hiam' action='hiam_user_sounds'}" title="Select User Sound" class="popup_mb">User</a>&nbsp;sounds</p>
								<input type="text" id="file_sound" value="{$arrCom.file_sound}" name="arrCom[file_sound]" style="display:none;"/>
							</div>
						</div>
						<div class="flg_poss" {if $arrCom.flg_poss != 1}style="display:none"{/if}>
							<div class="form-group">
								<label>Slide In Content Type: <em>*</em></label>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_slide_content_type]" id="slide_text" {if $arrCom.flg_slide_content_type == '0'}checked="checked"{/if} value="0"/>
									<label>Text</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_slide_content_type]" class="validate-one-required" id="slide_html" {if $arrCom.flg_slide_content_type == '1'}checked="checked"{/if} value="1" class="validate-one-required"/>
									<label>Html</label>
								</div>
							</div>
							<div>
								<div id="content_slide_text_div"{if $arrCom.flg_slide_content_type!='0'} style="display:none"{/if}>
									<textarea id="content_slide_text"{if $arrCom.flg_slide_content_type=='0'} name="arrCom[content_slide]"{/if} rows="13" style=" width:99%">{if $arrCom.flg_slide_content_type=='0'}{$arrCom.content_slide}{/if}</textarea>
								</div>
								<div id="content_slide_div"{if $arrCom.flg_slide_content_type!='1'} style="display:none"{/if}>
									<textarea id="content_slide"{if $arrCom.flg_slide_content_type=='1'} name="arrCom[content_slide]"{/if} rows="13" style="width:99%">{if $arrCom.flg_slide_content_type=='1'}{$arrCom.content_slide}{/if}</textarea>
								</div>
							</div>
							<div class="form-group">
								<label>Slide in Position: </label>
								<div class="radio radio-primary">
									<input type="radio" id="slide_position_default" name="arrCom[flg_slide_pos]" {if $arrCom.flg_slide_pos == '0' || !isset($arrCom.flg_slide_pos)}checked="checked"{/if} value="0"/>
									<label>Default</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="slide_position" name="arrCom[flg_slide_pos]" {if $arrCom.flg_slide_pos == '1'}checked="checked"{/if} value="1"/>
									<label>User Defined</label>
								</div>
								<input type="text" id="slide_pos" value="{$arrCom.slide_pos}" name="arrCom[slide_pos]" class="form-control" style="width:100px;" />Pixels
							</div>
							<div class="form-group">
								<input type="hidden" name="arrCom[flg_lightbox]" value="0" />
								<div class="checkbox checkbox-primary">
									<input id='lightbox' type="checkbox" value="1" {if $arrCom.flg_lightbox == '1'}checked="checked"{/if}  name="arrCom[flg_lightbox]" />
									<label>Lightbox effect</label>
								</div>
							</div>
							<div id="lightbox-effect" style="display:{if $arrCom.flg_lightbox == '1'}block{else}none{/if};">
								<label>Close instruction text: </label><input type="text" class="form-control" name="arrCom[close_text]" id="close_text" value="{$arrCom.close_text}" />
							</div>
							<div class="form-group">
								<label>Closing text color: </label>
								<input id="close_color" type="text" class="text-input small-input" value="{if empty($arrCom.close_color)}#000000{else}{$arrCom.close_color}{/if}" name="arrCom[close_color]" />
								<span id="close_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							</div>
						</div>
						<div class="flg_posf" {if $arrCom.flg_posf != 1}style="display:none"{/if}>
							<div class="form-group">
								<label>Fix Position Content Type: <em>*</em></label>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_fix_content_type]" id="fix_text" {if $arrCom.flg_fix_content_type == '0'}checked="checked"{/if} value="0"/>
									<label>Text</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_fix_content_type]" class="validate-one-required" id="fix_html" {if $arrCom.flg_fix_content_type == '1'}checked="checked"{/if} value="1" class="validate-one-required"/>
									<label>Html</label>
								</div>
							</div>
							<div>
								<div id="content_fix_text_div"{if $arrCom.flg_fix_content_type!='0'} style="display:none"{/if}>
									<textarea id="content_fix_text"{if $arrCom.flg_fix_content_type=='0'} name="arrCom[content_fix]"{/if} rows="13" style=" width:99%">{if $arrCom.flg_fix_content_type=='0'}{$arrCom.content_fix}{/if}</textarea>
								</div>
								<div id="content_fix_div"{if $arrCom.flg_fix_content_type!='1'} style="display:none"{/if}>
									<textarea id="content_fix"{if $arrCom.flg_fix_content_type=='1'} name="arrCom[content_fix]"{/if} rows="13" style="width:99%">{if $arrCom.flg_fix_content_type=='1'}{$arrCom.content_fix}{/if}</textarea>
								</div>
							</div>
							<div class="form-group">
								<label>Select Fixed Position: </label>
								<div class="radio radio-primary">
									<input type="radio" id="flg_fix_position_top" name="arrCom[flg_fix_position]" {if $arrCom.flg_fix_position == '1'||!isset($arrCom.flg_fix_position)}checked="checked"{/if} value="1"/>
									<label>Top</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="flg_fix_position_bottom" name="arrCom[flg_fix_position]" {if $arrCom.flg_fix_position == '2'}checked="checked"{/if} value="2"/>
									<label>Bottom</label>
								</div>
							</div>
							<div class="form-group">
								<label>Floating Effect: </label>
								<div class="radio radio-primary">
									<input type="radio" id="flg_floating_eff_yes" name="arrCom[flg_floating_eff]" {if $arrCom.flg_floating_eff == '0'}checked="checked"{/if} value="0"/>
									<label>Yes</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="flg_floating_eff_no" name="arrCom[flg_floating_eff]" {if $arrCom.flg_floating_eff == '1'||!isset($arrCom.flg_floating_eff)}checked="checked"{/if} value="1" />
									<label>No</label>
								</div>
							</p>
						</div>
						<div class="flg_posfs" {if $arrCom.flg_posf != 1 && $arrCom.flg_poss != 1}style="display:none"{/if}>
							<div class="form-group">
								<label>Height: </label>
								<div class="radio radio-primary">
									<input type="radio" id="flg_height_auto" name="arrCom[flg_height]" {if $arrCom.flg_height == '0'||!isset($arrCom.flg_height)}checked="checked"{/if} value="0" class="flg_height"/>
									<label>Auto</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="flg_height_defined" name="arrCom[flg_height]" {if $arrCom.flg_height == '1'}checked="checked"{/if} value="1" class="flg_height"/>
									<label>User Defined</label>
								</div>
								<input type="text" id="height" value="{$arrCom.height}" name="arrCom[height]" style="width:100px;"/>Pixels
							</div>
							<div class="form-group">
								<label>Width: </label>
								<div class="radio radio-primary">
									<input type="radio" id="flg_width_auto" name="arrCom[flg_width]" {if $arrCom.flg_width == '0'||!isset($arrCom.flg_width)}checked="checked"{/if} value="0" class="flg_width"/>
									<label>Auto</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" id="flg_width_defined" name="arrCom[flg_width]" {if $arrCom.flg_width == '1'}checked="checked"{/if} value="1" class="flg_width"/>
									<label>User Defined</label>
								</div>
								<input type="text" id="width" value="{$arrCom.width}" name="arrCom[width]" style="width:100px;"/>Pixels
							</div>
							<div class="form-group">
								<label>Background Color:</label>
								<input type="text" id="background_color" class="text-input small-input" value="{if empty($arrCom.background_color)}#ffffff{else}{$arrCom.background_color}{/if}" name="arrCom[background_color]" />
								<span id="background_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							</div>
							<div>
								<label>Border Style:</label>
								<select name="arrCom[flg_border_style]" class="required validate-custom-required btn-group selectpicker show-tick">
									<option value="1"{if $arrCom.flg_border_style=='1'} selected="selected"{/if}>None</option>
									<option value="2"{if $arrCom.flg_border_style=='2'} selected="selected"{/if}>Dotted</option>
									<option value="3"{if $arrCom.flg_border_style=='3'} selected="selected"{/if}>Dashed</option>
									<option value="4"{if $arrCom.flg_border_style=='4'} selected="selected"{/if}>Solid</option>
									<option value="5"{if $arrCom.flg_border_style=='5'} selected="selected"{/if}>Double</option>
									<option value="6"{if $arrCom.flg_border_style=='6'} selected="selected"{/if}>Groove</option>
									<option value="7"{if $arrCom.flg_border_style=='7'} selected="selected"{/if}>Ridge</option>
									<option value="8"{if $arrCom.flg_border_style=='8'} selected="selected"{/if}>Inset</option>
									<option value="9"{if $arrCom.flg_border_style=='9'} selected="selected"{/if}>Outset</option>
								</select>
							</div>
							<div class="form-group">
								<label>Border Width:</label>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_border_width]" id="flg_border_width_thin" {if $arrCom.flg_border_width == '1'}checked="checked"{/if} value="1" class="flg_border_width"/>
									<label>Thin</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_border_width]" id="flg_border_width_medium" {if $arrCom.flg_border_width == '2'}checked="checked"{/if} value="2" class="flg_border_width"/>
									<label>Medium</label>
								</div>
								<div class="radio radio-primary">
									<input type="radio" name="arrCom[flg_border_width]" id="flg_border_width_thick" {if $arrCom.flg_border_width == '3'}checked="checked"{/if} value="3" class="flg_border_width"/>
									<label>Thick</label>
								</div>
							</div>
							<div class="form-group">
								<label>Border Color:</label>
								<input type="text" id="border_color" class="text-input small-input" value="{if empty($arrCom.border_color)}#ffffff{else}{$arrCom.border_color}{/if}" name="arrCom[border_color]" />
								<span id="border_color_span">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							</div>
							<div>
								<label>Set Background Image: </label>
								<div id="file_background_image">
									{if !empty($arrCom.file_background)}{module name='files' action='view_file' file_id=$arrCom.file_background prefix="Hiam"}{/if}
								</div>
								<p>&nbsp;Select&nbsp;
								<a rel="" href="{url name='site1_hiam' action='hiam_default_backgrounds'}" title="Select Default Background Image" class="popup_mb">Default</a>&nbsp;or&nbsp;<a rel="" href="{url name='site1_hiam' action='hiam_user_backgrounds'}" title="Select User Background Image" class="popup_mb">User</a>&nbsp;images</p>
								<input type="text" id="file_background" value="{$arrCom.file_background}" name="arrCom[file_background]" style="display:none;"/>
							</div>
						</div>
					</fieldset>
                </div> 
            </div> 
        </div> 
    </div>
    <div class="form-group">
		<button type="submit" class="btn btn-success waves-effect waves-light" {is_acs_write}>{if $arrCom.id}Save{else}Add{/if} campaign"</button>
	</div>
</form>
</div>
{include file='../../box-bottom.tpl'}

<script src="/skin/_js/player/adapter.js" type="text/javascript"></script>
<script type="text/javascript">{literal}
/*var myAccordion = new Class({
	Extends: Fx.Accordion,
	initialize: function( completedntainer, toggler, element, options ){
		this.form = completedntainer.getParent( 'form' );
		this.parent( completedntainer, toggler, element, options );
		this.initButton();
	},
	initButton:function(){
		this.prev = $$( 'a.acc_prev' );
		this.next = $$( 'a.acc_next' );
		this.prev.each( function( el ){
			el.addEvent( 'click',function( e ){e.stop(); this.display( this.previous-1 );  } );
		},this );
		this.next.each( function( el ){
			el.addEvent( 'click',function( e ){e.stop(); this.display( this.previous+1 );  } );
		},this );
		this.displayForm.delay(1000);
	},
	displayForm: function() {
		$( 'newcompany' ).fade( 1 );
	}
});*/
var multibox;
var createrClass = new Class({
	initialize: function(){
		var myColor = new Color( $('close_color').value!=' '?$('close_color').value:'#000' );
		new MooRainbow('close_color', {
			id: 'close_color_id',
			imgPath: '/skin/_js/rainbow/',
			'startColor': myColor.rgb,
			onChange: function(color) {
				$('close_color_span').setStyle('background-color', color.hex);
				this.element.value = color.hex;
			}
		});
		myColor = new Color( $('background_color').value!=' '?$('background_color').value:'#000' );
		new MooRainbow('background_color', {
			id: 'background_color_id',
			imgPath: '/skin/_js/rainbow/',
			'startColor': myColor.rgb,
			onChange: function(color) {
				$('background_color_span').setStyle('background-color', color.hex);
				this.element.value = color.hex;
			}
		});
		myColor = new Color( $('border_color').value!=' '?$('border_color').value:'#000' );
		new MooRainbow('border_color', {
			id: 'border_color_id',
			imgPath: '/skin/_js/rainbow/',
			'startColor': myColor.rgb,
			onChange: function(color) {
				$('border_color_span').setStyle('background-color', color.hex);
				this.element.value = color.hex;
			}
		});
		multibox=new CeraBox( $$('.popup_mb'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width|default:80}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height|default:80}{literal}%',
				displayTitle: true,
			titleFormat: '{title}'
		});
		$('height').addEvent('click', function(){
			$('flg_height_defined').checked = true;
		});
		$('width').addEvent('click', function(){
			$('flg_width_defined').checked = true;
		});
		$('slide_pos').addEvent('click', function(){
			$('slide_position').checked = true;
		});
		$('lightbox').addEvent('click',function(){
			$('lightbox-effect').setStyle('display',(this.checked)?'block':'none');
			if( !this.checked ){
				$('close_text').set('value','Close');
			}
		});
		this.init_acordion_pages('flg_posc');
		this.init_acordion_pages('flg_poss','flg_posf');
		this.init_acordion_pages('flg_posf','flg_poss');
		CKEDITOR.replace( 'content_slide', {
			toolbar: 'Default'
		});
		CKEDITOR.replace( 'content_fix', {
			toolbar: 'Default'
		});
		$('fix_text').addEvent ( 'click', function () {
			this.show_hide_opt ( 'content_fix','content_fix', 'content_fix_text', 'content_fix_text_div', 'content_fix_div' );
		}.bind(this));
		$('fix_html').addEvent ( 'click', function () {
			this.show_hide_opt ( 'content_fix','content_fix_text', 'content_fix', 'content_fix_div', 'content_fix_text_div' );
		}.bind(this));
		$('slide_text').addEvent ( 'click', function () {
			this.show_hide_opt ( 'content_slide','content_slide', 'content_slide_text', 'content_slide_text_div', 'content_slide_div' );
			//поле урл обязательное
		}.bind(this));
		$('slide_html').addEvent ( 'click', function () {
			this.show_hide_opt ( 'content_slide','content_slide_text', 'content_slide', 'content_slide_div', 'content_slide_text_div' );
			//поле урл необязательное
		}.bind(this));
		$$('input.flg_sound').addEvent ( 'click', function () {
			if ( $(this).get('value') == '1' ) {
				$$('div.flg_sound').setStyle('display','');
			} else {
				$$('div.flg_sound').setStyle('display','none');
			}
		});
		var end_calendar = Calendar.setup({
			trigger: "trigger-end",
			inputField : "date-end",
			dateFormat: "%s",
			showTime : true,
			disabled: function(date) {
				if (date.clearTime() < Date.parse(new Date().clearTime())) {
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
			trigger: "trigger-start",
			inputField : "date-start",
			dateFormat: "%s",
			showTime : true,
			selection : Date.parse(new Date()),
			disabled: function(date) {
				if (date.clearTime() < Date.parse(new Date().clearTime())) {
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
	},
	show_hide_opt: function ( name, hide_name, set_name, show_item, hide_item ) {
		$(hide_name).erase('name');
		$(set_name).set({'name':'arrCom['+name+']'});
		$(show_item).setStyle('display','');
		$(hide_item).setStyle('display','none');
	},
	init_acordion_pages: function ( name, othername ) {
		$(name).addEvent ( 'click', function () {
			if ( $(this).checked ) {
				$$('div.'+name).setStyle('display','');
				if ( othername!=null ) {
					$$('div.flg_posfs').setStyle('display','');
				}
			} else {
				$$('div.'+name).setStyle('display','none');
				if ( othername!=null && !$(othername).checked ) {
					$$('div.flg_posfs').setStyle('display','none');
				}
			}
		});
	}
});
window.addEvent('domready', function() {
new createrClass();
});
{/literal}</script>
