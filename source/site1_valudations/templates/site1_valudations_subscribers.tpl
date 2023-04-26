<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	{module name='site1' action='head' type='mini'}
	<style>
		{literal}
		input[type="text"] {
			margin-right: 4px;
			width: 200px;
			display: inline-block;
		}
		{/literal}
	</style>
</head>

<body style="padding:20px;">
	<div class="card-box">
		<div class="form-group">
			<button type="submit" class="btn btn-default waves-effect waves-light" id="export">Submit</button>
		</div>
		<table class=" table table-striped">
			<tr>
				<th style="width: 400px;">
					<div class="checkbox checkbox-primary">
						<input type="checkbox" id="select_all">
						<label for="select_all">E-mail</label>
					</div>
				</th>
			</tr>
			{if sizeof($arrList) > 0} {foreach from=$arrList item='row'}
			<tr>
				<td>
					<div class="checkbox checkbox-primary">
						<input type="checkbox" class="select_one" id="email-{$row.id}" data-email="{$row['email']}" />
						<label for="email-{$row.id}">{$row['email']}</label>
					</div>
				</td>
			</tr>
			{/foreach} {else}
			<tr>
				<td style="padding: 20px; text-align: center;">{if strlen($search_query) > 0}No results found for "<strong>{$search_query}</strong>"{else}List is empty{/if}</td>
			</tr>
			{/if}
		</table>
		{literal}
		<script type="text/javascript">
			jQuery('#export').on('click', function (e) {
				console.log('export');
				var emailList = '';
				jQuery('.select_one:checked').each(function (_index, item) {
					var sep = '|';
					if (_index == 0) {
						sep = '';
					}
					emailList = emailList + sep + jQuery(item).attr('data-email');
				});
				window.parent.setEmails(emailList);
			});
			jQuery('#select_all').on('click', function (e) {
				console.log('select_all');
				jQuery('.select_one').each(function (_index, item) {

					jQuery(item).prop("checked", true);
				});
			});
		</script> {/literal}
	</div>
</body>

</html>