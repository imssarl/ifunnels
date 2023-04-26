/**
 * global var uid, pbid
 */

(function() {
	"use strict";
	var statistic = {
		init : function(){
			let _data = {
				url : window.location.href, 
				uid : uid,
				pbid : pbid,
				pagename : pagename,
			};
			$.getJSON('https://api.ipify.org?format=jsonp&callback=?', function(data) {
				_data.ip = data.ip;

				$.post("//fasttrk.net/services/pb_subscribers.php", _data).done(function( result ) {
					console.log(result);
				});
			});

			$('a:not([href="#"])').on('click', function(e){
				$.post("//fasttrk.net/services/pb_conversion.php", _data).done(function( result ) {
					console.log(result);
				});
			});

			$('form').on('submit', function(){
				$.post("//fasttrk.net/services/pb_conversion.php", _data).done(function( result ) {
					console.log(result);
				});
			});
		}
	}

	statistic.init();
	exports.statistic = statistic;
}());