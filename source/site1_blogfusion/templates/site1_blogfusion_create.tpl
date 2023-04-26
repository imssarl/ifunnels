{literal}

<script type="text/javascript">
var objAccordion = {};
window.addEvent('domready', function() {
	objAccordion = new myAccordion($('accordion'), $$('.toggler'), $$('.element'), { fixedHeight:false });
});
</script>
{/literal}
<br />
{if !$arrBlog.id}
<div align="center">
	<div  style="width:58%;">
		<a class="" href="{url name='site1_blogfusion' action='create'}"  rel="create_form">Create blog</a> | 
		<a class="" href="{url name='site1_blogfusion' action='import'}" class="select_type" rel="import_form">Import blog</a>
	</div>
</div>
<br />
{/if}
{if $msg == 'succes'}
	<div class="grn">Saved successfuly</div>
{/if}
{include file='../../error.tpl' fields=['placement_id'=>'Domains','ftp_directory'=>'Homepage Folder','title'=>'Blog Name','url'=>'Url','db_host'=>'DB Host Name',
'db_name'=>'Database Name','db_username'=>'Database User Name','db_password'=>'Database Password','dashboad_username'=>'Login ID','dashboad_password'=>'Password']}
<form class="wh validate" style="display:none;" id="create_form" method="post" action="" enctype="multipart/form-data">
{if !$arrBlog.id}
<div>
	Load&nbsp;settings:&nbsp;<select id="masterBlog" class="btn-group selectpicker show-tick">
	<option value="0"> - select -
	{foreach from=$arrSettingsSelect item=i}
	<option value="{$i.id}">{$i.title}
	{/foreach}
	</select>
</div>
{/if}
<br />
{if $arrBlog.id}<input type="hidden" value="{$arrBlog.id}" name="arrBlog[id]" />{/if}
<div class="panel-group" id="accordion-test-2">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseOne-2" aria-expanded="false" class="collapsed">
					Hosting settings
                </a>
			</h4>
		</div>
		<div id="collapseOne-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step0.tpl"}
            </div> 
        </div>
	</div> 
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTwo-2" aria-expanded="false" class="collapsed">
					Design and Content setup
                </a>
			</h4>
		</div>
		<div id="collapseTwo-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step1.tpl"}
            </div> 
        </div>
	</div>
	<div class="panel panel-default" style="display: none;">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseTree-2" aria-expanded="false" class="collapsed">
					Proprietary template options
                </a>
			</h4>
		</div>
		<div id="collapseTree-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step2.tpl"}
            </div> 
        </div>
	</div>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFour-2" aria-expanded="false" class="collapsed">
					Select plugins to install and activate (optional)
                </a>
			</h4>
		</div>
		<div id="collapseFour-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step3.tpl"}
            </div> 
        </div>
	</div>
	{if !$arrBlog.id}
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseFive-2" aria-expanded="false" class="collapsed">
					Create first post (optional)
                </a>
			</h4>
		</div>
		<div id="collapseFive-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step4.tpl"}
            </div> 
        </div>
	</div>
	{/if}
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseSix-2" aria-expanded="false" class="collapsed">
					Technical details
                </a>
			</h4>
		</div>
		<div id="collapseSix-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step5.tpl"}
            </div> 
        </div>
	</div>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion-test-2" href="#collapseSeven-2" aria-expanded="false" class="collapsed">
					Advanced options (optional)
                </a>
			</h4>
		</div>
		<div id="collapseSeven-2" class="panel-collapse collapse"> 
            <div class="panel-body">
                {include file="create/inc_create_step6.tpl"}
            </div> 
        </div>
	</div>
</div>
	<fieldset style="border:none;">
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="arrBlog[flg_settings]" {if $arrBlog.flg_settings} checked='1' {/if} value="1">
				<label>Save settings of this blog</label>
			</div>
		</div>
		<div class="form-group">
			<div class="checkbox checkbox-primary">
				<input type="checkbox" name="arrBlog[syndication]" {if $arrBlog.syndication||(empty( $arrBlog.id )&&empty( $arrErr ))} checked=""{/if} />
				<label>Add site to syndication network</label>
			</div>
		</div>
		<div class="form-group">
			<button type="submit" class="button btn btn-success waves-effect waves-light" id="create" {is_acs_write}>{if !$arrBlog.id}Create{else}Save{/if} Blog</button>
		</div>
	</fieldset>
