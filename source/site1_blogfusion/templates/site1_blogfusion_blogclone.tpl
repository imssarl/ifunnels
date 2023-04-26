<br/>
<br/>
{include file='../../error.tpl' fields=['placement_id'=>'Domains','ftp_directory'=>'Homepage Folder','title'=>'Blog Name','url'=>'Url','db_host'=>'DB Host Name',
'db_name'=>'Database Name','db_username'=>'Database User Name','db_password'=>'Database Password','dashboad_username'=>'Login ID','dashboad_password'=>'Password']}

<form  class="wh validate"  id="create_form" method="POST" action="">
{module name='site1_hosting' action='select' selected=$arrBlog arrayName='arrBlog' flg_bf=1}
	<fieldset>
		<legend>New Blog Settings</legend>
		<p>
			<label>Blog Name <em>*</em></label><input type="text" name="arrBlog[title]" value="{$arrBlog.title}" class="required text-input medium-text"/>
		</p>
		<div  id="database-detail">
			<p>
				Createe new database and users: {module name='cpanel_tools' action='set' type='database' info='allocate'}  or fill database detail below
			</p>
			<p>
				<label>Database Host Name <em>*</em></label><input type="text" title="Host Name" class="required  text-input medium-text {if $arrErr.filtered.db_host}error{/if}" value="{$arrBlog.db_host}" name="arrBlog[db_host]" id="db_host" /><p>(Please enter host name like "localhost" or "192.168.1.7")</p>
			</p>
			<p>
				<label>Database Name <em>*</em></label><input type="text"  title="Database Name" class="required  text-input medium-text {if $arrErr.filtered.db_name}error{/if}"  value="{$arrBlog.db_name}" name="arrBlog[db_name]" id="db_name" />
			</p>
			<p>
				<label>Database User Name <em>*</em></label><input type="text" title="Database User Name" class="required text-input medium-text {if $arrErr.filtered.db_user}error{/if}" value="{$arrBlog.db_username}" name="arrBlog[db_username]" id="db_user" />
			</p>
			<p>
				<label>Database Password <em>*</em></label><input type="password" title="Database Password" class="required text-input medium-text {if $arrErr.filtered.db_password}error{/if}" value="{$arrBlog.db_password}" name="arrBlog[db_password]" id="db_pass" /> <a href="#" id="test_db">Test connection <img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" id="test_db_loader"></a>
			</p>
			<p>
				<label>Table Prefix</label><input type="text" name="arrBlog[db_tableprefix]"  class=" text-input medium-text" value="{$arrBlog.db_tableprefix}"/>
			</p>
		</div>
		<p>
			<label>Clone blog without posts</label><input type="hidden" name="arrBlog[without_post]" value="0"><input type="checkbox" name="arrBlog[without_post]" value="1" />
		</p>
		<p>
			<label>Clone blog without pages</label><input type="hidden" name="arrBlog[without_page]" value="0"><input type="checkbox" name="arrBlog[without_page]" value="1" />
		</p>
	</fieldset>
	<fieldset>
		<legend>New Dashboard Login detail</legend>
		<p>
			<label>Login ID <em>*</em></label><input type="text" title="Login ID"  class="required text-input medium-text {if $arrErr.filtered.dashboad_username}error{/if}"  value="{$arrBlog.dashboad_username}" name="arrBlog[dashboad_username]" />
		</p>
		<p>
			<label>Password <em>*</em></label><input type="password" title="Password"  value="{$arrBlog.dashboad_password}" class="required text-input medium-text {if $arrErr.filtered.dashboad_password}error{/if}" name="arrBlog[dashboad_password]"/>
		</p>
		<p>
			<input type="submit" class="button" value="Clone" id="create" {is_acs_write}/>
		</p>
	</fieldset>
</form>

{literal}
<script type="text/javascript">
var blogFushSwitcher=function(local){
	if( local ){
		$('database-detail').setStyle('display','none');
	} else {
		$('database-detail').setStyle('display','block');
	}

}
// create Class
var createBlog = new Class({
	initialize: function(){
		this.testDB();
//		this.create();
	},
	testDB: function(){
		$('test_db').addEvent('click', function(e){
			e.stop();
			
			var password = encodeURIComponent($('ftp_password').value);
			var req = new Request({url: "{/literal}{url name='site1_blogfusion' action='testdb'}{literal}",onRequest: function(){$('test_db_loader').style.display='inline';}, onSuccess: function(responseText){
				if( responseText == 'succ') {
					r.alert( 'Messages', 'Connection to Server for this database successfully', 'roar_information' );
				} else if( responseText == 'empty') {
					r.alert( 'Messages', 'Please fill required fields: Blog URL, FTP Address, FTP Username, FTP Password, FTP Homepage Folder, Host Name, Database Name, Database User Name, Database Password', 'roar_error' );
				} else if(responseText == 'error'){
					r.alert( 'Messages', 'Not Connect to database. Please enter correct data.', 'roar_error' );
				}
			}, onComplete: function(){$('test_db_loader').style.display='none';} }).post({'url':$('domain').value, 'db_host':$('db_host').value, 'db_name':$('db_name').value, 'db_username':$('db_user').value, 'db_password': $('db_pass').value, 'ftp_host':$('ftp_address').value, 'ftp_username':$('ftp_username').value, 'ftp_password':password, 'ftp_directory':$('ftp_directory').value});
		});
	}/*,
	create: function() {
		var obj = this;
		$('create').addEvent('click', function(e){
			e.stop();
			var valid = new myVaidator($('create_form'));
			if(!valid.startValidate()) {
				return false;
			}
			$('create_form').submit();
			$('create').disabled=true;
		});
	}*/
});
var multibox={};
window.addEvent('domready',function(){ 
	new createBlog();
	multibox = new CeraBox( $$('.mb'), {
		group: false,
		width:'{/literal}{$arrUser.arrSettings.popup_width}{literal}%',
		height:'{/literal}{$arrUser.arrSettings.popup_height}{literal}%',
		displayTitle: true,
		titleFormat: '{title}'
	});
})
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