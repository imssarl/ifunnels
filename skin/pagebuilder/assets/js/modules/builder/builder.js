const { reject } = require('lodash');

(function () {
	"use strict";

	let siteBuilderUtils = require('../shared/utils.js');
	let bConfig = require('../config.js');
	let appUI = require('../shared/ui.js').appUI;
	let publisher = require('../../vendor/publisher');
	let ace = require('brace');
	let utils = require('../shared/utils.js');
	let notify = require('../shared/notify');
	const userActions = require('../users/user-actions');
	const { variant } = require('./variants');

	let userActive = false;

	userActions.addUserActionsToRoot();

	let activateAllPages = false;


	 /*
		Basic Builder UI initialisation
	*/
	var builderUI = {

		allBlocks: {},                                   //holds all blocks loaded from the server
		primarySideMenuWrapper: document.getElementById('main'),
		buttonBack: document.getElementById('backButton'),
		buttonBackConfirm: document.getElementById('leavePageButton'),

		aceEditors: {},
		frameContents: '',                               //holds frame contents
		templateID: 0,                                   //holds the template ID for a page (???)

		modalDeleteBlock: document.getElementById('deleteBlock'),
		modalResetBlock: document.getElementById('resetBlock'),
		modalDeletePage: document.getElementById('deletePage'),
		buttonDeletePageConfirm: document.getElementById('deletePageConfirm'),

		dropdownPageLinks: document.getElementById('internalLinksDropdown'),

		pageInUrl: null,

		tempFrame: {},

		currentResponsiveMode: {},

		sideSecondBlocksNav: document.querySelector('*[data-sidesecond="blocks"] nav'),
		sideSecondComponentsNav: document.querySelector('*[data-sidesecond="components"] nav'),
		
		sideSecondPopupNav: document.querySelector('*[data-sidesecond="popups"] nav'),

		init: function(){
			if ( document.body.classList.contains('builderUI') ) {
				builderUI.loadBlocksComponents();
			}

			//prevent click event on ancors in the block section of the sidebar
			$(this.primarySideMenuWrapper).on('click', 'a:not(.actionButtons)', function(e){e.preventDefault();});

			$(this.buttonBack).on('click', this.backButton);
			$(this.buttonBackConfirm).on('click', this.backButtonConfirm);

			$(builderUI.sideSecondBlocksNav).on('click', 'li a.delFavBlock', function () {

				builderUI.deleteFavBlock(this.getAttribute('data-block-id'));

				return false;

			});

			//notify the user of pending chnages when clicking the back button
			$(window).bind('beforeunload', function(){
				if( site.pendingChanges === true ) {
					return 'Your site contains changed which haven\'t been saved yet. Are you sure you want to leave?';
				}
			});

			//URL parameters
			builderUI.pageInUrl = siteBuilderUtils.getParameterByName('p');

			publisher.subscribe('onBeforeSave', function () {

				if ( typeof bConfig.onBeforeSave === 'function' ) bConfig.onBeforeSave();

			});

			window.addEventListener("message", receiveMessage, false);

			function receiveMessage(event) {

				if (event.data === "onFrameContentChanged") {

					site.activePage.heightAdjustment();
					site.setPendingChanges(true);

				}

			}

			publisher.subscribe('canvasWidthChanged', function () {
				site.activePage.heightAdjustment();
			});

			publisher.subscribe('onPendingChanges', function () {
				site.setPendingChanges(true);
			});

			publisher.subscribe('onResponsiveViewChange', function (mode) {

				if ( site.activePage.blocks === undefined ) return false;

				site.activePage.blocks.forEach(function (block) {
					if ( mode === 'mobile' ) block.hideFrameCover();
					else block.unhideFrameCover();
				});

			});


			/** Set callback function */
			userActions.callbackAfterUserNotActive = () => site.autoSave();
		},


		/*
			Loads blocks and components off the server and creates both sidebars
		*/
		loadBlocksComponents: function (blocks = true, components = true) {

			//load blocks
			$.getJSON(appUI.dataUrls.loadAll, function(data){
				builderUI.allBlocks = data;
				if ( blocks ) builderUI.implementBlocks();
				if ( components ) builderUI.implementComponents();
				publisher.publish('onSidebarDataReady');
			});

		},


		/*
			builds the blocks into the site bar
		*/
		implementBlocks: function() {
			var category,
				catCounter = 0,
				niceKey,
				catButton,
				catButtonSpan,
				catButtonSVG,
				x,
				blockUL,
				newItem,
				allBlocks = [];

			// Empty out the category navigation
			this.sideSecondBlocksNav.innerHTML = '';

			if (typeof this.allBlocks.elements === 'undefined' ) {
				// No blocks were send from the server, let's remove block related stuff
				$('button[data-side="blocks"]').remove();
				$('div[data-sidesecond="blocks"]').remove();
			}

			for( category in this.allBlocks.elements ) {
				// Skip the "Popups category"
				if (category.toLowerCase() === 'popups') {
					publisher.publish(
					  'createPopupsSidebar',
					  category,
					  this.allBlocks.elements[category]
					);
					continue;
				}

				//create the category button
				niceKey = category.toLowerCase().replace(/ /g, "_");

				catButton = document.createElement('BUTTON');
				catButtonSpan = document.createElement('SPAN');

				catButtonSpan.innerText = category;

				catButton.appendChild(catButtonSpan);

				catButtonSVG = siteBuilderUtils.htmlToElement(bConfig.sideMenuArrowSVG);

				catButton.appendChild(catButtonSVG);

				this.sideSecondBlocksNav.appendChild(catButton);


				//create the block thumbnails

				blockUL = document.createElement('UL');

				if ( catCounter === 0 ) {
					blockUL.setAttribute('data-no-fav-blocks', builderUI.sideSecondBlocksNav.getAttribute('data-no-fav-blocks'));
				}

				for( x = 0; x < this.allBlocks.elements[category].length; x++ ) {

					//console.log(this.allBlocks.elements[category][x]);
					if(this.allBlocks.elements[category][x].blocks_category === undefined){
						newItem = $('<li><a href="" class="delFavBlock" data-block-id="'+this.allBlocks.elements[category][x].id+'"><i class="fui-cross-circle"></i></a><img data-original-src="'+appUI.cnmPath+this.allBlocks.elements[category][x].blocks_thumb+'" data-srcc="'+appUI.baseUrl+this.allBlocks.elements[category][x].blocks_url+'" data-height="'+this.allBlocks.elements[category][x].blocks_height+'"></li>');
					}
					/*if ( catCounter === 0 ) {
						newItem = $('<li><a href="" class="delFavBlock" data-block-id="'+this.allBlocks.elements[category][x].id+'"><i class="fui-cross-circle"></i></a><img data-original-src="'+appUI.cnmPath+this.allBlocks.elements[category][x].blocks_thumb+'" data-srcc="'+appUI.baseUrl+this.allBlocks.elements[category][x].blocks_url+'" data-height="'+this.allBlocks.elements[category][x].blocks_height+'"></li>');
					}*/ else {
						newItem = $('<li><img data-original-src="'+appUI.cnmPath+this.allBlocks.elements[category][x].blocks_thumb+'" data-srcc="'+appUI.cnmPath+this.allBlocks.elements[category][x].blocks_url+'" data-height="'+this.allBlocks.elements[category][x].blocks_height+'"></li>');
					}

					blockUL.appendChild(newItem[0]);

				}

				this.sideSecondBlocksNav.appendChild(blockUL);

				catCounter++;

			}

			//draggables
			builderUI.makeDraggable();

		},

		/*
			Builds the components into the sidebar
		*/
		implementComponents: function () {

			var newItem,
				category,
				niceKey,
				catButton,
				catButtonSpan,
				catButtonSVG,
				x,
				componentsUL;

			//for( category in this.allBlocks.components ) {

				var key = ( typeof this.allBlocks.elements === 'undefined' )? Object.keys(this.allBlocks)[0]: Object.keys(this.allBlocks)[1];

			for( category in this.allBlocks[ key ] ) {

				//create the category button
				niceKey = category.toLowerCase().replace(" ", "_");

				catButton = document.createElement('BUTTON');
				catButtonSpan = document.createElement('SPAN');

				catButtonSpan.innerText = category;

				catButton.appendChild(catButtonSpan);

				catButtonSVG = siteBuilderUtils.htmlToElement(bConfig.sideMenuArrowSVG);

				catButton.appendChild(catButtonSVG);

				this.sideSecondComponentsNav.appendChild(catButton);

				//create the block thumbnails

				componentsUL = document.createElement('UL');

				for( x = 0; x < this.allBlocks[ key ][category].length; x++ ) {

					newItem = $('<li class="component '+niceKey+'"><img data-original-src="'+appUI.cnmPath+this.allBlocks[ key ][category][x].components_thumb+'" data-height="'+this.allBlocks[ key ][category][x].components_height+'"></li>');

					newItem.find('img').attr('data-insert-html', this.allBlocks[ key ][category][x].components_markup);

					componentsUL.appendChild(newItem[0]);

				}

				this.sideSecondComponentsNav.appendChild(componentsUL);

			}

		},


		/*
			event handler for when the back link is clicked
		*/
		backButton: function() {

			if( site.pendingChanges === true ) {
				$('#backModal').modal('show');
				return false;
			}

		},


		/*
			button for confirming leaving the page
		*/
		backButtonConfirm: function() {

			site.pendingChanges = false;//prevent the JS alert after confirming user wants to leave

		},


		/*
			makes the blocks and templates in the sidebar draggable onto the canvas
		*/
		makeDraggable: function() {

			$('[data-sidesecond="blocks"] ul li, #templates li').each(function(){

				$(this).draggable({
					helper: function() {
						return $('<div style="height: 100px; width: 300px; background: #F9FAFA; box-shadow: 5px 5px 1px rgba(0,0,0,0.1); text-align: center; line-height: 100px; font-size: 28px; color: #16A085"><span class="fui-list"></span></div>');
					},
					revert: 'invalid',
					appendTo: 'body',
					connectToSortable: '#pageList > ul:visible',
					start: function (event, ui) {
						site.activePage.transparentOverlay('on');
						$(this).data("startingScrollTop",window.pageYOffset);
					},
					stop: function (event, ui) {
						site.activePage.transparentOverlay('off');
					},
					drag: function (event, ui) {

						if ( ui.originalPosition.top - ui.offset.top > 100 ) {

							var st = parseInt($(this).data("startingScrollTop"));
							ui.position.top -= st;

						}
						
					}
				});

			});

			$('#elements li a').each(function(){

				$(this).unbind('click').bind('click', function(e){
					e.preventDefault();
				});

			});

		},


		/*
			Implements the site on the canvas, called from the Site object when the siteData has completed loading
		*/
		populateCanvas: function() {

			var i, counter2 = 1;

			//loop through the pages

			for( i in site.pages ) {

				counter2++;
				
				var newPage = new Page(i, site.pages[i], counter2);

				//set this page as active?
				if( builderUI.pageInUrl === i ) {

					newPage.selectPage();
				}

			}

			//activate the first page
			if(site.sitePages.length > 0 && builderUI.pageInUrl === null) {

				site.sitePages[0].selectPage();
			}

		},


		/*
			Canvas loading on/off
		*/
		canvasLoading: function (value) {

			if ( value === 'on' && document.getElementById('frameWrapper').querySelectorAll('#canvasOverlay').length === 0 ) {

				var overlay = document.createElement('DIV');

				overlay.style.display = 'flex';
				$(overlay).hide();
				overlay.id = 'canvasOverlay';

				overlay.innerHTML = '<div class="loader"><span>{</span><span>}</span></div>';

				document.getElementById('frameWrapper').appendChild(overlay);

				$('#canvasOverlay').fadeIn(500);

			} else if ( value === 'off' && document.getElementById('frameWrapper').querySelectorAll('#canvasOverlay').length === 1 ) {

				site.loaded();

				$('#canvasOverlay').fadeOut(500, function () {
					this.remove();
				});

			}

		},


		/*
			Deletes a favourite block
		*/
		deleteFavBlock: function (blockID) {

			$.ajax({
				url: appUI.dataUrls.deleteblock,
				type: 'post',
				data : {
					id : blockID
				},
				dataType: 'json'
			}).done(function (ret) {

				if ( ret.responseCode === 1 ) {

					$('a[data-block-id="' + blockID + '"]', builderUI.sideSecondBlocksNav).parent().fadeOut(function () {
						this.remove();
					});

				}

			});

		}

	};


	/*
		Page constructor
	*/
	function Page (pageName, page, counter) {

		this.name = pageName || "";
		this.pageID = page.page_id || 0;
		this.blocks = [];
		this.popups = [];
		this.parentUL = {}; //parent UL on the canvas
		this.status = '';//'', 'new' or 'changed'
		this.scripts = [];//tracks script URLs used on this page
		this.variants = [ '#' ];
		this.currentVariant = '#';

		this.pageSettings = {
			title: page.pages_title || '',
			meta_description: page.meta_description || '',
			meta_keywords: page.meta_keywords || '',
			header_includes: page.header_includes || '',
			page_css: page.page_css || '',
			google_fonts: page.google_fonts || [],
			header_script : page.header_script || '',
			footer_script : page.footer_script || '',
			protected: page.protected || 0,
			memberships: page.memberships || [],
			primary_membership: page.primary_membership || null,
			variantsSettings: [],
			optimize_page_settings: '',
			drip_feed: {
				enable: 0,
				after_period: 'month',
				value: null
			},
			optimization_test : {
				enable: false,
				name: null,
				goals: {
					lead: {
						enable: false,
						value: null
					},
					registration: {
						enable: false,
						value: null
					},
					sale: {
						enable: false,
						value: null
					}
				}
			}
		};
		
		if (page.drip_feed != null) {
			this.pageSettings.drip_feed = {
				enable: page.drip_feed.enable,
				after_period: page.drip_feed.after_period,
				value: page.drip_feed.value,
			};
		}
		
		if (page.optimization_test) {
			this.pageSettings.optimization_test = page.optimization_test;
		}
		
		this.pageMenuTemplate = `<a href="" class="menuItemLink" style="width:45%;">page</a>
			<span class="pageButtons">
				<button class="btn btn-xs btn-primary fileEdit fui-new"></button>
				<button class="btn btn-xs btn-default fileDuplicate fui-windows"></button>
				<button class="btn btn-xs btn-danger fileDel fui-cross"></button>
				<button class="btn btn-xs btn-primary fileSave fui-check" href="#"></button>
			</span>`;

		this.menuItem = {};//reference to the pages menu item for this page instance
		this.linksDropdownItem = {};//reference to the links dropdown item for this page instance

		this.parentUL = document.createElement('UL');
		this.parentUL.setAttribute('id', "page"+counter);

		/*
			makes the clicked page active
		*/
		this.selectPage = function() {
			// build blocks
			if ( this.parentUL.children.length === 0 && page.hasOwnProperty('blocks') ) {
				for (var x = 0; x < page.blocks.length; x++) {
					//create new Block
					var newBlock = new Block('block');

					page.blocks[x].src = appUI.dataUrls.getframe + '?id=' + page.blocks[x].id;

					newBlock.frameID = page.blocks[x].id;
					newBlock.page = this;
					
					if (page.blocks[x].frames_global === '1') 
						newBlock.global = true;
					
					newBlock.createParentLI(page.blocks[x].frames_height);
					newBlock.createFrame(page.blocks[x]);
					newBlock.createFrameCover();

					//add the block to the new page
					if( pageName == siteBuilderUtils.getParameterByName('p') || ( pageName == 'index' && siteBuilderUtils.getParameterByName('p') == null ) ){
						newBlock.insertBlockIntoDom(this.parentUL);
					}else{
						newBlock.insertBlockIntoTemp(this.parentUL);
					}
					
					$(newBlock.frameContent).find('[data-options]').each( function( eltId, eltData ){
						var  buttonContent = document.createElement('button');
						buttonContent.classList.add('content');
						if( $(eltData).data('options') == $(this.element).data('options') ){
							buttonContent.style.color='#42E54D';
						}else{
							buttonContent.style.color='#bbb';
						}
						buttonContent.title = 'Show variant '+$(eltData).data('options');
						buttonContent.innerHTML = $(eltData).data('options');
						
						if( !site.pageVariantsArray.includes( buttonContent.innerHTML ) ){
							site.pageVariantsArray.push( buttonContent.innerHTML );
						}
						
						buttonContent.addEventListener('click', function (e) {
							if( this.element != undefined ){
								$(this.element).hide();
							//console.log( $( e.target )[0].innerText, '[data-prntid="'+$(this.element).data('prntid')+'"][data-options="'+$( e.target )[0].innerText+'"]' );
								var showElement=$(this.element).parent().find('[data-prntid="'+$(this.element).data('prntid')+'"][data-options="'+$( e.target )[0].innerText+'"]');
								var canvasElement=require('./canvasElement.js').Element;
								showElement.show();
								var newQElement = new canvasElement(showElement[0]);
								newQElement.setParentBlock();
								newQElement.activate();
								newQElement.unsetNoIntent();
								let bConfig = require('../config.js');
								var styleeditor2=require('./styleeditor.js').styleeditor;
								styleeditor2.setupCanvasElements( $(this.element).parent() );
								for( var key in bConfig.editableItems ) {
									$(newQElement.element).find( key ).each(function () {
										$(this).attr('data-id', styleeditor2.makedataid() );
										styleeditor2.setupCanvasElementsOnElement(this, key);
									});
								}
								if ( !newQElement.element.hasAttribute('data-nointent') && !newQElement.element.hasAttribute('data-sbpro-editor') ) {
									$(newQElement.element).parents('.sb_hover').removeClass('sb_hover');
									newQElement.element.classList.add('sb_hover');
									newQElement.buildQuizToolBar();
									newQElement.buildToolBar();
								}
								newQElement.element.setAttribute('data-hover', true);
								if ( $(newQElement.element).parents('*[data-selector]')[0] ) $(newQElement.element).parents('*[data-selector]')[0].setAttribute('data-nointent', true);
								siteBuilder.site.setPendingChanges(true);
							}
						}.bind(this));
					});
					
					this.blocks.push(newBlock);
				}

				if (page.popups !== undefined) {
					for (var y = 0; y < page.popups.length; y++) {
						//create new Block

						var newPopupBlock = new Block('block');

						newPopupBlock.type = 'popup';
						newPopupBlock.popupType = page.popups[y].frames_popup;

						if (page.popups[y].frames_settings) {
							let additionalSettings = JSON.parse( page.popups[y].frames_settings );

							for (let key in additionalSettings) {
								newPopupBlock[key] = additionalSettings[key];
							}
						}

						page.popups[y].src = appUI.dataUrls.getframe + '?id=' + page.popups[y].id;

						newPopupBlock.frameID = page.popups[y].frames_id;
						newPopupBlock.page = this;
						newPopupBlock.createParentLI(page.popups[y].frames_height);
						newPopupBlock.parentLI.setAttribute('data-page-id', this.pageID);
						newPopupBlock.createFrame(page.popups[y]);
						newPopupBlock.createFrameCover();

						if (newPopupBlock.popupType === 'entry')
						newPopupBlock.insertBlockIntoDom(
							document.querySelector('#entryPopup > ul')
						);
						else if (newPopupBlock.popupType === 'exit')
						newPopupBlock.insertBlockIntoDom(
							document.querySelector('#exitPopup > ul')
						);
						else if (newPopupBlock.popupType === 'regular')
						newPopupBlock.insertBlockIntoDom(
							document.querySelector('#regularPopup > ul')
						);

						this.popups.push(newPopupBlock);
					}
				}
			}

			//mark the menu item as active
			site.deActivateAll();
			$(this.menuItem).addClass('active');

			//let Site know which page is currently active
			site.setActive(this);

			//display the name of the active page on the canvas
			site.pageTitle.innerHTML = this.name;

			//load the page settings into the page settings modal
			site.inputPageSettingsTitle.value = this.pageSettings.title;
			site.inputPageSettingsMetaDescription.value = this.pageSettings.meta_description;
			site.inputPageSettingsMetaKeywords.value = this.pageSettings.meta_keywords;
			site.inputPageSettingsIncludes.value = this.pageSettings.header_includes;
			site.inputPageSettingsPageCss.value = this.pageSettings.page_css;
			site.inputPageSettingsHeaderScript.value = this.pageSettings.header_script;
			site.inputPageSettingsFooterScript.value = this.pageSettings.footer_script;
			
			if( site.inputPageSettingsMemberships ) {
				site.inputPageSettingsMemberships.forEach( input => {
					if( this.pageSettings.memberships.indexOf( input.value ) !== -1 ) {
						input.checked = true;
					}
				} );
			}

			if( this.pageSettings.protected == '1' ) {
				$('#protected_page').bootstrapSwitch( 'state', true );
			}

			//google fonts
			$(site.inputPageSettingsGoogleFonts).tagsinput('removeAll');
			site.activePage.pageSettings.google_fonts.forEach(function (font) {
				$(site.inputPageSettingsGoogleFonts).tagsinput('add', font.nice_name);
			});

			//trigger custom event
			$('body').trigger('changePage');

			publisher.publish('onChangePage', this);

			//reset the heights for the blocks on the current page
			for( var i in this.blocks ) {

				if( Object.keys(this.blocks[i].frameDocument).length > 0 ){
					this.blocks[i].heightAdjustment();
				}

			}

			//show the empty message?
			this.isEmpty();

			return false;

		};

		/*
			changed the location/order of a block within a page
		*/
		this.setPosition = function(frameID, newPos) {

			//we'll need the block object connected to iframe with frameID

			for(var i in this.blocks) {

				if( this.blocks[i].frame.getAttribute('id') === frameID ) {

					//change the position of this block in the blocks array
					this.blocks.splice(newPos, 0, this.blocks.splice(i, 1)[0]);

				}

			}

		};

		/*
			Locates the proper Block object using frameID and publishes the load event
		*/
		this.fireBlockLoadEvent = function (frameID) {

			for(var i in this.blocks) {

				if( this.blocks[i].frame.getAttribute('id') === frameID ) {
					publisher.publish('onBlockLoaded', this.blocks[i]);
				}

			}

		};

		/*
			delete block from blocks array
		*/
		this.deleteBlock = function(block) {

			//remove from blocks array
			for( var i in this.blocks ) {
				if( this.blocks[i] === block ) {
					//found it, remove from blocks array
					this.blocks.splice(i, 1);
				}
			}
			
			for( var i in this.popups ) {
				if( this.popups[i] === block ) {
					//found it, remove from blocks array
					this.popups.splice(i, 1);
				}
			}

			site.setPendingChanges(true);

		};

		/*
			Places a transparent DIV over the frames on the page
		*/
		this.transparentOverlay = function (onOrOff = 'on') {

			for ( var i in this.blocks ) {

				this.blocks[i].transparentOverlay(onOrOff);

			}

		};

		/*
			setup for editing a page name
		*/
		this.flgRunEdit=false;
		this.editPageName = function() {

			if( !this.menuItem.classList.contains('edit') ) {

				//hide the link
				this.menuItem.querySelector('a.menuItemLink').style.display = 'none';

				//insert the input field
				var newInput = document.createElement('input');
				newInput.type = 'text';
				newInput.setAttribute('name', 'page');
				newInput.setAttribute('value', this.name);
				this.menuItem.insertBefore(newInput, this.menuItem.firstChild);

				newInput.focus();

				var tmpStr = newInput.getAttribute('value');
				newInput.setAttribute('value', '');
				newInput.setAttribute('value', tmpStr);

				this.menuItem.classList.add('edit');

			}

		};

		/*
			Updates this page's name (event handler for the save button)
		*/
		this.updatePageNameEvent = function(el) {

			if( this.menuItem.classList.contains('edit') ) {

				//el is the clicked button, we'll need access to the input
				var theInput = this.menuItem.querySelector('input[name="page"]');

				//make sure the page's name is OK
				if( site.checkPageName(theInput.value) ) {

					this.name = site.prepPageName( theInput.value );

					this.menuItem.querySelector('input[name="page"]').remove();
					this.menuItem.querySelector('a.menuItemLink').innerHTML = this.name;
					this.menuItem.querySelector('a.menuItemLink').style.display = 'block';

					// Updated attr href
					this.menuItem.querySelector('a.menuItemLink').setAttribute('href', `${window.location.pathname}?id=${siteBuilderUtils.getParameterByName('id')}&p=${this.name}`)
					this.menuItem.classList.remove('edit');

					//update the links dropdown item
					this.linksDropdownItem.text = this.name;
					this.linksDropdownItem.setAttribute('value', this.name + ".html");

					//update the page name on the canvas
					site.pageTitle.innerHTML = this.name;

					//changed page title, we've got pending changes
					// site.setPendingChanges(true);

					$.ajax({
						url: appUI.dataUrls.ajax,
						type: 'post',
						data : {
							pageid : this.pageID,
							pagename : this.name,
						},
						dataType: 'json'
					}).done(function (ret) {});

					this.flgRunEdit=false;

					site.save(false);

				} else {

					alert(site.pageNameError);

				}

			}

		};

		/*
			deletes this entire page
		*/
		this.delete = function() {

			//delete from the Site
			for( var i in site.sitePages ) {

				if( site.sitePages[i] === this ) {//got a match!

					//delete from site.sitePages
					site.sitePages.splice(i, 1);

					//delete from canvas
					this.parentUL.remove();
					//add to deleted pages
					site.pagesToDelete.push(this.name);

					//delete the page's menu item
					this.menuItem.remove();

					//delet the pages link dropdown item
					this.linksDropdownItem.remove();

					//activate the first page
				//++
//	console.log( site.sitePages[0] );

				//--	site.sitePages[0].selectPage();

					//page was deleted, so we've got pending changes
				//--	site.setPendingChanges(true);

				}

			}

		};

		/*
			checks if the page is empty, if so show the 'empty' message
		*/
		this.isEmpty = function() {

			if( this.blocks.length === 0 ) {

				site.messageStart.style.display = 'block';
				site.divFrameWrapper.classList.add('empty');

			} else {

				site.messageStart.style.display = 'none';
				site.divFrameWrapper.classList.remove('empty');

			}

		};

		/*
			preps/strips this page data for a pending ajax request
		*/
		this.prepForSave = function() {

			this.detectGoogleFonts();

			var page = {};

			page.name = this.name;
			page.pageSettings = this.pageSettings;
			page.status = this.status;
			page.pageID = this.pageID;
			page.blocks = [];
			page.popups = [];

			page.pageSettings['access_options'] = this.variants;

			for (var x = 0; x < this.blocks.length; x++) {
				var block = {};
		
				if (typeof bConfig.inBlockBeforeSave === 'function')
					bConfig.inBlockBeforeSave(this.blocks[x].frameDocument);
		
				//dump possible Google Map links from the heads
				$('head', this.blocks[x].frameDocument)
					.find('script[src*="maps.googleapis.com"]')
					.remove();
				const blockSource = this.blocks[x].getSource();
		
				block.frames_embeds = blockSource.embeds;
				block.frameContent = blockSource.source;
				block.sandbox = false;
				block.loaderFunction = '';
		
				block.frameHeight = this.blocks[x].frameHeight;
				block.originalUrl = this.blocks[x].originalUrl;
				block.position = x;
				if(this.blocks[x].id !== undefined){
					block.id = this.blocks[x].id;
				}
				if (this.blocks[x].global) block.frames_global = true;
		
				page.blocks.push(block);
			}

			 // process popups
			for (var y = 0; y < this.popups.length; y++) {
				let popup = {};
		
				if (typeof bConfig.inBlockBeforeSave === 'function')
				  bConfig.inBlockBeforeSave(this.popups[y].frameDocument);
		
				//dump possible Google Map links from the heads
				$('head', this.popups[y].frameDocument).find('script[src*="maps.googleapis.com"]').remove();
				

				const popupSource = this.popups[y].getSource();
				popup.frameContent = popupSource.source;
				popup.frames_embeds = popupSource.embeds;
				popup.sandbox = false;
				popup.loaderFunction = '';
		
				popup.frameHeight = this.popups[y].frameHeight;
				popup.originalUrl = this.popups[y].originalUrl;
				if (this.popups[y].global) popup.frames_global = true;

				let additionalSettings = {};
		
				if (typeof this.popups[y].popupReoccurrence !== 'undefined')
				  additionalSettings.popupReoccurrence = this.popups[y].popupReoccurrence;
				else additionalSettings.popupReoccurrence = 'All';
		
				if (typeof this.popups[y].popupDelay !== 'undefined')
				  additionalSettings.popupDelay = this.popups[y].popupDelay;
				else additionalSettings.popupDelay = 0;
		
				if (typeof this.popups[y].popupID !== 'undefined')
				  additionalSettings.popupID = this.popups[y].popupID;
				else additionalSettings.popupID = utils.randomString(10);
		
				if (Object.keys(additionalSettings).length !== 0)
				  popup.additionalSettings = additionalSettings;
		
				popup.type = this.popups[y].popupType;
		
				page.popups.push(popup);
			  }

			return page;

		};

		this.unique = function(arr){
			let obj = {};
			for (let i = 0; i < arr.length; i++) {
				let str = arr[i];
				obj[str] = true; 
			}
			return Object.keys(obj);
		}

		/*
			generates the full page, using skeleton.html
		*/
		this.fullPage = function() {

			var page = this;//reference to self for later
			page.scripts = [];//make sure it's empty, we'll store script URLs in there later

			var newDocMainParent = $('iframe#skeleton').contents().find( bConfig.pageContainer );
			var newDocMainParentPopups = $('iframe#skeleton').contents().find('#popups');

			//empty out the skeleton first
			$('iframe#skeleton').contents().find( bConfig.pageContainer ).html('');
			$('iframe#skeleton').contents().find('#popups').html('');

			//remove old script tags
			$('iframe#skeleton').contents().find( 'script' ).each(function(){
				$(this).remove();
			});

			$('iframe#skeleton').contents().find( 'link' ).each(function(){
				$(this).remove();
			});

			var theContents;
			for( var i in this.blocks ) {

				//grab the block content
				if (this.blocks[i].sandbox !== false) {
					theContents = $('#sandboxes #'+this.blocks[i].sandbox).contents().find( bConfig.pageContainer ).clone();
				} else {
					theContents = $(this.blocks[i].frameDocument.body).find( bConfig.pageContainer ).clone();
				}

				//remove video frameCovers
				theContents.find('.frameCover').each(function () {
					$(this).remove();
				});

				//remove style leftovers from the style editor
				for( var key in bConfig.editableItems ) {

					theContents.find( key ).each(function(){

						$(this).removeAttr('data-selector');

						$(this).css('outline', '');
						$(this).css('outline-offset', '');
						$(this).css('cursor', '');

						if( $(this).attr('style') === '' ) {

							$(this).removeAttr('style');

						}

					});

				}

				const videoWrapper = theContents.get(0).querySelector('[data-component="video2"] > .videoWrapper');

				if (videoWrapper) {
					const script = videoWrapper.querySelector('script[type="application/json"]');
					const { src, type } = JSON.parse(script.innerText);
					const container = videoWrapper.querySelector('.video-container');

					videoWrapper.removeChild(script);
					container.innerHTML = `<video width="100%" height="100%" class="video-js"><source src="${src}" type="${type}"></video>`;
				}

				//append to DOM in the skeleton
				newDocMainParent.append( $(theContents.html()) );

				//remove background images in parallax blocks
				newDocMainParent.find('*[data-parallax]').each(function () {
					this.style.backgroundImage = '';
				});

				//remove draggable attributes
				newDocMainParent.find('*[draggable]').each(function () {
					this.removeAttribute('draggable');
				});

				//do we need to inject any scripts?
				//var scripts = $(this.blocks[i].frameDocument.body).find('script');
				var scripts = $(this.blocks[i].frameDocument).find('script:not([type="application/json"]):not([src="/skin/pagebuilder/build/video-ui.bundle.js"])');
				var csses = $(this.blocks[i].frameDocument).find('link');
				const styles = $(this.blocks[i].frameDocument).find('style:not([class^="vjs-styles"]):not([data-variants="true"])');
				var theIframe = document.getElementById("skeleton");

				if(csses.size() > 0){
					csses.each(function(){

						var css;
						css = theIframe.contentWindow.document.createElement("link");
						css.rel = 'stylesheet';
						css.href = $(this).prop('href');

						if( theIframe.contentWindow.document.head.querySelectorAll(`link[href="${$(this).prop('href')}"]`).length === 0 ) {
							theIframe.contentWindow.document.head.appendChild(css);
						}
					});
				}

				if( styles.size() > 0 ) {
					styles.each(function(){

						var style;
						style = theIframe.contentWindow.document.createElement("style");
						style.innerHTML = this.innerHTML;

						theIframe.contentWindow.document.head.appendChild(style);
					});
				}

				if( scripts.size() > 0 ) {

					scripts.each(function(){

						if (['https://www.youtube.com/s/player/82e684c7/www-widgetapi.vflset/www-widgetapi.js', 'https://www.youtube.com/iframe_api'].indexOf(this.src) !== -1) {
							return;
						}

						var script;

						if( $(this).text() !== '' ) {//script tags with content

							script = theIframe.contentWindow.document.createElement("script");
							script.type = 'text/javascript';
							script.innerHTML = $(this).text();

							theIframe.contentWindow.document.body.appendChild(script);

						} else if( $(this).attr('src') !== null && page.scripts.indexOf($(this).attr('src')) === -1 ) {
							//use indexOf to make sure each script only appears on the produced page once

							script = theIframe.contentWindow.document.createElement("script");
							script.type = 'text/javascript';
							script.src = $(this).attr('src');

							theIframe.contentWindow.document.body.appendChild(script);

							page.scripts.push($(this).attr('src'));

						}

					});

				}

			}

			// Parsing TestAB elements
			if (page.pageSettings.optimization_test.enable === 'true') {
				const nodeHead = $('iframe#skeleton').contents().find('head');
				nodeHead.append('<style class="test-ab">[data-variant-current="#"] [data-vhide-default],[data-variant-name]:not([data-variant-name="#"]):not([data-vshow~="#"]){display: none;}</style');
				newDocMainParent.find('[data-variant-name]').removeClass('hidden');

				$('iframe#skeleton').contents().find('body').append('<script src="/skin/ifunnels-studio/dist/js/preview.bundle.js"></script>');
			}

			// Countdown
			if (newDocMainParent.find('[data-component="countdown"]').length) {
				const script = theIframe.contentWindow.document.createElement("script");
				script.type = 'text/javascript';
				script.src = '/skin/pagebuilder/build/flipobj.bundle.js';

				theIframe.contentWindow.document.body.appendChild(script);
			}

			// Video
			if (newDocMainParent.find('[data-component="video2"]').length) {
				const script = theIframe.contentWindow.document.createElement("script");
				script.type = 'text/javascript';
				script.src = '/skin/ifunnels-studio/dist/js/video2.bundle.js';

				theIframe.contentWindow.document.body.appendChild(script);
			}

			// Process popups
			for (var j in this.popups) {
				theContents = $(this.popups[j].frameDocument.body).find('.modal .modal-body > div:first-child').clone();

				//remove video frameCovers
				theContents.find('.frameCover').each(function () {
					$(this).remove();
				});

				theContents[0].querySelectorAll('script').forEach(script => script.remove());

				//remove style leftovers from the style editor
				for (key in bConfig.editableItems) {
					theContents.find(key).each(function () {
						$(this).removeAttr('data-selector');

						$(this).css('outline', '');
						$(this).css('outline-offset', '');
						$(this).css('cursor', '');

						if ($(this).attr('style') === '') {
							$(this).removeAttr('style');
						}
					});
				}

				let theContentsWrapped = utils.htmlToElement(
					builderUI.settings.popup_wrapping_html.replace(/%s/g, '')
				);

				// Attributes
				theContentsWrapped.setAttribute('data-popup', this.popups[j].popupType);

				if (this.popups[j].popupType === 'entry' || this.popups[j].popupType === 'exit') {
					theContentsWrapped.setAttribute('data-popup-occurrence', this.popups[j].popupReoccurrence);
					theContentsWrapped.setAttribute('data-popup-delay', this.popups[j].popupDelay);
				} else {
					theContentsWrapped.setAttribute('id', this.popups[j].popupID);
				}

				theContentsWrapped.querySelector('.modal-body').appendChild(theContents.get(0));

				//append to DOM in the skeleton
				newDocMainParentPopups.get(0).appendChild(theContentsWrapped);

				newDocMainParentPopups.get(0).querySelectorAll('[data-embed-id]').forEach(embed => {
					const embedId = embed.getAttribute('data-embed-id');
					embed.innerHTML = site.embeds[embedId];
				});

				newDocMainParent.get(0).querySelectorAll('[data-embed-id]').forEach(embed => {
					const embedId = embed.getAttribute('data-embed-id');
					embed.innerHTML = site.embeds[embedId];
				});

				//remove draggable attributes
				newDocMainParentPopups.find('*[draggable]').each(function () {
					this.removeAttribute('draggable');
				});
			}
		};


		/*
			Checks if all blocks on this page have finished loading
		*/
		this.loaded = function () {

			var i;

			for ( i = 0; i <this.blocks.length; i++ ) {

				if ( !this.blocks[i].loaded ) return false;

			}

			return true;

		};

		/*
			clear out this page
		*/
		this.clear = function() {

			var block = this.blocks.pop();

			while( block !== undefined ) {

				block.delete();

				block = this.blocks.pop();

			}

		};


		/*
			Height adjustment for all blocks on the page
		*/
		this.heightAdjustment = function () {

			for ( var i = 0; i < this.blocks.length; i++ ) {
				this.blocks[i].heightAdjustment();
			}

		};

		/*
			Turn grid view on/off
		*/
		this.gridView = function (on) {

			var i;

			for ( i in this.blocks ) this.blocks[i].gridView(on);

		};

		/*
			Attempt to detect which Google fonts are used on this page
		*/
		this.detectGoogleFonts = function () {

			/*let usedFonts = [];

			this.blocks.forEach(function (block) {

				let elements = block.frameDocument.querySelectorAll('span[style*="font-family"]');

				if ( elements.length > 0 ) {

					for ( let element of elements ) {
						usedFonts.push(element.style.fontFamily);
					}

				}

			});

			//console.log(usedFonts);

			// Rebuild the google_fonts from scratch
			site.customFonts.forEach(function (font) {

				usedFonts.forEach(function (f) {

					if ( f == font.css_name ) console.log(font.css_name);

				});

			});*/

		};


		//add this page to the site object
		site.sitePages.push( this );

		//plant the new UL in the DOM (on the canvas)
		site.divCanvas.appendChild(this.parentUL);

		//make the blocks/frames in each page sortable

		var thePage = this;

		$(this.parentUL).sortable({
			revert: true,
			placeholder: "drop-hover",
			handle: '.dragBlock',
			cancel: '',
			stop: function () {
				site.activePage.transparentOverlay('off');
				site.setPendingChanges(true);
				if ( !site.loaded() ) builderUI.canvasLoading('on');
			},
			beforeStop: function(event, ui){

				//template or regular block?
				var attr = ui.item.attr('data-frames');

				var newBlock;

				if (typeof attr !== typeof undefined && attr !== false) {//template, build it

					$('#start').hide();

					//clear out all blocks on this page
					thePage.clear();

					//create the new frames
					var frameIDs = ui.item.attr('data-frames').split('-');
					var heights = ui.item.attr('data-heights').split('-');
					var urls = ui.item.attr('data-originalurls').split('-');

					for( var x = 0; x < frameIDs.length; x++) {

						newBlock = new Block('block');
						newBlock.createParentLI(heights[x]);

						var frameData = {};

						frameData.src = appUI.moduleURL+'getframe/?id='+frameIDs[x];
						frameData.frames_original_url = appUI.moduleURL+'getframe/?id='+frameIDs[x];
						frameData.frames_height = heights[x];

						newBlock.createFrame( frameData );
						newBlock.createFrameCover();
					
//console.log( builderUI );

						newBlock.insertBlockIntoDom(thePage.parentUL);
						
	//					newBlock.insertBlockIntoTemp(thePage.parentUL);
						
						

						//add the block to the new page
						thePage.blocks.push(newBlock);

						//dropped element, so we've got pending changes
						site.setPendingChanges(true);

					}

					//set the tempateID
					builderUI.templateID = ui.item.attr('data-pageid');

					//make sure nothing gets dropped in the lsit
					ui.item.html(null);

					//delete drag place holder
					$('body .ui-sortable-helper').remove();

				} else {//regular block

					//are we dealing with a new block being dropped onto the canvas, or a reordering og blocks already on the canvas?

					if( ui.item.find('.frameCover > button').size() > 0 ) {//re-ordering of blocks on canvas

						//no need to create a new block object, we simply need to make sure the position of the existing block in the Site object
						//is changed to reflect the new position of the block on th canvas

						var frameID = ui.item.find('iframe').attr('id');
						var newPos = ui.item.index();

						site.activePage.setPosition(frameID, newPos);

						//swap iframe's content with builder.frameContent
						//ui.item.find('iframe').contents().find( bConfig.pageContainer ).html(builderUI.frameContent);

						ui.item.find('iframe').on('load', function () {
							$(this).contents().find( bConfig.pageContainer ).html(builderUI.frameContents);
							site.activePage.heightAdjustment();
							site.activePage.fireBlockLoadEvent(frameID);
						});

					} else {//new block on canvas

						//new block
						newBlock = new Block('block');

						newBlock.placeOnCanvas(ui);

					}

				}

			},
			start: function (event, ui) {

				site.activePage.transparentOverlay('on');

				if( ui.item.find('.frameCover').size() !== 0 ) {
					builderUI.frameContents = ui.item.find('iframe').contents().find( bConfig.pageContainer ).html();
				}

			},
			over: function(){

				$('#start').hide();

			}
		});

		//add to the pages menu
		this.menuItem = document.createElement('LI');
		this.menuItem.innerHTML = this.pageMenuTemplate;

		$(this.menuItem).find('a:first').text(pageName).attr('data-href', '#page'+counter);
		$(this.menuItem).find('a:first').text(pageName).attr('href', window.location.pathname+'?id='+siteBuilderUtils.getParameterByName('id')+'&p='+pageName);

		var theLink = $(this.menuItem).find('a:first').get(0);

		//bind some events
		this.menuItem.addEventListener('click', this, false);

		if ( counter === 1 ) {
			this.menuItem.querySelector('.fileEdit').remove();
			this.menuItem.querySelector('.fileDel').remove();
//			this.menuItem.querySelector('.fileSave').remove();
		} else {
			this.menuItem.querySelector('.fileEdit').addEventListener('click', this, false);
			this.menuItem.querySelector('.fileSave').addEventListener('click', this, false);
			this.menuItem.querySelector('.fileDel').addEventListener('click', this, false);
		}
		this.menuItem.querySelector('.fileDuplicate').addEventListener('click', function(){
			for( var i in site.sitePages ) {
				if( site.sitePages[i].name === this.parentNode.parentNode.getElementsByClassName('menuItemLink')[0].innerHTML ) {//got a match!
					site.deActivateAll();
					var newSettings=site.sitePages[i].pageSettings;
					newSettings.page_id=0;
					var dupPage = new Page('Dup'+i+'_'+site.sitePages[i].name, newSettings, site.sitePages.length+1);
					dupPage.status = 'new';
					for( var x = 0; x < site.sitePages[i].blocks.length; x++ ) {
						var newBlock = new Block('block');
						page.blocks[x].src = appUI.dataUrls.getframe + "?id="+page.blocks[x].id;
						if( page.blocks[x].frames_sandbox === '1') {
							newBlock.sandbox_loader = page.blocks[x].frames_loaderfunction;
						}
						newBlock.page = dupPage;
						if ( page.blocks[x].frames_global === '1' ) newBlock.global = true;
						newBlock.createParentLI(page.blocks[x].frames_height);
						newBlock.createFrame(page.blocks[x]);
						newBlock.createFrameCover();
						newBlock.insertBlockIntoDom(dupPage.parentUL);
						dupPage.blocks.push(newBlock);
					}
					
					dupPage.isEmpty();
					dupPage.selectPage();
					site.setPendingChanges(true);
				}
			}
		}, false);
		//add to the page link dropdown
		this.linksDropdownItem = document.createElement('OPTION');
		this.linksDropdownItem.setAttribute('value', pageName+".html");
		this.linksDropdownItem.text = pageName;

		builderUI.dropdownPageLinks.appendChild( this.linksDropdownItem );
		site.pagesMenu.appendChild(this.menuItem);

	}
	
	Page.prototype.handleEvent = function(event) {
		switch (event.type) {
			case "click":

				if( event.target.classList.contains('fileEdit') ) {

					this.editPageName();
					this.flgRunEdit=true;

				} else if( event.target.classList.contains('fileDuplicate') ) {

					//

				} else if( event.target.classList.contains('fileSave') ) {
					this.updatePageNameEvent(event.target);
				} else if( event.target.classList.contains('fileDel') ) {

					var thePage = this;

					$(builderUI.modalDeletePage).modal('show');

					$(builderUI.modalDeletePage).off('click', '#deletePageConfirm').on('click', '#deletePageConfirm', function() {

						thePage.delete();
						
						site.setPendingChanges(true);
						
						if( document.getElementById('saveTemplate') != null ){
							$(document.getElementById('saveTemplate')).trigger( "click" );
						}else{
							site.save(true);
						}
						var sitePosition='';
						if( window.location.href.indexOf( '/site-backend/' ) !== -1 ){
							sitePosition='/site-backend';
						}
						
						if( event.target.localName != 'li' ){
					//		window.location=sitePosition+'/ifunnels-studio/create/?id='+siteBuilderUtils.getParameterByName('id');
						}
		
						$(builderUI.modalDeletePage).modal('hide');

					});

				} else {

					event.preventDefault();
					
					site.pendingChanges = false;
					/** TODO: для чего это??? */
					if( !this.flgRunEdit ){
					
						if( document.getElementById('saveTemplate') != null ){
							const { templates } = require('./templates');
							templates.save().then((response) => window.location = $(event.target).attr('href'));
							return;
						} else {
							site.save(false);
						}

						if( event.target.localName != 'li' ){
							window.location = $(event.target).attr('href');
						}
					}
				}
		}
	};


	/*
		Block constructor
	*/
	function Block (type) {
		this.type = type;
		this.frameID = 0;
		this.page = {};
		this.loaded = false;
		this.sandbox = false;
		this.sandbox_loader = '';
		this.status = '';//'', 'changed' or 'new'
		this.global = false;
		this.originalUrl = '';

		this.parentLI = {};
		this.frameCover = {};
		this.frame = {};
		this.frameDocument = {};
		this.frameHeight = 0;
		this.dublicate = false;
		this.frameContent = null;

		this.annot = {};
		this.annotTimeout = {};

		this.oldWidth = 0;//used to determine the end of width animations

		/*
			creates the parent container (LI)
		*/
		this.createParentLI = function(height) {

			this.parentLI = document.createElement('LI');
			this.parentLI.setAttribute('class', 'element');
			//this.parentLI.setAttribute('style', 'height: '+height+'px');

		};

		/*
			creates the iframe on the canvas
		*/
		this.createFrame = function(frame, dublicate = false) {

			this.frame = document.createElement('IFRAME');
			this.frame.setAttribute('frameborder', 0);
			this.frame.setAttribute('scrolling', 0);
			this.frame.setAttribute('src', frame.src);
			this.frame.setAttribute('data-originalurl', frame.frames_original_url);
			this.originalUrl = frame.frames_original_url;
			//this.frame.setAttribute('data-height', frame.frames_height);
			this.frameHeight = frame.frames_height;
			this.frameContent = frame.frames_content;

			//vh heights require special attention
			if ( frame.frames_height.indexOf('vh') !== -1 ) this.frame.style.height = frame.frames_height;

			$(this.frame).uniqueId();

			//sandbox?
			if( this.sandbox !== false ) {

				this.frame.setAttribute('data-loaderfunction', this.sandbox_loader);
				this.frame.setAttribute('data-sandbox', this.sandbox);

				//recreate the sandboxed iframe elsewhere
				var sandboxedFrame = $('<iframe src="'+frame.src+'" id="'+this.sandbox+'" sandbox="allow-same-origin"></iframe>');
				$('#sandboxes').append( sandboxedFrame );
			}
			this.dublicate = dublicate;
		};

		/*
			Applies global and page styles to the block's iframe
		*/
		this.applyCustomCSS = function () {
			
			if( typeof this.frameDocument.querySelector != 'undefined' ){
				// remove possible old <style> section
				let oldStyle = this.frameDocument.querySelector('head style#custom_css');
				if ( oldStyle ) oldStyle.remove();
			}

			let theStyle = document.createElement('style');
			theStyle.id = "custom_css";
			theStyle.innerText = "";

			// do we have any custom to apply?
			if ( site.data.global_css ) {

				theStyle.innerText += site.data.global_css;

			}

			if ( this.page.pageSettings !== undefined && this.page.pageSettings.page_css !== '' ) {

				theStyle.innerText = theStyle.innerText + "\n" + this.page.pageSettings.page_css;

			}

			// only apply if there's custom css to apply
			if ( theStyle.innerText !== '' ) this.frameDocument.querySelector('head').appendChild(theStyle);
 
		};

		/*
			insert the iframe into the DOM on the canvas
		*/
		this.insertBlockIntoDom = function(theUL) {

			this.parentLI.appendChild(this.frame);
			theUL.appendChild( this.parentLI );

			if(this.dublicate){
				$(this.frame).contents().find('#page').replaceWith(this.frameContent);
			}

			this.frame.addEventListener('load', this, false);

			builderUI.canvasLoading('on');

		};
		
		/*
			добавление страницы в память, но без загрузки
		*/
		this.insertBlockIntoTemp = function(theUL) {

			this.parentLI.appendChild(this.frame);
			
			var addElt=document.createElement('textarea');
			addElt.style='display:none';
			addElt.innerHTML = this.parentLI.outerHTML;
			theUL.appendChild(addElt);
		};

		/*
			sets the frame document for the block's iframe
		*/
		this.setFrameDocument = function() {

			//set the frame document as well
			if( this.frame.contentDocument ) {
				this.frameDocument = this.frame.contentDocument;
			} else {
				this.frameDocument = this.frame.contentWindow.document;
			}

		};

		/*
			hides the frame toolbar
		*/
		this.hideFrameCover = function () {

			this.frameCover.style.display = 'none';

		};

		/*
			un-hides the frame toolbar
		*/
		this.unhideFrameCover = function () {

			this.frameCover.style.display = 'block';

		};

		/*
			creates the frame cover and block action button
		*/
		this.createFrameCover = function() {

			let newFramecover = this.type !== 'popup' ? document.importNode( document.getElementById('frameCoverTemplate').content, true ) : document.importNode( document.getElementById('frameCoverPopupTemplate').content, true );

			this.frameCover = newFramecover.querySelector('.frameCover');
			this.parentLI.appendChild(this.frameCover);

			if (this.type === 'popup') {
				
				
				
				if (this.popupType === 'exit' || this.popupType === 'entry') {
					this.frameCover.classList.add('entry');
		
				  	//hide the ID section
				  	$('.divPopupID', this.frameCover).remove();
		
				  	// Set the re-orrurrence dropdown
				  	$('select.selectPopupRecurrence', this.frameCover).val( this.popupReoccurrence );
				  	$('select.selectPopupRecurrence', this.frameCover).trigger('change');
		
					// Set the delay dropdown
					$('select.selectPopupDelay', this.frameCover).val(this.popupDelay);
					$('select.selectPopupDelay', this.frameCover).trigger('change');
		
					if (this.popupType === 'exit' || this.popupType === 'regular') {
						$('select.selectPopupDelay', this.frameCover).val('0');
						$('select.selectPopupDelay', this.frameCover).trigger('change');
						$('select.selectPopupDelay', this.frameCover).select2('destroy');
						$('select.selectPopupDelay', this.frameCover).prop('disabled', true);
						$('select.selectPopupDelay', this.frameCover).select2();
					}
		
					$('select.selectPopupRecurrence', this.frameCover).on( 'change', event => {
						this.popupReoccurrence = event.currentTarget.value;
						site.setPendingChanges(true);
					});
		
					$('select.selectPopupDelay', this.frameCover).on('change', event => {
						this.popupDelay = event.currentTarget.value;
						site.setPendingChanges(true);
					});
				} else {

					this.frameCover.classList.add('regular');
					this.frameCover.querySelector('.divPopupDelayWrapper').remove();
					this.frameCover.querySelector('.divPopupOccurrenceWrapper').remove();
			
					$('.divPopupID', this.frameCover).text('#' + this.popupID);
				}
				
				
				
				
			}

			/* setup the global block checkbox */
			if ( this.global === true ) $('input[type="checkbox"]', $(this.frameCover)).attr('checked', true);
			var theBlock = this;
			$('input[type="checkbox"]', $(this.frameCover)).on('change', function (e) {
				theBlock.toggleGlobal(e);
			}).radiocheck();
			/* setup the trash, reset, source and favourite links */
			let buttons = this.frameCover.querySelectorAll('.btn:not(.dragBlock)');
			for ( let button of buttons ) button.addEventListener('click', this, false);
			/* 
				should this block have the delete and save original buttons? (does not apply
				to saved/favourite blocks) 
			*/
			if ( this.frame.getAttribute('data-originalurl').indexOf('sites/getframe') !== -1 && this.frame.getAttribute('data-originalurl').indexOf('.html') === -1 ) {
				if (this.frameCover.querySelector('button.buttonDelOriginal')) this.frameCover.querySelector('button.buttonDelOriginal').setAttribute('disabled', true);
				if (this.frameCover.querySelector('button.buttonSaveOriginal')) this.frameCover.querySelector('button.buttonSaveOriginal').setAttribute('disabled', true);
			} else {
				//this.frameCover.querySelector('buttonSaveOriginal')
			}
			/* setup the toggle button */
			$(this.frameCover.querySelector('button.frameCoverToggle')).on('click', function (){
				if ( this.frameCover.classList.contains('stay') ) {
					this.frameCover.classList.remove('stay');
					this.frameCover.querySelector('button.frameCoverToggle').innerHTML = '<span class="fui-gear"></span>';
					this.parentLI.style.overflow = 'hidden';
				} else {
					this.frameCover.classList.add('stay');
					this.frameCover.querySelector('button.frameCoverToggle').innerHTML = '<span class="fui-cross-circle"></span>';
				}

			}.bind(this));
			$('select', this.frameCover).select2({
				minimumResultsForSearch: -1
			});
			// Setup the clone in cat links
			$('.dropdownCloneInCat a', this.frameCover).on('click', function (e) {
				this.cloneInCategory(e.currentTarget);
				return false;
			}.bind(this));
			$('.dropdownCloneInCat', this.frameCover).on('show.bs.dropdown', function (e) {
				$(e.currentTarget).closest('li').css('overflow', 'visible');
			});
			$('.dropdownCloneInCat', this.frameCover).on('hide.bs.dropdown', function (e) {
				$(e.currentTarget).closest('li').css('overflow', 'hidden');
			});
		};
		/*
			Configures the frameCover button tooltips once the frame has finished loading
		*/
		this.frameCovertooltips = function () {
			if (this.frameDocument.body.clientHeight > 200 ) {
				$('[data-toggle="tooltip"]', $(this.frameCover)).tooltip({
					trigger: 'hover',
					placement: 'bottom'
				});
			}
		};
		/*
			Places a transparent overlay over the block
		*/
		this.transparentOverlay = function (onOrOff = 'on') {
			var div,
				divs;
			if ( onOrOff === 'on' ) {//show the overlay
				divs = this.parentLI.querySelectorAll('div[data-overlay]');
				for ( div of divs ) {
					div.remove();
				}
				div = document.createElement('DIV');
				div.style.position = 'absolute';
				div.style.left = '0px';
				div.style.top = '0px';
				div.style.width = '100%';
				div.style.height = '100%';
				div.style.background = 'none';
				div.setAttribute('data-overlay', true);
				this.parentLI.appendChild(div);
			} else if ( onOrOff === 'off' ) {//hide the overlay
				divs = this.parentLI.querySelectorAll('div[data-overlay]');
				for ( div of divs ) {
					div.remove();
				}
			}
		};

		this.toggleGlobal = function (e) {
			if ( e.currentTarget.checked ) this.global = true;
			else this.global = false;
			//we've got pending changes
			site.setPendingChanges(true);
		};
		/*
			automatically corrects the height of the block's iframe depending on its content
		*/
		this.heightAdjustment = function() {
			if( Object.keys(this.frameDocument).length !== 0 && this.frame.style.height.indexOf('vh') === -1 ){
				this.frame.style.height = '0px';
				this.frameDocument.body.style.display = 'inline-block';
				var height = this.frameDocument.querySelector('html').offsetHeight;
				this.frameDocument.body.style.display = '';
				this.frame.style.height = height+"px";
				this.parentLI.style.height = height+"px";
				//this.frameCover.style.height = height+"px";
				this.frameHeight = height;
			}else if( this.frame.style.height.indexOf('vh') !== -1 ){
				this.parentLI.style.height = this.frame.style.height;
			}
		};

		/*
			deletes a block
		*/
		this.delete = function() {

			//remove from DOM/canvas with a nice animation
			$(this.frame.parentNode).fadeOut(500, function(){

				this.remove();

				site.activePage.isEmpty();

			});

			//remove from blocks array in the active page
			site.activePage.deleteBlock(this);

			//sanbox
			if( this.sanbdox ) {
				document.getElementById( this.sandbox ).remove();
			}

			//element was deleted, so we've got pending change
			site.setPendingChanges(true);

		};

		/*
			resets a block to it's orignal state
		*/
		this.reset = function (fireEvent) {

			if ( typeof fireEvent === 'undefined') fireEvent = true;

			//reset frame by reloading it
			this.frame.contentWindow.location = this.frame.getAttribute('data-originalurl');

			//sandbox?
			if( this.sandbox ) {
				var sandboxFrame = document.getElementById(this.sandbox).contentWindow.location.reload();
			}

			//element was deleted, so we've got pending changes
			site.setPendingChanges(true);

			builderUI.canvasLoading('on');

			if ( fireEvent ) publisher.publish('onBlockChange', this, 'reload');

		};

		/*
			launches the source code editor
		*/
		this.source = function() {

			//hide the iframe
			this.frame.style.display = 'none';

			//disable sortable on the parentLI
			$(this.parentLI.parentNode).sortable('disable');

			//built editor element
			var theEditor = document.createElement('DIV');
			theEditor.classList.add('aceEditor');
			$(theEditor).uniqueId();

			this.parentLI.appendChild(theEditor);

			//build and append error drawer
			var newLI = document.createElement('LI');
			var errorDrawer = document.createElement('DIV');
			errorDrawer.classList.add('errorDrawer');
			errorDrawer.setAttribute('id', 'div_errorDrawer');
			errorDrawer.innerHTML = '<button type="button" class="btn btn-xs btn-embossed btn-default button_clearErrorDrawer" id="button_clearErrorDrawer">CLEAR</button>';
			newLI.appendChild(errorDrawer);
			errorDrawer.querySelector('button').addEventListener('click', this, false);
			this.parentLI.parentNode.insertBefore(newLI, this.parentLI.nextSibling);

			require('brace/mode/html');
			require('brace/theme/twilight');

			var theId = theEditor.getAttribute('id');
			var editor = ace.edit( theId );

			//editor.getSession().setUseWrapMode(true);

			var pageContainer = this.frameDocument.querySelector( bConfig.pageContainer );
			var theHTML = pageContainer.innerHTML;


			editor.setValue( theHTML );
			editor.setTheme("ace/theme/" + bConfig.aceTheme);
			editor.getSession().setMode("ace/mode/html");

			var block = this;


			editor.getSession().on("changeAnnotation", function(){

				block.annot = editor.getSession().getAnnotations();

				clearTimeout(block.annotTimeout);

				var timeoutCount;

				if( $('#div_errorDrawer p').size() === 0 ) {
					timeoutCount = bConfig.sourceCodeEditSyntaxDelay;
				} else {
					timeoutCount = 100;
				}

				block.annotTimeout = setTimeout(function(){

					for (var key in block.annot){

						if (block.annot.hasOwnProperty(key)) {

							if( block.annot[key].text !== "Start tag seen without seeing a doctype first. Expected e.g. <!DOCTYPE html>." ) {

								var newLine = $('<p></p>');
								var newKey = $('<b>'+block.annot[key].type+': </b>');
								var newInfo = $('<span> '+block.annot[key].text + "on line " + " <b>" + block.annot[key].row+'</b></span>');
								newLine.append( newKey );
								newLine.append( newInfo );

								$('#div_errorDrawer').append( newLine );

							}

						}

					}

					if( $('#div_errorDrawer').css('display') === 'none' && $('#div_errorDrawer').find('p').size() > 0 ) {
						$('#div_errorDrawer').slideDown();
					}

				}, timeoutCount);


			});

			var buttonWrapper = document.createElement('DIV');
			buttonWrapper.classList.add('editorButtons');

			let editorButtons = document.importNode(document.getElementById('sourceEditorButtons').content, true);

			buttonWrapper.append( editorButtons.querySelector('#editCancelButton') );
			buttonWrapper.append( editorButtons.querySelector('#editSaveButton') );

			buttonWrapper.querySelector('#editCancelButton').addEventListener('click', this, false);
			buttonWrapper.querySelector('#editSaveButton').addEventListener('click', this, false);

			this.parentLI.appendChild( buttonWrapper );

			//should be make it a little higher?
			if ( this.parentLI.offsetHeight < 300 ) {
				this.parentLI.setAttribute('data-original-height', this.parentLI.offsetHeight+"px");
				this.parentLI.style.height = "300px";
			}

			builderUI.aceEditors[ theId ] = editor;

		};

		/*
			cancels the block source code editor
		*/
		this.cancelSourceBlock = function() {

			//enable draggable on the LI
			$(this.parentLI.parentNode).sortable('enable');

			//delete the errorDrawer
			$(this.parentLI.nextSibling).remove();

			//delete the editor
			this.parentLI.querySelector('.aceEditor').remove();
			$(this.frame).fadeIn(500);

			if ( this.parentLI.hasAttribute('data-original-height') ) {
				this.parentLI.style.height = this.parentLI.getAttribute('data-original-height');
				this.parentLI.removeAttribute('data-original-height');
			}

			$(this.parentLI.querySelector('.editorButtons')).fadeOut(500, function(){
				$(this).remove();
			});

		};

		/*
			updates the blocks source code
		*/
		this.saveSourceBlock = function() {

			//enable draggable on the LI
			$(this.parentLI.parentNode).sortable('enable');

			var theId = this.parentLI.querySelector('.aceEditor').getAttribute('id');
			var theContent = builderUI.aceEditors[theId].getValue();

			//delete the errorDrawer
			document.getElementById('div_errorDrawer').parentNode.remove();

			//delete the editor
			this.parentLI.querySelector('.aceEditor').remove();

			//update the frame's content
			this.frameDocument.querySelector( bConfig.pageContainer ).innerHTML = theContent;
			this.frame.style.display = 'block';

			//sandboxed?
			if( this.sandbox ) {

				var sandboxFrame = document.getElementById( this.sandbox );
				var sandboxFrameDocument = sandboxFrame.contentDocument || sandboxFrame.contentWindow.document;

				builderUI.tempFrame = sandboxFrame;

				sandboxFrameDocument.querySelector( bConfig.pageContainer ).innerHTML = theContent;

				//do we need to execute a loader function?
				if( this.sandbox_loader !== '' ) {

					/*
					var codeToExecute = "sandboxFrame.contentWindow."+this.sandbox_loader+"()";
					var tmpFunc = new Function(codeToExecute);
					tmpFunc();
					*/

				}

			}

			$(this.parentLI.querySelector('.editorButtons')).fadeOut(500, function(){
				$(this).remove();
			});

			if ( this.parentLI.hasAttribute('data-original-height') ) this.parentLI.removeAttribute('data-original-height');

			//adjust height of the frame
			this.heightAdjustment();

			//new page added, we've got pending changes
			site.setPendingChanges(true);

			//block has changed
			this.status = 'changed';

			publisher.publish('onBlockChange', this, 'change');
			publisher.publish('onBlockLoaded', this);

		};

		/*
			clears out the error drawer
		*/
		this.clearErrorDrawer = function() {

			var ps = this.parentLI.nextSibling.querySelectorAll('p');

			for( var i = 0; i < ps.length; i++ ) {
				ps[i].remove();
			}

		};

		/*
			returns the full source code of the block's frame
		*/
		this.getSource = function(appendEmbeds) {
			let embeds = {};
			let source = '<html>';

			const blockHead = this.frameDocument.head.cloneNode(true);
			blockHead.querySelectorAll('.resize-triggers-styles').forEach(style => style.remove());

			const blockBody = this.frameDocument.body.cloneNode(true);
			blockBody.querySelectorAll('.resize-triggers').forEach(trigger => trigger.remove());

			blockBody.querySelectorAll('[data-embed-id]').forEach( embed => {
				const originalId = embed.getAttribute('data-embed-id');
				embed.innerHTML = site.embeds[originalId];
				embeds[originalId] = site.embeds[originalId];
				if (appendEmbeds) {
					const newId = shortid.generate();
					embed.setAttribute('data-embed-id', newId);
					const embedScript = document.createElement('SCRIPT');
					embedScript.text = `
					if (!window.blockEmbeds) window.blockEmbeds = {};
						window.blockEmbeds["${newId}"] = "${utils.custom_base64_encode(
						embeds[originalId]
					)}";
					`;
					embedScript.classList.add('embed-data');
					blockBody.appendChild(embedScript);
				}
			});

			const videoWrapper = blockBody.querySelector('[data-component="video2"] > .videoWrapper');

			if (videoWrapper) {
				const script = videoWrapper.querySelector('script[type="application/json"]');
				const { src, type } = JSON.parse(script.innerText);
				const container = videoWrapper.querySelector('.video-container');

				videoWrapper.removeChild(script);
				container.innerHTML = `<video width="100%" height="100%" class="video-js"><source src="${src}" type="${type}"></video>`;

				const styles = blockHead.querySelectorAll('style[class^="vjs-styles"]');

				if (styles.length) {
					styles.forEach(node => blockHead.removeChild(node));
				}

				['https://www.youtube.com/iframe_api', 'https://www.youtube.com/s/player/82e684c7/www-widgetapi.vflset/www-widgetapi.js'].map(s => {
					const _script = blockHead.querySelectorAll(`script[src="${s}"]`);
					
					if (_script.length) {
						_script.forEach( e => blockHead.removeChild(e));
					}
				});
			}

			const video_ui = blockBody.querySelector('script[src="/skin/pagebuilder/build/video-ui.bundle.js"]');

			if (video_ui) {
				blockBody.removeChild(video_ui);
			}

			source += blockHead.outerHTML + blockBody.outerHTML;
			source += '</html>';

			source = utils.custom_base64_encode(source);
			embeds = JSON.stringify(embeds);
			embeds = utils.custom_base64_encode(embeds);
	  
			return { source, embeds };
		  };

		/*
			places a dragged/dropped block from the left sidebar onto the canvas
		*/
		this.placeOnCanvas = function(ui) {

			//frame data, we'll need this before messing with the item's content HTML
			var frameData = {}, attr;

			if( ui.item.find('iframe').size() > 0 ) {//iframe thumbnail

				frameData.src = ui.item.find('iframe').attr('src');
				frameData.frames_original_url = ui.item.find('iframe').attr('src');
				frameData.frames_height = ui.item.height();

				//sandboxed block?
				attr = ui.item.find('iframe').attr('sandbox');

				if (typeof attr !== typeof undefined && attr !== false) {
					this.sandbox = siteBuilderUtils.getRandomArbitrary(10000, 1000000000);
					this.sandbox_loader = ui.item.find('iframe').attr('data-loaderfunction');
				}

			} else {//image thumbnail

				frameData.src = ui.item.find('img').attr('data-srcc');
				frameData.frames_original_url = ui.item.find('img').attr('data-srcc');
				frameData.frames_height = ui.item.find('img').attr('data-height');

				//sandboxed block?
				attr = ui.item.find('img').attr('data-sandbox');

				if (typeof attr !== typeof undefined && attr !== false) {
					this.sandbox = siteBuilderUtils.getRandomArbitrary(10000, 1000000000);
					this.sandbox_loader = ui.item.find('img').attr('data-loaderfunction');
				}

			}

			//create the new block object
			this.frameID = 0;
			this.parentLI = ui.item.get(0);
			this.parentLI.innerHTML = '';
			this.status = 'new';
			this.createFrame(frameData);

			if (this.type === 'popup') {
				this.parentLI.setAttribute('data-page-name', site.activePage.name);
				this.parentLI.setAttribute('data-page-id', site.activePage.pageID);
			}

			if ( frameData.frames_height.indexOf('vh') !== -1 ) 
				this.parentLI.style.height = frameData.frames_height;
			else 
				this.parentLI.style.height = this.frameHeight + "px";

			this.createFrameCover();

			this.frame.addEventListener('load', this);

			//insert the created iframe
			ui.item.append($(this.frame));

			//add the block to the current page
			if (this.type === 'block') 
				site.activePage.blocks.splice(ui.item.index(), 0, this); 
			else 
				site.activePage.popups.splice(ui.item.index(), 0, this);

			//custom event
			ui.item.find('iframe').trigger('canvasupdated');

			//dropped element, so we've got pending changes
			site.setPendingChanges(true);

		};

		/*
			injects external JS (defined in config.js) into the block
		*/
		this.loadJavascript = function () {

			var i,
				old,
				newScript;

			//remove old ones
			old = this.frameDocument.querySelectorAll('script.builder');

			/*for ( i = 0; i < old.length; i++ ) old[i].remove();*/

			//inject
			for ( i = 0; i < bConfig.externalJS.length; i++ ) {

				newScript = document.createElement('SCRIPT');
				newScript.classList.add('builder');
				newScript.src = bConfig.externalJS[i];

				this.frameDocument.querySelector('body').appendChild(newScript);

			}

			if (this.frameDocument.querySelector('[data-component="video2"] > .videoWrapper')) {
				newScript = document.createElement('SCRIPT');
				newScript.src = '/skin/pagebuilder/build/video-ui.bundle.js';
				
				this.frameDocument.body.appendChild(newScript);
			}
		};


		/*
			Checks if this block has external stylesheet
		*/
		this.hasExternalCSS = function (src) {
			var externalCss,
				x;
			externalCss = this.frameDocument.querySelectorAll('link[href*="' + src + '"]');
			return externalCss.length !== 0;
		};


		/*
			Turn grid view on or off
		*/
		this.gridView = function (on) {
			if ( on ) {
				this.frameDocument.querySelector('body').classList.add('gridView');
			} else {
				this.frameDocument.querySelector('body').classList.remove('gridView');
			}
		};
		
		/** Show selected test variant */
		this.variantView = function () {
			const nodeElements = this.frameDocument.querySelectorAll('[data-variant-name]');
			nodeElements.forEach((n) => n.removeAttribute("data-variant-show"));

			// Add styles for show/hide variant of elements
			this.addStyleToVariant();
			
			this.heightAdjustment();
		};

		this.addStyleToVariant = function() {
			let style = this.frameDocument.head.querySelector('[data-variants]');
			const styles = `[data-variant-current="#"] [data-vhide-default],[data-variant-name]:not([data-variant-name="${site.activePage.currentVariant}"]):not([data-vshow~="${site.activePage.currentVariant}"]):not([data-variant-show="true"]){display: none;}[data-variant-show="true"]{visibility:visible;}[data-variant-show="false"]{display:none;}`;

			if(!style) {
				style = this.frameDocument.createElement('style');
				style.setAttribute('data-variants', true);
				this.frameDocument.head.appendChild(style);
			}

			this.frameDocument.body.setAttribute('data-variant-current', site.activePage.currentVariant);

			style.innerHTML = styles;
		}

		this.updateAttrShow = function () {
			const { frameDocument } = this;
			const el = [...frameDocument.querySelectorAll('[data-variant-name="#"]')];

			if (el.length) {
				el.forEach((e) => {
					const selector = e.getAttribute("data-selector");
					const tagName = e.tagName;
					const hide = (e.getAttribute("data-vhide") || "").split(",");

					const addedVariants = [
						...e.parentNode.querySelectorAll(
						`${tagName.toLowerCase()}[data-selector='${selector}']:not([data-variant-name="#"])`
						),
					].map((v) => v.getAttribute("data-variant-name"));

					let show = site.activePage.variants.filter(
						(v) => addedVariants.indexOf(v) === -1 && v !== "#"
					);

					show = show.filter((v) => !hide.includes(v));
					e.setAttribute("data-vshow", show.join(" "));
				});
			}
    	};

		this.cloneInCategory = function (el) {

			let theBlock = this;
			let dropdown = $(el).closest('.btn-group').find('.dropdown-toggle');

			let frames_content = utils.custom_base64_encode(theBlock.getSource());
			let frames_height = theBlock.frameHeight;
			let frames_width = theBlock.frameDocument.querySelector('body').offsetWidth;
			let category = el.getAttribute('data-cat-id');

			// Collapse the dropdown
			dropdown.dropdown('toggle');

			// disable the dropdown for now
			dropdown.attr('disabled', true);

			$.ajax({
				url: appUI.dataUrls.cloneblock,
				type: "POST",
				data: { 
					frames_content: frames_content,
					frames_height: frames_height,
					frames_width: frames_width,
					category: category
				},
				dataType: "json"
			}).done(function (ret) {
				let notifyConfig = notify.config;
				dropdown.removeAttr('disabled');
				if ( ret.responseCode === 1 ) {
					notifyConfig.className = "joy";
					$.notify(ret.content, notifyConfig);
					builderUI.loadBlocksComponents(true, false);
				} else {
					notifyConfig.className = "bummer";
					$.notify(ret.content, notifyConfig);
				}
			});

		};

		/*
			Deletes the original block's template
		*/
		this.deleteOriginalBlock = function (el) {
			let theBlock = this;
			let element = (el.classList.contains('btn')) ? el : el.parentNode;
			element.blur();
			function hideButton () {
				return new Promise (function (resolve, reject) {
					$('i', element).fadeOut( () => {
						let newSpan = document.createElement('SPAN');
						newSpan.innerText = element.getAttribute('data-saving');
						element.appendChild(newSpan);
						resolve(element);
					});
				});
			}

			function deleteBlockRemote (el) {

				let frames_url = theBlock.frame.getAttribute('data-originalurl');

				return new Promise(function (resolve, reject) {

					$.ajax({
						url: appUI.dataUrls.deleteoriginal_block,
						type: "POST",
						data: { 
							frames_url: frames_url
						},
						dataType: "json"
					}).done(function (ret) {

						let notifyConfig = notify.config;

						if ( ret.responseCode === 1 ) {

							notifyConfig.className = "joy";
							$.notify(ret.content, notifyConfig);
							builderUI.loadBlocksComponents(true, false);
							resolve(el);

						} else {

							notifyConfig.className = "bummer";
							$.notify(ret.content, notifyConfig);
							reject(el);

						}

					});

				});

			}

			function hideSaving (el) {

				return new Promise(function (resolve, reject) {

					$('span', el).fadeOut(function () {

						this.remove();

						let newSpan = document.createElement('SPAN');
						newSpan.innerText = el.getAttribute('data-confirmation');

						el.appendChild(newSpan);

						resolve(el);

					});

				});

			}

			function deleteRemoteFailed (el) {

				$('span', el).fadeOut( function () {

					this.remove();
					$('i', el).fadeIn();

				});

			}

			function deletedTimeout (el) {

				setTimeout( () => {

					$('span', el).fadeOut( function () {

						this.remove();
						$('i', el).fadeIn();

						theBlock.frameCover.classList.remove('stay');

					});

				}, 3000);

			}

			let q = hideButton()
				.then(deleteBlockRemote)
				.then(hideSaving,)
				.then(deletedTimeout)
				.catch(deleteRemoteFailed);

		};

		/*
			Save / overwrite the original block
		*/
		this.saveOriginalBlock = function (el) {

			let theBlock = this;
			let element = (el.classList.contains('btn')) ? el : el.parentNode;

			element.blur();

			function hideButton () {

				return new Promise (function (resolve, reject) {

					$('i', element).fadeOut( () => {

						let newSpan = document.createElement('SPAN');
						newSpan.innerText = element.getAttribute('data-saving');

						element.appendChild(newSpan);

						resolve(element);

					});

				});

			}

			function saveBlockRemote (el) {

				let frames_content = utils.custom_base64_encode(theBlock.getSource());
				let frames_url = theBlock.frame.getAttribute('data-originalurl');
				let frames_height = theBlock.frameHeight;
				let frames_width = theBlock.frameDocument.querySelector('body').offsetWidth;

				return new Promise(function (resolve, reject) {

					$.ajax({
						url: appUI.dataUrls.updateoriginal_block,
						type: "POST",
						data: { 
							frames_content: frames_content, 
							frames_url: frames_url,
							frames_height: frames_height,
							frames_width: frames_width
						},
						dataType: "json"
					}).done(function (ret) {

						let notifyConfig = notify.config;

						if ( ret.responseCode === 1 ) {

							notifyConfig.className = "joy";
							$.notify(ret.content, notifyConfig);
							builderUI.loadBlocksComponents(true, false);
							resolve(el);

						} else {

							notifyConfig.className = "bummer";
							$.notify(ret.content, notifyConfig);
							reject(el);

						}

					});

				});

			}

			function hideSaving (el) {

				return new Promise(function (resolve, reject) {

					$('span', el).fadeOut(function () {

						this.remove();

						let newSpan = document.createElement('SPAN');
						newSpan.innerText = el.getAttribute('data-confirmation');

						el.appendChild(newSpan);

						resolve(el);

					});

				});

			}

			function saveRemoteFailed (el) {

				$('span', el).fadeOut( function () {

					this.remove();
					$('i', el).fadeIn();

				});

			}

			function savedTimeout (el) {

				setTimeout( () => {

					$('span', el).fadeOut( function () {

						this.remove();
						$('i', el).fadeIn();

						theBlock.frameCover.classList.remove('stay');

					});

				}, 3000);

			}

			let q = hideButton()
				.then(saveBlockRemote)
				.then(hideSaving,)
				.then(savedTimeout)
				.catch(saveRemoteFailed);

		};

		/*
			Save this block as favourite
		*/
		this.saveAsFav = function (el) {

			let theBlock = this;
			let element = (el.classList.contains('btn')) ? el : el.parentNode;

			element.blur(); // remove focus / depressed state

			function hideFavButton () {

				return new Promise (function (resolve, reject) {

					$('i', element).fadeOut( () => {

						let newSpan = document.createElement('SPAN');
						newSpan.innerText = element.getAttribute('data-saving');

						element.appendChild(newSpan);

						// prevent the frameCover from disappearing
						theBlock.frameCover.classList.add('stay');

						resolve(element);

					});

				});

			}

			function saveFavRemote (el) {		
				let frames_content = theBlock.getSource().source; //utils.custom_base64_encode(theBlock.getSource());
				let frames_height = theBlock.frameHeight;
				let frames_original_url = theBlock.originalUrl;
				let frames_width = theBlock.frameDocument.querySelector('body').offsetWidth;
				let frames_type = theBlock.type;

				return new Promise(function (resolve, reject) {

					$.ajax({
						url: appUI.dataUrls.favoriteblock,
						type: "POST",
						data: { 
							frames_content: frames_content, 
							frames_height: frames_height, 
							frames_original_url: frames_original_url,
							frames_width: frames_width,
							frames_type: frames_type
						},
						dataType: "json"
					}).done(function (ret) {

						if ( ret.responseCode === 1 ) {

							// add the new fav block to the sidebar
							
							let newItem = false;
							
							if( frames_type == 'popup' ){
								newItem = $('<li style="display: none"><a href="" class="delFavBlock" data-block-id="'+ret.block.blocks_id+'"><i class="fui-cross-circle"></i></a><img src="'+appUI.cnmPath+ret.block.blocks_thumb+'" data-srcc="'+ret.block.blocks_url+'" data-height="'+ret.block.blocks_height+'"></li>');
								$(builderUI.sideSecondPopupNav).find('ul:first').append(newItem);
							}else{
								newItem = $('<li style="display: none"><a href="" class="delFavBlock" data-block-id="'+ret.block.blocks_id+'"><i class="fui-cross-circle"></i></a><img src="'+ret.block.blocks_thumb+'" data-srcc="'+ret.block.blocks_url+'" data-height="'+ret.block.blocks_height+'"></li>');
								$(builderUI.sideSecondBlocksNav).find('ul:first').append(newItem);
							}

							newItem.fadeIn();

							builderUI.makeDraggable();

							resolve(el);

							$(builderUI.sideSecondComponentsNav).empty();
							builderUI.loadBlocksComponents();

						} else {

							reject(el);

						}

					});

				});

			}

			function hideSaving (el) {

				return new Promise(function (resolve, reject) {

					$('span', el).fadeOut(function () {

						this.remove();

						let newSpan = document.createElement('SPAN');
						newSpan.innerText = el.getAttribute('data-confirmation');

						el.appendChild(newSpan);

						resolve(el);

					});

				});

			}

			function saveRemoteFailed (el) {

				alert('Could not save the block as favourite, please try again');

				$('span', el).fadeOut( function () {

					this.remove();
					$('i', el).fadeIn();

				});

			}

			function savedTimeout (el) {

				setTimeout( () => {

					$('span', el).fadeOut( function () {

						this.remove();
						$('i', el).fadeIn();

						theBlock.frameCover.classList.remove('stay');

					});

				}, 3000);

			}

			let q = hideFavButton()
				.then(saveFavRemote)
				.then(hideSaving,)
				.then(savedTimeout)
				.catch(saveRemoteFailed);

		};

	}

	Block.prototype.handleEvent = function(event) {
		switch (event.type) {
			case "load":
				this.setFrameDocument();
				this.applyCustomCSS();
				this.heightAdjustment();
				this.loadJavascript();
				this.frameCovertooltips();

				$(this.frameCover).removeClass('fresh', 500);

				publisher.publish('onBlockLoaded', this);

				this.loaded = true;

				builderUI.canvasLoading('off');

				userActions.addUserActionsToIframe( this.frameDocument );

				break;

			case "click":

				var theBlock = this;

				//figure out what to do next

				if( event.target.classList.contains('deleteBlock') || event.target.parentNode.classList.contains('deleteBlock') ) {//delete this block

					$(builderUI.modalDeleteBlock).modal('show');

					$(builderUI.modalDeleteBlock).off('click', '#deleteBlockConfirm').on('click', '#deleteBlockConfirm', function(){
						theBlock.delete(event);
						$(builderUI.modalDeleteBlock).modal('hide');
					});

				} else if( event.target.classList.contains('resetBlock') || event.target.parentNode.classList.contains('resetBlock') ) {//reset the block

					$(builderUI.modalResetBlock).modal('show');

					$(builderUI.modalResetBlock).off('click', '#resetBlockConfirm').on('click', '#resetBlockConfirm', function(){
						theBlock.reset();
						$(builderUI.modalResetBlock).modal('hide');
					});

				} else if( event.target.classList.contains('htmlBlock') || event.target.parentNode.classList.contains('htmlBlock') ) {//source code editor

					theBlock.source();

				} else if ( event.target.classList.contains('favBlock') || event.target.parentNode.classList.contains('favBlock') ) {

					theBlock.saveAsFav(event.target);
					/*site.setPendingChanges(true);
					site.autoSave();*/

				} else if( event.target.classList.contains('editCancelButton') || event.target.parentNode.classList.contains('editCancelButton') ) {//cancel source code editor

					theBlock.cancelSourceBlock();

				} else if( event.target.classList.contains('editSaveButton') || event.target.parentNode.classList.contains('editSaveButton') ) {//save source code

					theBlock.saveSourceBlock();

				} else if( event.target.classList.contains('button_clearErrorDrawer') ) {//clear error drawer

					theBlock.clearErrorDrawer();

				} else if( event.target.classList.contains('buttonSaveOriginal') || event.target.parentNode.classList.contains('buttonSaveOriginal') ) { // Save original

					theBlock.saveOriginalBlock(event.target);

				} else if ( event.target.classList.contains('buttonDelOriginal') || event.target.parentNode.classList.contains('buttonDelOriginal') ) { // Delete original

					theBlock.deleteOriginalBlock(event.target);

				}

		}
	};


	/*
		Site object literal
	*/
	/*jshint -W003 */
	var site = {

		pendingChanges: false,      //pending changes or no?
		pages: {},                  //array containing all pages, including the child frames, loaded from the server on page load
		is_admin: 0,                //0 for non-admin, 1 for admin
		data: {},                   //container for ajax loaded site data
		pagesToDelete: [],          //contains pages to be deleted

		sitePages: [],              //this is the only var containing the recent canvas contents

		sitePagesReadyForServer: {},     //contains the site data ready to be sent to the server

		activePage: {},             //holds a reference to the page currently open on the canvas

		pageTitle: document.getElementById('pageTitle'),//holds the page title of the current page on the canvas
		
		pageVariants: document.getElementById('pageVariants'),
		pageVariantsArray: ['#'],
		currentOptimizeVariant: '#',

		divCanvas: document.getElementById('pageList'),//DIV containing all pages on the canvas

		pagesMenu: document.getElementById('pages'), //UL containing the pages menu in the sidebar

		valueNewPage: document.getElementById('selectNewPage'),
		buttonNewPage: document.getElementById('addPage'),
		liNewPage: document.getElementById('newPageLI'),

		pName: document.querySelector('.pName'),

		inputPageSettingsTitle: document.getElementById('pageData_title'),
		inputPageSettingsMetaDescription: document.getElementById('pageData_metaDescription'),
		inputPageSettingsMetaKeywords: document.getElementById('pageData_metaKeywords'),
		inputPageSettingsIncludes: document.getElementById('pageData_headerIncludes'),
		inputPageSettingsPageCss: document.getElementById('pageData_headerCss'),
		inputPageSettingsGoogleFonts: document.getElementById('pageData_googleFonts'),
		inputPageSettingsHeaderScript: document.getElementById('pageData_headerScript'),
		inputPageSettingsFooterScript: document.getElementById('pageData_footerScript'),
		inputPageSettingsProtected: document.getElementById('protected_page'),
		inputPageSettingsMemberships: document.querySelectorAll('[name="arrData[memberships][]"]'),
		selectPageSettingsPrimaryMembership: document.getElementById('primary-membership'),

		// Drip Feed
		inpuPageSettingstDripFeedEnable: document.getElementById('drip_feed'),
		selectPageSettingsAfterPeriod: document.getElementById('after_period'),
		inputPageSettingsDripFeedValue: document.getElementById('drip_value'),

		// Optimization Test
		checkboxEnableTest: document.getElementById('optimization_test'),
		inputNameTest: document.querySelector('[name="arrData[optimization_test][name]"]'),
		checkboxGoalLeadTest: document.getElementById('goal_lead'),
		inputGoalLeadValue: document.querySelector('[name="arrData[goals][lead][value]"]'),
		checkboxGoalRegistrationTest: document.getElementById('goal_registration'),
		inputGoalRegistrationValue: document.querySelector('[name="arrData[goals][registration][value]"]'),
		checkboxGoalSaleTest: document.getElementById('goal_sale'),
		inputGoalSaleValue: document.querySelector('[name="arrData[goals][sale][value]"]'),
		inputTrackingCode: document.getElementById('tracking_code'),

		buttonSubmitPageSettings: document.getElementById('pageSettingsSubmittButton'),

		modalPageSettings: document.getElementById('pageSettingsModal'),
		
		modalOptimizeCreateBlock: document.getElementById('optimize_create_block'),
		modalOptimizeCreateBlockButton: document.getElementById('optimize_create_block_button'),
		buttonOptimizeCreateBlockSave: document.getElementById('optimize_create_block_save'),
		
		modalOptimizeVariantSettings: document.getElementById('optimize_create_variant'),
		modalOptimizeVariantSettingsButton: document.getElementById('optimize_create_variant_button'),
		buttonOptimizeVariantSettingsSave: document.getElementById('optimize_create_variant_save'),
		inputVariantFlgWinner: document.getElementById('flg_select_winer'),
		inputVariantDays: document.getElementById('optimize_days'),
		inputVariantVisits: document.getElementById('optimize_visits'),

		buttonSave: document.getElementById('savePage'),

		messageStart: document.getElementById('start'),
		divFrameWrapper: document.getElementById('frameWrapper'),

		skeleton: document.getElementById('skeleton'),

		autoSaveTimer: {},

		customFonts: {},

		linkNewPage: document.getElementById('linkNewPage'),

		init: function(run) {
			$.getJSON(appUI.dataUrls.siteData, function(data) {

				site.customFonts = data.fonts;

				if ( data.language ) window.language = data.language;

				if (data.settings) builderUI.settings = data.settings;

				if( data.site !== undefined ) {

					site.data = data.site;

					if( data.site.viewmode ) {
						publisher.publish('onSetMode', data.site.viewmode);
					}

				}

				if( data.pages !== undefined ) {
					site.pages = data.pages;
				}

				site.is_admin = data.is_admin;

				if ( data.google_api !== undefined ) {
					bConfig.google_api = data.google_api;
				}

				if( $('#pageList').size() > 0 ) {
					builderUI.populateCanvas();
				}

				if ( data.templateID !== undefined ) {
					builderUI.templateID = data.templateID;
				}
				
				//fire custom event
				$('body').trigger('siteDataLoaded');
				publisher.publish('siteDataLoaded');
			});

			this.loadPageSettings = this.loadPageSettings.bind(this);
			

			$(this.buttonNewPage).on('click', site.newPage);
			$(this.modalPageSettings).on('show.bs.modal', site.loadPageSettings);


			$(this.buttonSubmitPageSettings).on('click', site.updatePageSettings);
			$(this.buttonSave).on('click', e => {
				site.save(true);
			});
			$(this.linkNewPage).on('click', site.addNewPage);

			this.loadVariantSettings = this.loadVariantSettings.bind(this);
			$(this.modalOptimizeVariantSettings).on('show.bs.modal', site.loadVariantSettings);
			$(this.buttonOptimizeVariantSettingsSave).on('click', e => {

				site.activePage.pageSettings.variantsSettings[this.surrentOptimizeVariant]=[
					this.inputVariantFlgWinner.checked,
					this.inputVariantDays.value,
					this.inputVariantVisits.value,
				];
				var arrayToString='';
				var i;
				for( i in site.activePage.pageSettings.variantsSettings ){
					arrayToString=i+':'+site.activePage.pageSettings.variantsSettings[i].join()+( arrayToString==''?arrayToString:'|'+arrayToString);
				}
				site.activePage.pageSettings.optimize_page_settings=arrayToString;
				document.getElementById('optimize_page_settings').value=arrayToString;
				site.setPendingChanges(true);
				$(this.modalOptimizeVariantSettings).modal('hide');
			});

			//auto save time
			this.autoSaveTimer = setTimeout(site.autoSave, bConfig.autoSaveTimeout);

			publisher.subscribe('onBlockChange', function (block, type) {

				if ( block.global ) {

					for ( var i = 0; i < site.sitePages.length; i++ ) {

						for ( var y = 0; y < site.sitePages[i].blocks.length; y ++ ) {

							if ( site.sitePages[i].blocks[y] !== block && site.sitePages[i].blocks[y].originalUrl === block.originalUrl && site.sitePages[i].blocks[y].global ) {

								if ( type === 'change' ) {

									// Remove blue outline, sb_open class
									let theClone = block.frameDocument.body.cloneNode(true);
									let opens = theClone.querySelectorAll('.sb_open');

									for ( let el of opens ) {
										el.classList.remove('sb_open');
									}

									/*opens.forEach(function (el) {
										el.classList.remove('sb_open');
									});*/


									site.sitePages[i].blocks[y].frameDocument.body = theClone;

									publisher.publish('onBlockLoaded', site.sitePages[i].blocks[y]);

								} else if ( type === 'reload' ) {

									site.sitePages[i].blocks[y].reset(false);

								}

								site.sitePages[i].status = 'changed';

							}

						}

					}

				}

			});

			/*
				This to make sure we update some site details when the site details form is submitted
			*/
			publisher.subscribe('onSiteDetailsSaved', function (formData) {

				formData.forEach(function (entry) {

					if ( entry.name === 'sites_name' ) site.data.sites_name = entry.value;
					if ( entry.name === 'global_css' ) site.data.global_css = entry.value;

				});

				// apply possible custom styles to each block on the canvas
				site.applyCustomCSS();

			});

			$(site.skeleton).on('load', function () {

				publisher.publish('onSkeletonLoaded', this);

			});

			this.inputPageSettingsMemberships.forEach( input => input.addEventListener( 'change', this.updateSelectPrimaryMembership ) );

		},

		initBlock: function(){
			return new Block('block');
		},

		applyCustomCSS: function () {

			for ( let page of site.sitePages ) {
				for ( let block of page.blocks ) {
					block.applyCustomCSS();
				}
			}

		},

		autoSave: function(){

			if( userActions.getStatus() ) {
				return;
			}

			if(site.pendingChanges) {
				site.save(false);
			}

			window.clearInterval(this.autoSaveTimer);
			this.autoSaveTimer = setTimeout(site.autoSave, bConfig.autoSaveTimeout);

		},

		setPendingChanges: function(value) {

			site.pendingChanges = value;

			if( value === true ) {

				//reset timer
				window.clearInterval(this.autoSaveTimer);
				this.autoSaveTimer = setTimeout(site.autoSave, bConfig.autoSaveTimeout);

				$('#savePage .bLabel').text( $('#savePage').attr('data-label2') );

				if( site.activePage.status !== 'new' ) {

					site.activePage.status = 'changed';

				}

			} else {

				$('#savePage .bLabel').text( $('#savePage').attr('data-label') );

				site.updatePageStatus('');

			}

			userActions.pendingChanges = value;

		},

		save: function(showConfirmModal) {

			publisher.publish('onBeforeSave');

			//fire custom event
			$('body').trigger('beforeSave');

			//disable button
			$("#savePage").addClass('disabled');
			$("#savePage").find('.bLabel').text( $("#savePage").attr('data-loading') );

			//remove old alerts
			$('#errorModal .modal-body > *, #successModal .modal-body > *').each(function(){
				$(this).remove();
			});

			//remove all tick activations
			$('.tick').each(function(){
				$(this).remove();
			});

			site.prepForSave(false);

			var serverData = {};
			serverData.pages = this.sitePagesReadyForServer;

			if( this.pagesToDelete.length > 0 ) {
				serverData.toDelete = this.pagesToDelete;
				this.pagesToDelete = [];
			}
			
			$.ajax({
				url: appUI.dataUrls.siteData,
				dataType: 'json',
				async: false,
				success: function(data) {
					site.customFonts = data.fonts;
					if ( data.language ) window.language = data.language;
					if( data.site !== undefined ) {
						site.data = data.site;
					}
					if( data.pages !== undefined ) {
						site.pages = data.pages;
					}
					site.is_admin = data.is_admin;
				}
			});

			serverData.siteData = site.data;

			//store current responsive mode as well
			serverData.siteData.responsiveMode = builderUI.currentResponsiveMode;
			serverData.autosave = !showConfirmModal; 
			$.ajax({
				url: appUI.dataUrls.save,
				type: "POST",
				dataType: "json",
				data: serverData,
				async: false,
			}).done(function(res){

				//enable button
				$("#savePage").removeClass('disabled');
				$("#savePage").find('.bLabel').text( $("#savePage").attr('data-label') );

				if( res.responseCode === 0 ) {

					if( showConfirmModal ) {

						$('#errorModal .modal-body').html( $(res.responseHTML) );
						$('#errorModal').modal('show');

					}

				} else if( res.responseCode === 1 ) {
					
					
					let _activePage = site.activePage.name;
					_activePage = siteBuilderUtils.getParameterByName('p');
					
					site.sitePages = [];
					$.getJSON(appUI.dataUrls.siteData, function(data) {
						site.customFonts = data.fonts;
						if ( data.language ) window.language = data.language;
						if( data.site !== undefined ) {
							site.data = data.site;
							if( data.site.viewmode ) {
								publisher.publish('onSetMode', data.site.viewmode);
							}
						}
		
						if( data.pages !== undefined ) {
							site.pages = data.pages;
						}
		
						site.is_admin = data.is_admin;
		
						if ( data.google_api !== undefined ) {
							bConfig.google_api = data.google_api;
						}
		
						if( $('#pageList').size() > 0 ) {
							$('#pageList, #pages, #entryPopup > ul, #exitPopup > ul, #regularPopup > ul').empty();
							builderUI.populateCanvas();

							site.sitePages.forEach(function(page){
								if(page.name == _activePage){
									page.selectPage();
								}
							});
						}
		
						if ( data.templateID !== undefined ) {
							builderUI.templateID = data.templateID;
						}
		
						//fire custom event
						$('body').trigger('siteDataLoaded');
						publisher.publish('siteDataLoaded');
		
					});

					if( showConfirmModal ) {

						$('#successModal .modal-body').html( $(res.responseHTML) );
						$('#successModal').modal('show');

					}
					//no more pending changes
					site.setPendingChanges(false);
					this.pagesToDelete = [];

					//update revisions?
					$('body').trigger('changePage');

				}

				publisher.publish('onAfterSave');

			});

		},

		/*
			preps the site data before sending it to the server
		*/
		prepForSave: function(template) {

			this.sitePagesReadyForServer = {};

			//find the pages which need to be send to the server
			for( var i = 0; i < this.sitePages.length; i++ ) {

				if( this.sitePages[i].status !== '' ) {

					this.sitePagesReadyForServer[this.sitePages[i].name] = this.sitePages[i].prepForSave();

				}
			}
		},


		/*
			sets a page as the active one
		*/
		setActive: function(page) {

			//reference to the active page
			this.activePage = page;

			//hide other pages
			for(var i in this.sitePages) {
				this.sitePages[i].parentUL.style.display = 'none';
			}

			//display active one
			this.activePage.parentUL.style.display = 'block';

		},


		/*
			de-active all page menu items
		*/
		deActivateAll: function() {

			var pages = this.pagesMenu.querySelectorAll('li');

			for( var i = 0; i < pages.length; i++ ) {
				pages[i].classList.remove('active');
			}

		},


		/*
			adds a new page to the site
		*/
		newPage: function() {
			site.deActivateAll();

			$('#newPageModal').modal('show');
		},

		addNewPage: function(e) {
			e.preventDefault();
			$('#newPageModal').modal('hide');

			const pageIdValue = window.storage.getData('pageId') || 'new'; 
			
			if( pageIdValue != 'new' ){
				$.ajax({
					dataType: "json",
					url: appUI.dataUrls.pageDataUrl,
					data: {
						pageID: pageIdValue
					},
					success: function(data) {
						if( data.page !== undefined ) {
							const sitePages = {};
							const pageName = Object.keys( data.page )[0];
							
							sitePages[pageName] = data.page[pageName];
							sitePages[pageName]['page_id'] = 0;
							
							const newPage = new Page( `new-${pageName}`, sitePages[pageName], site.sitePages.length + 1);
							newPage.status = 'new';

							for( let x = 0; x < sitePages[pageName].blocks.length; x++ ) {
								const newBlock = new Block('block');
								sitePages[pageName].blocks[x].src = `${appUI.dataUrls.getframe}?id=${sitePages[pageName].blocks[x].id}`;

								if( sitePages[pageName].blocks[x].frames_sandbox === '1') {
									newBlock.sandbox_loader = page.blocks[x].frames_loaderfunction;
								}

								newBlock.page = newPage;
								
								if ( sitePages[pageName].blocks[x].frames_global === '1' ) newBlock.global = true;
								newBlock.createParentLI(sitePages[pageName].blocks[x].frames_height);
								newBlock.createFrame(sitePages[pageName].blocks[x]);
								newBlock.createFrameCover();
								newBlock.insertBlockIntoDom(newPage.parentUL);
								newPage.blocks.push(newBlock);
							}
							newPage.selectPage();
							newPage.isEmpty();
						}
					}
				});
			} else {
				// create the new page instance
				const newPage = new Page(`page${site.sitePages.length + 1}`, {pages_id: 0, drip_feed: {enable: 0, after_period: 'month', value: null}}, site.sitePages.length + 1);

				newPage.status = 'new';
				newPage.selectPage();
				newPage.editPageName();
				newPage.isEmpty();
			}

			site.activePage.flgRunEdit = true;


			site.setPendingChanges(true);
		},
		
		/*
			checks if the name of a page is allowed
		*/
		checkPageName: function(pageName) {

			//make sure the name is unique
			var pageNames=[];
			for( var i in this.sitePages ) {
				if( pageNames[this.sitePages[i].name] == undefined ){
					pageNames[this.sitePages[i].name]=0;
				}
				pageNames[this.sitePages[i].name]++;
			}
			if( pageNames[pageName] > 1 ){
				this.pageNameError = "The page name must be unique.";
				return false;
			}
			return true;

		},


		/*
			removes unallowed characters from the page name
		*/
		prepPageName: function(pageName) {

			pageName = pageName.replace(' ', '');
			pageName = pageName.replace(/[?*!.|&#;$%@"<>()+,^]/g, "");

			return pageName;

		},


		/*
			variant settings load
		*/
		loadVariantSettings: function() {
			if( typeof site.activePage.pageSettings.variantsSettings[this.surrentOptimizeVariant] != 'undefined' ){
				$(this.inputVariantFlgWinner).prop('checked', site.activePage.pageSettings.variantsSettings[this.surrentOptimizeVariant][0] ).change();
				this.inputVariantDays.value=site.activePage.pageSettings.variantsSettings[this.surrentOptimizeVariant][1];
				this.inputVariantVisits.value=site.activePage.pageSettings.variantsSettings[this.surrentOptimizeVariant][2];
			}
		},


		/*
			save page settings for the current page
		*/
		updatePageSettings: function() {

			site.activePage.pageSettings.title = site.inputPageSettingsTitle.value;
			site.activePage.pageSettings.meta_description = site.inputPageSettingsMetaDescription.value;
			site.activePage.pageSettings.meta_keywords = site.inputPageSettingsMetaKeywords.value;
			site.activePage.pageSettings.header_includes = site.inputPageSettingsIncludes.value;
			site.activePage.pageSettings.page_css = site.inputPageSettingsPageCss.value;
			site.activePage.pageSettings.header_script = site.inputPageSettingsHeaderScript.value;
			site.activePage.pageSettings.footer_script = site.inputPageSettingsFooterScript.value;

			if(site.inputPageSettingsProtected) {
				site.activePage.pageSettings.protected = site.inputPageSettingsProtected.checked ? '1' : '0';
				site.activePage.pageSettings.memberships = site.getSelectedMemberships( site.inputPageSettingsMemberships );
				site.activePage.pageSettings.primary_membership = site.selectPageSettingsPrimaryMembership.value;
				site.activePage.pageSettings.drip_feed.enable = site.inpuPageSettingstDripFeedEnable.checked ? '1' : '0';
				site.activePage.pageSettings.drip_feed.after_period = site.selectPageSettingsAfterPeriod.value;
				site.activePage.pageSettings.drip_feed.value = site.inputPageSettingsDripFeedValue.value;
			}

			if( site.checkboxEnableTest ) {
				site.activePage.pageSettings.optimization_test.enable = site.checkboxEnableTest.checked ? 'true' : 'false';
				site.activePage.pageSettings.optimization_test.name = site.checkboxEnableTest ? site.inputNameTest.value : null;
				
				if( site.checkboxEnableTest.checked ) {
					// Lead
					site.activePage.pageSettings.optimization_test.goals.lead = {
						enable: site.checkboxGoalLeadTest.checked,
						value: site.checkboxGoalLeadTest.checked ? site.inputGoalLeadValue.value : null
					};
	
					// Registration
					site.activePage.pageSettings.optimization_test.goals.registration = {
						enable: site.checkboxGoalRegistrationTest.checked,
						value: site.checkboxGoalRegistrationTest.checked ? site.inputGoalRegistrationValue.value : null
					};
	
					// Sale
					site.activePage.pageSettings.optimization_test.goals.sale = {
						enable: site.checkboxGoalSaleTest.checked,
						value: site.checkboxGoalSaleTest.checked ? site.inputGoalSaleValue.value : null
					};
				} else {
					// Lead
					site.activePage.pageSettings.optimization_test.goals.lead = 
					// Registration
					site.activePage.pageSettings.optimization_test.goals.registration = 
					// Sale
					site.activePage.pageSettings.optimization_test.goals.sale = {
						enable: false,
						value: null
					};
				}

				publisher.publish('onChangedStatus', site.checkboxEnableTest);
			}

			// Google fonts
			let usedFonts = $(site.inputPageSettingsGoogleFonts).tagsinput('items');

			site.activePage.pageSettings.google_fonts.forEach(function (font) {

				if ( usedFonts.indexOf(font.nice_name) === -1 ) {

					let index = site.activePage.pageSettings.google_fonts.indexOf(font);
					site.activePage.pageSettings.google_fonts.splice(index, 1);

				}    

			});

			site.setPendingChanges(true);

			$(site.modalPageSettings).modal('hide');

			site.applyCustomCSS();

			

		},

		getSelectedMemberships: function( inputMemberships ) {
			const memberships = [];

			if( inputMemberships ) {
				inputMemberships.forEach( input => {
					if( input.checked ) {
						memberships.push( input.value );
					}
				});
			}

			return memberships;
		},


		/*
			update page statuses
		*/
		updatePageStatus: function(status) {

			for( var i in this.sitePages ) {
				this.sitePages[i].status = status;
			}

		},


		/*
			Checks all the blocks in this site have finished loading
		*/
		loaded: function () {
			var i;
			for ( i = 0; i < this.sitePages.length; i++ ) {
				if ( !this.sitePages[i].loaded() ) return false;
			}
			return true;
		},

		/*
			Turn grid view on/off
		*/
		gridView: function (on) {

			var i;

			for ( i in this.sitePages ) this.sitePages[i].gridView(on);

		},

		/** Selected optimize */
		openOptimizeVariant : function(  ){
			$(this.modalOptimizeVariantSettingsButton).trigger('click');
			
		},

		/** Selected optimize */
		openOptimizeSettings : function( type='create'/* edit */, variantsData, surrentVariant, flgShow=true ){
			$(this.modalOptimizeCreateBlockButton).trigger('click');
			$('#select_variant').empty();
			$('#show_variant').prop('checked', flgShow).change();
			variantsData.forEach( arrVar => {
				const option = document.createElement( 'option');
				option.value = arrVar;
				option.textContent = arrVar;
				if( surrentVariant == arrVar ){
					option.selected = true;
				}
				document.getElementById('select_variant').appendChild( option );
				$( document.getElementById('select_variant') ).selectpicker('refresh');
			});
			
			var optionsString=" ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			document.getElementById('new_variant').value=optionsString[ variantsData.length ];
			document.getElementById('crerate_variant').value=type;
		},

		/** Selected memberships */
		loadPageSettings : function( e ) {
			/** Change page name */
			site.pName.innerHTML = `${site.activePage.name}.html`;
			const { memberships, drip_feed } = site.activePage.pageSettings;

			if( site.activePage.pageSettings.protected == '1' ) {
				site.inputPageSettingsProtected.checked = true;
			}

			if( this.inputPageSettingsMemberships ) {
				this.inputPageSettingsMemberships.forEach( input => {
					if( memberships.indexOf( input.value ) !== -1 ) {
						input.checked = true;
					}
				} );
			}

			if( drip_feed.enable == 1 ) {
				site.inpuPageSettingstDripFeedEnable.checked = true;
				$('#drip_feed').bootstrapSwitch( 'state', true );

				site.selectPageSettingsAfterPeriod.querySelector(`option[value="${drip_feed.after_period}"]`).setAttribute('selected', 'selected');
				$( site.selectPageSettingsAfterPeriod ).selectpicker('refresh');
				site.inputPageSettingsDripFeedValue.value = drip_feed.value;
			}

			const { optimization_test } = site.activePage.pageSettings;
			if (this.checkboxEnableTest) {
				this.checkboxEnableTest.checked = optimization_test.enable === 'true' ? true : false;
				$(this.checkboxEnableTest).bootstrapSwitch( 'state', optimization_test.enable === 'true' ? true : false );

				this.inputNameTest.value = optimization_test.name || '';
				this.checkboxGoalLeadTest.checked = optimization_test.goals.lead.enable === 'true' ? true : false;
				this.inputGoalLeadValue.value = optimization_test.goals.lead.value || '';

				if (optimization_test.goals.lead.enable === 'true') {
					const inputNode = this.checkboxGoalLeadTest.parentNode.nextElementSibling;

					if( inputNode ) {
						inputNode.style.display = this.checkboxGoalLeadTest.checked ? 'flex' : 'none';
					}
				}

				this.checkboxGoalRegistrationTest.checked = optimization_test.goals.registration.enable === 'true' ? true : false;
				this.inputGoalRegistrationValue.value = optimization_test.goals.registration.value || '';

				if (optimization_test.goals.registration.enable === 'true') {
					const inputNode = this.checkboxGoalRegistrationTest.parentNode.nextElementSibling;

					if( inputNode ) {
						inputNode.style.display = this.checkboxGoalRegistrationTest.checked ? 'flex' : 'none';
					}
				}

				this.checkboxGoalSaleTest.checked = optimization_test.goals.sale.enable === 'true' ? true : false;
				this.inputGoalSaleValue.value = optimization_test.goals.sale.value || '';

				if (optimization_test.goals.sale.enable === 'true') {
					const inputNode = this.checkboxGoalSaleTest.parentNode.nextElementSibling;

					if( inputNode ) {
						inputNode.style.display = this.checkboxGoalSaleTest.checked ? 'flex' : 'none';
					}
				}
			}

			site.updateSelectPrimaryMembership();
		},

		updateSelectPrimaryMembership : function( e ) {
			const listMembership = [];

			if(!site.selectPageSettingsPrimaryMembership) {
				return;
			}

			site.inputPageSettingsMemberships.forEach( input => {
				if( input.checked ) {
					listMembership.push( { name: input.previousSibling.textContent.trim(), value: input.value } );
				}
			});

			site.selectPageSettingsPrimaryMembership.querySelectorAll( 'option' ).forEach( option => {
				site.selectPageSettingsPrimaryMembership.removeChild( option );
			} );

			listMembership.forEach( membership => {
				const option = document.createElement( 'option');
				option.value = membership.value;
				option.textContent = membership.name;

				if( site.activePage.pageSettings.primary_membership == membership.value ) {
					option.selected = true;
				}

				site.selectPageSettingsPrimaryMembership.appendChild( option );

				$( site.selectPageSettingsPrimaryMembership ).selectpicker('refresh');
			} );
		}

	};

	builderUI.init(); site.init();


	//**** EXPORTS
	module.exports.site = site;
	module.exports.builderUI = builderUI;
	module.exports.Block = Block;
}());