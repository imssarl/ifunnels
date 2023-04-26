{if Core_Acs::haveAccess( array( 'email test group' ) )}
<div class="panel panel-color panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">Filters</h3>
	</div>
	<div class="panel-body">
		<form action="" method="get">
			{if !empty( $sFilter.LC )}
			<select id="saved_filters" class="btn-group selectpicker show-tick pull-left m-r-10">
				<option value="">- Saved Filters -</option>
				{foreach from=$sFilter.LC item=i}
				<option value='{json_encode($i)}'{if $i.lead == $smarty.get.arrFilter.lead && $i.tags == $smarty.get.arrFilter.tags} selected="selected"{/if}>{$i.name}</option>
				{/foreach}
			</select>
			{/if}
			<select class="btn-group selectpicker show-tick pull-left" name="arrFilter[lead]">
				<option value=""{if !isset($smarty.get.arrFilter.lead) || empty( $smarty.get.arrFilter.lead )}selected="selected"{/if}>- select -</option>
				{foreach from=$mo_campaigns key=id item=v}
				<option value="{$id}" {if $id == $smarty.get.arrFilter.lead}selected="selected"{/if}>{$v.name}</option>
				{/foreach}
			</select>
			
			<div class="col-md-3">
				<input type="text" name="arrFilter[tags]" class="form-control" placeholder="Enter Tags separated comma" value="{$smarty.get.arrFilter.tags}" />
			</div>
			<div class="checkbox checkbox-primary pull-left">
				<input type="checkbox" id="save_filter" value="1" />
				<label for="save_filter">Save Filter</label>
			</div>
			<div class="col-md-2" id="save-field" style="display: none">
				<input type="text" id="filter_name" class="form-control" placeholder="Filter Name" />
			</div>
			<button type="submit" class="btn btn-default waves-effect waves-light m-l-10" id="filter">Filter</button>
		</form>
	</div>
</div>
{/if}
<div class="card-box wrap ulp">
	{if !empty($error_message)}
		{include file='../../message.tpl' type='error' message={$error_message}}
	{elseif !empty($ok_message)}
		{include file='../../message.tpl' type='success' message={$ok_message}}
	{elseif !empty($message)}
		{include file='../../message.tpl' type='warning' message={$message}}
	{/if}
	<div class="form-group">
		<button type="button" id="export" class="btn btn-success waves-effect waves-light" data-toggle="modal" data-target="#panel-modal">Export</button>
	</div>
	<div class="ulp_pageswitcher">{include file="../../pgg_backend.tpl"}</div>
	<table class=" table  table-striped">
	<tr>
		<th>E-mail</th>
		<th>IP</th>
		<th>Tags</th>
		<th>Lead Campaigns</th>
		<th style="width: 150px;">Date Added</th>
		<th style="width: 70px;"></th>
	</tr>
	{if sizeof($arrList) > 0}
	{foreach from=$arrList item='row'}
	<tr>
		<td>{$row['email']}</td>
		<td>{$row['ip']}</td>
		<td>
		{if isset($row['tags']) && is_array($row['tags'])}{implode( ', ', $row['tags'])}{else}{$row['tags']}{/if}
		</td>
		<td>
		{foreach $row['mo_ids'] as $moId}
			{if isset($mo_campaigns[$moId]) && !empty($mo_campaigns[$moId]['name']) }{$mo_campaigns[$moId]['name']}{if $moId != end( $row['mo_ids'] )}, {/if}{/if}
		{/foreach}
		{if !isset($row['mo_ids']) && isset( $mo_campaigns[$row.squeeze_events] )}{$mo_campaigns[$row.squeeze_events].name}{/if}
		</td>
		<td data-test="{$row.added}">{if $row.added!=0}{$row.added|date_local:$config->date_time->dt_full_format}{/if}</td>
		<td style="text-align: center;">
			{if !empty($row['requests'])}
			<a data-toggle="modal" href="#ulp-message-{$row['id']}" title="View message"><i class="ion-ios7-download" style="color: #81c868; font-size: 21px; vertical-align: bottom;"></i></a>
			{/if}
			{if isset($row['messages'])}
			<a data-toggle="modal" href="#ulp-autoresponders-{$row['id']}" title="View autoresponders"><i class="ion-ios7-download" style="color: #81c868; font-size: 21px; vertical-align: bottom;"></i></a>
			{/if}
			<a href="{url name='site1_funnels' action='leads'}?action=delete&id={$row['id']}" title="Delete record" onclick="return ulp_submitOperation();"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></a>
		</td>
	</tr>
	{/foreach}
	{else}
	<tr><td colspan="6" style="padding: 20px; text-align: center;">{if strlen($search_query) > 0}No results found for "<strong>{$search_query}</strong>"{else}List is empty{/if}</td></tr>
	{/if}
	</table>
	<div class="ulp_pageswitcher">{include file="../../pgg_backend.tpl"}</div>
