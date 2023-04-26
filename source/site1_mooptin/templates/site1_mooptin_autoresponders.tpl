<div class="card-box">
	<div class="form-group">
		<a href="https://help.ifunnels.com/collection/52-lead-channels" target="_blank" class="btn btn-info btn-rounded waves-effect waves-light">
			<span class="btn-label"><i class="fa fa-exclamation"></i></span>Access the Online Tutorials here
		</a>
	</div>
	<a href="{url name='site1_mooptin' action='autoresponder'}" class="popup" title="Add New Lead Setting">Add New Lead Setting</a><br/>
	<a href="#twilio_settings" class="popup" title="Integrate Twilio Account">Integrate Twilio Account</a>
	<div style="display: none;">
		<div id="twilio_settings" class="popup-block">
			<div class="card-box">
				<form method="post" action="" >
					<div class="form-group">
						<label>Twilio</label>
					</div>
					<div class="form-group">
						<label>Token: </label>
						<input type="text" id="twilio_token" name="arrData[token]" value="{Core_Users::$info['twilio']['token']}" class="form-control">
						<br><small>Enter your Token.</small>
					</div>
					<div class="form-group">
						<label>Sid: </label>
						<input type="text" id="twilio_sid" name="arrData[sid]" value="{Core_Users::$info['twilio']['sid']}" class="form-control">
						<br><small>Enter your SID.</small>
					</div>
					<div class="form-group">
						<label>TwiML Apps Messaging REQUEST POST URL: </label>
						<br><small>{Zend_Registry::get( 'config' )->domain->url}{url name='site1_mooptin' action='twilio_api'}{Project_Widget_Mutator::encode( Core_Users::$info['id'] )}/</small>
					</div>
					<fieldset class="m-t-10">
						<button type="submit" class="btn btn-default waves-effect waves-light">Submit</button>
					</fieldset>
				</form>
			</div>
		</div>
	</div>
	<table class="table table-striped" style="width:98%">
		<thead>
			<tr>
				<th>Name</th>
				<th width="180">Options</th>
			</tr>
		</thead>
		<tbody>{if count($arrList)>0}
			{foreach $arrList as $v}
			<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
				<td>{$v.name}</td>
				<td class="option">
					<a href="{url name='site1_mooptin' action='autoresponder' wg="id={$v.id}"}" class="popup"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></a>
					<a href="{url name='site1_mooptin' action='autoresponders' wg="del={$v.id}"}"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
				</td>
			</tr>
			{/foreach}
			<tr>
				<td colspan="2">{include file="../../pgg_backend.tpl"}</td>
			</tr>
			{else}
			<tr>
				<td colspan="2">No elements</td>
			</tr>
			{/if}
		</tbody>
	</table>
	
</div>
{literal}
<script type="text/javascript">
	window.placeAutoresponder=function(){
		location.reload();
	}

	window.mooptinpopup=new CeraBox( $$('.popup'), {
		group: false,
		width:'{/literal}{if !empty($arrUser.arrSettings.popup_width)}{$arrUser.arrSettings.popup_width}{else}70{/if}{literal}%',
		height:'{/literal}{if !empty($arrUser.arrSettings.popup_width)}{$arrUser.arrSettings.popup_height}{else}70{/if}{literal}%',
		displayTitle: true,
		titleFormat: '{title}',
		fixedPosition: true
	});
</script>
{/literal}