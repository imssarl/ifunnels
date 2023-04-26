{if $arrPrm.flg_tpl==3}
{elseif $arrPrm.flg_tpl==1}
	{include file="files_`$arrPrm.action`.tpl"}
{elseif $arrPrm.action}
	{if $arrPrm.action!='edit_group'&&$arrPrm.action!='upload_file'&&$arrPrm.action!='file_info'&&$arrPrm.action!='view_file'}<h1>{$arrPrm.title}</h1>{/if}
	{include file="files_`$arrPrm.action`.tpl"}
{else}
	wrong action!
{/if}