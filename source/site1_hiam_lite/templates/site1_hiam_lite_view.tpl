<div style="margin:0 auto;width:940px;">
{foreach from=$arrList item=msg}
{if $msg.flg_type==0}
<h3>{$msg.title}</h3>
<p>{$msg.body}</p>
{elseif !Core_Users::$info['flg_hiam_view']}
{Project_Users::setFlag2HiamLite()}
<a href="#hiam_lite_popup" id="hiam_lite_popup_link" title="{$msg.title}" style="display:none;"></a>
<div style="display:none">
	<div id="hiam_lite_popup">
		<div class="hiam_lite_popup_view">
			<h3>{$msg.title}</h3>
			<p>{$msg.body}</p>
		</div>
	</div>
</div>
{literal}
<script type="text/javascript">
$('hiam_lite_popup_link').cerabox({
	group: false,
	width:'50%',
	height:'50%',
	displayTitle: true,
	titleFormat: '{title}'
});

window.addEvent('domready', function(){
	$('hiam_lite_popup_link').fireEvent('click');
});
</script>
{/literal}
{/if}
{/foreach}
</div>