</form>
{literal}
<script type="text/javascript">
//  Exstends to Accordion
var blogFushSwitcher=function(local){
	if( local ){
		$('database-detail').setStyle('display','none');
	} else {
		$('database-detail').setStyle('display','block');
	}

}
var category = new Hash({/literal}{$treeJson}{literal});
var categoryId = {/literal}{$arrBlog.category_id|default:0}{literal};
var myAccordion = new Class({
	Extends: Fx.Accordion,
	initialize: function(container, toggler, element, options){
		this.parent(container, toggler, element, options);
		this.initButton();
	}, 
	initButton:function(){
		this.prev = $$('a.acc_prev');
		this.next = $$('a.acc_next');		
		var obj = this;
		this.prev.each(function(el){
			el.removeEvents('click');
			el.addEvent('click',function(e){e.stop(); obj.display(obj.previous-1);   });
		});
		this.next.each(function(el){
			el.removeEvents('click');
			el.addEvent('click',function(e){e.stop(); obj.display(obj.previous+1);
			
			var myFx = new Fx.Scroll(document.body, {
    		offset: {
        		'x': 0,
        		'y': 260
    			}
			}).toTop();
			
			});
		});
		$('create_form').show();
	},
	add:function(){
		$('proprietary').style.display='block';
		$('toggler').addClass('toggler');
		$('toggler').getNext().addClass('element');
		this.addSection($('toggler'),$('toggler').getNext());
		$('toggler').getNext().addClass('initElement');
		$$('div.initElement').each(function(div,index){
			div.set('id',index);
		});
		this.initButton();
		this.clearEvent();
		this.initialize($('accordion'), $$('.toggler'), $$('.element'));
	},
	deleteSection:function(init){
		//$('proprietary').style.display='none';
		//$('toggler').removeClass('toggler');
		//$('toggler').getNext().removeClass('element');
		//$('toggler').getNext().removeClass('initElement');
		$$('div.initElement').each(function(div,index){
			div.set('id',index);
		});
		
		if( init ) {
			this.clearEvent();
			this.initialize($('accordion'), $$('.toggler'), $$('.element'));
		}
	},
	clearEvent:function(){
		$$('.toggler').each(function(el){
			el.removeEvents(this.trigger);
		});
	}
});
var jsonSettings = {/literal}'{$jsonSettings}'{literal};
var prop = false;
// Visual Form Effects
var visualEffect = new Class({
	initialize: function(){
		this.initShuffel();
		this.selectPlugin();
		this.headerBar();
		this.initTheme();
		this.initCategory();
		this.initMaster();
	},
	initMaster: function(){
		if ( !$('masterBlog') ){
			return false;
		}
		$('masterBlog').addEvent('change', function(){
			this.setMaster($('masterBlog').value);
		}.bind(this));
	},
	setMaster: function(id){
		var arrSettings = JSON.decode(jsonSettings);
		var set = false;
		arrSettings.each(function(item){
			if( item.id == id ){
				set = item;
			}
		});
		if ( !set ) {
			return false;
		}
		this.setCategoryFromId(set.category_id); // set Categories
		Array.each($('theme').options,function(option){ // set Theme
			if ( option.value == set.theme[0] ) {
				this.setTheme(option);
			}
		},this);
		// set Next fields
		set = new Hash(set);
		Array.each($('create_form').elements,function(element){ 
			switch(element.tagName) {
				case 'INPUT' : 
					set.each(function(value,key){ 
						// set Plugins
						if ( element.className == 'plugins' && key == 'plugins' ) { 
							value.each(function(p){
								if( element.value == p ){
									element.checked = 1;
								}
							});
						}
						// set all Radio
						if ( element.type == 'radio' && element.name == 'arrBlog['+ key +']' && element.value == value ) {  
							element.checked = 1;
						}						
						// set all Text
						if( element.name == 'arrBlog['+key+']' && element.type != 'checkbox' && element.type != 'radio'
							&& key != 'db_tableprefix' 
							&& key != 'title' 
							&& key != 'ftp_directory' 
							&& key != 'url' ){ 
							element.value = value; 
						}
					});
					if ( element.name == 'arrFtp[address]' ) { element.value = set.ftp_host } 
					if ( element.name == 'arrFtp[username]' ) { element.value = set.ftp_username } 
					if ( element.name == 'arrFtp[password]' ) { element.value = set.ftp_password } 
				break;
				
				case 'TEXTAREA' :  set.each(function(value,key){ if( element.name == 'arrBlog['+key+']'){ element.value = value; } });  break;
				
				default: break;
			}
		},this);
	},
	initCategory: function(){
	$('category').addEvent('change',function(){
		this.setCategory($('category').value,false);
	}.bind(this));
	if(categoryId != 0){
		this.setCategoryFromId(categoryId);
	}
		
	},
	setCategoryFromId: function(id) {
		category.each(function(item){
			var hash = new Hash(item.node);
			hash.each(function(i){
				if(id == i.id){
					this.setCategory(item.id,true);
				}
			},this);
		},this);		
	},
	setCategory: function( pid, selected){
		if( selected ) {
			Array.each($('category').options,function(i){
				if(i.value == pid){
					i.selected=1;
				}
			});
		}
		$('category_child').empty();
		category.each(function(item){
			if( item.id == pid ){
				var hash = new Hash(item.node);
				hash.each(function(v,i){
					var option = new Element('option',{'value':v.id,'html':v.title});
					if(categoryId == v.id){
						option.selected=1;//console.log(v.id);
					}
					option.inject($('category_child'));
				});
			}
			jQuery('#category_child').selectpicker('refresh');
		});		
	},
	selectPlugin:function(){
		$('plugins_all').addEvent('click', function(){
			$$('input.plugins').each(function(el){
				el.checked = $('plugins_all').checked;
			});
		});
	},
	initShuffel: function() {
		$$('a.shuffel').each(function(a){
			var obj = this;
			a.addEvent('click', function(e){
				e.stop();
				obj.shuffel(a.rel);
			});
		},this);
		this.loadShuffel();
	},
	loadShuffel:function(){
		this.html = new Array();
		$$('div.shuffCont').each(function(el,index){
			this.html[el.id]=el.get('html');
		},this);
		$$('input.initShuf').each(function(el){
			var div = el.getNext('div');
			div.set('html', this.html[el.value]);
		},this);		
	},
	shuffel: function(no) {
		var a = $("affiliate").get('html');
		var b = $("subscription").get('html');
		var c = $("adsense_sky").get('html');
		var placeA = $('affilate_place').value;
		var placeB = $('subscription_place').value;
		var placeC = $('adsense_sky_place').value;
		var tempText1 = $('affilated_programs').value;
		var tempText2 = $('subscription_form').value;
		var tempText3 = $('adsense_skycraper').value;
		
		if ( no == 1 ) {
			$("affiliate").set('html',c);
			$("subscription").set('html',a);
			$("adsense_sky").set('html',b);
			$('affilate_place').value = placeC;
			$('subscription_place').value = placeA;
			$('adsense_sky_place').value = placeB;
		} else {
			$("affiliate").set('html',b);
			$("subscription").set('html',c);
			$("adsense_sky").set('html',a);
			$('affilate_place').value = placeB;
			$('subscription_place').value = placeC;
			$('adsense_sky_place').value = placeA;
		}

		$('affilated_programs').value = tempText1;
		$('subscription_form').value = tempText2;
		$('adsense_skycraper').value = tempText3;
				
	},
	headerBar: function(){
		$$('input.header_bar').each(function(el){
			el.addEvent('click', function(){
				$$('div.header_bar_block').each(function(e){e.style.display='none';});
				$(el.value).style.display='block';
				this.addRequired(el);
			}.bind(this));
		},this);
	},
	addRequired:function(el){
		$$('.propRequired').each(function(element){
			element.removeClass('required');
		});
		switch(el.value){
			case 'adsense_code':  $(el.value).getChildren().getChildren('input').each(function(e){e.addClass('required');});break;
			case 'code':  $(el.value).getChildren().getChildren('textarea').each(function(e){e.addClass('required');}); break;
			case 'upload_banner':  $(el.value).getChildren().getChildren('textarea').each(function(e){e.addClass('required');}); break;
		}		
	},
	initTheme: function(){
		if ( !$chk( $('theme') ) ) {
			return;
		}
		var objThis = this;
		$('theme').addEvent('change',function(){
			objThis.setTheme(this.options[this.selectedIndex]);	
		});
		
		$('theme').addEvent('domready', function(){
			objThis.setTheme(this.options[this.selectedIndex]);	
		});
		
  		$("theme").addEvent('keyup', function(event) {
   			if(event.key != 'down' && event.key !='up' ){
   				return false;
   			}   	
   			objThis.setTheme(this.options[this.selectedIndex]);		
  		});
	},
	setTheme: function(element){
		if(element.className.test('prop')) {
			prop = true;
			objAccordion.add();
		} else {
			objAccordion.deleteSection(prop);
			prop = false;
		}
		if(element.tagName == 'IMG' ){
			$('themeImg').empty();
			$('theme').value=element.id;
			var img = new Element('img', {'src':element.getParent('a').href});
			img.inject($('themeImg'));	
		} else {
			element.selected=1;
			$('themeImg').empty();
			var img = new Element('img', {'src':element.title});
			img.inject($('themeImg'));			
		}
	}
});
// create Class
var createBlog = new Class({
	initialize: function(){
		this.testDB();
		this.initEvent();
	},
	initEvent:function(){
		$('domain-settings-id').addEvent('change',function(e){
			var uri=new URI($('cpanel_database_mb').href);
			uri.setData({
				info:'allocate',
				placement_id:this.value
			});
			$('cpanel_database_mb').href=uri.toURI();
		});
	},
	testDB: function(){
		$('test_db').addEvent('click', function(e){
			e.stop();
			var req = new Request({
				url: "{/literal}{url name='site1_blogfusion' action='testdb'}{literal}",
				onRequest: function(){
					$('test_db_loader').style.display='inline';
				},
				onSuccess: function(responseText){
					if( responseText == 'succ') {
						r.alert( 'Messages', 'Connection to Server for this database successfully', 'roar_information' );
					} else if( responseText == 'empty') {
						r.alert( 'Messages', 'Please fill required fields: Blog URL, FTP Address, FTP Username, FTP Password, FTP Homepage Folder, Host Name, Database Name, Database User Name, Database Password', 'roar_error' );
					} else if(responseText == 'error'){
						r.alert( 'Messages', 'Not Connect to database. Please enter correct data.', 'roar_error' );
					}
				},
				onComplete: function(){
					$('test_db_loader').style.display='none';
				}}).post({
						url:$('hosting-settings-url').value,
						db_host:$('db_host').value,
						db_name:$('db_name').value,
						db_username:$('db_user').value,
						db_password: $('db_pass').value,
						placement_id:$('domain-settings-id').value,
						ftp_directory:$('domain-settings-directory').value
					});
		});
	}
});

var redirect=function(url){location.href=url;}

var multibox={};
var visual={};
window.addEvent('domready', function() {
	visual = new visualEffect();
	var create = new createBlog();
	multibox = new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
	$$('div.initElement').each(function(div,index){
		div.set('id',index);
	});
});

var CpanelDatabaseResult = function(hash){
	$('db_name').value = hash.db;
	$('db_user').value = hash.user;
	$('db_pass').value = hash.pass;
}

var CpanelSubdomainResult = function(hash) {
	$('domain').value = 'http://'+hash.subdomain[0]+'.'+hash.root+'/';
}
</script>
{/literal}
