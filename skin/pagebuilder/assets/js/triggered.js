(function() {
	"use strict";

	let _flgTriggered = false;

	document.addEventListener("DOMContentLoaded", function() {
		$('[data-triggered-optin="true"] button, [data-triggered-optin="true"] input[type="submit"]').on('click', function(e){
			if( ! _flgTriggered) {
				e.preventDefault();
				_flgTriggered = true;
	
				/** Show hidden elements form */
				$(this)
					.closest('[data-triggered-optin="true"]')
					.find('input, textarea, label')
					.slideDown('fast');
			}
		});
	});
}());