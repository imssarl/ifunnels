{if $file.flg_type == 0} {*остальные типы файлов*}
	No file preview.
{elseif $file.flg_type == 1 or $file.flg_type == 2} {*аудио||видео*}
	<div id="mixPlayer_{$file.id}" class="galery_item {if $file.flg_type == 2}video{else}audio{/if}" url="{$file.path_web}{$file.name_system}" uid="{$file.id}" >
		To watch this video, you need the latest <a href="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" target="_blank">Flash-Player</a> and active javascript in your browser.
	</div>
{elseif $file.flg_type == 3} {*картинки*}
	<img src="{img src=".`$file.path_web``$file.name_system`" w="230" h="150"}" id="object_{$file.id}" uid="{$file.id}" class="image_item"/>
{/if}
