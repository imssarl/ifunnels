<p><input type="submit" value="Submit" class="subbut" /></p>
<form action="" id="current-form" method="post">
<table class="info glow" style="width:98%">
<thead>
	<tr>
		<th style="padding-right:0;"><input type="checkbox" id="del" class="tooltip no-click" title="mass delete" rel="check to select all" /></th>
		<th>Title</th>
		<th>System name</th>
		<th>Credits</th>
		<th width="180">Length of subscriptions</th>
		<th>Description</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>&nbsp;</td>
		<td valign="top"><input type="text" class="elogin" name="arrData[0][title]" value="" /></td>
		<td valign="top"><input type="text" class="elogin" name="arrData[0][sys_name]" value="" /></td>
		<td valign="top"><input type="text" class="elogin" name="arrData[0][credits]" value="" /></td>
		<td valign="top">
			<input style="width: 80px;" type="text" class="elogin" name="arrData[0][length]" value="" />
			<select style="width: 80px;" class="elogin" name="arrData[0][flg_length]">
				<option value="0">Days</option>
				<option value="1">Month</option>
				<option value="2">Years</option>
				<option value="3">Items</option>
			</select>
		</td>
		<td><textarea name="arrData[0][description]" class="elogin"></textarea></td>
	</tr>
	<tr>
		<td colspan="6">{include file="../../pgg_backend.tpl"}</td>
	</tr>
	{foreach $arrList as $v}
	<tr{if ($v@iteration-1) is div by 2} class="matros"{/if}>
		<input type="hidden" name="arrData[{$v.id}][id]" value="{$v.id}"/>
		<td style="padding-right:0;" valign="top"><input type="checkbox" name="arrData[{$v.id}][del]" class="check-me-del" id="check-{$v.id}" value="{$v.id}" /></td>
		<td valign="top"><input type="text" class="elogin" name="arrData[{$v.id}][title]" value="{$v.title}" /></td>
		<td valign="top"><input type="text" class="elogin" name="arrData[{$v.id}][sys_name]" value="{$v.sys_name}" /></td>
		<td valign="top"><input type="text" class="elogin" name="arrData[{$v.id}][credits]" value="{$v.credits}" /></td>
		<td valign="top">
			<input style="width: 80px;" type="text" class="elogin" name="arrData[{$v.id}][length]" value="{$v.length}" />
			<select style="width: 80px;" class="elogin" name="arrData[{$v.id}][flg_length]">
				<option {if $v.flg_length==0}selected="1"{/if} value="0">Days</option>
				<option {if $v.flg_length==1}selected="1"{/if} value="1">Month</option>
				<option {if $v.flg_length==2}selected="1"{/if} value="2">Years</option>
				<option {if $v.flg_length==3}selected="1"{/if} value="3">Items</option>
			</select>
		</td>
		<td><textarea name="arrData[{$v.id}][description]" class="elogin">{$v.description}</textarea></td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="6">{include file="../../pgg_backend.tpl"}</td>
	</tr>
</tbody>
</table>
</form>
<div><input type="submit" value="Submit" class="subbut" /></div>

<script type="text/javascript">
var json='{$arrList|json}';
{literal}
$$('.check-me-del').each(function(el){
	el.addEvent('click',function(e){
		if(!el.checked){ // добавить
			el.getParent('td').getNext('td').getChildren('select')[0].setStyle('display','none');
			if( !$$('.check-me-del').some(function(item){ if(item.checked) return true; }) ){
				$('moveto').set('html','').setStyle('width','0px');
			}
			var group={};
			var groups=JSON.decode(json);
			groups.each(function( item ){
				if( item.id==el.value ){
					group=item;
					return;
				}
			});

			$$('.moveto-select').each(function(select){
				var option=new Element('option',{value:group.id,html:'move to '+group.title});
				option.inject( select );
				sortSelect(select);
			});
		} else {
			el.getParent('td').getNext('td').getChildren('select')[0].setStyle('display','block');
			$('moveto').set('html','User reassign').setStyle('width','160px');
			$$('.moveto-select').each(function(item){
				Object.each(item.options,function(option){
					if(el.value==option.value){
						option.destroy();
					}
				});
			});
		}

	});
});
var sortSelect=function (select) {
		var nodes = select.options;
		var len = nodes.length;
		var sorted = new Array();
		while (nodes[0]) {
			sorted.push(new String(nodes[0].get('html')));
			sorted[sorted.length-1].element = nodes[0];
			nodes[0].destroy();
		}
		sorted = sorted.sort();
		for (var i = 0; i < len; i++) {
			sorted[i].element.inject(select);
		}
		Object.each(select.options, function(option){
			if( option.value==0 ){
				option.selected=true;
			}
		});
};
$$('.moveto-select').each(function(select){
	sortSelect(select);
});
$$('.subbut').addEvent('click',function(e){
	e && e.stop();
	if ($$('.check-me-del').some(function(item){
		return item.checked==true;
	})) {
		if(!confirm('Your sure to delete selected items?')) return;
	}
	$('current-form').submit();
});
checkboxFullToggle($('del'));
{/literal}
</script>