<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/border-radius.css" />
<!--<link rel="stylesheet" type="text/css" href="/skin/_js/jscalendar/css/steel/steel.css" />-->
<script type="text/javascript" src="/skin/_js/jscalendar/js/jscal2.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/unicode-letter.js"></script>
<script type="text/javascript" src="/skin/_js/jscalendar/js/lang/en.js"></script>
{include file='../../error.tpl' fields=['title'=>'Title','body'=>'Body','start'=>'Start','end'=>'End']}
<form action="" class="wh validate" method="post">
	<input type="hidden" name="arrData[id]" value="{$arrData.id}">
	<fieldset>
		<ol>
			<li>
				<label>Title:<em>*</em></label>
				<input type="text" name="arrData[title]" value="{$arrData.title}" class="required" />
			</li>
			<li>
				<label>Body:<em>*</em></label>
				<textarea name="arrData[body]" id="body" class="validate-ckeditor" >{$arrData.body}</textarea>
			</li>
			<li>
				<label>Type:</label>
				<select id="flg_type" name="arrData[flg_type]">
					<option value="0"{if empty($arrData.flg_type)||$arrData.flg_type==0} selected="selected"{/if}>dashboard</option>
					<option value="1"{if !empty($arrData.flg_type)&&$arrData.flg_type==1} selected="selected"{/if}>popup</option>
				</select>
			</li>
			<li id="flg_priority"{if empty($arrData.flg_type)||$arrData.flg_type==0} style="display:none;"{/if}>
				<label>Priority:</label>
				<input type="checkbox" name="arrData[flg_priority]" value="1"{if $arrData.flg_priority} checked="checked"{/if} />
			</li>
			<li>
				<label>Start:<em>*</em></label>
				<input type="text" value="{if $arrData.start}{$arrData.start|date_format:$config->date_time->dt_full_format}{else}{$smarty.now|date_format:$config->date_time->dt_full_format}{/if}" id="view-date-start" class="not_started completed required" data-meiomask="fixed.DateTime" />
				<input type="hidden" name="arrData[start]"  value="{if !empty($arrData.start)}{$arrData.start}{else}{$smarty.now}{/if}" id="date-start" />
				<img src="/skin/_js/jscalendar/img.gif" id="trigger-start" style="cursor:pointer;" alt="" />
			</li>
			<li>
				<label>End:<em>*</em></label>
				<input type="text" value="{if $arrData.end}{$arrData.end|date_format:$config->date_time->dt_full_format}{/if}" id="view-date-end" class="not_started completed required" data-meiomask="fixed.DateTime" />
				<input type="hidden" name="arrData[end]"  value="{if !$arrData.end}{$smarty.now}{else}{$arrData.end}{/if}" id="date-end" />
				<img src="/skin/_js/jscalendar/img.gif" id="trigger-end" style="cursor:pointer;" alt="" />
			</li>
			<li>
				<label>Groups:<em>*</em></label>
				<table>
				<tr>
					<td width="30%" class="for_checkbox">
						<input type="checkbox" id="select_all">
						<label for="select_all">Select all</label>
					</td>
				{foreach from=$arrGroups item=group key=key}
					{if ($key-1)%3 == 0}
				</tr>
				<tr>
					{/if}
					<td width="30%" class="for_checkbox">
						<input type="checkbox" name="arrData[groupsIds][]" value="{$group['id']}"{if in_array($group['id'], $arrData['groups'])} checked="checked"{/if} id="g_{$key}" class="all_goups" data-validators="validate-one-required-names">
						<label for="g_{$key}">{$group['title']}</label>
					</td>
				{/foreach}
				</tr>
				</table>
			</li>
			<li>
				<label>&nbsp;</label><input type="submit" id="submit" value="Save" />
			</li>
		</ol>
	</fieldset>
</form>

{literal}
<script type="text/javascript">
	window.addEvent('domready',function(){
		CKEDITOR.replace( 'body', {
			toolbar : 'Default',
			height:"300",
			width:"700"
		});
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
	
	$('flg_type').addEvent( 'change', function( elt ){
		if( elt.target.value=='1' ){
			$('flg_priority').show();
		}else{
			$('flg_priority').hide();
		}
	});
		
	$('select_all').addEvent( 'change', function( elt ){
		$$('.all_goups').each( function( e ){
			e.checked=elt.target.checked;
		});
	});
	
	$$('.all_goups').addEvent( 'change', function( elt ){
		if( !elt.target.checked ){
			$('select_all').checked=false;
		}
	});
	
	$('submit').addEvent('click',function(evt){
		$$('.validate-ckeditor').set('style','visibility:hidden;display:inline-block;height:0px;weight:0px;');
	});
</script>
{/literal}