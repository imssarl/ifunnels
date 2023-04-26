<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
	<div class="card-box">
		<div class="form-group">
			<table class="table">
				<thead>
					<tr>
						<th>Email</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$arrEmails item=v}
					<tr data-type="{$v.type}">
						<td>{$v}</td>
						</td>
					</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>