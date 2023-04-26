<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
	<div class="card-box">
		<table class="table table-striped">
			<tr>
				<th>View</th>
				<th>Lead</th>
				<th>Sale</th>
				<th>Country</th>
			</tr>
			{foreach $arrList as $k => $v}
			<tr>
				<td>{if empty($v.view)}0{else}{$v.view}{/if}</td>
				<td>{if empty($v.lead)}0{else}{$v.lead}{/if}</td>
				<td>{if empty($v.sale)}0{else}{$v.sale}{/if}</td>
				<td>{$k}</td>
			</tr>
			{/foreach}
		</table>
	</div>
</body>
</html>