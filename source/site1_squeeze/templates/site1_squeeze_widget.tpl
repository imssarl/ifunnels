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
			var _element=$('[src="{/literal}{Zend_Registry::get( 'config' )->domain->url}{literal}/funnels/widget/"]');
			_result=$( '.cnm-lpb-statistic' ).length ? $( _element ) : $( _element ).after( '<span class="cnm-lpb-statistic">&nbsp;</span>' );
			$.ajax({
				method: "POST",
				url: "{/literal}{Zend_Registry::get( 'config' )->domain->url}{literal}/funnels/widget/",
				data: { action: 'get' }
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