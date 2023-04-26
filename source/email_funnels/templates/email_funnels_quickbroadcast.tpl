<!DOCTYPE html>
<html>
<head>
	{module name='site1' action='head'}
<style>{literal}
input[type="text"]{
	margin-right: 4px;
	display: inline-block;
}
 {/literal}</style>
</head>
<body>
{literal}<style type="text/css">.message {padding-bottom:20px;margin-bottom:20px;border-bottom:2px dotted #cecece}.message:last-child {border:none;margin:none}.ui-sortable-placeholder {height:40px!important;border-radius:3px!important;border: 1px dotted #cccccc!important;background:#ffffff!important;}.panel-heading:after{content:'';width:100%;clear:both;display:block}.w-97{width:97%}.w-3{width:3%}.m-t-3{margin-top:3px}
.main_subject{max-width:90%;display: inline-block;}</style>{/literal}
<div class="card-box">
	<form action="" method="post" id="autosave_form">
		<input type="hidden" name="arrData[type]" value="1" />
		<input type="hidden" name="arrData[flg_pause]" value="0" />
		<div class="row" id="funnel_settings">
			{assign var=key value=0}
			<div class="form-group">
				<label>Subjects</label><br/>
				<p class="main_subject_block">
					<input type="text" name="arrData[message][{$key}][subject][0]" id="subject_0" class="subject_0 main_subject medium-input text-input form-control" data-hashtag="" value="" />
				</p>
			</div>
			<div class="form-group">
				<label>Body HTML</label>
				<textarea class="form-control" name="arrData[message][{$key}][body_html]" id="body_html_0" rel="0">{$v.body_html}</textarea>
			</div>
			<div class="form-group">
				<div class="checkbox checkbox-custom">
					<input type="hidden" class="form-control" name="arrData[options][flg_resender]" value="0" />
					<input type="checkbox" class="form-control" name="arrData[options][flg_resender]" id="flg_resender" value="1"{if !isset($arrData.options.flg_resender) || $arrData.options.flg_resender == '1'} checked{/if} />
					<label for="flg_resender" id="flg_resender_label">Resend to non openers in xx hours</label>
				</div>
			</div>
			<div id="resender_timer" class="flg_resender_box form-group"{if ( !isset($arrData.options.flg_resender) || $arrData.options.flg_resender == '1' ) && $arrData.options.type!=2}{else} style="display:none;"{/if}>
				<label>Resend time</label>
				<input type="number" class="form-control" name="arrData[options][resender_time]" value="{$arrData.options.resender_time|default:24}" min="1" />
			</div>
			<div class="form-group">
				<label>Select the SMTP integration to use with this funnel</label>&nbsp;
				{if !empty($arrSMTP)}
				<select class="selectpicker" name="arrData[smtp_id]">
				{foreach $arrSMTP as $item}
					<option value="{$item.id}"{if $arrData.smtp_id==$item.id} selected="selected"{/if}>{$item.title} [{if $item.flg_active=='1'}ACTIVE{else}INACTIVE{/if}]</option>
				{/foreach}
				</select>
				{else}
				<a href="{url name='email_funnels' action='frontend_settings'}" class="btn btn-default waves-effect waves-light">Add SMPT integration</a>
				{/if}
			</div>
		</div>
		<div class="form-group">
			<button type="submit" class="btn btn-success waves-effect waves-light" id="save_button">Save</button>
		</div>
	</form>
</div>
<script type="text/javascript" src="/skin/_js/ui.js"></script>
<script src="/skin/light/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/skin/_js/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" href="/skin/_js/jquery-ui/jquery-ui.css">
<script type="text/javascript" src="/skin/_js/jquery-ui/jquery-ui.js"></script>
<script src="/skin/light/plugins/bootstrap-select/dist/js/bootstrap-select.min.js" type="text/javascript"></script>
<script src="/skin/light/js/jquery.core.js"></script>
{literal}
<script type="text/javascript">
	var afterSave='{/literal}{$id}{literal}';
	if (window.top !== window.window && typeof window.parent.quickBroadcastUpdate != "undefined" && afterSave != ''){
		window.parent.quickBroadcastUpdate(afterSave);
	}
	jQuery(document).ready(function($) {
		$('.selectpicker').selectpicker({
			style: 'btn-info',
			size: 4
		});
		//$( '.selectpicker' ).selectpicker('refresh');
	});
	CKEDITOR.replace( 'body_html_0', {
		toolbar : 'Basic_Squeeze',
		enterMode: CKEDITOR.ENTER_BR,
		shiftEnterMode: CKEDITOR.ENTER_BR,
		fontSize_sizes: '8px/8;9px/9;10px/10;11px/11;12px/12;14px/14;16px/16;18px/18;20px/20;22px/22;24px/24;26px/26;28px/28;36px/36;48px/48;72px/72',
		fontSize_style: {
			element: 'font',
			attributes: { 'size': '#(size)' },
			styles: { 'font-size': '#(size)px', 'line-height': '100%' }
		}
	});
	$('flg_resender').addEvent('change',function(e){
		if( e.target.checked ){
			$$('.flg_resender_box').show();
		}else{
			$$('.flg_resender_box').hide();
		}
	});
</script>
{/literal}
</body>
</html>