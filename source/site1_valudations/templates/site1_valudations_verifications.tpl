<div class="row">
    <div class="col-lg-12">
        {if $msg!=''}
        <div class="alert alert-success alert-dismissable">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">x</button>
            <div>{$msg}</a></div>
        </div>
        {/if}
        {if $error!=''}
            {include file='../../message.tpl' type='error' message=$error}
        {/if}
	</div>      
	<div class="col-lg-12">
		<div class="panel panel-default panel-border">
			<div class="panel-heading">
				<h3 class="panel-title">Validate Single Email Address</h3>
			</div>
			<div class="panel-body" id="single">
				<form method="post">
					<div class="form-group pull-left m-r-10">
						<input type="text" name="email" placeholder="Enter Email"	class="form-control" />
					</div>
					<div class="form-group pull-left">
						<button type="submit" class="btn btn-default waves-effect waves-light" id="export">Validate</button>
					</div>
				</form>
			</div>
		</div>

		<div class="panel panel-default panel-border">
			<div class="panel-heading">
				<h3 class="panel-title">Bulk Validations</h3>
			</div>
			<div class="panel-body">
				<form method="post" enctype="multipart/form-data">
					<div class="form-group pull-left m-r-10">
						<select class="btn-group selectpicker show-tick" name="action">
							<option value="">-select-</option>
							<option value="upload">Upload File</option>
							<option value="select">Select from Contacts</option>
						</select>
					</div>
					<div class="form-group pull-left m-r-10 show_upload" style="display: none;">
						<input type="file" name="csv" data-input="false" class="filestyle" data-buttontext="Select File" accept=".txt,.csv" />
						<p>Note: Upload a file in csv, txt (Max 15Mb)</p>
					</div>
					<div class="form-group pull-left m-r-10 show_select" style="display: none;">
						<a href="{url name='site1_valudations' action='subscribers'}" class="btn btn-default waves-effect waves-light popup" title="Select">Click to Select Contacts</a><br/>
						<input type="hidden" name="select" />
					</div>
					<div class="form-group pull-left">
						<button type="submit" class="btn btn-default waves-effect waves-light" id="export">Validate</button>
					</div>
					<div class="row">
						<div class="form-group show_select col-lg-12" style="display: none;">
							<div class="checkbox checkbox-primary">
								<input type="checkbox" id="remove" name="remove" />
								<label for="remove">Recommended: clean and delete all Undeliverable email addresses from my account</label>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div class="col-lg-12">
		<div class="panel panel-default panel-border">
			<div class="panel-heading"></div>
			<div class="panel-body">
				<table class="table table-striped" style="width:98%">
					<thead>
						<tr>
							<th>Title</th>
							<th>Type</th>
							<th>Date Added</th>
							<th>Status</th>
							<th>Report</th>
						</tr>
					</thead>
					<tbody>{if count($arrLists)>0}
						{foreach $arrLists as $v}
						<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
							<td>{$v.name}</td>
							<td>
								{if $v.type==Project_Validations::SINGLE}<span class="label label-default">Single Email</span>{/if}
								{if $v.type==Project_Validations::CNM_LIST}<span class="label label-primary">Contacts List</span>{/if}
								{if $v.type==Project_Validations::FILE_LIST}<span class="label label-info">File</span>{/if}
								{if $v.type==Project_Validations::REAL_TIME}<span class="label label-success">Real Time</span>{/if}
							</td>
							<td>{$v.added|date_local:$config->date_time->dt_full_format}</td>
							<td>{if $v.status==0}<span class="label label-warning">In progress</span>{else}<span class="label label-success">Completed</span>{/if}</td>
							<td>
								{if $v.type == Project_Validations::FILE_LIST && $v.status==1 && !empty($v.options.zip)}<a href="?up_id={$v.id_checker}" title="Download"><i class="ion-ios7-download" style="color: #81c868; font-size: 21px; vertical-align: bottom;"></i></a>{/if}
								{if $v.type == Project_Validations::CNM_LIST && $v.status==1}<a href="#report_{$v.id}" class="report" title="View"><i class="ion-eye" style="font-size: 21px; vertical-align: bottom;"></i></a>
								<div style="display: none;">
									<div id="report_{$v.id}" class="popup-block">
										<div class="card-box">
											<table class="table table-striped">
												<thead>
													<tr>
														<th>Status</th>
														<th>Emails</th>
													</tr>
												</thead>
												<tbody>
													{foreach $v.options as $statName=>$statArray}
													<tr>
														<td>{$statName}</td>
														<td>
														{foreach $statArray as $statArray2}
															{implode( ', ', $statArray2 )}
														{/foreach}
														</td>
													</tr>
													{/foreach}
												</tbody>
											</table>
										</div>
									</div>
								</div>
								{/if}
								{if $v.type == Project_Validations::FILE_LIST && $v.status==1}<a href="#report_{$v.id}" class="report" title="View"><i class="ion-eye" style="font-size: 21px; vertical-align: bottom;"></i></a>
								<div style="display: none;">
									<div id="report_{$v.id}" class="popup-block">
										{if empty($v.options.status.total)}
										<div class="card-box">
											<table class="table table-striped">
												<thead>
													<tr>
														<th>Status</th>
														<th>Emails</th>
													</tr>
												</thead>
												<tbody>
													{foreach $v.options as $statName=>$statArray}
													<tr>
														<td>{$statName}</td>
														<td>
														{foreach $statArray as $statArray2}
															{implode( ', ', $statArray2 )}
														{/foreach}
														</td>
													</tr>
													{/foreach}
												</tbody>
											</table>
										</div>
										{else}
										<div class="card-box">
											<table class="table table-striped">
												<thead>
													<tr>
														<th># of Emails Checked</th>
														<th>Deliverable</th>
														<th>Risky</th>
														<th>Invalid</th>
														<th>Unknown</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>{$v.options.status.total}</td>
														<td>{if isset($v.options.status.verified)}{$v.options.status.verified}{else}0{/if}</td>
														<td>{if isset($v.options.status.risky)}{$v.options.status.risky}{else}0{/if}</td>
														<td>{if isset($v.options.status.undeliverable)}{$v.options.status.undeliverable}{else}0{/if}</td>
														<td>{if isset($v.options.status.unknown)}{$v.options.status.unknown}{else}0{/if}</td>
													</tr>
												</tbody>
											</table>
										</div>
										{/if}
									</div>
								</div>
								{/if}
								{if ( $v.type == Project_Validations::CNM_LIST || $v.type == Project_Validations::FILE_LIST ) && $v.status==1}
								<a href="?save={$v.id}" class="update" title="Update Contact Statuses"><i class="ion-android-add-contact" style="font-size: 21px; vertical-align: bottom;"></i></a>
								{/if}
								{if ( $v.type == Project_Validations::SINGLE || $v.type == Project_Validations::REAL_TIME ) && $v.status==1 && isset($v.options.result)}{$v.options.result}{/if}
							</td>
						</tr>
						{/foreach}
						<tr>
							<td colspan="5">{include file="../../pgg_backend.tpl"}</td>
						</tr>
						{else}
						<tr>
							<td colspan="5">No elements</td>
						</tr>
						{/if}
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<script src="/skin/light/plugins/bootstrap-filestyle/src/bootstrap-filestyle.min.js" type="text/javascript"></script>
{literal}
<script type="text/javascript">
window.mooptinpopup=new CeraBox( $$('.popup'), {
	group: false,
	width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
	height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
	displayTitle: true,
	titleFormat: '{title}',
	fixedPosition: true
});

