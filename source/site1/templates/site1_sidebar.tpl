<div class="left side-menu">
	<div class="sidebar-inner slimscrollleft">
		<!--- Divider -->
		<div id="sidebar-menu">
			<ul>
				<li class="has_sub">
					<a href="/" class="waves-effect {if empty($arrNest.name)}active{/if}"><i class="ti-home"></i> <span>Dashboard</span> </a>
				</li>
				{if Core_Acs::haveRight( ['site1_hosting'=>['addomain&hosting']] ) || Core_Acs::haveRight( ['site1_hosting'=>['mydomains']] ) || Core_Acs::haveRight( ['site1_hosting'=>['mydomains_externally']] )}
					<li class="has_sub">
						<a href="#" class="waves-effect {if $arrNest.name=='site1_hosting'||$arrNest.name=='site1_domain_parking'}active{/if}"><i class="ti-star"></i><span>Domains & Hosting</span> </a>
						<ul class="list-unstyled">
							{if Core_Acs::haveRight( ['site1_hosting'=>['addomain']] )}
								<li class="{if $arrNest.name=='site1_hosting'&&$arrNest.action=='add'}active{/if}"><a class=" popup-sidebar" href="{url name='site1_hosting' action='addomain'}?flg_type=1">Add A New Domain</a></li>
							{/if}
							{if Core_Acs::haveRight( ['site1_hosting'=>['mydomains']] )}
								<li class="{if $arrNest.name=='site1_hosting'&&$arrNest.action=='mydomains'}active{/if}"><a href="{url name='site1_hosting' action='mydomains'}">Domains Hosted With Us</a></li>
							{/if}
							{*
							{if Core_Acs::haveRight( ['site1_hosting'=>['mydomains_externally']] )}
								<li class="{if $arrNest.name=='site1_hosting'&&$arrNest.action=='mydomains_externally'}active{/if}"><a href="{url name='site1_hosting' action='mydomains_externally'}">Domains Hosted Externally</a></li>
							{/if}
							*}
						</ul>
					</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_deliver'=>['dashboard']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='site1_deliver'}active{/if}"><i class="ti-money"></i><span>Deliver</span> </a>
					<ul class="list-unstyled">
						<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='dashboard'}active{/if}"><a href="{url name='site1_deliver' action='dashboard'}">Dashboard</a></li>
						<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='settings'}active{/if}"><a href="{url name='site1_deliver' action='settings'}">Settings</a></li>
						<li class="{if $arrNest.name=='site1_deliver' && in_array($arrNest.action, array('discounts', 'discounts_set'))}active{/if}"><a href="{url name='site1_deliver' action='discounts'}">DisCounts<span class="label label-warning m-l-10">Beta</span></a></li>
						<li class="{if $arrNest.name=='site1_deliver' && in_array($arrNest.action, array( 'memberships', 'memberships_site', 'memberships_plans', 'memberships_create_plan', 'webhook', 'automate' ) )}active{/if}"><a href="{url name='site1_deliver' action='memberships'}">Memberships</a></li>
						<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='sales'}active{/if}"><a href="{url name='site1_deliver' action='sales'}">Sales</a></li>
						<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='subscriptions'}active{/if}"><a href="{url name='site1_deliver' action='subscriptions'}">Subscriptions</a></li>
						<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='members'}active{/if}"><a href="{url name='site1_deliver' action='members'}">Members</a></li>
						<li class="{if $arrNest.name=='site1_deliver' && $arrNest.action=='leads'}active{/if}"><a href="{url name='site1_deliver' action='leads'}">Leads</a></li>
					</ul>
				</li>
				{/if}
				{*<li class="has_sub">
					<a href="{url name='site1_accounts' action='credits'}" class="waves-effect {if $arrNest.name=='site1_accounts'&&$arrNest.action=='credits'}active{/if}"><i class="ti-paint-bucket"></i> <span>Buy Credits</span> </a>
				</li>*}
				{if Core_Acs::haveAccess( array( 'SP_USERS' ) )}
					<li class="has_sub">
						<a href="#" class="waves-effect {if $arrNest.name=='site1_sp'}active{/if}"><i class="ti-light-bulb"></i><span>Service Provider</span> </a>
						<ul class="list-unstyled">
							<li class="{if $arrNest.name=='site1_sp'&&$arrNest.action=='manage'}active{/if}"><a href="{url name='site1_sp' action='manage'}">Manage Accounts</a></li>
							<li class="{if $arrNest.name=='site1_sp'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_sp' action='create'}">Create New Account</a></li>
						</ul>
					</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_funnels'=>['dashboard']] )}
					<li class="has_sub">
						<a href="#" class="waves-effect {if $arrNest.name=='site1_funnels'}active{/if}"><i class="ti-light-bulb"></i><span>Affiliate Funnels</span> </a>
						<ul class="list-unstyled">
							<li class="{if $arrNest.name=='site1_funnels'&&$arrNest.action=='dashboard'}active{/if}"><a href="{url name='site1_funnels' action='dashboard'}">Dashboard</a></li>
							<li class="{if $arrNest.name=='site1_funnels'&&$arrNest.action=='settings'}active{/if}"><a href="{url name='site1_funnels' action='settings'}">Settings</a></li>
							<li class="{if $arrNest.name=='site1_funnels'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_funnels' action='create'}">Create Funnel</a></li>
							<li class="{if $arrNest.name=='site1_funnels'&&$arrNest.action=='manage'}active{/if}"><a href="{url name='site1_funnels' action='manage'}">Your Funnels</a></li>
							<li class="{if $arrNest.name=='site1_funnels'&&$arrNest.action=='leads'}active{/if}"><a href="{url name='site1_funnels' action='leads'}">Your Leads</a></li>
						</ul>
					</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_ecom_funnels'=>['create']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='site1_ecom_funnels'}active{/if}"><i class="ti-wand"></i><span>iFunnels Studio</span> </a>
					<ul class="list-unstyled">
						<li class="{if $arrNest.name=='site1_ecom_funnels'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_ecom_funnels' action='create'}">Create New Funnel</a></li>
						<li class="{if $arrNest.name=='site1_ecom_funnels'&&$arrNest.action=='manage'}active{/if}"><a href="{url name='site1_ecom_funnels' action='manage'}">Manage Funnels</a></li>
						<li class="{if $arrNest.name=='site1_ecom_funnels'&&$arrNest.action=='reporting'}active{/if}"><a href="{url name='site1_ecom_funnels' action='reporting'}">Reporting</a></li>
						{if Core_Acs::haveRight( ['site1_ecom_funnels'=>['optimization']] )}
						<li class="{if $arrNest.name=='site1_ecom_funnels' && $arrNest.action=='optimization'}active{/if}"><a href="{url name='site1_ecom_funnels' action='optimization'}">Optimize <span class="label label-warning m-l-10">Beta</span></a></li>
						{/if}
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['email_funnels'=>['frontend_settings']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='email_funnels'}active{/if}"><i class="ti-email"></i><span>Email Funnels</span> </a>
					<ul class="list-unstyled">
						{if Core_Acs::haveRight( ['email_funnels'=>['dashboard']] )}<li class="{if $arrNest.action=='dashboard'&&$arrNest.name=='email_funnels'}active{/if}"><a href="{url name='email_funnels' action='dashboard'}">Dashboard</a></li>{/if}
						<li class="{if $arrNest.name=='email_funnels'&&$arrNest.action=='frontend_settings'}active{/if}"><a href="{url name='email_funnels' action='frontend_settings'}">Settings</a></li>
						<li class="{if $arrNest.name=='email_funnels'&&$arrNest.action=='frontend_set'}active{/if}"><a href="{url name='email_funnels' action='frontend_set'}">Create Funnel</a></li>
						<li class="{if $arrNest.name=='email_funnels'&&$arrNest.action=='frontend_manage'}active{/if}"><a href="{url name='email_funnels' action='frontend_manage'}">Your Funnels</a></li>
						<li class="{if $arrNest.name=='email_funnels'&&$arrNest.action=='contacts'}active{/if}"><a href="{url name='email_funnels' action='contacts'}">Contacts</a></li>   
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_automations'=>['frontend_set']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='site1_automations'}active{/if}"><i class="ti-exchange-vertical"></i><span>Automate</span> </a>
					<ul class="list-unstyled">
						<li class="{if $arrNest.name=='site1_automations'&&$arrNest.action=='frontend_set'}active{/if}"><a href="{url name='site1_automations' action='frontend_set'}">Create Automation</a></li>
						<li class="{if $arrNest.name=='site1_automations'&&$arrNest.action=='frontend_manage'}active{/if}"><a href="{url name='site1_automations' action='frontend_manage'}">Manage Automations</a></li>
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_valudations'=>['settings']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='site1_valudations'}active{/if}"><i class="ti-id-badge"></i><span>Validate</span> </a>
					<ul class="list-unstyled">
						<li><a>Email Validations Available: <span class="label label-table label-success">{Core_Payment_Purse::getAmount()*250+Core_Users::$info['validation_limit']}</span></a></li>
						<li class="{if $arrNest.name=='site1_valudations'&&$arrNest.action=='buy_credits'}active{/if}"><a href="{url name='site1_valudations' action='buy_credits'}">Buy Credits</a></li>
						<li class="{if $arrNest.name=='site1_valudations'&&$arrNest.action=='settings'}active{/if}"><a href="{url name='site1_valudations' action='settings'}">Settings</a></li>
						<li class="{if $arrNest.name=='site1_valudations'&&$arrNest.action=='verifications'}active{/if}"><a href="{url name='site1_valudations' action='verifications'}">Verifications</a></li>
						<li class="{if $arrNest.name=='site1_valudations'&&$arrNest.action=='integrate'}active{/if}"><a href="{url name='site1_valudations' action='integrate'}">Integrate</a></li>  
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveAccess( array( 'email test group' ) )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='site1_accounts'&&$arrNest.action=='history'}active{/if}{if $arrNest.action!='themes'&&in_array($arrNest.name,array('site1_nvsb','site1_ncsb','site1_blogfusion','site1_wizard'))}active{/if}"><i class="ti-spray"></i> <span> AzonFunnels </span> </a>
					<ul class="list-unstyled">
						{if ( Core_Acs::haveRight(['site1_nvsb'=>['create']])||Core_Acs::haveRight(['site1_ncsb'=>['create']])||Core_Acs::haveRight(['site1_blogfusion'=>['create']])||Core_Acs::haveRight(['zonterest'=>['icon']]) ) && !Core_Acs::haveAccess( array( 'DFY' ) )}
							<li><a href="#wizards" class="popup-main-wizards">Create Stores</a></li>
						{/if}
						{if Core_Acs::haveRight(['site1_nvsb'=>['manage']])||Core_Acs::haveRight(['site1_ncsb'=>['manage']])||Core_Acs::haveRight(['site1_blogfusion'=>['manage']])||Core_Acs::haveRight(['zonterest'=>['icon']])}
							<li><a href="{url name='site1_zonterest' action='manage'}">Manage Stores</a></li>
						{/if}
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_squeeze'=>['customization']] ) || Core_Acs::haveRight( ['site1_squeeze'=>['manage_split']] ) || Core_Acs::haveRight( ['site1_contentbox'=>['create']] ) }
				<li class="has_sub">
					<a href="#" class="waves-effect {if in_array($arrNest.name,array('site1_squeeze','site1_exquisite_popups', 'site1_contentbox'))}active{/if}"><i class="ti-pencil-alt"></i><span> Lead Funnels </span></a>
					<ul class="list-unstyled">
						{if Core_Acs::haveRight( ['site1_squeeze'=>['customization']] )}<li class="{if $arrNest.name=='site1_squeeze'&&$arrNest.action=='customization'}active{/if}"><a href="{url name='site1_squeeze' action='customization'}">Squeeze Page Builder</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_squeeze'=>['manage_squeeze']] )}<li class="{if $arrNest.name=='site1_squeeze'&&$arrNest.action=='manage_squeeze'}active{/if}"><a href="{url name='site1_squeeze' action='manage_squeeze'}">Your Landing Pages</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_squeeze'=>['reporting']] )}<li class="{if $arrNest.name=='site1_squeeze'&&$arrNest.action=='reporting'}active{/if}"><a href="{url name='site1_squeeze' action='reporting'}">Reporting</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_squeeze'=>['manage_split']] )}<li class="{if $arrNest.name=='site1_squeeze'&&$arrNest.action=='manage_split'}active{/if}"><a href="{url name='site1_squeeze' action='manage_split'}">Split Testing</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_contentbox'=>['create']] )}<li class="{if $arrNest.name=='site1_contentbox'}active{/if}"><a href="{url name='site1_contentbox' action='create'}">Content Builder </a></li>{/if}
						{if Core_Acs::haveRight( ['site1_contentbox'=>['manage']] )}<li class="{if $arrNest.name=='site1_contentbox'}active{/if}"><a href="{url name='site1_contentbox' action='manage'}">Manage Content Boxes </a></li>{/if}
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_mooptin'=>['create']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if in_array($arrNest.name,array('site1_mooptin') ) || ( $arrNest.name=='site1_squeeze'&&$arrNest.action=='subscribers' ) }active{/if}"><i class="ti-hand-point-right"></i><span> Lead Channels </span></a>
					<ul class="list-unstyled">
						<li class="{if $arrNest.name=='site1_mooptin'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_mooptin' action='create'}">Create Lead Campaign </a></li>
						<li class="{if $arrNest.name=='site1_mooptin'&&$arrNest.action=='manage'}active{/if}"><a href="{url name='site1_mooptin' action='manage'}">Your Lead Campaigns </a></li>
						<li class="{if $arrNest.name=='site1_mooptin'&&$arrNest.action=='autoresponders'}active{/if}"><a href="{url name='site1_mooptin' action='autoresponders'}">Lead Channel Settings </a></li>
						<li class="{if $arrNest.name=='site1_squeeze'&&$arrNest.action=='subscribers'}active{/if}"><a href="{url name='site1_squeeze' action='subscribers'}">Lead Contacts </a></li>
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_publisher'=>['project_create']] ) || Core_Acs::haveRight( ['site1_publisher'=>['projects_manage']] ) || Core_Acs::haveRight( ['site1_articles'=>['rewriter']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if in_array($arrNest.name,array('site1_publisher','site1_articles','site1_syndication','site1_video_manager'))}active{/if}"><i class="ti-menu-alt"></i><span>Content Publishing </span></a>
					<ul class="list-unstyled">
						{if Core_Acs::haveRight( ['site1_publisher'=>['project_create']] )}<li class="{if $arrNest.name=='site1_publisher'&&$arrNest.action=='project_create'}active{/if}"><a href="{url name='site1_publisher' action='project_create'}">Publish Content</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_publisher'=>['projects_manage']] )}<li class="{if $arrNest.name=='site1_publisher'&&$arrNest.action=='projects_manage'}active{/if}"><a href="{url name='site1_publisher' action='projects_manage'}">Manage Publishing Projects</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_articles'=>['rewriter']] )}<li class="{if $arrNest.name=='site1_articles'&&$arrNest.action=='rewriter'}active{/if}"><a href="{url name='site1_articles' action='rewriter'}">Content Rewriter</a></li>{/if}
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_traffic'=>['campaign']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if in_array($arrNest.name,array('site1_traffic'))&&$arrNest.action!='create'}active{/if}"><i class="ti-location-pin"></i><span> Traffic Exchange </span></a>
					<ul class="list-unstyled">
						<li class="{if $arrNest.name=='site1_traffic'&&$arrNest.action=='campaign'}active{/if}"><a href="{url name='site1_traffic' action='campaign'}"> Create Campaign</a></li>
						<li class="{if $arrNest.name=='site1_traffic'&&$arrNest.action=='manager'}active{/if}"><a href="{url name='site1_traffic' action='manager'}"> Manage Campaigns</a></li>
						<li class="{if $arrNest.name=='site1_traffic'&&$arrNest.action=='promote'}active{/if}"><a href="{url name='site1_traffic' action='promote'}"> Promote Campaigns</a></li>
						<li class="{if $arrNest.name=='site1_traffic'&&$arrNest.action=='manage_promote'}active{/if}"><a href="{url name='site1_traffic' action='manage_promote'}"> Manage Promotions</a></li>
						<li class="{if $arrNest.name=='site1_traffic'&&$arrNest.action=='browse'}active{/if}"><a href="{url name='site1_traffic' action='browse'}"> Browse Campaigns</a></li>
					</ul>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['site1_snippets'=>['create']] ) || Core_Acs::haveRight( ['site1_hiam'=>['create']] ) || Core_Acs::haveRight( ['site1_hiam'=>['manage']] ) || Core_Acs::haveRight( ['site1_snippets'=>['manage']] ) || Core_Acs::haveRight( ['site1_accounts'=>['copyprophet']] ) || Core_Acs::haveRight( ['site1_affiliate'=>['create']] ) || Core_Acs::haveRight( ['site1_traffic'=>['create']] )}
				<li class="has_sub">
					<a href="#" class="waves-effect {if $arrNest.name=='site1_accounts'&&$arrNest.action=='copyprophet'}active{/if}{if in_array($arrNest.name,array('site1_hiam','site1_snippets','site1_affiliate'))}active{/if}{if $arrNest.name=='site1_traffic'&&$arrNest.action=='create'}active{/if}"><i class="ti-money"></i><span style="padding-left: 0px; display: inline-block; width: 159px;"> Advertisement & Monetization </span></a>
					<ul class="list-unstyled">
						{if Core_Acs::haveRight( ['site1_snippets'=>['create']] )}<li class="{if $arrNest.name=='site1_snippets'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_snippets' action='create'}">Create New Ads</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_hiam'=>['create']] )}<li class="{if $arrNest.name=='site1_hiam'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_hiam' action='create'}">Create High Impact Ads</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_hiam'=>['manage']] ) || Core_Acs::haveRight( ['site1_snippets'=>['manage']] )}<li><a class="popup-main" href="#side-bar-ads-manage">Manage Campaigns</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_accounts'=>['copyprophet']] )}<li class="{if $arrNest.name=='site1_accounts'&&$arrNest.action=='copyprophet'}active{/if}"><a href="{url name='site1_accounts' action='copyprophet'}">Copy Prophet</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_affiliate'=>['create']] )}<li class="{if $arrNest.name=='site1_affiliate'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_affiliate' action='create'}">Link Profit Booster</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_traffic'=>['create']] )}<li class="{if $arrNest.name=='site1_traffic'&&$arrNest.action=='create'}active{/if}"><a href="{url name='site1_traffic' action='create'}">Traffic Locator</a></li>{/if}
					</ul>
				</li>
				{/if}

				{if Core_Acs::haveRight( ['dashboard'=>['advancedtools']] ) && !Core_Acs::onlyHaveAccess(array('Default', 'Affiliate Funnels Starter' ) ) && !Core_Acs::onlyHaveAccess(array('Default', 'Affiliate Funnels Free' ) ) && !Core_Acs::onlyHaveAccess(array('Default', 'Affiliate Funnels Free', 'Affiliate Funnels Starter') ) || Core_Acs::haveAccess( array( 'Advanced Tools' ) )}
				<li>
					<a href="#" class="waves-effect {if $arrNest.name=='site1_blogfusion'&&$arrNest.action=='themes'}active{/if} {if $arrNest.name=='site1_accounts'&&$arrNest.action=='templates'}active{/if} {if in_array($arrNest.name,array('site1_organizer','site1_nicheresearch','keyword_generator','site1_market_trands'))}active{/if}"><i class="ti-gift"></i><span>Advanced Tools</span></a>
					<ul>
						{if Core_Acs::haveRight( ['article'=>['options']] )}<li><a href="#side-bar-content-manage" class="popup-main">Your Content Library</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_organizer'=>['manage']] )}<li class="{if $arrNest.name=='site1_organizer'&&$arrNest.action=='manage'}active{/if}"><a href="{url name='site1_organizer' action='manage'}">Organizer </a></li>{/if}
						{if Core_Acs::haveRight( ['site1_accounts'=>['templates']] )}<li class="{if $arrNest.name=='site1_accounts'&&$arrNest.action=='templates'}active{/if}"><a href="{url name='site1_accounts' action='templates'}">Manage Template</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_blogfusion'=>['themes']] )}<li class="{if $arrNest.name=='site1_blogfusion'&&$arrNest.action=='themes'}active{/if}"><a href="{url name='site1_blogfusion' action='themes'}">Manage WP Theme</a></li>{/if}
						{if Core_Acs::haveRight( ['site1_market_trands'=>['main']] )}
						<li class="{if $arrNest.name=='site1_nicheresearch'&&$arrNest.action=='main'}active{/if}"><a href="{url name='site1_nicheresearch' action='main'}">Niche Research</a></li>
						<li class="{if $arrNest.name=='keyword_generator'&&$arrNest.action=='combine_keywords'}active{/if}"><a href="{url name='keyword_generator' action='combine_keywords'}">Keyword Generation </a></li>
						<li class="{if $arrNest.name=='site1_market_trands'&&$arrNest.action=='main'}active{/if}"><a href="{url name='site1_market_trands' action='main'}">Market Trends</a></li>
						{/if}
					</ul>
				</li>
				{/if}
			</ul>
			<div class="clearfix"></div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>

	<!-- End #main-nav -->
	<div id="messages" style="display: none">
		<!-- Messages are shown when a link with these attributes are clicked: href="#messages" rel="modal"  -->
		<h3>3 Messages</h3>

		<p>
			<strong>17th May 2009</strong> by Admin<br/>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus magna. Cras in mi at felis aliquet congue.
			<small><a href="#" class="remove-link" title="Remove message">Remove</a></small>
		</p>
		<p>
			<strong>2nd May 2009</strong> by Jane Doe<br/>
			Ut a est eget ligula molestie gravida. Curabitur massa. Donec eleifend, libero at sagittis mollis, tellus
			est malesuada tellus, at luctus turpis elit sit amet quam. Vivamus pretium ornare est.
			<small><a href="#" class="remove-link" title="Remove message">Remove</a></small>
		</p>
		<p>
			<strong>25th April 2009</strong> by Admin<br/>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus magna. Cras in mi at felis aliquet congue.
			<small><a href="#" class="remove-link" title="Remove message">Remove</a></small>
		</p>
		<form action="" method="post">
			<h4>New Message</h4>
			<fieldset>
				<textarea class="textarea" name="textfield" cols="79" rows="5"></textarea>
			</fieldset>
			<fieldset>
				<select name="dropdown" class="small-input">
					<option value="option1">Send to...</option>
					<option value="option2">Everyone</option>
					<option value="option3">Admin</option>
					<option value="option4">Jane Doe</option>
				</select>
				<input class="button" type="submit" value="Send"/>
			</fieldset>
		</form>
	</div>
	<!-- End #messages -->


