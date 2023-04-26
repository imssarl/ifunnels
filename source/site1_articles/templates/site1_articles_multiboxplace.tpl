{assign var=place value=$arrPrm.place}
{assign var=type value=$arrPrm.type}
{assign var=input value=$arrPrm.input}
{assign var=required value=$arrPrm.required}
{assign var=return value=$arrPrm.return}
{assign var=className value=$arrPrm.className}
{if $type == 'multiple'}
<div id="opt-block-multimanage_{$place}" >
<div  {if $arrPrm.disabled==1} style="display:none;" {/if}>
<label>Add content{if $required == 1} <em>*</em>{/if} </label>

{if !Core_Acs::haveAccess( array('Zonterest PRO 2.0') )}
	<a {if !Core_Acs::haveRight( ['article'=>['contentwizard']] )} style="display:none;"{/if}  href="" id="open_mutlibox_select_{$place}" class="mb_article"  title="Articles Select" rel="">Content Wizard</a>
	&nbsp;&nbsp;&nbsp;
	<a  href="" id="open_mutlibox_import_{$place}" class="mb_article"  title="Articles Import" rel="">Upload Article</a>
{else}
	<input type="hidden" id="open_mutlibox_select_{$place}" class="mb_article" />
	<input type="hidden" id="open_mutlibox_import_{$place}" class="mb_article" />
	<a  href="{url name='site1_publisher' action='project_create'}" title="Create Publishing Project" rel="">Create Publishing Project</a>
{/if}

</div>
</div>
{else}
<div id="opt-block-multimanage_{$place}" style="display:none;">
	<a  href="" id="open_mutlibox_select_{$place}" class="mb_article" style="display:none;" title="Articles Select" rel="">Select from article wizard</a>
	<br/>
	<a  href="" id="open_mutlibox_import_{$place}" class="mb_article" style="display:none;" title="Articles Import" rel="">Upload articles</a>
</div>
{/if}
<input type="hidden" id="multibox_ids_{$place}" name="multibox_ids_{$place}" value=""/>
<input type="hidden" id="count_article_{$place}" value="0" />
{literal}
<script>
 
/*
*  multibox select article initialize place
*/
var multiboxPlace = new Class({
	Implements:Options,
	options: {
		place: '{/literal}{$place|default:"article_wizard"}{literal}',
		type: '{/literal}{$type|default:"multiple"}{literal}',
		input: '{/literal}{$input|default:"checkbox"}{literal}',
		links: {
			importLink:'',
			selectLink:''
		},
		return2import:'{/literal}{$return|default:"list"}{literal}'
	},
	initialize: function( options ){
		this.setOptions( options );
		this.initEvents();
		this.initSelectLink();
		this.initImportLink();
	},
	initEvents: function() {
		$$('.' + this.options.place ).each( function( el ){
			el.addEvent( 'click', function( e ){ 
				if(  el.checked && el.id == 'import' ) {
					$( 'open_mutlibox_select_' + this.options.place ).style.display = 'none';
					$( 'open_mutlibox_import_' + this.options.place ).style.display = 'block';					
				} else if( el.checked && el.id == 'select' ) {
					$( 'open_mutlibox_select_' + this.options.place ).style.display = 'block';
					$( 'open_mutlibox_import_' + this.options.place ).style.display = 'none';					
				}			
			}.bind( this ) );
		}, this );
		$('opt-block-multimanage_' + this.options.place ).setStyle('display','block');
	},
	
	initSelectLink: function() {
		if( this.options.type != 'multiple') {
		$$( '.' + this.options.place ).each( function( el ) {
			var type = 'checkbox';
			if( el.title ) { type = el.title; }
			else if ( el.rel ) { type = el.rel;	}
			$( 'open_mutlibox_select_' + this.options.place ).href = this.options.links.selectLink + "?place=" + this.options.place + "&type_input_element=" + type;
		},this );			
		} else {
			$( 'open_mutlibox_select_' + this.options.place ).href = this.options.links.selectLink + "?place=" + this.options.place + "&type_input_element=" + this.options.input;
		}
	},

	initImportLink: function() {
		if( this.options.return2import == '' ) {
			this.options.return2import = 'list';
		}
		$( 'open_mutlibox_import_' + this.options.place ).href = this.options.links.importLink + "?place=" + this.options.place + "&return=" + this.options.return2import;
	}
});

