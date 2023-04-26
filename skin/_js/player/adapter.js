	$$('.galery_item').each ( function (elt) {
		var height;
		if ( elt.classList.contains('audio') ) {
			height = 20;
			elt.getParent().getParent().setStyle('height','50px');
		}else if ( elt.classList.contains('video') ) {
			height = 150;
		}else{
			height = 150;
		}
		swfobject.embedSWF("/skin/_js/player/NonverBlaster.swf", "mixPlayer_"+elt.get('uid'), "230", height, "2", "/skin/_js/player/expressinstall.swf", {//flashvars
			"mediaURL":elt.get('url'),// mp3 mov & others
			"teaserURL":"",
			"allowSmoothing":"true",
			"autoPlay":"false",
			"buffer":"6",
			"showTimecode":"false",
			"loop":"false",
			"controlColor":"0x00ff00",
			"controlBackColor":"0xffffff",
			"scaleIfFullScreen":"true",
			"showScalingButton":"true",
			"defaultVolume":"50",
			"crop":"false"
		},{//params
			"menu":"true",
			"allowFullScreen":"true",
			"allowScriptAccess":"always"
		},{//attributes
			"id":"object_"+elt.get('uid'),
			"bgcolor":"#ffffff"
		});
	});