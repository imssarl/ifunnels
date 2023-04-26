(function () {
	"use strict";

	var siteBuilder = require('./builder.js');
	var publisher = require('../../vendor/publisher');
	const { variant } = require('./variants');

	/*
		  constructor function for Element
	  */
	module.exports.Element = function (el) {
		if (el == undefined) {
			return false;
		}
		this.element = el;
		this.sandbox = false;
		this.parentFrame = {};
		this.parentBlock = {};//reference to the parent block element
		this.editableAttributes = [];
		this.toolbar = {};
		this.ABtoolbar = {};
		this.quiztoolbar = {};

		//make current element active/open (being worked on)
		this.setOpen = function () {

			$(this.element).off('mouseenter mouseleave');
			this.element.classList.add('sb_open');
			this.element.classList.remove('sb_hover');

		};

		//sets up hover and click events, making the element active on the canvas
		this.activate = function () {

			var element = this,
				DELAY = 700, clicks = 0, timer = null;

			//data attributes for color
			if (this.element.tagName === 'A') $(this.element).data('color', getComputedStyle(this.element).color);

			$(this.element).css({ 'outline': '', 'cursor': '' });

			$(this.element).off('click').hoverIntent({
				over: function (e) {

					e.stopPropagation();

					if (!this.element.hasAttribute('data-nointent') && !this.element.hasAttribute('data-sbpro-editor') && !this.element.classList.contains('sb_hover')) {

						$(this.element).parents('.sb_hover').removeClass('sb_hover');

						this.element.classList.add('sb_hover');

						this.buildToolBar();

						this.buildQuizToolBar();

						this.buildABToolbar();

					}

				}.bind(this),
				out: function (e) {

					e.stopPropagation();

					setTimeout(function () {

						if (Object.keys(this.toolbar).length === 0 || !this.toolbar.hasAttribute('data-hover')) {
							this.element.classList.remove('sb_hover');
							this.destroyToolBar();
						}

					}.bind(this), 100);

				}.bind(this),
				timeout: 0
			}).on('mouseenter', function () {

				this.setAttribute('data-hover', true);

				if ($(this).parents('*[data-selector]')[0]) $(this).parents('*[data-selector]')[0].setAttribute('data-nointent', true);

			}).on('mouseleave', function () {

				this.removeAttribute('data-hover');

				if ($(this).parents('*[data-selector]')[0]) $(this).parents('*[data-selector]')[0].removeAttribute('data-nointent');

			}).on('click', function (e) {

				e.preventDefault();
				e.stopPropagation();

			}).on('dragstart', function () {

				//remove all existing toolbars
				$(this.element).closest('body').find('.canvasElToolbar').remove();

			}.bind(this));

		};

		this.deactivate = function () {

			$(this.element).off('mouseenter mouseleave click');
			//$(this.element).css({'outline': '', 'cursor': ''});
			this.element.classList.remove('sb_open');
			this.element.classList.remove('sb_hover');

		};

		//removes the elements outline
		this.removeOutline = function () {

			//$(this.element).css({'outline': '', 'cursor': ''});

			this.element.classList.remove('sb_open');
			this.element.classList.remove('sb_hover');

		};

		this.unsetNoIntent = function () {

			this.element.removeAttribute('data-nointent');

		};

		//sets the parent iframe
		this.setParentFrame = function () {

			var doc;
			if (this.element != undefined) {
				doc = this.element.ownerDocument;
			} else {
				return false;
			}
			var w = doc.defaultView || doc.parentWindow;
			var frames = w.parent.document.getElementsByTagName('iframe');

			for (var i = frames.length; i-- > 0;) {

				var frame = frames[i];

				try {
					var d = frame.contentDocument || frame.contentWindow.document;
					if (d === doc)
						this.parentFrame = frame;
				} catch (e) { }
			}

		};

		//sets this element's parent block reference
		this.setParentBlock = function () {

			//loop through all the blocks on the canvas
			for (var i = 0; i < siteBuilder.site.sitePages.length; i++) {
				// For blocks
				for (var x = 0; x < siteBuilder.site.sitePages[i].blocks.length; x++) {

					//if the block's frame matches this element's parent frame
					if (siteBuilder.site.sitePages[i].blocks[x].frame === this.parentFrame) {
						//create a reference to that block and store it in this.parentBlock
						this.parentBlock = siteBuilder.site.sitePages[i].blocks[x];
					}

				}

				// For popups
				for (var y = 0; y < siteBuilder.site.sitePages[i].popups.length; y++) {
					//if the popup's frame matches this element's parent frame
					if (siteBuilder.site.sitePages[i].popups[y].frame === this.parentFrame) {
						//create a reference to that block and store it in this.parentBlock
						this.parentBlock = siteBuilder.site.sitePages[i].popups[y];
					}

				}
			}
		};

		//build the toolbar
		this.buildToolBar = function () {

			if (Object.keys(this.toolbar).length !== 0) return false;

			var toolbar = document.createElement('div'),
				buttonEdit = document.createElement('button'),
				buttonContent,
				elOffset = $(this.element).offset(),
				spaceBelowElement;

			//remove all existing toolbars
			$(this.element).closest('body').find('.canvasElToolbar').remove();

			//the edit button
			buttonEdit.classList.add('edit');
			toolbar.appendChild(buttonEdit);
			if (this.element.getAttribute('data-component') === 'embed') {
				buttonEdit.innerHTML = '<i class="fa fa-code edit-source-btn"></i>';
				const buttonDelete = document.createElement('button');
				buttonDelete.innerHTML = '<i class="fa fa-trash edit-source-btn"></i>';
				toolbar.appendChild(buttonDelete);
				buttonDelete.addEventListener('click', function () {
					publisher.publish('deSelectAllCanvasElements');
					this.clickHandler(this, true);
					this.destroyToolBar();
				}.bind(this));
			} else
				buttonEdit.innerHTML = '<img src="/skin/pagebuilder/img/icons/design-24px-glyph_pen-01@2x.png">';

			buttonEdit.addEventListener('click', function () {
				publisher.publish('deSelectAllCanvasElements');
				this.clickHandler(this);
				this.destroyToolBar();
			}.bind(this));

			//the content button
			if (this.element.parentNode.hasAttribute('data-content')) {
				buttonContent = document.createElement('button');
				buttonContent.classList.add('content');
				buttonContent.innerHTML = '<img src="/skin/pagebuilder/img/icons/design-24px-glyph_text@2x.png">';
				buttonContent.addEventListener('click', function (e) {

					publisher.publish('onContentClick', this);

				}.bind(this));
				toolbar.appendChild(buttonContent);
			}

			// Optimization Test
			const { optimization_test } = siteBuilder.site.activePage.pageSettings; 
			
			if( optimization_test.enable === 'true' ) {
				buttonContent = document.createElement('button');
				buttonContent.classList.add('content');
				buttonContent.innerHTML = '<img src="/skin/pagebuilder/img/icons/plus.svg">';
				buttonContent.title = 'Add new variant';

				/** Add Event Listener */
				buttonContent.addEventListener('click', variant.showCreateModal.bind(this, false));
				toolbar.appendChild(buttonContent);

				// Show/Hide Button
				buttonContent = document.createElement('button');
				buttonContent.classList.add('content');
				buttonContent.innerHTML = '<img src="/skin/pagebuilder/img/icons/eye.svg">';
				buttonContent.title = 'Show/Hide on variants';

				buttonContent.addEventListener('click', variant.toggleVisible.bind(this));
				toolbar.appendChild(buttonContent);

				const variants = variant.parseVariants(this.element);
				if (!variants.length) {
					variants.push({ active: true, name: "#" });
				}

				variants.map(({active, name}) => {
					buttonContent = document.createElement('button');
					buttonContent.classList.add('content');	

					if( active ) {
						buttonContent.classList.add('current');							
					}

					buttonContent.setAttribute('data-variant', name);
					buttonContent.textContent = name;
					toolbar.appendChild(buttonContent);

					/** Add Event Listener */
					buttonContent.addEventListener('click', variant.showCreateModal.bind(this, true));
				});
			}
			

			this.toolbar = toolbar;

			//toolbar hover events
			$(toolbar).on('mouseenter', function () {
				this.toolbar.setAttribute('data-hover', "true");
				$(this.element).parents('*[data-selector]').attr('data-nointent', true);
			}.bind(this)).on('mouseleave', function () {

				this.toolbar.removeAttribute('data-hover');

				setTimeout(function () {
					if (!this.element.hasAttribute('data-hover')) {
						this.element.classList.remove('sb_hover');
						this.destroyToolBar();
					}
				}.bind(this), 100);

			}.bind(this));

			toolbar.classList.add('canvasElToolbar');

			//determine positioning

			spaceBelowElement = this.parentFrame.offsetHeight - this.element.offsetHeight - elOffset.top;

			if (elOffset.top === 0 && $(this.element)[0].offsetHeight === this.element.offsetHeight) {
				//full height, show inside top left corner
				toolbar.style.top = "0px";
				toolbar.classList.add('inside');
			} else if (elOffset.top < 40 && spaceBelowElement < 50) {
				//full height, show inside top left corner
				toolbar.style.top = elOffset.top + "px";
				toolbar.classList.add('inside');
			} else if (elOffset.top < 40) {
				//close to the top
				toolbar.style.top = (elOffset.top + this.element.offsetHeight) + "px";
				toolbar.classList.add('bottom');
			} else {
				//not close to top, display above to the left
				toolbar.style.top = (elOffset.top - 30) + "px";
				toolbar.classList.add('top');
			}

			//carousel?
			if ($(this.element).closest('div[data-component="carousel"]').size() > 0) {
				toolbar.style.left = ((this.element.offsetWidth / 2) + elOffset.left) + "px";
			} else {
				toolbar.style.left = elOffset.left + "px";
			}

			$(this.element).closest('body').append(toolbar);

		};

		//build quiz the toolbar
		this.buildQuizToolBar = function () {
			if (Object.keys(this.quiztoolbar).length !== 0) return false;

			//remove all existing toolbars
			$(this.element).closest('body').find('.canvasQuizToolbar').remove();

			var quiztoolbar = document.createElement('div'),
				buttonContent,
				elOffset = $(this.element).offset(),
				spaceBelowElement;



			//the quiz page data-component="quest-box"

			if (this.element.getAttribute('data-component') == "quest-box") {

				var questEltP = $(this.element).prev('[data-component="quest-box"]');
				if (questEltP.length != 0) {

					buttonContent = document.createElement('button');
					buttonContent.classList.add('prev-quiz');
					buttonContent.innerHTML = 'Prev';
					$(buttonContent).css('width', '50px');

					buttonContent.addEventListener('click', function (e) {


						if (this.element != undefined) {
							$(this.element).hide();

							if (Object.keys(this.quiztoolbar).length !== 0) {
								this.quiztoolbar.remove();
								this.quiztoolbar = {};
							}

							var canvasElement = require('./canvasElement.js').Element;
							var newQElement = new canvasElement(questEltP[0]);
							$(newQElement.element).css('display', 'inline-block');
							newQElement.activate();
							if (!newQElement.element.hasAttribute('data-nointent') && !newQElement.element.hasAttribute('data-sbpro-editor') && !newQElement.element.classList.contains('sb_hover')) {
								$(newQElement.element).parents('.sb_hover').removeClass('sb_hover');
								newQElement.element.classList.add('sb_hover');
								newQElement.buildToolBar();
								newQElement.buildQuizToolBar();
							}
							newQElement.element.setAttribute('data-hover', true);
							if ($(newQElement.element).parents('*[data-selector]')[0]) $(newQElement.element).parents('*[data-selector]')[0].setAttribute('data-nointent', true);

						}
					}.bind(this));
					quiztoolbar.appendChild(buttonContent);
				}

				var questEltN = $(this.element).next('[data-component="quest-box"]');

				if (questEltN.length != 0) {
					buttonContent = document.createElement('button');
					buttonContent.classList.add('next-quiz');
					buttonContent.innerHTML = 'Next';
					$(buttonContent).css('width', '50px');
					buttonContent.addEventListener('click', function (e) {


						if (this.element != undefined) {
							$(this.element).hide();

							if (Object.keys(this.quiztoolbar).length !== 0) {
								this.quiztoolbar.remove();
								this.quiztoolbar = {};
							}

							var canvasElement = require('./canvasElement.js').Element;
							var newQElement = new canvasElement(questEltN[0]);
							$(newQElement.element).css('display', 'inline-block');
							newQElement.activate();
							if (!newQElement.element.hasAttribute('data-nointent') && !newQElement.element.hasAttribute('data-sbpro-editor') && !newQElement.element.classList.contains('sb_hover')) {
								$(newQElement.element).parents('.sb_hover').removeClass('sb_hover');
								newQElement.element.classList.add('sb_hover');
								newQElement.buildQuizToolBar();
								newQElement.buildToolBar();
							}
							newQElement.element.setAttribute('data-hover', true);
							if ($(newQElement.element).parents('*[data-selector]')[0]) $(newQElement.element).parents('*[data-selector]')[0].setAttribute('data-nointent', true);

						}
					}.bind(this));

					quiztoolbar.appendChild(buttonContent);
				}

				buttonContent = document.createElement('button');
				buttonContent.classList.add('add-quiz');
				buttonContent.innerHTML = 'Add';
				$(buttonContent).css('width', '50px');
				buttonContent.addEventListener('click', function (e) {
					if (this.element != undefined) {
						var cloneQuiz = $(this.element).clone();
						cloneQuiz.find('[data-component="heading"]').find('h3').html('Clone ' + cloneQuiz.find('[data-component="heading"]').find('h3').html());
						$(this.element).after(cloneQuiz);
						var questEltA = $(this.element).next('[data-component="quest-box"]');
						$(this.element).hide();

						if (Object.keys(this.quiztoolbar).length !== 0) {
							this.quiztoolbar.remove();
							this.quiztoolbar = {};
						}

						var canvasElement = require('./canvasElement.js').Element;


						var styleeditor2 = require('./styleeditor.js').styleeditor;
						styleeditor2.setupCanvasElements($(questEltA[0]).parent());
						$(questEltA[0]).attr('data-id', styleeditor2.makedataid());


						var newQElement = new canvasElement(questEltA[0]);
						$(newQElement.element).css('display', 'inline-block');

						newQElement.setParentBlock();
						newQElement.activate();
						newQElement.unsetNoIntent();

						let bConfig = require('../config.js');
						for (var key in bConfig.editableItems) {
							$(newQElement.element).find(key).each(function () {
								$(this).attr('data-id', styleeditor2.makedataid());
								styleeditor2.setupCanvasElementsOnElement(this, key);
							});
						}

						if (!newQElement.element.hasAttribute('data-nointent') && !newQElement.element.hasAttribute('data-sbpro-editor') && !newQElement.element.classList.contains('sb_hover')) {
							$(newQElement.element).parents('.sb_hover').removeClass('sb_hover');
							newQElement.element.classList.add('sb_hover');
							newQElement.buildQuizToolBar();
							newQElement.buildToolBar();
						}
						newQElement.element.setAttribute('data-hover', true);
						if ($(newQElement.element).parents('*[data-selector]')[0]) $(newQElement.element).parents('*[data-selector]')[0].setAttribute('data-nointent', true);

						//	var styleeditor=require('./styleeditor.js');
						//	styleeditor.setupCanvasElements( element.parentBlock );
						siteBuilder.site.setPendingChanges(true);
					}
				}.bind(this));

				quiztoolbar.appendChild(buttonContent);


				buttonContent = document.createElement('button');
				buttonContent.classList.add('delete-quiz');
				buttonContent.innerHTML = 'Delete';
				$(buttonContent).css('width', '60px');
				buttonContent.addEventListener('click', function (e) {
					if (this.element != undefined) {
						var openOtherElt = false;
						var questEltD = $(this.element).next('[data-component="quest-box"]');
						if (questEltD.length == 0) {
							questEltD = $(this.element).prev('[data-component="quest-box"]');
							if (questEltD.length != 0) {
								openOtherElt = true;
							}
						} else {
							openOtherElt = true;
						}

						if (Object.keys(this.quiztoolbar).length !== 0) {
							this.quiztoolbar.remove();
							this.quiztoolbar = {};
						}

						$(this.element).remove();
						if (openOtherElt) {
							var canvasElement = require('./canvasElement.js').Element;
							var newQElement = new canvasElement(questEltD[0]);
							$(newQElement.element).css('display', 'inline-block');
							newQElement.activate();
							if (!newQElement.element.hasAttribute('data-nointent') && !newQElement.element.hasAttribute('data-sbpro-editor') && !newQElement.element.classList.contains('sb_hover')) {
								$(newQElement.element).parents('.sb_hover').removeClass('sb_hover');
								newQElement.element.classList.add('sb_hover');
								newQElement.buildQuizToolBar();
								newQElement.buildToolBar();
							}
							newQElement.element.setAttribute('data-hover', true);
							if ($(newQElement.element).parents('*[data-selector]')[0]) $(newQElement.element).parents('*[data-selector]')[0].setAttribute('data-nointent', true);
						}

					}
				}.bind(this));
				quiztoolbar.appendChild(buttonContent);


				buttonContent = document.createElement('span');
				buttonContent.classList.add('total-quiz');
				buttonContent.innerHTML = 'Total: ' + $(this.element).parents().find('[data-component="quest-box"]').length;
				$(buttonContent).css('width', '90px');

				quiztoolbar.appendChild(buttonContent);


			}


			this.quiztoolbar = quiztoolbar;

			//toolbar hover events
			$(quiztoolbar).on('mouseenter', function () {
				this.quiztoolbar.setAttribute('data-hover', "true");
				$(this.element).parents('*[data-selector]').attr('data-nointent', true);
			}.bind(this)).on('mouseleave', function () {
				this.quiztoolbar.removeAttribute('data-hover');
				setTimeout(function () {
					if (!this.element.hasAttribute('data-hover')) {
						this.element.classList.remove('sb_hover');
						this.destroyToolBar();
					}
				}.bind(this), 100);

			}.bind(this));
			quiztoolbar.classList.add('canvasQuizToolbar');

			//determine positioning


			//close to the top
			//   quiztoolbar.style.top = (elOffset.top + this.element.offsetHeight) + "px";
			//   quiztoolbar.classList.add('bottom');

			quiztoolbar.style.top = (elOffset.top - 30) + "px";
			//   quiztoolbar.style.right = "0px";
			quiztoolbar.classList.add('top');

			//carousel?

			quiztoolbar.style.left = (elOffset.left + 35) + "px";


			$(this.element).closest('body').append(quiztoolbar);

		};


		//destroy the toolbar
		this.destroyToolBar = function () {

			if (Object.keys(this.toolbar).length !== 0) {

				this.toolbar.remove();
				this.toolbar = {};

			}

			if (Object.keys(this.ABtoolbar).length !== 0) {

				this.ABtoolbar.remove();
				this.ABtoolbar = {};

			}

		};

		this.buildABToolbar = function() {
			// if (Object.keys(this.toolbar).length !== 0) return false;

			if (!this.element.getAttribute('data-variant-name') || this.element.getAttribute('data-variant-name') === '#') {
				return false;
			}

			const toolbar = document.createElement('div'),
				buttonRemove = document.createElement('button');

			//remove all existing toolbars
			$(this.element).closest('body').find('.canvasABToolbar').remove();

			//the edit button
			buttonRemove.classList.add('remove');
			buttonRemove.setAttribute("title", "Remove this variant");

			toolbar.appendChild(buttonRemove);
			toolbar.classList.add('canvasABToolbar');
			
			buttonRemove.innerHTML = '<img src="/skin/pagebuilder/img/icons/trash-round@2x.png">';

			buttonRemove.addEventListener('click', function () {
				publisher.publish('deSelectAllCanvasElements');
				
				this.element.remove();

				publisher.publish("removeVariantFromCanvas");
				
				this.destroyToolBar();
			}.bind(this));

			//toolbar hover events
			$(toolbar)
				.on('mouseenter', function () {
					this.toolbar.setAttribute('data-hover', "true");
					$(this.element).parents('*[data-selector]').attr('data-nointent', true);
				}.bind(this))
				.on('mouseleave', function () {

					this.toolbar.removeAttribute('data-hover');

					setTimeout(function () {
						if (!this.element.hasAttribute('data-hover')) {
							this.element.classList.remove('sb_hover');
							this.destroyToolBar();
						}
					}.bind(this), 100);

				}.bind(this));

			this.ABtoolbar = toolbar;

			//determine positioning

			const { top, left, height, width } = this.element.getBoundingClientRect();
			toolbar.style.left = `${left + width - 30}px`; 

			if (top === 0 && $(this.element)[0].offsetHeight === this.element.offsetHeight) {
				//full height, show inside top left corner
				toolbar.style.top = "0px";
				toolbar.classList.add('inside');
			} else if (top < 40) {
				//close to the top
				toolbar.style.top = (top + this.element.offsetHeight) + "px";
				toolbar.classList.add('bottom');
			} else {
				//not close to top, display above to the left
				toolbar.style.top = (top - 30) + "px";
				toolbar.classList.add('top');
			}

			$(this.element).closest('body').append(toolbar);
		};

		this.setParentFrame();

		/*
			is this block sandboxed?
		*/

		if (this.parentFrame.getAttribute('data-sandbox')) {
			this.sandbox = this.parentFrame.getAttribute('data-sandbox');
		}

	};

}());