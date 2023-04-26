<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		{*<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/mootools/1.3.2/mootools-yui-compressed.js"></script>*}
		<script type="text/javascript" src="http://{$project_domain}/skin/_js/mootools.js"></script>
		<link rel="stylesheet" type="text/css" href="http://{$project_domain}/skin/_css/widget.css" />
		{literal}
		<style>

		</style>
		{/literal}
	</head>
	<body>
	<div id="splash"><div><img src="http://{$project_domain}/skin/i/frontends/design/ajax-loader-w.gif" /></div></div>
	<div class="form">
		<!-- Start Tabs-->
		<ul class="w-tabs">
			<li><a href="#" id="1" class="w-tabs-a active">Profile</a></li>
			<li><a href="#" id="2" class="w-tabs-a">Settings</a></li>
			<li><a href="#" id="3" class="w-tabs-a">Select templates</a></li>
			<li><a href="#" id="4" class="w-tabs-a">Generate</a></li>
		</ul>
		<!-- End tabs-->
		
		<form method="post" class="wh fields" id="form" action="">
			<div class="w-tab-blocks" id="step-1">
				<fieldset>
					<legend >Personal</legend>
						<ol>
							<li><label>First Name <em>*</em>: </label><input type="text"  class="required-profile profile" name="arr[first_name]" value=""></li>
							<li><label>Last Name <em>*</em>: </label><input type="text"  class="required-profile profile" name="arr[last_name]" value=""></li>
							<li><label>Email address: </label><input type="text" class="profile" name="arr[email]" value=""></li>
							<li><label>Autoresponder email: </label><input type="text" class="profile" name="arr[autoresponder_email]" value=""></li>
							<li><label>Your Adsense ID (include pub-) <em>*</em>: </label><input type="text"  class="required-profile profile" name="arr[adsense_id]" value=""></li>
							<li><label>Amazon Associates ID: </label><input type="text" class="profile" name="arr[amazon_associates_id]" value=""></li>
							<li><label>Ebay Affilate ID: </label><input type="text" class="profile" name="arr[ebayaffid]" value=""></li>
							<li><input type="button" name="2" class="button-next" value="Next"/></li>
						</ol>
				</fieldset>
				<input type="hidden" value="1" name="arr[show_google_ads]" >
				<input type="hidden" value="1" name="arr[show_subscribe]" >
				<input type="hidden" value="1" name="arr[show_amazon_ads]" >

				<input type="hidden" value="0" name="arr[show_yahoo_ads]" >
				<input type="hidden" value="0" name="arr[show_search_feed]" >
				<input type="hidden" value="0" name="arr[show_chitika]" >
				<input type="hidden" value="0" name="arr[show_parteners]" >
				<input type="hidden" value="0" name="arr[show_bestseller]" >
				<input type="hidden" value="0" name="arr[show_best_products]" >
				<input type="hidden" value="0" name="arr[show_centers]" >
				<input type="hidden" value="0" name="arr[show_right]" >
				<input type="hidden" value="0" name="arr[show_submit_article_form]" >
				<input type="hidden" value="0" name="arr[switch]" >
				<input type="hidden"  name="arr[no_of_results]" value="10">
				<input type="hidden" name="arr[amazon_country]" value="us"/>
				<input type="hidden"  name="arr[no_of_amazon_products]" value="7">
			</div>
			<div class="w-tab-blocks"  id="step-2" style="display:none">
				<fieldset>
					<legend></legend>
					<ol>
						<li>
							<label>How many sites you want generated <em>*</em>:</label>
							<fieldset>
								<div><label><input type="radio" name="arr[count_sites]" class="count-sites" value="1" id="count_sites" style="float:left;" /></label>&nbsp;<input style="width:20px" name="arr[count_sites_num]" id="count_sites_num" type="text" /><input type="hidden" id="max_sites" value="{$maxSites}"> out of <b>{$maxSites}</b></div>
								<label><input type="radio" name="arr[count_sites]" id="count_sites_all" class="count-sites" value="0" /> All</label>
							</fieldset>
						</li>
						<li>
							<fieldset>
								<legend>Where are you going to install the sites <em>*</em>:</legend>
								<label><input type="radio" value="1" name="arr[type_install]" class="type-install">  each site in a main domain (e.g. http://yoursite.com)</label>
								<label><input type="radio" value="0" name="arr[type_install]" class="type-install">  in subfolders (e.g. http://yourdomain.com/site)</label>
							</fieldset>
						</li>
						<li>
							<input type="button" name="1" class="button-next" value="Back"/>&nbsp;<input type="button" name="3"  class="button-next" value="Next"/>
						</li>
					</ol>
				</fieldset>
			</div>
			<div  class="w-tab-blocks"  id="step-3"  style="display:none">
				<fieldset>
					<legend></legend>
					<ol>
						<li id="select-content-websites">
							<fieldset>
								<legend>Select niche websites <em>*</em>:</legend>
								<label><input type="radio" name="arr[content_template_type]" class="content-templates" id="content_template"  value="1"/>manually</label>
								<label><input type="radio" name="arr[content_template_type]" class="content-templates" id="content_template_auto"  value="0" />automatically</label>
							</fieldset>
						</li>
						<li style="display:none; background:#EEE;" id="content-templates-block">
							<fieldset>
								{foreach from=$arrContent item=i key=k}
								<label><input type="checkbox" name="arr[content_templates][]" class="content-templates-item" value="{$k}"/> {$i}</label>
								{/foreach}
							</fieldset>
						</li>
						<li>
							<fieldset>
								<legend>Select design template <em>*</em>:</legend>
								<label><input type="radio" name="arr[template_type]" class="template" id="design_template" value="1" />manually</label>
								<label><input type="radio" name="arr[template_type]" class="template" value="0" />automatically</label>
							</fieldset>
						</li>
						<li style="display:none; background:#EEE;" id="templates-block">
							<label>&nbsp;</label><select name="arr[template]" id="template-select"><option value=""> -select- {html_options options=$arrTemplates}</select>
						</li>
						<li>
							<input type="button" name="2" class="button-next" value="Back"/>&nbsp;<input type="button" name="4" class="button-next" value="Next"/>
						</li>
					</ol>
				</fieldset>
			</div>
			<div class="w-tab-blocks" id="step-4" style="display:none;">
				<fieldset>
					<ol>
						<li><a href="#" id="get-archive">Generate archive</a></li>
						<li><input type="button" name="3" class="button-next" value="Back"/></li>
					</ol>
				</fieldset>
			</div>
		</form>
	</div>

	<script type="text/javascript">
		{literal}
		var Widget=new Class({
			initialize: function(){
				this.init();
				this.initEvent();
				if( this.checkCookie() ){
					this.setForm();
				}
			},
			init: function(){
				this.params={
					cookie:{
						name:'cnm-widgets',
						expires: 365,
						path:'/'
					},
					tab:{
						className:'.w-tabs-a',
						blockClassName:'.w-tab-blocks'
					},
					url: document.location.href
				};
			},
			initEvent: function(){
				$$( this.params.tab.className ).each(function(element){
					element.addEvent('click',function(e){
						e.stop();
						this.next( element.id );
					}.bind( this ) );
				},this);
				$$('.button-next').each(function(element){
					element.addEvent('click',function(e){
						this.next( element.name );
					}.bind(this));
				},this);
				$$('.content-templates').each(function( element ){
					element.addEvent('click',function(e){
						$('content-templates-block').setStyle('display',(element.value==1)?'block':'none');
					});
				});
				$$('.template').each(function( element ){
					element.addEvent('click',function(e){
						$('templates-block').setStyle('display',(element.value==1)?'block':'none');
					});
				});
				$('get-archive').addEvent('click', function(e){
					e.stop();
					this.get();
				}.bind(this));
				$$('.count-sites').each(function(el){
					el.addEvent('click',function(){
						if( el.value==1 ){
							$('select-content-websites').setStyle('display','block');
							$('content_template_auto').checked=false;
							return;
						}
						$('select-content-websites').setStyle('display','none');
						$('content_template_auto').checked=true;
					});
				})
			},
			get: function(){
				var session=Number.random(10000,1000000);
				$('splash').setStyle('display','block');
				var params=$('form').toQueryString()+'&session='+session;
				var iframe=new Element('iframe',{ id:'downloadIFrame',frameBorder:0,width:0,height:0,src:this.params.url+'&'+params }).inject( document.body );
				this.check.delay(2000,this,session);
			},
			check: function(session){
				var self=this;
				var r=new Request({
					url: self.params.url+'&check='+session,
					onSuccess: function(r){
						if( r == 1 ){
							$('splash').setStyle('display','none');
							document.location.reload();
						} else {
							self.check.delay(1000,self,session);
						}
					}
				}).post();
			},
			next: function( step ){
				if( !this.validateForm( step ) ){
					return false;
				}
				$$( this.params.tab.className ).each( function(el){ el.removeClass('active'); });
				$( step ).addClass('active');
				$$( this.params.tab.blockClassName ).each( function(el){ el.setStyle('display','none') });
				$( 'step-'+step ).setStyle('display','block');
			},
			validateForm: function( step ){
				switch( step ){
					case '2':
						if( $$('.required-profile').some(function(element){ return element.value==''; }) ){
							alert('Fill all required fields');
							return false;
						}
						this.saveCookie();
						break;
					case '3':
						if( !$$('.count-sites').some(function(element){ return element.checked; }) ){
							alert('Please select, how many sites you want generated');
							return false;
						}
						if( $('count_sites').checked && $('count_sites_num').value=='' ){
							alert('Please enter, how many sites you want');
							return false;
						}
						if( $('count_sites').checked && $('count_sites_num').value > $('max_sites').value ){
							alert('Number can\'t be more '+$('max_sites').value);
							return false;
						}
						if( !$$('.type-install').some(function(element){ return element.checked; }) ){
							alert('Please select, where are you going to install the sites');
							return false;
						}
						break;
					case '4':
						if( !$$('.content-templates').some(function(element){ return element.checked; }) ){
							alert('Please select content template');
							return false;
						}
						if( $('content_template').checked && !$$('.content-templates-item').some(function(element){ return element.checked; }) ){
							alert('Please select niche websites');
							return false;
						}
						if( !$$('.template').some(function(element){ return element.checked; }) ){
							alert('Please select design template');
							return false;
						}
						if( $('design_template').checked && $('template-select').value=='' ){
							alert('Please select design template');
							return false;
						}
						break;
				}
				return true;
			},
			saveCookie: function(){
				var hash=new Hash();
				$$('.profile').each(function(item){
					if( item.type == 'checkbox' ||  item.type == 'radio' ){
						if( item.checked ){
							hash.set(item.name, item.value );
						}
					} else {
						hash.set(item.name,item.value);
					}
				});
				var cookie=new Hash.Cookie( this.params.cookie.name,  {duration: this.params.cookie.expires } );
				cookie.set('profile',hash);
				cookie.save();
			},
			checkCookie: function(){
				var cookie=new Hash.Cookie( this.params.cookie.name,  {duration: this.params.cookie.expires } );
				this.hashData=new Hash(cookie.get('profile'));
				return (this.hashData!=null);
			},
			setForm: function(){
				this.hashData.each(function(value,name){
					$$('.profile').each(function(element){
						if( element.name == name && ( element.type != 'checkbox' && element.type != 'radio')){
							element.value=value;
						}
						if( (element.type == 'checkbox' || element.type == 'radio' ) && element.name==name ){
							element.checked=( value==element.get('value') )? true:false;
						}
					});
				});
			}
		});
		window.addEvent('domready',function(){
			new Widget();
		});


	</script>
	{/literal}
	</body>
</html>