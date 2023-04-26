<form method="post" class="wh" action="{Core_Module_Router::$uriFull}" name="r_set" id="r_set">
	<input type="button" onclick="r_set.submit();return false;" value="Activate templates" />
	<fieldset>
		<legend>Select IAM templates</legend>
	</fieldset>
	<div>
		{foreach from=$templates item=i key=type}
		<fieldset>
			<legend>{if $type==Project_Sites::BF}Wordpress{/if}{if $type==Project_Sites::NCSB}NCSB{/if}{if $type==Project_Sites::NVSB}NVSB{/if}</legend>
			<ol>
				{foreach from=$i item=template}
				<li>
					<input type="hidden" value="0" name="{$type}[{$template.id}]" />
					<label style="cursor: pointer;" for="id-{$template.id}">
						<a href="#" class="screenshot" rel="<img src='{$template.preview}'>" style="text-decoration:none">{$template.title}</a>&nbsp;
					</label>
					<input type="checkbox" class="{$type}-checkbox" id="id-{$template.id}" value="{$template.id}" {if in_array(implode('_',array($template['id'],$type)),$activeTemplatesLinks)} checked="checked" {/if} name="{$type}[{$template.id}]" />
				</li>
				{/foreach}
			</ol>
		</fieldset>
		{/foreach}
	</div>
</form>
{literal}
<script type="text/javascript">
window.addEvent('domready', function(){
	var optTips2 = new Tips('.tips');
	var optTips = new Tips('.screenshot');
	$$('.screenshot').each(function(el){ el.addEvent('click',function(e){ e.stop(); }); });
	$$('.select-all').each(function(input){
		input.addEvent('click',function(){
			$$('.'+input.get('value')+'-checkbox').each(function(el){
				el.set('checked',input.get('checked'));
			});
		});
	});
});
</script>
{/literal}