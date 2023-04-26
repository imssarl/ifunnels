<div class="notification {if $type=='warning'}attention{elseif $type=='error'}error{elseif $type=='information'}information{elseif $type=='attention'}attention{else}success{/if} png_bg">
	<a href="#" class="close"><img src="/skin/i/frontends/design/newUI/icons/cross_grey_small.png" title="Close this notification" alt="close" /></a>
	<div>{$message}</div>
</div>