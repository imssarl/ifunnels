{if count($arrList)>1}
	{if $smarty.get.order_mv!="{$field}--up"}<a href="{url name=$arrPrm.name action=$arrPrm.action}?order_mv={$field}--up{if !empty($sortParam)}&{$sortParam}{/if}{if !empty($smarty.get.id)}&id={$smarty.get.id}{/if}"><img src="/skin/i/backend/up.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/up_off.gif" width="5" height="11" alt="" />{/if}{if $smarty.get.order_mv!="{$field}--dn"}<a href="{url name=$arrPrm.name action=$arrPrm.action}?order_mv={$field}--dn{if !empty($sortParam)}&{$sortParam}{/if}{if !empty($smarty.get.id)}&id={$smarty.get.id}{/if}" ><img src="/skin/i/backend/down.gif" width="5" height="11" alt="" /></a>{else}<img src="/skin/i/backend/down_off.gif" width="5" height="11" alt="" />{/if}
{/if}