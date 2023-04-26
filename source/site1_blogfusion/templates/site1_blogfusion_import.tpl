<br />
<div align="center">
	<div  style="width:58%;">
		<a class="" href="{url name='site1_blogfusion' action='create'}" rel="create_form">Create blog</a> | 
		<a class="" href="{url name='site1_blogfusion' action='import'}"   class="select_type" rel="import_form">Import blog</a>
	</div>
</div>	
<br />

{include file='../../error.tpl' fields=['placement_id'=>'Domains','ftp_directory'=>'Homepage Folder','title'=>'Blog Name','url'=>'Url','db_host'=>'DB Host Name',
'db_name'=>'Database Name','db_username'=>'Database User Name','db_password'=>'Database Password','dashboad_username'=>'Login ID','dashboad_password'=>'Password']}

<form class="wh validate"  id="import_form" method="POST" action="" >
	{module name='site1_hosting' action='select' selected=$arrBlog arrayName='arrBlog' onlyRemote=true}
	<fieldset>
		<legend>Add Existing Blog </legend>
		<p>
			<label>Blog Name <em>*</em> </label><input type="text" name="arrBlog[title]" class="required text-input medium-input" value="{$arrBlog.title}" />
		</p>
		<p>
			<label>Select Category</label>
			<select id="category" class="required validate-custom-required emptyValue:'0' medium-input" >
			<option value="0"> -select-
			{foreach from=$arrCategories item=i}
				<option {if $arrBlog.category_id == $i.id}selected='1'{/if} value="{$i.id}">{$i.title}
			{/foreach}</select></label>
			<select name="arrBlog[category_id]" class="required  medium-input validate-custom-required emptyValue:'0'" id="category_child" ></select>
		</p>
		<p>
			<label>Add site to syndication network: </label>
			<input type="checkbox" name="arrBlog[syndication]" {if $arrBlog.syndication||(empty( $arrBlog.id )&&empty( $arrErr ))} checked=""{/if} />
		</p>
	</fieldset>
	<fieldset>
		<legend>Database Details</legend>
		<p>
			<label>Host Name <em>*</em></label><input type="text" title="Host Name" class="required text-input medium-input {if $arrErr.filtered.db_host}error{/if}" value="{$arrBlog.db_host}" name="arrBlog[db_host]" id="db_host" /><p>(Please enter host name like "localhost" or "192.168.1.7")</p>
		</p>
		<p>
			<label>Database Name <em>*</em></label><input type="text"  title="Database Name" class="required text-input medium-input {if $arrErr.filtered.db_name}error{/if}"  value="{$arrBlog.db_name}" name="arrBlog[db_name]" id="db_name" />
		</p>
		<p>
			<label>Database User Name <em>*</em></label><input type="text" title="Database User Name" class="required text-input medium-input {if $arrErr.filtered.db_user}error{/if}" value="{$arrBlog.db_username}" name="arrBlog[db_username]" id="db_user" />
		</p>
		<p>
			<label>Database Password <em>*</em></label><input type="password" title="Database Password" class="required text-input medium-input {if $arrErr.filtered.db_password}error{/if}" value="{$arrBlog.db_password}" name="arrBlog[db_password]" id="db_pass" /> <a href="#" id="test_db">Test connection <img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" id="test_db_loader"></a>
		</p>
		<p>
			<label>Table Prefix</label><input type="text" name="arrBlog[db_tableprefix]"  class="text-input medium-input" value="{if $arrBlog.db_tableprefix}{$arrBlog.db_tableprefix}{else}wp_{/if}"/>
		</p>
	</fieldset>
	<fieldset>
		<legend>Dashboard Login detail</legend>
		<p>
			<label>Login ID <em>*</em></label><input type="text" title="Login ID"  class="required text-input medium-input {if $arrErr.filtered.dashboad_username}error{/if}"  value="{$arrBlog.dashboad_username}" name="arrBlog[dashboad_username]" />
		</p>
		<p>
			<label>Password <em>*</em></label><input type="password" title="Password"  value="{$arrBlog.dashboad_password}" class="required text-input medium-input {if $arrErr.filtered.dashboad_password}error{/if}" name="arrBlog[dashboad_password]"/>
		</p>
		<p>
			<input type="submit" id="submit" class="button" value="Import Blog" >
		</p>
	</fieldset>
</form>

{literal}
<style>
.error{border:1px solid red;}
</style>
<script type="text/javascript">
var category = new Hash({/literal}{$treeJson}{literal});
var categoryId = {/literal}{$arrBlog.category_id|default:0}{literal};

// import Class
var importBlog = new Class({
	initialize: function(){
		this.testDB();
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


var visualEffect = new Class({
	initialize: function(){
		this.initCategory();
	},
	initCategory: function(){
		$('category').addEvent('change',function(){
			this.setCategory($('category').value,false);
		}.bind(this));
		if(categoryId != 0){
			category.each(function(item){
				var hash = new Hash(item.node);
				hash.each(function(i){
					if(categoryId == i.id){
						this.setCategory(item.id,true);
					}
				},this);
			},this);
		}
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
		});		
	}
});

// Initialize Class
var multibox={};
window.addEvent('domready', function() {
	var objImport = new importBlog();
	var view = new visualEffect();
	// init multibox
	multibox=new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
});


</script>
{/literal}