new CeraBox( $$('.report'), {
	group: false,
	width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
	height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
	displayTitle: true,
	titleFormat: '{title}',
	fixedPosition: true
});

jQuery( '[name="action"]' ).on( 'change', function(){
	jQuery( '.show_upload' ).hide();
	jQuery( '.show_select' ).hide();
	if( jQuery( this ).prop( 'value' ) == 'upload' ){
		jQuery( '.show_upload' ).show();
	} else {
		jQuery( '.show_upload' ).hide();
	}
	if( jQuery( this ).prop( 'value' ) == 'select' ){
		jQuery( '.show_select' ).show();
	} else {
		jQuery( '.show_select' ).hide();
	}
});

jQuery( '#single form' ).on( 'submit', function(){
	let flg_submit = true;
	if( !/^[0-9a-z]([-_.]?[0-9a-z_])*@[0-9a-z]([-.]?[0-9a-z])*\.[a-z]{2,10}$/i.test( jQuery( '#single input[name="email"]' ).prop( 'value' ) ) ){
		flg_submit = false;
		jQuery( '#single input[name="email"]' ).addClass( 'parsley-error' );
	} else {
		jQuery( '#single input[name="email"]' ).removeClass( 'parsley-error' );
	}
	return flg_submit;
} );

window.setEmails=function( listEmails ){
	console.log( 'se' );
	jQuery( '[name="select"]' ).val( listEmails );
	window.mooptinpopup.boxWindow.close();
}


</script>
{/literal}