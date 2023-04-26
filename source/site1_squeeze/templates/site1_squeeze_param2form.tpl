{literal}
(function() {
	var params = {},
	capture = void 0,
	query = window.location.search.substring(1),
	whitespace = /\+/g,
	regex = /([^&=]+)=?([^&]*)/g,
	decode = function(s) {
		return decodeURIComponent(s.replace(whitespace, " "));
	};
	while (capture = regex.exec(query)) {
		var key = decode(capture[1]),
		value = decode(capture[2]);
		if (value !== '') {
			params[key] = value;
		}
	}
	this.params = params;
}).call(this);

var jQ = false;
function initGC() {
	if (typeof (jQuery) == 'undefined'){
		if (!jQ) {
			jQ = true;
			let _jquery = document.createElement('script');
			_jquery.type = "text/javascript";
			_jquery.src = '//code.jquery.com/jquery-3.3.1.min.js';
			document.getElementsByTagName('head')[0].appendChild(_jquery);
		}
		setTimeout('initGC()', 50);
		return;
	}
	(function ($) {
		$(function () {
			jQuery.each($('form#form-{/literal}{$smarty.get.formid}{literal} [name]'), function(inputid,inputvalue){
				if( $(inputvalue).attr('type')=='hidden' ){
					jQuery.each(window.params, function(eltname,eltvalue){
						if( eltname == $(inputvalue).attr('name') ){
							$(inputvalue).attr('value', eltvalue);
						}
					});
					}
			});
		});
	})(jQuery);
}
initGC();
{/literal}