<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>

<div class="card-box">
	<div id="background">
		<div style="padding: 10px;">
			<form action="">

				<table class="table table-striped">
					<thead>
						<tr>
							<th>Company</th>
							<th>Options</th>
						</tr>
					</thead>

					<tbody>{if count($arrList)>0}
						{foreach $arrList as $v}
						<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
							<td>{$v.name}</td>
							<td class="option">
								<a class="select-form" data-leadchannels="{$v.id}" href="#">Select</a>
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
			</form>
		</div>
	</div>
</div>

{literal}
<script type="text/javascript">
window.parent.$('cerabox').getChildren('.cerabox-content')[0].setStyle('overflow','none');

var returnDataToElementId='{/literal}textarea_html_{$smarty.get.boxid}{literal}';

$$('.select-form').addEvent( 'click', function(evnt) {
	evnt.stop();
	$$('tr.matros').removeClass('info');
	$(this).getParent().getParent().addClass('info');
	window.parent.$(returnDataToElementId).set('value', $(this).get('data-leadchannels'));
	window.parent.$(returnDataToElementId).fireEvent('change',{'target':window.parent.$(returnDataToElementId)});
	window.parent.CeraBoxWindow.close();
});
</script>
{/literal}

</body>
</html>