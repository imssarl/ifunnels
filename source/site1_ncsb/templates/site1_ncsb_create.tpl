{if !empty($arrNcsb.id)}
{include file="site1_ncsb_edit.tpl"}
{else}
{include file='../../error.tpl' fields=['ftp_directory'=>'Homepage Folder','domain_id'=>'Domain','template_id'=>'Template',
	'category_id'=>'Select Category','url'=>'Url','navigation_length'=>'Article Navigation Length',
	'main_keyword'=>'Main Keyword','flg_snippet'=>'Display type','arrArticleIds'=>'Articles list']}

<form method="post" action="" class="wh validate" id="create_ncsb" >
	<input type="hidden" name="arrNcsb[id]" value="{$arrNcsb.id}" />
	<p>Please complete the form below. Mandatory fields are marked with <em>*</em></p>
	{module name='site1_hosting' action='select' selected=$arrNcsb arrayName='arrNcsb'}
	<fieldset>
		<legend>Site template</legend>
		<div class="form-group">
			<label for="templates">Template <em>*</em></label>
			<select name="arrNcsb[template_id]" id="templates" class="required medium-input validate-custom-required emptyValue:'0' {if !empty($arrErrors.errForm.template_id)}error{/if} btn-group selectpicker show-tick">
				<option value=''> - select - </option>
				{html_options options=$arrTemplates selected=$arrNcsb.template_id}
			</select>
		</div>
		<div>
			<div align="center">
			<img src="" border="0" alt="" id="template_img" />
			<p id="divdesc"></p>
			</div>
		</div>
	</fieldset>
	<span{if $smarty.get.template} style="display:none;"{/if}>
	<fieldset>
		<legend>Configuration settings</legend>
		<div class="form-group"{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641} style="display:none;"{/if}>
			<label>Select Category <em>*</em></label>
			<select id="category" class="required medium-input validate-custom-required emptyValue:'0' btn-group selectpicker show-tick">
				<option value="0"> - select -
				{foreach from=$arrCategories item=i}
				<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
				{/foreach}
			</select>
		</div>
		<div class="form-group"{if isset($arrNcsb.category_id) && $arrNcsb.category_id==641} style="display:none;"{/if}>
			<label>&nbsp;</label>
			<select name="arrNcsb[category_id]" class="required medium-input validate-custom-required emptyValue:'0'  {if !empty($arrErrors.errForm.category_id)}error{/if} btn-group selectpicker show-tick" id="category_child" ></select>
		</div>
		<div class="form-group">
			<label for="adsenseid"><span>Adsense ID </span></label>
			<input name="arrNcsb[google_analytics]" class="text-input medium-input form-control" type="text" id="adsenseid" value="{if !empty($arrNcsb.google_analytics)}{$arrNcsb.google_analytics}{else}{Core_Users::$info['adsenseid']}{/if}"/>
		</div>
		<div class="form-group">
			<label for="mainkeyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrNcsb[main_keyword]" type="text" id="mainkeyword" value="{$arrNcsb.main_keyword}" class="required text-input medium-input {if !empty($arrErrors.errForm.main_keyword)}error{/if} form-control"/>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="arrNcsb[syndication]" {if $arrNcsb.syndication||(empty( $arrNcsb.id )&&empty( $arrErr ))} checked=""{/if} />
				<label>Add site to syndication network</label>	
			</div>
		</div>
	</fieldset>

	<fieldset>
		<legend>Source settings</legend>
		<div class="form-group">
			<label for="articlenavigationlength"><span>Article Navigation Length <em>*</em></span></label>
			<input name="arrNcsb[navigation_length]" type="text" id="articlenavigationlength" value="{if $arrNcsb.navigation_length==0&&$arrNcsb.id}5{else}{$arrNcsb.navigation_length}{/if}" class="required text-input medium-input {if !empty($arrErrors.errForm.navigation_length)}error{/if} form-control"/>
			<br/><small>(number of links to articles to display in the sidebar)</small>
		</div>
		<div class="form-group">
			<label>Display type <em>*</em></label>
			<div class="radio radio-primary">
				<input name="arrNcsb[flg_snippet]" type="radio" id="show_full" value="no"{if $arrNcsb.flg_snippet==0} checked="1"{/if}>
				<label>Full Article (display random article on the home page)</label>
			</div>
			<div class="radio radio-primary">
				<input name="arrNcsb[flg_snippet]" type="radio" id="flg_snippets" value="yes"{if $arrNcsb.flg_snippet=='1'} checked="1"{/if} class="required">
				<label>Snippets (display article snippets on the home page)</label>
			</div>
		</div>
		<div class="form-group" style="display:{if $arrNcsb.flg_snippet == 'yes'}block{else}none{/if};" id="flg_snippets_1">
			<label for="snippet_number"><span>Number of article snippets</span></label>
			<input name="arrNcsb[snippet_number]" type="text" class="text-input medium-input form-control" id="snippet_number" value="{$arrNcsb.snippet_number}" />
		</div>
		<div class="form-group" style="display:{if $arrNcsb.flg_snippet == 'yes'}block{else}none{/if};" id="flg_snippets_2">
			<label for="snippet_length"><span>Length of each snippet</span></label>
			<input name="arrNcsb[snippet_length]" type="text" class="text-input medium-input form-control" id="snippet_length" value="{$arrNcsb.snippet_length}" />
		</div>
		<div class="form-group">
		{module name='site1_articles' action='multiboxplace' selected=$strJson place='content_wizard' type='multiple' required=0}
			<div id="articleList"></div>
		</div>
	</fieldset>
	{if !isset($arrNcsb.category_id) || $arrNcsb.category_id!=641}
	{module name='advanced_options' action='optinos' site_type=Project_Sites::NCSB site_data=$arrOpt}
	{/if}
	</span>
	<div class="form-group">
		<button type="submit" class="button btn btn-success waves-effect waves-light" {is_acs_write}>{if $smarty.get.id}Save site{else}Generate new site{/if}</button>
	</div>
