var jQ = false;
function initJQ() {
	if (typeof (jQuery) == 'undefined') {
		if (!jQ) {
			jQ = true;
			let _jquery = document.createElement('script');
			_jquery.type = "text/javascript";
			_jquery.src = '//code.jquery.com/jquery-3.3.1.min.js';
			document.getElementsByTagName('head')[0].appendChild(_jquery);
		}
		setTimeout('initJQ()', 50);
	} else {
		(function ($) {
			$(function () {
				
			})
		})(jQuery)
	}
}
initJQ();