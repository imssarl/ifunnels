<a href="{url name='site1_hiam' action='input_file' wg="sysname=$sysname" }" class="popup" title="Add new file">Add new file</a>
{module name='files' action='files_manager' sysname=$sysname set_action=$arrPrm.action set_name=$arrPrm.name}
{literal}
<script type="text/javascript">
multibox=new CeraBox( $$('.popup'), {
	group: false,
	width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
	height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
	displayTitle: true,
	titleFormat: '{title}'
});
</script>
{/literal}