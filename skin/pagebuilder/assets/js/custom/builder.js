/*
	Use this module to load custom JS in the builder page
*/

(function () {
	"use strict";

	if(showModal){
		$('#newSiteModal').modal('show');
	}
	let appUI = require('../modules/shared/ui.js').appUI;

	var sites = {
		wrapperSites: document.getElementById('sites'),
		selectUser: document.getElementById('userDropDown'),
		selectSort: document.getElementById('sortDropDown'),
		buttonDeleteSite: document.getElementById('deleteSiteButton'),
		buttonsDeleteSite: document.querySelectorAll('.deleteSiteButton'),
		divSites: document.getElementById('sites'),
		buttonSearchSites: document.getElementById('buttonSearchSites'),
		inputSearchSites: document.getElementById('inputSearchSites'),
		ulCatList: document.getElementById('ulCatList'),
		ulTemplateList: document.getElementById('ulTemplateList'),
		divEmptyCanvas: document.getElementById('divEmptyCanvas'),
		linkNewSite: document.getElementById('linkNewSite'),

		/** New Page Modal */
		npm: document.querySelector('.newPageModal'),
		linkNewPage: document.getElementById('linkNewPage'),
		
		init: function() {
			/** Set default value */
			window.storage.setData('pageId', 'new');

			$(this.ulCatList).on('click', 'button:not(.active)', function () {
				let catID = this.getAttribute('data-cat-id');
				// button
				$(sites.ulCatList).find('button').removeClass('active');
				$(this).addClass('active');

				sites.deselectTemplate();

				// templates
				if ( catID === 'canvas' ) {
					$(sites.linkNewSite).removeClass('disabled');
					$('.templateList').hide();
					$(sites.divEmptyCanvas).fadeIn();
				} else {
					$(sites.linkNewSite).addClass('disabled');
					$(sites.divEmptyCanvas).hide();
					$('.templateList').show();
					$('.templateList li').hide();
					$('.templateList li[data-cat-id="' + catID + '"]').fadeIn();
				}

			});

			$(sites.ulTemplateList).on('click', 'a', function () {
				let active = this.classList.contains('active');
				$(sites.linkNewSite).removeClass('disabled');
				sites.deselectTemplate();
				if ( !active ) {
					this.classList.add('active');
					sites.activateTemplate(this.getAttribute('data-template-id'));
				}
				return false;
			});

			sites['npmUlCategory'] = sites.npm.querySelector('[data-list="category"]');
			sites['npmTemplateWrapper'] = sites.npm.querySelector('.templateWrapper');
			sites['npmCanvas'] = sites.npm.querySelector('.divEmptyCanvas');
			sites['npmTemplateList'] = sites.npm.querySelector('.templateList');
			sites['npmTemplateListItems'] = sites.npmTemplateList.querySelectorAll('.templateList__item a');

			$(sites.npmUlCategory).on('click', 'button', e => {
				e.preventDefault();
				if( e.currentTarget.classList.contains( 'active' ) ) return;

				const categoryId = e.currentTarget.getAttribute( 'data-cat-id' );

				sites.npmUlCategory.querySelectorAll('button').forEach( button => button.classList.remove('active') );
				e.currentTarget.classList.add('active');

				if( categoryId == 'canvas' ) {
					$(sites.npmCanvas).stop(true, true).fadeIn();
					$(sites.npmTemplateList).stop(true, true).fadeOut();
					sites.linkNewPage.classList.remove('disabled');
					window.storage.setData('pageId', 'new');
				} else {
					sites.npmTemplateList.querySelectorAll('.templateList__item').forEach(template => template.style.display = 'none');
					sites.npmTemplateList.querySelectorAll(`.templateList__item[data-cat-id="${categoryId}"]`).forEach(template => template.style.display = 'flex');

					sites.linkNewPage.classList.add('disabled');
					$(sites.npmCanvas).stop(true, true).fadeOut();
					$(sites.npmTemplateList).stop(true, true).fadeIn();
				}
			});

			$(sites.npmTemplateListItems).on('click', e => {
				e.preventDefault();

				if( ! e.currentTarget.classList.contains('active') ) {

					sites.npmTemplateListItems.forEach(a => a.classList.remove('active'));

					e.currentTarget.classList.add('active');
					sites.linkNewPage.classList.remove('disabled');

					window.storage.setData( 'pageId', e.currentTarget.getAttribute('data-page-id') );
				}
			});

			$(sites.linkNewPage).on('click', e => {
				e.preventDefault();
				sites.deselectPage();
			});
		},

		deselectPage: function () {
			$(sites.linkNewPage).removeClass('disabled');
			$(sites.npmUlCategory).find('button').removeClass('active');
			$(sites.npmUlCategory).find('button[data-cat-id="canvas"]').addClass('active');
			$(sites.npmCanvas).fadeIn();
			$(sites.npmTemplateList).fadeOut();
			$(sites.npmTemplateListItems).removeClass('active');

			window.storage.setData('pageId', 'new');
		},

		/*
			Un-selects the template
		*/
		deselectTemplate: function () {
			$(sites.linkNewSite).removeClass('disabled');
			sites.activateTemplate(0);
			$(sites.ulTemplateList).find('a').removeClass('active');
		},

		/*
			Selects a template
		*/
		activateTemplate: function (templateID) {
			if ( templateID === 0 ) sites.linkNewSite.href = appUI.dataUrls.create + "?new";
			else sites.linkNewSite.href = appUI.dataUrls.create + "?new&template=" + templateID;
		},
	};

	sites.init();
}(storage));