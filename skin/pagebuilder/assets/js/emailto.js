var config = require('./modules/config');

(function() {
	"use strict";
	var emailto = {
		init : function(){

			$('[data-action="sentapi"]').off('submit').on('submit', function(e){
				$.ajax({
					url: $(this).prop('action'),
					type: "POST",
					data: $(this).serialize(),
					dataType: "json"
				});
				let _message = $(this).find('[name="_confirmation"]').prop('value');
				$(this).html(`<div class="alert alert-success" role="alert">${_message}</div>`);
				return false;
			});
		}
	}

	emailto.init();
	exports.emailto = emailto;
}());