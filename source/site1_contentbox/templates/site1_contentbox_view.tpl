{literal}
var m=document.createElement('script');
m.type="text/javascript";
m.src="{/literal}{$host}{literal}/skin/_js/mootools.js";
document.getElementsByTagName('head')[0].appendChild(m);
var checkMooTools=function(){
	try{
		if(MooTools.version){

			window.addEvent('domready', function() {
				cbView();
			});
			//cbView(); 
		} 
	}catch(e){ 
		console.log(e); 
		setTimeout('checkMooTools()',100);
	}
};
checkMooTools();
function cbView(){
var cbEditor = new Class({
	
	cbCounter: 0, // сколько было создано блоков, чтобы не пересекались удаленные и вновь созданные ( при новом блоке всегда +1 )
	
	defaultBoxes: '{/literal}{$codedData}{literal}', // дефолтные натсройки боксов
	
	lastElementSelected: false, // флаги работы с элементами
	lastElementResize: false, 
	lastElementMove: false, 
	
	elementMoveType: false, // тип уголка изменения размера основного блока

	elementOptions:false, // опции отдельных элементов настройки при переносе в блок настроек
	settingsDefault:false, // редактируемые опциии
	mouseXpos : 0,
	mouseYpos : 0,
	mouseMoveX : 0,
	mouseMoveY : 0,
	formId : 0,

	selectionBox:false,
	
	mergeOptions:function( obj1,obj2 ){ // obj1 переписывается значениями obj2
		var obj3={};
		for (var attr in obj1) {
			obj3[attr]=obj1[attr];
		}
		for (var attr in obj2) {
			if( typeof obj3[attr] == 'object' ){
				obj3[attr]=this.mergeOptions( obj3[attr], obj2[attr] );
			}else{
				obj3[attr]=obj2[attr];
			}
		}
		return obj3;
	},
	
	defautOptions:new Object(),
	
	addDefaultSettings: function( dataSettings ){
		var object=this;
		if( dataSettings != null && dataSettings.length > 0 ){
			if( typeof blockPosition != 'undefined' ){
				if( object.dTop == window.innerHeight && object.dLeft == window.innerWidth ){
					dataSettings.each(function(elt, boxid){
						for( var key in elt ){
							if( 'left' == key && object.dLeft>dataSettings[boxid][key] ){
								object.dLeft=parseInt( dataSettings[boxid][key] );
							}
							if( 'top' == key && object.dTop>dataSettings[boxid][key] ){
								object.dTop=parseInt( dataSettings[boxid][key] );
							}
						}
					});
				}
			}
			dataSettings.each(function(elt, boxid){
				object.settingsDefault=elt;
				var newElement=new Element( 'div' );
				if( typeof object.settingsDefault['type'] != 'undefined' ){
					newElement.set( 'data-target', object.settingsDefault['type'] );
				}
				object.cbCounter = parseInt(object.settingsDefault.boxid);
				object.selectSettings( newElement,  object.cbCounter);
				object.settingsDefault=false;
				newElement.destroy();
			});
		}
	},
	
	initialize: function(){
		var object=this;
		$$('head')[0].adopt(new Element('link', { 'rel' : 'stylesheet', 'href' : 'https://cdnjs.cloudflare.com/ajax/libs/material-design-iconic-font/2.2.0/css/material-design-iconic-font.min.css' }));
		$$('head')[0].adopt(new Element('link', { 'rel' : 'stylesheet', 'href' : '//{Zend_Registry::get( 'config' )->domain->host}/skin/_css/normalize.css' }));

		if( object.defaultBoxes != '' ){
			var dataSettings=JSON.decode( object.decode( object.defaultBoxes ) );
			object.addDefaultSettings( dataSettings );
		}

		$$('form').addEvent('submit', function(){
			if($(this).getElement('input[name="email"]') !== undefined) {
				if(!$(this).getElement('input[name="email"]').get('value').test(/^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$/)){
					$(this).getElement('input[name="email"]').focus();
					return false;
				}
			}
		});

		{/literal}{if isset($smarty.get.local_data)}{literal}
		$$( '#menu .options' ).each( function( elnt ){
			elnt.addEvent( 'mousedown', function( evnt ){
				if( evnt.target.get( 'class' ) != 'options' ){
					evnt.target=evnt.target.getParent(  );
				}
				if( $$('.options_'+evnt.target.get( 'data-target' ))[0] !== undefined && $$('.options_'+evnt.target.get( 'data-target' ))[0].getStyle('display') != 'block' ){
					$$('.menu_options').hide();
					$$('.options_'+evnt.target.get( 'data-target' )).show( 'block' );
				}else{
					$$('.menu_options').hide();
				}
			});
		});

		new CeraBox( $$('.popup-templates'), {
			group: false,
			displayTitle: true,
			titleFormat: '{title}',
			width:'80%',
			height:'80%',
			events:{
				onOpen: function(currentItem, collection){
					$$( '.move_box_settings' ).each( function( elnt ){
						elnt.addEvent( 'click', function( evnt ){
							if( typeof evnt.target.get('data-settings') != 'undefined' ){
								var dataSettings=JSON.decode( object.decode( evnt.target.get('data-settings') ) );
								object.addDefaultSettings( dataSettings );
								CeraBoxWindow.close();
							}
						});
					});
				},
			}
		});
		

		
		$$( '#menu .settings' ).each( function( elnt ){
			elnt.addEvent( 'mousedown', function( evnt ){
				if( evnt.target.get( 'class' ) != 'settings' ){
					evnt.target=evnt.target.getParent(  );
				}
				object.cbCounter += 1;
				object.selectSettings( evnt.target,  object.cbCounter);
			});
		});
		
		document.addEvent( 'mouseup', function( evt ){
			if( object.lastElementResize != false ){
				object.hookResize( evt, 'clear_elt' );
			}else{
				object.hookBox( evt, 'clear_elt' );
			}

			$$('div.content_box.selected').each(function(elm){
				elm.moveDeltaY = undefined;
				elm.moveDeltaX = undefined;
			});
		});

		document.addEvent( 'mousemove', function( evt ){
			if( object.lastElementResize != false ){
				object.resizeBox( evt );
			}
			if( object.lastElementMove != false ){
				object.moveBox( evt );
			}
		});

		$('generate').addEvent('click',function(){
			object.setMobileVersion();
			$('form-cb').set( 'action', '');
			$('form-cb').set( 'target','_self' );
			$('form-cb').submit();
		});

		$('emulator').addEvent('mousedown', function(prop){
			if(prop.target.get('class') != 'custom-scroll_inner') 
				return;
			$$('.content_box').removeClass('selected');
			if(prop.event.button == 0) {
				object.selectionBox = prop;
				$(document.body).adopt(new Element('div.selectionBox', { styles : { top: prop.client.y + 'px', left: prop.client.x + 'px', zIndex : '10' } }));
				$(document.body).setStyle('cursor', 'default');
			}
		});

		$('emulator').addEvent('mousemove', function(prop){
			if(Math.abs(object.mouseXpos - prop.client.x) < 10 || Math.abs(object.mouseYpos - prop.client.y) < 10)
				return; 
			else {
				object.mouseXpos = prop.client.x;
				object.mouseYpos = prop.client.y;
			}
			
			if(object.selectionBox !== false){
				var pos = {};
				$$('div.selectionBox')[0].removeProperty('style');
				if(prop.client.x < object.selectionBox.client.x)
					pos.right = $(document.body).getStyle('width').toInt() - object.selectionBox.client.x + 'px';
				else 
					pos.left = object.selectionBox.client.x;

				if(prop.client.y < object.selectionBox.client.y)
					pos.bottom = $(document.body).getStyle('height').toInt() - object.selectionBox.client.y + 'px';
				else
					pos.top = object.selectionBox.client.y;

				pos.width = Math.abs(prop.client.x - object.selectionBox.client.x) + 'px';
				pos.height = Math.abs(prop.client.y - object.selectionBox.client.y) + 'px';

				$$('div.selectionBox')[0].setStyles(pos);

				$$('.content_box').each(function(elm){

					var a = { x : elm.getStyle('left').toInt(), x1 : elm.getStyle('left').toInt() + elm.getStyle('width').toInt(), y : elm.getStyle('top').toInt(), y1 : elm.getStyle('top').toInt() + elm.getStyle('height').toInt() },
						b = { x : $$('div.selectionBox')[0].getStyle('left').toInt() - $$('div.emulator')[0].getBoundingClientRect().left.toInt(), x1 : $$('div.selectionBox')[0].getStyle('left').toInt() - $$('div.emulator')[0].getBoundingClientRect().left.toInt() + $$('div.selectionBox')[0].getStyle('width').toInt(), 
							  y : $$('div.selectionBox')[0].getStyle('top').toInt() - $$('div.emulator')[0].getBoundingClientRect().top.toInt(), y1 : $$('div.selectionBox')[0].getStyle('top').toInt() - $$('div.emulator')[0].getBoundingClientRect().top.toInt() + $$('div.selectionBox')[0].getStyle('height').toInt() };

					var intersect = function(a,b){
						return(
						(
							(
								( a.x>=b.x && a.x<=b.x1 )||( a.x1>=b.x && a.x1<=b.x1  )
							) && (
								( a.y>=b.y && a.y<=b.y1 )||( a.y1>=b.y && a.y1<=b.y1 )
							)
						)||(
							(
								( b.x>=a.x && b.x<=a.x1 )||( b.x1>=a.x && b.x1<=a.x1  )
							) && (
								( b.y>=a.y && b.y<=a.y1 )||( b.y1>=a.y && b.y1<=a.y1 )
							)
						)
						)||(
						(
							(
								( a.x>=b.x && a.x<=b.x1 )||( a.x1>=b.x && a.x1<=b.x1  )
							) && (
								( b.y>=a.y && b.y<=a.y1 )||( b.y1>=a.y && b.y1<=a.y1 )
							)
						)||(
							(
								( b.x>=a.x && b.x<=a.x1 )||( b.x1>=a.x && b.x1<=a.x1  )
							) && (
								( a.y>=b.y && a.y<=b.y1 )||( a.y1>=b.y && a.y1<=b.y1 )
							)
						)
						);
					}
					var _flagSelected = intersect(a, b);
					if(_flagSelected) elm.addClass('selected'); else elm.removeClass('selected');
				});
			}
				
		});

		$(document.body).addEvent('mouseup', function(prop){
			if(object.selectionBox !== false) {
				object.selectionBox = false;
				$$('div.selectionBox').dispose();
			}
		});

		$$('a[data-type]').addEvent('click', function(){
			if(!$(this).hasClass('active')) {
				$$('a[data-type]').removeClass('active');

				$$('.pc,.mobile,.tablet,.albumn').hide();
				$$('.' + $(this).get('data-type')).show();
				$(this).addClass('active');
				if($$('.orientation a.active[data-orientation]')[0].get('data-orientation') == 'albumn') {
					var width = $(this).get('data-size-height');
					var height = $(this).get('data-size-width');
					$$('div.mobile-img')[0].setStyles({left : 'calc(50% - 432.5px)', top: 'calc(50% - 215.5px)', height : '423px', width : '862px', 'background-image' : "url('/skin/i/frontends/design/2.png')"});

				} else {
					var width = $(this).get('data-size-width');
					var height = $(this).get('data-size-height');
					$$('div.mobile-img')[0].setStyles({left : 'calc(50% - 432.5px)', top: 'calc(50% - 215.5px)', height : '423px', width : '862px', 'background-image' : "url('/skin/i/frontends/design/1.png')"});

				}
				
				$$('div.emulator').setStyles({ top: "0", left: "0", width: "100%", height: "100%" });
				if($(this).get('data-type') == 'mobile') {
					$$('.emulator')[0].setStyles({ top : 'calc(50% - '+(height/2)+'px', left: 'calc(50% - '+(width/2)+'px)', width : ''+width+'px', height : ''+height+'px'});
					$$('div.mobile-img')[0].setStyles({top : 'calc(50% - 432.5px)', left: 'calc(50% - 215.5px)', width : '423px', height : '862px', 'background-image' : "url('/skin/i/frontends/design/1.png')"});
				}

				if($$('.orientation a.active[data-orientation]')[0].get('data-orientation') == 'albumn') {
					$$('div.mobile-img')[0].setStyles({left : 'calc(50% - 432.5px)', top: 'calc(50% - 215.5px)', height : '423px', width : '862px', 'background-image' : "url('/skin/i/frontends/design/2.png')"});
				} else {
					$$('div.mobile-img')[0].setStyles({top : 'calc(50% - 432.5px)', left: 'calc(50% - 215.5px)', width : '423px', height : '862px', 'background-image' : "url('/skin/i/frontends/design/1.png')"});
				}

				var _flag = false;
				$$('input[type="number"][data-return="top_m"]').each(function(elm){
					if(elm.get('value').toInt() != 0) {
						_flag = true;
					}
				});

				if($(this).get('data-type') == 'mobile' && !_flag) {

					var arrElts=$$('.content_box input[data-return$=type][data-default$=block]');
					var arrSortedElts=[];
					if ( arrElts.length > 0 ){
						arrElts.each(function( elt1 ){
							var elt1Consecutive=elt1.getParent().getParent().getStyle('top').toInt()*10000+elt1.getParent().getParent().getStyle('left').toInt();
							arrSortedElts.push(elt1Consecutive);
							elt1.getParent().getParent().set('data-consecutive',elt1Consecutive);
						});
						arrSortedElts.sort(function(a, b){return a-b});

						var top = 0, _arrNotIntersect=[], _zIndex = 0;
						arrSortedElts.each(function( eltDataConsecutive ){
							var _blockHeight = 0, _arrSortedElts=[], _top = 0;
							_zIndex += 1;
							var _idBlock = $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
							$$( '[data-return="z-index_m"][data-boxid="'+_idBlock+'"]' )[0].set('value', _zIndex);
							$$('.content_box:not([data-consecutive]').each(function(elm){
								if(object.getIntersect(elm, $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0])){
									if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
										elm.setStyle('width', '355px');
										var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
										elm.setStyle('height', b);
										_blockHeight += (b + 10);
										$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
										$$('[data-return="left_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
									} else {
										$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
										_blockHeight += (elm.getStyle('height').toInt() + 10);
									}
									
									var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
									_arrSortedElts.push(_elt1Consecutive);
									elm.set('data-consecutive1',_elt1Consecutive);
								}
							});

							_arrSortedElts.sort(function(a, b) { return a-b; });
							_arrSortedElts.each(function( _eltDataConsecutive ){
								_zIndex += 1;
								var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
								$$( '[data-return="top_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', top + _top);
								_top += ($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

								if($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 375) {
									$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 355);
									$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10);
								} else {
									$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
									$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', (375 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
								}
								$$('[data-return="z-index_m"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
							});
							
							$$( '[data-return="height_m"][data-boxid="'+_idBlock+'"]' )[0].set('value', _blockHeight);
							$$( '[data-return="top_m"][data-boxid="'+_idBlock+'"]' )[0].set('value', top);
							top += (_blockHeight + 10);
						});
						$$('.content_box:not([data-consecutive1],[data-consecutive])').each(function(elm){
							var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
							_arrNotIntersect.push(_elt1Consecutive);
							elm.set('data-consecutive1',_elt1Consecutive);
							if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
								elm.setStyle('width', '355px');
								var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
								elm.setStyle('height', b);
								$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
								$$('[data-return="left_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
							} else {
								$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
							}
						});
						_arrNotIntersect.sort(function(a, b){return a-b});
						_arrNotIntersect.each(function( eltDataConsecutive ){
							var idBlock = $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
							_zIndex += 1;
							$$( '[data-return="top_m"][data-boxid="'+idBlock+'"]' )[0].set('value', top);
							top += ($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

							if($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 375) {
								$$( '[data-return="width_m"][data-boxid="'+idBlock+'"]' )[0].set('value', 355);
								$$( '[data-return="left_m"][data-boxid="'+idBlock+'"]' )[0].set('value', 10);
							} else {
								$$( '[data-return="width_m"][data-boxid="'+idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt());
								$$( '[data-return="left_m"][data-boxid="'+idBlock+'"]' )[0].set('value', (375 - $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
							}
							$$('[data-return="z-index_m"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
						});
					} else {
						var _top = 0, _arrSortedElts=[], _zIndex=0;
						$$('.content_box').each(function(elm){
							if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
								elm.setStyle('width', '355px');
								var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
								elm.setStyle('height', b);
								$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
								$$('[data-return="left_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
							} else {
								$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
							}
							
							var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
							_arrSortedElts.push(_elt1Consecutive);
							elm.set('data-consecutive1',_elt1Consecutive);
						});

						_arrSortedElts.sort(function(a, b) { return a-b; });
						_arrSortedElts.each(function( _eltDataConsecutive ){
							_zIndex +=1;
							var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
							$$( '[data-return="top_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', _top);
							_top += ($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

							if($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 375) {
								$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 355);
								$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10) ;								
							} else {
								$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
								$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', (375 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
							}
							$$('[data-return="z-index_m"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
						});
					}
				}

				for(var i = 1; i <= object.cbCounter; i++)
					object.selectDevice(i);
			}


			if($(this).get('data-orientation') == 'true') {
				$$('.orientation').show();
			} else {
				$$('.orientation').hide();
			}
			jQuery('#emulator').customScroll('destroy').customScroll('init');
		});

		$$('.orientation a[data-orientation]').addEvent('click', function(){
			if(!$(this).hasClass('active')) {
				var width = $$('.emulator')[0].getStyle('width');
				var height = $$('.emulator')[0].getStyle('height');
				$$('.orientation a[data-orientation]').removeClass('active');
				$(this).addClass('active');
				$$('.emulator')[0].setStyles({width: height,  height: width, left: "calc(50% - " + (parseInt(height) / 2) + "px)", top: "calc(50% - " + (parseInt(width) / 2) + "px)"});
				$$('div.mobile-img')[0].setStyles({top : $$('div.mobile-img')[0].getStyle('left'), left: $$('div.mobile-img')[0].getStyle('top'), width : $$('div.mobile-img')[0].getStyle('height'), height : $$('div.mobile-img')[0].getStyle('width')});
				
				if($$('div.mobile-img')[0].getStyle('background-image') == "url(\"/skin/i/frontends/design/2.png\")" && $$('.orientation a.active[data-orientation]').get('data-orientation') != 'albumn') {
					$$('div.mobile-img')[0].setStyle('background-image', "url('/skin/i/frontends/design/1.png')");
				} else {
					$$('div.mobile-img')[0].setStyle('background-image', "url('/skin/i/frontends/design/2.png')");
				}
				if($(this).get('data-orientation') == 'albumn') {
					$$('.pc,.mobile,.tablet,.albumn').hide();
					$$('.albumn').show();
				} else {
					$$('.pc,.mobile,.tablet,.albumn').hide();
					$$('.mobile').show();
				}

				var _flag = false;
				$$('input[type="number"][data-return="top_a"]').each(function(elm){
					if(elm.get('value').toInt() != 0) {
						_flag = true;
					}
				});

				$$('.content_box').each(function( elm ){
					$($(elm).get('id')).removeAttribute('data-consecutive');
					$($(elm).get('id')).removeAttribute('data-consecutive1');
				});

				var arrElts=$$('.content_box input[data-return$=type][data-default$=block]');
				var arrSortedElts=[];
				if ( arrElts.length > 0 ){
					arrElts.each(function( elt1 ){
						var elt1Consecutive=elt1.getParent().getParent().getStyle('top').toInt()*10000+elt1.getParent().getParent().getStyle('left').toInt();
						arrSortedElts.push(elt1Consecutive);
						elt1.getParent().getParent().set('data-consecutive',elt1Consecutive);
					});
					arrSortedElts.sort(function(a, b){return a-b});
					var top = 0, _arrNotIntersect=[], _zIndex = 0;
					arrSortedElts.each(function( eltDataConsecutive ){
						var _blockHeight = 0, _arrSortedElts=[], _top = 0;
						_zIndex += 1;
						var _idBlock = $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
						$$( '[data-return="z-index_a"][data-boxid="'+_idBlock+'"]' )[0].set('value', _zIndex);
						$$('.content_box:not([data-consecutive]').each(function(elm){
							if(object.getIntersect(elm, $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0])){
								if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
									elm.setStyle('width', 647);
									var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
									elm.setStyle('height', b);
									_blockHeight += (b + 10);
									$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
									$$('[data-return="left_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
								} else {
									_blockHeight += (elm.getStyle('height').toInt() + 10);
								}
								var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
								_arrSortedElts.push(_elt1Consecutive);
								elm.set('data-consecutive1',_elt1Consecutive);
							}
						});

						_arrSortedElts.sort(function(a, b) { return a-b; });
						_arrSortedElts.each(function( _eltDataConsecutive ){
							var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
							_zIndex += 1;
							$$( '[data-return="top_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', top + _top);
							_top += $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt();

							if($$('[data-return="width"][data-boxid="'+__idBlock+'"]')[0].get('value') > 667) {
								$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 647);
								$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
								$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10) ;
							} else {
								$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
								$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
								$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', (667 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
							}
							$$('[data-return="z-index_a"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
						});
						var _idBlock = $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
						$$( '[data-return="height_a"][data-boxid="'+_idBlock+'"]' )[0].set('value', _blockHeight);
						$$( '[data-return="top_a"][data-boxid="'+_idBlock+'"]' )[0].set('value', top);
						top += (_blockHeight + 10);
					});
					$$('.content_box:not([data-consecutive1],[data-consecutive])').each(function(elm){
						var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
						_arrNotIntersect.push(_elt1Consecutive);
						elm.set('data-consecutive1',_elt1Consecutive);
						if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
							elm.setStyle('width', 647);
							var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
							elm.setStyle('height', b);
							$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
							$$('[data-return="left_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
						}
					});
					_arrNotIntersect.sort(function(a, b){return a-b});
					_arrNotIntersect.each(function( eltDataConsecutive ){
						var idBlock = $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
						_zIndex += 1;
						$$( '[data-return="top_a"][data-boxid="'+idBlock+'"]' )[0].set('value', top);
						top += ($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);
						$$( '[data-return="height_a"][data-boxid="'+idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('height').toInt());

						if($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 667) {
							$$( '[data-return="width_a"][data-boxid="'+idBlock+'"]' )[0].set('value', 647);
							$$( '[data-return="left_a"][data-boxid="'+idBlock+'"]' )[0].set('value', 10);
						} else {
							$$( '[data-return="width_a"][data-boxid="'+idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt());
							$$( '[data-return="left_a"][data-boxid="'+idBlock+'"]' )[0].set('value', (667 - $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
						}
						$$('[data-return="z-index_a"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
					});
				} else {
					var _top = 0, _arrSortedElts=[], _zIndex=0;
					$$('.content_box').each(function(elm){
						if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
							elm.setStyle('width', '647px');
							var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
							elm.setStyle('height', b);
							$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
							$$('[data-return="left_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
						} else {
							$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
						}
						
						var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
						_arrSortedElts.push(_elt1Consecutive);
						elm.set('data-consecutive1',_elt1Consecutive);
					});

					_arrSortedElts.sort(function(a, b) { return a-b; });
					_arrSortedElts.each(function( _eltDataConsecutive ){
						_zIndex += 1;
						var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
						$$( '[data-return="top_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', _top);
						_top += ($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

						if($$('[data-return="width"][data-boxid="'+__idBlock+'"]')[0].get('value') > 667) {
							$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 647);
							$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
							$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10);
						} else {
							$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
							$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', (667 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
							$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
						}
						$$('[data-return="z-index_a"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
					});

				}

				for(var i = 1; i <= object.cbCounter; i++)
					object.selectDevice(i);
			}
		});
		{/literal}{/if}{literal}
		
		window.addEvent('resize', function(){
			object.resizeScreen(object.cbCounter);
		});

		{/literal}{if isset($smarty.get.local_data)}{literal}
		CKEDITOR.on( 'instanceCreated', function ( event ) {
			event.editor.on( 'change', function( evt ) {
				var boxid = $(evt.editor.element.$).getNext('.options_block').getElement('[data-return="boxid"]').get('data-default');
				$$('textarea[name="arrSettings['+boxid+'][html]"]').set('value', evt.editor.getData());
			});
		});
		{/literal}{/if}{literal}
	}, 
	selectDevice : function(boxid){
		var suffix = '';
		if($$('a[data-type].active')[0].get('data-type') == 'mobile') suffix = '_m';
		if($$('a[data-type].active')[0].get('data-type') == 'mobile' && $$('.orientation a[data-orientation].active')[0].get('data-orientation') == 'albumn') suffix = '_a';
		if($$('a[data-type].active')[0].get('data-type') == 'tablet') suffix = '_t';
		if(boxid && $( 'content_box_'+boxid ) != undefined) {
			$( 'content_box_'+boxid ).setStyle('left', (parseInt($$( '[data-return="left'+suffix+'"][data-boxid="'+boxid+'"]' )[0].get('value'))) + 'px');
			$( 'content_box_'+boxid ).setStyle('top', (parseInt($$( '[data-return="top'+suffix+'"][data-boxid="'+boxid+'"]' )[0].get('value'))) + 'px');
			$( 'content_box_'+boxid ).setStyle('width', $$( '[data-return="width'+suffix+'"][data-boxid="'+boxid+'"]' )[0].get('value') + 'px');
			$( 'content_box_'+boxid ).setStyle('height', $$( '[data-return="height'+suffix+'"][data-boxid="'+boxid+'"]' )[0].get('value') + 'px');

			if($$('a[data-type].active')[0].get('data-type') != 'pc') {
				if($$( '[data-return="hide'+suffix+'"][data-boxid="'+boxid+'"]' )[0].getProperty('checked')){
					$( 'content_box_'+boxid ).setStyle('display', 'none');
				} else {
					$( 'content_box_'+boxid ).setStyle('display', 'block');
				}
			} else {
				$( 'content_box_'+boxid ).setStyle('display', 'block');
			}
		}
	},
	setMobileVersion : function(){
		var _flag = false;
		$$('input[type="number"][data-return="top_m"]').each(function(elm){
			if(elm.get('value').toInt() != 0) {
				_flag = true;
			}
		});
		$$('input[type="number"][data-return="top_a"]').each(function(elm){
			if(elm.get('value').toInt() != 0) {
				_flag = true;
			}
		});
		if(_flag) return;

		var object = this;
		var arrElts=$$('.content_box input[data-return$=type][data-default$=block]');
		var arrSortedElts=[];
		if ( arrElts.length > 0 ){
			arrElts.each(function( elt1 ){
				var elt1Consecutive=elt1.getParent().getParent().getStyle('top').toInt()*10000+elt1.getParent().getParent().getStyle('left').toInt();
				arrSortedElts.push(elt1Consecutive);
				elt1.getParent().getParent().set('data-consecutive',elt1Consecutive);
			});
			arrSortedElts.sort(function(a, b){return a-b});
			var top = 0, _arrNotIntersect=[], _zIndex=0;
			arrSortedElts.each(function( eltDataConsecutive ){
				var _blockHeight = 0, _arrSortedElts=[], _top = 0;
				_zIndex += 1;
				var _idBlock = $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
				$$( '[data-return="z-index_m"][data-boxid="'+_idBlock+'"]' )[0].set('value', _zIndex);
				$$('.content_box:not([data-consecutive]').each(function(elm){
					if(object.getIntersect(elm, $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0])){
						if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
							elm.setStyle('width', '355px');
							var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
							elm.setStyle('height', b);
							_blockHeight += (b + 10);
							$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
							$$('[data-return="left_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
						} else {
							$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
							_blockHeight += (elm.getStyle('height').toInt() + 10);
						}
						
						var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
						_arrSortedElts.push(_elt1Consecutive);
						elm.set('data-consecutive1',_elt1Consecutive);
					}
				});

				_arrSortedElts.sort(function(a, b) { return a-b; });
				_arrSortedElts.each(function( _eltDataConsecutive ){
					var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
					_zIndex +=1;
					$$( '[data-return="top_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', top + _top);
					_top += ($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

					if($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 375) {
						$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 375);
					} else {
						$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
						$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', (375 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
					}
					$$('[data-return="z-index_m"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);

				});
				$$( '[data-return="height_m"][data-boxid="'+_idBlock+'"]' )[0].set('value', _blockHeight);
				$$( '[data-return="top_m"][data-boxid="'+_idBlock+'"]' )[0].set('value', top);
				top += (_blockHeight + 10);
			});
			$$('.content_box:not([data-consecutive1],[data-consecutive])').each(function(elm){
				var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
				_arrNotIntersect.push(_elt1Consecutive);
				elm.set('data-consecutive1',_elt1Consecutive);
				if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
					elm.setStyle('width', '355px');
					var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
					elm.setStyle('height', b);
					$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
					$$('[data-return="left_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
				} else {
					$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
				}
			});
			_arrNotIntersect.sort(function(a, b){return a-b});
			_arrNotIntersect.each(function( eltDataConsecutive ){
				var idBlock = $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
				_zIndex +=1;
				$$( '[data-return="top_m"][data-boxid="'+idBlock+'"]' )[0].set('value', top);
				top += ($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

				if($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 375) {
					$$( '[data-return="width_m"][data-boxid="'+idBlock+'"]' )[0].set('value', 355);
					$$( '[data-return="left_m"][data-boxid="'+idBlock+'"]' )[0].set('value', 10);
				} else {
					$$( '[data-return="width_m"][data-boxid="'+idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt());
					$$( '[data-return="left_m"][data-boxid="'+idBlock+'"]' )[0].set('value', (375 - $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
				}
				$$('[data-return="z-index_m"][data-boxid="'+idBlock+'"]').set('value', _zIndex);	
			});

			/* Tablet version */
			$$('.content_box').each(function( elm ){
				$($(elm).get('id')).removeAttribute('data-consecutive');
				$($(elm).get('id')).removeAttribute('data-consecutive1');
			});

			top = 0, _arrNotIntersect=[], _zIndex=0;
			arrSortedElts.each(function( eltDataConsecutive ){
				var _blockHeight = 0, _arrSortedElts=[], _top = 0;
				var _idBlock = $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
				_zIndex += 1;
				$$( '[data-return="z-index_a"][data-boxid="'+_idBlock+'"]' )[0].set('value', _zIndex);
				$$('.content_box:not([data-consecutive]').each(function(elm){
					if(object.getIntersect(elm, $$('.content_box[data-consecutive="'+eltDataConsecutive+'"]')[0])){
						if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
							elm.setStyle('width', 647);
							var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
							elm.setStyle('height', b);
							_blockHeight += (b + 10);
							$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
							$$('[data-return="left_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
						} else {
							_blockHeight += (elm.getStyle('height').toInt() + 10);
						}
						var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
						_arrSortedElts.push(_elt1Consecutive);
						elm.set('data-consecutive1',_elt1Consecutive);
					}
				});

				_arrSortedElts.sort(function(a, b) { return a-b; });
				_arrSortedElts.each(function( _eltDataConsecutive ){
					var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
					_zIndex += 1;
					$$( '[data-return="top_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', top + _top);
					_top += $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt();

					if($$('[data-return="width"][data-boxid="'+__idBlock+'"]')[0].get('value') > 667) {
						$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 647);
						$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
						$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10) ;
					} else {
						$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
						$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
						$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', (667 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
					}
					$$('[data-return="z-index_a"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
				});
				$$( '[data-return="height_a"][data-boxid="'+_idBlock+'"]' )[0].set('value', _blockHeight);
				$$( '[data-return="top_a"][data-boxid="'+_idBlock+'"]' )[0].set('value', top);
				top += (_blockHeight + 10);
			});
			$$('.content_box:not([data-consecutive1],[data-consecutive])').each(function(elm){
				var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
				_arrNotIntersect.push(_elt1Consecutive);
				elm.set('data-consecutive1',_elt1Consecutive);
				if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
					elm.setStyle('width', 647);
					var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
					elm.setStyle('height', b);
					$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
					$$('[data-return="left_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
				}
			});
			_arrNotIntersect.sort(function(a, b){return a-b});
			_arrNotIntersect.each(function( eltDataConsecutive ){
				var idBlock = $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
				_zIndex +=1;
				$$( '[data-return="top_a"][data-boxid="'+idBlock+'"]' )[0].set('value', top);
				top += ($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

				if($$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 667) {
					$$( '[data-return="width_a"][data-boxid="'+idBlock+'"]' )[0].set('value', 647);
					$$( '[data-return="left_a"][data-boxid="'+idBlock+'"]' )[0].set('value', 10);
				} else {
					$$( '[data-return="width_a"][data-boxid="'+idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt());
					$$( '[data-return="left_a"][data-boxid="'+idBlock+'"]' )[0].set('value', (667 - $$('.content_box[data-consecutive1="'+eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
				}
				$$('[data-return="z-index_a"][data-boxid="'+idBlock+'"]').set('value', _zIndex);
			});
		} else {
			var _top = 0, _arrSortedElts=[], _zIndex=0;

			$$('.content_box').each(function(elm){
				if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
					elm.setStyle('width', '355px');
					var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
					elm.setStyle('height', b);
					$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
					$$('[data-return="left_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
				} else {
					$$('[data-return="height_m"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
				}
				
				var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
				_arrSortedElts.push(_elt1Consecutive);
				elm.set('data-consecutive1',_elt1Consecutive);
			});

			_arrSortedElts.sort(function(a, b) { return a-b; });
			_arrSortedElts.each(function( _eltDataConsecutive ){
				_zIndex +=1;
				var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');
				$$( '[data-return="top_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', _top);
				_top += ($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

				if($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt() > 375) {
					$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 355);
					$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10) ;								
				} else {
					$$( '[data-return="width_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
					$$( '[data-return="left_m"][data-boxid="'+__idBlock+'"]' )[0].set('value', (375 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
				}
				$$('[data-return="z-index_m"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
			});

			_top = 0; _arrSortedElts=[], _zIndex = 0;
			$$('.content_box').each(function(elm){
				if(elm.getElement('div.content') !== null && elm.getElement('[data-return="type"]').get('data-default') != 'video') {
					elm.setStyle('width', '647px');
					var b = elm.getElement('div.content').setStyle('height', 'auto').getBoundingClientRect().height;
					elm.setStyle('height', b);
					$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', b);
					$$('[data-return="left_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', 10);
				} else {
					$$('[data-return="height_a"][data-boxid="'+elm.get('id').replace('content_box_', '')+'"]').set('value', elm.getStyle('height').toInt());
				}
				
				var _elt1Consecutive = elm.getStyle('top').toInt()*10000+elm.getStyle('left').toInt();
				_arrSortedElts.push(_elt1Consecutive);
				elm.set('data-consecutive1',_elt1Consecutive);
			});

			_arrSortedElts.sort(function(a, b) { return a-b; });
			_arrSortedElts.each(function( _eltDataConsecutive ){
				_zIndex += 1;
				var __idBlock = $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].get('id').replace('content_box_', '');

				$$( '[data-return="top_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', _top);
				_top += ($$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('height').toInt() + 10);

				if($$('[data-return="width"][data-boxid="'+__idBlock+'"]')[0].get('value') > 667) {
					$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 647);
					$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
					$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', 10);
				} else {
					$$( '[data-return="width_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt());
					$$( '[data-return="height_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', $$('[data-return="height"][data-boxid="'+__idBlock+'"]')[0].get('value'));
					$$( '[data-return="left_a"][data-boxid="'+__idBlock+'"]' )[0].set('value', (667 - $$('.content_box[data-consecutive1="'+_eltDataConsecutive+'"]')[0].getStyle('width').toInt()) / 2) ;
				}
				$$('[data-return="z-index_a"][data-boxid="'+__idBlock+'"]').set('value', _zIndex);
			});
		}
	},
	getIntersect : function(elm, elm1){
		var a = { x : elm.getStyle('left').toInt(), x1 : elm.getStyle('left').toInt() + elm.getStyle('width').toInt(), y : elm.getStyle('top').toInt(), y1 : elm.getStyle('top').toInt() + elm.getStyle('height').toInt() },
			b = { x : elm1.getStyle('left').toInt(), x1 : elm1.getStyle('left').toInt() + elm1.getStyle('width').toInt(), 
				  y : elm1.getStyle('top').toInt(), y1 : elm1.getStyle('top').toInt() + elm1.getStyle('height').toInt() };
		return(
			(
				(
					( a.x>=b.x && a.x<=b.x1 )||( a.x1>=b.x && a.x1<=b.x1  )
				) && (
					( a.y>=b.y && a.y<=b.y1 )||( a.y1>=b.y && a.y1<=b.y1 )
				)
			)||(
				(
					( b.x>=a.x && b.x<=a.x1 )||( b.x1>=a.x && b.x1<=a.x1  )
				) && (
					( b.y>=a.y && b.y<=a.y1 )||( b.y1>=a.y && b.y1<=a.y1 )
				)
			)
			)||(
			(
				(
					( a.x>=b.x && a.x<=b.x1 )||( a.x1>=b.x && a.x1<=b.x1  )
				) && (
					( b.y>=a.y && b.y<=a.y1 )||( b.y1>=a.y && b.y1<=a.y1 )
				)
			)||(
				(
					( b.x>=a.x && b.x<=a.x1 )||( b.x1>=a.x && b.x1<=a.x1  )
				) && (
					( a.y>=b.y && a.y<=b.y1 )||( a.y1>=b.y && a.y1<=b.y1 )
				)
			)
		);
	},
	resizeScreen : function(boxid) {
		if(window.getSize().x >= 800 && $$('.emulator')[0] == undefined) return;
		for (var i = 1; i <= boxid; i++) {
			$$( '#content_box_'+i+' .options_block .setting_def_elt' ).each( function( dataElement ){
				var elementTarget=$$( '#content_box_'+i )[0];
				var dataTail='[data]';
				var eltValue=dataElement.get( 'data-default' );
				if( dataElement.get( 'data-tail' ) ){
					dataTail=dataElement.get( 'data-tail' );
				}
				
				if($$('.emulator')[0] !== undefined){
					var suffix = '';
					if($$('a[data-type].active')[0].get('data-type') == 'mobile') suffix = '_m';
					if($$('a[data-type].active')[0].get('data-type') == 'mobile' && $$('.orientation a[data-orientation].active')[0].get('data-orientation') == 'albumn') suffix = '_a';
			
					if(i) {
						$( 'content_box_'+i ).setStyle('left', (parseInt($$( '[data-return="left'+suffix+'"][data-boxid="'+i+'"]' )[0].get('value'))) + 'px');
						$( 'content_box_'+i ).setStyle('top', (parseInt($$( '[data-return="top'+suffix+'"][data-boxid="'+i+'"]' )[0].get('value'))) + 'px');
						$( 'content_box_'+i ).setStyle('width', $$( '[data-return="width'+suffix+'"][data-boxid="'+i+'"]' )[0].get('value') + 'px');
						$( 'content_box_'+i ).setStyle('height', $$('[data-return="height'+suffix+'"][data-boxid="'+i+'"]' )[0].get('value') + 'px');
					}
				} else {
					//elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', eltValue ) );
					if(window.getSize().x <= 400) {
						if(dataElement.get('data-return') == 'width_m') {
							elementTarget.setStyle('width', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'height_m') {
							elementTarget.setStyle('height', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'left_m') {
							elementTarget.setStyle('left', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'top_m') {
							elementTarget.setStyle('top', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'hide_m'){
							if(eltValue == '1') {
								elementTarget.hide();
							}  else {
								elementTarget.show();
							}
						}
					} else if(window.getSize().x <= 800) {
						if(dataElement.get('data-return') == 'width_a') {
							elementTarget.setStyle('width', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'height_a') { 
							elementTarget.setStyle('height', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'left_a') {
							elementTarget.setStyle('left', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'top_a') {
							elementTarget.setStyle('top', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'hide_a'){
							if(eltValue == '1') {
								elementTarget.hide();
							}  else {
								elementTarget.show();
							}
						}
					}
					
				}
			});
		}
	},

	selectSettings: function( evtTarget, boxid ){
		var object=this;
		if( evtTarget.get( 'data-target' ) == 'text' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'html':{
					'name': 'Content Text',
					'type': 'text_box',
					'openoncreate':'true',
					'returntype':'attr',
					'elementclass': 'content',
					'default': object.encode( '<h2><span style="color:#000000;">edit this text</span></h2>' )
				}
			});
		}
		if( evtTarget.get( 'data-target' ) == 'form' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'html':{
					'name':'HTML',
					'type':'textarea',
					'openoncreate':'true',
					'returntype':'attr',
					'elementclass':'content',
					'default':object.encode( '<form action="//test.local?" method="post" id="form-cb-' + boxid + '" accept-charset="UTF-8"><input name="email" type="text" placeholder="E-mail" /><label></label><input type="submit" name="submit" value="Submit" /></form>' )
				},
				'form_name':{ // уникальное имя формы, для обращения через внешние кнопки
					'name': 'Form Name',
					'type': 'text',
					'useinonaction':'true',
				},
				/*'style' : {
					'name':'style',
					'elementclass':'content',
					'default':object.encode( '<style></style>' ),
					'type':'style'
				},*/
				'style' : {
					'name':'Style',
				    'type':'style',
				    'default':'',
				    'returntype':'attr',
				    'elementclass':'style',
				    'elementclasstype':'style',
				}
			});
		}
		if( evtTarget.get( 'data-target' ) == 'form_formated' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'html':{
					'name':'HTML',
					'type':'form_formater',
					'openoncreate':'true',
					'returntype':'attr',
					'elementclass':'content',
					'default':object.encode( '<form action="//test.local?" method="post" id="form-cb-' + boxid + '" accept-charset="UTF-8"><input name="email" type="text" placeholder="E-mail" /><label></label><input name="name" type="text" placeholder="Name" /><label></label><input type="submit" name="submit" value="Submit" /></form>' ),
			//		'runparser': '{/literal}{url name="site1_contentbox" action="create"}{literal}'
				},
				'form_name':{ // уникальное имя формы, для обращения через внешние кнопки
					'name': 'Form Name',
					'type': 'text',
					'useinonaction':'true',
				},
				'style' : {
					'name':'Style',
				    'type':'style',
				    'default':'',
				    'returntype':'attr',
				    'elementclass':'style',
				    'elementclasstype':'style',
				}
			});
		}
		if( evtTarget.get( 'data-target' ) == 'lead_channels') {
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'html':{
					'name':'HTML',
					'type':'lead_channels',
					'openoncreate':'true',
					'returntype':'attr',
					'elementclass':'content',
					'default':'',
				},
				'style' : {
					'name':'Style',
				    'type':'style',
				    'default':'',
				    'returntype':'attr',
				    'elementclass':'style',
				    'elementclasstype':'style',
				},
				'button_text':{
					'name' : 'Button Text',
					'type' : 'text',
					'default' : 'Submit'
				}
			});
		}
		if( evtTarget.get( 'data-target' ) == 'block' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'opacity':{
					'name':'Block Transparent',
					'type':'scroll',
					'steps':100,  // колличество шагов
					'stepStart':0,  // минимальное значение
					'stepEnd':100,  // максимальное значение
					'default':100, // исходное значение
					'dev':100, // конечное значение делится на это значение перед выводом
					'elementclass':'background', // к какому элементу будут применены свойства
					'elementclasstype':'div', // к какому элементу будут применены свойства, его тип
					'container' : 'messages'
				},
				'background-color':{
					'name':'Block Color',
					'type':'color',
					'default':'#e8e8e8',
					'elementclass':'background',
					'elementclasstype':'div',
					'container' : 'messages'
				},
				'border-style':{
					'name':'Border Style',
					'type':'select',
					'default':'solid',
					'options':'none|dotted|dashed|solid|double|groove|ridge|inset|outset',
					'elementclass':'background',
					'elementclasstype':'div',
					'container' : 'messages'
				},
				'border-width':{
					'name':'Border Size',
					'type':'number',
					'tail':'[data]px',
					'min':0,
					'default':0,
					'elementclass':'background',
					'elementclasstype':'div',
					'container' : 'messages'
				},
				'border-color':{
					'name':'Border Color',
					'type':'color',
					'default':'#a3a3a3',
					'elementclass':'background',
					'elementclasstype':'div',
					'container' : 'messages'
				},
				'border-radius':{
					'name':'Border Radius',
					'type':'number',
					'tail':'[data]px',
					'min':0,
					'default':8,
					'elementclass':'background',
					'elementclasstype':'div',
					'container' : 'messages'
				}
			});
		}
		//----------------BUTTONS
		var buttonDefaultSettings={
				'font-size' : {

					'name':'Font size',
					'type':'number',
					'tail':'[data]px',
					'min':1,
					'default':26,
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				'html': {
				     'name': 'Button Text',
				     'type': 'text',
				     'showonload':'true',
				     'default': 'Button',
				     'returntype':'attr',
				     'elementclass': 'action',
				     'elementclasstype': 'a',
				    },
				'color' : {
					'name' : 'Color text',
					'type':'color',
					'default':'#a3a3a3',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				'text-align' : {
					'name':'Text align',
					'type':'select',
					'default':'center',
					'options':'center|left|right|justify',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				'opacity':{
					'name':'Block Transparent',
					'type':'scroll',
					'steps':100,  // колличество шагов
					'stepStart':0,  // минимальное значение
					'stepEnd':100,  // максимальное значение
					'default':100, // исходное значение
					'dev':100, // конечное значение делится на это значение перед выводом
					'elementclass':'action', // к какому элементу будут применены свойства
					'elementclasstype':'a', // к какому элементу будут применены свойства, его тип
					'container' : 'messages'
				},
				
				'background-image':{
					'name':'Background Image',
					'type':'file_image',
					'imagetype':'button',
					'default':'',
					'tail':'url([data])',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				
				'background-repeat':{
					'name':'Background Repeat Image',
					'type':'select',
					'default':'no-repeat',
					'options':'no-repeat|repeat|repeat-x|repeat-y',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				
				'background-origin':{
					'name':'Background Positioning Area',
					'type':'select',
					'default':'padding-box',
					'options':'padding-box:The position is relative to the padding box.|border-box:The position is relative to the border box.|content-box:The position is relative to the content box.',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				
				'background-size':{
					'name':'Background Image Size',
					'type':'select',
					'default':'cover',
					'options':'auto|cover|contain',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				
				'background-color':{
					'name':'Background Color',
					'type':'color',
					'default':'#e8e8e8',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				
				'border-style':{
					'name':'Border Style',
					'type':'select',
					'default':'solid',
					'options':'none|dotted|dashed|solid|double|groove|ridge|inset|outset',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				'border-width':{
					'name':'Border Size',
					'type':'number',
					'tail':'[data]px',
					'min':0,
					'default':1,
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				'border-color':{
					'name':'Border Color',
					'type':'color',
					'default':'#a3a3a3',
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				'border-radius':{
					'name':'Border Radius',
					'type':'number',
					'tail':'[data]px',
					'min':0,
					'default':50,
					'elementclass':'action',
					'elementclasstype':'a',
					'container' : 'messages'
				},
				
				/*'html':{
					'name': 'Content Text',
					'type': 'text_box',
					'showonload':'true',
					'default': object.encode( '<div style="display:table;text-align:center;height:100%;width:100%;margin:0px;"><span style="color:#0000CD;display:table-cell;vertical-align:middle;text-decoration:none;font-size:26px;font-weight:bold">Button</span></div>' ),
					'returntype':'attr',
					'elementclass': 'action',
					'elementclasstype': 'a',
				},*/
				
				'height':{
					'default':60,
				},
				
				'width':{
					'default':100,
				},
				
				'padding':{
					'name':'Padding',
					'type':'number',
					'tail':'[data]px',
					'default':10,
					'elementclass':'action',
					'elementclasstype':'a'
				},
				
				'button_action':{
					'name':'On Click Action',
					'type':'select',
					'default':'url',
					'event':'action',
					'options':'url:Open Url:action_url|call:Click-To-Call:action_call|form:Show Form:action_form|submit:Submit Form:action_submit',
					'elementclass':'action',
					'elementclasstype':'a',
					'actions':{
						'url':{
							'href':{
								'name':'Url',
								'type':'text',
								'default':'#',
								'returntype':'attr',
								'elementclass':'action',
								'elementclasstype':'a',
							}
						},
						'call':{
							'href':{
								'name':'Phone',
								'type':'text',
								'default':'tel:855-895-5555',
								'returntype':'attr',
								'elementclass':'action',
								'elementclasstype':'a',
							}
						},
						'form':{
							'href':{
								'name':'Form Name',
								'type':'select',
								'onaction':'form_name',
								'tail':'#[data]',
								'returntype':'attr',
								'elementclass':'action',
								'elementclasstype':'a',
							}
						},
						'submit':{
							'href':{
								'name':'Form Name',
								'type':'select',
								'onaction':'form_name',
								'tail':'#[data]',
								'returntype':'attr',
								'elementclass':'action',
								'elementclasstype':'a',
							}
						}
					}
				}
		}
		
		if( evtTarget.get( 'data-target' ) == 'button' ){
			object.addNewBox( evtTarget.get( 'data-target' ), object.mergeOptions( buttonDefaultSettings,{
					'html':{
						'openoncreate':'true',
					}
				} ) 
			);
		}
		if( evtTarget.get( 'data-target' ) == 'button_select' ){
			object.addNewBox( evtTarget.get( 'data-target' ), object.mergeOptions( buttonDefaultSettings,{
				'html':{
					'default':'',
					'showonload':'false',
				},
				'padding':{
					'default':0,
				},
				'border-radius':{
					'default':0,
				},
				'border-width':{
					'default':0,
				},
				'background-color':{
					'default':'rgba(0,0,0,0)',
				},
				'background-image':{
					'openoncreate':'true',
				},
				
			} ) );
		}
		if( evtTarget.get( 'data-target' ) == 'button_upload' ){
			object.addNewBox( evtTarget.get( 'data-target' ), object.mergeOptions( buttonDefaultSettings,{
				'html':{
					'default':'',
					'showonload':'false',
				},
				'padding':{
					'default':0,
				},
				'border-radius':{
					'default':0,
				},
				'border-width':{
					'default':0,
				},
				'background-color':{
					'default':'rgba(0,0,0,0)',
				},
				'background-image':{
					'openoncreate':'true',
				},
			} ) );
		}// add button settings
		//--------------------------------------------
		if( evtTarget.get( 'data-target' ) == 'image' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'src':{
					'name':'Image',
					'type':'file_image',
					'openoncreate':'true',
					'default':'',
					'returntype':'attr',
					'elementclass':'background',
					'elementclasstype':'img',
				},
				'button_action':{
					'name':'On Click Action',
					'type':'select',
					'default':'url',
					'event':'action',
					'options':'url:Open Url:action_url',
					'elementclass':'action',
					'elementclasstype':'a',
					'actions':{
						'url':{
							'href':{
								'name':'Url',
								'type':'text',
								'default':'#',
								'returntype':'attr',
								'elementclass':'action',
								'elementclasstype':'a',
							}
						}
					}
				}
			});
		}
		if( evtTarget.get( 'data-target' ) == 'video' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'html':{
					'name': 'Video Link',
					'type': 'video_embed',
					'openoncreate':'true',
					'default': object.encode( 'Insert Video Code Here' ),
					'returntype':'attr',
					'elementclass':'content',
				}
			});
		}
		if( evtTarget.get( 'data-target' ) == 'html' ){
			object.addNewBox( evtTarget.get( 'data-target' ), {
				'html':{
					'name': 'HTML',
					'type': 'text_box',
					'openoncreate':'true',
					'default': object.encode( 'Add HTML code HERE' ),
					'returntype':'attr',
					'elementclass':'content',
				}
			});
		}
	}, 
	
	dTop : window.innerHeight,
	dLeft : window.innerWidth,
	
	addNewBox: function( dataTarget, options ){
		var object=this;
		//object.cbCounter = object.settingsDefault.boxid == undefined ? object.cbCounter : object.settingsDefault.boxid;
		//object.cbCounter+=1;
		var strOptions='';
		var strOptionsActions='';

		var emulator = $$('.emulator')[0];
		var defaultLeft = emulator==undefined || emulator.getBoundingClientRect().left === 0 ? 600 : 0;
		var defaultTop = emulator==undefined || emulator.getBoundingClientRect().top === 0 ? 100 : 0;
		

		
		var mergedOptions=object.mergeOptions( {
			'boxid':{
				'name': 'Boxid',
				'type': 'hidden',
				'default' : object.cbCounter
			},
			'type':{
				'name': 'Option Type',
				'type': 'hidden',
				'default':dataTarget,
			},
			'left':{
				'name': 'Position Left',
				'type': 'number',
				'tail':'[data]px',
				'default':defaultLeft,
				'class' : 'pc'
			},

			'top':{
				'name': 'Position Top',
				'type': 'number',
				'tail':'[data]px',
				'default':defaultTop,
				'class' : 'pc' 
			},
			'width':{
				'name': 'Width',
				'type': 'number',
				'tail':'[data]px',
				'default':300,
				'class' : 'pc'
			},
			'height':{
				'name': 'Height',
				'type': 'number',
				'tail':'[data]px',
				'default':100,
				'class' : 'pc'
			},
			'top_a':{
				'name' : 'Position Top',
				'type' : 'number',
				'tail' : '[data]px',
				'default' : 0,
				'class' : 'albumn'
			},
			'left_a':{
				'name': 'Position Left',
				'type': 'number',
				'tail':'[data]px',
				'default':0,
				'class' : 'albumn'
			},
			'width_a':{
				'name': 'Width',
				'type': 'number',
				'tail':'[data]px',
				'default':667,
				'class' : 'albumn'
			},
			'height_a':{
				'name': 'Height',
				'type': 'number',
				'tail':'[data]px',
				'default':100,
				'class' : 'albumn'
			},
			'top_t':{
				'name' : 'Position Top',
				'type' : 'number',
				'tail' : '[data]px',
				'default' : 0,
				'class' : 'tablet'
			},
			'left_t':{
				'name': 'Position Left',
				'type': 'number',
				'tail':'[data]px',
				'default':0,
				'class' : 'tablet'
			},
			'width_t':{
				'name': 'Width',
				'type': 'number',
				'tail':'[data]px',
				'default':667,
				'class' : 'tablet'
			},
			'height_t':{
				'name': 'Height',
				'type': 'number',
				'tail':'[data]px',
				'default':100,
				'class' : 'tablet'
			},
			'top_m':{
				'name' : 'Position Top',
				'type' : 'number',
				'tail' : '[data]px',
				'default' : 0,
				'class' : 'mobile'
			},
			'left_m':{
				'name': 'Position Left',
				'type': 'number',
				'tail':'[data]px',
				'default':0,
				'class' : 'mobile'
			},
			'width_m':{
				'name': 'Width',
				'type': 'number',
				'tail':'[data]px',
				'default':375,
				'class' : 'mobile'
			},
			'height_m':{
				'name': 'Height',
				'type': 'number',
				'tail':'[data]px',
				'default':100,
				'class' : 'mobile'
			},
			'hide_a' : {
				'name' : 'Hide',
				'type' : 'checkbox',
				'tail' : '[data]',
				'default' : 0,
				'class' : 'albumn'
			},
			'hide_m' : {
				'name' : 'Hide',
				'type' : 'checkbox',
				'tail' : '[data]',
				'default' : 0,
				'class' : 'mobile'
			},
			'z-index':{
				'name': 'Disposition',
				'type': 'number',
				'min': 0,
				'class' : 'pc'
			},
			'z-index_m':{
				'name' : 'Disposition',
				'type' : 'number',
				'min' : 0,
				'class' : 'mobile',
			},
			'z-index_a':{
				'name' : 'Disposition',
				'type' : 'number',
				'min' : 0,
				'class' : 'albumn',
			}
		}, options );
		if( object.dTop != window.innerHeight && object.dLeft != window.innerWidth ){
			for( var key in mergedOptions ){
				flgUpdateBlockPosition=false;updateValue=0;
				if( 'left' == key ){
					flgUpdateBlockPosition=true;
					updateValue=window.innerWidth;
					dUpdate=object.dLeft;
				}
				if( 'top' == key ){
					flgUpdateBlockPosition=true;
					updateValue=window.innerHeight;
					dUpdate=object.dTop;
				}
				if( flgUpdateBlockPosition && mergedOptions[key]['update_position'] == undefined ){
					mergedOptions[key]['update_position'] = true;
					object.settingsDefault[key]=updateValue*blockPosition[key]/100-parseInt(dUpdate)+parseInt(object.settingsDefault[key]);
				}
			}
		}
		for( var key in mergedOptions ){
			var values=mergedOptions[key];
			strOptions=strOptions+'<'+'input type="hidden" class="setting_def_elt" data-return="'+key+'"';
			strOptionsActions='';
			for( var data_name in values ){
				if( 'actions' == data_name ){
					// если к значению настройки привязано отображение другие настройки
					for( var actionname in values[data_name] ){
						for( var optionreturn in values[data_name][actionname] ){
							// теперь добавляем связанные настройки 
							strOptionsActions=strOptionsActions+'<'+'input type="hidden" class="setting_def_elt" data-optionclass="'+actionname+'" data-return="'+optionreturn+'" data-optionparent="'+key+'"';
							for( var data_actions_name in values[data_name][actionname][optionreturn] ){
								// тут дефолтными присваиваем если есть в settingsDefault
								if( data_actions_name == 'default' 
									&& typeof object.settingsDefault[key] != 'undefined' 
									&& object.settingsDefault[key]==actionname 
									&& typeof object.settingsDefault[actionname] != 'undefined'
									&& typeof object.settingsDefault[actionname][optionreturn] != 'undefined'
								){
									strOptionsActions=strOptionsActions+' data-'+data_actions_name+'="'+object.settingsDefault[actionname][optionreturn]+'"';
								}else{
									strOptionsActions=strOptionsActions+' data-'+data_actions_name+'="'+values[data_name][actionname][optionreturn][data_actions_name]+'"';
								}
								
							}
							strOptionsActions=strOptionsActions+' /'+'>'
						}
					}
				}else{
					// если значение настройки не влияет на отображение других настройки
					if( data_name == 'default' 
						&&  key!='html'
						&& typeof object.settingsDefault[key] != 'undefined'
					){
						strOptions=strOptions+' data-'+data_name+'="'+object.settingsDefault[key]+'"';
					}else{
						strOptions=strOptions+' data-'+data_name+'="'+values[data_name]+'"';
					}
				}
			}
			strOptions=strOptions+' /'+'>'+strOptionsActions;
		}
		var adoptToElt=document.body;
		var iconMove = null;
		if( $$('.emulator')[0] != undefined )
			adoptToElt=$$('.emulator')[0];

		if( dataTarget == 'text' ) {
			iconMove = '<div class="move-icon"><i class="ti-move"></i></div>';
		}
		adoptToElt.adopt(
			new Element( 'div', {
					'class':'content_box',
					'id': 'content_box_'+object.cbCounter,
					'html': (iconMove !== null ? iconMove : '') + '{/literal}{if isset($smarty.get.local_data)}{literal}<div class="grip_block grip_t">&nbsp;</div>\
					<div class="grip_block grip_tr">&nbsp;</div>\
					<div class="grip_block grip_r">&nbsp;</div>\
					<div class="grip_block grip_br">&nbsp;</div>\
					<div class="grip_block grip_b">&nbsp;</div>\
					<div class="grip_block grip_bl">&nbsp;</div>\
					<div class="grip_block grip_l">&nbsp;</div>\
					<div class="grip_block grip_tl">&nbsp;</div>\
					<div class="overlay" style="width:100%;height:100%;top:0;left:0;position:absolute;">&nbsp;</div>\
					<div class="action_block">\
						<div class="edit"><i class="ion-edit" style="font-size: 18px; vertical-align: bottom; color: #FFCC29; margin: 0 5px;"></i></div>\
						<div class="remove"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></div>\
						<div class="dublicate"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></div>\
					</div>\
					{/literal}{/if}{literal}<div class="options_block">'
					+strOptions+
					'</div>'
			}).setStyle('position', 'absolute')
		);
		if( $('emulator') != undefined && $('emulator').length > 0 )
			jQuery('#emulator').customScroll('destroy').customScroll('init');
		if( object.settingsDefault==false ){
			object.lastElementSelected=$( 'content_box_'+ object.cbCounter);
			object.lastElementSelected.cboxid=object.cbCounter;
			object.lastElementSelected.deltaX=20;
			object.lastElementSelected.deltaY=20;
		
			object.lastElementMove=true;
		
			object.lastElementSelected.getElements( '.grip_block' ).show();
			object.lastElementSelected.getElements( '.action_block' ).show();
		}
		object.moveSettings( object.cbCounter);
		{/literal}{if isset($smarty.get.local_data)}{literal}
		object.addSortabler( dataTarget );
		object.addBlockActions( object.cbCounter );
		{/literal}{/if}{literal}
		$$('.menu_options').hide();
	},
	
	parseOptions:function ( options ){
		this.elementOptions=options;
	}, 
		
	clearOptions:function (  ){
		this.elementOptions=false;
		return '';
	}, 
		
	returnOption:function ( optionType, optionName, defaultValue ){
		if( typeof this.elementOptions[optionType] != 'undefined' ){
			return ' '+optionType+'="'+this.elementOptions[optionType]+'"';
		}else if( typeof this.elementOptions[optionType+'|'+optionName] != 'undefined' ){
			return ' '+optionType+'="'+this.elementOptions[optionType+'|'+optionName]+'"';
		}else if( typeof  defaultValue != 'undefined' ){
			return ' '+optionType+'="'+defaultValue+'"';
		}else{
			return '';
		}
	}, 
		
	returnOptionValue:function ( optionType, optionName, defaultValue ){
		if( typeof this.elementOptions[optionType] != 'undefined' ){
			return this.elementOptions[optionType];
		}else if( typeof this.elementOptions[optionType+'|'+optionName] != 'undefined' ){
			return this.elementOptions[optionType+'|'+optionName];
		}else if( typeof  defaultValue != 'undefined' ){
			return defaultValue;
		}else{
			return '';
		}
	}, 

	addSetting:function ( options ){
		this.parseOptions( options );
		return 
	},

	changePositionSettings:function ( boxid ){
		if( this.lastElementSelected != false && boxid!=this.lastElementSelected.cboxid ){
			boxid=this.lastElementSelected.cboxid;
		}
		var suffix = '';
		if($$('a[data-type].active')[0].get('data-type') == 'mobile') suffix = '_m';
		if($$('a[data-type].active')[0].get('data-type') == 'mobile' && $$('.orientation a[data-orientation].active')[0].get('data-orientation') == 'albumn') suffix = '_a';
		
		$$( '[data-return="left'+suffix+'"][data-boxid="'+boxid+'"]' )[0].set( 'value', $( 'content_box_'+boxid ).offsetLeft );
		$$( '[data-return="top'+suffix+'"][data-boxid="'+boxid+'"]' )[0].set( 'value', $( 'content_box_'+boxid ).offsetTop );
		$$( '[data-return="width'+suffix+'"][data-boxid="'+boxid+'"]' )[0].set( 'value', $( 'content_box_'+boxid ).offsetWidth );
		$$( '[data-return="height'+suffix+'"][data-boxid="'+boxid+'"]' )[0].set( 'value', $( 'content_box_'+boxid ).offsetHeight );
	}, 

	openOnDblClick:function ( boxid ){
		if( $$( '#dbl_click_open_'+boxid ).length > 0 ){
			this.simulateClick( $( 'dbl_click_open_'+boxid ) );
		}
	},

	openSettings:function ( boxid ){
		$$( '.all_settings_blocks' ).each( function( elt ){elt.hide(  );});
		if( $$( '.settings_blocks_'+boxid ).length !=0 ){
			$$( '.settings_blocks_'+boxid ).each( function( elt ){elt.show(  );});
			return;
		}
		
		// надо подсветить какой блок выбрали ?
	}, 

	arrShowActions:[],
	
	addShowAction:function ( close_all, show_one ){
		this.arrShowActions.push( {
			'close_all': close_all,
			'show_one': show_one
		});
	},
	
	runShowActions:function (){
		var object=this;
		for( var key in object.arrShowActions ){
			var data=object.arrShowActions[key];
			$$( data.close_all ).hide();
			$$( data.show_one ).show();
		};
		object.arrShowActions=[];
	}, 

	parseData:function ( link, data){
		var returnData=data;
		new Request({
			url: link,
			method: 'post',
			async: false,
			onComplete: function(data){
				returnData=data;
			}
		}).post({'data':data,'action':'parse_form'});
		return returnData;
	},

	addSettingsElement:function ( dataElement, menuElement, boxid ){
		var object=this;
		// проверяем настройки с action связанные с другими элементами
		var addActionOptNmae='';
		if( dataElement.get( 'data-optionclass' ) ){
			addActionOptNmae='['+dataElement.get( 'data-optionclass' )+']';
		}
		if( typeof object.settingsDefault[dataElement.get( 'data-return' )] != 'undefined' ){
			if( dataElement.get( 'data-dev' ) > 1 ){
				dataElement.set( 'data-default', object.settingsDefault[dataElement.get( 'data-return' )]*dataElement.get( 'data-dev' ) );
			}else{
				if( dataElement.get( 'data-type' ) == 'text_box' || dataElement.get( 'data-type' ) == 'textarea' || dataElement.get( 'data-type' ) == 'video_embed' || dataElement.get( 'data-type' ) == 'form_formater' || dataElement.get( 'data-type' ) == 'style'){
					if(object.settingsDefault[dataElement.get( 'data-return' )] != null) {
						dataElement.set( 'data-default', object.encode( object.settingsDefault[dataElement.get( 'data-return' )] ) );
					}
				}else{
					dataElement.set( 'data-default', object.settingsDefault[dataElement.get( 'data-return' )] );
				}
			}
			var eltAction='';
			if( dataElement.get( "data-event" )=="action" ){
				eltAction='action_'+eltValue;
			}
			if( eltAction != '' ){
				var getDefaultDataElement=$$('#content_box_'+boxid+' .setting_def_elt[data-optionparent="'+dataElement.get( 'data-return' )+'"][data-optionclass="'+eltValue+'"]' );
				if( getDefaultDataElement.length > 0 ){
					eltValue=getDefaultDataElement[0].get('data-default');
				}
			}
		}
		// создаем управляемый элемент в блоке
		if( dataElement.get( 'data-elementclass' ) && $$( '#content_box_'+boxid+' .'+dataElement.get( 'data-elementclass' ) ).length == 0 ){
			var elementclasstype='div';
			if( dataElement.get( 'data-elementclasstype' ) ){
				elementclasstype=dataElement.get( 'data-elementclasstype' );
			}
			console.log(dataElement.get('data-name'));
			var param = {'class':dataElement.get( 'data-elementclass' )};
			{/literal}
			{if isset($smarty.get.local_data)}{literal}
			if(dataElement.get('data-name') == 'Content Text') {
				param.contenteditable = true;
			} 
			{/literal}
			{/if}
			{literal}
			$$( '#content_box_'+boxid ).grab(
				new Element( elementclasstype, param).setStyles({
					'position':'absolute',
					'top':'0px',
					'left':'0px',
					'width': '100%',
					'height': '100%'
				}), 'top' 
			);
		}
		var elementTarget=$$( '#content_box_'+boxid )[0];
		if( dataElement.get( 'data-elementclass' ) ){
			elementTarget=$$( '#content_box_'+boxid+' .'+dataElement.get( 'data-elementclass' ) );
		}
		var elementTargetSearch='#content_box_'+boxid;
		if( dataElement.get( 'data-elementclass' ) ){
			elementTargetSearch='#content_box_'+boxid+' .'+dataElement.get( 'data-elementclass' );
		}

		if( dataElement.get( 'data-return' ) == 'style' ){
			//console.log(dataElement.get('value'));
		}

		{/literal}{if isset($smarty.get.local_data)}{literal}
		// создаем элемент управления
		var elementEditor=new Element( 'input', {
			'type':dataElement.get( 'data-type' ), 
			'name': 'arrSettings['+boxid+']'+addActionOptNmae+'['+dataElement.get( 'data-return' )+']',
			'id': 'setting_'+boxid+addActionOptNmae+dataElement.get( 'data-return' ),
			'class':'setting_elt form-control ' + (dataElement.get('data-class') != null ? dataElement.get('data-class') : ''), 
			'data-return':dataElement.get( 'data-return' ), 
			'data-boxid':boxid, 
		});
		// это название элемента управления
		var elementTitle=new Element( 'span', {'class':'setting_label '  + (dataElement.get('data-class') != null ? dataElement.get('data-class') : ''), 'html': dataElement.get( 'data-name' )});
		var addElements=[];
		var buttonOpenPopup=new Element('div');
		// File image selector
		if( dataElement.get( 'data-type' ) == 'hidden' ){
			elementEditor.set( 'type', 'hidden' );
			if( dataElement.get( 'data-default' ) ){
				elementEditor.set( 'value', dataElement.get( 'data-default' ) );
			}
			addElements.push( elementEditor );
		}
		if( dataElement.get( 'data-type' ) == 'checkbox' ) {
			elementEditor.set( 'type', 'checkbox' );
			if( dataElement.get( 'data-default' ) ){
				elementEditor.set( 'value', dataElement.get( 'data-default' ) );
				if(dataElement.get( 'data-default' ) == 1) 
					elementEditor.set('checked', 'checked');
			}
			addElements.push( elementTitle );
			addElements.push( new Element(
				'div', { 
					'class' : 'checkbox checkbox-primary ' + ((dataElement.get('data-class') != null ? dataElement.get('data-class') : '')) }
				).adopt( 
					[ 
						elementEditor.addEvent('change', function(){
							if($(this).getProperty('checked')){
								$('content_box_' + boxid).setStyle('display', 'none');
								$(this).set('value', 1);
							}
							else {
								$('content_box_' + boxid).setStyle('display', 'block');
								$(this).set('value', 0);
							}
						}), 
						new Element( 'label', { 'html' : 'Yes'} )
					]  
				) 
			);
		}
		// File image selector
		if( dataElement.get( 'data-type' ) == 'file_image' ){
			var parentElement=new Element( 'div');
			var imageType='background';
			if( dataElement.get( 'data-imagetype' ) ){
				imageType=dataElement.get( 'data-imagetype' );
			}
			// ссылка на попап с url
			buttonOpenPopup=new Element( 'a', {
				'href':'{/literal}{url name="site1_contentbox" action="images"}{literal}?flg_type='+imageType+'&boxid='+boxid+'&return='+dataElement.get( 'data-return' ),
				'data-id':'popup_'+dataElement.get( 'data-return' )+'_'+imageType+'_'+boxid,
				'html': 'Select'
			});
			if( dataElement.get( 'data-openoncreate' ) == 'true' ){
				buttonOpenPopup.set( 'id', 'dbl_click_open_'+boxid  );
			}
			var cnmLink='';
			var cnmLinkDefault=Zend_Registry::get( 'config' )->domain->url;
			if( dataElement.get( 'data-default' ) ){
				if( dataElement.get( 'data-default' ).indexOf( cnmLinkDefault ) != -1 ){
					cnmLink='';
				}else if( dataElement.get( 'data-default' ).indexOf( 'data:image' ) == -1 ){
					cnmLink=cnmLinkDefault;
				}
				elementEditor.set( 'value', cnmLink+dataElement.get( 'data-default' ) );
			}
			parentElement.adopt( [
				elementEditor
					.setStyles({'width':'80%','display': 'inline'}).set('id',imageType+'_'+dataElement.get( 'data-return' )+'_'+boxid)
					.addEvent( 'change', function( evnt ){
						var cnmLink='';
						var cnmLinkDefault=Zend_Registry::get( 'config' )->domain->url;
						if( evnt.target.get( 'value' ).indexOf( cnmLinkDefault ) != -1 ){
							cnmLink='';
						}else if( evnt.target.get( 'value' ).indexOf( 'data:image' ) == -1 ){
							cnmLink=cnmLinkDefault;
						}
						if( dataElement.get( 'data-returntype' ) == 'attr' ){
							elementTarget.set( dataElement.get( 'data-return' ), dataTail.replace( '[data]', cnmLink+evnt.target.get( 'value' ) ) );
						}else{
							elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', cnmLink+evnt.target.get( 'value' ) ) );
						}
					}), 
				buttonOpenPopup
			]);
			addElements.push( elementTitle );
			addElements.push( parentElement );
		}
		// Add INPUT type TEXT|NUMBER
		if( dataElement.get( 'data-type' ) == 'number' || dataElement.get( 'data-type' ) == 'text' ){
			var dataTail='[data]';
			if( dataElement.get( 'data-tail' ) ){
				dataTail=dataElement.get( 'data-tail' );
			}
			if( dataElement.get( 'data-max' ) ){
				elementEditor.set( 'max', dataElement.get( 'data-max' ) );
			}
			if( dataElement.get( 'data-min' ) ){
				elementEditor.set( 'min', dataElement.get( 'data-min' ) );
			}
			if( dataElement.get( 'data-default' ) ){
				elementEditor.set( 'value', dataElement.get( 'data-default' ) );
			}
			addElements.push( elementTitle );
			addElements.push( elementEditor );
		}
		// Add SELECT
		if( dataElement.get( 'data-type' ) == 'select' ){
			var elementEditor=new Element( 'select', {
				'type':dataElement.get( 'data-type' ), 
				'name': 'arrSettings['+boxid+']'+addActionOptNmae+'['+dataElement.get( 'data-return' )+']', 
				'class':'setting_elt btn-default selectpicker show-tick', 
				'data-return':dataElement.get( 'data-return' ), 
				'data-boxid':boxid, 
			});
			elementEditor.addEvent( 'change', function( evnt ){
				if( typeof evnt.target.selectedOptions[0]!= 'undefined' && evnt.target.selectedOptions[0].get( 'rel' )!='' && dataElement.get( "data-event" )=="action" ){
					$$( '.'+dataElement.get( 'data-return' )+'_'+boxid ).hide();
					$$( '.'+evnt.target.selectedOptions[0].get( 'rel' ) ).show();
					var fireEventElt=$$( '.'+dataElement.get( 'data-return' )+'_'+boxid+'.'+evnt.target.selectedOptions[0].get( 'rel' )+' .setting_elt' )[0];
					fireEventElt.fireEvent( 'change', { 'target': fireEventElt }, 10 );
				}
			});
			if( dataElement.get( 'data-options' ) ){
				var arrSettings=dataElement.get( 'data-options' ).split( '|' );
				arrSettings.each( function( elnt ){
					var eltTitle=elnt;
					var eltValue=elnt;
					var flgOptionSelected=false;
					if( elnt.split( ':' ).length > 1 ){
						eltValue=elnt.split( ':' )[0];
						if( typeof elnt.split( ':' )[1] != 'undefined' || elnt.split( ':' )[1]!='' ){
							eltTitle=elnt.split( ':' )[1];
						}
					}
					// привязываем выбор этого options к показу скрытого элемента формы с таким классом
					var eltAction='';
					if( dataElement.get( "data-event" )=="action" ){
						eltAction='action_'+eltValue;
					}
					// проверяем какая опция выбрана дефолтом
					if( dataElement.get( 'data-default' ) == eltValue ){
						flgOptionSelected=true;
						// в конце переноса всех настроек запускаем эти функции только для выбранного элемента
						if( eltAction != '' ){
							object.addShowAction( '.'+dataElement.get( 'data-return' )+'_'+boxid, '.'+eltAction );
						}
					}
					elementEditor
						.adopt( new Element( 'option', {'value':eltValue, 'html':eltTitle, 'selected':flgOptionSelected, 'rel':eltAction}) );
					var eltAction='';
				});
			}
			if( dataElement.get( 'data-onaction' ) ){ // на параметры ругих элементов может быть завязан только элемент select
				elementEditor.set( 'data-onaction', dataElement.get( 'data-onaction' ) );
				if( $$('.setting_elt[data-return="'+dataElement.get( 'data-onaction' )+'"]').length > 0 ){
					$$('.setting_elt[data-return="'+dataElement.get( 'data-onaction' )+'"]').each(function(elmt){
						//выбор исходного значения в конце загрузки - доделать
						elementEditor
							.adopt( new Element( 'option', {'value':elmt.get('value'), 'html':elmt.get('value')/*, 'selected':flgOptionSelected*/}) );
					});
				}
			}
			addElements.push( elementTitle );
			addElements.push( elementEditor );
		}
		
		// Add color
		if( dataElement.get( 'data-type' ) == 'color' ){
			var parentElement=new Element( 'div' );
			elementEditor.set( 'id', 'color_editor_'+boxid+'_'+dataElement.get( 'data-return' ) );
			elementEditor.set( 'type', 'text' );
			elementEditor.set( 'data-elementclass', dataElement.get( 'data-elementclass' ) );
			if( dataElement.get( 'data-default' ) ){
				elementEditor.set( 'value', dataElement.get( 'data-default' ) );
			}
			parentElement.adopt( [
				elementEditor, 
				new Element( 'span', { 'id': 'color_editor_'+boxid+'_'+dataElement.get( 'data-return' )+'_span' })
			] );
			addElements.push( elementTitle );
			addElements.push( parentElement );
		}
		//add scroll
		if( dataElement.get( 'data-type' ) == 'scroll' ){
			var dataDev=1;
			if( dataElement.get( 'data-dev' ) > 1 ){
				dataDev=dataElement.get( 'data-dev' );
			}
			elementEditor.set( 'type', 'hidden' );
			elementEditor.set( 'id', 'slider_editor_'+boxid+'_'+dataElement.get( 'data-return' ) );
			if( dataElement.get( 'data-default' ) ){
				elementEditor.set( 'value', dataElement.get( 'data-default' )/dataDev );
			}
			var parentElement=new Element( 'div' );
			parentElement.adopt( [
				new Element( 'div', {'style':{'clear':'both'}}), 
				new Element( 'div', { 'id':'slider_'+boxid+'_'+dataElement.get( 'data-return' ), 'class':'slider_box' }).adopt( 
					new Element( 'div', {'class':'slider_knob'})
				 ), 
				elementEditor
			] );
			addElements.push( elementTitle );
			addElements.push( parentElement );
		}

		if( dataElement.get( 'data-type' ) == 'lead_channels' ) {
			var elementEditor=new Element( 'input', {
				'name': 'arrSettings['+boxid+']'+addActionOptNmae+'['+dataElement.get( 'data-return' )+']', 
				'type' : 'hidden',
				'id': 'textarea_'+dataElement.get( 'data-return' )+'_'+boxid,
				'class':'setting_elt',
				'data-return':dataElement.get( 'data-return' ), 
				'data-boxid':boxid,
				'data-tail':dataElement.get( 'data-tail' ), 
				'data-returntype':dataElement.get( 'data-returntype' )
			});
			if( dataElement.get( 'data-default' ) ){
				new Request({
					url: '{/literal}{url name="site1_contentbox" action="generate_lead_channels"}{literal}',
					method: 'post',
					onComplete: function(data){
						var button_text = $$('[data-return="button_text"][data-boxid="' + boxid + '"]').get('value');
						$$('#content_box_' + boxid + ' > .content')[0].set('html', JSON.parse(data));
						var elm = $$('#content_box_' + boxid + ' > .content')[0];
						elm.getElement('input[type="submit"]').set('value', button_text);
						var _height = elm.setStyle('height', 'auto').getBoundingClientRect().height;
						elm.getParent().setStyle('height', _height);
						elm.getParent().getElements('input[data-return$=height_m]').set('data-default', _height);
						$$( '[data-return="height"][data-boxid="'+boxid+'"]' ).set('value', _height);
					}
				}).post({'id': dataElement.get( 'data-default' )});
				elementEditor.set( 'value', dataElement.get( 'data-default' ) );
			}
			var buttonSave=new Element( 'a', {
				'href':'#',
				'style' : 'display:none;',
				'html': 'Save',
				'data-elementtarget':elementTargetSearch,
				'data-elementeditor':'[name="arrSettings['+boxid+']'+addActionOptNmae+'['+dataElement.get( 'data-return' )+']"]',
				'id':'save_from_popup_'+dataElement.get( 'data-return' )+'_'+boxid
			});
			var parentElement=new Element( 'div', {
				'styles':{
					'display':'none'
				}
			}).adopt([
				new Element( 'div',{
					'id': 'popup_'+dataElement.get( 'data-return' )+'_'+boxid
				}).adopt(
					new Element( 'div', {'class':'move_inside_'+boxid,'html':'load....'})
				),
				new Element( 'div',{
					'id': 'move_popup_'+dataElement.get( 'data-return' )+'_'+boxid
				}).adopt([
					new Element( 'div', {'class':''}).adopt(
						buttonSave
					),
					elementEditor,
					new Element ('iframe', {
						'style' : 'border: none;',
						'src' : '{/literal}{url name="site1_contentbox" action="lead_channels"}{literal}?boxid='+boxid
					})
				])
			]);
			
			buttonOpenPopup=new Element( 'a', {
				'href':'#popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-movefrom':'move_popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-moveto':'.move_inside_'+boxid,
				'data-savebutton':'save_from_popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-editorelement':'textarea_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-id':'popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'html': 'Change',
				'styles':{
					'width': '50px',
					'margin': '0 auto',
					'display': 'block',
				},
			});
			buttonOpenPopup.set( 'data-activateeditor', 'lead_channels' );
			addElements.push( elementTitle );
			addElements.push( buttonOpenPopup );
			addElements.push( parentElement );
		}

		if( dataElement.get( 'data-type' ) == 'text_box' || dataElement.get( 'data-type' ) == 'textarea' || dataElement.get( 'data-type' ) == 'video_embed' || dataElement.get( 'data-type' ) == 'form_formater'){
			var elementEditor=new Element( 'textarea', {
				'name': 'arrSettings['+boxid+']'+addActionOptNmae+'['+dataElement.get( 'data-return' )+']', 
				'id': 'textarea_'+dataElement.get( 'data-return' )+'_'+boxid,
				'class':'setting_elt',
				'data-return':dataElement.get( 'data-return' ), 
				'data-boxid':boxid,
				'data-tail':dataElement.get( 'data-tail' ), 
				'data-returntype':dataElement.get( 'data-returntype' ),
				'styles':{
					'width': '100%',
					'height': '440px'
				}
			});
			if( dataElement.get( 'data-default' ) ){
				if(object.decode( dataElement.get( 'data-default' )).indexOf('form-cb-') != -1)
					elementEditor.set( 'html', object.decode( dataElement.get( 'data-default' ) ).replace(/form-cb-\w{1,}/, 'form-cb-' + elementEditor.get('data-boxid')) );
				else 
					elementEditor.set( 'html', object.decode( dataElement.get( 'data-default' ) ) );
			}
			var buttonSave=new Element( 'a', {
				'href':'#',
				'html': 'Save',
				'data-elementtarget':elementTargetSearch,
				'data-elementeditor':'[name="arrSettings['+boxid+']'+addActionOptNmae+'['+dataElement.get( 'data-return' )+']"]',
				'id':'save_from_popup_'+dataElement.get( 'data-return' )+'_'+boxid
			});
			var parentElement=new Element( 'div', {
				'styles':{
					'display':'none'
				}
			}).adopt([
				new Element( 'div',{
					'id': 'popup_'+dataElement.get( 'data-return' )+'_'+boxid
				}).adopt(
					new Element( 'div', {'class':'move_inside_'+boxid,'html':'load....'})
				),
				new Element( 'div',{
					'id': 'move_popup_'+dataElement.get( 'data-return' )+'_'+boxid
				}).adopt([
					new Element( 'div', {'class':'center_inside'}).adopt(
						buttonSave
					),
					elementEditor
				])
			]);
			
			buttonOpenPopup=new Element( 'a', {
				'href':'#popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-movefrom':'move_popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-moveto':'.move_inside_'+boxid,
				'data-savebutton':'save_from_popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-editorelement':'textarea_'+dataElement.get( 'data-return' )+'_'+boxid,
				'data-id':'popup_'+dataElement.get( 'data-return' )+'_'+boxid,
				'html': 'Change',
				'styles':{
					'width': '50px',
					'margin': '0 auto',
					'display': 'block',
				},
			});
			if( dataElement.get( 'data-runparser' ) ){
				buttonOpenPopup.set( 'data-runparser', dataElement.get( 'data-runparser' ) );
			}
			if( dataElement.get( 'data-type' ) == 'text_box' && dataElement.get('data-name') != 'HTML'){
				buttonOpenPopup.set( 'data-activateeditor', 'ckeditor' );
			}
			if( dataElement.get( 'data-type' ) == 'form_formater' ){
				buttonOpenPopup.set( 'data-activateeditor', 'formeditor' );
			}
			if( dataElement.get( 'data-type' ) == 'video_embed' ){
				buttonOpenPopup.set( 'data-activateeditor', 'video_editor' );
				buttonOpenPopup.set( 'data-boxid', boxid );
			}
			if( dataElement.get( 'data-openoncreate' ) == 'true' ){
				buttonOpenPopup.set( 'id', 'dbl_click_open_'+boxid  );
			}
			addElements.push( elementTitle );
			addElements.push( buttonOpenPopup );
			addElements.push( parentElement );
		}
		// добавляем элементы
		var addAction='';
		if( dataElement.get( 'data-optionparent' ) ){
			addAction='action_'+dataElement.get( 'data-optionclass' )+' '+dataElement.get( 'data-optionparent' )+'_'+boxid;
		}
		if(dataElement.get('data-container') == 'messages') {
			$('messages').adopt(
				new Element( 'div', {'class': 'all_settings_blocks settings_blocks_'+boxid }).adopt( addElements )
			);
		} else {
			menuElement.adopt(
			new Element( 'div', {'class':addAction })
				.adopt( addElements )
			);
		}
		{/literal}{else}{literal}
		if( dataElement.get( 'data-type' ) == 'lead_channels' ) {
			
			if( dataElement.get( 'data-default' ) ){
				new Request({
					url: '{/literal}{Zend_Registry::get( 'config' )->domain->url}{literal}/services/lead_channels.php?id=' + dataElement.get( 'data-default' ),
					method: 'get',
					onComplete: function(data){
						var button_text = $$('[data-return="button_text"][data-type="text"]').get('data-default');
						$$('#content_box_' + boxid + ' > .content')[0].set('html', data);
						var elm = $$('#content_box_' + boxid + ' > .content')[0];
						elm.getElement('input[type="submit"]').set('value', button_text);
						var _height = elm.setStyle('height', 'auto').getBoundingClientRect().height;
						elm.getParent().setStyle('height', _height);
						elm.getParent().getElements('input[data-return$=height_m]').set('data-default', _height);
						$$( '[data-return="height"][data-boxid="'+boxid+'"]' ).set('value', _height);
					}
				}).send();
			}
		}
		{/literal}{/if}{literal}
		// проверяем оболочку вставляемых данных
		var dataTail='[data]';
		if( dataElement.get( 'data-tail' ) ){
			dataTail=dataElement.get( 'data-tail' );
		}
		//проверяемм нет ли связи с элементом родителем
		var addDefaultValue=true;
		if( dataElement.get( 'data-optionparent' ) ){
			addDefaultValue=false;
			var selectedParent=$$('.settings_blocks_'+boxid+' .setting_elt[data-return="'+dataElement.get( 'data-optionparent' )+'"]');
			if( selectedParent.length > 0 ){
				selectedParent=selectedParent[0].get('value');
				if( selectedParent==dataElement.get( 'data-optionclass' ) ){
					addDefaultValue=true;
				}
			}
		}
		if( addDefaultValue ){
			// запрашиваем место куда будет внесено исходное значение
			var eltValue=dataElement.get( 'data-default' );
			var eltAction='';
			if( dataElement.get( "data-event" )=="action" ){
				eltAction=eltValue;
			}
			if( eltAction != '' ){
				var getDefaultDataElement=$$('#content_box_'+boxid+' .setting_def_elt[data-optionparent="'+dataElement.get( 'data-return' )+'"][data-optionclass="'+eltValue+'"]' );
				if( getDefaultDataElement.length > 0 ){
					eltValue=getDefaultDataElement[0].get('data-default');
				}
			}
			if( dataElement.get( 'data-type' ) == 'textarea' || dataElement.get( 'data-type' ) == 'text_box' || dataElement.get( 'data-type' ) == 'video_embed' || dataElement.get( 'data-type' ) == 'form_formater' || dataElement.get('data-type') == 'style' ){
				eltValue=object.decode( dataElement.get( 'data-default' ) );
			}
			if( eltAction != '' ){
				if( eltAction == 'url' || eltAction == 'call' ){
					elementTarget.set( 'href', dataTail.replace( '[data]', eltValue ) );
				}
				if( eltAction == 'form' ){
					// ппоказывать по нажатию скрытую форму
					elementTarget.addEvent( 'click', function(){ document[dataTail.replace( '[data]', eltValue )].show() } );
				}
				if( eltAction == 'submit' ){
					// посылать по нажатию форму
					elementTarget.addEvent( 'click', function(){ document[dataTail.replace( '[data]', eltValue )].submit();  } );
				}
				elementTarget.addClass('get-button');
			}else{
				if( dataElement.get( 'data-returntype' ) == 'attr' ){
					if(dataElement.get('data-type') != 'lead_channels') {
						elementTarget.set( dataElement.get( 'data-return' ), dataTail.replace( '[data]', eltValue ) );
					}

					{/literal}{if isset($smarty.get.local_data)}{literal}
					if($$('input[data-formstyles="' + boxid + '"')[0] == undefined && dataElement.get('data-type') == 'textarea' || dataElement.get('data-type') == 'form_formater' || dataElement.get('data-type') == 'lead_channels' ){
						$('messages').adopt( new Element('div', {'class':'all_settings_blocks settings_blocks_' + boxid}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Font Family'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('select', {'class':'setting_elt btn-group selectpicker show-tick bs-select-hidden form-styles', 'data-return' : 'font-family', 'name' : 'arrSettings['+boxid+'][form_styles][fontFamily]', 'data-formstyles' : boxid})
						.adopt([
								new Element('option', { 'value':'arial,helvetica,sans-serif', 'html':'Arial', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'arial,helvetica,sans-serif' ? 'selected' : '') }),
								new Element('option', { 'value':'comic sans ms,cursive', 'html':'Comic Sans MS', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'comic sans ms,cursive' ? 'selected' : '')  }),
								new Element('option', { 'value':'courier new,courier,monospace', 'html':'Courier New', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'courier new,courier,monospace' ? 'selected' : '')  }),
								new Element('option', { 'value':'georgia,serif', 'html':'Georgia', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'georgia,serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'lucida sans unicode,lucida grande,sans-serif','html':'Lucida Sans Unicode', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'lucida sans unicode,lucida grande,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'tahoma,geneva,sans-serif', 'html':'Tahoma', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'tahoma,geneva,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'times new roman,times,serif', 'html':'Times New Roman', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'times new roman,times,serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'trebuchet ms,helvetica,sans-serif', 'html':'Trebuchet MS', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'trebuchet ms,helvetica,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'verdana,geneva,sans-serif', 'html':'Verdana', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'verdana,geneva,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'arial black,gadget,sans-serif', 'html':'Arial Black', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'arial black,gadget,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'impact,charcoal,sans-serif', 'html':'Impact', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'impact,charcoal,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'lucida console,monaco,monospace', 'html':'Lucida Console', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'lucida console,monaco,monospace' ? 'selected' : '')  }),
								new Element('option', { 'value':'palatino linotype,book antiqua,palatino,serif', 'html':'Palatino Linotype', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'palatino linotype,book antiqua,palatino,serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'trebuchet ms,helvetica,sans-serif', 'html':'Trebuchet MS', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'trebuchet ms,helvetica,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'symbol', 'html':'Symbol', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'symbol' ? 'selected' : '')  }),
								new Element('option', { 'value':'webdings', 'html':'Webdings', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'webdings' ? 'selected' : '')  }),
								new Element('option', { 'value':'wingdings,zapf dingbats', 'html':'Wingdings', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'wingdings,zapf dingbats' ? 'selected' : '')  }),
								new Element('option', { 'value':'ms sans serif,geneva,sans-serif', 'html':'MS Sans Serif', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'ms sans serif,geneva,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'ms serif,new york,serif', 'html':'MS Serif', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'ms serif,new york,serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'lato,sans-serif', 'html':'Lato', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'lato,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'source sans pro,sans-serif', 'html':'Source Sans Pro', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'source sans pro,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'rambla,sans-serif', 'html':'Rambla', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'rambla,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'droid sans,sans-serif', 'html':'Droid Sans', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'droid sans,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'permanent marker,sans-serif', 'html':'Permanent Marker', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'permanent marker,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'signika negative,sans-serif', 'html':'Signika Negative', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'signika negative,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'magra,sans-serif', 'html':'Magra', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'magra,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'exo,sans-serif', 'html':'Exo', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'exo,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'cinzel,sans-serif', 'html':'Cinzel', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'cinzel,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'titillium web,sans-serif', 'html':'Titillium Web', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'titillium web,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'oxygen,sans-serif', 'html':'Oxygen', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'oxygen,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'architects daughter,sans-serif', 'html':'Architects Daughter', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'architects daughter,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'give you glory,sans-serif', 'html':'Give You Glory', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'give you glory,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'gochi hand,sans-serif', 'html':'Gochi Hand', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'gochi hand,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'marck script,sans-serif', 'html':'Marck Script', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'marck script,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'la belle aurore,sans-serif', 'html':'La Belle Aurore', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'la belle aurore,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'yellowtail,sans-serif', 'html':'Yellowtail', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'yellowtail,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'walter turncoat,sans-serif', 'html':'Walter Turncoat', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'walter turncoat,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'kaushan script,sans-serif', 'html':'Kaushan Script', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'kaushan script,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'loved by the king,sans-serif', 'html':'Loved by the King', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'loved by the king,sans-serif' ? 'selected' : '')  }),
								new Element('option', { 'value':'over the rainbow,sans-serif', 'html':'Over the Rainbow', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.fontFamily == 'over the rainbow,sans-serif' ? 'selected' : '')  })
								
							])
						);
						
						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Input Background Color'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'text', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.backgroundColorInput : '#ffffff'), 'name' : 'arrSettings['+boxid+'][form_styles][backgroundColorInput]', 'class' : 'setting_elt form-control form-styles', 'id' : 'color_editor_input_'+boxid+'_background-color', 'data-formstyles' : boxid, 'data-return' : 'background-color', 'data-elemetedit':'input'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Input Text Color'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'text', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.colorInput : '#8F8F8F'), 'name' : 'arrSettings['+boxid+'][form_styles][colorInput]','class' : 'setting_elt form-control form-styles', 'id' : 'color_editor_input_'+boxid+'_color', 'data-formstyles' : boxid, 'data-return' : 'color', 'data-elemetedit':'input'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Input Icons'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('div', {'class' : 'checkbox checkbox-primary', 'html' : '<input type="checkbox" name="arrSettings['+boxid+'][form_styles][icons]" class="form-styles" value="1" ' + (object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.icons == '1' ? 'checked="checked"' : '') + ' data-formstyles="'+boxid+'" /><label>Yes</label>'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Button Background Color'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'text', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.backgroundColorButton : '#DDDDDD'), 'name' : 'arrSettings['+boxid+'][form_styles][backgroundColorButton]','class' : 'setting_elt form-control form-styles', 'id' : 'color_editor_button_'+boxid+'_background-color', 'data-formstyles' : boxid, 'data-return' : 'background-color', 'data-elemetedit':'select'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Button Text Color'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'text', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.colorButton : '#797979'), 'name' : 'arrSettings['+boxid+'][form_styles][colorButton]','class' : 'setting_elt form-control form-styles', 'id' : 'color_editor_button_'+boxid+'_color', 'data-formstyles' : boxid, 'data-return' : 'color', 'data-elemetedit':'select'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Font size input'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'number', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.fontSizeInput : '14'), 'name' : 'arrSettings['+boxid+'][form_styles][fontSizeInput]', 'class' : 'setting_elt form-control form-styles', 'data-return' : 'font-size', 'data-elemetedit':'input', 'data-formstyles' : boxid }));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Font size button'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'number', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.fontSizeButton : '14'), 'name' : 'arrSettings['+boxid+'][form_styles][fontSizeButton]', 'class' : 'setting_elt form-control form-styles', 'data-return' : 'font-size', 'data-elemetedit':'button', 'data-formstyles' : boxid }));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Border Style Input'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('select', {'class':'setting_elt btn-group selectpicker show-tick bs-select-hidden form-styles', 'data-return' : 'border-style', 'name' : 'arrSettings['+boxid+'][form_styles][borderStyleInput]', 'data-elemetedit' : 'input', 'data-formstyles' : boxid})
							.adopt([
								new Element('option', { 'value':'none', 'html':'none', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'none' ? 'selected' : '') }),
								new Element('option', { 'value':'dotted', 'html':'dotted', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'dotted' ? 'selected' : '')  }),
								new Element('option', { 'value':'dashed', 'html':'dashed', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'dashed' ? 'selected' : '')  }),
								new Element('option', { 'value':'solid', 'html':'solid', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'solid' ? 'selected' : '')  }),
								new Element('option', { 'value':'double', 'html':'double', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'double' ? 'selected' : '')  }),
								new Element('option', { 'value':'groove', 'html':'groove', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'groove' ? 'selected' : '')  }),
								new Element('option', { 'value':'ridge', 'html':'ridge', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'ridge' ? 'selected' : '')  }),
								new Element('option', { 'value':'inset', 'html':'inset', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'inset' ? 'selected' : '')  }),
								new Element('option', { 'value':'outset', 'html':'outset', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleInput == 'outset' ? 'selected' : '')  })
							])
						);

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Border Color Input'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'text', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.borderColorInput : '#000000'), 'name' : 'arrSettings['+boxid+'][form_styles][borderColorInput]', 'class' : 'setting_elt form-control form-styles', 'id' : 'color_editor_input_'+boxid+'_border-color', 'data-formstyles' : boxid, 'data-return' : 'border-color', 'data-elemetedit':'input'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Border Width Input'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'number', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.borderWidthInput : 0), 'name' : 'arrSettings['+boxid+'][form_styles][borderWidthInput]', 'class' : 'setting_elt form-control form-styles', 'data-return' : 'border-width', 'data-elemetedit':'input', 'data-formstyles' : boxid }));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Border Style Button'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('select', {'class':'setting_elt btn-group selectpicker show-tick bs-select-hidden form-styles', 'data-return' : 'border-style', 'name' : 'arrSettings['+boxid+'][form_styles][borderStyleButton]', 'data-elemetedit' : 'button', 'data-formstyles' : boxid})
							.adopt([
								new Element('option', { 'value':'none', 'html':'none', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'none' ? 'selected' : '') }),
								new Element('option', { 'value':'dotted', 'html':'dotted', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'dotted' ? 'selected' : '')  }),
								new Element('option', { 'value':'dashed', 'html':'dashed', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'dashed' ? 'selected' : '')  }),
								new Element('option', { 'value':'solid', 'html':'solid', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'solid' ? 'selected' : '')  }),
								new Element('option', { 'value':'double', 'html':'double', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'double' ? 'selected' : '')  }),
								new Element('option', { 'value':'groove', 'html':'groove', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'groove' ? 'selected' : '')  }),
								new Element('option', { 'value':'ridge', 'html':'ridge', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'ridge' ? 'selected' : '')  }),
								new Element('option', { 'value':'inset', 'html':'inset', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'inset' ? 'selected' : '')  }),
								new Element('option', { 'value':'outset', 'html':'outset', 'selected' : ( object.settingsDefault.form_styles != undefined && object.settingsDefault.form_styles.borderStyleButton == 'outset' ? 'selected' : '')  })
							])
						);

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Border Color Button'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'text', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.borderColorButton : '#000000'), 'name' : 'arrSettings['+boxid+'][form_styles][borderColorButton]', 'class' : 'setting_elt form-control form-styles', 'id' : 'color_editor_button_'+boxid+'_border-color', 'data-formstyles' : boxid, 'data-return' : 'border-color', 'data-elemetedit':'button'}));

						$$('.settings_blocks_' + boxid).adopt(new Element('span', {'class':'setting_label', 'html':'Border Width Button'}));
						$$('.settings_blocks_' + boxid).adopt(new Element('input', {'type':'number', 'value' : (object.settingsDefault.form_styles != undefined ? object.settingsDefault.form_styles.borderWidthButton : 0), 'name' : 'arrSettings['+boxid+'][form_styles][borderWidthButton]', 'class' : 'setting_elt form-control form-styles', 'data-return' : 'border-width', 'data-elemetedit' : 'button', 'data-formstyles' : boxid }));
						
						$$('input[type="checkbox"].form-styles').addEvent('change', function(){
							object.generateStyle($(this).get('data-formstyles'));
						});

						$$('input[type="number"].form-styles').addEvent('change', function(){
							object.generateStyle($(this).get('data-formstyles'));
						});

						$$('select.form-styles').addEvent('change', function(){
							object.generateStyle($(this).get('data-formstyles'));
						});

						var colors_1 = jsColorPicker( '#color_editor_input_'+boxid+'_background-color', {
							customBG: '#ffffff',
							readOnly: true,
							init: function(elm, _colors_1){ // colors is a different instance (not connected to colorPicker)
								elm.style.backgroundColor = elm.value;
								elm.style.color = _colors_1.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
							},
							displayCallback: function(_color, _mode, _options){
								object.colorpickerCallback( _color, _mode, _options );
							}
						});

						var colors_2 = jsColorPicker( '#color_editor_input_'+boxid+'_color', {
							customBG: '#ffffff',
							readOnly: true,
							init: function(elm_1, _colors_2){ // colors is a different instance (not connected to colorPicker)
								elm_1.style.backgroundColor = elm_1.value;
								elm_1.style.color = _colors_2.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
							},
							displayCallback: function(_color, _mode, _options){
								object.colorpickerCallback( _color, _mode, _options );
							}
						});

						var colors_3 = jsColorPicker( '#color_editor_button_'+boxid+'_background-color', {
							customBG: '#ffffff',
							readOnly: true,
							init: function(elm_2, _colors_3){ // colors is a different instance (not connected to colorPicker)
								elm_2.style.backgroundColor = elm_2.value;
								elm_2.style.color = _colors_3.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
							},
							displayCallback: function(_color, _mode, _options){
								object.colorpickerCallback( _color, _mode, _options );
							}
						});

						var colors_4 = jsColorPicker( '#color_editor_button_'+boxid+'_color', {
							customBG: '#ffffff',
							readOnly: true,
							init: function(elm_3, _colors_4){ // colors is a different instance (not connected to colorPicker)
								elm_3.style.backgroundColor = elm_3.value;
								elm_3.style.color = _colors_4.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
							},
							displayCallback: function(_color, _mode, _options){
								object.colorpickerCallback( _color, _mode, _options );
							}
						});

						var colors_5 = jsColorPicker( '#color_editor_input_'+boxid+'_border-color', {
							customBG: '#ffffff',
							readOnly: true,
							init: function(elm_4, _colors_5){ // colors is a different instance (not connected to colorPicker)
								elm_4.style.backgroundColor = elm_4.value;
								elm_4.style.color = _colors_5.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
							},
							displayCallback: function(_color, _mode, _options){
								object.colorpickerCallback( _color, _mode, _options );
							}
						});

						var colors_6 = jsColorPicker( '#color_editor_button_'+boxid+'_border-color', {
							customBG: '#ffffff',
							readOnly: true,
							init: function(elm_5, _colors_6){ // colors is a different instance (not connected to colorPicker)
								elm_5.style.backgroundColor = elm_5.value;
								elm_5.style.color = _colors_6.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
							},
							displayCallback: function(_color, _mode, _options){
								object.colorpickerCallback( _color, _mode, _options );
							}
						});
					}
					{/literal}{/if}{literal}
				}else{
					if( dataElement.get( 'data-return' ) == 'opacity') {
						elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', eltValue ) / dataElement.get('data-dev') );
					} if ( dataElement.get( 'data-return') == 'padding' ) {
						elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', eltValue ) );
						elementTarget.setStyle( 'margin', '-' + dataTail.replace( '[data]', eltValue) );
					} else {
						elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', eltValue ) );
					}
					if(window.getSize().x <= 800) {
						if(dataElement.get('data-return') == 'width_a') {
							elementTarget.setStyle('width', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'height_a') {
							elementTarget.setStyle('height', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'left_a') {
							elementTarget.setStyle('left', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'top_a') {
							elementTarget.setStyle('top', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'hide_a'){
							if(eltValue == '1') {
								elementTarget.hide();
							}  else {
								elementTarget.show();
							}
						}
					}
					if(window.getSize().x <= 400) {
						if(dataElement.get('data-return') == 'width_m') {
							elementTarget.setStyle('width', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'height_m') {
							elementTarget.setStyle('height', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'left_m') {
							elementTarget.setStyle('left', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'top_m') {
							elementTarget.setStyle('top', dataTail.replace('[data]', eltValue));
						}
						if(dataElement.get('data-return') == 'hide_m'){
							if(eltValue == '1') {
								elementTarget.hide();
							}  else {
								elementTarget.show();
							}
						} 
					}
				}
				if(object.settingsDefault != false && $$('#content_box_' + boxid + ' style')[0] != undefined) {
					object.generateStyle(boxid, object.settingsDefault);
				}
			}
		}
		{/literal}{if isset($smarty.get.local_data)}{literal}
		// теперь на существующие элементы добавляю экшны
		if( buttonOpenPopup.get('tag') != 'div' ){
			// добавляем экшн попапа если он есть у элемента
			object.defaultCeraboxMove='';
			new CeraBox( buttonOpenPopup, {
				group: false,
				width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
				height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
				displayTitle: true,
				titleFormat: '{title}',
				fixedPosition: true,
				events: {
					onClose:function(currentItem, collection){
						// возвращаем исходное значение если закрыли popup
						if( object.defaultCeraboxMove != '' ){
							$( currentItem.get( 'data-movefrom' ) ).set('html', object.defaultCeraboxMove);
							object.defaultCeraboxMove=''; //обнуляем
						}
						var eltCounter=object.cbCounter;

						if( currentItem.getPrevious( 'input' ) != null  )
							eltCounter=currentItem.getPrevious( 'input' ).get( 'data-boxid' );
						if( currentItem.get('data-editorelement') != null )
							eltCounter=$(currentItem.get('data-editorelement')).get( 'data-boxid' );
						
						$$('#content_box_' + eltCounter + ' > div.content').each(function(elm){
							if(elm.getParent().getElement('[data-return="type"]').get( 'data-default' ) != 'video') {
								var _height = elm.setStyle('height', 'auto').getBoundingClientRect().height;
								elm.getParent().setStyle('height', _height);
								elm.getParent().getElements('input[data-return$=height_m]').set('data-default', _height);
								$$( '[data-return="height"][data-boxid="'+eltCounter+'"]' ).set('value', _height);
							}
						});

						$$('#content_box_' + eltCounter + ' > a.action').each(function(elm){
							if(elm.get('html') != '' && elm.getParent().getElements('[data-return="type"]')[0].get( 'data-default' ) != 'button_upload') {
								var _height = elm.setStyle('height', 'auto').getBoundingClientRect().height;
								elm.getParent().setStyle('height', _height);
								var _width = elm.setStyle('width', 'auto').getBoundingClientRect().width;
								elm.getParent().setStyle('width', _width);
								elm.setStyles({ 'width': '100%', 'height' : '100%'});
								elm.getParent().getElements('input[data-return$=height_m]').set('data-default', _height);
								elm.getParent().getElements('input[data-return$=width_m]').set('data-default', _width);
								elm.getParent().getElements('input[data-return$=height_a]').set('data-default', _height);
								elm.getParent().getElements('input[data-return$=width_a]').set('data-default', _width);
								$$( '[data-return="height"][data-boxid="'+eltCounter+'"]' ).set('value', _height);
								$$( '[data-return="width"][data-boxid="'+eltCounter+'"]' ).set('value', _width);
							}
							if( elm.getParent().getElements('[data-return="type"]')[0].get( 'data-default' ) == 'button_upload' 
								|| elm.getParent().getElements('[data-return="type"]')[0].get( 'data-default' ) == 'button_select' 
								|| elm.getParent().getElements('[data-return="type"]')[0].get( 'data-default' ) == 'button' 
							) {
								var updateSrc=$$( '[data-return="background-image"][data-boxid="'+eltCounter+'"]' )[0].get('value');
								elm.getParent().getElements('input[data-return="background-image"]').set('data-default', updateSrc);
								elm.setStyle('background-image', 'url('+updateSrc+')');
								console.log( eltCounter, eltCounter, updateSrc );
							}
						});

						if(currentItem.get('data-activateeditor') == 'lead_channels') {
							$(currentItem.get('data-editorelement')).set('value', $$('#content_box_' + eltCounter + ' [data-return="html"]')[0].get('data-default'));
						}

						if(currentItem.get('data-activateeditor') == 'ckeditor') {
							if($$('#content_box_' + eltCounter + ' [data-return="html"]')[0].get('data-name') != 'HTML'){
								var ckeditorInline = $('content_box_' + eltCounter).getChildren('.content');
								try{
									CKEDITOR.inline( ckeditorInline[0], {
										toolbar : 'Contentbox'
									} );
								}
								catch(e){}
							}
						}
					},
					onOpen:function( currentItem, collection ){
						console.log(currentItem);
						if( currentItem.get( 'data-movefrom' ) != null && currentItem.get( 'data-moveto' ) != null ){
							$$(currentItem.get( 'data-moveto' )).each(function(moveBox){
								if( moveBox.getParent().get('id') != currentItem.get( 'data-id' ) ){
									moveBox.empty();
									object.defaultCeraboxMove=$( currentItem.get( 'data-movefrom' ) ).get('html');
									$( currentItem.get( 'data-movefrom' ) ).empty();
									moveBox.set('html', object.defaultCeraboxMove);
									if( currentItem.get( 'data-activateeditor' ) == 'ckeditor' ){
										var ckObject=CKEDITOR.replace( $( currentItem.get( 'data-editorelement' ) ), {
											toolbar : 'Contentbox'
										});
									}
									if( currentItem.get( 'data-activateeditor' ) == 'formeditor' ){
										var formEditorObject=$( currentItem.get( 'data-editorelement' ) );
										if( $('formeditor_'+currentItem.get( 'data-id' )) == null ){
											var formEditorParent=formEditorObject.getParent();
											formEditorParent.adopt( new Element( 'div',{
												'id': 'formeditor_'+currentItem.get( 'data-id' )
											}).adopt([
												new Element( 'div', {'class':'fe_tabs','styles':{'display':'block'}}).adopt([
													new Element( 'div',{'html':'<a class="fe_open" id="open_source" href="#source">Rendered source</a>'} ),
												//	new Element( 'div',{'html':'<a class="fe_open" id="open_view" href="#view">View</a>'} ),
													new Element( 'div',{'html':'<a class="fe_open" id="open_settings" href="#settings">Settings</a>'} )
												]),
												new Element( 'div', {'class':'fe_blocks','id':'fe_open_source','styles':{'display':'block'}}).adopt( formEditorObject ),
											//	new Element( 'div', {'class':'fe_blocks','id':'fe_open_view','styles':{'display':'none'}}),
												new Element( 'div', {'class':'fe_blocks','id':'fe_open_settings','styles':{'display':'none'}})
											]));
										}else{
											var formEditorParent=$('formeditor_'+currentItem.get( 'data-id' )).getParent();
											$$('#fe_open_settings input[type="checkbox"]').each( function( eltch ){
												if( eltch.get('data-checked') ){
													eltch.checked=true;
												}else{
													eltch.checked=false;
												}
											});
											$$('#fe_open_settings input[type="checkbox"]').addEvent( 'change', function( evntch ){
												if( evntch.target.checked ){
													evntch.target.set( 'data-checked','checked' );
												}else{
													evntch.target.erase('data-checked');
												}
											});
										}
										var formOldValue='';
										formEditorParent.getElements( '.fe_open' ).each(function(eltfe){
											eltfe.addEvent('click', function( evtfe ){
												evtfe.stop();
												if( typeof evtfe.target.get('id') != 'undefined' && evtfe.target.get('id') == 'open_source' ){
													formOldValue=formEditorObject.get('value');
												}
												if( typeof evtfe.target.get('id') != 'undefined' && evtfe.target.get('id') == 'open_settings' ){
													if( formOldValue != formEditorObject.get('value') ){
														formOldValue=formEditorObject.get('value');
														new Request({
															url: '{/literal}{url name="site1_contentbox" action="create"}{literal}',
															method: 'post',
															onComplete: function(data){
																$('fe_open_settings').set('html', data );
																$$('#fe_open_settings input[type="checkbox"]').addEvent( 'change', function( evntch ){
																	if( evntch.target.checked ){
																		evntch.target.set( 'data-checked','checked' );
																	}else{
																		evntch.target.erase('data-checked');
																	}
																});
															}
														}).post({'data':formOldValue,'action':'show_form_settings'});
													}
												}
												if( typeof evtfe.target.get('id') != 'undefined' && $('fe_'+evtfe.target.get('id')) != null ){
													$$('.fe_blocks').hide();
													//console.log( 'fe_'+evtfe.target.get('id') );
													formEditorParent.getElementById('fe_'+evtfe.target.get('id')).show();
												}
											});
										});
									}
									if( currentItem.get( 'data-activateeditor' ) == 'lead_channels' ){
										$( currentItem.get( 'data-editorelement' ) ).addEvent('change', function() {
											var lead_channels = $(this);
											new Request({
												url: '{/literal}{url name="site1_contentbox" action="generate_lead_channels"}{literal}',
												method: 'post',
												onComplete: function(data){
													console.log(data);
													$$('#content_box_' + lead_channels.get('data-boxid') + ' > .content')[0].set('html', JSON.parse(data));
													var elm = $$('#content_box_' + lead_channels.get('data-boxid') + ' > .content')[0];
													var _height = elm.setStyle('height', 'auto').getBoundingClientRect().height;
													elm.getParent().setStyle('height', _height);
													elm.getParent().getElements('input[data-return$=height_m]').set('data-default', _height);
													elm.getParent().getElements('input[data-return$=html]').set('data-default', lead_channels.get('value'));
													$$( '[data-return="height"][data-boxid="'+lead_channels.get('data-boxid')+'"]' ).set('value', _height);
												}
											}).post({'id':lead_channels.get('value')});
											$$('#content_box_' + lead_channels.get('data-boxid') + ' [data-return="html"]')[0].set('data-default', lead_channels.get('value'));
										});
									}
									// тут экшны на сохранение
									moveBox.getElementById( currentItem.get( 'data-savebutton' ) ).addEvent( 'click', function( evnt ){
										var dataString='';
										if( currentItem.get( 'data-activateeditor' ) == 'video_editor' ){
											dataString=$( currentItem.get( 'data-editorelement' ) ).get('value');
											elementTarget.set( 'html', dataString );
											var videoElement=elementTarget.getElements('iframe, video, embed')[0][0];
											if(videoElement !== undefined) {
												$$('input[name="arrSettings['+currentItem.get( 'data-boxid' )+'][height]"]')[0].set('value',videoElement.offsetHeight);
												$$('input[name="arrSettings['+currentItem.get( 'data-boxid' )+'][height]"]')[0].fireEvent('change',{'target':$$('input[name="arrSettings['+currentItem.get( 'data-boxid' )+'][height]"]')[0]});
												$$('input[name="arrSettings['+currentItem.get( 'data-boxid' )+'][width]"]')[0].set('value',videoElement.offsetWidth);
												$$('input[name="arrSettings['+currentItem.get( 'data-boxid' )+'][width]"]')[0].fireEvent('change',{'target':$$('input[name="arrSettings['+currentItem.get( 'data-boxid' )+'][width]"]')[0]});
												videoElement.set('width','100%');
												videoElement.set('height','100%');
												dataString=videoElement.outerHTML;
											}
										} else if( currentItem.get( 'data-activateeditor' ) == 'formeditor' ){
											var formValues=formEditorObject.get('value');
											var formOptions=formEditorObject.getParent().getParent().getElements('input[name^="settings[form_autoresponder"]');
											var jsonSend={'form':formValues,'options':{}};
											formOptions.each( function( senddataElement ){//sendelt
												var arrData=senddataElement.get('name').match( /settings\[(.*?)\]\[(.*?)\]/ );
												if( typeof jsonSend.options[arrData[1]] == 'undefined' ){
													jsonSend.options[arrData[1]]={};
												}
												if( senddataElement.get('type')=='checkbox' ){
													jsonSend.options[arrData[1]][arrData[2]]=senddataElement.get('checked');
												}else{
													jsonSend.options[arrData[1]][arrData[2]]=senddataElement.get('value');
												}
											});
											dataString=formEditorObject.get('value');
											new Request({
												url: '{/literal}{url name="site1_contentbox" action="create"}{literal}',
												method: 'post',
												async: false,
												onComplete: function(data){
													dataString=data;
												}
											}).post({'data':jsonSend,'action':'show_form'});
										}else if( currentItem.get( 'data-activateeditor' ) == 'lead_channels' ){
											var lead_channels = $( currentItem.get( 'data-editorelement' ) );
											new Request({
												url: '{/literal}{url name="site1_contentbox" action="generate_lead_channels"}{literal}',
												method: 'post',
												onComplete: function(data){
													$$('#content_box_' + lead_channels.get('data-boxid') + ' > .content')[0].set('html', JSON.parse(data));
													var elm = $$('#content_box_' + lead_channels.get('data-boxid') + ' > .content')[0];
													var _height = elm.setStyle('height', 'auto').getBoundingClientRect().height;
													elm.getParent().setStyle('height', _height);
													elm.getParent().getElements('input[data-return$=height_m]').set('data-default', _height);
													elm.getParent().getElements('input[data-return$=html]').set('data-default', lead_channels.get('value'));
													$$( '[data-return="height"][data-boxid="'+lead_channels.get('data-boxid')+'"]' ).set('value', _height);
												}
											}).post({'id':lead_channels.get('value')});
										}
										else if( currentItem.get( 'data-activateeditor' ) == 'ckeditor' ){
											dataString=ckObject.getData();
										}else{
											dataString=$( currentItem.get( 'data-editorelement' ) ).get('value');
										}
										$( currentItem.get( 'data-editorelement' ) ).set( 'html', dataString );
										if( currentItem.get( 'data-runparser' ) ){
											dataString=object.parseData( currentItem.get( 'data-runparser' ), dataString );
										}
										elementTarget.set( dataElement.get( 'data-return' ), dataString );
										//---
										moveBox.getElements( '.cke' ).each( function(destroyElt){ destroyElt.destroy();} );
										object.defaultCeraboxMove=moveBox.get('html');
										window.CeraBoxWindow.close();
									});
								}
							});
						}
					},
				}
			});
			if( dataElement.get( 'data-openoncreate' ) == 'true' && typeof object.settingsDefault[dataElement.get( 'data-return' )] == 'undefined' ){
				object.simulateClick( buttonOpenPopup );
			}
			buttonOpenPopup=new Element('div');
		}
		if( dataElement.get( 'data-type' ) == 'number' 
		|| dataElement.get( 'data-type' ) == 'text'
		|| dataElement.get( 'data-type' ) == 'select' ){
			if( dataElement.get( 'data-return' ) == 'z-index' ){
				object.zIndexElement='z-index-'+boxid+addActionOptNmae;
				elementEditor.set( 'id', object.zIndexElement );
			}
			elementEditor.addEvent( 'change', function( evnt ){
				object.eventInpuTextChange( boxid, dataElement.get( 'data-return' ), evnt.target.get( 'value' ) );
				// экшн на изменение настроек закончен
			});
			// тут вставляем исходные свойства элемента
			if( dataElement.get( 'data-return' ) == 'z-index' && !dataElement.get( 'data-default' ) ){
				elementEditor.set( 'value', boxid );
				elementTarget.setStyle( dataElement.get( 'data-return' ), elementEditor.get( 'value' ) );
			}else{
				elementEditor.set( 'value', dataElement.get( 'data-default' ) );
				elementTarget.setStyle( dataElement.get( 'data-return' ), dataElement.get( 'data-default' ) );
			}
			if( dataElement.get( 'data-return' ) == 'form_name' ){
				elementEditor.set( 'value', 'form_name_'+boxid );
				elementEditor.set( 'disabled', 'disabled' );
				// заполняем все элементы завязанные брать эти данные 
				
				//elementTarget.setStyle( dataElement.get( 'data-return' ), elementEditor.get( 'value' ) );
			}
			if( addDefaultValue ){
				// запрашиваем место куда будет внесено исходное значение
				if( dataElement.get( 'data-return' ) == 'border-width' 
				&& elementTarget.getStyle( 'border-style' )[0] != 'none none none none' 
				&& elementTarget.getStyle( 'border-style' )[0] != 'none' ){
					/*elementTarget.setStyle( 'top', "-"+dataTail.replace( '[data]', dataElement.get( 'data-default' ) ) );
					elementTarget.setStyle( 'left', "-"+dataTail.replace( '[data]', dataElement.get( 'data-default' ) ) );*/
				}
				if( dataElement.get( 'data-return' ) == 'border-style' 
				&& dataElement.get( 'data-return' )!='none' ){
					/*elementTarget.setStyle( 'top', "-"+elementTarget.getStyle( 'border-width' )[0] );
					elementTarget.setStyle( 'left', "-"+elementTarget.getStyle( 'border-width' )[0] );*/
				}
				if( dataElement.get( 'data-return' ) == 'padding' ){
					elementTarget.setStyle( 'margin', "-"+dataTail.replace( '[data]', dataElement.get( 'data-default' ) ) );
				}
			}
			// все настройки элемента перенесены
		}
		// Add mooRainbow
		if( dataElement.get( 'data-type' ) == 'color' ){
			var defaultColor="#ffffff";
			if( dataElement.get( 'data-default' ) ){
				defaultColor=dataElement.get( 'data-default' );
			}
			var colors = jsColorPicker( '#color_editor_'+boxid+'_'+dataElement.get( 'data-return' ), {
				customBG: defaultColor,
				readOnly: true,
				init: function(elm, _colors){ // colors is a different instance (not connected to colorPicker)
					elm.style.backgroundColor = elm.value;
					elm.style.color = _colors.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
				},
				displayCallback: function(_color, _mode, _options){
					object.colorpickerCallback( _color, _mode, _options );
				}
			});
			elementTarget.setStyle( dataElement.get( 'data-return' ), defaultColor );
			$( 'color_editor_'+boxid+'_'+dataElement.get( 'data-return' ) ).addEvent( 'change', function(  ){
				// тут напрямую устанавливать цвет блока
				elementTarget.setStyle( dataElement.get( 'data-return' ), defaultColor );
			});
		}
		if( dataElement.get( 'data-type' ) == 'scroll' ){
			var dataDev=1;
			if( dataElement.get( 'data-dev' ) > 1 ){
				dataDev=dataElement.get( 'data-dev' );
			}
			new Slider( $( 'slider_'+boxid+'_'+dataElement.get( 'data-return' ) ), $( 'slider_'+boxid+'_'+dataElement.get( 'data-return' ) ).getElement( '.slider_knob' ), {
				steps: dataElement.get( 'data-steps' ), 
				range: [dataElement.get( 'data-stepStart' ), dataElement.get( 'data-stepEnd' )], 
				wheel: true, 
				snap: true, 
				initialStep: parseInt( dataElement.get( 'data-default' ) ), // начальное значение
				onChange: function( val ){
					$( 'slider_editor_'+boxid+'_'+dataElement.get( 'data-return' ) ).set( 'value', val/dataDev );
					elementTarget.setStyle( dataElement.get( 'data-return' ), val/dataDev );
				}
			});
			$( 'slider_editor_'+boxid+'_'+dataElement.get( 'data-return' ) ).set( 'value', dataElement.get( 'data-default' )/dataDev );
		}
		if( dataElement.get( 'data-useinonaction') == 'true' ){
			if( $$('.setting_elt[data-onaction="'+dataElement.get( 'data-return' )+'"]').length > 0 ){
				$$('.setting_elt[data-onaction="'+dataElement.get( 'data-return' )+'"]').each(function(elmt){
					elmt
						.adopt( new Element( 'option', {'value':elementEditor.get('value'), 'html':elementEditor.get('value')/*, 'selected':flgOptionSelected*/}) );
				});
			}
		}
		// останавливаем экшны которые должнызапускаться по нажатию на элемент
		if( !object.flgHaveOnclickEvent ){
			elementTarget.addEvent('click', function( evnt ){
				return false;
			});
			object.flgHaveOnclickEvent=true;
		}
		jQuery('.selectpicker').selectpicker({
		  	style: 'btn-default',
		  	size: 4
		});
		{/literal}{/if}{literal}
	}, 
	
	colorpickerCallback:function( color, mode, options ) {
		if( options.input.hasClass( 'form-styles' ) ){
			console.log(this.generateStyle(options.input.get('data-formstyles')));
			console.log( options.input.get('data-elemetedit'), options.input.get('data-return') );
		}else{
			var elementTargetNew=$$( '#content_box_'+options.input.get( 'data-boxid' ) )[0];
			if( options.input.get( 'data-elementclass' ) ){ // TODO - Добавить в генератор
				elementTargetNew=$$( '#content_box_'+options.input.get( 'data-boxid' )+' .'+options.input.get( 'data-elementclass' ) );
			}
			elementTargetNew.setStyle( options.input.get( 'data-return' ), options.input.value );
		}
	}, 

	//генерация стилей для Lead Channels
	generateStyle : function( boxid, json ){
		var _backgroundColorInput = '', 
			_backgroundColorButton = '', 
			_borderColorInput = '',
			_borderColorButton = '',
			_colorInput = '', 
			_colorButton = '', 
			_fontSizeInput = 14,
			_fontSizeButton = 14,
			_borderWidthInput = 0,
			_borderStyleInput = 'none';
			_borderStyleButton = 'none';
			_fontFamily = '';
			_styles = '';

		var _moId = null;

		if( typeof json == 'undefined' || !json) {
			_fontFamily = ($$('.form-styles[data-return="font-family"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-return="font-family"][data-formstyles="'+boxid+'"]')[0].get('value') : '');
			_backgroundColorInput = ($$('.form-styles[data-elemetedit="input"][data-return="background-color"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="input"][data-return="background-color"][data-formstyles="'+boxid+'"]')[0].get('value') : '#ffffff');
			_backgroundColorButton = ($$('.form-styles[data-elemetedit="select"][data-return="background-color"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="select"][data-return="background-color"][data-formstyles="'+boxid+'"]')[0].get('value') : '#DDDDDD');
			_colorInput = ($$('.form-styles[data-elemetedit="input"][data-return="color"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="input"][data-return="color"][data-formstyles="'+boxid+'"]')[0].get('value') : '#8F8F8F');
			_colorButton = ($$('.form-styles[data-elemetedit="select"][data-return="color"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="select"][data-return="color"][data-formstyles="'+boxid+'"]')[0].get('value') : '#797979');
			_borderColorInput = ($$('.form-styles[data-elemetedit="input"][data-return="border-color"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="input"][data-return="border-color"][data-formstyles="'+boxid+'"]')[0].get('value') : '');
			_borderColorButton = ($$('.form-styles[data-elemetedit="button"][data-return="border-color"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="button"][data-return="border-color"][data-formstyles="'+boxid+'"]')[0].get('value') : '');
			_icons = ($$('.form-styles[data-formstyles="'+boxid+'"][type="checkbox"]')[0] != undefined ?$$('.form-styles[data-formstyles="'+boxid+'"][type="checkbox"]')[0].get('checked') : '');
			_fontSizeInput = ($$('.form-styles[data-elemetedit="input"][data-return="font-size"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="input"][data-return="font-size"][data-formstyles="'+boxid+'"]')[0].get('value') : 14);
			_fontSizeButton = ($$('.form-styles[data-elemetedit="button"][data-return="font-size"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="button"][data-return="font-size"][data-formstyles="'+boxid+'"]')[0].get('value') : 14);
			_borderWidthInput = ($$('.form-styles[data-elemetedit="input"][data-return="border-width"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="input"][data-return="border-width"][data-formstyles="'+boxid+'"]')[0].get('value') : 0);
			_borderWidthButton = ($$('.form-styles[data-elemetedit="button"][data-return="border-width"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="button"][data-return="border-width"][data-formstyles="'+boxid+'"]')[0].get('value') : 0);
			_borderStyleInput = ($$('.form-styles[data-elemetedit="input"][data-return="border-style"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="input"][data-return="border-style"][data-formstyles="'+boxid+'"]')[0].get('value') : 'none');
			_borderStyleButton = ($$('.form-styles[data-elemetedit="button"][data-return="border-style"][data-formstyles="'+boxid+'"]')[0] != undefined ? $$('.form-styles[data-elemetedit="button"][data-return="border-style"][data-formstyles="'+boxid+'"]')[0].get('value') : 'none');
			_moId = $$('#content_box_' + boxid + ' input[data-return="html"]')[0].get('data-default');
		} else {
			_fontFamily = typeof json.form_styles != 'undefined'&&json.form_styles.fontFamily != undefined ? json.form_styles.fontFamily : '';
			_backgroundColorInput = typeof json.form_styles != 'undefined'&&json.form_styles.backgroundColorInput != undefined ? json.form_styles.backgroundColorInput : '#ffffff';
			_backgroundColorButton = typeof json.form_styles != 'undefined'&&json.form_styles.backgroundColorButton != undefined ? json.form_styles.backgroundColorButton : '#DDDDDD';
			_colorInput = typeof json.form_styles != 'undefined'&&json.form_styles.colorInput != undefined ? json.form_styles.colorInput : '#000000';
			_colorButton = typeof json.form_styles != 'undefined'&&json.form_styles.colorButton != undefined ? json.form_styles.colorButton : '#797979';
			_borderColorInput = typeof json.form_styles != 'undefined'&&json.form_styles.borderColorInput != undefined ? json.form_styles.borderColorInput : '';
			_borderColorButton = typeof json.form_styles != 'undefined'&&json.form_styles.borderColorButton != undefined ? json.form_styles.borderColorButton : '';
			_fontSizeInput = typeof json.form_styles != 'undefined'&&json.form_styles.fontSizeInput != undefined ? json.form_styles.fontSizeInput : 14;
			_fontSizeButton = typeof json.form_styles != 'undefined'&&json.form_styles.fontSizeButton != undefined ? json.form_styles.fontSizeButton : 14;
			_borderWidthInput =typeof json.form_styles != 'undefined'&& json.form_styles.borderWidthInput != undefined ? json.form_styles.borderWidthInput : 0;
			_borderWidthButton = typeof json.form_styles != 'undefined'&&json.form_styles.borderWidthButton != undefined ? json.form_styles.borderWidthButton : 0;
			_borderStyleInput = typeof json.form_styles != 'undefined'&&json.form_styles.borderStyleInput != undefined ? json.form_styles.borderStyleInput : 'none';
			_borderStyleButton = typeof json.form_styles != 'undefined'&&json.form_styles.borderStyleButton != undefined ? json.form_styles.borderStyleButton : 'none';
			_icons = typeof json.form_styles != 'undefined'&&json.form_styles.icons != undefined ? json.form_styles.icons : '';
			_moId = parseInt(json.html);
		}
		
		if(_fontFamily != '') {
			_styles += '#form-' + _moId + ' { font-family: '+_fontFamily+'; }'; 
		}

		_styles += '#form-' + _moId + ' input { width: 100% !important; margin: 0; border: 0; margin-bottom: 10px; padding: 10px; border-radius: 5px; box-sizing: border-box; }\n';

		if(_backgroundColorInput != '') {
			_styles += '#form-' + _moId + ' input {background-color:'+_backgroundColorInput+';}\n';
		}
		if(_backgroundColorButton != '') {
			_styles += '#form-' + _moId + ' input[type="submit"] {background-color:' +_backgroundColorButton+ ';}\n';
		}
		if(_colorInput != '') {
			_styles += '#form-' + _moId + ' input {color:' +_colorInput+ ';}\n';
			_styles += '#form-' + _moId + ' input + span {color:'+_colorInput+'; display: inline-block;}\n';
			_styles += '#form-' + _moId + ' input::-webkit-input-placeholder {color:'+_colorInput+';}\n';
			_styles += '#form-' + _moId + ' input::-moz-placeholder          {color:'+_colorInput+';}\n';
			_styles += '#form-' + _moId + ' input:-moz-placeholder           {color:'+_colorInput+';}\n';
			_styles += '#form-' + _moId + ' input:-ms-input-placeholder      {color:'+_colorInput+';}\n';
		}
		if(_colorButton != '') {
			_styles += '#form-' + _moId + ' input[type="submit"] {color:' +_colorButton+ ';}\n';
		}

		if(_icons){
			_styles += '#form-' + _moId + ' input[type="text"] {padding-left: 40px;}\n';
			_styles += '#form-' + _moId + ' input[type="text"] + span:before { content: "\\f190"; color: inherit; position: absolute; left: 0; margin: -20px 9px 0; font-size: 21px; display: inline-block; font-family: "Material-Design-Iconic-Font"; text-rendering: auto; -webkit-font-smoothing: antialiased;}\n';
			_styles += '#form-' + _moId + ' input[name="email"] + span:before { content: "\\f15a";}\n';
			_styles += '#form-' + _moId + ' input[name="name"] + span:before { content: "\\f207";}\n';
		}

		if(_borderColorInput != ''){
			_styles += '#form-' + _moId + ' input[type="text"] { border-color: '+_borderColorInput+'; }\n';
		}

		if(_borderColorButton!= ''){
			_styles += '#form-' + _moId + ' input[type="submit"] { border-color: '+_borderColorButton+'; }\n';
		}

		_styles += '#form-' + _moId + ' input[type="text"] { border-width: '+_borderWidthInput+'px; }\n';
		_styles += '#form-' + _moId + ' input[type="submit"] { border-width: '+_borderWidthButton+'px; }\n';
		_styles += '#form-' + _moId + ' input[type="text"] { border-style: '+_borderStyleInput+'; }\n';
		_styles += '#form-' + _moId + ' input[type="submit"] { border-style: '+_borderStyleButton+'; }\n';
		_styles += '#form-' + _moId + ' input[type="text"] { font-size: '+_fontSizeInput+'px; }\n';
		_styles += '#form-' + _moId + ' input[type="submit"] { font-size: '+_fontSizeButton+'px; }\n';

		$$('#content_box_' + boxid + ' style')[0].set('html', _styles);
	},

	flgHaveOnclickEvent:false,
	
	simulateClick:function(elt) {
	  var evt;
	  if (document.createEvent) { // DOM Level 2 standard
			evt=document.createEvent("MouseEvents");
			evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
			elt.dispatchEvent(evt);
		} else if (elt.fireEvent) { // IE
			elt.fireEvent('onclick');
		}
	},
	
	eventInpuTextChange:function ( boxid, boxreturn, boxvalue ){
		var dataElement=$$( '#content_box_'+boxid+' .options_block .setting_def_elt[data-return="'+boxreturn+'"]' )[0];
		if( typeof dataElement == 'undefined' ){
			return false;
		}
		var elementTarget=$$( '#content_box_'+boxid )[0];
		if( dataElement.get( 'data-elementclass' ) ){
			elementTarget=$$( '#content_box_'+boxid+' .'+dataElement.get( 'data-elementclass' ) );
		}
		var dataTail='[data]';
		if( dataElement.get( 'data-tail' ) ){
			dataTail=dataElement.get( 'data-tail' );
		}
		// запрашиваем место куда будет внесено изменение
		if( dataElement.get( 'data-returntype' ) == 'attr' ){
			elementTarget.set( dataElement.get( 'data-return' ), dataTail.replace( '[data]', boxvalue ) );

		}else{
			elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', boxvalue ) );
			if(dataElement.get('data-return').indexOf('_a') || dataElement.get('data-return').indexOf('_m')) {
				var dataSetting = dataElement.get( 'data-return' ).substring(0, dataElement.get( 'data-return' ).length - 2);
				elementTarget.setStyle( dataSetting, dataTail.replace( '[data]', boxvalue ) );
			} else {
				elementTarget.setStyle( dataElement.get( 'data-return' ), dataTail.replace( '[data]', boxvalue ) );
			}
		}
		if( dataElement.get( 'data-return' ) == 'button_text' ) {
			elementTarget.getElement('input[type="submit"]').set('value', $$('[data-return="button_text"][data-boxid="'+boxid+'"]')[0].get('value'));
		}
		// подстройка расположений блоков из-за некоторый настроек свойств
		if( dataElement.get( 'data-return' ) == 'border-width' 
		&& elementTarget.getStyle( 'border-style' )[0] != 'none none none none' 
		&& elementTarget.getStyle( 'border-style' )[0] != 'none' ){
			/*elementTarget.setStyle( 'top', "-"+dataTail.replace( '[data]', boxvalue ) );
			elementTarget.setStyle( 'left', "-"+dataTail.replace( '[data]', boxvalue ) );*/
		}
		if( dataElement.get( 'data-return' ) == 'border-style' 
		&& dataElement.get( 'data-return' )!='none' ){
			/*elementTarget.setStyle( 'top', "-"+elementTarget.getStyle( 'border-width' )[0] );
			elementTarget.setStyle( 'left', "-"+elementTarget.getStyle( 'border-width' )[0] );*/
		}
		if( dataElement.get( 'data-return' ) == 'padding' ){
			elementTarget.setStyle( 'margin', "-"+dataTail.replace( '[data]', boxvalue ) );
		}
	},
	
	moveSettings:function ( boxid ){
		var object=this;
		{/literal}{if isset($smarty.get.local_data)}{literal}
		this.openSettings( boxid );
		{/literal}{/if}{literal}
		var thisSettingsMenu=new Element( 'div', {
			'class':'all_settings_blocks settings_blocks_'+boxid
		});
		{/literal}{if isset($smarty.get.local_data)}{literal}
		$( 'settings_menu' ).adopt(thisSettingsMenu);
		{/literal}{/if}{literal}
		object.flgHaveOnclickEvent=false;

		$$( '#content_box_'+boxid+' .options_block .setting_def_elt' ).each( function( elt ){
			//console.log(elt);
			object.addSettingsElement( elt, thisSettingsMenu, boxid );
		});
		{/literal}{if isset($smarty.get.local_data)}{literal}
		$$('.tabs-left>li').removeClass('active');
		$$('.tabs-left>li>a[href="#settings_menu"]').getParent().addClass('active');
		$$('.tab-pane').removeClass('active');
		$( 'settings_menu' ).addClass('active');
		/*$('hide_settings_menu_block').setStyle('right','331px');*/
		{/literal}{/if}{literal}
		object.runShowActions();
	},	
	
	{/literal}{if isset($smarty.get.local_data)}{literal}
	// далее функции редактора
	addSortabler:function ( dataTarget ){
		var object=this;
		var dragDropElt=new Element( 'div', {
			'class':'component_box',
			'id': 'component_box_'+object.cbCounter,
			'data-id': object.cbCounter,
			'html': '<div class="component_block">\
					<div class="text">'+object.strip( $$('.settings[data-target="'+dataTarget+'"]')[0].get('html') )+' #'+object.cbCounter+'</div>\
					<div class="remove"><i class="ion-trash-a" style="font-size: 20px; vertical-align: bottom; color: #AC1111; margin: 0 5px;"></i></div>\
					<div class="dublicate"><i class="ion-ios7-copy-outline" style="font-size: 20px; vertical-align: bottom; color: #99AABB; margin: 0 5px;"></i></div>\
				</div>',
			'styles':{
				'padding': '5px'
			}
		});
		var disposionComponents=$( 'components_menu' ).getElements( '.component_box' );
		var disposionComponentsLength=disposionComponents.length;
		if( disposionComponentsLength > 0 ){
			var addElementFlg=false;
			var breakEachFlg=false;
			disposionComponents.each(function(elt){
				if( !breakEachFlg ){
					if( $( 'z-index-'+elt.get( 'data-id' )).get('value') <= $( 'z-index-'+ object.cbCounter).get('value') ){
						dragDropElt.inject(elt, 'before');
						addElementFlg=true;
						breakEachFlg=true; // break from each
					}
				}
			});
			if( !addElementFlg ){
				$( 'components_menu' ).grab(dragDropElt,'top');
			}
		}else{
			$( 'components_menu' ).grab(dragDropElt,'top');
		}
		/*$( 'components_menu' ).show();*/
		
		/*$('hide_components_menu_block').setStyle('right','331px');*/
		dragDropElt.addEvents({
			'mouseenter':function(evntdd){
				evntdd.target.setStyle('background-color','#aaa');
			},
			'mouseleave':function(evntdd){
				evntdd.target.setStyle('background-color','transparent');
			},
			'click':function(evntdd){
				if( evntdd.target.getParent('.component_box') ){
					object.openSettings( evntdd.target.getParent('.component_box').get('data-id') );
					var contentTarget=$('content_box_'+evntdd.target.getParent('.component_box').get('data-id'));
					$$( '.grip_block' ).hide(  );
					$$( '.action_block' ).hide(  );
					contentTarget.getElements( '.grip_block' ).show(  );
					contentTarget.getElements( '.action_block' ).show(  );
					object.lastElementSelected=contentTarget;
					object.lastElementSelected.cboxid=evntdd.target.getParent('.component_box').get('data-id');
				}
			}
		});
		new Sortables(
			'components_menu', { 
			onComplete: function(element, clone){
				var disposionComponents=$( 'components_menu' ).getElements( '.component_box' );
				var disposionComponentsLength=disposionComponents.length;
				disposionComponents.each(function(elt){
					var addActionOptNmae='';
					if( elt.get( 'data-optionclass' ) ){
						addActionOptNmae='['+elt.get( 'data-optionclass' )+']';
					}
					$( 'z-index-'+elt.get( 'data-id' )).set('value',disposionComponentsLength);
					object.eventInpuTextChange( $( 'z-index-'+elt.get( 'data-id' )).get( 'data-boxid' ), $( 'z-index-'+elt.get( 'data-id' )).get( 'data-return' ), $( 'z-index-'+elt.get( 'data-id' )).get( 'value' ) );
					disposionComponentsLength--;
				});
			}
		});
	},
	
	addBlockActions:function( boxid ){
		var object=this;
		$$( '#content_box_'+boxid ).addEvent( 'mouseenter', function( evt ){
			if($$('div.selectionBox')[0] !== undefined) 
				return false;
			if( object.lastElementSelected == false ){
				evt.target.getElements( '.grip_block' ).show(  );
				evt.target.getElements( '.action_block' ).show(  );
				evt.target.getElements( '.move-icon' ).show();
				object.lastElementSelected=$( evt.target );
				object.lastElementSelected.cboxid=boxid;

				if(evt.target.getElements('.cke_editable')[0] !== undefined) {
					evt.target.getElements('.cke_editable')[0].getNext('.overlay').hide();
				}
			}
		});
		$$( '#content_box_'+boxid ).addEvent( 'mouseleave', function( evt ){
			if($$('div.selectionBox')[0] !== undefined) 
				return false;
			if( object.lastElementResize == false && object.lastElementMove == false ){
				$$( '.grip_block' ).hide(  );
				$$( '.action_block' ).hide(  );
				$$( '.move-icon' ).hide();
				object.lastElementSelected=false;

				if(evt.target.getElements('.cke_editable')[0] !== undefined) {
					evt.target.getElements('.cke_editable')[0].getNext('.overlay').show();
				}
			}
		});
		$$( '#content_box_'+boxid ).addEvent( 'mouseup', function( evt ){
			if( object.lastElementResize == false ){
				object.hookBox( evt, 'clear_elt' );
			}
			object.changePositionSettings( boxid );
			object.openSettings( boxid );
		});
		$$( '#content_box_'+boxid ).addEvent( 'mousedown', function( evt ){
			if( object.lastElementResize == false ){
				object.mouseMoveY = evt.event.y;
				object.mouseMoveX = evt.event.x;
				if(evt.target.hasClass('ti-move')) {
					object.flagMoved = true;
				} else {
					object.flagMoved = false;
				}
				object.hookBox( evt, 'lock_elt' );
			}
		});
		$$( '#content_box_'+boxid ).addEvent( 'dblclick', function( evt ){
			if( object.lastElementMove == false ){
				object.openOnDblClick( boxid );
			}
		});
		$$( '#content_box_'+boxid+' .grip_block' ).each( function( elt ){
			elt.addEvent( 'mouseup', function( evt ){
				object.hookResize( evt, 'clear_elt' );
			});
			elt.addEvent( 'mousedown', function( evt ){
				object.hookResize( evt, 'lock_elt' );
			});
		});
		$$( '#content_box_'+boxid+' .remove, #component_box_'+boxid+' .remove' ).addEvent( 'click', function( evt ){
			if( confirm( 'Are you sure you would like to delete this?' ) ){
				if($$('.content_box.selected').length > 0) {
					$$('.content_box.selected').each(function(elm){
						object.removeBlock( parseInt($$('.content_box.selected')[0].get('id').substring(12)) );
					});
				} else 
					object.removeBlock( boxid );
			}
		});
		$$( '#content_box_'+boxid+' .dublicate, #component_box_'+boxid+' .dublicate' ).addEvent( 'click', function( evt ){
			if($$('.content_box.selected').length > 0) {
				$$('.content_box.selected').each(function(elm){
					object.dublicateBlock( parseInt(elm.get('id').substring(12)) );
				});
			} else 
				object.dublicateBlock( boxid );
		});

		$$( '#content_box_'+boxid+' .edit, #component_box_'+boxid+' .edit' ).addEvent( 'click', function( evt ){
			
			jQuery('.setting-tabs').stop(true, true).animate({
				right : "0px"
			}, "fast", function(){
				jQuery('.sideways > li:not(:first-child)').removeClass('hidden');
			});
		
			jQuery('#close').children('i').toggleClass('fa-arrow-circle-down').toggleClass('fa-arrow-circle-up');

			$$('.tabs-left>li').removeClass('active');
			$$('.tabs-left>li>a[href="#settings_menu"]').getParent().addClass('active');
			$$('.tab-pane').removeClass('active');
			$( 'settings_menu' ).addClass('active');

		});
	}, 
	
	removeBlock:function( boxid ){
		$$( '#content_box_'+boxid+' .options_block .setting_elt' ).each( function( elt ){
			if( elt.get( 'data-type' ) == 'color' ){
				// надо удалить блоки id созданные mooRainbow
				$$( '#box-color_editor_'+boxid+'_'+elt.get( 'data-return' ) ).destroy(  );
			}
			
			// внимательно смотреть что удалять
		});
		$( 'content_box_'+boxid ).destroy(  );
		$( 'component_box_'+boxid ).destroy(  );
		$$( '.settings_blocks_'+boxid ).destroy(  );
	}, 
	
	dublicateBlock:function( boxid ){
		var object=this;
		object.cbCounter+=1;
		//var cbNumber=$$( '.content_box' ).length;
		// переносим текущие свойства элемента - в начальные свойства его же
		$$( '.settings_blocks_'+boxid+' [name^="arrSettings["]' ).each( function( elt_from ){
			$$( '#content_box_'+boxid+' .options_block .setting_elt' ).each( function( elt_to ){
				var addActionOptNmae='';
				if( elt_to.get( 'data-optionclass' ) ){
					addActionOptNmae='['+elt_to.get( 'data-optionclass' )+']';
				}
				if( elt_from.get( 'name' ) == 'arrSettings['+boxid+']'+addActionOptNmae+'['+elt_to.get( 'data-return' )+']' ){
					var haveData=elt_from.get( 'value' );
					if( !haveData && elt_from.get( 'html' ) && elt_from.tagName.toLowerCase(  )!='select' ){
						haveData=elt_from.get( 'html' );
					}
					if( elt_from.tagName.toLowerCase(  )=='textarea' ){
						haveData=object.encode( haveData );
					}
					if( elt_to.get( 'data-dev' ) || false ){
						haveData=haveData*elt_to.get( 'data-dev' );
					}
					if( elt_to.get( 'data-return' ) == 'left' || elt_to.get( 'data-return' ) == 'top'){
						haveData=haveData+20;
					}
					elt_to.set( 'data-default', haveData );
				}
			});
		});
		var clone=$( 'content_box_'+boxid ).clone();
		clone.set( 'id', 'content_box_'+object.cbCounter );
		$$('.emulator')[0].adopt( clone );
		clone.getElements( 'input[data-return="left"]' )[0].set( 'data-default', clone.offsetLeft*1+20 );
		clone.getElements( 'input[data-return="top"]' )[0].set( 'data-default',clone.offsetTop*1+20 );
		clone.getElements( 'input[data-return="boxid"]' )[0].set( 'data-default',object.cbCounter );
		if(clone.getElements('input[data-return="html"]')[0] !== undefined){
			clone.getElements('input[data-return="html"]')[0].set('data-default', object.encode($$('#content_box_'+boxid+' .content')[0].get('html')));
			
		}
		this.moveSettings( object.cbCounter );

		object.addSortabler( $$( '#content_box_'+boxid+' .options_block input[data-return="type"]' )[0].get( 'data-default' ) ); 
		this.addBlockActions( object.cbCounter );

		jQuery('#emulator').customScroll('destroy').customScroll('init');
	}, 
	
	hookBox:function( evt, flg_type ){
		if( flg_type=='lock_elt' ){
			this.lastElementMove=true;
		}
		this.lastElementSelected.deltaX=evt.event.offsetX;
		this.lastElementSelected.deltaY=evt.event.offsetY;
		if( flg_type=='clear_elt' ){
			this.lastElementMove=false;
		}
	}, 

	hookResize:function ( evt, flg_type ){
		var elt=evt.srcElement || evt.target;
		if( flg_type=='lock_elt' ){
			this.lastElementResize=true;
			this.elementMoveType=elt.get( 'class' ).substring( 16 );
		}
		this.lastElementSelected.startX=( evt.type=='mousedown' ) ? ( evt.client.x/*+this.lastElementSelected.scrollLeft*/ ) : 0;
		this.lastElementSelected.startY=( evt.type=='mousedown' ) ? ( evt.client.y/*+this.lastElementSelected.scrollTop*/ ) : 0;
		this.lastElementSelected.startH=this.lastElementSelected.offsetHeight;
		this.lastElementSelected.startW=this.lastElementSelected.offsetWidth;

		// добавить начальный скрол позишн
		
		if( flg_type=='clear_elt' ){
			this.lastElementResize=false;
		}
	}, 
	flagMoved : false,
	moveBox:function ( evt ){
		if( this.lastElementSelected != false ){
			if(this.lastElementSelected.getElement('.cke_editable') !== null && !this.flagMoved) {
				this.lastElementSelected.getElement('.cke_editable').set('contenteditable', 'true');
				return false;
			} else {
				if(this.lastElementSelected.getElement('.cke_editable') !== null)
					this.lastElementSelected.getElement('.cke_editable').set('contenteditable', 'false');
			}
			var self = this;
			$$('.content_box.selected').each(function(elm){
				if( typeof elm.moveDeltaY == 'undefined' ){
					elm.moveDeltaY=self.mouseMoveY - elm.getStyle('top').toInt();
				}
				if( typeof elm.moveDeltaX == 'undefined' ){
					elm.moveDeltaX=self.mouseMoveX - elm.getStyle('left').toInt();
				}
				elm.setStyles({
					"top" :  (evt.client.y - elm.moveDeltaY) - $$('.emulator')[0].getBoundingClientRect().top, 
					"left" : (evt.client.x - elm.moveDeltaX ) - $$('.emulator')[0].getBoundingClientRect().left
				});

				if($('grid').get('checked')) {
					var coord_x = (parseInt(elm.style.left) / parseInt($('cell-size').get('value')));
					if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5) {
						elm.style.left = Math.floor(coord_x) * parseInt($('cell-size').get('value')) + 'px';
					}
					var coord_y = (parseInt(elm.style.top) / parseInt($('cell-size').get('value')));
					if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
						elm.style.top = Math.floor(coord_y) * parseInt($('cell-size').get('value')) + 'px';
					}
				}
			});

			var _scrollTop = $$('.emulator .custom-scroll_inner')[0].scrollTop;

			this.lastElementSelected.style.top=evt.client.y-this.lastElementSelected.deltaY - $$('.emulator')[0].getBoundingClientRect().top + _scrollTop +'px';
			this.lastElementSelected.style.left=evt.client.x-this.lastElementSelected.deltaX- $$('.emulator')[0].getBoundingClientRect().left +'px';

			var top = parseInt(evt.client.x) - parseInt(this.lastElementSelected.style.top);
			var left = parseInt(evt.client.y) - parseInt(this.lastElementSelected.style.left);

			if($('grid').get('checked')) {
				var coord_x = (parseInt(this.lastElementSelected.style.left) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.left = Math.floor(coord_x) * parseInt($('cell-size').get('value')) + 'px';
				}
				var coord_y = (parseInt(this.lastElementSelected.style.top) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.top = Math.floor(coord_y) * parseInt($('cell-size').get('value')) + 'px';
				}
			}

			if($$('.emulator')[0] !== undefined) {
				if(parseInt(this.lastElementSelected.style.left) < parseInt(0)) {
					this.lastElementSelected.style.left = 0 + 'px';
				}
				if(parseInt(this.lastElementSelected.style.top) < 0) {
					this.lastElementSelected.style.top = 0 + 'px';
				}
			}
		} else return false;
	}, 

	resizeBox:function( evt ){
		// для высоты учитывать текущий скролл позишн с начальный скрол позишном
		if( this.elementMoveType=='l' ){
			if( this.lastElementSelected.startX ){
				this.lastElementSelected.style.width=this.lastElementSelected.startW-( evt.client.x - this.lastElementSelected.startX ) +'px';
			}
			this.lastElementSelected.style.left=evt.client.x+'px';
			if($('grid').get('checked')) {
				var coord_x = (parseInt(this.lastElementSelected.style.left) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5){
					this.lastElementSelected.style.width=this.lastElementSelected.startW-( Math.floor(coord_x) * parseInt($('cell-size').get('value')) - this.lastElementSelected.startX ) +'px';
					this.lastElementSelected.style.left=Math.floor(coord_x) * parseInt($('cell-size').get('value'))+'px';
				}
			}
		}
		if( this.elementMoveType=='tl' ){
			if( this.lastElementSelected.startX ){
				this.lastElementSelected.style.width=this.lastElementSelected.startW-( evt.client.x - this.lastElementSelected.startX ) +'px';
			}
			this.lastElementSelected.style.left=evt.client.x+'px';
			if($('grid').get('checked')) {
				var coord_x = (parseInt(this.lastElementSelected.style.left) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5){
					this.lastElementSelected.style.width=this.lastElementSelected.startW-( Math.floor(coord_x) * parseInt($('cell-size').get('value')) - this.lastElementSelected.startX ) +'px';
					this.lastElementSelected.style.left=Math.floor(coord_x) * parseInt($('cell-size').get('value'))+'px';
				}
			}
			if( this.lastElementSelected.startY ){
				this.lastElementSelected.style.height=this.lastElementSelected.startH-( evt.client.y - this.lastElementSelected.startY ) +'px';
			}
			this.lastElementSelected.style.top=evt.client.y+'px';
			if($('grid').get('checked')) {
				var coord_y = (parseInt(this.lastElementSelected.style.top) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.height=this.lastElementSelected.startH-(  Math.floor(coord_y) * parseInt($('cell-size').get('value')) - this.lastElementSelected.startY ) +'px';
					this.lastElementSelected.style.top = Math.floor(coord_y) * parseInt($('cell-size').get('value')) + 'px';
				}
			}
		}
		if( this.elementMoveType=='bl' ){
			if( this.lastElementSelected.startX ){
				this.lastElementSelected.style.width=this.lastElementSelected.startW-( evt.client.x - this.lastElementSelected.startX ) +'px';
			}
			this.lastElementSelected.style.left=evt.client.x+'px';
			if($('grid').get('checked')) {
				var coord_x = (parseInt(this.lastElementSelected.style.left) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5){
					this.lastElementSelected.style.width=this.lastElementSelected.startW-( Math.floor(coord_x) * parseInt($('cell-size').get('value')) - this.lastElementSelected.startX ) +'px';
					this.lastElementSelected.style.left=Math.floor(coord_x) * parseInt($('cell-size').get('value'))+'px';
				}
			}
			if( this.lastElementSelected.startY ){
				this.lastElementSelected.style.height=evt.client.y-this.lastElementSelected.startY+this.lastElementSelected.startH+'px';
			}
			if($('grid').get('checked')) {
				var coord_y = ((parseInt(this.lastElementSelected.style.top) + parseInt(this.lastElementSelected.style.height)) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.height=Math.floor(coord_y) * parseInt($('cell-size').get('value'))-this.lastElementSelected.startY+this.lastElementSelected.startH+'px';
				}
			}
		}
		if( this.elementMoveType=='t' ){
			if( this.lastElementSelected.startY ){
				this.lastElementSelected.style.height=this.lastElementSelected.startH-( evt.client.y - this.lastElementSelected.startY ) +'px';
			}
			this.lastElementSelected.style.top=evt.client.y+'px';
			if($('grid').get('checked')) {
				var coord_y = (parseInt(this.lastElementSelected.style.top) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.height=this.lastElementSelected.startH-(  Math.floor(coord_y) * parseInt($('cell-size').get('value')) - this.lastElementSelected.startY ) +'px';
					this.lastElementSelected.style.top = Math.floor(coord_y) * parseInt($('cell-size').get('value')) + 'px';
				}
			}
		}
		if( this.elementMoveType=='tr' ){
			if( this.lastElementSelected.startY ){
				this.lastElementSelected.style.height=this.lastElementSelected.startH-( evt.client.y - this.lastElementSelected.startY ) +'px';
			}
			this.lastElementSelected.style.top=evt.client.y+'px';
			if($('grid').get('checked')) {
				var coord_y = (parseInt(this.lastElementSelected.style.top) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.height=this.lastElementSelected.startH-(  Math.floor(coord_y) * parseInt($('cell-size').get('value')) - this.lastElementSelected.startY ) +'px';
					this.lastElementSelected.style.top = Math.floor(coord_y) * parseInt($('cell-size').get('value')) + 'px';
				}
			}
			
			if( this.lastElementSelected.startX ){
				this.lastElementSelected.style.width=evt.client.x-this.lastElementSelected.startX+this.lastElementSelected.startW+'px';
			}
			this.lastElementSelected.style.top=evt.client.y+'px';
			if($('grid').get('checked')) {
				var coord_x = ((parseInt(this.lastElementSelected.style.left) + parseInt(this.lastElementSelected.style.width)) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5){
					this.lastElementSelected.style.width =  Math.floor(coord_x) * parseInt($('cell-size').get('value'))-this.lastElementSelected.startX+this.lastElementSelected.startW+'px';
				}
			}
		}
		if( this.elementMoveType=='b' ){
		
		console.log( this.lastElementSelected.startY );
		
			if( this.lastElementSelected.startY ){
				this.lastElementSelected.style.height=evt.client.y-this.lastElementSelected.startY+this.lastElementSelected.startH+'px';
			}
			if($('grid').get('checked')) {
				var coord_y = ((parseInt(this.lastElementSelected.style.top) + parseInt(this.lastElementSelected.style.height)) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.height=Math.floor(coord_y) * parseInt($('cell-size').get('value'))-this.lastElementSelected.startY+this.lastElementSelected.startH+'px';
				}
			}
		}
		if( this.elementMoveType=='r' ){
			if( this.lastElementSelected.startX ){
				this.lastElementSelected.style.width=evt.client.x-this.lastElementSelected.startX+this.lastElementSelected.startW+'px';
			}
			if($('grid').get('checked')) {
				var coord_x = ((parseInt(this.lastElementSelected.style.left) + parseInt(this.lastElementSelected.style.width)) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5){
					this.lastElementSelected.style.width =  Math.floor(coord_x) * parseInt($('cell-size').get('value'))-this.lastElementSelected.startX+this.lastElementSelected.startW+'px';
				}
			}
		}
		if( this.elementMoveType=='br' ){
			if( this.lastElementSelected.startX ){
				this.lastElementSelected.style.width=evt.client.x-this.lastElementSelected.startX+this.lastElementSelected.startW+'px';
			}
			if($('grid').get('checked')) {
				var coord_x = ((parseInt(this.lastElementSelected.style.left) + parseInt(this.lastElementSelected.style.width)) / parseInt($('cell-size').get('value')));
				if((coord_x - ( ~ ~ coord_x )).toFixed(2) <= 0.5){
					this.lastElementSelected.style.width =  Math.floor(coord_x) * parseInt($('cell-size').get('value'))-this.lastElementSelected.startX+this.lastElementSelected.startW+'px';
				}
			}
			if( this.lastElementSelected.startY ){
				this.lastElementSelected.style.height=evt.client.y-this.lastElementSelected.startY+this.lastElementSelected.startH+'px';
			}
			if($('grid').get('checked')) {
				var coord_y = ((parseInt(this.lastElementSelected.style.top) + parseInt(this.lastElementSelected.style.height)) / parseInt($('cell-size').get('value')));
				if((coord_y - ( ~ ~ coord_y )).toFixed(2) <= 0.5) {
					this.lastElementSelected.style.height=Math.floor(coord_y) * parseInt($('cell-size').get('value'))-this.lastElementSelected.startY+this.lastElementSelected.startH+'px';
				}
			}
		}
	}, 

	{/literal}{/if}{literal}
	decode:function( data ){	// // this.decode( 'U2xhdmEgU2xlcG92ICszNzUzMzY2OTE2MDU' );
		var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		var o1, o2, o3, h1, h2, h3, h4, bits, i=0, enc='';
		do {
			h1 = b64.indexOf( data.charAt( i++ ) );
			h2 = b64.indexOf( data.charAt( i++ ) );
			h3 = b64.indexOf( data.charAt( i++ ) );
			h4 = b64.indexOf( data.charAt( i++ ) );
			bits = h1<<18 | h2<<12 | h3<<6 | h4;
			o1 = bits>>16 & 0xff;
			o2 = bits>>8 & 0xff;
			o3 = bits & 0xff;
			if ( h3 == 64 )	  enc += String.fromCharCode( o1 );
			else if ( h4 == 64 ) enc += String.fromCharCode( o1, o2 );
			else			   enc += String.fromCharCode( o1, o2, o3 );
		} while ( i < data.length );
		return enc;
	}, 
	
	encode:function ( data ){	// Encodes data with MIME base64
		var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		var o1, o2, o3, h1, h2, h3, h4, bits, i=0, enc='';
		do {
			o1 = data.charCodeAt( i++ );
			o2 = data.charCodeAt( i++ );
			o3 = data.charCodeAt( i++ );
			bits = o1<<16 | o2<<8 | o3;
			h1 = bits>>18 & 0x3f;
			h2 = bits>>12 & 0x3f;
			h3 = bits>>6 & 0x3f;
			h4 = bits & 0x3f;
			enc += b64.charAt( h1 ) + b64.charAt( h2 ) + b64.charAt( h3 ) + b64.charAt( h4 );
		} while ( i < data.length );
		switch( data.length % 3 ){
			case 1:
				enc = enc.slice( 0, -2 ) + '==';
			break;
			case 2:
				enc = enc.slice( 0, -1 ) + '=';
			break;
		}
		return enc;
	},
	strip:function(html){
		var tmp = document.createElement("div");
		tmp.innerHTML = html;
		return tmp.textContent||tmp.innerText;
	}

});

new cbEditor();
}
{/literal}