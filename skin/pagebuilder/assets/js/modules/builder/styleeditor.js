(function () {
	"use strict";

	let canvasElement = require('./canvasElement.js').Element;
	let bConfig = require('../config.js');
	let jsCalendar = require('./jscalendar.js');
	let appUI = require('../shared/ui.js').appUI;
	let siteBuilder = require('./builder.js');
	let publisher = require('../../vendor/publisher');
	let utils = require('../shared/utils.js');
	const { component } = require('./component.js');
	const flatpickr = require("flatpickr");
	const moment = require("moment");
	const vanillaTextMask = require("vanilla-text-mask");
	const _maskIstance = null;
	const webinar = require('./webinar');
	const helper = require('./../../helper');
	const bump = require('./bump');
	require('./nft');

	var styleeditor = {

		buttonSaveChanges: document.getElementById('saveStyling'),
		activeElement: {}, //holds the element currenty being edited
		allStyleItemsOnCanvas: [],
		_oldIcon: [],
		styleEditor: document.getElementById('styleEditor'),
		formStyle: document.getElementById('stylingForm'),
		buttonRemoveElement: document.getElementById('deleteElementConfirm'),
		buttonCloneElement: document.getElementById('cloneElementButton'),
		buttonDelElement: document.getElementById('removeElementButton'),
		buttonResetElement: document.getElementById('resetStyleButton'),
		selectLinksInernal: document.getElementById('internalLinksDropdown'),
		selectLinksPages: document.getElementById('pageLinksDropdown'),
		videoInputYoutube: document.getElementById('youtubeID'),
		videoInputURL: document.getElementById('videoURL'),
		videoInputVimeo: document.getElementById('vimeoID'),
		inputCustomLink: document.getElementById('internalLinksCustom'),
		linkImage: null,
		linkIcon: null,
		//	inputLinkText: document.getElementById('linkText'),
		selectIcons: document.getElementById('icons'),
		buttonDetailsAppliedHide: document.getElementById('detailsAppliedMessageHide'),
		buttonCloseStyleEditor: document.querySelector('#styleEditor button.close'),
		ulPageList: document.getElementById('pageList'),
		responsiveToggle: document.getElementById('responsiveToggle'),
		theScreen: document.getElementById('screen'),
		inputLinkActive: document.getElementById('checkboxLinkActive'),

		openTargetBlank: document.getElementById('checkboxTargetBlank'),

		settingAttrId: document.getElementById('settingAttrId'),

		formEffects: document.getElementById('effectsForm'),
		inputEffectDelay: document.getElementById('intDelay'),
		inputEffectAnimation: document.getElementById('flgAnimation'),

		checkboxEmailForm: document.getElementById('checkboxEmailForm'),
		inputEmailFormTo: document.getElementById('inputEmailFormTo'),
		textareaCustomMessage: document.getElementById('textareaCustomMessage'),
		checkboxCustomAction: document.getElementById('checkboxCustomAction'),
		inputCustomAction: document.getElementById('inputCustomAction'),
		checkboxUseLeadChannels: document.getElementById('checkboxUseLeadChannels'),
		selectLeadChannels: document.getElementById('selectLeadChannels'),
		textareaCustomMessageLeadChannel: document.getElementById('textareaCustomMessageLeadChannel'),
		inputRedirectTo: document.getElementById('inputRedirectTo'),
		selectPages: document.getElementById('selectPages'),
		checkboxTriggeredOptin: document.getElementById('checkboxTriggeredOptin'),
		checkboxTriggeredFields: document.getElementById('checkboxTriggeredFields'),

		textareaCodeField: document.getElementById('code--field'),
		enterCodeSave: document.getElementById('enterCodeSave'),

		btnGradientSave: document.getElementById('btnGradientSave'),
		textareaGradxCode: document.getElementById('gradx_code'),

		inputCombinedGallery: document.getElementById('inputCombinedGallery'),
		inputImageTitle: document.getElementById('inputImageTitle'),
		inputImageAlt: document.getElementById('inputImageAlt'),

		checkboxSliderAutoplay: document.getElementById('checkboxSliderAutoplay'),
		checkboxSliderPause: document.getElementById('checkboxSliderPause'),
		selectSliderAnimation: document.getElementById('selectSliderAnimation'),
		inputSlideInterval: document.getElementById('inputSlideInterval'),
		selectSliderNavArrows: document.getElementById('selectSliderNavArrows'),
		selectSliderNavIndicators: document.getElementById('selectSliderNavIndicators'),

		inputZoomLevel: document.getElementById('inputZoomLevel'),
		textareaAddress: document.getElementById('textareaAddress'),
		textareaInfoMessage: document.getElementById('textareaInfoMessage'),
		checkBoxMapBW: document.getElementById('checkBoxMapBW'),

		/**
		 * Shape Dividers
		 */

		shapePositionDropdown: document.getElementById('dividersDropdown'),
		shapeHeight: document.getElementById('shape-height'),
		shapeResponsive: document.getElementById('shape-responsive'),
		shapeTablet: document.getElementById('shape-tablet'),
		shapeMobile: document.getElementById('shape-mobile'),
		shapePx: document.getElementById('shape-px'),
		shapeProcent: document.getElementById('shape-procent'),
		shapeZIndex: document.getElementById('shape-z-index'),
		shapeOpacity: document.getElementById('shape-opacity'),
		shapeFlip: document.getElementById('shape-flip'),
		shapeRatio: document.getElementById('shape-ratio'),
		shapeSafe: document.getElementById('shape-safe'),
		shapeSave: document.getElementById('btnShapeSave'),
		shapeColor: document.getElementById('shape-color'),
		btnDeleteShape: document.getElementById('btnDeleteShape'),

		/**
		 * Quiz
		 */
		quizAction: document.getElementById('quizAction'),
		quizUrl: document.getElementById('quizUrl'),
		quizThanks: document.getElementById('quizThanks'),
		quizPopup: document.getElementById('quizPopup'),

		/** Checkout */
		checkoutSwitcher: document.getElementById('checkoutSwitcher'),
		checkoutSettings: document.querySelector('div[data-checkout]'),
		checkoutSettingsDisplay: document.getElementById('checkoutDisplay'),
		checkoutSettingsRedirect: document.getElementById('checkoutRedirect'),
		checkoutSettingsMembership: document.getElementById('membershipPlans'),

		/** Webinar */
		btnChatSave: document.getElementById('btnChatSave'),

		/** Video */
		buttonColor: document.getElementById('button_color'),

		/** Bump Order */
		bumpSwitcher: document.getElementById('bumpSwitcher'),
		bumpContainer: document.querySelector('div[data-bump]'),
		

		init: function () {

			publisher.subscribe('closeStyleEditor', function () {
				styleeditor.closeStyleEditor();
			});

			publisher.subscribe('onBlockLoaded', function (block) {
				styleeditor.setupCanvasElements(block);
			});

			publisher.subscribe('onComponentDrop', function (block, $e) {
				if ($e.attr('data-component') == 'video2') {
					const newScript = document.createElement('script');
					newScript.src = '/skin/pagebuilder/build/video-ui.bundle.js';
					block.frameDocument.body.appendChild(newScript);
				}

				styleeditor.setupCanvasElements(block);
			});

			publisher.subscribe('onSetMode', function (mode) {
				styleeditor.responsiveModeChange(mode);
			});

			publisher.subscribe('deSelectAllCanvasElements', function () {
				styleeditor.deSelectAllCanvasElements();
			});

			//events
			$(this.buttonSaveChanges).on('click', this.updateStyling);
			$(this.formStyle).on('focus', 'input', this.animateStyleInputIn).on('blur', 'input:not([name="background-image"])', this.animateStyleInputOut);
			$(this.checkoutSettingsRedirect).on('focus', this.animateStyleInputIn).on('blur', this.animateStyleInputOut);
			$(this.buttonRemoveElement).on('click', this.deleteElement);
			$(this.buttonCloneElement).on('click', this.cloneElement);
			$(this.buttonResetElement).on('click', this.resetElement);
			$(this.videoInputYoutube).on('focus', function () { $(styleeditor.videoInputVimeo).val(''); $(styleeditor.videoInputURL).val(''); });
			$(this.videoInputVimeo).on('focus', function () { $(styleeditor.videoInputYoutube).val(''); $(styleeditor.videoInputURL).val(''); });
			$(this.videoInputURL).on('focus', function () { $(styleeditor.videoInputYoutube).val(''); $(styleeditor.videoInputVimeo).val(''); });
			$(this.inputCustomLink).on('focus', this.resetSelectAllLinks);
			$(this.buttonDetailsAppliedHide).on('click', function () { $(this).parent().fadeOut(500); });
			$(this.buttonCloseStyleEditor).on('click', this.closeStyleEditor);
			$(this.inputCustomLink).on('focus', this.inputCustomLinkFocus).on('blur', this.inputCustomLinkBlur);
			$(document).on('modeContent modeBlocks', 'body', this.deActivateMode);

			$(this.enterCodeSave).on('click', this.updateCode);

			$(this.btnGradientSave).on('click', this.gradientSave);

			$(this.btnChatSave).on('click', this.webinarChatSave);

			//chosen font-awesome dropdown
			$(this.selectIcons).chosen({ 'search_contains': true });

			//check if formData is supported
			if (!window.FormData) {
				this.hideFileUploads();
			}

			//listen for the beforeSave event
			$('body').on('beforeSave', this.closeStyleEditor);

			//responsive toggle
			$(this.responsiveToggle).on('click', 'a', this.toggleResponsiveClick);

			//set the default responsive mode
			siteBuilder.builderUI.currentResponsiveMode = Object.keys(bConfig.responsiveModes)[0];

			let $sliderOpacity = $('#slider-shape-opacity'),
				$sliderHeight = $('#slider-height'),
				$sliderZIndex = $('#slider-shape-z-index');

			$('#shapeModal').on('shown.bs.modal', function () {
				$(this).find('.modal-title').html(`${$(styleeditor.shapePositionDropdown).prop('value')} Shape Divider`);

				$('.uncode_radio_images_list input[type="radio"]').prop('checked', false);
				$('.uncode_radio_images_list .uncode_radio_image_src').removeClass('checked');
				$(styleeditor.shapeFlip).bootstrapSwitch('state', false); //.prop('checked', false);
				$(styleeditor.shapeHeight).bootstrapSwitch('state', false);
				$(styleeditor.shapePx).prop('value', 150);
				$(styleeditor.shapeOpacity).prop('value', 100);
				$(styleeditor.shapeRatio).bootstrapSwitch('state', false);
				$(styleeditor.shapeSafe).bootstrapSwitch('state', false);
				$(styleeditor.shapeZIndex).prop('value', 0);
				$(styleeditor.shapeResponsive).bootstrapSwitch('state', false);
				$(styleeditor.shapeTablet).bootstrapSwitch('state', false);
				$(styleeditor.shapeMobile).bootstrapSwitch('state', false);
				$(styleeditor.shapeProcent).prop('value', 30);
				$(styleeditor.shapeColor).spectrum("set", '#464D54');

				$sliderOpacity.slider('value', 100);
				$sliderHeight.slider('value', 30);
				$sliderZIndex.slider('value', 0);

				if ($(styleeditor.activeElement.element).find('.shape-divider[data-position="' + $(styleeditor.shapePositionDropdown).prop('value') + '"]').length > 0) {
					let _shape = $(styleeditor.activeElement.element).find('.shape-divider[data-position="' + $(styleeditor.shapePositionDropdown).prop('value') + '"]');

					$('.uncode_radio_images_list input[type="radio"][value="' + _shape.attr('data-shape-figure') + '"]').prop('checked', true).next().next().addClass('checked');

					if (_shape.attr('data-shape-flip') !== undefined) {
						$(styleeditor.shapeFlip).bootstrapSwitch('state', true);
					}
					if (_shape.attr('data-shape-ratio') !== undefined) {
						$(styleeditor.shapeRatio).bootstrapSwitch('state', true);
					}

					if (_shape.attr('data-shape-safe') !== undefined) {
						$(styleeditor.shapeSafe).bootstrapSwitch('state', true);
					}

					/** Shape z-index */
					$sliderZIndex.slider('value', _shape.attr('data-shape-z-index'));
					$(styleeditor.shapeZIndex).prop('value', _shape.attr('data-shape-z-index'));

					/** Shape opacity */
					$sliderOpacity.slider('value', _shape.attr('data-shape-opacity') * 100);
					$(styleeditor.shapeOpacity).prop('value', _shape.attr('data-shape-opacity') * 100);

					/** Shape height in px */
					if (_shape.attr('data-shape-unit') == 'px') {
						$(styleeditor.shapePx).prop('value', _shape.attr('data-shape-height'));
					}

					/** Shape height in % */
					if (_shape.attr('data-shape-unit') == '%') {
						$(styleeditor.shapeHeight).bootstrapSwitch('state', true);
						$(styleeditor.shapeProcent).prop('value', _shape.attr('data-shape-height'));
						$sliderHeight.slider('value', _shape.attr('data-shape-height'));
					}

					/** Shape color */
					$(styleeditor.shapeColor).spectrum("set", _shape.attr('data-shape-color'));

					/** Shape Responsive */
					if (_shape.hasClass('hidden-sm') || _shape.hasClass('hidden-xs')) {
						$(styleeditor.shapeResponsive).bootstrapSwitch('state', true);
					}

					/** Shape Hidden Tablet */
					if (_shape.hasClass('hidden-sm')) {
						$(styleeditor.shapeTablet).bootstrapSwitch('state', true);
					}

					/** Shape Hidden Mobile */
					if (_shape.hasClass('hidden-xs')) {
						$(styleeditor.shapeMobile).bootstrapSwitch('state', true);
					}
				}
			});

			$(styleeditor.shapePositionDropdown).on('change', function () {
				if ($(styleeditor.activeElement.element).find('.shape-divider[data-position="' + $(this).prop('value') + '"]').length > 0) {
					$(btnDeleteShape).removeClass('disabled');
				} else {
					$(btnDeleteShape).addClass('disabled');
				}
			});

			$(styleeditor.btnDeleteShape).on('click', function () {
				$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + $(styleeditor.shapePositionDropdown).prop('value') + '"]').remove();
				$(this).addClass('disabled');
				siteBuilder.site.setPendingChanges(true);
				return false;
			});

			if ($sliderOpacity.length > 0) {
				$sliderOpacity.slider({
					max: 100,
					step: 10,
					value: 100,
					orientation: 'horizontal',
					range: 'min',
					slide: function (event, ui) {
						$("#shape-opacity").val(ui.value);
					}
				});
				$("#shape-opacity").val($sliderOpacity.slider("value"));
			}

			if ($sliderHeight.length > 0) {
				$sliderHeight.slider({
					max: 100,
					step: 1,
					value: 30,
					orientation: 'horizontal',
					range: 'min',
					slide: function (event, ui) {
						$("#shape-procent").val(ui.value);
					}
				});
				$("#shape-procent").val($sliderHeight.slider("value"));
			}

			if ($sliderZIndex.length > 0) {
				$sliderZIndex.slider({
					max: 10,
					step: 1,
					value: 0,
					orientation: 'horizontal',
					range: 'min',
					slide: function (event, ui) {
						$("#shape-z-index").val(ui.value);
					}
				});
				$("#shape-z-index").val($sliderZIndex.slider("value"));
			}

			$(styleeditor.shapeHeight).on('switchChange.bootstrapSwitch', function (event, state) {
				$('[data-checked-height="px"]').stop(true, true).toggle();
				$('[data-checked-height="%"]').stop(true, true).toggle();
			});

			$(styleeditor.shapeResponsive).on('switchChange.bootstrapSwitch', function (event, state) {
				$('[data-checked-resonsive]').stop(true, true).fadeToggle('fast');
			});

			$(styleeditor.checkoutSwitcher).on('switchChange.bootstrapSwitch', function (event, state) {
				$(styleeditor.checkoutSettings).stop(true, true).fadeToggle('fast');
			});

			$(styleeditor.bumpSwitcher).on('switchChange.bootstrapSwitch', function (event, state) {
				$(styleeditor.bumpContainer).stop(true, true).fadeToggle('fast');
			});

			$(styleeditor.shapeColor).spectrum({
				cancelText: 'Cancel',
				chooseText: 'Choose',
				preferredFormat: "hex",
				showPalette: true,
				allowEmpty: true,
				showInput: true,
				showAlpha: true,
				palette: [
					["#000", "#444", "#666", "#999", "#ccc", "#eee", "#f3f3f3", "#fff"],
					["#f00", "#f90", "#ff0", "#0f0", "#0ff", "#00f", "#90f", "#f0f"],
					["#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d0e0e3", "#cfe2f3", "#d9d2e9", "#ead1dc"],
					["#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
					["#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6fa8dc", "#8e7cc3", "#c27ba0"],
					["#c00", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3d85c6", "#674ea7", "#a64d79"],
					["#900", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#0b5394", "#351c75", "#741b47"],
					["#600", "#783f04", "#7f6000", "#274e13", "#0c343d", "#073763", "#20124d", "#4c1130"]
				]
			});

			$(styleeditor.buttonColor).spectrum({
				cancelText: 'Cancel',
				chooseText: 'Choose',
				preferredFormat: "hex",
				showPalette: true,
				allowEmpty: true,
				showInput: true,
				showAlpha: true,
				palette: [
					["#000", "#444", "#666", "#999", "#ccc", "#eee", "#f3f3f3", "#fff"],
					["#f00", "#f90", "#ff0", "#0f0", "#0ff", "#00f", "#90f", "#f0f"],
					["#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d0e0e3", "#cfe2f3", "#d9d2e9", "#ead1dc"],
					["#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
					["#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6fa8dc", "#8e7cc3", "#c27ba0"],
					["#c00", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3d85c6", "#674ea7", "#a64d79"],
					["#900", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#0b5394", "#351c75", "#741b47"],
					["#600", "#783f04", "#7f6000", "#274e13", "#0c343d", "#073763", "#20124d", "#4c1130"]
				]
			});

			$('.uncode_radio_image_src').on('click', this.dividerClick);

			$(styleeditor.shapeSave).on('click', this.modalShapeSave);

			/** Quiz Action */
			this.eventQuizAction = this.eventQuizAction.bind(this);
			$(this.quizAction).on('change', this.eventQuizAction);

			$('#simulate_live').on('change', function() {
				if (styleeditor.activeElement.element.closest('[data-component]').getAttribute('data-component') == 'video2') {
					$(this).parent().next().attr('data-simulate', $(this).prop('checked'));
				}
			});

			bump.init(styleeditor);

			this.setupFormTab();
		},

		/*
			Configured the checkboxes in the FORM tab
		*/
		setupFormTab: function () {

			if (this.checkboxEmailForm === null) return false;

			styleeditor.inputEffectAnimation.addEventListener('change', function () {
				console.log('---change effect---');
			});

			this.checkboxEmailForm.addEventListener('change', function () {
				if (this.checked) {

					//use sent API
					styleeditor.inputEmailFormTo.removeAttribute('disabled');
					styleeditor.textareaCustomMessage.removeAttribute('disabled');

					//make sure custom action is disabled
					styleeditor.checkboxCustomAction.checked = false;
					styleeditor.inputCustomAction.setAttribute('disabled', true);

					if (styleeditor.checkboxUseLeadChannels !== null) {
						styleeditor.checkboxUseLeadChannels.checked = false;
						styleeditor.textareaCustomMessageLeadChannel.setAttribute('disabled', true);
						styleeditor.inputRedirectTo.setAttribute('disabled', true);
					}

					$('[data-form-type]').hide();
					$('[data-form-type="email"]').show();

				} else {

					styleeditor.inputEmailFormTo.setAttribute('disabled', true);
					styleeditor.textareaCustomMessage.setAttribute('disabled', true);

				}
			});

			this.checkboxCustomAction.addEventListener('change', function () {
				if (this.checked) {

					//use custom action
					styleeditor.inputCustomAction.removeAttribute('disabled');

					//make sure sent API is disabled
					styleeditor.checkboxEmailForm.checked = false;
					styleeditor.inputEmailFormTo.setAttribute('disabled', false);
					styleeditor.textareaCustomMessage.setAttribute('disabled', true);

					if (styleeditor.checkboxUseLeadChannels !== null) {
						styleeditor.checkboxUseLeadChannels.checked = false;
						styleeditor.textareaCustomMessageLeadChannel.setAttribute('disabled', true);
						styleeditor.inputRedirectTo.setAttribute('disabled', true);
					}

					$('[data-form-type]').hide();
					$('[data-form-type="action"]').show();

				} else {

					styleeditor.inputCustomAction.setAttribute('disabled', true);

				}
			});

			if (this.checkboxUseLeadChannels !== null) {
				this.checkboxUseLeadChannels.addEventListener('change', function () {
					if (this.checked) {
						styleeditor.selectLeadChannels.removeAttribute('disabled');
						styleeditor.textareaCustomMessageLeadChannel.removeAttribute('disabled');
						styleeditor.inputRedirectTo.removeAttribute('disabled');

						styleeditor.checkboxEmailForm.checked = false;
						styleeditor.inputEmailFormTo.setAttribute('disabled', false);
						styleeditor.textareaCustomMessage.setAttribute('disabled', true);

						styleeditor.checkboxCustomAction.checked = false;
						styleeditor.inputCustomAction.setAttribute('disabled', true);

						$('[data-form-type]').hide();
						$('[data-form-type="leadchannels"]').show();

					} else {
						styleeditor.selectLeadChannels.setAttribute('disabled', true);
						styleeditor.textareaCustomMessageLeadChannel.setAttribute('disabled', true);
						styleeditor.inputRedirectTo.setAttribute('disabled', true);
					}
				});
			}

			if (this.checkboxTriggeredOptin !== null) {
				this.checkboxTriggeredOptin.addEventListener('change', function () {
					if (this.checked) {
						$(styleeditor.activeElement.element).attr('data-triggered-optin', 'true');
						if ($(styleeditor.activeElement.element).closest('body').find('script.triggered').length == 0) {
							$(styleeditor.activeElement.element).closest('body').append('<script class="triggered" type="text/javascript" src="/skin/pagebuilder/build/triggered.bundle.js"></script>');
						}
					} else {
						$(styleeditor.activeElement.element).removeAttr('data-triggered-optin');
						$(styleeditor.activeElement.element).closest('body').find('script.triggered').remove();
					}
					siteBuilder.site.setPendingChanges(true);
				});
			}

			if (this.checkboxTriggeredFields !== null) {
				this.checkboxTriggeredFields.addEventListener('change', function () {
					if (this.checked) {
						$(styleeditor.activeElement.element).attr('data-triggered-fields', 'true');
					} else {
						$(styleeditor.activeElement.element).removeAttr('data-triggered-fields');
					}
					siteBuilder.site.setPendingChanges(true);
				});
			}
		},

		/*
			Deselects all canvas elements
		*/
		deSelectAllCanvasElements: function () {

			for (var i in this.allStyleItemsOnCanvas) {
				if (this.allStyleItemsOnCanvas.hasOwnProperty(i)) {

					this.allStyleItemsOnCanvas[i].removeOutline();

				}
			}

		},

		/*
			Event handler for responsive mode links
		*/
		toggleResponsiveClick: function (e) {

			e.preventDefault();

			styleeditor.responsiveModeChange(this.getAttribute('data-responsive'));

		},


		/*
			Toggles the responsive mode
		*/
		responsiveModeChange: function (mode) {

			if (styleeditor.responsiveToggle === null) return false;

			var links,
				i;

			//UI stuff
			links = styleeditor.responsiveToggle.querySelectorAll('li');

			for (i = 0; i < links.length; i++) links[i].classList.remove('active');

			document.querySelector('a[data-responsive="' + mode + '"]').parentNode.classList.add('active');


			for (var key in bConfig.responsiveModes) {

				if (bConfig.responsiveModes.hasOwnProperty(key)) this.theScreen.classList.remove(key);

			}

			if (bConfig.responsiveModes[mode]) {

				this.theScreen.classList.add(mode);
				this.theScreen.style.maxWidth = bConfig.responsiveModes[mode];

				if (typeof siteBuilder.site.activePage.heightAdjustment === 'function') siteBuilder.site.activePage.heightAdjustment();

				publisher.publish('onResponsiveViewChange', mode);

			}

			siteBuilder.builderUI.currentResponsiveMode = mode;

		},


		/*
			Activates style editor mode
		*/
		setupCanvasElements: function (block) {

			//needed to move from 1.0.1 to 1.0.2, can be removed after 1.0.4
			$(block.frame).contents().find('*[data-selector]').each(function () {
				this.removeAttribute('data-selector');
			});

			$(block.frame).contents().find('*[data-image-src]').each(function () {
				$(this).css('background-image', 'url(' + $(this).attr('data-image-src') + ')');
			});

			if (block === undefined) return false;

			var i;

			//create an object for every editable element on the canvas and setup it's events
			for (var key in bConfig.editableItems) {

				$(block.frame).contents().find(bConfig.pageContainer + ' ' + key).each(function () {

					if (!this.hasAttribute('data-selector')) styleeditor.setupCanvasElementsOnElement(this, key);

				});

			}

		},


		/*
			Sets up canvas elements on element
		*/
		setupCanvasElementsOnElement: function (element, key) {

			//Element object extention
			canvasElement.prototype.clickHandler = function (el, deleteEmbed) {
				styleeditor.styleClick(this, deleteEmbed);
			};

			var newElement = new canvasElement(element);

			newElement.editableAttributes = bConfig.editableItems[key];
			newElement.setParentBlock();
			newElement.activate();
			newElement.unsetNoIntent();

			for (var i in styleeditor.allStyleItemsOnCanvas) {

				if (styleeditor.allStyleItemsOnCanvas[i].element === newElement.element) {

					styleeditor.allStyleItemsOnCanvas.splice(i, 1);

				}

			}

			styleeditor.allStyleItemsOnCanvas.push(newElement);

			if (typeof key !== undefined) {
				$(element).attr('data-selector', key);

				if ($(element).attr('data-id') == null)
					$(element).attr('data-id', this.makedataid());
			}

		},

		makedataid: function () {
			var text = "",
				possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			for (var i = 0; i < 5; i++) {
				text += possible.charAt(Math.floor(Math.random() * possible.length));
			}
			return text;
		},

		styleDblClick: function (element) {

			this.closeStyleEditor();

			//content editor?
			if (element.element.parentNode.hasAttribute('data-content')) {
				publisher.publish('onClickContent', element.element);
			}

		},


		/*
			Event handler for when the style editor is envoked on an item
		*/
		styleClick: function (element, deleteEmbed) {
			$('#editingElement').empty();

			if (element.element.hasAttribute('data-container') && $(element.element).attr('data-component') != "quest") {
				//disable the clone & delete buttons
				styleeditor.buttonCloneElement.setAttribute('disabled', true);
				styleeditor.buttonDelElement.setAttribute('disabled', true);
			} else {
				//enable the clone & delete buttons
				styleeditor.buttonCloneElement.removeAttribute('disabled');
				styleeditor.buttonDelElement.removeAttribute('disabled');
			}

			//if we have an active element, make it unactive
			if (Object.keys(this.activeElement).length !== 0) {
				this.activeElement.activate();
			}

			//set the active element
			this.activeElement = element;

			if (element.element.getAttribute('data-component') === 'embed') {
				if (deleteEmbed) $('#removeElementButton').click();
				else element.parentBlock.source(element.element);
				return;
			}

			//unbind hover and click events and make this item active
			this.activeElement.setOpen();

			var theSelector = $(this.activeElement.element).attr('data-selector');
			var theBreadcrumps = $(this.activeElement.element).attr('data-selector');
			var parentDS = $(this.activeElement.element).parent();
			do {
				var parentDSdata = $(parentDS[0]).attr('data-selector');
				if (parentDSdata != null) {
					var createLink = document.createElement('a');
					$(createLink).addClass('breadcr');
					var textValue = $(parentDS[0]).attr('data-selector');
					var replText = textValue.replace(/\*\[data-component=\"(.*?)\"\]/g, "$1");
					$(createLink).html(replText);
					createLink.openDS = parentDS[0];
					var _this = this;
					$(createLink).on('click', function () {
						publisher.publish('deSelectAllCanvasElements');
						var cElEvt = new canvasElement(this.openDS);
						cElEvt.element = this.openDS;
						styleeditor.styleClick(cElEvt);
						cElEvt.destroyToolBar();

					});
					$('#editingElement').prepend(createLink);
					$('#editingElement').prepend('<br/><span class="glicon"></span>');

				}
				parentDS = $(parentDS[0]).parent();
			} while (parentDS[0].nodeName != 'BODY');

			$('#editingElement').append('<p>' + theSelector + '</p>');

			//activate first tab
			$('#detailTabs a:first').click();

			//hide all by default
			$('ul#detailTabs li:not(.showDefault)').hide();

			//what are we dealing with?
			if ($(this.activeElement.element).data('selector') == '.block') {
				this.editBlock(this.activeElement.element);
			}

			if ($(this.activeElement.element).prop('tagName') === 'A') {
				this.editLink(this.activeElement.element);

				if (this.activeElement.element.hasAttribute('target') && this.activeElement.element.getAttribute('target') === '_blank') {
					styleeditor.openTargetBlank.checked = true;	
				} else {
					styleeditor.openTargetBlank.checked = false;
				}
			}

			if ($(this.activeElement.element).prop('tagName') === 'IMG') {
				this.editImage(this.activeElement.element);
			}

			if ($(this.activeElement.element).attr('data-type') === 'video') {
				this.editVideo(this.activeElement.element);
			}

			if ($(this.activeElement.element).attr('data-type') === 'video2') {
				this.editVideo2(this.activeElement.element);
			}

			if ($(this.activeElement.element).hasClass('fa')) {
				this.editIcon(this.activeElement.element);
			}

			if (this.activeElement.element.tagName === 'FORM') {
				this.editForm(this.activeElement.element);
			}

			if (this.activeElement.element.parentNode.parentNode.parentNode.hasAttribute('data-carousel-item')) {
				this.editSlideshow($(this.activeElement.element).closest('.carousel')[0]);
			}

			if (this.activeElement.element.classList.contains('mapOverlay')) {
				this.editMap($(this.activeElement.element).prev()[0]);
			}

			if (this.activeElement.element.classList.contains('codeblock')) {
				this.editCode(this.activeElement);
			}

			if (this.activeElement.element.getAttribute('data-component') === 'quest') {
				this.editQuiz(this.activeElement);
			}

			/** Button */
			if (['button'].indexOf(this.activeElement.element.parentElement.getAttribute('data-component')) !== -1) {
				this.editBtn(this.activeElement);
			}

			/** Nav > a, ul > li > a */
			if (['nav a', 'ul > li > a', 'img', 'a', 'a.btn, button.btn'].indexOf(this.activeElement.element.getAttribute('data-selector')) !== -1) {
				this.editBtn(this.activeElement);
			}

			if (this.activeElement.element.getAttribute('data-component') === 'chat') {
				this.editChat(this.activeElement);
			}

			if (this.activeElement.element.parentNode.getAttribute('data-component') === 'nft') {
				this.editNft(this.activeElement);
			}

			//load the attributes
			this.buildeStyleElements(theSelector);

			if (this.activeElement.element.classList.contains('btn') || this.activeElement.element.getAttribute('data-selector') == 'nav a' || this.activeElement.element.getAttribute('data-selector') == 'ul > li > a') {
				$('#styleElements input[name="text"]').prop('value', $(this.activeElement.element).text());
			}

			if ($(styleeditor.activeElement.element).find('.shape-divider[data-position="top"]').length > 0) {
				$(btnDeleteShape).removeClass('disabled');
			}

			//open side panel
			this.toggleSidePanel('open');

			if (this.activeElement.element.getAttribute('data-component') == 'countdown') {
				this.editCountdown(this.activeElement);
			}

			this.editEffects(this.activeElement);

			return false;

		},


		/*
			dynamically generates the form fields for editing an elements style attributes
		*/
		buildeStyleElements: function (theSelector) {
			//delete the old ones first
			$('#styleElements > *:not(#styleElTemplate)').each(function () {

				$(this).remove();

			});

			var takeFrom = styleeditor.activeElement.element;

			if (styleeditor.activeElement.element.classList.contains('mapOverlay')) {
				takeFrom = $(styleeditor.activeElement.element).prev()[0];
			}

			for (var x = 0; x < bConfig.editableItems[theSelector].length; x++) {

				//create style elements
				var newStyleEl = $('#styleElTemplate').clone(),
					newDropDown,
					z,
					newOption,
					labelText = '';
				newStyleEl.attr('id', 'el_' + x);
				newStyleEl.find('input').uniqueId();

				if (typeof window.language.styles[bConfig.editableItems[theSelector][x]] !== 'undefined') {
					labelText = window.language.styles[bConfig.editableItems[theSelector][x]] + ":";
				} else {
					labelText = bConfig.editableItems[theSelector][x][0].toUpperCase() + bConfig.editableItems[theSelector][x].slice(1) + ":";
				}

				newStyleEl.find('.control-label').text(labelText);

				if (theSelector + " : " + bConfig.editableItems[theSelector][x] in bConfig.editableItemOptions) {//we've got a dropdown instead of open text input

					newStyleEl.find('input').remove();

					newDropDown = $('<select class="form-control select select-default btn-block select-sm"></select>');
					newDropDown.attr('name', bConfig.editableItems[theSelector][x]);

					for (z = 0; z < bConfig.editableItemOptions[theSelector + " : " + bConfig.editableItems[theSelector][x]].length; z++) {

						newOption = $('<option value="' + bConfig.editableItemOptions[theSelector + " : " + bConfig.editableItems[theSelector][x]][z] + '">' + bConfig.editableItemOptions[theSelector + " : " + bConfig.editableItems[theSelector][x]][z] + '</option>');

						// for parallax
						if (bConfig.editableItems[theSelector][x] === 'parallax' && takeFrom.hasAttribute('data-parallax') && takeFrom.getAttribute('data-parallax') === 'scroll' && bConfig.editableItemOptions[theSelector + " : " + bConfig.editableItems[theSelector][x]][z] === 'on') {
							newOption.attr('selected', true)
						}


						if (bConfig.editableItemOptions[theSelector + " : " + bConfig.editableItems[theSelector][x]][z] === $(takeFrom).css(bConfig.editableItems[theSelector][x])) {
							//current value, marked as selected
							newOption.attr('selected', 'true');

						}

						newDropDown.append(newOption);

					}

					newStyleEl.append(newDropDown);
					newDropDown.select2({
						minimumResultsForSearch: -1
					});

					if (bConfig.editableItems[theSelector][x] === 'parallax') {

						let parallaxInfo = document.importNode(document.getElementById('templateParallaxInfo').content, true);
						newStyleEl.append(parallaxInfo.querySelector('.alert'));

					}

				} else if (bConfig.editableItems[theSelector][x] == 'blockid') {

					newStyleEl.find('input').val($(takeFrom).attr('data-id')).attr('name', bConfig.editableItems[theSelector][x]);

					newStyleEl.find('input').addClass('padding-right');

				} else if (bConfig.editableItems[theSelector][x] == 'quiz-progress') {

					var parentWidth = parseInt($(takeFrom).css('width').replace('px', ''));
					var childWidth = parseInt($($(takeFrom).find('.surveyStepProgressCounter')[0]).css('width').replace('px', ''));
					var widthValue = Math.round(childWidth / parentWidth * 100);

					newStyleEl.find('input').val(widthValue).attr('name', bConfig.editableItems[theSelector][x]);
					newStyleEl.find('input').addClass('padding-right');
					newStyleEl.append($('<span class="inputAppend">%</span>'));

				} else if (bConfig.editableItems[theSelector][x] in bConfig.customStyleDropdowns) {

					var somethingSelected = 0,
						labelText2 = '';

					if (typeof window.language.styles[bConfig.editableItems[theSelector][x]] !== 'undefined') {
						labelText2 = window.language.styles[bConfig.editableItems[theSelector][x]] + ":";
					} else {
						labelText2 = bConfig.customStyleDropdowns[bConfig.editableItems[theSelector][x]].label + ":";
					}

					//this option uses a custom label
					newStyleEl.find('.control-label').text(labelText2);

					newStyleEl.find('input').remove();

					newDropDown = $('<select class="form-control select select-default btn-block select-sm" data-class-dropdown="' + bConfig.editableItems[theSelector][x] + '"></select>');
					newDropDown.attr('name', bConfig.editableItems[theSelector][x]);

					for (var opt in bConfig.customStyleDropdowns[bConfig.editableItems[theSelector][x]].values) {

						if (bConfig.customStyleDropdowns[bConfig.editableItems[theSelector][x]].values.hasOwnProperty(opt)) {

							newOption = $('<option value="' + bConfig.customStyleDropdowns[bConfig.editableItems[theSelector][x]].values[opt] + '">' + opt + '</option>');

							newDropDown.append(newOption);

							//detect currently applied class
							for (var clss in takeFrom.classList) {
								if (takeFrom.classList.hasOwnProperty(clss)) {

									if (takeFrom.classList[clss] === bConfig.customStyleDropdowns[bConfig.editableItems[theSelector][x]].values[opt]) {

										somethingSelected = 1;
										newOption.attr('selected', 'true');

									}

								}
							}

						}

					}

					if (bConfig.editableItems[theSelector][x] == 'countdown-type') {
						newDropDown.on('change', function (e, trigger = false) {
							if (!trigger) {
								this.changeTypeFunc(this.activeElement.element, e.currentTarget.value);
							} else {
								this.changeTypeFunc(this.activeElement.element);
							}
						}.bind(this));
					}

					if (bConfig.editableItems[theSelector][x] == 'countdown-action') {
						newDropDown.on('change', function () {
							const elementUrl = document.querySelector('input[name="countdown-redirect"]');
							$(elementUrl.parentNode).addClass('hide');
							
							if (this.value == 'redirect' || this.value == 'url') {
								$(elementUrl.parentNode).removeClass('hide');

								$(elementUrl.parentNode).children().addClass('hidden');
								
								if (this.value == 'redirect') {
									$('#cd_page-select').prev().removeClass('hidden');
									$('#cd_page-label').removeClass('hidden');
								}

								if (this.value == 'url') {
									const $children = $(elementUrl.parentNode).children();

									$children.eq(3).removeClass('hidden');
									$children.eq(4).removeClass('hidden');
								}
							}
						});
					}

					//if nothing selected, use the default
					if (somethingSelected === 0) {
						newDropDown.val(bConfig.customStyleDropdowns[bConfig.editableItems[theSelector][x]].default);
					}

					newStyleEl.append(newDropDown);
					newDropDown.select2({
						minimumResultsForSearch: -1
					});


				} else if (utils.contains.call(bConfig.inputAppend, bConfig.editableItems[theSelector][x])
					&& bConfig.editableItems[theSelector][x].indexOf("countdown") == -1
					&& bConfig.editableItems[theSelector][x].indexOf("progress") == -1
					&& bConfig.editableItems[theSelector][x].indexOf("onselect") == -1
				) {

					if (bConfig.editableItems[theSelector][x] == 'custom') {
						newStyleEl.find('input').attr('name', bConfig.editableItems[theSelector][x]);
					} else {
						newStyleEl.find('input').val($(takeFrom).css(bConfig.editableItems[theSelector][x]).replace('px', '')).attr('name', bConfig.editableItems[theSelector][x]);
						newStyleEl.find('input').addClass('padding-right');
						newStyleEl.append($('<span class="inputAppend">px</span>'));
					}
				} else {


					var valueName = bConfig.editableItems[theSelector][x];
					if (valueName == 'margin' || valueName == 'padding') {
						valueName = valueName + '-top';
					}
					if (valueName == 'border-radius') {
						valueName = 'border-top-left-radius';
					}

					newStyleEl.find('input').val($(takeFrom).css(valueName)).attr('name', bConfig.editableItems[theSelector][x]);

					if (bConfig.editableItems[theSelector][x] === 'background-image') {

						newStyleEl.find('input').addClass('padding-right p-r-60').val($(takeFrom).css(bConfig.editableItems[theSelector][x]).replace(/['"]+/g, ''));

						var elementParalax = document.querySelector('[data-parallax="scroll"]');
						if ($(takeFrom).data('parallax') == 'scroll') {
							newStyleEl.find('input').val('url(' + $(takeFrom).attr('data-image-src') + ')');
						}

						newStyleEl.append($('<a href="#" class="linkLib"><span class="fui-image"></span></a>'));
						newStyleEl.append($('<a href="#" class="linkLib linkGradient"><span class="fa fa-paint-brush"></span></a>'));

						newStyleEl.find('a.linkLib').bind('click', function (e) {

							e.preventDefault();

							var theInput = $(this).prev();

							$('#imageModal').modal('show');

						});

						newStyleEl.find('a.linkGradient').off('click').bind('click', function (e) {

							e.preventDefault();
							$('#gradientModal').modal('show');
							let _option = {
								targets: [".target"]
							};

							if ($(styleeditor.activeElement.element).attr('data-option') !== undefined) {
								_option = JSON.parse(atob($(styleeditor.activeElement.element).attr('data-option')));
								let _sliders = _option.sliders;
								_option.sliders = [];
								_sliders.forEach(function (item) {
									_option.sliders.push({ 'color': item[0], 'position': item[1] });
								});
								_option.targets = [".target"];
							}

							window.gradX("#gradX", _option);

							$('#gradX select').select2({
								minimumResultsForSearch: -1
							});

							styleeditor.textareaGradxCode = document.getElementById('gradx_code');
						});
					}
					else if (bConfig.editableItems[theSelector][x] === 'background-gradient') {
						//newStyleEl.find('input').addClass('padding-right').val( $(takeFrom).css( bConfig.editableItems[theSelector][x] ).replace(/['"]+/g, '') );
						newStyleEl.append($('<a href="#" class="linkLib"><span class="fa fa-paint-brush"></span></a>'));
					}
					else if (bConfig.editableItems[theSelector][x].indexOf("color") > -1) {

						if (bConfig.editableItems[theSelector][x] == 'progress-color') {

							newStyleEl.find('input').val($($(takeFrom).find('.surveyStepProgressCounter')[0]).css('background-color'));

						} else if (bConfig.editableItems[theSelector][x] == 'countdown-panelcolor') {

							newStyleEl.find('input').val($(takeFrom).attr('data-panelcolor'));

						} else if (bConfig.editableItems[theSelector][x] == 'divider-color') {
							const dividerColor = takeFrom.getAttribute('data-color') || '#000000';
							newStyleEl.find('input').val(dividerColor);
							takeFrom.style.setProperty('--divider-color', dividerColor);

							/** Getting a CSS Variable's Value */
							// getComputedStyle(takeFrom).getPropertyValue('--divider-color');
						} else if (takeFrom.getAttribute('data-selector') === 'label' && bConfig.editableItems[theSelector][x] === 'color') {
							newStyleEl.find('input[name="color"]').prop('value', getComputedStyle(takeFrom).getPropertyValue('--color').trim() || '#f00000');
						} else if (bConfig.editableItems[theSelector][x] == 'countdown-labelcolor') {

							newStyleEl.find('input').val($(takeFrom).attr('data-labelcolor'));

						} else if (bConfig.editableItems[theSelector][x] == 'countdown-textcolor') {

							newStyleEl.find('input').val($(takeFrom).attr('data-textcolor'));

						} else if (bConfig.editableItems[theSelector][x] === 'background-color-overlay') {

							var backgroundColorOverlay = $(takeFrom).find('.overly').css('background-color');
							if (backgroundColorOverlay == null) {
								backgroundColorOverlay = 'rgba(0, 0, 0, 0)';
							}
							newStyleEl.find('input').val(backgroundColorOverlay);

						} else if (bConfig.editableItems[theSelector][x] == 'hover-background-color') {
							newStyleEl.find('input').val($(takeFrom).attr('data-hover-color') || '#97d6ff');
						} else {

							if ($(takeFrom).css(bConfig.editableItems[theSelector][x]) !== 'transparent' && $(takeFrom).css(bConfig.editableItems[theSelector][x]) !== 'none' && $(takeFrom).css(bConfig.editableItems[theSelector][x]) !== '') {

								newStyleEl.val($(takeFrom).css(bConfig.editableItems[theSelector][x]));

							}

						}

						newStyleEl.find('input').spectrum({
							cancelText: window.language.front_end_spectrum_cancel,
							chooseText: window.language.front_end_spectrum_choose,
							preferredFormat: "hex",
							showPalette: true,
							allowEmpty: true,
							showInput: true,
							showAlpha: true,
							palette: [
								["#000", "#444", "#666", "#999", "#ccc", "#eee", "#f3f3f3", "#fff"],
								["#f00", "#f90", "#ff0", "#0f0", "#0ff", "#00f", "#90f", "#f0f"],
								["#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d0e0e3", "#cfe2f3", "#d9d2e9", "#ead1dc"],
								["#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
								["#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6fa8dc", "#8e7cc3", "#c27ba0"],
								["#c00", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3d85c6", "#674ea7", "#a64d79"],
								["#900", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#0b5394", "#351c75", "#741b47"],
								["#600", "#783f04", "#7f6000", "#274e13", "#0c343d", "#073763", "#20124d", "#4c1130"]
							]
						});

					}

				}

				if (bConfig.editableItems[theSelector][x] == 'countdown-redirect') {
					newDropDown = $('<select class="form-control select select-default btn-block select-sm m-b-20 hidden" id="cd_page-select"></select>');

					const { pages } = siteBuilder.site;

					newDropDown.append('<option value="">Select Page</option>');

					Object.keys(pages).forEach((name) =>
						newDropDown.append(`<option value="${name}">${name}</option>`)
					);

					newStyleEl.prepend(newDropDown);
					newStyleEl.prepend('<label class="control-label hidden" id="cd_page-label">Pages</label>');

					newDropDown.on('change', function() {
						const value = $(this).prop('value');
						$(this)
							.closest('.form-group')
							.find('input')
							.val(`${value ? value + '.php' : ''}`);
					});
					
					newDropDown.select2({
						minimumResultsForSearch: -1
					});
				}

				newStyleEl.css('display', 'block');

				$('#styleElements').append(newStyleEl);

				$('#styleEditor form#stylingForm').height('auto');

			}

		},

		getListQuestionBox: function (domElement) {
			const optionList = [];
			domElement
				.closest('[data-component="quest-box"]')
				.closest('[data-container="true"]')
				.querySelectorAll('[data-component="quest-box"]')
				.forEach(domElement => {
					const header = domElement.querySelector('[data-component="heading"] > h3');
					optionList.push({
						value: domElement.getAttribute('data-id'),
						name: header.innerText.trim().replace('   ', ' ').replace('\n', ' ')
					});
				});

			return optionList;
		},

		/*
			Applies updated styling to the canvas
		*/
		updateStyling: function () {
			var elementID,
				length,
				applyTo;

			$('#styleEditor #tab1 .form-group:not(#styleElTemplate) input, #styleEditor #tab1 .form-group:not(#styleElTemplate) select').each(function () {

				applyTo = styleeditor.activeElement.element;

				if (styleeditor.activeElement.element.classList.contains('mapOverlay')) {
					applyTo = $(styleeditor.activeElement.element).prev()[0];
				}

				if ($(this).attr('name') !== undefined) {

					//custom class dropdown?
					if (this.hasAttribute('data-class-dropdown')) {

						var dropdownItem = bConfig.customStyleDropdowns[this.getAttribute('data-class-dropdown')];

						//remove the currently applied class
						for (var option in dropdownItem.values) {
							if (dropdownItem.values.hasOwnProperty(option)) {

								if (dropdownItem.values[option] !== '' && styleeditor.activeElement.element.classList.contains(dropdownItem.values[option])) {
									applyTo.classList.remove(dropdownItem.values[option]);
								}

							}
						}

						//apply class
						if (
							this.value !== "" &&
							bConfig.countdownProps.indexOf(this.getAttribute("name")) === -1
						) applyTo.classList.add(this.value);

					} else {

						if ($(this).attr('name').indexOf("color") > -1) {//color picker

							if ($(this).attr('name') !== 'background-color-overlay') { // anything but background color overlay

								if ($(this).spectrum('get') !== null) {
									$(applyTo).css($(this).attr('name'), $(this).spectrum('get').toRgbString());
								} else {
									$(applyTo).css($(this).attr('name'), 'transparent');
								}

							} else { // background color overlay

								// if the .overly element does not exist, we'll need to add it
								if (applyTo.querySelector('.overly') === null) {
									let divOverly = document.createElement('DIV');
									divOverly.classList.add('overly');
									applyTo.insertBefore(divOverly, applyTo.firstChild);
								}

								if ($(this).spectrum('get') !== null) {
									applyTo.querySelector('.overly').style.backgroundColor = $(this).spectrum('get').toRgbString();
								} else {
									applyTo.querySelector('.overly').style.backgroundColor = 'transparent';
								}

							}

						} else if (utils.contains.call(bConfig.inputAppend, $(this).attr('name'))) {
							if (['auto', 'inital', 'inherit'].indexOf($(this).val()) === -1) {
								$(applyTo).css($(this).attr('name'), `${$(this).val()}px`);
							} else {
								$(applyTo).css($(this).attr('name'), $(this).val());
							}

						} else if ($(this).attr('name') === 'parallax') {

							if (this.value === 'on') {

								// setup the parallax, only if a background image is selected
								if (applyTo.style.backgroundImage && applyTo.style.backgroundImage !== '' && applyTo.style.backgroundImage !== 'none') {
									applyTo.classList.add('parallax-window');
									applyTo.setAttribute('data-parallax', 'scroll');
									applyTo.setAttribute('data-image-src', applyTo.style.backgroundImage.match(/url\(\"(.+)\"\)/)[1]);
								}

							} else {

								// disable the parallax
								applyTo.classList.remove('parallax-window');
								applyTo.removeAttribute('data-parallax');
								applyTo.removeAttribute('data-image-src');

							}

						} else {
							$(applyTo).css($(this).attr('name'), $(this).val());

						}

					}

				}

				/* SANDBOX */

				if (styleeditor.activeElement.sandbox) {

					elementID = $(styleeditor.activeElement.element).attr('id');

					$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).css($(this).attr('name'), $(this).val());

				}

				/* END SANDBOX */

			});

			//links
			if ($(styleeditor.activeElement.element).prop('tagName') === 'A') {

				//change the href prop?
				styleeditor.activeElement.element.href = document.getElementById('internalLinksCustom').value;

				length = styleeditor.activeElement.element.childNodes.length;

				if ($(styleeditor.activeElement.element).closest(bConfig.navSelector).size() === 1 && styleeditor.inputLinkActive.checked) {

					styleeditor.activeElement.element.parentNode.classList.add(bConfig.navActiveClass);

				} else {

					styleeditor.activeElement.element.parentNode.classList.remove(bConfig.navActiveClass);

				}

				//does the link contain an image?
				if (styleeditor.linkImage) {

					styleeditor.activeElement.element.childNodes[length - 1].nodeValue = document.querySelector('[name="text"]').value;

				} else if (styleeditor.linkIcon) {

					styleeditor.activeElement.element.childNodes[length - 1].nodeValue = document.querySelector('[name="text"]').value;

				} else {
					const text = document.querySelector('[name="text"]');
					if( text ) {
						styleeditor.activeElement.element.innerText = document.querySelector('[name="text"]').value;
					}
				}

				// Linking to a modal?
				styleeditor.activeElement.element.removeAttribute('data-toggle');

				siteBuilder.site.activePage.popups.forEach((popup) => {
					if ('#' + popup.popupID === document.getElementById('internalLinksCustom').value) { // Links to a popup
						styleeditor.activeElement.element.setAttribute('data-toggle', 'modal');
					}
				});

				// Open in a new window?
				if ( styleeditor.openTargetBlank.checked ) {
					styleeditor.activeElement.element.setAttribute('target', '_blank');
				} else {
					styleeditor.activeElement.element.removeAttribute('target');
				}

				/* SANDBOX */

				if (styleeditor.activeElement.sandbox) {

					elementID = $(styleeditor.activeElement.element).attr('id');

					$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).attr('href', $('input#internalLinksCustom').val());


				}

				/* END SANDBOX */

			}

			if ($(styleeditor.activeElement.element).parent().prop('tagName') === 'A') {

				//change the href prop?
				styleeditor.activeElement.element.parentNode.href = document.getElementById('internalLinksCustom').value;

				length = styleeditor.activeElement.element.childNodes.length;


				/* SANDBOX */

				if (styleeditor.activeElement.sandbox) {

					elementID = $(styleeditor.activeElement.element).attr('id');

					$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).parent().attr('href', $('input#internalLinksCustom').val());

				}

				/* END SANDBOX */

			}

			//icons
			if ($(styleeditor.activeElement.element).hasClass('fa')) {

				//out with the old, in with the new :)
				//get icon class name, starting with fa-
				var get = $.grep(styleeditor.activeElement.element.className.split(" "), function (v, i) {

					return v.indexOf('fa-') === 0;

				}).join();

				//if the icons is being changed, save the old one so we can reset it if needed

				if (get !== $('select#icons').val()) {

					$(styleeditor.activeElement.element).uniqueId();
					styleeditor._oldIcon[$(styleeditor.activeElement.element).attr('id')] = get;

				}

				$(styleeditor.activeElement.element).removeClass(get).addClass($('select#icons').val());


				/* SANDBOX */

				if (styleeditor.activeElement.sandbox) {

					elementID = $(styleeditor.activeElement.element).attr('id');
					$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).removeClass(get).addClass($('select#icons').val());

				}

				/* END SANDBOX */

			}

			//buttons
			if ($(styleeditor.activeElement.element).hasClass('btn')) {
				if ($(styleeditor.activeElement.element).prop('tagName') == 'INPUT')
					$(styleeditor.activeElement.element).prop('value', $('#styleElements input[name="text"]').prop('value'));
				else
					$(styleeditor.activeElement.element).html($('#styleElements input[name="text"]').prop('value'));
			}

			//video URL
			if ($(styleeditor.activeElement.element).attr('data-type') === 'video') {
				const URI = require('urijs');
				const url = URI("//app.ifunnels.com/video/");
				const sticky = $("#slick_stick").prop('checked');

				// Base URL
				url.addQuery({ url: $("#videoURL").val(), simulate_live: $("#simulate_live").prop('checked') ? 1 : 0 });

				const $iframe = $(styleeditor.activeElement.element).prev();
				$iframe.attr("src", url.toString());
				$iframe.attr('data-sticky', sticky);

				const { parentFrame } = styleeditor.activeElement;

				// Sticky
				if (sticky) {
					const src = "/skin/ifunnels-studio/dist/js/stick.bundle.js";

					if (!parentFrame.contentDocument.querySelector(`script[src="${src}"]`)) {
						const script = parentFrame.contentDocument.createElement("script");
						script.src = src;

						const link = parentFrame.contentDocument.createElement("link");
						link.setAttribute('rel', 'stylesheet');
						link.setAttribute('href', '/skin/ifunnels-studio/dist/css/stick.bundle.css');

						parentFrame.contentDocument.head.appendChild(link);
						parentFrame.contentDocument.body.appendChild(script);
					}
				} else {
					const script = parentFrame.contentDocument.querySelector(
						'script[src="/skin/ifunnels-studio/dist/js/stick.bundle.js"]'
					);

					const link = parentFrame.contentDocument.querySelector('link[href="/skin/ifunnels-studio/dist/css/stick.bundle.css"]');

					if (script) {
						script.parentNode.removeChild(script);
					}

					if (link) {
						link.parentNode.removeChild(link);
					}
				}
				
				/* SANDBOX */

				if (styleeditor.activeElement.sandbox) {

					elementID = $(styleeditor.activeElement.element).attr('id');

					if ($('input#youtubeID').val() !== '') {

						var inputData = $('#video_Tab input#youtubeID').val();
						if (inputData.indexOf("youtu") > -1) {//youtube
							var newRegExp = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i;
							var matchResult = inputData.match(newRegExp);
							inputData = matchResult[1];
						}
						$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).prev().attr('src', "//www.youtube.com/embed/" + inputData);

					} else if ($('input#vimeoID').val() !== '') {

						var inputData = $('#video_Tab input#vimeoID').val();
						if (inputData.indexOf("vimeo.com") > -1) {//vimeo
							inputData = inputData.match(/player\.vimeo\.com\/video\/([0-9]*)/);
						}
						$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).prev().attr('src', "//player.vimeo.com/video/" + inputData + "?title=0&amp;byline=0&amp;portrait=0");

					} else if ($('input#videoURL').val() !== '') {

						var inputData = $('#video_Tab input#videoURL').val();
						if (inputData.indexOf("app.ifunnels.com") > -1) {//vimeo
							var matchResult = inputData.match(/.*(?:app.ifunnels.com\/video\/\?url=)([^#\&\?]*).*/);
							inputData = matchResult[1];
						}
						$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).prev().attr('src', "//app.ifunnels.com/video/?url=" + inputData);

					}

				}

				/* END SANDBOX */

			}

			//video2 URL
			if ($(styleeditor.activeElement.element).attr('data-type') === 'video2') {
				const sticky = $("#slick_stick").prop('checked');
				const simulate_live = $("#simulate_live").prop('checked');
				const url = $("#videoURL").val();

				const videoWrapper = styleeditor.activeElement.element.parentNode;
				const { cfg } = styleeditor.activeElement.parentBlock.frame.contentWindow;
				const source = { type: `video/${helper.parseMediaType(url)}`, src: url };
				const script = videoWrapper.querySelector('script[type="application/json"]');

				cfg.player.src(source);
				script.innerText = JSON.stringify(source);

				videoWrapper.setAttribute('data-sumulate-live', simulate_live);
				videoWrapper.setAttribute('data-sticky', sticky);

				videoWrapper.setAttribute('data-button-text', $('#button_text').prop('value'));
				videoWrapper.setAttribute('data-button-color', $('#button_color').prop('value'));
				
				/* SANDBOX */

				if (styleeditor.activeElement.sandbox) {

					elementID = $(styleeditor.activeElement.element).attr('id');

					if ($('input#youtubeID').val() !== '') {

						var inputData = $('#video_Tab input#youtubeID').val();
						if (inputData.indexOf("youtu") > -1) {//youtube
							var newRegExp = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i;
							var matchResult = inputData.match(newRegExp);
							inputData = matchResult[1];
						}
						$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).prev().attr('src', "//www.youtube.com/embed/" + inputData);

					} else if ($('input#vimeoID').val() !== '') {

						var inputData = $('#video_Tab input#vimeoID').val();
						if (inputData.indexOf("vimeo.com") > -1) {//vimeo
							inputData = inputData.match(/player\.vimeo\.com\/video\/([0-9]*)/);
						}
						$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).prev().attr('src', "//player.vimeo.com/video/" + inputData + "?title=0&amp;byline=0&amp;portrait=0");

					} else if ($('input#videoURL').val() !== '') {

						var inputData = $('#video_Tab input#videoURL').val();
						if (inputData.indexOf("app.ifunnels.com") > -1) {//vimeo
							var matchResult = inputData.match(/.*(?:app.ifunnels.com\/video\/\?url=)([^#\&\?]*).*/);
							inputData = matchResult[1];
						}
						$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).prev().attr('src', "//app.ifunnels.com/video/?url=" + inputData);

					}

				}

				/* END SANDBOX */
			}

			//forms
			if (styleeditor.activeElement.element.tagName === 'FORM') {

				//sent API or custom action?

				//remove possible confirmation input
				if (styleeditor.activeElement.element.querySelector('input[name="_confirmation"]')) styleeditor.activeElement.element.querySelector('input[name="_confirmation"]').remove();

				//remove the siteID hidden input
				if (styleeditor.activeElement.element.querySelector('input[name="_hiddenInputSiteID"]')) styleeditor.activeElement.element.querySelector('input[name="_hiddenInputSiteID"]').remove();

				if (styleeditor.activeElement.element.querySelector('input[name="_emailto"]')) styleeditor.activeElement.element.querySelector('input[name="_emailto"]').remove();

				if (styleeditor.checkboxEmailForm.checked) {

					styleeditor.activeElement.element.setAttribute('action', baseUrl + bConfig.sentApiURL);
					styleeditor.activeElement.element.setAttribute('data-action', 'sentapi');

					// Insert hidden field for email
					if (styleeditor.inputEmailFormTo.value !== '') {
						let input = document.createElement('input');
						input.type = "hidden";
						input.name = "_emailto";
						input.value = styleeditor.inputEmailFormTo.value;
						styleeditor.activeElement.element.appendChild(input);
					}

					// Insert hidden field for the site ID
					if (typeof siteBuilder.site.data.sites_id !== undefined) {
						let input = document.createElement('input');
						input.type = "hidden";
						input.name = "_hiddenInputSiteID";
						input.value = siteBuilder.site.data.sites_id;
						styleeditor.activeElement.element.appendChild(input);
					}

					//custom confirmation message?
					if (styleeditor.textareaCustomMessage.value !== '') {

						var confirmationInput = document.createElement('input');
						confirmationInput.type = "hidden";
						confirmationInput.name = "_confirmation";
						confirmationInput.value = styleeditor.textareaCustomMessage.value;

						styleeditor.activeElement.element.appendChild(confirmationInput);

					}

					if ($(styleeditor.activeElement.element).closest('body').find('script.emailto').length == 0) {
						$(styleeditor.activeElement.element).closest('body').append('<script class="emailto" type="text/javascript" src="/skin/pagebuilder/build/emailto.bundle.js"></script>');
					}

				} else {

					if (styleeditor.checkboxCustomAction.checked) {

						styleeditor.activeElement.element.setAttribute('action', styleeditor.inputCustomAction.value);
						styleeditor.activeElement.element.setAttribute('data-action', 'custom');

					}

				}

				if (styleeditor.checkboxUseLeadChannels.checked) {
					let _btnText = '';
					if ($(styleeditor.activeElement.element).find('input[type="submit"]').size() > 0) {
						_btnText = $(styleeditor.activeElement.element).find('input[type="submit"]').eq(0).prop('value');
					}
					if ($(styleeditor.activeElement.element).find('button').size() > 0) {
						_btnText = $(styleeditor.activeElement.element).find('button').eq(0).html();
					}
					if ($(styleeditor.selectPages).prop('value') !== '') {
						siteBuilder.site.sitePages.forEach(function (page) {
							if (page.pageID == $(styleeditor.selectPages).prop('value')) {
								$(styleeditor.inputRedirectTo).prop('value', page.name + '.php');
							}
						});
					}
					$.ajax({
						url: appUI.dataUrls.getLeadChannelsForm,
						type: "POST",
						data: {
							lead_id: styleeditor.selectLeadChannels.value,
							currentform: btoa($(styleeditor.activeElement.element).parent().html())
						},
						dataType: "json"
					}).done(function (result) {
						/**
						 * Added attr for form with Lead Channel company ID
						 */
						$(styleeditor.activeElement.element).attr("data-lead-channel", styleeditor.selectLeadChannels.value);

						/** added all attr for form */
						Object.keys(result.form.attr).forEach(function (attr) {
							$(styleeditor.activeElement.element).prop(attr, result.form.attr[attr]);
						});



						if (result.responseCode === 1) {

							let _elements = {
								'input': [],
								'button': []
							};

							//$(styleeditor.activeElement.element).empty();
							$(styleeditor.activeElement.element).find('input:not([type*="submit,hidden"])').each(function () {
								if ($(this).css('display') !== 'none') {
									let _this = this;
									Object.keys(this.attributes).forEach(function (i) {
										_elements['input'].push({ 'attr': _this.attributes[i].name, 'value': _this.attributes[i].value });
									});
								}
							});

							$(styleeditor.activeElement.element).find('button,input[type="submit"],input[type="button"]').each(function () {
								let _this = this;
								Object.keys(this.attributes).forEach(function (i) {
									_elements['button'].push({ 'attr': _this.attributes[i].name, 'value': _this.attributes[i].value, 'parent': $(_this).parent() });
								});
							});

							$(styleeditor.activeElement.element).empty();
							$(styleeditor.activeElement.element).css('min-height', '70px');

							result.form.input.forEach(function (elem) {
								switch (elem.type) {
									case 'text':
										/*
											let _input_text = $('<input type="text" />');
											_elements['input'].forEach(function(attr){
												if(attr.attr !== 'name' && attr.attr !== 'id' && attr.attr !== 'placeholder' && attr.attr !== 'class' && attr.attr !== 'value'){
													_input_text.find('input').attr(attr.attr, attr.value);
												}
											});
											
											_input_text.find('input').prop('name', elem.name);
											_input_text.find('input').prop('type', 'text');
											_input_text.find('input').prop('value', (elem.value !== undefined ? elem.value : ''));
											_input_text.find('input').prop('placeholder', elem.placeholder);
											_input_text.find('input').prop('style', elem.style);
											
											$(styleeditor.activeElement.element).append(_input_text);
											*/

										var checkboxFields = '';
										if (styleeditor.checkboxTriggeredFields.checked == true) {
											checkboxFields = 'float:left;width:auto;';
										}
										$(styleeditor.activeElement.element).append(`<div class="form-group" style="${checkboxFields}"><input type="text" id="${elem.name}" name="${elem.name}" placeholder="${elem.placeholder}" value="${elem.value !== undefined ? elem.value : ''}" class="${elem.class}" /></div>`);
										break;

									case 'hidden':
										$(styleeditor.activeElement.element).append(`<input type="hidden" id="${elem.name}" name="${elem.name}" value="${elem.value !== undefined ? elem.value : ''}">`);
										break;

									case 'submit':
										/*
											let _submit = $('<button />');
											_elements['button'].forEach(function(attr){
												if(attr.attr !== 'name' && attr.attr !== 'id' && attr.attr !== 'placeholder' && attr.attr !== 'class' && attr.attr !== 'value' ){
													_submit.find('button').attr(attr.attr, attr.value);
												}
											});
											_submit.find('button').prop('type', elem.type);
											_submit.find('button').prop('style', elem.style);
											_submit.find('button').html( elem.value !== undefined ? elem.value : '');
											$(styleeditor.activeElement.element).append(_submit);
											*/
										var checkboxFields = '';
										if (styleeditor.checkboxTriggeredFields.checked == true) {
											checkboxFields = ' float:left;width:auto;';
										}
										$(styleeditor.activeElement.element).append(`<button type="${elem.type}" style="${elem.style}${checkboxFields}" class="${elem.class}" >${elem.value !== undefined ? elem.value : ''}</button>`);
										break;
								}
							});

							if (result.form.gdpr != undefined) {
								$(styleeditor.activeElement.element).append(`<div class="gdpr-block">` + result.form.gdpr + `</div>`);
							}

							$(styleeditor.activeElement.element).find('[name="_inputRedirectTo"]').prop('value', styleeditor.inputRedirectTo.value);
							$(styleeditor.activeElement.element).find('[name="_textareaCustomMessageLeadChannel"]').prop('value', styleeditor.textareaCustomMessageLeadChannel.value);

							if ($(styleeditor.selectPages).prop('value') !== '') {
								$(styleeditor.activeElement.element).attr('data-redirect-page', $(styleeditor.selectPages).prop('value'));
							}
							styleeditor.setupCanvasElementsOnElement($(styleeditor.activeElement.element).find('button')[0], 'a.btn, button.btn');
						}
					});

					if ($(styleeditor.activeElement.element).closest('body').find('script.leadchannel').length == 0) {
						$(styleeditor.activeElement.element).closest('body').append('<script class="leadchannel" type="text/javascript" src="/skin/pagebuilder/build/leadchannels.bundle.js"></script>');
					}
				}

			}

			// effects
			var countdownId = $(styleeditor.activeElement.element).attr('data-id');
			if (styleeditor.inputEffectAnimation != null && styleeditor.inputEffectAnimation.value !== '') {
				$(styleeditor.activeElement.element).attr('data-effects', styleeditor.inputEffectAnimation.value);
				$(styleeditor.activeElement.element).attr('data-delayef', styleeditor.inputEffectDelay.value);
			}

			//countdown
			if ($(styleeditor.activeElement.element).data('component') === 'countdown') {
				var textColor = document.querySelector('[name="countdown-textcolor"]').value;
				var panelColor = document.querySelector('[name="countdown-panelcolor"]').value;
				var labelColor = document.querySelector('[name="countdown-labelcolor"]').value;
				var style = document.querySelector('[name="countdown-style"]').value;
				var value = document.querySelector('[name="countdown-value"]').value;
				var type = document.querySelector('[name="countdown-type"]').value;
				var labels = document.querySelector('[name="countdown-labels"]').value;
				var action = document.querySelector('[name="countdown-action"]').value;
				var url = document.querySelector('[name="countdown-redirect"]').value;
				var delay = document.querySelector('[name="countdown-delay"]').value;
				var direction = document.querySelector('[name="countdown-direction"]').value;

				$(styleeditor.activeElement.element).attr('data-value', value);
				$(styleeditor.activeElement.element).attr('data-delay', delay);
				$(styleeditor.activeElement.element).attr('data-textcolor', textColor);
				$(styleeditor.activeElement.element).attr('data-panelcolor', panelColor);
				$(styleeditor.activeElement.element).attr('data-labelcolor', labelColor);
				$(styleeditor.activeElement.element).attr('data-style', style);
				$(styleeditor.activeElement.element).attr('data-type', type);
				$(styleeditor.activeElement.element).attr('data-labels', labels);
				$(styleeditor.activeElement.element).attr('data-action', action);
				$(styleeditor.activeElement.element).attr('data-url', url);
				$(styleeditor.activeElement.element).attr('data-direction', direction);

				// Update countdown
				component.updateCountDown(styleeditor.activeElement.parentBlock);
			}

			//image
			if (styleeditor.activeElement.element.tagName === 'IMG') {
				let theHref;

				//lightbox image
				if ($(styleeditor.activeElement.element).parents(bConfig.imageLightboxWrapper).size() > 0) {
					$(styleeditor.activeElement.element).parents(bConfig.imageLightboxWrapper).find('a').attr(bConfig.imageLightboxAttr, styleeditor.inputCombinedGallery.value);
				}

				//title attribute
				if (styleeditor.inputImageTitle.value !== '') styleeditor.activeElement.element.setAttribute('title', styleeditor.inputImageTitle.value);
				else styleeditor.activeElement.element.removeAttribute('title');

				//alt attribute
				if (styleeditor.inputImageAlt.value !== '') styleeditor.activeElement.element.setAttribute('alt', styleeditor.inputImageAlt.value);
				else styleeditor.activeElement.element.removeAttribute('alt');

				// Link on image? (not for lightbox images)
				if ($(styleeditor.activeElement.element).parents('[data-component="image-lightbox"]').size() === 0) {
					if (styleeditor.selectLinksPages.value !== '#') theHref = styleeditor.selectLinksPages.value;
					if (styleeditor.selectLinksInernal.value !== '#') theHref = styleeditor.selectLinksInernal.value;
					if (styleeditor.inputCustomLink.value !== '') theHref = styleeditor.inputCustomLink.value;

					if (typeof theHref !== 'undefined') {

						if (styleeditor.activeElement.element.parentNode.tagName === 'A') {//parent is already an anchor tag

							styleeditor.activeElement.element.parentNode.href = theHref;

						} else {//no anchor tag yet

							$(styleeditor.activeElement.element).wrap('<a href="' + theHref + '"></a>');

						}

					} else {

						// All link fields are empty; if the active element has a parent anchor tag, remove it
						$(styleeditor.activeElement.element).unwrap();

					}
				}

			}

			// quest-box
			if ($(styleeditor.activeElement.element).attr('data-component') == "quest-box") {

				$(styleeditor.activeElement.element).attr('data-id', document.querySelector('[name="blockid"]').value);

			}

			// quest
			if (styleeditor.activeElement.element.getAttribute('data-component') == 'quest') {
				styleeditor.activeElement.element.setAttribute('data-hover-color', document.querySelector('[name="hover-background-color"]').value || '#97d6ff');

				/** Set blockid attr & remove blockurl */
				styleeditor.activeElement.element.setAttribute('data-blockid', styleeditor.quizAction.value);
				styleeditor.activeElement.element.removeAttribute('data-blockurl');
				styleeditor.activeElement.element.removeAttribute('data-blockpopup');

				/** Set attr block url if him filled */
				if (styleeditor.quizAction.value == 'open-url') {
					styleeditor.activeElement.element.setAttribute('data-blockurl', styleeditor.quizUrl.value);
					styleeditor.activeElement.element.setAttribute('data-blockthanks', utils.custom_base64_encode(styleeditor.quizThanks.value));
				}

				if (styleeditor.quizAction.value == 'open-popup') {
					styleeditor.activeElement.element.setAttribute('data-blockpopup', styleeditor.getRegularPopupId());
				}
			}

			if ($(styleeditor.activeElement.element).attr('data-component') == "grid") {
				if (document.querySelector('[name="custom"]').value !== '') {
					$(styleeditor.activeElement.element).empty();
					var arrCols = document.querySelector('[name="custom"]').value.split(',');
					if (arrCols.length != 0) {
						$.each(arrCols, function (key, value) {
							$(styleeditor.activeElement.element).append('<div class="col-md-' + (value.trim()) + '" data-selector=\'*[data-component="grid"] > div\'><div data-container="true"></div></div>');
							styleeditor.setupCanvasElementsOnElement($(styleeditor.activeElement.element).find('[data-selector=\'*[data-component="grid"] > div\']')[key], '*[data-component="grid"] > div');
						});
					}
				}
			}

			//slideshow
			if (styleeditor.activeElement.element.parentNode.parentNode.parentNode.hasAttribute('data-carousel-item')) {

				var theSlideshow = $(styleeditor.activeElement.element).closest('.carousel')[0];

				//auto play
				if (styleeditor.checkboxSliderAutoplay.checked) {
					theSlideshow.setAttribute('data-ride', 'carousel');
				} else {
					theSlideshow.removeAttribute('data-ride');
				}

				//pause on hover
				if (styleeditor.checkboxSliderPause.checked) {
					theSlideshow.setAttribute('data-pause', 'hover');
				} else {
					theSlideshow.removeAttribute('data-pause');
				}

				//animation
				if (styleeditor.selectSliderAnimation.value === 'carousel-fade' && !theSlideshow.classList.contains('carousel-fade')) {
					theSlideshow.classList.add('carousel-fade');
				} else {
					theSlideshow.classList.remove('carousel-fade');
				}

				//interval
				if (styleeditor.inputSlideInterval.value !== '') {
					theSlideshow.setAttribute('data-interval', styleeditor.inputSlideInterval.value);
				} else {
					theSlideshow.removeAttribute('data-interval');
				}

				//nav arrows
				theSlideshow.classList.remove('nav-arrows-out');
				theSlideshow.classList.remove('nav-arrows-none');
				theSlideshow.classList.remove('nav-arrows-in');

				if (styleeditor.selectSliderNavArrows.value === 'nav-arrows-out') {
					theSlideshow.classList.add('nav-arrows-out');
				} else if (styleeditor.selectSliderNavArrows.value === 'nav-arrows-none') {
					theSlideshow.classList.add('nav-arrows-none');
				} else {
					theSlideshow.classList.add('nav-arrows-in');
				}

				//nav indicators
				theSlideshow.classList.remove('nav-indicators-out');
				theSlideshow.classList.remove('nav-indicators-none');
				theSlideshow.classList.remove('nav-indicators-in');

				if (styleeditor.selectSliderNavIndicators.value === 'nav-indicators-out') {
					theSlideshow.classList.add('nav-indicators-out');
				} else if (styleeditor.selectSliderNavIndicators.value === 'nav-indicators-none') {
					theSlideshow.classList.add('nav-indicators-none');
				} else {
					theSlideshow.classList.add('nav-indicators-in');
				}

			}

			//Map
			if (styleeditor.activeElement.element.classList.contains('mapOverlay') && typeof bConfig.google_api !== 'undefined') {

				var theMap = $(styleeditor.activeElement.element).prev()[0],
					apiInfo = {};

				//setup the data attributes
				if (styleeditor.textareaAddress.value !== '') {
					theMap.setAttribute('data-address', styleeditor.textareaAddress.value);
				} else {
					theMap.removeAttribute('data-address');
				}

				if (styleeditor.textareaInfoMessage.value !== '') {
					theMap.setAttribute('data-info-message', styleeditor.textareaInfoMessage.value);
				} else {
					theMap.removeAttribute('data-info-message');
				}

				if (styleeditor.inputZoomLevel.value !== 0) {
					theMap.setAttribute('data-zoom', styleeditor.inputZoomLevel.value);
				} else {
					theMap.removeAttribute('data-zoom');
				}

				if (styleeditor.checkBoxMapBW.checked) {
					theMap.setAttribute('data-style', 'blackandwhite');
				} else {
					theMap.removeAttribute('data-style');
				}


				//load the Google Maps API
				apiInfo.action = "loadMapAPI";
				apiInfo.key = bConfig.google_api;
				styleeditor.activeElement.parentBlock.frame.contentWindow.postMessage(apiInfo, '*');
				document.getElementById('skeleton').contentWindow.postMessage(apiInfo, '*');

			}

			// Divider
			if (styleeditor.activeElement.element.getAttribute('data-component') === 'divider') {
				const dividerColor = document.querySelector('[name="divider-color"]');
				if (dividerColor) {
					styleeditor.activeElement.element.setAttribute('data-color', dividerColor.value);
					styleeditor.activeElement.element.style.setProperty('--divider-color', dividerColor.value);
				}
			}

			// Radio Button
			if (styleeditor.activeElement.element.getAttribute('data-selector') === 'label') {
				const labelColor = document.querySelector('[name="color"]');
				if (labelColor) {
					styleeditor.activeElement.element.style.setProperty('--color', labelColor.value);
				}
			}

			// Button or link
			if (['button'].indexOf(styleeditor.activeElement.element.parentElement.getAttribute('data-component')) !== -1 || ['nav a', 'ul > li > a', 'img', 'a'].indexOf(styleeditor.activeElement.element.getAttribute('data-selector')) !== -1) {
				/** Set or remove attr for the element */
				if (styleeditor.checkoutSwitcher.checked) {
					styleeditor.activeElement.element.setAttribute('data-checkout', true);
					styleeditor.activeElement.element.setAttribute('data-checkout-display', styleeditor.checkoutSettingsDisplay.value);
					styleeditor.activeElement.element.setAttribute('data-checkout-redirect', styleeditor.checkoutSettingsRedirect.value);
					styleeditor.activeElement.element.setAttribute('data-checkout-membership', styleeditor.checkoutSettingsMembership.value);
					styleeditor.activeElement.element.setAttribute('data-bump', styleeditor.bumpSwitcher.checked);

					/** Create js script and add to frame */
					const script = styleeditor.activeElement.parentFrame.contentDocument.createElement('script');
					script.setAttribute('src', '/skin/ifunnels-studio/dist/js/checkout.bundle.js');
					script.setAttribute('id', 'checkout-js');
					styleeditor.activeElement.parentFrame.contentDocument.body.appendChild(script);

					/** Create css stylesheet */
					const link = styleeditor.activeElement.parentFrame.contentDocument.createElement('link');
					link.setAttribute('href', '/skin/ifunnels-studio/dist/css/checkout.bundle.css');
					link.setAttribute('rel', 'stylesheet');
					link.setAttribute('id', 'checkout-css');
					styleeditor.activeElement.parentFrame.contentDocument.head.appendChild(link);
				} else {
					styleeditor.activeElement.element.removeAttribute('data-checkout');
					styleeditor.activeElement.element.removeAttribute('data-checkout-display');
					styleeditor.activeElement.element.removeAttribute('data-checkout-redirect');
					styleeditor.activeElement.element.removeAttribute('data-checkout-membership');
					styleeditor.activeElement.element.removeAttribute('data-bump');
					styleeditor.activeElement.element.removeAttribute('data-bump-list');

					/** Remove script from frame */
					const script = styleeditor.activeElement.parentFrame.contentDocument.querySelector('script#checkout-js');
					if (script) {
						script.parentElement.removeChild(script);
					}

					/** Remove style from frame */
					const link = styleeditor.activeElement.parentFrame.contentDocument.querySelector('link#checkout-css');
					if (link) {
						link.parentElement.removeChild(link);
					}
				}
			}

			// Chat
			if (styleeditor.activeElement.element.getAttribute('data-component') == 'chat') {

			}

			// NFT
			if (styleeditor.activeElement.element.parentNode.getAttribute('data-component') == 'nft') {
				const { editableAttributes, element, parentFrame } = styleeditor.activeElement;
				const styles = {
					classList: Array.from(element.classList).filter(
						(className) => !["sb_open"].includes(className)
					),
					styles: {},
        		};

				editableAttributes.forEach(attr => {
					const formatAttr = helper.formatToCamelCase(attr); 
					
					if (element.style[formatAttr] && element.style[formatAttr] !== '') {
						styles.styles[formatAttr] = element.style[formatAttr];
					}
				});

				let style_node = element.parentNode.querySelector('script[data-type="styles"][type="application/json"]');

				if (!style_node) {
					style_node = parentFrame.contentDocument.createElement("script");
					style_node.setAttribute("type", "application/json");
					style_node.setAttribute("data-type", "styles");
		  
					element.parentNode.appendChild(style_node);
				}

				style_node.innerText = JSON.stringify(styles);
			}

			if ($(styleeditor.activeElement.element).data('selector') == '.block') {
				$(styleeditor.activeElement.element).prop('id', settingAttrId.value);
			}

			$('#detailsAppliedMessage').fadeIn(600, function () {

				setTimeout(function () { $('#detailsAppliedMessage').fadeOut(1000); }, 3000);

			});

			if (styleeditor.openTargetBlank.checked) {
				$(styleeditor.activeElement.element).attr('target', '_blank');
			}
			//adjust frame height


			if (typeof styleeditor.activeElement.parentBlock.heightAdjustment === 'function') styleeditor.activeElement.parentBlock.heightAdjustment();

			//we've got pending changes
			siteBuilder.site.setPendingChanges(true);

			publisher.publish('onBlockChange', styleeditor.activeElement.parentBlock, 'change');

		},

		/*
			on focus, we'll make the input fields wider
		*/
		animateStyleInputIn: function () {
			$(this).css('position', 'absolute');
			$(this).css('right', '0px');
			$(this).animate({ 'width': '100%' }, 500);
			$(this).focus(function () {
				this.select();
			});

		},

		/*
			on blur, we'll revert the input fields to their original size
		*/
		animateStyleInputOut: function () {

			$(this).animate({ 'width': '42%' }, 500, function () {
				$(this).css('position', 'relative');
				$(this).css('right', 'auto');
			});

		},

		/*
			builds the dropdown with #blocks on this page
		*/
		buildBlocksDropdown: function (currentVal) {
			$(styleeditor.selectLinksInernal).select2('destroy');

			if (typeof currentVal === 'undefined') currentVal = null;

			var x,
				newOption;

			styleeditor.selectLinksInernal.innerHTML = '';

			newOption = document.createElement('OPTION');
			newOption.innerText = styleeditor.selectLinksInernal.getAttribute('data-placeholder');
			newOption.setAttribute('value', '#');
			styleeditor.selectLinksInernal.appendChild(newOption);

			for (x = 0; x < siteBuilder.site.activePage.blocks.length; x++) {

				var frameDoc = siteBuilder.site.activePage.blocks[x].frameDocument;
				var pageContainer = frameDoc.querySelector(bConfig.pageContainer);

				if (pageContainer !== null && pageContainer.children[0]) {

					var theID = pageContainer.children[0].id;

					newOption = document.createElement('OPTION');
					newOption.innerText = '#' + theID;
					newOption.setAttribute('value', '#' + theID);
					if (currentVal === '#' + theID) newOption.setAttribute('selected', true);

					styleeditor.selectLinksInernal.appendChild(newOption);

				}

			}

			$(styleeditor.selectLinksInernal).select2({
				minimumResultsForSearch: -1
			});
			$(styleeditor.selectLinksInernal).trigger('change');

			$(styleeditor.selectLinksInernal).off('change').on('change', function () {
				styleeditor.inputCustomLink.value = this.value;
				styleeditor.resetPageDropdown();
			});

		},

		/*
			blur event handler for the custom link input
		*/
		inputCustomLinkBlur: function (e) {

			var value = e.target.value,
				x;

			//pages match?
			for (x = 0; x < styleeditor.selectLinksPages.querySelectorAll('option').length; x++) {

				if (value === styleeditor.selectLinksPages.querySelectorAll('option')[x].value) {

					styleeditor.selectLinksPages.selectedIndex = x;
					$(styleeditor.selectLinksPages).trigger('change').select2();

				}

			}

			//blocks match?
			styleeditor.selectLinksInernal.querySelectorAll('option').forEach(function (option, i) {

				if (value === option.value) {

					styleeditor.selectLinksInernal.selectedIndex = i;
					$(styleeditor.selectLinksInernal).trigger('change').select2();

				}

			});

		},

		/*
			focus event handler for the custom link input
		*/
		inputCustomLinkFocus: function () {
			styleeditor.resetPageDropdown();
			styleeditor.resetBlockDropdown();
		},

		/*
			builds the dropdown with pages to link to
		*/
		buildPagesDropdown: function (currentVal) {
			$(styleeditor.selectLinksPages).select2('destroy');

			if (typeof currentVal === 'undefined') currentVal = null;

			var x,
				newOption;

			styleeditor.selectLinksPages.innerHTML = '';

			newOption = document.createElement('OPTION');
			newOption.innerText = styleeditor.selectLinksPages.getAttribute('data-placeholder');
			newOption.setAttribute('value', '#');
			styleeditor.selectLinksPages.appendChild(newOption);

			for (x = 0; x < siteBuilder.site.sitePages.length; x++) {

				newOption = document.createElement('OPTION');
				newOption.innerText = siteBuilder.site.sitePages[x].name;
				newOption.setAttribute('value', siteBuilder.site.sitePages[x].name + '.php');
				if (currentVal === siteBuilder.site.sitePages[x].name + '.php') newOption.setAttribute('selected', true);

				styleeditor.selectLinksPages.appendChild(newOption);

			}

			$(styleeditor.selectLinksPages).select2({
				minimumResultsForSearch: -1
			});
			$(styleeditor.selectLinksPages).trigger('change');

			$(styleeditor.selectLinksPages).off('change').on('change', function () {
				styleeditor.inputCustomLink.value = this.value;
				styleeditor.resetBlockDropdown();
			});

		},

		/*
			reset the block link dropdown
		*/
		resetBlockDropdown: function () {
			styleeditor.selectLinksInernal.selectedIndex = 0;
			$(styleeditor.selectLinksInernal).select2('destroy').select2();
		},

		/*
			reset the page link dropdown
		*/
		resetPageDropdown: function () {
			styleeditor.selectLinksPages.selectedIndex = 0;
			$(styleeditor.selectLinksPages).select2('destroy').select2();
		},


		/*
			when the clicked element is an anchor tag (or has a parent anchor tag)
		*/
		editLink: function (el) {

			var theHref;

			$('a#link_Link').parent().show();

			//set theHref
			if ($(el).prop('tagName') === 'A') {

				theHref = $(el).attr('href');

			} else if ($(el).parent().prop('tagName') === 'A') {

				theHref = $(el).parent().attr('href');

			}

			if ($(el).closest(bConfig.navSelector).size() === 1) {

				styleeditor.inputLinkActive.parentNode.style.display = 'block';

				//link is active?
				if (el.parentNode.classList.contains(bConfig.navActiveClass)) {
					//$(styleeditor.inputLinkActive).radiocheck('checked');
					$(styleeditor.inputLinkActive).prop('checked', true);
				} else {
					//$(styleeditor.inputLinkActive).radiocheck('unchecked');
					$(styleeditor.inputLinkActive).prop('checked', false);
				}

			} else {

				styleeditor.inputLinkActive.parentNode.style.display = 'none';

			}

			styleeditor.buildPagesDropdown(theHref);
			styleeditor.buildBlocksDropdown(theHref);
			styleeditor.inputCustomLink.value = theHref;

			//grab an image?
			if (el.querySelector('img')) styleeditor.linkImage = el.querySelector('img');
			else styleeditor.linkImage = null;

			//grab an icon?
			if (el.querySelector('.fa')) styleeditor.linkIcon = el.querySelector('.fa').cloneNode(true);
			else styleeditor.linkIcon = null;
		},

		editEffects: function (el) {
			document.querySelector('#intDelay').value = $(el.element).attr('data-delayef');
			$('select#flgAnimation option').each(function () {
				this.removeAttribute('selected');
			});

			$('select#flgAnimation option').each(function () {
				if ($(this).val() === $(el.element).attr('data-effects')) {
					$(this).attr('selected', true);
				}
			});

			$('#flgAnimation').trigger('change');
		},

		editCountdown: function (el) {
			const url = $(el.element).attr('data-url');

			document.querySelector('[name="countdown-textcolor"]').value = $(el.element).attr('data-textcolor');
			document.querySelector('[name$="labelcolor"]').value = $(el.element).attr('data-labelcolor');
			document.querySelector('[name="countdown-panelcolor"]').value = $(el.element).attr('data-panelcolor');
			document.querySelector('[name="countdown-style"]').value = $(el.element).attr('data-style');
			document.querySelector('[name="countdown-type"]').value = $(el.element).attr('data-type');
			document.querySelector('[name="countdown-delay"]').value = $(el.element).attr('data-delay');
			document.querySelector('[name="countdown-value"]').value = $(el.element).attr('data-value');
			document.querySelector('[name="countdown-redirect"]').value = $(el.element).attr('data-url') || '';
			document.querySelector('[name="countdown-labels"]').value = $(el.element).attr('data-labels');
			document.querySelector('[name="countdown-direction"]').value = $(el.element).attr('data-direction');
			document.querySelector('[name="countdown-action"]').value = $(el.element).attr('data-action');


			const redirectNode = document.querySelector('[name="countdown-redirect"]').parentNode;
			const $children = $(redirectNode).children();
			$children.addClass('hidden');

			switch ($(el.element).attr('data-action')) {
				default: case 'url': {
					$children.eq(3).removeClass('hidden');
					$children.eq(4).removeClass('hidden');
					break;
				}

				case 'redirect': {
					$children.eq(0).removeClass('hidden');
					$children.eq(1).removeClass('hidden');
					break;
				}
			}

			if (url) {
				$("#cd_page-select").select2("val", url.substring(0, url.length - 4));
			}
			
			$('[name="countdown-labels"]').trigger('change', [true]);
			$('[name="countdown-style"]').trigger('change', [true]);
			$('[name="countdown-type"]').trigger('change', [true]);
			$('[name="countdown-direction"]').trigger('change', [true]);
			$('[name="countdown-action"]').trigger('change', [true]);

			// this.changeTypeFunc(el.element);
		},
		/*
			when the clicked element is an image
		*/
		editImage: function (el) {
			var theHref;

			$('a#img_Link').parent().show();
			$('a#link_Link').parent().show();

			// Link stuff
			if (document.querySelector('[name="text"]') != null) {
				document.querySelector('[name="text"]').parentNode.style.display = 'none';
			}
			styleeditor.inputLinkActive.parentNode.style.display = 'none';

			if ($(el).parent().prop('tagName') === 'A') theHref = $(el).parent().attr('href');
			else theHref = '';

			styleeditor.buildPagesDropdown(theHref);
			styleeditor.buildBlocksDropdown(theHref);
			styleeditor.inputCustomLink.value = theHref;

			//set the current SRC
			$('.imageFileTab').find('input#imageURL').val($(el).attr('src'));

			//reset the file upload
			$('.imageFileTab').find('a.fileinput-exists').click();

			//are we dealing with a lightbox image?
			if ($(el).parents(bConfig.imageLightboxWrapper).size() > 0) {
				if ($(el).parents(bConfig.imageLightboxWrapper).find('a')[0].hasAttribute(bConfig.imageLightboxAttr)) {
					styleeditor.inputCombinedGallery.value = $(el).parents(bConfig.imageLightboxWrapper).find('a').attr(bConfig.imageLightboxAttr);
				} else {
					styleeditor.inputCombinedGallery.value = "";
				}
				styleeditor.inputCombinedGallery.style.display = 'block';
			} else {
				styleeditor.inputCombinedGallery.value = "";
				styleeditor.inputCombinedGallery.style.display = 'none';
			}

			//image title
			if (el.hasAttribute('title')) styleeditor.inputImageTitle.value = el.getAttribute('title');

			//image alt
			if (el.hasAttribute('alt')) styleeditor.inputImageAlt.value = el.getAttribute('alt');

		},

		/*
			when the clicked element is a video element
		*/
		editVideo: function (el) {
			const URI = require('urijs');

			const { query } = URI.parse($(el).prev().attr("src"));
			const { url, simulate_live } = URI.parseQuery(query);
			const $iframe = $(el).prev();

			$('a#video_Link').parent().show();
			$('a#video_Link').click();

			$('#video_Tab input#videoURL').val(url);
			$('#simulate_live').prop('checked', parseInt(simulate_live));

			$('#slick_stick').prop('checked', !$iframe.attr('data-sticky') ? false : !($iframe.attr('data-sticky') === 'false'));
		},

		editVideo2: function(el) {
			const videoWrapper = el.parentNode;

			if (!videoWrapper.querySelector('script[type="application/json"]')) {
				return;
			}

			const { src } = JSON.parse(
				videoWrapper.querySelector('script[type="application/json"]').innerText
			);

			$('a#video_Link').parent().show();
			$('a#video_Link').click();

			if (src) {
				$('#video_Tab input#videoURL').val(src);
			}

			$('#simulate_live').prop('checked', !videoWrapper.getAttribute('data-sumulate-live') ? false : !(videoWrapper.getAttribute('data-sumulate-live') === 'false')).trigger('change');
			$('#slick_stick').prop('checked', !videoWrapper.getAttribute('data-sticky') ? false : !(videoWrapper.getAttribute('data-sticky') === 'false'));

			if (videoWrapper.getAttribute('data-button-text')) {
				$('#button_text').prop('value', videoWrapper.getAttribute('data-button-text'));
			}

			if (videoWrapper.getAttribute('data-button-color')) {
				$('#button_color').prop('value', videoWrapper.getAttribute('data-button-color'));
				$('#button_color').spectrum('set', videoWrapper.getAttribute('data-button-color'));
			}
		},

		editChat: function (el) {
			$('a#webinar_Link').parent().show();
			
			$('#chatModal').on('shown.bs.modal', () => {
				webinar.init(el.element, el);
			});

			const sec = $('#webinar_sec');
			const username = $('#webinar_username');
			const message = $('#webinar_message');

			$('#clear_all_messages')
				.off('click')
				.on('click', function(e) {
					e.preventDefault();
					webinar.clearAllMessages();
				});

			$('#add_webinar_message')
				.off('click')
				.on('click', function(e) {
					e.preventDefault();
					webinar.addMessage(sec.prop('value'), username.prop('value'), message.prop('value'));

					sec.prop('value', '');
					username.prop('value', '');
					message.prop('value', '');
				});
		},

		/*
			when the clicked element is an fa icon
		*/
		editIcon: function () {

			$('a#icon_Link').parent().show();

			//get icon class name, starting with fa-
			var get = $.grep(this.activeElement.element.className.split(" "), function (v, i) {

				return v.indexOf('fa-') === 0;

			}).join();

			$('select#icons option').each(function () {

				this.removeAttribute('selected');

				if ($(this).val() === get) {

					$(this).attr('selected', true);

					$('#icons').trigger('chosen:updated');

				}

			});

		},


		editNavbar: function (element) {

			var links,
				buttons;

			$('a#menuitems_Link').parent().show();

			//retrieve the links

			if (styleeditor.activeElement.element.hasAttribute('class')) {

				if (styleeditor.activeElement.element.getAttribute('class').indexOf('sbpro-navbar-left') !== -1) {

					links = styleeditor.activeElement.element.querySelectorAll('.collapse > ul:nth-child(1) a:not(.btn)');
					buttons = styleeditor.activeElement.element.querySelectorAll('.collapse a.btn');

				} else if (styleeditor.activeElement.element.getAttribute('class').indexOf('sbpro-navbar-left-right') !== -1) {

					links = styleeditor.activeElement.element.querySelectorAll('.collapse > ul:nth-child(1) a:not(.btn)');
					buttons = styleeditor.activeElement.element.querySelectorAll('.collapse a.btn');

				} else if (styleeditor.activeElement.element.getAttribute('class').indexOf('sbpro-navbar-right') !== -1) {

					links = styleeditor.activeElement.element.querySelectorAll('.collapse > ul:nth-child(2) a:not(.btn)');
					buttons = styleeditor.activeElement.element.querySelectorAll('.collapse a.btn');

				} else if (styleeditor.activeElement.element.getAttribute('class').indexOf('sbpro-navbar-centered') !== -1) {

					links = styleeditor.activeElement.element.querySelectorAll('.collapse > ul:nth-child(1) a:not(.btn)');
					buttons = styleeditor.activeElement.element.querySelectorAll('.collapse a.btn');

				}

			}
		},

		editForm: function (form) {

			var email;

			$(styleeditor.selectPages).find('option').remove();

			$('a#form_Link').parent().show();

			if (form.hasAttribute('data-action')) {

				if (form.getAttribute('data-action') === 'sentapi') {

					//email = form.getAttribute('action').replace(bConfig.sentApiURL, '');
					email = $(form).find('[name="_emailto"]').prop('value');

					styleeditor.checkboxEmailForm.checked = true;
					styleeditor.inputEmailFormTo.removeAttribute('disabled');
					styleeditor.textareaCustomMessage.removeAttribute('disabled');
					styleeditor.inputEmailFormTo.value = email;
					styleeditor.checkboxCustomAction.checked = false;
					styleeditor.inputCustomAction.value = "";
					styleeditor.inputCustomAction.setAttribute('disabled', false);
					styleeditor.textareaCustomMessageLeadChannel.setAttribute('disabled', false);

					$('[data-form-type]').hide();
					$('[data-form-type="email"]').show();

					//confirmation input?
					if (form.querySelector('input[name="_confirmation"]')) {
						styleeditor.textareaCustomMessage.value = form.querySelector('input[name="_confirmation"]').value;
					}

				} else if (form.getAttribute('data-action') === 'custom') {

					styleeditor.checkboxEmailForm.checked = false;
					styleeditor.inputEmailFormTo.setAttribute('disabled', true);
					styleeditor.textareaCustomMessage.setAttribute('disabled', true);
					styleeditor.textareaCustomMessageLeadChannel.setAttribute('disabled', false);

					//styleeditor.inputEmailFormTo.value = "";
					styleeditor.textareaCustomMessage.value = "";
					styleeditor.checkboxCustomAction.checked = true;
					styleeditor.inputCustomAction.value = form.getAttribute('action');
					styleeditor.inputCustomAction.removeAttribute('disabled');


					$('[data-form-type]').hide();
					$('[data-form-type="action"]').show();

				}
			} else {

				//nothing set, disable both options
				styleeditor.checkboxEmailForm.checked = false;
				styleeditor.inputEmailFormTo.setAttribute('disabled', true);
				styleeditor.textareaCustomMessage.setAttribute('disabled', true);
				//styleeditor.inputEmailFormTo.value = "";
				styleeditor.textareaCustomMessage.value = "";
				styleeditor.checkboxCustomAction.checked = false;
				styleeditor.inputCustomAction.value = "";
				styleeditor.inputCustomAction.setAttribute('disabled', false);

			}

			if (form.getAttribute('data-lead-channel') !== null) {
				styleeditor.checkboxUseLeadChannels.checked = true;
				styleeditor.selectLeadChannels.removeAttribute('disabled');
				styleeditor.textareaCustomMessageLeadChannel.removeAttribute('disabled');
				styleeditor.inputRedirectTo.removeAttribute('disabled');
				$(styleeditor.selectLeadChannels).find(`option[value="${form.getAttribute('data-lead-channel')}"]`).prop('selected', 'selected');

				styleeditor.inputRedirectTo.value = $(form).find('[name="_inputRedirectTo"]').prop('value');
				styleeditor.textareaCustomMessageLeadChannel.value = $(form).find('[name="_textareaCustomMessageLeadChannel"]').prop('value');

				$('[data-form-type]').hide();
				$('[data-form-type="leadchannels"]').show();
			}

			$(styleeditor.selectPages).append(`<option value="">Select Page</option>`);
			siteBuilder.site.sitePages.forEach(function (page) {
				$(styleeditor.selectPages).append(`<option value="${page.pageID}" ${$(styleeditor.activeElement.element).data('redirect-page') == page.pageID ? "selected" : ""}>${page.name}</option>`);
			});
			$('#selectPages').select2('val', $(styleeditor.activeElement.element).data('redirect-page'));

			if (styleeditor.checkboxTriggeredOptin !== null) {
				if ($(styleeditor.activeElement.element).attr('data-triggered-optin') !== undefined)
					styleeditor.checkboxTriggeredOptin.checked = true;
			}

			if (styleeditor.checkboxTriggeredFields !== null) {
				if ($(styleeditor.activeElement.element).attr('data-triggered-fields') !== undefined)
					styleeditor.checkboxTriggeredFields.checked = false;
			}
		},


		editSlideshow: function (slideshow) {

			$('a#slideshow_Link').parent().show();

			//auto play
			if (slideshow.hasAttribute('data-ride') && slideshow.getAttribute('data-ride') === 'carousel') {
				$(styleeditor.checkboxSliderAutoplay).bootstrapSwitch('state', true, true);
			} else {
				$(styleeditor.checkboxSliderAutoplay).bootstrapSwitch('state', false, true);
			}

			//pause on hover
			if (slideshow.hasAttribute('data-pause') && slideshow.getAttribute('data-pause') === 'hover') {
				$(styleeditor.checkboxSliderPause).bootstrapSwitch('state', true, true);
			} else {
				$(styleeditor.checkboxSliderPause).bootstrapSwitch('state', false, true);
			}

			//animation
			if (slideshow.classList.contains('carousel-fade')) {
				styleeditor.selectSliderAnimation.value = "carousel-fade";
			} else {
				styleeditor.selectSliderAnimation.value = "";
			}
			$(styleeditor.selectSliderAnimation).trigger('change');

			//interval
			if (slideshow.hasAttribute('data-interval')) {
				styleeditor.inputSlideInterval.value = slideshow.getAttribute('data-interval');
			} else {
				styleeditor.inputSlideInterval.value = "";
			}

			//nav arrows
			if (slideshow.classList.contains('nav-arrows-out')) {
				styleeditor.selectSliderNavArrows.value = 'nav-arrows-out';
			} else if (slideshow.classList.contains('nav-arrows-none')) {
				styleeditor.selectSliderNavArrows.value = 'nav-arrows-none';
			} else {
				styleeditor.selectSliderNavArrows.value = 'nav-arrows-in';
			}
			$(styleeditor.selectSliderNavArrows).trigger('change');

			//nav indicators
			if (slideshow.classList.contains('nav-indicators-out')) {
				styleeditor.selectSliderNavIndicators.value = 'nav-indicators-out';
			} else if (slideshow.classList.contains('nav-indicators-none')) {
				styleeditor.selectSliderNavIndicators.value = 'nav-indicators-none';
			} else {
				styleeditor.selectSliderNavIndicators.value = 'nav-indicators-in';
			}
			$(styleeditor.selectSliderNavIndicators).trigger('change');

		},

		editMap: function (map) {

			$('a#map_Link').parent().show();

			if (map.hasAttribute('data-address')) styleeditor.textareaAddress.value = map.getAttribute('data-address');

			if (map.hasAttribute('data-info-message')) styleeditor.textareaInfoMessage.value = map.getAttribute('data-info-message');

			if (map.hasAttribute('data-zoom')) styleeditor.inputZoomLevel.value = map.getAttribute('data-zoom');

			if (map.hasAttribute('data-style') && map.getAttribute('data-style') === 'blackandwhite') {
				$(styleeditor.checkBoxMapBW).bootstrapSwitch('state', true, true);
			} else {
				$(styleeditor.checkBoxMapBW).bootstrapSwitch('state', false, true);
			}

		},

		editCode: function (code) {
			$('a#code_Link').parent().show();
			var dataCode;
			dataCode = $(code.element).find('.code').data('option');
			if (dataCode != undefined) {
				styleeditor.textareaCodeField.value = decodeURIComponent(window.atob(dataCode).split('').map(function (c) { return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2); }).join(''));
			} else {
				styleeditor.textareaCodeField.value = '';
			}
		},

		updateCode: function () {
			var dataCode;
			dataCode = styleeditor.textareaCodeField.value;
			$(styleeditor.activeElement.element).find('.code').attr('data-option', window.btoa(encodeURIComponent(dataCode).replace(/%([0-9A-F]{2})/g, function toSolidBytes(match, p1) { return String.fromCharCode('0x' + p1); })));
			//$(styleeditor.activeElement.element).find('.code').html( dataCode );
			$('#codeModal').modal('hide');
			siteBuilder.site.setPendingChanges(true);
		},

		editBlock: function (block) {
			$(this.settingAttrId).on('focus', this.animateStyleInputIn).on('blur', this.animateStyleInputOut);
			$('a#setting_Link').parent().show();
			$(this.settingAttrId).prop('value', $(block).prop('id'));
		},

		/**
		 * Edit Quiz
		 */
		editQuiz: function (data) {
			$('a#quiz_Link').parent().show();

			/** Added animate for a input */
			$(this.quizUrl)
				.on('focus', this.animateStyleInputIn)
				.on('blur', this.animateStyleInputOut);

			const { element } = data;
			const selectedAction = element.getAttribute('data-blockid') || '';
			let options = [
				{
					value: '',
					name: ' - select -'
				},
				{
					value: 'open-url',
					name: 'Open Url'
				},
				{
					value: 'open-popup',
					name: 'Show Popup Upon Completion'
				}
			];

			options = options.concat(this.getListQuestionBox(element));

			/** Remove all option in a select element */
			this.quizAction.querySelectorAll('option').forEach(option => this.quizAction.removeChild(option));

			/** Set options for a select element */
			options.forEach((option) => {
				const optionDom = document.createElement('option');
				optionDom.value = option.value;
				optionDom.innerText = option.name;

				if (option.value == selectedAction) {
					optionDom.selected = true;
				}

				/** Disabled option if not created Regular popup */
				if (option.value == 'open-popup') {
					if (!this.isCreatedReqularPopup()) {
						optionDom.setAttribute('disabled', 'true');
					}
				}

				this.quizAction.appendChild(optionDom);
			});

			/** Called trigger for update select2 */
			$(this.quizAction).trigger('change');

			this.quizUrl.value = element.getAttribute('data-blockurl') || null;
			this.quizThanks.value = utils.custom_base64_decode(element.getAttribute('data-blockthanks')) || null;
		},

		/** Edit Btn */
		editBtn: function (el) {
			const { element } = el;

			if( $('a#checkout_Link').length == 0 ) return;

			$('a#checkout_Link').parent().show();

			if (element.getAttribute('data-checkout')) {
				styleeditor.checkoutSwitcher.checked = true;
				$(styleeditor.checkoutSwitcher).trigger('change');

				/** Set value for input the redirect */
				styleeditor.checkoutSettingsRedirect.value = element.getAttribute('data-checkout-redirect');

				/** Set value for select the display */
				styleeditor
					.checkoutSettingsDisplay
					.querySelector(`option[value="${element.getAttribute('data-checkout-display')}"]`)
					.setAttribute('selected', 'selected');

				/** Called trigger for update select2 */
				$(styleeditor.checkoutSettingsDisplay).trigger('change');

				const option = styleeditor.checkoutSettingsMembership.querySelector(`option[value="${element.getAttribute('data-checkout-membership')}"]`);
				if (option) {
					option.setAttribute("selected", "selected");
				}
					
				/** Called trigger for update select2 */
				$(styleeditor.checkoutSettingsMembership).trigger('change');

				if (element.getAttribute('data-bump') != null && element.getAttribute('data-bump') == 'true') {
					styleeditor.bumpSwitcher.checked = element.getAttribute('data-bump');
					$(styleeditor.bumpSwitcher).trigger('change');

					const bumpList = JSON.parse(element.getAttribute('data-bump-list')) || [];

					document.querySelector('a[href="#bumpModal"]')
						.innerHTML = `<span class="label label-warning m-r-10">${bumpList.length}</span>Select Products`;
				}
			} else {
				styleeditor.checkoutSwitcher.checked = false;
				$(styleeditor.checkoutSwitcher).trigger('change');
				styleeditor.checkoutSettingsRedirect.value = '';

				var options = styleeditor
					.checkoutSettingsDisplay
					.querySelectorAll(`option`);

				options.forEach(option => option.removeAttribute('selected'));
				options[0].setAttribute('selected', 'selected');

				/** Called trigger for update select2 */
				$(styleeditor.checkoutSettingsDisplay).trigger('change');

				var options = styleeditor
					.checkoutSettingsMembership
					.querySelectorAll(`option`);

				options.forEach(option => option.removeAttribute('selected'));
				if (options[0]) {
					options[0].setAttribute("selected", "selected");
				}

				/** Called trigger for update select2 */
				$(styleeditor.checkoutSettingsMembership).trigger('change');
			}
		},

		editNft: function (el) {
			$('a#nft_Link').parent().show();
		},

		/** Created regular popup? */
		isCreatedReqularPopup: function () {
			return siteBuilder.site.activePage.popups.some(popup => popup.popupType === 'regular');
		},

		/** Return regular popup id */
		getRegularPopupId: function () {
			let regularPopup = null;
			siteBuilder.site.activePage.popups.forEach(popup => {
				if (popup.popupType === 'regular') {
					regularPopup = popup;
				}
			});

			return regularPopup.popupID || null;
		},

		/** Callback for changes a select Quiz Action */
		eventQuizAction: function (e) {

			/** Hide or show a groups block Redirect / Thanks */
			if (e.currentTarget.value === 'open-url') {
				this.quizUrl.parentElement.classList.remove('hidden');
				this.quizThanks.parentElement.classList.remove('hidden');
			} else {
				this.quizUrl.parentElement.classList.add('hidden');
				this.quizThanks.parentElement.classList.add('hidden');
			}
		},

		/*
			delete selected element
		*/
		deleteElement: function () {

			publisher.publish('onBeforeDelete');

			var toDel,
				daddy,
				slideShowDeleted = false;


			//determine what to delete
			if (styleeditor.activeElement.element.parentNode.parentNode.parentNode.hasAttribute('data-carousel-item')) {

				toDel = $(styleeditor.activeElement.element.parentNode.parentNode.parentNode);

				slideShowDeleted = true;

			} else if ($(styleeditor.activeElement.element).prop('tagName') === 'A') {//ancor

				if ($(styleeditor.activeElement.element).parent().prop('tagName') === 'LI') {//clone the LI

					toDel = $(styleeditor.activeElement.element).parent();

				} else {

					toDel = $(styleeditor.activeElement.element);

				}

			} else if ($(styleeditor.activeElement.element).prop('tagName') === 'IMG') {//image

				if ($(styleeditor.activeElement.element).parent().prop('tagName') === 'A') {//clone the A

					toDel = $(styleeditor.activeElement.element).parent();

				} else {

					toDel = $(styleeditor.activeElement.element);

				}

			} else if (styleeditor.activeElement.element.classList.contains('frameCover')) {//video

				toDel = $(styleeditor.activeElement.element).closest('*[data-component="video"]');

				const { parentFrame } = styleeditor.activeElement;
				const script = parentFrame.contentDocument.querySelector('script[src="/skin/ifunnels-studio/dist/js/stick.bundle.js"]');
				const link = parentFrame.contentDocument.querySelector('link[href="/skin/ifunnels-studio/dist/css/stick.bundle.css"]');

				if (script) {
					script.parentNode.removeChild(script);
				}

				if (link) {
					link.parentNode.removeChild(link);
				} 

			} else if (styleeditor.activeElement.element.classList.contains('mapOverlay')) {

				toDel = $(styleeditor.activeElement.element).closest('*[data-component="map"]');

			} else {//everything else

				toDel = $(styleeditor.activeElement.element);

			}

			//remove empty spaces from parent
			daddy = toDel[0].parentNode;


			toDel.fadeOut(500, function () {

				var randomEl = $(this).closest('body').find('*:first'),
					daddysDaddy;

				toDel.remove();

				/* SANDBOX */

				var elementID = $(styleeditor.activeElement.element).attr('id');

				$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).remove();

				/* END SANDBOX */

				if (slideShowDeleted && typeof bConfig.rebuildSlideshowNavigation === 'function') bConfig.rebuildSlideshowNavigation($(daddy).closest('.carousel')[0]);

				if (typeof styleeditor.activeElement.parentBlock.heightAdjustment === 'function') styleeditor.activeElement.parentBlock.heightAdjustment();

				//we've got pending changes
				siteBuilder.site.setPendingChanges(true);

				if (daddy.hasAttribute('data-component') && daddy.querySelectorAll('*').length === 0) {

					daddysDaddy = daddy.parentNode;

					daddy.remove();

					if (daddysDaddy.querySelectorAll('*').length === 0) daddysDaddy.innerHTML = '';

				} else {

					if (daddy.querySelectorAll('*').length === 0) daddy.innerHTML = '';

				}



				//if daddy is an empty data-component, delete it
				if (daddy.hasAttribute('data-component') && daddy.querySelectorAll('*').length === 0) daddy.remove();

			});

			if ($(styleeditor.activeElement.element).attr('data-component') == 'quest-box') {
				$(styleeditor.activeElement.element).parent().find('[data-component="quest-box"]').remove();
			}


			$('#deleteElement').modal('hide');

			styleeditor.closeStyleEditor();

			publisher.publish('onBlockChange', styleeditor.activeElement.parentBlock, 'change');

			setTimeout(() => {
				siteBuilder.site.activePage.variants = ['#'];
				publisher.publish('onChangedStatus', { checked: true })
			}, 5000);
		},

		/**
		 * Set Gradient for block
		 */
		gradientSave: function () {
			$(styleeditor.activeElement.element).attr('data-option', $(styleeditor.textareaGradxCode).data('option'));
			let params = atob($(styleeditor.textareaGradxCode).data('option'));
			params = JSON.parse(params);

			var len = params.sliders.length;

			if (len === 1) {
				//since only one slider , so simple background
				style_str = this.sliders[0][0];
			} else {
				var style_str = "", suffix = "";
				for (var i = 0; i < len; i++) {
					if (params.sliders[i][1] == "") {
						style_str += suffix + (params.sliders[i][0]);

					} else {
						if (params.sliders[i][1] > 100) {
							params.sliders[i][1] = 100;
						}
						style_str += suffix + (params.sliders[i][0] + " " + params.sliders[i][1] + "%");

					}
					suffix = " , "; //add , from next iteration
				}

				if (params.type == 'linear') {
					//direction, [color stoppers]
					style_str = params.direction + " , " + style_str; //add direction for gradient
				} else {
					//position, type size, [color stoppers]
					style_str = "ellipse at center , " + style_str;
				}
			}

			$(styleeditor.formStyle).find('[name="background-image"]').prop('value', `${params.type === 'linear' ? 'linear' : 'radial'}-gradient(${style_str})`);
			$('#gradientModal').modal('hide');
			$('#gradX').empty();

		},


		/*
			clones the selected element
		*/
		cloneElement: function () {

			publisher.publish('onBeforeClone');

			var theClone, theClone2, theOne, cloned, elementID, slideShowCloned = false;

			styleeditor.activeElement.removeOutline();

			if (styleeditor.activeElement.element.hasAttribute('data-parent')) {//clone the parent element

				theClone = $(styleeditor.activeElement.element).parent().clone();
				theClone.find($(styleeditor.activeElement.element).prop('tagName')).attr('style', '');

				theClone2 = $(styleeditor.activeElement.element).parent().clone();
				theClone2.find($(styleeditor.activeElement.element).prop('tagName')).attr('style', '');

				theOne = theClone.find($(styleeditor.activeElement.element).prop('tagName'));
				cloned = $(styleeditor.activeElement.element).parent();

			} else if (styleeditor.activeElement.element.tagName === 'LI') {

				theClone = $(styleeditor.activeElement.element).clone();

				theClone2 = $(styleeditor.activeElement.element).clone();

				theOne = theClone;
				cloned = $(styleeditor.activeElement.element);

			} else if (styleeditor.activeElement.element.parentNode.parentNode.parentNode.hasAttribute('data-carousel-item')) {

				theClone = $(styleeditor.activeElement.element.parentNode.parentNode.parentNode).clone();

				theClone.removeClass('active');

				theOne = theClone.find($(styleeditor.activeElement.element).prop('tagName'));

				cloned = $(styleeditor.activeElement.element.parentNode.parentNode.parentNode);

				slideShowCloned = theClone;

			} else if (styleeditor.activeElement.element.hasAttribute('data-component') && styleeditor.activeElement.element.getAttribute('data-component') === 'grid') {

				theClone = $(styleeditor.activeElement.element).closest('*[data-component]').clone();
				theOne = theClone;

				cloned = $(styleeditor.activeElement.element);

			} else if ($(styleeditor.activeElement.element).closest('*[data-component]')[0] !== undefined) {

				theClone = $(styleeditor.activeElement.element).closest('*[data-component]').clone();

				if ($(styleeditor.activeElement.element).closest('*[data-component]').attr('data-component') === 'video') {
					theOne = theClone.find('.frameCover');
				} else {
					theOne = theClone.find($(styleeditor.activeElement.element).prop('tagName'));
				}

				cloned = $(styleeditor.activeElement.element).closest('*[data-component]');

				if ($(styleeditor.activeElement.element).closest('*[data-component]').attr('data-component') === 'quest-box') {
					cloned.attr('data-id', styleeditor.makedataid());
					cloned.hide();
				}

			} else if (styleeditor.activeElement.element.getAttribute('data-selector') == '.block') {
				let _blc = {
					src: $(styleeditor.activeElement.parentBlock.frame).prop('src'),
					frames_original_url: styleeditor.activeElement.parentBlock.originalUrl,
					frames_height: styleeditor.activeElement.parentBlock.frameHeight.toString(),
					frames_content: `<html>${$(styleeditor.activeElement.parentBlock.frame).contents().find('html').html()}</html>`,
					frames_global: styleeditor.activeElement.parentBlock.global ? '1' : '0'
				};

				var newBlock = siteBuilder.site.initBlock();

				newBlock.id = null;
				newBlock.page = siteBuilder.site.activePage;
				if (_blc.frames_global === '1') newBlock.global = true;
				newBlock.createParentLI(_blc.frames_height);
				newBlock.createFrame(_blc, true);
				newBlock.createFrameCover();
				newBlock.insertBlockIntoDom(siteBuilder.site.activePage.parentUL);

				siteBuilder.site.activePage.blocks.push(newBlock);
				siteBuilder.site.pages[siteBuilder.site.activePage.name].blocks.push(_blc);
				siteBuilder.site.setPendingChanges(true);

				return;
			}
			else {//clone the element itself

				theClone = $(styleeditor.activeElement.element).clone();

				//theClone.attr('style', '');

				/*if( styleeditor.activeElement.sandbox ) {
					theClone.attr('id', '').uniqueId();
				}*/

				theClone2 = $(styleeditor.activeElement.element).clone();
				//theClone2.attr('style', '');

				/*
				if( styleeditor.activeElement.sandbox ) {
					theClone2.attr('id', theClone.attr('id'));
				}*/

				theOne = theClone;
				cloned = $(styleeditor.activeElement.element);

			}

			theOne[0].classList.remove('sb_open');

			cloned.after(theClone);

			/* SANDBOX */

			if (styleeditor.activeElement.sandbox) {

				elementID = $(styleeditor.activeElement.element).attr('id');
				$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).after(theClone2);

			}

			/* END SANDBOX */

			//make sure the new element gets the proper events set on it
			var newElement = new canvasElement(theOne.get(0));
			newElement.setParentBlock();
			newElement.activate();
			newElement.unsetNoIntent();

			styleeditor.setupCanvasElements(styleeditor.activeElement.parentBlock);

			//possible height adjustments
			if (typeof styleeditor.activeElement.parentBlock.heightAdjustment === 'function') styleeditor.activeElement.parentBlock.heightAdjustment();

			//we've got pending changes
			siteBuilder.site.setPendingChanges(true);

			publisher.publish('onBlockChange', styleeditor.activeElement.parentBlock, 'change');

			if (slideShowCloned && typeof bConfig.rebuildSlideshowNavigation === 'function') bConfig.rebuildSlideshowNavigation($(styleeditor.activeElement.element).closest('.carousel')[0]);

		},


		/*
			resets the active element
		*/
		resetElement: function () {

			if ($(styleeditor.activeElement.element).closest('body').width() !== $(styleeditor.activeElement.element).width()) {

				$(styleeditor.activeElement.element).attr('style', '').css({ 'outline': '3px dashed red', 'cursor': 'pointer' });

			} else {

				$(styleeditor.activeElement.element).attr('style', '').css({ 'outline': '3px dashed red', 'outline-offset': '-3px', 'cursor': 'pointer' });

			}

			/* SANDBOX */

			if (styleeditor.activeElement.sandbox) {

				var elementID = $(styleeditor.activeElement.element).attr('id');
				$('#' + styleeditor.activeElement.sandbox).contents().find('#' + elementID).attr('style', '');

			}

			/* END SANDBOX */

			$('#styleEditor form#stylingForm').height($('#styleEditor form#stylingForm').height() + "px");

			$('#styleEditor form#stylingForm .form-group:not(#styleElTemplate)').fadeOut(500, function () {

				$(this).remove();

			});


			//reset icon

			if (styleeditor._oldIcon[$(styleeditor.activeElement.element).attr('id')] !== null) {

				var get = $.grep(styleeditor.activeElement.element.className.split(" "), function (v, i) {

					return v.indexOf('fa-') === 0;

				}).join();

				$(styleeditor.activeElement.element).removeClass(get).addClass(styleeditor._oldIcon[$(styleeditor.activeElement.element).attr('id')]);

				$('select#icons option').each(function () {

					if ($(this).val() === styleeditor._oldIcon[$(styleeditor.activeElement.element).attr('id')]) {

						$(this).attr('selected', true);
						$('#icons').trigger('chosen:updated');

					}

				});

			}

			setTimeout(function () { styleeditor.buildeStyleElements($(styleeditor.activeElement.element).attr('data-selector')); }, 550);

			siteBuilder.site.setPendingChanges(true);

			publisher.publish('onBlockChange', styleeditor.activeElement.parentBlock, 'change');

		},


		resetSelectLinksPages: function () {

			$('#internalLinksDropdown').select2('val', '#');

		},

		resetSelectLinksInternal: function () {

			$('#pageLinksDropdown').select2('val', '#');

		},

		resetSelectAllLinks: function () {

			$('#internalLinksDropdown').select2('val', '#');
			$('#pageLinksDropdown').select2('val', '#');
			this.select();

		},

		/*
			hides file upload forms
		*/
		hideFileUploads: function () {

			$('form#imageUploadForm').hide();
			$('#imageModal #uploadTabLI').hide();

		},


		/*
			closes the style editor
		*/
		closeStyleEditor: function (e) {

			if (e !== undefined) e.preventDefault();

			if (styleeditor.activeElement.editableAttributes && styleeditor.activeElement.editableAttributes.indexOf('content') === -1) {
				styleeditor.activeElement.removeOutline();
				styleeditor.activeElement.activate();
			}

			if (styleeditor.styleEditor.classList.contains('open')) {

				styleeditor.toggleSidePanel('close');

			}

		},


		/*
			toggles the side panel
		*/
		toggleSidePanel: function (val) {

			if (val === 'open') styleeditor.styleEditor.classList.add('open');
			else if (val === 'close') styleeditor.styleEditor.classList.remove('open');

			//height adjustment
			setTimeout(function () {
				siteBuilder.site.activePage.heightAdjustment();
			}, 1000);

		},

		dividerClick: function (el) {
			$(el.currentTarget).prev('input:radio').prop('checked');
			$('.uncode_radio_image_src').removeClass('checked');
			$(el.currentTarget).addClass('checked');
		},

		modalShapeSave: function () {
			if ($('input[name="uncode_radio_image"]:checked').length > 0) {
				let shapePosition = $('#dividersDropdown').prop('value'),
					shape = $('input[name="uncode_radio_image"]:checked').prop('value');

				if ($(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').length == 0) {
					switch (shapePosition) {
						case "top":
							$(styleeditor.activeElement.element)
								.prepend(
									`<div class="shape-divider" data-position="${shapePosition}">
										<svg class="shapeDivider" x="${bConfig.shapeDividers[shape].x}" y="${bConfig.shapeDividers[shape].y}" width="${bConfig.shapeDividers[shape].width}" height="${bConfig.shapeDividers[shape].height}" viewBox="${bConfig.shapeDividers[shape].viewBox}" enable-background="${bConfig.shapeDividers[shape]['enable-background']}" xml:space="${bConfig.shapeDividers[shape]['xml:space']}" preserveAspectRatio="${bConfig.shapeDividers[shape].preserveAspectRatio}"></svg>
									</div>`
								);
							break;
						case "bottom":
							$(styleeditor.activeElement.element)
								.append(
									`<div class="shape-divider" data-position="${shapePosition}">
										<svg class="shapeDivider" x="${bConfig.shapeDividers[shape].x}" y="${bConfig.shapeDividers[shape].y}" width="${bConfig.shapeDividers[shape].width}" height="${bConfig.shapeDividers[shape].height}" viewBox="${bConfig.shapeDividers[shape].viewBox}" enable-background="${bConfig.shapeDividers[shape]['enable-background']}" xml:space="${bConfig.shapeDividers[shape]['xml:space']}" preserveAspectRatio="${bConfig.shapeDividers[shape].preserveAspectRatio}"></svg>
									</div>`
								);
							break;
					}
				}
				$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').attr('data-shape-figure', shape);
				$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').attr('data-shape-unit', ($(styleeditor.shapeHeight).prop('checked') ? '%' : 'px'));
				if ($(styleeditor.shapeHeight).prop('checked')) {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').css('height', $(styleeditor.shapeProcent).prop('value') + '%').attr('data-shape-height', $(styleeditor.shapeProcent).prop('value'));
				} else {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').css('height', $(styleeditor.shapePx).prop('value') + 'px').attr('data-shape-height', $(styleeditor.shapePx).prop('value'));
				}

				$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]')
					.css({ 'z-index': $(styleeditor.shapeZIndex).prop('value'), 'opacity': $(styleeditor.shapeOpacity).prop('value') / 100 })
					.attr('data-shape-z-index', $(styleeditor.shapeZIndex).prop('value'))
					.attr('data-shape-opacity', $(styleeditor.shapeOpacity).prop('value') / 100);

				$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').attr('data-shape-color', $(styleeditor.shapeColor).prop('value'));

				/**
				 * Property Shape Flip
				 */
				if ($(styleeditor.shapeFlip).prop('checked')) {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').attr('data-shape-flip', true);
				} else {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').removeAttr('data-shape-flip');
				}

				/**
				 * Property Shape Ratio
				 */
				if ($(styleeditor.shapeRatio).prop('checked')) {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').attr('data-shape-ratio', true);
				} else {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').removeAttr('data-shape-ratio');
				}

				/**
				 * Property Shape Safe
				 */
				if ($(styleeditor.shapeSafe).prop('checked')) {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').attr('data-shape-safe', true);
				} else {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').removeAttr('data-shape-safe');
				}

				/**
				 * Property Shape Hide Tablet
				 */
				if ($(styleeditor.shapeTablet).prop('checked')) {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').addClass('hidden-sm');
				} else {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').removeClass('hidden-sm');
				}

				/**
				* Property Shape Hide Mobile
				*/
				if ($(styleeditor.shapeMobile).prop('checked')) {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').addClass('hidden-xs');
				} else {
					$(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"]').removeClass('hidden-xs');
				}

				/**
				 * Create SVG object
				 */
				let svg = Snap($(styleeditor.activeElement.element).find('.shape-divider[data-position="' + shapePosition + '"] .shapeDivider').get(0));
				svg.clear();
				bConfig.shapeDividers[shape].path.forEach(function (obj) {
					obj.fill = $(styleeditor.shapeColor).spectrum("get");
					svg.path().attr(obj);
				});
				$(styleeditor.btnDeleteShape).removeClass('disabled');
				siteBuilder.site.setPendingChanges(true);
			}
			$('#shapeModal').modal('hide');
		},

		changeTypeFunc: function (el, _type = null) {
			let flgEdit = false;

			if(_type === null) {
				flgEdit = true;
			}

			const type = _type || el.getAttribute('data-type');

			// Value
			const nodeValue = document.querySelector('[name="countdown-value"]');

			// Action Field
			const nodeAction = document.querySelector('[name="countdown-action"]');

			// Action URL
			const nodeUrl = document.querySelector('[name="countdown-redirect"]').parentNode;

			//Style
			const nodeStyle = document.querySelector('[name="countdown-style"]').parentNode;

			// Labels
			const nodeLabels = document.querySelector('[name="countdown-labels"]').parentNode;

			// Direction
			const nodeDirection = document.querySelector('[name="countdown-direction"]').parentNode;

			// Delay
			const nodeDelay = document.querySelector('[name="countdown-delay"]').parentNode;

			if(['redirect', 'url'].indexOf(nodeAction.value) !== -1) {
				nodeUrl.classList.remove('hide');
			} else {
				nodeUrl.classList.add('hide');
			}

			switch(type) {
				case 'counter':
					nodeValue.parentNode.classList.remove('hide');
					nodeDelay.classList.remove('hide');
					nodeDirection.classList.remove('hide');
					nodeLabels.classList.add('hide');
					nodeStyle.classList.add('hide');
					nodeAction.parentNode.classList.add('hide');
					nodeUrl.classList.add('hide');

					nodeValue.removeAttribute('placeholder');

					if(nodeValue._flatpickr) {
						flatpickr(nodeValue).destroy();
					}

					if(this._maskIstance) {
						this._maskIstance.destroy();
					}
	
					if(!flgEdit) {
						nodeValue.value = '100';
					}
				break;
				
				case 'bilboard':
					nodeDirection.classList.add('hide');
					nodeValue.parentNode.classList.remove('hide');
					nodeLabels.classList.add('hide');
					nodeStyle.classList.add('hide');
					nodeAction.parentNode.classList.add('hide');
					nodeUrl.classList.add('hide');
					nodeDelay.classList.remove('hide');

					nodeValue.removeAttribute('placeholder');

					if(nodeValue._flatpickr) {
						flatpickr(nodeValue).destroy();
					}

					if(this._maskIstance) {
						this._maskIstance.destroy();
					}
				
					if(!flgEdit) {
						nodeValue.value = 'Tick   ,Counter,Is     ,Flippin,Awesome';
					}
				break;

				case 'timer':
					nodeValue.parentNode.classList.remove('hide');
					nodeDirection.classList.add('hide');
					nodeAction.parentNode.classList.remove('hide');
					// nodeUrl.classList.remove('hide');
					nodeLabels.classList.remove('hide');
					nodeStyle.classList.remove('hide');
					nodeDelay.classList.add('hide');
		
					nodeValue.removeAttribute('placeholder');

					if(!flgEdit) {
						nodeValue.value = moment().format("YYYY-MM-DD HH:mm:ss");
					}

					if(this._maskIstance) {
						this._maskIstance.destroy();
					}
					
					flatpickr(nodeValue, {
						enableTime: true,
    					dateFormat: "Y-m-d H:i",
					});
				break;

				case 'timercountdown':
					nodeDirection.classList.add('hide');
					nodeValue.parentNode.classList.remove('hide');
					nodeAction.parentNode.classList.remove('hide');
					// nodeUrl.classList.remove('hide');
					nodeLabels.classList.remove('hide');
					nodeStyle.classList.remove('hide');
					nodeDelay.classList.add('hide');

					if(!flgEdit) {
						nodeValue.value = '24:00:00';
					}

					if(nodeValue._flatpickr) {
						flatpickr(nodeValue).destroy();
					}

					if(this._maskIstance) {
						this._maskIstance.destroy();
					}

					nodeValue.setAttribute('placeholder', '00:00:00');

					this._maskIstance = vanillaTextMask.maskInput({
						inputElement: nodeValue,
						mask: [/\d/, /\d/, ':', /\d/, /\d/, ':', /\d/, /\d/]  
					});
				break;

				case 'clock':
					nodeDirection.classList.add('hide');
					nodeValue.parentNode.classList.add('hide');
					nodeAction.parentNode.classList.add('hide');
					nodeUrl.classList.add('hide');
					nodeLabels.classList.add('hide');
					nodeStyle.classList.add('hide');
					nodeDelay.classList.add('hide');

					nodeValue.removeAttribute('placeholder');

					if(nodeValue._flatpickr) {
						flatpickr(nodeValue).destroy();
					}

					if(this._maskIstance) {
						this._maskIstance.destroy();
					}
				break;
			}
		},

		webinarChatSave: function () {
			webinar.saveJSON();
			siteBuilder.site.setPendingChanges(true);
			$('#chatModal').modal('hide');
		}
	};

	styleeditor.init();

	exports.styleeditor = styleeditor;

}());