/************************/


var multiboxArticle = new Class( {
	Implements: Options,
	options: {
		jsonData: '',
		place:'article_wizard'		
	},
	initialize: function( options ) {
		this.setOptions( options );
		this.parentClass = new {/literal}{$className|default:"articleList"}{literal}( this.options );
		$( 'multibox_ids_' + this.options.place ).value = this.options.jsonData;
		this.parentClass.set();
	}
}); 

/************************/


var addArticle = new Class( {
	Implements: Options,
	options: {
		jsonData: '',
		place:'article_wizard'		
	},
	initialize: function( options ) {
		this.setOptions( options );
		var arr=new Array();
		arr=JSON.decode( $( 'multibox_ids_' + this.options.place ).value );
		var addData=JSON.decode( options.jsonData )[0];
		if(arr==null){
			arr=new Array();
		}
		var length=Object.getLength(arr)+1;
		arr.append( [ addData ] );

		$( 'multibox_ids_' + this.options.place ).value=JSON.encode( arr );
		this.parentClass = new {/literal}{$className|default:"articleList"}{literal}( {
			jsonData: $( 'multibox_ids_' + this.options.place ).value,
			place: this.options.place		
		});
		this.parentClass.set();
	}
}); 

var removeArticle = new Class( {
	Implements: Options,
	options: {
		jsonData: '',
		place:'article_wizard'		
	},
	initialize: function( options ) {
		this.setOptions( options );
		var arr=new Array();
		if( $( 'multibox_ids_' + this.options.place ).value != '' ){
			arr=JSON.decode( $( 'multibox_ids_' + this.options.place ).value );
		}
		Array.each(arr, function(value,index){
			if( arr[index].id == JSON.decode( options.jsonData)[0].id ){
				delete arr[index];
			}
		});
		arr=arr.clean();
		$( 'multibox_ids_' + this.options.place ).value=JSON.encode( arr );
		this.parentClass = new {/literal}{$className|default:"articleList"}{literal}({
			jsonData: $( 'multibox_ids_' + this.options.place ).value,
			place: this.options.place		
		});
		this.parentClass.set();
	}
}); 

/************************/


var multibox_article ={};
var disabled = {/literal}{if $arrPrm.disabled}true{else}false{/if};{literal}

window.addEvent( 'domready', function() {
	/*
	* Initialization multibox
	*/
	if( !$chk( multibox_article.options ) ) {
		multibox_article=new CeraBox( $$('.mb_article'), {
			group: false,
			width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
			height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
			displayTitle: true,
			titleFormat: '{title}'
		});
	}
	/***********************/
	
	/*
	* initialization multiboxPlace
	*/
	new multiboxPlace({
		place:'{/literal}{$place}{literal}',
		type:'{/literal}{$type}{literal}',
		links: {
			importLink:'{/literal}{url name="site1_articles" action="importpopup"}{literal}',
			selectLink:'{/literal}{url name="site1_articles" action="multiboxselect"}{literal}'
		}
	});
	/***************/

	/*
	* initialization multiboxArticle if edit. Get JSON from Smarty
	*/
	{/literal}
	{if $arrPrm.selected != ''}
		json_{$place} = '{$arrPrm.selected|replace:"'":"`"}';
		new multiboxArticle( {literal}{{/literal}jsonData:json_{$place}, place:'{$place}'{literal}}{/literal});
	{/if}
	{literal}
	/***********************/
} );

</script>
{/literal}