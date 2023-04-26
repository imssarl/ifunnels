<div style="float:left;width:600px;">
<div><a href="{url name='site1_video_manager' action='multibox'}" class="mb" title="Import from Video Manager">Import from Video Manager</a></div>
<form method="post" action="" class="wh" id="create_widget">
	<p>Please fill in the following fields in order to submit your content, video, URLs to social networks and social bookmarking services.</p>
	<fieldset>
		<legend>Bookmark settings</legend>
		<p>
			<small>For social networks ("Post" Tab in the widget on the right) please enter the content you want to submit (html, or embed code of your videos)</small>
			<label for="TEXTAREA_ID"><span>Content:</span></label>
			<textarea id="TEXTAREA_ID" rows="5" cols="50"></textarea>
		</p>
		<p>
			<small>For social bookmarks (optional if you don't use the "Bookmark" tab in the widget on the right) please enter the url to bookmark and share</small>
			<label for="TEXTAREA2_ID"><span>URL:</span></label>
			<textarea id="TEXTAREA2_ID" rows="2" cols="50">{$smarty.get.url}</textarea>
		</p>
		<p>
			<small>Some services let you add a Title (for example: Yahoo bookmarks allows it) for your submission</small>
			<label for="TEXTAREA3_ID"><span>Title:</span></label>
			<textarea id="TEXTAREA3_ID" rows="2" cols="50">{$smarty.get.title}</textarea>
		</p>
	</fieldset>
	<p><input type="submit" value="Submit to Widget" class="button" /></p>
	<p>Now, please select the Post (for social networks) or Bookmark (for social bookmarking) tab in the widget on the right side, then select the social network or social bookmarking service, where you want to submit your post / URL, and click on its icon in the widget.</p>
</form>
</div>
<div id="divWildfirePost" style="float:left;margin-left:40px;"></div>
<div class="clear"></div>
<script language="javascript" src="//cdn.gigya.com/wildfire/js/wfapiv2.js"></script>
<script type="text/javascript">
{literal}
var ui='<config><display showEmail="false" useTransitions="true" showBookmark="true"></display><body corner-roundness="8;8;8;8" font="Verdana"><background gradient-color-begin="#ADC8FF"></background><controls><snbuttons type="textUnder" background-color="#FFFFFF" over-background-color="#FFFFFF" color="#376DDA" corner-roundness="0;10;0;10" bold="false" over-color="#0D1B6D"></snbuttons><textboxes><codeboxes color="#6A6A6A" frame-color="#1B366D" background-color="#F4F4F4"></codeboxes></textboxes><buttons gradient-color-begin="#0099FF" gradient-color-end="#223276" color="#FFFFFF" corner-roundness="0;8;0;8" bold="true" over-gradient-color-begin="#0099FF" over-gradient-color-end="#0099FF"></buttons><servicemarker gradient-color-begin="#F4F4F4" gradient-color-end="#F4F4F4"></servicemarker></controls><texts color="#FFFFFF" bold="true"><privacy color="#AAAAAA"></privacy><labels color="#1B366D"></labels><messages color="#F4F4F4" background-color="#1B366D"></messages><links color="#376DDA" underline="false" over-color="#1B366D"></links></texts></body></config>';

var pconf={
	defaultContent: 'TEXTAREA_ID',
	defaultBookmarkURL: 'TEXTAREA2_ID',
	widgetTitle: 'TEXTAREA3_ID',
	UIConfig: ui
};
Wildfire.initPost('678281', 'divWildfirePost', 500, 500, pconf);

var placeParam={};
var placeDo=function() {
	if ( typeof(placeParam.body)!='undefined' ) {
		$('TEXTAREA_ID').value=pconf.defaultContent=placeParam.body;
	}
	if ( typeof(placeParam.url_of_video)!='undefined' ) {
		$('TEXTAREA2_ID').value=pconf.defaultBookmarkURL=placeParam.url_of_video;
	}
	if ( typeof(placeParam.video_title)!='undefined' ) {
		$('TEXTAREA3_ID').value=pconf.widgetTitle=placeParam.video_title;
	}
	Wildfire.initPost('678281', 'divWildfirePost', 500, 500, pconf);
	placeParam={};
}

$('create_widget').addEvent('submit', function(e) {
	e.stop();
	var pconf={
		defaultContent: $('TEXTAREA_ID').value,
		defaultBookmarkURL: $('TEXTAREA2_ID').value,
		widgetTitle: $('TEXTAREA3_ID').value,
		UIConfig: ui
	};
	Wildfire.initPost('678281', 'divWildfirePost', 500, 500, pconf);
});

var multibox={};
window.addEvent('domready', function() {
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});
{/literal}
</script>