{* Wizards builders *}
<div style="display: none;">
	<div id="wizards" class="popup-block">
		<div class="card-box">
			{if Core_Acs::haveRight( ['site1_wizard'=>['create']] )}
				<p>If you would like to let the wizard create an Amazon store for you, follow this link:<br/><a class="wizard_icon"  href="{url name='site1_wizard' action='create'}" title="Wizard">Amazon Wizard</a></p>
			{/if}
			{if Core_Acs::haveRight(['site1_wizard'=>['zonterest']])}
				<p>If you would like to let the wizard create an AzonFunnels Amazon store for you, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='zonterest'}">AzonFunnels Custom Domain</a></p>
			{/if}
			{if Core_Acs::haveRight(['site1_wizard'=>['zonterestamazideas']])}
				<p>If you would like to let the wizard create an AzonFunnels Amazon store for you, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='zonterestamazideas'}">AzonFunnels Amazideas</a></p>
			{/if}
			{if Core_Acs::haveRight(['site1_wizard'=>['zonterestpro']])}
				<p>If you would like to let the wizard create an AzonFunnels Amazon store for you, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='zonterestpro'}">AzonFunnels Pro</a></p>
			{/if}
			{if Core_Acs::haveRight(['site1_wizard'=>['zonterestLight']])}
				<p>If you would like to let the wizard create an AzonFunnels Amazon store for you, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='zonterestLight'}">AzonFunnels&nbsp;Light&nbsp;Wizard</a></p>
			{/if}
			{if Core_Acs::haveRight( ['site1_wizard'=>['contentpro']] )}
				<p>If you want the wizard to create a Niche Content website monetized with Adsense, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='contentpro'}">Exclusive Niche Content Wizard</a></p>
			{/if}
			{if Core_Acs::haveRight( ['site1_wizard'=>['clickbankpro']] )}
				<p>If you want the wizard to create a Niche Content website monetized with Clickbank content, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='clickbankpro'}">Clickbank&nbsp;PRO&nbsp;Wizard</a></p>
			{/if}
			{if Core_Acs::haveAccess( array('email test group') )}
				<p>If you want the wizard to create a IAM Wizard website monetized with Clickbank, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='iam'}">IAM Wizard</a></p>
			{/if}

			{if Core_Acs::haveRight( ['site1_wizard'=>['content']] )}
				<p>If you want the wizard to create a Niche Content website monetized with Adsense, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='content'}">Content&nbsp;Website&nbsp;Wizard</a></p>
			{/if}
			{if Core_Acs::haveRight( ['site1_wizard'=>['video']] )}
				<p>If you want the wizard to create a Niche Video website monetized with Adsense, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='video'}">Video&nbsp;Website&nbsp;Wizard</a></p>
			{/if}
			{if Core_Acs::haveRight( ['site1_wizard'=>['clickbank']] )}
				<p>If you want the wizard to create a Niche Content website monetized with Clickbank content, follow this link:<br/><a class="wizard_icon" href="{url name='site1_wizard' action='clickbank'}">Clickbank&nbsp;Wizard</a></p>
			{/if}

			<div class="clear"></div>
		</div>
	</div>
