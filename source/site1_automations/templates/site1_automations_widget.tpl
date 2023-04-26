{literal}
var jQ = false;
function initSW() {
	if (typeof (jQuery) == 'undefined'){
		if (!jQ) {
			jQ = true;
			let _jquery = document.createElement('script');
			_jquery.type = "text/javascript";
			_jquery.src = '//code.jquery.com/jquery-3.3.1.min.js';
			document.getElementsByTagName('head')[0].appendChild(_jquery);
		}
		setTimeout('initSW()', 50);
		return;
	}
	(function ($) {
		$(function () {
			var _element=$('[src="{/literal}{$strHost}{literal}"]');
			_result=$( '.cnm-lpb-statistic' ).length ? $( _element ) : $( _element ).after( '<iframe src="{/literal}{$strHost}{literal}?action=iframe&c='+$( _element ).data('code')+'" sandbox="allow-scripts allow-same-origin allow-top-navigation allow-forms allow-popups allow-pointer-lock allow-popups-to-escape-sandbox"></iframe>' );
			$.ajax({
				method: "POST",
				url: "{/literal}{$strHost}{literal}",
				data: { action: 'set' }
			}).done(function (result){
				result=JSON.parse( result );
				if( typeof  result.s != 'undefined' && typeof  result.c != 'undefined' ){
					_result.next().text( result.c+' / '+result.s );
					_result.next().fadeIn( 'fast' );
				}
			});
		});
	})(jQuery);
}
initSW();
{/literal}