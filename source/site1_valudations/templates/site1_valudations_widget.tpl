{literal}
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
				$('head').append('<link rel="stylesheet" type="text/css" href="{/literal}{Zend_Registry::get( 'config' )->domain->url}{literal}/skin/_css/validate/validate.css" />');
				let _methods = {
					validateEmail: function (email) {
						var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
						return re.test(String(email).toLowerCase());
					}
				},
					_email = null,
					_element = null;
				$('[name="email"],[type="email"]').each(function(){
					$(this).after('<div class="cnm-status-validate"></div>');
					$(this).next('.cnm-status-validate').css({
						'left' : $(this).position().left,
						'top' : $(this).position().top - 50
					});
				});
				$('form').data('submit', false).on('submit', function(){
					if(!$(this).data('submit')){
						return false;	
					}
				});
				$('[name="email"],[type="email"]').on('keypress change', function (){
					_element = this;
					var _buttonS=$(_element).closest('form').find('input[type="submit"],button[type="submit"]');
					_stopS=_buttonS.next( '.cnm-close-submit' ).length ? _buttonS.next() : _buttonS.after( '<div class="cnm-close-submit"></div>' ).next();
					_stopS.css({
						'position': 'absolute',
						'z-index': '999999',
						'background-color': 'transparent',
						'width': _buttonS[0].offsetWidth,
						'height': _buttonS[0].offsetHeight,
						'left': _buttonS[0].offsetLeft,
						'top': _buttonS[0].offsetTop
					});
					_buttonS.prop('disabled', 'disabled');
				});
				$('[name="email"],[type="email"]').on('blur', function (){
					if($(this).prop('value').trim() && !_methods.validateEmail($(this).prop('value'))){
						let self = this;
						$(this).next('.cnm-status-validate').addClass('error').html('<i class="icon ion-close"></i>This email address is invalid. Please try another one').fadeIn('fast');
						setTimeout(function(){ $(self).next('.cnm-status-validate').fadeOut('fast', function(){
							$(this).removeClass('error');
						}); }, 3000 );
					}
					if (_email !== $(this).prop('value') && _methods.validateEmail($(this).prop('value'))) {
						_email = $(this).prop('value');
						_element = this;
						_result = $(this).next( '.cnm-status-validate' ).length ? $(_element) : $(_element).after( '<div class="cnm-status-validate"></div>' );
						$.ajax({
							method: "POST",
							type: "POST",
							url: "{/literal}{Zend_Registry::get( 'config' )->domain->url}{literal}/validations/request/",
							beforeSend: function () {
								$(_element).prop('disabled', 'disabled');
								$('.cnm-status-validate').html('<img src="{/literal}{Zend_Registry::get( 'config' )->domain->url}{literal}/skin/_css/validate/25.svg" />Your email address is being verified').fadeIn('fast');
							},
							data: {
								email: _email,
								code: '{/literal}{$code}{literal}'
							}
						}).done(function (result) {
							result = JSON.parse( result ); 
							$(_element).prop('disabled', false);
							if( ["deliverable"].indexOf( result ) != -1 ){
								_result.next().addClass('success').html('<i class="icon ion-checkmark"></i>Valid Email Address. You can now submit the form');
								$(_element).closest('form').find('input[type="submit"],button[type="submit"]').prop('disabled', false);
								$(_element).closest('form').find('input[type="submit"],button[type="submit"]').next('.cnm-close-submit').remove();
							}else if( ["undeliverable", "risky", "unknown"].indexOf( result ) != -1 ) {
								_result.next().addClass('error').html('<i class="icon ion-close"></i>This email address is invalid. Please try another one');
							}else{
								_result.next().addClass('error').html('<i class="icon ion-close"></i>'+result);
							}
							setTimeout(function(){ $(_element).next('.cnm-status-validate').fadeOut('fast', function(){
								$(this).removeClass('error').removeClass('success').html('');
							}); }, 3000 );
						});
					}
				});
			})
		})(jQuery)
	}
}
initJQ();
{/literal}