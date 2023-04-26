<div class="panel panel-default" style="display:none;"> 
    <div class="panel-heading"> 
        <h4 class="panel-title"> 
            <a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFive-2" aria-expanded="false" class="collapsed">
               {if !Core_Acs::haveAccess( 'Zonterest PRO' )}Networking{/if}
            </a> 
        </h4> 
    </div>
     <div id="collapseFive-2" class="panel-collapse collapse"> 
        <div class="panel-body">
        	<fieldset>
				<div class="form-group">
					<div class="checkbox checkbox-primary">
						<input type="checkbox" name="arrPrj[flg_mastersite]" {if $arrPrj.flg_mastersite =='1'}checked="checked"{/if} value="1" id="master_blog" class="not_started in_progress cross_linking completed" />
						<label for="master_blog">Master Site Links</label>
					</div>
				</div>
				<div class="form-group" style="display:{if $arrPrj.flg_mastersite == 1}block{else}none{/if};" id="select_master_blog">
					<label></label>
					<select id="master_blog_list" name="arrPrj[mastersite_id]" class="not_started in_progress cross_linking completed btn-group selectpicker show-tick" ></select>
				</div>
				<div class="form-group">
					<div class="checkbox checkbox-primary">
						<input id="circular_links" type="checkbox" value="1"  {if $arrPrj.flg_circular =='1'}checked="checked"{/if} name="arrPrj[flg_circular]" class="not_started in_progress cross_linking completed" />
						<label for="circular_links">Circular Links</label>
					</div>
				</div>
				<p style="display: none;">
					<a href="#" class="acc_prev button" >Prev step</a>
				</p>
			</fieldset>
        </div>
    </div>
</div>
{literal}<script type="text/javascript">
var FifthPage = new Class( {
	Implements: Options,
	options: {
		jsonSitesList: null,
		flgStatus: null,
		masterBlogId: null,
		jsonSheduleId: null
	},
	initialize: function (options) {
		this.setOptions(options);
		this.intSites();
		this.initMaster();
	},
	intSites: function () {
		$$( '.blog-list' ).each( function( input ){
			input.addEvent( 'click',function(){
				$( 'master_blog_list' ).empty();
				$$( '.fieldset-blog-list' ).each( function( el ){
					el.empty();
					el.hide();
				});
				this.intputSitesTo( input );
			}.bind( this ) );
			if ( input.checked ) {
				this.intputSitesTo( input );
			}
		},this );
	},
	intputSitesTo: function ( element ) {
		var parentDiv=$($$('.fieldset-'+element.get('id'))[0]);
		if ( $( 'category_child' ).value == null ) {
			return false;
		}
		var num_of_sites=0;
		var arrSheduleId = (this.options.jsonSheduleId!=null)?this.options.jsonSheduleId:(new Array());
		var type=null;
		Object.each(JSON.decode( this.options.jsonSitesList ), function( block ){
			if( $( 'category_child' ).value != block.category_id ) {
				return;
			}
			var checked_input = false;
			if( (arrSheduleId.some(function(v){ return block.id==v.site_id; })) || (element.value == 1) ){
				checked_input = true;
			}
			if( type != block.type ){
				type=block.type;
				var typeName='';
				switch (type) {
					case '5':{
						typeName='Blog Fusion'
						break;
					}
					case '2':{
						typeName='Zonterest'
						break;
					}
					case '3':{
						typeName='Niche Video Site Builder'
						break;
					}
				}
			//	new Element( 'label[html="&nbsp;'+typeName+'"]' )
			//		.inject( parentDiv );
			}
			new Element( 'div' )
				.inject( parentDiv )
				.adopt(
					new Element( 'input.blog-item[type="checkbox"][name="arrPrj[arrSiteIds]['+block.type+']['+block.id+'][site_id]"][value='+block.id+']'+((checked_input)?'[checked="checked"]':''))
						.addEvent("click", function (item) {
							if ( item.target.checked ) {
								$$(".field_"+block.id).setStyle('display','').set('disabled',false);
								num_of_sites++;
								this.inputToSelect(block);
							}else{
								num_of_sites--;
								$$(".field_"+block.id).setStyle('display','none').set('disabled',true);
								$( 'master_blog_list' ).getChildren('option[value="'+block.id+'"]').destroy();
								if ( $('master_blog_list').options.length == 0 ) {
									$( 'master_blog' ).checked = false;
									$( 'select_master_blog' ).setStyle( 'display', 'none' );
								}
							}
							if( num_of_sites < 2 ){
								$('circular_links').disabled=true;
							}else{
								$('circular_links').disabled=false;
							}
						}.bind(this)),
					new Element( 'span[html="&nbsp;'+block.url+',&nbsp;'+block.title+'"]' )
				);
			if( block.categories != null ) {
				block.categories.each( function( category ){
					checked_cat_input = false;
					if( arrSheduleId.some(function(v){ return category.ext_id==v.ext_category_id && block.id==v.site_id; }) ){
						checked_cat_input = true;
					}
					new Element( 'fieldset[style="display:'+((checked_input)?'':'none')+';padding-left:16px;"][class="field_'+block.id+'"]' )
					.inject( parentDiv )
					.adopt(
						new Element( 'label' )
							.adopt(
								new Element( 'input[type="radio"][name="arrPrj[arrSiteIds]['+block.type+']['+block.id+'][ext_category_id]"][value="'+category.ext_id+'"]'+((checked_cat_input)?'[checked="checked"]':'') ),
								new Element( 'span[html='+category.title+']' )
							)
					);
				});
			}
			if ( checked_input ) {
				this.inputToSelect(block);
			}
		}.bind(this));
		if ( element.value != 1 ) {
			parentDiv.setStyle( 'display','' );
		}else{
			parentDiv.setStyle( 'display','block' );
		}
	},
	inputToSelect: function (item) {
		new Element( 'option[value="'+item.id+'"][html="'+item.url+'"]'+((item.id == '{/literal}{$arrPrj.mastersite_id}{literal}')?'[selected="selected"]':'') )
			.inject( $( 'master_blog_list' ) );
	},
	initMaster: function () {
		$( 'master_blog' ).addEvent( 'click', function(){
			if (  $('master_blog_list').options.length == 0 ) {
				r.alert( 'Messages', 'Please select sites on which you want to publish.', 'roar_error' );
				$( 'master_blog' ).checked = false;
			}
			$( 'select_master_blog' ).setStyle( 'display', ( $( 'master_blog' ).checked != null && $( 'master_blog' ).checked != false  )?'':'none' );
		});
	}
});
</script>
{/literal}