/**
 * For display Categories Tree
 * User: Pavel
 * Date: 23.03.11
 * Time: 17:11
 */

var Categories = new Class({
	Implements: Options,
	options: {
		firstLevel: 'category',
		secondLevel: 'category_child',
		optionName1:'-select-',
		optionName2:'-select-',
		intCatId: null,
		jsonTree:null
	},
	initialize: function( options ){
		this.setOptions( options );
		this.arrCategories = new Hash( this.options.jsonTree );
		$(this.options.firstLevel).addEvent('change',function(){
			this.setFromFirstLevel( $(this.options.firstLevel).value );
		}.bind( this ) );
		if( this.options.intCatId!=null && this.checkLevel(this.options.intCatId) ) {
			this.setFromFirstLevel( this.options.intCatId );
		} else if( this.options.intCatId!=null ) {
			this.setFromSecondLevel( this.options.intCatId );
		}
	},
	checkLevel: function( id ){
		var bool=false;
		this.arrCategories.each( function( el ){
			if( el.id == id ) { bool=true; }
		} );
		return bool;
	},
	setFromFirstLevel: function( id ){
		// если изменен элемент 1 уровня, то второй уровень обнуляется
		$( this.options.secondLevel ).empty();
		var option = new Element( 'option[value="0"][html="'+this.options.optionName2+'"]' );
		option.inject( $(this.options.secondLevel) );
		
		this.arrCategories.each( function( item ){
			if( item.id == id ) {
				Array.from( $(this.options.firstLevel).options ).each( function(i){
					if(i.value == id){
						i.selected=1;
					}
				});
				var hash = new Hash( item.node );
				hash.each(function( i,k ){
					var option = new Element( 'option[value="'+i.id+'"][html="'+i.title+' '+((i.count)?'('+i.count+')':'')+'"]' );
					if( i.id == this.options.intCatId ){
						option.selected=1;
					}
					option.inject( $(this.options.secondLevel) );
				},this );
			}
		},this );
		jQuery('.selectpicker').selectpicker('refresh');
	},
	setFromSecondLevel: function( id ) {
		this.arrCategories.each( function( item ){
			var hash = new Hash(item.node);
			hash.each( function( el ){
				if ( id == el.id ) {
					this.setFromFirstLevel( el.pid );
				}
			},this );
		},this );
		jQuery('.selectpicker').selectpicker('refresh');
	}
});

/**
 * For create Category selects
 * User: Pavel & Slava
 * Date: 19.05.11
 * Time: 17:11
 */

var CategoriesSelects=new Class({
	Implements: Options,
	options: {
		language : '',
		category_parent : '',
		category_child : '',
		optionName1:'-select-',
		optionName2:'-select-',
		post_settings : '',
		request_url : '',
		selected : {
			parent_id : 0,
			child_id : 0
		}
	},
	initialize: function(options){
		this.setOptions( options );
		this.initEvents();
	},
	initEvents: function(){
		$(this.options.language).addEvent('change',function(e){
			if( $(this.options.language).get('value') > 0 ){
				this.setLanguage( $(this.options.language).get('value') );
			}
		}.bind(this));
		$(this.options.language).fireEvent('change');
	},
	setLanguage: function(lang){
		this.getCategory2Lang(lang);
	},
	getCategory2Lang: function(lang){
		var request_options = this.options.post_settings;
		request_options.lang = lang;
		var request_parent = this.options.category_parent;
		var request_child = this.options.category_child;
		var parent_id = this.options.selected.parent_id;
		var child_id = this.options.selected.child_id;
		var request_url = this.options.request_url;
		var first_lavel = this.options.category_parent;
		var second_lavel = this.options.category_child;
		var language = this.options.language;
		var optionName1 = this.options.optionName1;
		var optionName2 = this.options.optionName2;
		var r=new Request.JSON({
			url: request_url,
			onRequest: function(){
				$(request_parent).disabled=true;
				$(request_child).disabled=true;
				var img=new Element( 'img[src="/skin/i/frontends/design/ajax_loader_line.gif"][id="loader"]' );
				img.inject($(language).getPrevious('label'),'bottom');
			},
			onSuccess: function(hash){
				$(request_parent).empty();
				$(request_child).empty();
				new Element('option[value=""][html="'+optionName1+'"][selected="selected"]').inject($(request_parent),'bottom');
				new Element('option[value=""][html="'+optionName2+'"][selected="selected"]').inject($(request_child),'bottom');
				Object.each(hash,function(item){
					if(item.level>1){
						return;
					}
					var option=new Element('option[value="'+item.id+'"][html="'+item.title+' '+((item.count)?'('+item.count+')':'')+'"]');
					if (item.id == parent_id){
						option.set('selected', 'selected');
						hashch = new Hash(item.node);
						hashch.each(function(itemchild){
							var option=new Element('option[value="'+itemchild.id+'"][html="'+itemchild.title+' "]');
							if (itemchild.id == child_id){
								option.set('selected', 'selected');
							}
							option.inject($(request_child),'bottom');
						});
					}
					option.inject($(request_parent),'bottom');
				});
				new Categories({
					firstLevel: first_lavel,
					secondLevel: second_lavel,
					intCatId: child_id,
					optionName1:optionName1,
					optionName2:optionName2,
					jsonTree: hash
				});
			},
			onComplete: function(){
				$(request_parent).disabled=false;
				$(request_child).disabled=false;
				if( $('loader') ){
					$('loader').destroy();
				}
			},
		}).post( request_options );
	}
});