</div>
{if sizeof($arrList) > 0}
{foreach from=$arrList item='row'}
{if !empty($row['requests'])}
<div class="modal fade" data-toggle="modal" id="ulp-message-{$row['id']}" tabindex="-1" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Messages</h4>
			</div>
			<div class="modal-body">
				<table class=" table  table-striped">
					<tr>
						<th>Date</th>
						<th>Message</th>
					</tr>
					{foreach $row['requests'] as $date=>$msg}
					<tr>
						<td>{$date|date_format:$config->date_time->dt_full_format}</td>
						<td>
							{if isset($msg.email) && !empty($msg.email)}{$msg.email} {/if}
							{if isset($msg.ip) && !empty($msg.ip)}{$msg.ip} {/if}
							{if isset($msg.phone) && !empty($msg.phone)}{$msg.phone} {/if}
						</td>
					</tr>
					{/foreach}
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
{/if}
{if isset($row['messages']) }
<div class="modal fade" data-toggle="modal" id="ulp-autoresponders-{$row['id']}" tabindex="-1" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<table class=" table  table-striped">
					<tr>
						<th>Date</th>
						<th>Message/Autoresponder</th>
					</tr>
				{foreach from=$row['messages'] item='arrLog' key='ar_id'}
					{if !empty( $arrLog )}
					{if isset( $a8rData[$arrLog['arId']] )}
					<tr>
						<th>&nbsp;</th>
						<th>{$a8rData[$arrLog['arId']]}</th>
					</tr>
					{/if}
					<tr>
						<td>{$arrLog['added']|date_format:$config->date_time->dt_full_format}</td>
						<td><a href='#' title="{htmlspecialchars( $arrLog['ansver'] )}">{htmlspecialchars( $arrLog['message'] )|truncate:300:"...":true}</a></td>
					</tr>
					{/if}
				{/foreach}
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
{/if}
{/foreach}
{/if}
<script type="text/javascript">{literal}
	function ulp_submitOperation() {
		var answer = confirm("Do you really want to delete this subsciber?")
		if (answer) return true;
		else return false;
	}
	{/literal}{if Core_Acs::haveAccess( array( 'email test group' ) )}{literal}
	jQuery( document ).ready( function(){
		jQuery( '#save_filter' ).on( 'change', function(){
			if( jQuery( this ).prop( 'checked' ) ) {
				jQuery( '#save-field' ).fadeIn( 'fast' );
			} else {
				jQuery( '#save-field' ).fadeOut( 'fast' );
			}
			return false;
		} );

		jQuery( '#filter' ).on( 'click', function(){
			if( jQuery( '#save_filter' ).prop( 'checked' ) ){
				let _filter = Cookies.getJSON( 'filter' );
				if( _filter !== undefined ){
					if(_filter.LC === undefined) { _filter.LC = []; }
					_filter.LC.push( {
						'name' : ( jQuery( '#filter_name' ).prop( 'value' ) !== '' ? jQuery( '#filter_name' ).prop( 'value' ) : 'Filter ' + ( _filter.LC.length + 1 ) ),
						'lead' : jQuery( 'select[name="arrFilter[lead]"]' ).prop( 'value' ),
						'tags' : jQuery( '[name="arrFilter[tags]"]' ).prop( 'value' )
					} );
				} else {
					_filter = {
						'LC' : [
							{
								'name' : ( jQuery( '#filter_name' ).prop( 'value' ) !== '' ? jQuery( '#filter_name' ).prop( 'value' ) : 'Filter 1' ),
								'lead' : jQuery( 'select[name="arrFilter[lead]"]' ).prop( 'value' ),
								'tags' : jQuery( '[name="arrFilter[tags]"]' ).prop( 'value' )
							}
						]
					};
				}
				Cookies.set('filter', JSON.stringify( _filter ) );
			}
		} );

		jQuery( '#saved_filters' ).on( 'change', function(){
			let _params = JSON.decode( jQuery( this ).prop( 'value' ) );
			window.location.assign( '?arrFilter%5Blead%5D=' + _params.lead + '&arrFilter%5Btags%5D=' + _params.tags );
		} );
	} );
	{/literal}{/if}{literal}
{/literal}</script>

<div id="panel-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content p-0 b-0">
			<div class="panel panel-color panel-primary">
				<div class="panel-heading"> 
					<button type="button" class="close m-t-5" data-dismiss="modal" aria-hidden="true">×</button> 
					<h3 class="panel-title">Export contacts</h3> 
				</div> 
				<div class="panel-body text-center"> 
					<div class="progress progress-lg m-b-5">
						<div class="progress-bar progress-bar-warning progress-bar-striped active" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
							<span class="sr-only"></span>
						</div>
					</div> 
				</div> 
			</div>
		</div>
	</div>
</div>
{literal}
<script>
	let maxPage = '{/literal}{$arrPg.urlmax}{literal}'.match( /\?page=(\d+)/i ), page = 1, flg_done = false;
	jQuery( document ).ready( function(){
		jQuery( '#export' ).on( 'click', function(){
			if( maxPage === null ) {
				maxPage = 1;
			} else {
				maxPage = parseInt( maxPage[1] );
			}
			if( !flg_done )
				send( page );
		} );
	} );

	function send( page ){
		jQuery.ajax({
			method: "POST",
			url: "{/literal}{url name='site1_funnels' action='ajax'}{literal}",
			data: {
				export : true,
				url : {'page' :  page}
			}
		}).done( function( data ){
			page++;
			jQuery( '[role="progressbar"]' ).css( 'width', (page * 100 / maxPage) + "%" );
			if( page <= maxPage )
				send( page );
			else {
				flg_done = true;
				data = JSON.parse( data );
				if( !jQuery( '[role="progressbar"]' ).parent().next().hasClass( 'download-file' ) ) 
					jQuery( '[role="progressbar"]' ).parent().fadeOut( 'fast' ).after( '<a href="' + data + '" class="btn btn-success waves-effect waves-light download-file">Download File</a>' );
			} 
		} );
	}
</script>
{/literal}