</div>
{******************}

{* *Create sites icons** }
<div style="display: none;">
	<div id="side-bar-create-sites" class="popup-block">
		<ul class="shortcut-buttons-set">
			{if Core_Acs::haveRight(['site1_nvsb'=>['create']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_nvsb' action='create'}">
					<span><img src="/skin/i/frontends/design/icons_on/video_builder.png" alt="Niche Video Site Builder" /><br/>Niche Video Site Builder</span>
				</a>
			</li>
			{/if}
			{if Core_Acs::haveRight(['site1_ncsb'=>['create']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_ncsb' action='create'}">
					<span><img src="/skin/i/frontends/design/icons_on/content_builder.png" alt="Niche Content Site Builder" /><br/>Niche Content Site Builder</span>
				</a>
			</li>
			{/if}
			{if Core_Acs::haveRight(['site1_blogfusion'=>['create']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_blogfusion' action='create'}">
					<span><img src="/skin/i/frontends/design/icons_on/blog_fusion.png" alt="Blog Fusion" /><br/>Blog Fusion</span>
				</a>
			</li>
			{/if}
		</ul>
		<div class="clear"></div>
	</div>
</div>
{ **END Create sites icons** }
{ **Manage sites icons** }
<div style="display: none;">
	<div id="side-bar-manage-sites" class="popup-block">
		<ul class="shortcut-buttons-set">
			{if Core_Acs::haveRight(['site1_nvsb'=>['manage']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_nvsb' action='manage'}">
					<span><img src="/skin/i/frontends/design/icons_on/video_builder.png" alt="Niche Video Site Builder" /><br/>Niche Video Site Builder</span>
				</a>
			</li>
			{/if}
			{if Core_Acs::haveRight(['site1_ncsb'=>['manage']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_ncsb' action='manage'}">
					<span><img src="/skin/i/frontends/design/icons_on/content_builder.png" alt="{if Core_Acs::haveAccess( array('Zonterest PRO') )}Manage AzonFunnels Websites{else}Niche Content Site Builder{/if}" /><br/>{if Core_Acs::haveAccess( array('Zonterest PRO') )}Manage AzonFunnels Websites{else}Niche Content Site Builder{/if}</span>
				</a>
			</li>
			{/if}
			{if Core_Acs::haveRight(['site1_zonterest'=>['manage']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_zonterest' action='manage'}">
					<span><img src="/skin/i/frontends/design/icons_on/content_builder.png" alt="Manage AzonFunnels Websites." /><br/>Manage AzonFunnels Websites</span>
				</a>
			</li>
			{/if}
			{if Core_Acs::haveRight(['site1_blogfusion'=>['manage']]) }
			<li>
				<a class="shortcut-button" href="{url name='site1_blogfusion' action='manage'}">
					<span><img src="/skin/i/frontends/design/icons_on/blog_fusion.png" alt="Blog Fusion" /><br/>Blog Fusion</span>
				</a>
			</li>
			{/if}
		</ul>
		<div class="clear"></div>
	</div>
</div>
{ **END Manage sites icons* *}

{**Manage content icons**}
<div style="display: none;">
	<div id="side-bar-content-manage" class="popup-block">
		<ul class="shortcut-buttons-set">
			{if Core_Acs::haveRight( ['site1_articles'=>['articles']] )}
			   <li><a   class="shortcut-button" href="{url name='site1_articles' action='articles'}">
					<span><img src="/skin/i/frontends/design/icons_on/article_module.png" alt="Manage Your Articles" /><br/>Manage Your Articles</span></a>
			   </li>
			{/if}
			{if Core_Acs::haveRight( ['site1_video_manager'=>['video']] )}
			   <li><a class="shortcut-button" href="{url name='site1_video_manager' action='video'}">
				   <span><img src="/skin/i/frontends/design/icons_on/site1_video_manager.png" alt="Manage Your Videos" /><br/>Manage Your Videos</span></a>
			   </li>
			{/if}
		</ul>
		<div class="clear"></div>
	</div>
</div>
{**END Manage content icons**}

{**Manage content icons**}
<div style="display: none;">
	<div id="side-bar-ads-manage" class="popup-block">
		<ul class="shortcut-buttons-set">
			{if Core_Acs::haveRight( ['site1_snippets'=>['manage']] )}
		   <li><a   class="shortcut-button" href="{url name='site1_snippets' action='manage'}">
				<span><img src="/skin/i/frontends/design/icons_on/campaign_optimizer.png" alt="Manage Campaign Optimizer Ads" /><br/>Manage Campaign Optimizer Ads</span></a>
		   </li>
		   {/if}
			{if Core_Acs::haveRight( ['site1_hiam'=>['manage']] )}
		   <li><a class="shortcut-button" href="{url name='site1_hiam' action='manage'}">
			   <span><img src="/skin/i/frontends/design/icons_on/dams.png" alt="Manage High Impact Ads" /><br/>Manage High Impact Ads</span></a>
		   </li>
			 {/if}
		</ul>
		<div class="clear"></div>
	</div>
</div>
{**END Manage content icons**}


{literal}
<script type="text/javascript">
window.addEvent('domready',function(){
var sidebarpopup=new CeraBox( $$('.popup-main'), {
			group: false,
			displayTitle: false
		});
});

window.addEvent('domready',function(){
	var wizard_multibox;
	var mainpopup=new CeraBox( $$('.popup-main-wizards'), {
		group: false,
		displayTitle: false,
		width:'950px',
		height:'500px',
		events:{
			onOpen: function(a,b){
				wizard_multibox=new CeraBox( $$('.wizard_icon'), {
					group: false,
					width:'950px',
					height:'500px',
					displayTitle: true,
					titleFormat: '{title}'
				});
			}
		}
	});
});
</script>
{/literal}