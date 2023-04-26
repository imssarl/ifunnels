{if !empty($arrNvsb.id)}
{include file="site1_nvsb_edit.tpl"}
{else}
{include file='../../error.tpl' fields=['ftp_directory'=>'Homepage Folder','domain_id'=>'Domain','template_id'=>'Template',
	'category_id'=>'Select Category','url'=>'Url','navigation_length'=>'Article Navigation Length',
	'main_keyword'=>'Main Keyword','flg_snippet'=>'Display type','arrArticleIds'=>'Articles list']}

<form method="post" action="" class="wh validate"  id="from-create" enctype="multipart/form-data">
<input type="hidden" name="arrNvsb[id]" value="{$arrNvsb.id}" />
	<p>Please complete the form below. Mandatory fields are marked with <em>*</em></p>
	{module name='site1_hosting' action='select' selected=$arrNvsb arrayName='arrNvsb'}
	<fieldset>
		<legend>Site template</legend>
		<p>
			<label>Template <em>*</em></label>
			<select class="required validate-custom-required emptyValue:'0' medium-input" id="select-template" name="arrNvsb[template_id]"><option value="" id=""> - select -
				{foreach from=$arrTemplates item=i}
				<option {if $arrNvsb.template_id == $i.id}selected{/if} value="{$i.id}">{$i.title}
				{/foreach}
			</select>
		</p>
		<p>
			<div align="center">
				<img src="" border="0" alt="" id="template_img" />
				<p id="divdesc"></p>
			</div>
		</p>
	</fieldset>
	<span{if $smarty.get.template} style="display:none;"{/if}>
	<fieldset>
		<legend>Configuration settings</legend>
		<p>
			<label>Select Category <em>*</em></label>
			<select id="category" class="required validate-custom-required emptyValue:'0' medium-input">
				<option value="0"> - select -
				{foreach from=$arrCategories item=i}
				<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
				{/foreach}
			</select><br/>
			<select name="arrNvsb[category_id]" class="required validate-custom-required emptyValue:'0'  medium-input" id="category_child" ></select>
		</p>
		<p>
			<label for="adsenseid"><span>Google Adsense ID </span></label>
			<input name="arrNvsb[google_analytics]" type="text" id="adsenseid" class="text-input medium-input" value="{if !empty($arrNvsb.google_analytics)}{$arrNvsb.google_analytics}{else}{Core_Users::$info['adsenseid']}{/if}" />
			<br/><small>Format: pub-xxxxx; do not forget the pub-...</small>
		</p>
		<p>
			<label for="mainkeyword"><span>Main Keyword <em>*</em></span></label>
			<input name="arrNvsb[main_keyword]" class="required text-input medium-input"  type="text" id="mainkeyword" value="{$arrNvsb.main_keyword}" />
			<br/><small>Example:Flower Gardening </small>
		</p>
		{if Core_Acs::haveRight( ['nvsb'=>['hosted','hostedpro']] )}
			<input type="hidden" name="arrNvsb[syndication]" value="on" />
		{else}
		<p>
			<input type="checkbox" name="arrNvsb[syndication]" {if $arrNvsb.syndication||(empty( $arrNvsb.id )&&empty( $arrErr ))} checked=""{/if} /> Add site to syndication network
		</p>
		{/if}
	</fieldset>
	<fieldset>
		<legend id="in" style="cursor: pointer;">Advanced Settings</legend>
		<legend id="out" style="display: none;cursor: pointer;">Advanced Settings</legend>
		<div id="vertical_slide">
			<p>
				Do you want to add articles to the site now (they will show up in the Blog section of your site)? <input type="checkbox" {if $arrNvsb.flg_articles}checked=1{/if} name="arrNvsb[flg_articles]" id="source_type" />  Yes
			</p>
			<div id="source_block" style="display:{if $arrNvsb.flg_articles}block{else}none{/if};">
				{module name='site1_articles' action='multiboxplace' selected=$strJson place='content_wizard' type='multiple'}	
				<div id="articleList"></div>
			</div>
			<p>
				<label>Tag Cloud Word</label>
				<textarea name="arrNvsb[tag_cloud]" class="textarea text-input" style="height:70px;" >{$arrNvsb.tag_cloud}</textarea>
				<br/><small>We recommend no more than 10 to 15 words. Separate each word with coma.</small>
			</p>
			<p>
				<label>Related keywords</label>
				<input type="radio" value="0" name="arrNvsb[flg_related_keywords]"  {if $arrNvsb.flg_related_keywords==0} checked='1' {/if}> hide <br/>
				<input type="radio" value="1" name="arrNvsb[flg_related_keywords]"   {if $arrNvsb.flg_related_keywords==1} checked='1' {/if}> display
			</p>
			<p>
				<label>Usage</label>
				<input type="radio" value="0" name="arrNvsb[flg_usage]" {if isset($arrNvsb.flg_usage) && $arrNvsb.flg_usage==0} checked='1' {/if}> filter videos using mandatory keywords <br/>
				<input type="radio" value="1" name="arrNvsb[flg_usage]" {if !isset($arrNvsb.flg_usage) || $arrNvsb.flg_usage==1} checked='1' {/if}> filter videos using banned keywords
			</p>
			<p>
				<label>Mandatory keywords</label>
				<textarea name="arrNvsb[mandatory_keywords]" class="textarea text-input"  style="height:70px;" >{$arrNvsb.mandatory_keywords}</textarea>
			</p>
			<p>
				<label>Show comments</label>
				<input type="radio" value="0" name="arrNvsb[flg_comments]" {if $arrNvsb.flg_comments==0} checked='1' {/if}> hide the comments<br/>
				<input type="radio" value="1" name="arrNvsb[flg_comments]" {if $arrNvsb.flg_comments==1} checked='1' {/if}> show the comments and enable your vistors to add comments to your videos
			</p>
			{if $arrUser.id==1 || $arrUser.id==39180 || $arrUser.id==23551 || $arrUser.id==39182 || $arrUser.id==28832}
			<p>
				<label>Keywords file</label>
				<input type="file" name="keywords" />
			</p>
			<p>
				<label>Links file</label>
				<input type="file" name="links" />
			</p>
			{/if}
		</div>
	</fieldset>
	
	{module name='advanced_options' action='optinos' site_type=Project_Sites::NVSB site_data=$arrOpt}
	</span>
	<input value="{if $smarty.get.id}Save site{else}Generate new site{/if}" type="submit"  id="create" class="button" {is_acs_write} >
