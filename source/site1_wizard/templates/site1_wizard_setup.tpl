{if Core_Acs::haveRight( ['wizard'=>['icon_amazon']] )}
<a class="wizard_tab" style="top:41%;" href="{url name='site1_wizard' action='create'}" title="Wizard"><img src="/skin/i/frontends/design/wizard/amazon.png"></a>
{/if}
{if Core_Acs::haveRight( ['wizard'=>['icon_zonterest']] )}
<a class="wizard_tab" style="top:{if Core_Acs::haveRight( ['wizard'=>['icon_amazon']] )}59{else}41{/if}%;" href="{url name='site1_wizard' action='zonterest'}" title="Wizard AzonFunnels"><img src="/skin/i/frontends/design/wizard/zonterest.png"></a>
{/if}
{if Core_Acs::haveRight( ['wizard'=>['icon_zonterestpro']] )}
<a class="wizard_tab" style="top:{if Core_Acs::haveRight( ['wizard'=>['icon_amazon']] )}59{else}41{/if}%;" href="{url name='site1_wizard' action='zonterestpro'}" title="Wizard AzonFunnels PRO"><img src="/skin/i/frontends/design/wizard/zonterest.png"></a>
{/if}
{if Core_Acs::haveAccess( 'email test group', 'Content Website Builder' )}
{if Core_Acs::haveRight( ['wizard'=>['icon_content']] )}
<a class="wizard_tab" style="top:73%;" href="{url name='site1_wizard' action='content'}" title="Wizard"><img src="/skin/i/frontends/design/wizard/zonterest.png"></a>
{/if}
{if Core_Acs::haveRight( ['wizard'=>['icon_video']] )}
<a class="wizard_tab" style="top:88%;" href="{url name='site1_wizard' action='video'}" title="Wizard"><img src="/skin/i/frontends/design/wizard/zonterest.png"></a>
{/if}
{/if}
{literal}
<script type="text/javascript">
window.addEvent('load',function(){
	var wizard_multibox=new CeraBox( $$('.wizard_tab'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	var wizard_multibox=new CeraBox( $$('.wizard_icon'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
</script>
{/literal}