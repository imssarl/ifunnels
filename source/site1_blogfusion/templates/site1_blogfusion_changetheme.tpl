{include file="site1_blogfusion_general_menu.tpl"}

{if $msg == 'error'}
	<div class="red" align="center">Error. Can't change theme.	</div>
{elseif $msg == 'change'}
 <div class="grn" align="center">Changed successfully</div>
{/if}
{include file='../../error.tpl'}
<form action="" method="POST" class="wh" id="form_post" style="width:70%">
	<fieldset>
		<legend>Themes</legend>
		<p>
			<h3>Current theme: <span style="text-transform:uppercase;">{$selectedTheme.title}{if $selectedTheme.preview} (<a href="#" class="screenshot" rel="<img src='{$selectedTheme.preview}'>" style="text-decoration:none">preview</a>){/if}</span></h3>
		</p>
		<p>
			<label>Change theme</label>
			{foreach from=$arrList item='i'}
				<input type="radio" class="selectTheme" {if $i.id == $selectedTheme.id}checked='1'{/if} name="theme" value="{$i.id}" /> {$i.title}{if $i.preview} (<a href="#" class="screenshot" rel="<img src='{$i.preview}'>" style="text-decoration:none">preview</a>){/if}<br/>
			{/foreach}
		</p>
		<p>
			<input type="button" class="button" value="Change" id="change" {is_acs_write}>
		</p>
	</fieldset>
</form>
</td>
</tr>
</table>
{literal}
<script>
window.addEvent('domready', function(){
	$('change').addEvent('click', function(){
		this.disabled = true;
		$('form_post').submit();
	});
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){ el.addEvent('click',function(e){ e.stop(); }); });
});
</script>
{/literal}