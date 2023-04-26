(function () {
	"use strict";

	var siteBuilder = require('./builder.js');
	var appUI = require('../shared/ui.js').appUI;
	var utils = require('../shared/utils.js');
	let publisher = require('../../vendor/publisher');

	var templates = {
		
		ulTemplates: document.querySelectorAll('[data-sidesecond="templates"] .sideSecondInner ul'),
		buttonSaveTemplate: document.getElementById('saveTemplate'),
		buttonSave: document.getElementById('savePage'),
		modalDeleteTemplate: document.getElementById('delTemplateModal'),
	
		init: function() {
											
			//make template thumbs draggable
			//this.makeDraggable();
			
			$(this.buttonSaveTemplate).on('click', this.saveTemplate);
			
			//listen for the beforeSave event
			$('body').on('siteDataLoaded', function(){
				
				if( siteBuilder.site.is_admin === 1 ) {
				
					//templates.addDelLinks();
					$(templates.modalDeleteTemplate).on('show.bs.modal', templates.prepTemplateDeleteModal);
				
				}
			});  
			
			$('.templ[data-template-id]').on('click', function(e){
				templates.clickTemplate(e);
			});

			if( $('#savePage ul').length ) {
				$('#savePage a').on('click', this.saveAsTemplate);
			}

			$('#selectCategory').on('change', () => siteBuilder.site.setPendingChanges(true));
		},

		saveAsTemplate: e => {
			e.preventDefault();
			e.stopPropagation();

			console.log( siteBuilder.site.data.id );

			$.ajax({
				method: "POST",
				url: appUI.dataUrls.saveAsTemplate,
				data: { site_id: siteBuilder.site.data.id },
				dataType : 'json'
			}).done( response => {

				console.log( response.status === 'success', response.status, response );
				if( response.status === 'success' ) {
					$('#successModal .modal-body').html( $(response.responseHTML) );
					$('#successModal').modal('show');
				} else {
					$('#errorModal .modal-body').html( $(response.responseHTML) );
					$('#errorModal').modal('show');
				}
			});
		},
		
		clickTemplate: function(e){
			swal({
				title: "Are you sure?",
				text: "All data will be overwritten!",
				icon: "warning",
				buttons: {
					cancel: true,
					confirm: "Confirm",
				},
				dangerMode: true,
			}).then((result) => {
				if(!result) return;

				$.ajax({
					url: appUI.dataUrls.uploadTemplate,
					type: "POST",
					dataType: "json",
					data: {
						templateid : $(e.currentTarget).data('template-id'),
						currentid : $('[name="siteID"]').prop('value')
					}
				}).done(function(data){
					if(data.responseCode === 1){
						window.location.reload();
					} else {
						swal("Error", "Reload page and try again.", "error");
					}
					$('body').trigger('siteDataLoaded');
					publisher.publish('siteDataLoaded');
				});
			});
			console.log(e);
		},
		
		/*
			makes the template thumbnails draggable
		*/
		makeDraggable: function() {
			
			$(this.ulTemplates).find('li').each(function(){
		
				$(this).draggable({
					helper: function() {
					return $('<div style="height: 100px; width: 300px; background: #F9FAFA; box-shadow: 5px 5px 1px rgba(0,0,0,0.1); text-align: center; line-height: 100px; font-size: 28px; color: #16A085"><span class="fui-list"></span></div>');
					},
					revert: 'invalid',
					appendTo: 'body',
					connectToSortable: '#pageList > ul:visible',
					start: function(){
						
						siteBuilder.site.activePage.transparentOverlay('on');

					},
					stop: function () {

						siteBuilder.site.activePage.transparentOverlay('off');

					}
				
				});
				
				//disable click events on child ancors
				$(this).find('a').each(function(){
					$(this).unbind('click').bind('click', function(e){
						e.preventDefault();
					});
				});
			
			});
			
		},
		
		
		/*
			Saves a page as a template
		*/
		saveTemplate: function(e) {
						
			e.preventDefault();
						
			//disable button
			$(templates.buttonSaveTemplate).addClass('disabled');
			$(templates.buttonSave).find('.bLabel').text( $(templates.buttonSave).attr('data-loading') )
			$(templates.buttonSave).addClass('disabled');

			//remove old alerts
			$('#errorModal .modal-body > *, #successModal .modal-body > *').each(function(){
				$(this).remove();
			});

			//remove all tick activations
			$('.tick[data-state="initialised"]').each(function(){
				$(this).remove();
			});
			
			siteBuilder.site.prepForSave(true);

			var serverData = {};
			serverData.pages = siteBuilder.site.sitePagesReadyForServer;
			serverData.siteData = siteBuilder.site.data;
			serverData.fullPage = utils.custom_base64_encode("<html>"+$(siteBuilder.site.skeleton).contents().find('html').html()+"</html>");
			if( siteBuilder.site.pagesToDelete.length > 0 ) {
				serverData.toDelete = siteBuilder.site.pagesToDelete;
			}
			
			//are we updating an existing template or creating a new one?
			serverData.templateID = siteBuilder.builderUI.templateID;

			// template category?
			let selectCategory = $('#selectCategory');

			if ( selectCategory.length ) {
				serverData.categoryID = selectCategory.val();
			}
			
			$.ajax({
				url: appUI.dataUrls.tsave,
				type: "POST",
				dataType: "json",
				data: serverData
			}).done(function(res){
				//enable button			
				$(templates.buttonSaveTemplate).removeClass('disabled');
				$(templates.buttonSave).removeClass('disabled');
				$(templates.buttonSave).find('.bLabel').text( $(templates.buttonSave).attr('data-label') );
				
				if( res.responseCode === 0 ) {
					
					$('#errorModal .modal-body').append( $(res.responseHTML) );
					$('#errorModal').modal('show');
					//siteBuilder.builderUI.templateID = 0;
				
				} else if( res.responseCode === 1 ) {
					
					
					$('#successModal .modal-body').append( $(res.responseHTML) );
					$('#successModal').modal('show');
					siteBuilder.builderUI.templateID = res.templateID;

					let _activePage = siteBuilder.site.activePage.name;
					let siteBuilderUtils = require('../shared/utils.js');
					_activePage = siteBuilderUtils.getParameterByName('p');
					
					
					
					$.getJSON(appUI.dataUrls.siteData, function(data) {

						siteBuilder.site.customFonts = data.fonts;
						if ( data.language ) window.language = data.language;
						if( data.site !== undefined ) {
							siteBuilder.site.data = data.site;
						}
		
						if( data.pages !== undefined ) {
							siteBuilder.site.pages = data.pages;
						}
		
						siteBuilder.site.is_admin = data.is_admin;

						if( $('#pageList').size() > 0 ) {
							$('#pageList, #pages').empty();
							siteBuilder.builderUI.populateCanvas();

							siteBuilder.site.sitePages.forEach(function(page){
								if(page.name == _activePage){
									page.selectPage();
								}
							});
						}
						
						$('body').trigger('siteDataLoaded');
						publisher.publish('siteDataLoaded');
					});

					//no more pending changes
					siteBuilder.site.setPendingChanges(false);
				}
				
				
				
			});
		
		},
		
		save: function() {
						
			//disable button
			$(templates.buttonSaveTemplate).addClass('disabled');
			$(templates.buttonSave).find('.bLabel').text( $(templates.buttonSave).attr('data-loading') )
			$(templates.buttonSave).addClass('disabled');

			//remove old alerts
			$('#errorModal .modal-body > *, #successModal .modal-body > *').each(function(){
				$(this).remove();
			});
			
			siteBuilder.site.prepForSave(true);

			var serverData = {};
			serverData.pages = siteBuilder.site.sitePagesReadyForServer;
			serverData.siteData = siteBuilder.site.data;
			serverData.fullPage = utils.custom_base64_encode("<html>"+$(siteBuilder.site.skeleton).contents().find('html').html()+"</html>");
			if( siteBuilder.site.pagesToDelete.length > 0 ) {
				serverData.toDelete = siteBuilder.site.pagesToDelete;
			}
			
			//are we updating an existing template or creating a new one?
			serverData.templateID = siteBuilder.builderUI.templateID;

			// template category?
			let selectCategory = $('#selectCategory');

			if ( selectCategory.length ) {
				serverData.categoryID = selectCategory.val();
			}
			
			return $.ajax({
				url: appUI.dataUrls.tsave,
				type: "POST",
				dataType: "json",
				data: serverData
			});
		},
		
		/*
			adds DEL links for admin users
		*/
		addDelLinks: function() {
			
			$(this.ulTemplates).find('li').each(function(){
			
				var newLink = $('<a href="#delTemplateModal" data-toggle="modal" data-pageid="'+$(this).attr('data-pageid')+'" class="btn btn-danger btn-sm">DEL</a>');
				$(this).append( newLink );
				
			});
			
		},
			
		
		/*
			preps the delete template modal
		*/
		prepTemplateDeleteModal: function(e) {
						
			var button = $(e.relatedTarget); // Button that triggered the modal
		  	var pageID = button.attr('data-pageid'); // Extract info from data-* attributes
		  	
		  	$('#delTemplateModal').find('#templateDelButton').attr('href', $('#delTemplateModal').find('#templateDelButton').attr('href')+"/"+pageID);
		}
			
	};
	
	templates.init();

	exports.templates = templates;
	
}());