{literal}
var mootools=document.createElement('SCRIPT');
mootools.type="text/javascript";
mootools.src='{/literal}{$host}{literal}/skin/_js/mootools.js';
document.getElementsByTagName('head')[0].appendChild(mootools);
var checkMooTools=function(){ try{ if( MooTools.version ) init(); }catch(e){ setTimeout('checkMooTools()',50); } }
checkMooTools();
function init(){

	var Hiam=new Class({
		Implements: Options,
		options: {
			id:'',
			host:'',
			dir:'',
			flash: {
				/**
				 * Backgroung for corners;
				 */
				image:'',
				/**
				 * Play sound:
				 * 0 - none; 1- play;
				 */
				flgSound:0,
				/**
				 * Path to file sound;
				 */
				sound:''
			},
			css:{
				width:'auto',
				height:'auto',
				border: {
					/**
					 * width border:
					 * 1-Thin; 2-Medium; 3-Thick;
					 */
					width:1,
					/**
					 * Border style:
					 * 1-None; 2-Dotted; 3-Dashed; 4-Solid; 5-Double; 6-Groove; 7-Ridge; 8-Inset; 9-Outset;
					 */
					style:1,
					color:''
				},
				background:{
					/**
					 * Path to image file;
					 */
					image:'',
					color:''
				},
				lightbox:1
			},
			close:{
				text:'',
				color:''
			},
			cookie:{
				name: 'cnm-hiam',
				expires: 0,
				path:'/'
			},
			flgWidth:0,
			flgHeight:0,
			/**
			 * Floating effect:
			 * 0-No; 1-Yes;
			 */
			flgFloating:0,
			/**
			 * Display banner:
			 *  0-Always; 1-Once Per Session;
			 */
			flgDisplay:0,
			/**
			 * Open window:
			 * 0-new; 1-same;
			 */
			flgWindow:0,

			/**
			 * URL for campaign;
			 */
			url:'',
			/**
			 * 	Position for fixed campaign:
			 * 	1 - Top;
			 * 	2 - Bottom;
			 */
			fixPosition: 1,
			/**
			 * 	Position for corner compaign:
			 * 	1 - Top Left;
			 * 	2 - Top Right;
			 * 	3 - Bottom Left;
			 * 	4 - Bottom Right;
			 */
			cornerPositeion: 1,

			/**
			 * Content for slide type
			 */
			contentSlide: '',
			
			/**
			 * Content for fixed type
			 */
			contentFix: '',
			/**
			 * Wen view banner:
			 * 0-On Load; 1-When User Leaves the Page;
			 */
			flgAction:0,
			/**
			 * View Slide type;
			 */
			viewSlide:1,
			/**
			 * View Corner type;
			 */
			viewCorner:0,
			/**
			 * View Fixed type;
			 */
			viewFix:0,
			/**
			 * Top: px;
			 */
			slidePos: 0
		},

		initialize: function( options ){
			this.setOptions( options );
			if( this.options.flgDisplay == 1 && this._checkCookie('id') ){
				return false;
			}

			this.initEvents();
			this._saveCookie('id',this.options.id);
		},

		initEvents: function(){
			if( this.options.flgAction == 1){
				$$('a').addEvent('click', function(e){
					e.stop();
					$$('a').removeEvents();
					this.slideView();
					this.fixedView();
					this.cornerView();
				}.bind(this));
			} else {
				this.slideView();
				this.fixedView();
				this.cornerView();
			}
		},

		slideView: function(){
			if( !this.options.viewSlide ){
				return;
			}
			var body=document.getElementsByTagName('body')[0];
			var lightbox=new Element('div',{id:'hiam-ligtbox'});
			if( this.options.css.lightbox ){
				lightbox.setStyles({
						background:'#000000',
						opacity: '0.8',
						position: 'fixed',
						'z-index':'999',
						width:'100%',
						height:'100%'
				});
				lightbox.inject( body,'top' );
			}
			var div=new Element('div',{ id:'hiam-slide-block', align:'center' }).inject( body ,'top' );
			div.setStyles({
				position:'absolute',
				width:'auto',
				height: 'auto',
				'z-index':'1000'
			});
			var conteiner=new Element('span',{ html:this.options.contentSlide});
			var content=new Element('div',{ id:'hiam-slide-content' }).inject( div ,'top' );
			conteiner.inject( content );
			content.setStyles({
				 background: 		this._getBackground(),
				 color: 			'#000',
				 padding: 			'10px',
				 margin: 			'0',
				 border:		 	this._getBorder(),
				 width:			  ( this.options.flgWidth==0 ) ? 'auto' : this.options.css.width + 'px',
				 height: 		  ( this.options.flgHeight==0 ) ? 'auto' : this.options.css.height + 'px',
				'text-align': 		'left',
				float: 'left'
			});
			var close=new Element('div',{ align:'right' }).inject( content ,'top' );
			close.setStyles({
				padding:'0 10px 10px 0'
			});
			var a=new Element('a',{href:'#',id:'hiam-slide-close', html: ((this.options.close.text.length>2)?this.options.close.text:'Close')+' X'}).inject( close, 'top' );
			a.setStyles({
				color:this.options.close.color,
				'font-size':'12px'
			});
			$$('#hiam-slide-content a').each(function(el){
				el.target=(this.options.flgWindow==0)?'_blank':'_self';
			},this);
			div.position();
			if( this.options.slidePos ){
				div.setStyle('top',this.options.slidePos);
			}
			var mySlide = new Fx.Slide(content,{
				duration: 1200,
				transition: 'bounce:out'
			});
			mySlide.hide();
			if( this.options.css.lightbox ){
				mySlide.show();
			} else {
				mySlide.slideIn();
			}
			a.addEvent('click', function( e ){
				e.stop();
				mySlide.hide();
				div.destroy();
				lightbox.destroy();
			});
			lightbox.addEvent('click',function(e){
				e.stop();
				mySlide.hide();
				div.destroy();
				lightbox.destroy();
			});
			this.initScript(conteiner);
		},

		getPosition: function(div){
		},

		cornerView: function(){
			if( !this.options.viewCorner ){
				return;
			}
			var body=document.getElementsByTagName('body')[0];
			var div=new Element('div',{ id:'hiam-flash', align:'left', class:((this.options.cornerPositeion<=2)?'top':'bottom') }).inject( body ,'top' );
			div.setStyles({
				position:	'fixed',
				width:		'auto',
				height: 	'auto',
				'z-index':'1000'
			});
			switch( this.options.cornerPositeion ){
				case 1: div.setStyle('left','0px'); div.setStyle('top','0px');  break;
				case 2: div.setStyle('right','0px'); div.setStyle('top','0px');  break;
				case 3: div.setStyle('left','0px'); div.setStyle('bottom','0px'); break;
				case 4: div.setStyle('right','0px'); div.setStyle('bottom','0px');break;
			}
			var flash = new Swiff( this.options.host+this.options.dir+'swf/corner.swf', {
				id: 'Hiam-Corner-Flash',
				container: div,
				width:  75,
				height: 75,
				params: {
					wMode: 'transparent',
					bgcolor: '#ffffff',
					quality: 'high',
					allowScriptAccess: 'always',
					movie: this.options.host+this.options.dir+'swf/corner.swf'
				},
				vars: {
					corner: this.options.cornerPositeion,
					image: this.options.flash.image,
					sound: this.options.flash.sound,
					url: this.options.url
				}
			});
		},

		fixedView: function(){
			if( !this.options.viewFix ){
				return;
			}
			var body=document.getElementsByTagName( 'body' )[0];
			var div=new Element( 'div', {id:'hiam-fix-block',html:this.options.contentFix } ).inject( body, 'top' );
			div.setStyles({
				position: 		'fixed',
				'z-index': 		'998',
				left: 			'0px',
				width:			  ( this.options.flgWidth==0 ) ? '100%' : this.options.css.width + 'px',
				height: 		  ( this.options.flgHeight==0 ) ? 'auto' : this.options.css.height + 'px',
				background: 	this._getBackground(),
				border:		 	this._getBorder(),
				padding: 		'5px',
				margin:			'0px',
			   'text-align': 	'left'
			});
			if( this.options.fixPosition == 1 ){
				div.setStyle('top','0');
			} else {
				div.setStyle('bottom','0');
			}
			var close=new Element('div',{ align:'right' }).inject( div ,'top' );
			close.setStyles({
				padding:'0 35px 10px 0'
			});
			var a=new Element('a',{href:'#',id:'hiam-fix-close', html:((this.options.close.text.length>2)?this.options.close.text:'Close')+' X'}).inject( close, 'top' );
			a.setStyles({
				color:this.options.close.color,
			   'font-size': '10px'
			});
			a.addEvent('click', function(e){e.stop(); div.destroy()});
			$$('#hiam-fix-block a').each(function(el){
				el.target=(this.options.flgWindow==0)?'_blank':'_self';
			},this);
			this.initScript(div);
		},

		initScript: function( conteiner ){
			var scripts=conteiner.getChildren('script');
			if(scripts==null){
				return;
			}
			scripts.each(function(item){
				if(item.src!=''){
					var el_script=new Element('script',{type:'text/javascript',src:item.src});
					document.getElementsByTagName('head')[0].appendChild(el_script);
					item.destroy();
					return;
				}
				eval.call(window,item.innerHTML);
			});
		},

		_saveCookie: function( key, value ){
			var cookie=new Hash.Cookie( this.options.cookie.name,  {duration: this.options.cookie.expires } );
			cookie.set( key , value );
			cookie.save();
		},

		_checkCookie: function( key ){
			var cookie=new Hash.Cookie( this.options.cookie.name,  {duration: this.options.cookie.expires } );
			var value=cookie.get( key );
			return (value!=null);
		},

		_getBackground: function(){
			var str='';
			if( this.options.css.background.image ){
				str+='url('+this.options.css.background.image+') repeat ';
			}
			str+=this.options.css.background.color;
			return str;
		},

		_getBorder: function(){
			var str='';
			switch(this.options.css.border.width){
				case 1 : str+='thin '; break;
				case 2 : str+='medium '; break;
				case 3 : str+='thick '; break;
			}
			switch( this.options.css.border.style ){
				case 1 : str+='None '; break;
				case 2 : str+='Dotted '; break;
				case 3 : str+='Dashed '; break;
				case 4 : str+='Solid '; break;
				case 5 : str+='Double '; break;
				case 6 : str+='Groove '; break;
				case 7 : str+='Ridge '; break;
				case 8 : str+='Inset '; break;
				case 9 : str+='Outset '; break;
			}
			str+=this.options.css.border.color;
			return str;
		}
	});

	/**
	 * Start pocess
	 */
{/literal}{foreach from=$items item=item}
var start_{$item.id}{literal}=function(){
	new Hiam({
		{/literal}
		id: {$item.id|default:0},
		host:'{$host}',
		dir:'{$dir}',
		{literal}
		flash:{
			{/literal}
			flgSound: {$item.flg_sound|default:0},
			sound:	'{if !empty($item.file_sound)}{$item.file_sound_path}{/if}',
			image:	'{if !empty($item.file_corner)}{$item.file_corner_path}{/if}'
			{literal}
		},
		css:{
			{/literal}
			width: 	{$item.width|default:0},
			height: {$item.height|default:0},
			{literal}
			border: {
				{/literal}
				width: {$item.flg_border_width|default:0},
				style: {$item.flg_border_style|default:0},
				color:'{if !empty($item.border_color)}{$item.border_color|trim}{/if}'
				{literal}
			},
			background:{
				{/literal}
				image:	'{if !empty($item.file_background)}{$item.file_background_path}{/if}',
				color:	'{if !empty($item.background_color)}{$item.background_color|trim}{/if}'
				{literal}
			},
			lightbox:{/literal}{$item.flg_lightbox|default:0}{literal}
		},
		close:{
			{/literal}
			text:'{$item.close_text}',
			color: '{$item.close_color|default:'#000000'}'
			{literal}
		},
		{/literal}
		flgFloating:	{$item.flg_floating_eff|default:0},
		flgDisplay: 	{$item.flg_display|default:0},
		flgWindow: 		{$item.flg_window|default:0},
		flgSound: 		{$item.flg_sound|default:0},
		url: 		   '{if !empty($item.url)}{$item.url}{/if}',
		fixPosition:	{$item.flg_fix_position|default:0},
		cornerPositeion:{$item.flg_corner_position|default:0},
		contentSlide:  '{$item.content_slide_parsed|replace:"</script>":"<\/script>"|default:0}',
		contentFix:    '{$item.content_fix_parsed|replace:"</script>":"<\/script>"|default:0}',
		flgAction:  	{$item.flg_action|default:0},
		viewSlide:  	{$item.flg_poss|default:0},
		viewCorner:  	{$item.flg_posc|default:0},
		viewFix:  		{$item.flg_posf|default:0},
		flgWidth:  		{$item.flg_width|default:0},
		flgHeight:  	{$item.flg_height|default:0},
		slidePos:  		{$item.slide_pos|default:0}
		{literal}
	});
	}
	{/literal}start_{$item.id}.delay({$item.delay*1000});{/foreach}{literal}
}
function expand_flash(){
	if( document.getElementById('hiam-flash').style.top=="0px" ){
		var width=500;
		var height=400;
	} else {
		var width=400;
		var height=500;
	};
	document.getElementById('hiam-flash').style.width=width+"px";
	document.getElementById('hiam-flash').style.height=height+"px";
	document.getElementById('Hiam-Corner-Flash').style.width=width+"px";
	document.getElementById('Hiam-Corner-Flash').style.height=height+"px";
}
function narrow_flash(){
var flash = new Fx.Morph('Hiam-Corner-Flash', {
    duration: 'short',
    transition: Fx.Transitions.Sine.easeOut
});
var div = new Fx.Morph('hiam-flash', {
    duration: 'short',
    transition: Fx.Transitions.Sine.easeOut
});
flash.start({
    'height': 75,
    'width': 75
});
div.start({
    'height': 75,
    'width': 75
});
}
{/literal}