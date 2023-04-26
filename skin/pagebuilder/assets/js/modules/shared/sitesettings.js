(function () {
	"use strict";

	var appUI = require('./ui.js').appUI;
	var publisher = require('../../vendor/publisher');
	let siteBuilder = require('../builder/builder.js');
	const {protectedObj} = require('../protected/protected.js');

	var siteSettings = {
		buttonSiteSettings2: $('.siteSettingsModalButton'),
		buttonSaveSiteSettings: document.getElementById('saveSiteSettingsButton'),
		selectHostingOptions: {},
		modalSiteSettings: document.getElementById('siteSettings'),
		selectHostingOptionsId: '#select_hostingOptions',

		init: function() {
			//$(this.buttonSiteSettings).on('click', this.siteSettingsModal);
			this.buttonSiteSettings2.on('click', this.siteSettingsModal);
			$(this.buttonSaveSiteSettings).on('click', this.saveSiteSettings);

			$(this.modalSiteSettings).on('change', this.selectHostingOptionsId, function (e) {
				this.switchHostingOption(e);
			}.bind(this));
		},

		/*
			loads the site settings data
		*/
		siteSettingsModal: function(e) {
			e.preventDefault();

			$('#siteSettings').modal('show');

			//destroy all alerts
			$('#siteSettings .modal-alerts .alert').fadeOut(500, function(){
				$(this).remove();
				
			});

			$('#siteSettings .modal-body-content > *').show();
			$('#cancelSiteSettingsButton > span').eq(1).html('Cancel & Close');

			$('#saveSiteSettingsButton').show();
			//set the siteID
			$('input#siteID').val( $(this).attr('data-siteid') );
		},

		/*
			saves the site settings
		*/
		saveSiteSettings: function() {

			// destroy all alerts
			$('#siteSettings .alert').fadeOut(500, function(){
				$(this).remove();
			});

			// disable button
			$('#saveSiteSettingsButton').addClass('disabled');

			// hide form data
			$('#siteSettings .modal-body-content > *').hide();

			// show loader
			$('#siteSettings .loader').show();

			let theData = $('form#siteSettingsForm').serializeArray();

			$.ajax({
				url: $('form#siteSettingsForm').prop('action'),
				type: 'post',
				dataType: 'json',
				data: theData
			}).done( function( ret ) {
				if( ret.responseCode === 0 ) { // error
					$('#siteSettings .loader').fadeOut(500, function(){
						$('#siteSettings .modal-alerts').append( ret.responseHTML );
						// show form data
						$('#siteSettings .modal-body-content > *').show();
						// enable button
						$('#saveSiteSettingsButton').removeClass('disabled');
					});
				} else if( ret.responseCode === 1 ) { // all is well
					publisher.publish("onSiteDetailsSaved", theData); // needed to update the siteData object in the builder.js module

					$('#siteSettings .loader').fadeOut(500, function(){

						protectedObj.setProtection();

						// update site name in top menu
						$('#siteTitle').text( ret.siteName );

						$('#siteSettings .modal-alerts').append( ret.responseHTML );
						//$('#siteSettings .modal-body-content > *').show();
						// enable button
						$('#saveSiteSettingsButton').removeClass('disabled').hide();
						$('#cancelSiteSettingsButton > span').eq(1).html('Close');

						// update the site name in the small window
						$('#site_' + ret.siteID + ' .window .top b').text( ret.siteName );
					});
				}
			});
		},
	};

	siteSettings.init();
}());