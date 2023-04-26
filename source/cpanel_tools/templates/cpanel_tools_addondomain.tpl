<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	{module name='site1' action='head'}

	<link href="/skin/_css/tips.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="/skin/_css/site1.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="/skin/_css/style1.css" rel="stylesheet" type="text/css" media="screen" />
	<script type="text/javascript" src="/skin/_js/mootools.js"></script>
	<script type="text/javascript" src="/skin/_js/xlib.js"></script>
	{*validator*}
	<script type="text/javascript" src="/skin/_js/validator/validator.js"></script>
	<link rel="stylesheet" type="text/css" href="/skin/_js/validator/style.css">
	{*/validator*}
	<script type="text/javascript">
	{literal}
		window.addEvent('domready',function(){
			validator=new WhValidator({className:'validate'});
		});
	{/literal}
	</script>
</head>
<body style="padding:10px;">
<div>
	{if $error}
	<div class="red" style="padding:10px;">
		{if $error == '001'}
			Process Aborted. Can not connect
		{elseif $error == '002'}
			Process Aborted. Can not create Addon Domain
		{/if}
	</div>
	{/if}
	{if  !empty($result)}
	<div class="grn" style="padding:10px;">
		{$result.domain} has been setup. It can be accessed via the subdomain {$result.user}.{$host}. FTP access has been granted with the user name {$result.user} and the password {$result.pass}
	</div>
	{/if}
</div>
	<form class="wh validate" action="" id="wh-form" method="POST" style="width:100%;"> 
		<fieldset>
			<legend>cPanel info</legend>
			<ol>
				<li>
					<label>Hostname</label>
					<input type="text" name="arrCpanel[host]" id="cpanel_host" class="required" />&nbsp;<a href="Hostname (eg. qjmp.com)" class="Tips" title="Example">?</a>
				</li>
				<li>
					<label>Username</label>
					<input type="text" name="arrCpanel[user]" id="cpanel_user" class="required"  />&nbsp;<a href="Cpanel username" class="Tips" title="Example">?</a>
				</li>
				<li>
					<label>Password</label>
					<input type="password" name="arrCpanel[passwd]" id="cpanel_passwd" class="required"  />&nbsp;<a href="Cpanel password" class="Tips" title="Example">?</a>
				</li>
				<li>
					<label>cPanel Theme / Skin</label>
					<select name="arrCpanel[theme]"  id="cpanel_theme">
						<option value="x">x 
						<option value="x2">x2 
						<option value="x3">x3 
						<option value="other">other 
					</select>&nbsp;<a href="<div style='width:300px;'><strong>Try following steps if you do not know what your current cPanel theme is:</strong> 	
					<ul>
	  					<li>- Login to your cPanel account</li>
	  					<li>- Look at the URL in your browser. It would look somewhat similar to <strong>http://www.hosting.com:2082/frontend/x/index.html</strong></li>
	  					<li>- cPanel  theme	name is everything after the &quot;/frontend/&quot;, and before the next  slash &quot;/&quot;. In above example cPanel theme is &quot;x&quot;. It could be &quot;x2&quot;,  &quot;rvblue&quot;, etc.</li>
					</ul></div>"  
					class="Tips" title="cPanel Theme / Skin">?</a>
				</li>
				<li id="other">
					<label>&nbsp;</label>
				</li>
				<li>
					<p><font color="Red">Note</font>: Please Check your cpanel theme/skin before select.The script will not work if wrong cPanel theme is selected. Usually cPanel skin name would be "x", but yours may be different.</p>
				</li>
			</ol>
		</fieldset>
		<fieldset>
			<legend>New Addons</legend>
			<ol>
				<li>
					<label>New Domain</label>
					<input type="text" name="arrAction[domain]" id="addon_domain" class="required" />&nbsp;<a href="Domain Name (Do not put any http:// or www)" class="Tips" title="Example">?</a> 
				</li>
		</fieldset>
				
		<fieldset>	
			<legend>Username/directory/subdomain</legend>	
				<li>
					<label>Name</label>
					<input type="text" name="arrAction[user]" id="addon_subdomain" class="required"  />&nbsp;<a href="New Username" class="Tips" title="Example">?</a>
				</li>
				
				<li>
					<label>Password</label>
					<input type="password" name="arrAction[pass]" id="addon_passwd" class="required"  />&nbsp;<a href="New Password" class="Tips" title="Example">?</a>
				</li>
				
				<li>
					<input type="submit" name="submit" value="Submit" />
				</li>
			</ol>
		</fieldset>
	</form>
	<script type="text/javascript">
	var info = '{$smarty.get.info|default:'none'}';
	var cPanelResult = '{$jsonResult}';
	{literal}
	window.addEvent('domready', function() {
		var hash = new Hash(JSON.decode(cPanelResult));
		if(hash.getLength() > 0 && info == 'allocate'){
			window.parent.CpanelAddonResult(hash);
		}		
		$('cpanel_theme').addEvent('change',function(){
			if( $('cpanel_theme').value  == 'other' ) {
				var input = new Element('input', {'type':'text','name':'arrCpanel[theme]', 'id':'input_other', 'class':'required'}).inject($('other'));
				var example = new Element('a',{'href':'Your cPanel skin name','title':'Example','class':'Tips'}).set('html','&nbsp;?').injectInside($('other'));
				var optTipsSmall = new Tips('.Tips', {className: 'tips'});
			} else {
				if($('input_other')) {
					$('input_other').destroy();
				}
			}
			validator=new WhValidator({className:'validate'});
		});
		var optTips = new Tips('.Tips', {className: 'tips'});		
		$$('.Tips').each(function(a){a.addEvent('click',function(e){e.stop()})});		
	});
	{/literal}
	</script>
	
</body>
</html>	