{if empty($arrPrm.action)}
	wrong action!
{else}
	{if $arrPrm.action==$arrNest.action&&$arrPrm.flg_tpl==0}{*если у нас ниже инклюдится шаблон ссылочного экшена*}
		<div class="heading">
			<a class="menu" href="{url name='site1_submission' action='create'}">Create Submission</a>  
			<a class="menu" href="{url name='site1_submission' action='manage'}">Manage Submissions</a> | 
			<a class="menu" href="{url name='site1_submission' action='accounts'}">Manage Directory Accounts</a> | 
			<a class="menu" href="{url name='site1_submission' action='profiles'}">Manage Author Profiles</a> | 
			<a class="menu" href="{url name='site1_submission' action='edit'}">Edit content for Submission project</a> 
		</div>
	{/if}
	{include file="site1_submission_`$arrPrm.action`.tpl"}
{/if}