</form>
{/if}


<script type="text/javascript">

var jsonCategory = {$treeJson};
var categoryId = {$arrNcsb.category_id|default:0};
var info={$strTemplatesInfo};
{literal}


var Categories = new Class({
	Implements: Options,
	options: {
		firstLevel: 'category',
		secondLevel: 'category_child',
		intCatId: categoryId
	},
	initialize: function( options ){
		this.setOptions(options);
		this.arrCategories = new Hash(jsonCategory);
		$(this.options.firstLevel).addEvent('change',function(){
			this.setFromFirstLevel( $(this.options.firstLevel).value );
		}.bind( this ) );
		if( $chk( this.options.intCatId ) && this.checkLevel( this.options.intCatId ) ) {
			this.setFromFirstLevel( this.options.intCatId );
		} else if( $chk( this.options.intCatId ) ) {
			this.setFromSecondLevel( this.options.intCatId );
		}
	},
	checkLevel: function(id){
		var bool=false;
		this.arrCategories.each(function(el){
			if( el.id == id ) { bool=true; }
		}); 
		return bool;
	},
	setFromFirstLevel: function( id ){
		this.arrCategories.each( function(item){
			if( item.id == id ) {
				Array.each( $(this.options.firstLevel).options,function(i){
					if(i.value == id){
						i.selected=1;
					}
				});					

				$(this.options.secondLevel).empty();
				var option = new Element('option',{'value':'','html':'- select -'});
				option.inject( $(this.options.secondLevel) );
				var hash = new Hash(item.node);
				
				
				
				hash.each(function(i,k){
					var option = new Element('option',{'value':i.id,'html':i.title});
					if( i.id == this.options.intCatId ){
						option.selected=1;
					}
					option.inject( $(this.options.secondLevel) );
				},this);
				jQuery('#'+this.options.secondLevel).selectpicker('refresh');
			}
		},this);
	},
	setFromSecondLevel: function( id ) {
		this.arrCategories.each(function( item ){
			var hash = new Hash(item.node);
			hash.each(function(el){
				if ( id == el.id ) {
					this.setFromFirstLevel( el.pid );
				}
			},this);
		},this);
	}
});
window.addEvent('domready', function(){
	new Categories();
});

var articleList = new Class({
	Implements: Options,
	options: {
		jsonData:'',
		place:'',
		contentDiv:$('articleList')
	},
	initialize: function( options ){
		this.setOptions( options );
		this.hash = JSON.decode( this.options.jsonData );
	},
	set: function(){
		this.options.contentDiv.empty();
		var header = new Element( 'div' );
		var b = new Element( 'b' ).set( 'html','<br /><br />Selected articles' ).inject( header );
		header.inject( this.options.contentDiv );
		if(this.hash == false){ return; }
		Object.each(this.hash, function( value, key ) {
			key++ ;
			var div = new Element( 'div' );
			var name = new Element( 'p' );
			name.set( 'html',key + '. ' + value.title.substr( 0, 50 ) + ' <a href="#" class="delete_article_' + this.options.place + '" rel="' + value.id + '">Delete from list</a>' );
			name.inject( div );
			div.inject( this.options.contentDiv );
			$('count_article_' + this.options.place).value = key;
		},this );
		$( 'multibox_ids_' + this.options.place ).value=JSON.encode( this.hash );
		this.initDeleteArticle();
	},
	initDeleteArticle: function() {
		$$( '.delete_article_' + this.options.place ).each( function( el ) {
			el.addEvent( 'click',function( e ) {
				e && e.stop();
				var arr = new Array();
				var i = 0;
				this.hash.each( function( value, key ) {
					if( value.id != el.rel ) {
						arr[ i ] = value;
						i++;
					}
				} );
				this.hash = arr;
				this.set();
			}.bind( this ) );
		},this );
	}	
});

$('templates').addEvent('change',function(){
	if ( this.value>'' ) {
		info.each(function( item ){
			if( item.id == this.value ){
				$('template_img').set('src',item.preview);

				$('divdesc').set('html',item.description.replace(/\\n/g,' ').replace(/\\r/g,' '));
			}
		}, this);
	} else {
		$('template_img').set('src','');
		$('divdesc').set('html','');
	}
});
$('templates').fireEvent('change');

$('show_full').addEvent('click',function(){
	$('flg_snippets_1').style.display='none';
	$('flg_snippets_2').style.display='none';
});
//$('show_full').fireEvent('click');

$('flg_snippets').addEvent('click',function(){
	$('flg_snippets_1').style.display='block';
	$('flg_snippets_2').style.display='block';
});
//$('flg_snippets').fireEvent('click');

var multibox={};
window.addEvent('domready', function() {
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});

{/literal}
</script>
