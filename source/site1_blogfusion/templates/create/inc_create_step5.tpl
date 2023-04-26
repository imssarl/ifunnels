<div class="form-group">
	<fieldset id="database-detail">
		<legend>Database Detail</legend>
		<div class="form-group">
			<label>Host Name <em>*</em></label>
			<input type="text" title="Host Name" class="required text-input medium-input {if $arrErr.filtered.db_host}error{/if} form-control" value="{$arrBlog.db_host}" name="arrBlog[db_host]" id="db_host" />
			<p>(Please enter host name like "localhost" or "192.168.1.7")</p>
		</div>
		<div class="form-group">
			Createe new database and users: {module name='cpanel_tools' action='set' type='database' info='allocate'} or fill database detail below
		</div>
		<div class="form-group">
			<label>Database Name <em>*</em></label>
			<input type="text"  title="Database Name" class="required text-input medium-input {if $arrErr.filtered.db_name}error{/if} form-control"  value="{$arrBlog.db_name}" name="arrBlog[db_name]" id="db_name" />
		</div>
		<div class="form-group">
			<label>Database User Name <em>*</em></label>
			<input type="text" title="Database User Name" class="required text-input medium-input {if $arrErr.filtered.db_user}error{/if} form-control" value="{$arrBlog.db_username}" name="arrBlog[db_username]" id="db_user" />
		</div>
		<div class="form-group">
			<label>Database Password <em>*</em></label>
			<input type="password" title="Database Password" class="required text-input medium-input {if $arrErr.filtered.db_password}error{/if} form-control" value="{$arrBlog.db_password}" name="arrBlog[db_password]" id="db_pass" /> <a href="#" id="test_db">Test connection <img src="/skin/i/frontends/design/ajax-loader_new.gif" style="display:none;" id="test_db_loader"></a>
		</div>
		<div class="form-group">
			<label>Table Prefix</label>
			<input type="text" name="arrBlog[db_tableprefix]" class="text-input medium-input form-control"  value="{$arrBlog.db_tableprefix}"/>
		</div>
	</fieldset>
	<fieldset>
		<legend>Dashboard Login detail</legend>
		<div class="form-group">
			<label>Login ID <em>*</em></label>
			<input type="text" title="Login ID" class="required text-input medium-input {if $arrErr.filtered.dashboad_username}error{/if} form-control"  value="{$arrBlog.dashboad_username}" name="arrBlog[dashboad_username]" />
		</div>
		<div class="form-group">
			<label>Password <em>*</em></label>
			<input type="password" title="Password"  value="{$arrBlog.dashboad_password}" class="required text-input medium-input {if $arrErr.filtered.dashboad_password}error{/if} form-control" name="arrBlog[dashboad_password]"/>
		</div>
		<div class="form-group">
			<a href="#" class="acc_prev button">Prev step</a> <a href="#" class="acc_next button">Next step</a>
		</div>
	</fieldset>
</div>