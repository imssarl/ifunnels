<br />
{include file='../../error.tpl' fields=[
	'placement_id'=>'Domains','ftp_directory'=>'Homepage Folder','title'=>'Blog Name','url'=>'Url','category_id'=>'Select Category','adsense_id'=>'Adsense ID','main_keyword'=>'Main Keyword']}

<form action="" method="post" class="wh validate"  id="from-create">
<p>Please complete the form below. Mandatory fields are marked with <em>*</em></p>
{module name='site1_hosting' action='select' selected=$arrNvsb arrayName='arrNvsb' onlyRemote=true}
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
		<select name="arrNvsb[category_id]" class="medium-input required validate-custom-required emptyValue:'0'" id="category_child" ></select>
	</p>
	<p>
		<label>Main Keyword <em>*</em></label><input class="required medium-input text-input" type="text" name="arrNvsb[main_keyword]" value="{$arrNvsb.main_keyword}">
	</p>
	<p>
		<label for="adsenseid">Adsense ID <em>*</em></label><input name="arrNvsb[google_analytics]"  type="text" id="adsenseid" value="{$arrNvsb.google_analytics}"  class="required  medium-input text-input"/>
	</p>
	<p>
		<input type="checkbox" name="arrNvsb[syndication]" {if $arrNvsb.syndication||(empty( $arrNvsb.id )&&empty( $arrErr ))} checked=""{/if} /> Add site to syndication network
	</p>
	<p>
		<input type="submit" value="Import" id="import" class="button" {is_acs_write} />
	</p>
</fieldset>
</form>
<script type="text/javascript">
var jsonCategory = {$treeJson|default:'null'};
var categoryId = {$arrNvsb.category_id|default:0};
var info={$strTemplatesInfo};
{literal}
var NCSB = new Class({
	initialize: function( options ){
		this.initSubmit();
		this.start();
	},
	start: function(){
		
	},
	initSubmit: function(){
		$('from-create').addEvent('submit',function( e ){
			$('import').set('disabled','1');
		});
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
		if (!$chk(this.arrCategories)) {
			return;
		}
		this.arrCategories.each(function(el){
			if( el.id == id ) { bool=true; }
		}); 
		return bool;
	},
	setFromFirstLevel: function( id ){
		if (!$chk(this.arrCategories)) {
			return;
		}		
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
		if (!$chk(this.arrCategories)) {
			return;
		}		
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
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	new NCSB();
	new Categories();
});
{/literal}
</script>