</form>
{/if}

<script type="text/javascript">
var post = {$post_true|default:'null'};
var edit = {$arrNvsb.id|default:'null'};
var templateId = {$arrNvsb.template_id|default:'null'};
var arrTemplates = {$jsonTemplates|default:'null'};
var jsonCategory = {$treeJson|default:'null'};
var categoryId = {$arrNvsb.category_id|default:0};
{literal}
var NVSB = new Class({
	Implements:Options,
	options:{
		templatesSelect:'select-template',
		countSpot:10
	},
	initialize: function( options ){
		this.setOptions( options );	
		this.initSubmit();
		this.elementTemplateSelect = $( this.options.templatesSelect );
		this.start();
		this.sourceType();
		
	},
	start: function(){
		this.selectTemplate();
		if( templateId != null ) {
			this.editTemplate();
		}
	},
	initSubmit: function(){
//		$('from-create').addEvent('submit', function(){
//			$('create').set('disabled','1');
//		});
	},
	sourceType: function(){
		$('source_type').addEvent('click', function(){
			$('source_block').setStyle('display', ( $('source_type').checked )?'block':'none' );
			$('vertical_slide').getParent('div').setStyle('height','auto');
		});
	},	
	editTemplate:function(){
		$('divdesc').set('html','');
		arrTemplates.each(function(template){
			if( template.id == this.elementTemplateSelect.value ) {
				$('template_img').set( 'src', template.preview );
				$('divdesc').set('html',template.description.replace(/\\n/g,' ').replace(/\\r/g,' '));
			}
		},this);
	},
	selectTemplate: function(){
		this.elementTemplateSelect.addEvent( 'change', function(){
				$('template_img').set( 'src', '' );
				$('divdesc').set('html','');
				arrTemplates.each(function(template){
					if( template.id == this.elementTemplateSelect.value ) {
						$('template_img').set( 'src', template.preview );
						$('divdesc').set('html',template.description.replace(/\\n/g,' ').replace(/\\r/g,' '));
					}
				},this);
		}.bind( this ) );
	}
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
		if( this.hash == null ) {return;}
		this.hash.each( function( value, key ) {
			key++ ;
			var div = new Element( 'div' );
			var name = new Element( 'p' );
			name.set( 'html',key + '. ' + value.title.substr( 0, 50 ) + ' <a href="#" class="delete_article_' + this.options.place + '" rel="' + value.id + '">Delete from list</a>' );
			name.inject( div );
			div.inject( this.options.contentDiv );
			$('count_article_' + this.options.place).value = key;
		},this );
		$( 'multibox_ids_' + this.options.place ).value=JSON.encode( this.hash );
		$('vertical_slide').getParent('div').setStyle('height','auto');
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
var multibox = {};
window.addEvent('domready', function(){
	new NVSB();
	new Categories();
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle:true,
		titleFormat:'{title}'
	});
	var myVerticalSlide = new Fx.Slide('vertical_slide');
	myVerticalSlide.hide();
	$('in').addEvent('click', function(event){
		event.stop();
		myVerticalSlide.slideIn();
		$('out').setStyle('display','block');
		this.setStyle('display','none');
	});
	$('out').addEvent('click', function(event){
	  	event.stop();
	  	myVerticalSlide.slideOut();
		$('in').setStyle('display','block');
		this.setStyle('display','none');
	});
});
{/literal}
</script>