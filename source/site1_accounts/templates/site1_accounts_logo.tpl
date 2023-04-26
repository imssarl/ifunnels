{if empty($arrPack)}
	<a href="/" title="Niche Marketing Platform"><img class="title" src="/skin/i/frontends/design/logo3.png" alt="Creative Niche Manager" /></a>
{else}
	<img src="{img src="`$arrPack.image.path_sys``$arrPack.image.name_system`" w='450' h='67'}" />
{/if}