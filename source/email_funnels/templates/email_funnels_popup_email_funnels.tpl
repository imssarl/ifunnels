<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
	{if !empty($smarty.get.id)}
	<div class="card-box">
		<div class="form-group">
			<a href="{url name='email_funnels' action='popup_email_funnels'}" class="btn btn-default waves-effect waves-light">Return to select</a>
		</div>
		{foreach from=$arrData.message item=message}
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">{$message.name}</h3>
			</div>
			<div class="panel-body">
				{$message.body_html}
			</div>
		</div>
		{/foreach}
	</div>
	{else}
	<div class="card-box">
		<div id="accordion" role="tablist" aria-multiselectable="true" class="m-b-20 panel-group">
			<div class="card panel panel-default">
				<div class="card-header panel-heading" role="tab" id="headingOne">
					<h5 class="mb-0 mt-0 panel-title"><a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne" class="collapsed">Type</a></h5>
				</div>

				<div id="collapseOne" class="collapse panel-collapse" role="tabpanel" aria-labelledby="headingOne">
					<div class="card-body panel-body">
						<div class="checkbox checkbox-custom">
							<input id="broadcast" type="checkbox" checked="" value="1" />
							<label for="broadcast">Broadcast</label>
						</div>
						<div class="checkbox checkbox-custom">
							<input id="sequence" type="checkbox" checked="" value="2" />
							<label for="sequence">Sequence</label>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="form-group">
			<table class="table">
				<thead>
					<tr>
						<th>Title</th>
						<th>Description</th>
						<th class="text-center">Number of Emails</th>
						<th class="text-center">Length of Sequence, Days</th>
						<th>Option</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$arrData item=v}
					<tr data-type="{$v.type}">
						<td>{$v.title}</td>
						<td>{$v.description}</td>
						<td align="center">{if $v.type == '1'}1{else}{count($v.message)}{/if}</td>
						<td align="center">{if $v.type == '1'}0{else}{$v.length_days}{/if}</td>
						<td>
							<a href="{url name='email_funnels' action='popup_email_funnels' wg="id={$v.id}"}" class="btn btn-default waves-effect waves-light">Preview</a>
							<a href="#" class="btn btn-default waves-effect waves-light" data-ef="{$v.id}">Select</a>
						</td>
					</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</div>
	{literal}
	<script type="text/javascript">
		jQuery( document ).ready( function(){
			jQuery( '#accordion .card h5 > a' ).on( 'click', function(){
				jQuery( '.collapse' ).removeClass( 'show' );
				jQuery( '#accordion .card h5 > a' ).addClass( 'collapsed' );
				jQuery( this ).removeClass( 'collapsed' );
				jQuery( jQuery( this ).attr( 'href' ) ).addClass( 'show' );
				return false;
			} );

			jQuery( '[type="checkbox"]' ).on( 'change', function(){
				if( jQuery( this ).prop( 'checked' ) ){
					jQuery( 'tr[data-type="' + jQuery( this ).prop( 'value' ) + '"]' ).show();
				} else {
					jQuery( 'tr[data-type="' + jQuery( this ).prop( 'value' ) + '"]' ).hide();
				}
			} );

			jQuery('[data-ef]').on( 'click', function( evt ){
				evt.preventDefault();
				window.parent.multibox.boxWindow.close();
				window.parent.setTemplate( jQuery( this ).data( 'ef' ) );
				return false;
			});
		} );
	</script>
	{/literal}
	{/if}
</body>
</html>