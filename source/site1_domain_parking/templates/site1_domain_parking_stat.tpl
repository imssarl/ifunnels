<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
	<div id="main-content">
		<h2>Statistics for "{$arr['title']}"</h2>
		<table>
			<thead>
			<tr>
				<th width="20%" align="center">Domain</th>
				<th align="center">Status</th>
			</tr>
			</thead>
			<tbody>
				{foreach from=$arr['domains'] key='k' item='i'}
				<tr{if $k%2=='0'} class="matros"{/if}>
					<td align="center"><a href="http://{$k}" target="_blank">{$k}</a></td>
					<td>{if !is_array($i)}<span class="grn">parked</span>{else} <span class="red">Error:
						{foreach from=$i item=error}
						{$error};
						{/foreach}</span>
					{/if}</td>
				</tr>
				{/foreach}
			</tbody>
		</table>
	</div>
</body>
</html>
