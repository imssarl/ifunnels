<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head' type='mini'}
</head>
<body>
		<ul id="tabs" style="display:none;">
			<li><a class="tab" href="#" id="one">Select file</a></li>
			<li><a class="tab" href="#" id="two">Add new file</a></li>
		</ul>
		<div id="home" style="display:none;" style="width:95%; ">
			<div class="feature" style="top: 10px;width:100%; ">
				<br />
				<table style="width:90%;">
					<tr>
						<th>Title</th>	
						<th style="width:5%"></th>
					</tr>
					{if $arrList}
					{foreach from=$arrList key=k item=v}
					<tr {if $k%2=='0'} class="matros"{/if}>
						<td>
							<span id="file_title_{$v.id}">{$v.title}</span>
						</td>
						<td align="center" class="option">
							<input type="radio" value="{$v.title}" ids="{$v.id}" name="choose_file" class="chk_item" />
						</td>
					</tr>
					{/foreach}
					{else}
					<tr>
					<td colspan="2">
						no content found
					</td>
					</tr>
					{/if}
				</table>
				<br />
				<div align="right">
				{include file="../../pgg_frontend.tpl"}
				</div>
				<div align="center">
					<input type="button" value="Choose" id="choosekeyw">
				</div>
			</div>
			<div class="feature" style="width:100%; ">
				<div style="left:10px;top:0px;width:100%;">
					<br />
					<form class="wh" style="width:70%" action="" method="post" enctype="multipart/form-data" id="import_form">
						<label>File <em>*</em></label>
						<input type="file" name="file" class="file" >
						<input type="text" name="select" style="display:none;" value="{$select}">
						<div align="center"><p><input type="submit" value="Choose" id="choosefile" {is_acs_write}></p></div>
					</form>
				</div>
			</div>
		</div>
{literal}
<script type="text/javascript" src="/skin/_js/tabs/rotater.js"></script>
<script type="text/javascript" src="/skin/_js/tabs/tabs.js"></script>
<script type="text/javascript">
var selectFileClass = new Class({
	initialize: function(){
		var tabs = new Tabs('.tab','.feature',{startIndex:0});
		$('choosekeyw').addEvent('click', function(){
			var arr=new Array();
			$$('.chk_item').each(function(v){
				if(v.checked){
					window.parent.document.getElementById(  'file_{/literal}{$select}{literal}' ).value=v.get('ids');
					window.parent.document.getElementById( 'file_{/literal}{$select}{literal}_title' ).value=v.get('value');
				}
			});
			window.parent.multibox.boxWindow.close();
		});
		$('home').setStyle('display','');
		$('tabs').setStyle('display','');
	}
});
window.addEvent('domready', function(){
	new selectFileClass();
});
</script>
{/literal}
</body>
</html>