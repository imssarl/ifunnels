{if !empty($revisions)}
	{foreach from=$revisions item=revision}
		<li>
			<span class="fui-arrow-right"></span>
			{date('Y-m-d H:i:s', $revision.frames_timestamp)}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="{url name='site1_ecom_funnels' action='rpreview'}?s={$siteID}&r={$revision.frames_timestamp}&p={$page}" target="_blank" title="Preview Revision">
				<span class="fui-export"></span>
			</a>
			&nbsp;
			<a href="{url name='site1_ecom_funnels' action='deleterevision'}?s={$siteID}&r={$revision.frames_timestamp}&p={$page}" title="Delete Revision" class="link_deleteRevision">
				<span class="fui-trash text-danger"></span>
			</a>
			&nbsp;
			<a href="{url name='site1_ecom_funnels' action='restorerevision'}?s={$siteID}&r={$revision.frames_timestamp}&p={$page}" title="Restore Revision" class="link_restoreRevision">
				<span class="fui-power text-primary"></span>
			</a>
		</li>
	{/foreach}
{/if}
