{if Core_Users::$info['flg_approve']==0}
{module name='site1_accounts' action='terms' header=1}
{else}
{module name='site1_accounts' action='categoryWarning'}
{module name='site1_accounts' action='balanceWarning'}

	{if Core_Users::$info['flg_maintenance']&&!Core_Acs::haveAccess( array('Maintenance') )}

	{/if}

{if Core_Acs::haveAccess( 'Blog Fusion' )}
<center>
<table width="100%" border="0">
<tr>
	<td width="22%"></td>
	<td width="280" valign="top">
		<div style="border:1px solid #999; padding:10px; margin:6px;">
		<b>Check these How-To User Guides:</b><br/><br/>
		<a target="_blank" href="{Zend_Registry::get( 'config' )->domain->url}/usersdata/cnm_help/blogfusion.pdf">Step 1: Create your blog</a><br/><br/>
		<a target="_blank" href="{Zend_Registry::get( 'config' )->domain->url}/usersdata/cnm_help/contentpublishing.pdf">Step 2: Post content on your blogs</a><br/><br/>
		<a target="_blank" href="{Zend_Registry::get( 'config' )->domain->url}/usersdata/cnm_help/contentsyndication.pdf">Step 3: Generate traffic</a><br/><br/>
		Tools:<br/><br/>
		<a target="_blank" href="{Zend_Registry::get( 'config' )->domain->url}/usersdata/cnm_help/sitemanagement.pdf">Manage your FTP details</a><br/><br/>
		<a target="_blank" href="{Zend_Registry::get( 'config' )->domain->url}/usersdata/cnm_help/contentwizard.pdf">Article Manager</a><br/><br/>
		<a target="_blank" href="{Zend_Registry::get( 'config' )->domain->url}/usersdata/cnm_help/videomanager.pdf">Video Manager</a><br/><br/>
		</div>
	</td>
	<td width="30"></td>
	<td>
<table>
	<tr>
		<td><b>Step 1:</b> <a class="a1" href="{url name='site1_blogfusion' action='create'}">Create your blog</a></td>
	</tr>
	<tr>
		<td>
			<a class="a1" href="{url name='site1_blogfusion' action='create'}">
				<img width="50" height="50" src="/skin/i/frontends/design/icons_on/blog_fusion.png" alt="Blog Fusion"/>
			</a>
		</td>
	</tr>	
	<tr>
		<td><b>Step 2:</b> <a class="a1" href="{url name='site1_publisher' action='blog'}">Post content on your blogs</a></td>
	</tr>
	<tr>
		<td>
			<a class="a1" href="{url name='site1_publisher' action='blog'}">
				<img src="/skin/i/frontends/design/icons_on/manage_category.png" alt="Content Publishing" />
			</a>
		</td>
	</tr>	
	<tr>
		<td><b>Step 3:</b> <a class="a1" href="{url name='site1_syndication' action='manage'}">Generate traffic</a></td>
	</tr>
	<tr>
		<td>
			<a class="a1" href="{url name='site1_syndication' action='manage'}">
				<img src="/skin/i/frontends/design/icons_on/upload_articles.png" alt="Forums" />
			</a>
		</td>
	</tr>	
	<tr>
		<td><b>Tools:</b></td>
	</tr>
	<tr>
		<td>
		<a class="a1" href="{url name='ftp_tools' action='manage'}">Manage your FTP details</a><br/>
		<a class="a1" href="{url name='site1_articles' action='articles'}">Article Manager</a><br/>
		<a class="a1" href="{url name='site1_video_manager' action='video'}">Video Manager</a><br/>
		<a class="a1" href="{url name='site1_quick_indexer' action='main'}">Quick Indexer</a><br/>
		<a class="a1" href="{url name='site1_blogfusion' action='manage'}">Manage Your Blogs</a>
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</center>
{/if}
{if Core_Acs::haveAccess( 'Zonterest' )}
<div align="center">
	<a href="https://creativenichemanager.zendesk.com/forums/21400862-zonterest-amazon-affiliate-system" target="_blank"><img src="/skin/i/frontends/design/icons_on/help.png" alt="Click Here to Access AzonFunnels Knowledge Base"><br/>Click Here to Access <br/>Zonterest Knowledge Base</a>
</div>
{/if}
{if Core_Acs::haveAccess('CNM1.0')}<div align="center"><p>Upgrade and get unlimited access to all modules of the Creative Niche Manager (<a href="{$unlimitedPack.click2sell_url}" target="_blank">click here</a>)</p></div>{/if}
{if !Core_Acs::haveAccess( 'Blog Fusion' )||(Core_Acs::haveAccess( 'Blog Fusion' )&&count( Core_Users::$info['groups'] )>1)}
<div style="height:40px;margin:0 auto;width:940px;">&nbsp;
<center><a href="#save_menu" class="save_button">Save settings of menu structure</a></center>
</div>

<div id="wrap">
{if Core_Acs::haveAccess( array( 'Advertiser' ) )}
<center>
	<table>
		<tr>
			<td style="text-align:center;">
				<a class="a1" href="{url name='site1_hiam' action='manage'}">
					<img src="/skin/i/frontends/design/icons_on/dams.png" alt="High Impact Ad Manager" /><br />High Impact Ad Manager
				</a>
			</td>
			<td style="text-align:center;">
				<a class="a1" href="{url name='site1_snippets' action='manage'}">
					<img src="/skin/i/frontends/design/icons_on/campaign_optimizer.png" alt="Campaign Optimizer" /><br />Campaign Optimizer
				</a>
			</td>
		</tr>
	</table>
</center>
{/if}

{foreach from=array('left','right') item=wrap}
{if $wrap=='left'}
<div id="wrap_{$wrap}">
{else}
<div id="wrap_{$wrap}">
{/if}
{foreach from=$arrUser['arrSettings']['menu_settings'][implode('', array($wrap,'_box'))] item=boxId}
	{if $boxId==1}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="1">
	{if Core_Acs::haveRight( ['dashboard'=>['domainregistration&hosting']] )}
		<h2>Domain Registration & Hosting</h2>
		<div class="inside">
			<ul>
				{if Core_Acs::haveRight( ['hosting'=>['incon']] )}
				<li style="width: 70%;">
					<a class="a1" style="padding:8px;" href="{url name='site1_hosting' action='mydomains'}">
						<img src="/skin/i/frontends/design/icons_on/ftp.png" alt="My Domains & Hosting: click here to register new domains and host your existing domains with us" /><br />My Domains & Hosting: click here to register new domains and host your existing domains with us
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['domain_parking'=>['icon']] )}
				<li>
					<a class="a1"  href="{url name='site1_domain_parking' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/domain_parking.png" alt="Domain Parking" /><br />Domain&nbsp;Parking
					</a>
				</li>
				{/if}
			</ul>
		</div>
	{/if}
	</div>
	{/if}{if $boxId==2}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="2">
	{*{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}*}
	{if Core_Acs::haveRight( ['dashboard'=>['templatemanager']] )}
		<h2>Template Manager</h2>
		<div class="inside">
			<ul>
				<li>
					<a class="a1" href="{url name='site1_accounts' action='templates'}">
						<img src="/skin/i/frontends/design/icons_on/manage_template.png" alt="Manage Template" /><br />Manage Template
					</a>
				</li>
				<li>
					<a class="a1" href="{url name='site1_blogfusion' action='themes'}">
						<img src="/skin/i/frontends/design/icons_on/manage_wp.png" alt="Manage WP Theme" /><br />Manage WP Theme
					</a>
				</li>
			</ul>
		</div>
	{/if}
	</div>
	{/if}{if $boxId==3}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="3">
	{*{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}*}
	{if Core_Acs::haveRight( ['dashboard'=>['marketresearch']] )}
		<h2>Market Research and Competitive intelligence</h2>
		<div class="inside">
			<ul>
				<li>
					<a class="a1" href="{url name='site1_nicheresearch' action='main'}">
						<img src="/skin/i/frontends/design/icons_on/niche_research.png" alt="Niche Research" /><br />Niche <br /> Research
					</a>
				</li>
				<li>
					<a class="a1" href="{Core_Module_Router::$offset}keywordgenerator/">
						<img src="/skin/i/frontends/design/icons_on/keyword_generation.png" alt="Keyword Generation" /><br />Keyword <br /> Generation
					</a>
				</li>
				<li>
					<a class="a1" href="{Core_Module_Router::$offset}market-trends/">
						<img src="/skin/i/frontends/design/icons_on/site1_market_trands.png" alt="Market Trends" /><br />Market <br /> Trends
					</a>
				</li>
			</ul>
		</div>
	{/if}
	</div>
	{/if}{if $boxId==5}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="5">
	{*{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}*}
	{if Core_Acs::haveRight( ['dashboard'=>['projectmanager']] )}
		<h2>Project Manager</h2>
		<div class="inside">
			<ul>
				<li style="width:120px;">
					<a class="a1" href="{url name='site1_publisher' action='project_create'}">
						<img src="/skin/i/frontends/design/icons_on/create_keyword.png" alt="Create Content Project" /><br />Create <br/>Content Project
					</a>
				</li>
				<li>
					<a class="a1" href="{url name='site1_publisher' action='projects_manage'}">
						<img src="/skin/i/frontends/design/icons_on/article_project.png" alt="Manage Content Projects" /><br />Manage <br/>Content <br/>Projects
					</a>
				</li>
				<li>
					<a class="a1" href="{url name='site1_organizer' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/organizer.png" alt="Organizer" /><br />Organizer
					</a>
				</li>
			</ul>
		</div>
	{/if}
	</div>
	{/if}{if $boxId==6}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="6">
	{if Core_Acs::haveRight( ['dashboard'=>['sitebuilder']] )}
		<h2>Site Builder</h2>
		<div class="inside">
			<ul>
				{if Core_Acs::haveRight(['nvsb'=>['icon']]) }
				<li>
					<a class="a1" href="{url name='site1_nvsb' action='create'}">
						<img src="/skin/i/frontends/design/icons_on/video_builder.png" alt="Niche Video Site Builder" /><br />Niche Video Site Builder
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight(['ncsb'=>['icon']]) }
				<li>
					<a class="a1" href="{url name='site1_ncsb' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/content_builder.png" alt="{if Core_Acs::haveAccess( array('Zonterest PRO') )}Manage AzonFunnels Websites{else}Niche Content Site Builder{/if}" /><br />{if Core_Acs::haveAccess( array('Zonterest PRO') )}Manage AzonFunnels Websites{else}Niche Content Site Builder{/if}
					</a>
				</li>
				{/if}
				{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}
				<li>
					<a class="a1" href="{url name='site1_blogfusion' action='create'}">
						<img width="50" height="50" src="/skin/i/frontends/design/icons_on/blog_fusion.png" alt="Blog Fusion"/><br />Blog Fusion
					</a>
				
				</li>
				<li>
					<a class="a1" href="{url name='site1_blogfusion' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/manage_sites.png" alt="Manage Existing Sites" /><br />Manage existing site
					</a>
				</li>
				{if !Core_Acs::haveRight(['wizard'=>['icon_zonterestpro_daschboard']])}
				<li>
					<a class="a1" href="{url name='site1_accounts' action='history'}">
						<img src="/skin/i/frontends/design/icons_on/history.png" alt="History" /><br />History
					</a>
				</li>
				{/if}
				{/if}
				{if Core_Acs::haveRight(['wizard'=>['icon_zonterest_daschboard']])}
				<li>
					<a class="a1 wizard_icon" href="{url name='site1_wizard' action='zonterest'}">
						<img src="/skin/i/frontends/design/icons_on/zonterest.png" alt="Zonterest Wizard" /><br />Zonterest Wizard
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight(['wizard'=>['icon_zonterestpro_daschboard']])}
				<li>
					<a class="a1 wizard_icon" href="{url name='site1_wizard' action='zonterestpro'}">
						<img src="/skin/i/frontends/design/icons_on/zonterest.png" alt="Zonterest PRO Wizard" /><br />Zonterest PRO Wizard
					</a>
				</li>
				{/if}
			</ul>
		</div>
	{/if}
	</div>
	{/if}{if $boxId==7}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="7">
	{*{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}*}
	{if Core_Acs::haveRight( ['dashboard'=>['contentwizard']] )}
		<h2>Content Wizard</h2>
		<div class="inside">
			<ul>
				{if Core_Acs::haveRight( ['article'=>['options']] )}
				<li>
					<a class="a1" href="{url name='site1_articles' action='articles'}">
						<img src="/skin/i/frontends/design/icons_on/manage_article.png" alt="Manage Article" /><br />Article Manager
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['publisher'=>['icon']] )}
				<li>
					<a class="a1" href="{url name='site1_publisher' action='projects_manage'}">
						<img src="/skin/i/frontends/design/icons_on/manage_category.png" alt="Content Publishing" /><br />Content <br /> Publishing
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['syndication'=>['icon']] )}
				<li>
					<a class="a1" href="{url name='site1_syndication' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/upload_articles.png" alt="Forums" /><br />Content <br /> Syndication
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['article'=>['options']] )}
				<li>
					<a class="a1" href="{url name='site1_articles' action='rewriter'}">
						<img src="/skin/i/frontends/design/icons_on/article_rewriter.png" alt="Article Rewriter" width="50" height="50"/><br/>Article Rewriter
					</a>
				</li>
				{/if}
				{if Core_Acs::haveRight( ['video_manager'=>['icon']] )}
				<li>
					<a class="a1" href="{url name='site1_video_manager' action='video'}">
						<img src="/skin/i/frontends/design/icons_on/site1_video_manager.png" alt="Video Manager" /><br />Video Manager
					</a>
				</li>
				{/if}
			</ul>
		</div>	
	{/if}
	</div>
	{/if}{if $boxId==8}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="8">
	{*{if Core_Acs::haveAccess( array( 'email test group','CNM1.0', 'NVSB Hosted Pro' ) )}*}
	{if Core_Acs::haveRight( ['dashboard'=>['advertising']] )}
		<h2>Advertising, Tracking and Monitoring</h2>
		<div class="inside">
			<ul>
				<li>
					<a class="a1" href="{url name='site1_hiam' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/dams.png" alt="High Impact Ad Manager" /><br />High Impact Ad Manager
					</a>
				</li>
				{if !Core_Acs::haveRight(['wizard'=>['icon_zonterestpro_daschboard']])}
				<li>
					<a class="a1" href="{url name='site1_snippets' action='manage'}">
						<img src="/skin/i/frontends/design/icons_on/campaign_optimizer.png" alt="Campaign Optimizer" /><br />Campaign Optimizer
					</a>
				</li>
				{/if}
				{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}
				<li>
					<a class="a1" href="{url name='site1_accounts' action='copyprophet'}">
						<img src="/skin/i/frontends/design/icons_on/copyprophet.png" alt="Copy Prophet" /><br />Copy Prophet
					</a>
				</li>
				<li>
					<a class="a1" href="{Core_Module_Router::$offset}affiliate-module/create/">
						<img src="/skin/i/frontends/design/icons_on/site1_affiliate.png" alt="Affiliate Profit Booster" /><br />Affiliate Profit Booster
					</a>
				</li>
				{/if}
			</ul>
		</div>
	{/if}
	</div>
	{/if}{if $boxId==9}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="9">
	{*{if Core_Acs::haveAccess( array( 'email test group','CNM1.0', 'NVSB Hosted Pro' ) )}*}
	{if Core_Acs::haveRight( ['dashboard'=>['trafficgeneration']] )}
		<h2>Traffic Generation</h2>
		<div class="inside">
			<ul>
				{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}
				<li>
					<a class="a1" href="{url name='site1_traffic' action='create'}">
						<img src="/skin/i/frontends/design/icons_on/traffic_locator.png" alt="Traffic Locator" /><br />Traffic <br />Locator
					</a>
				</li>
				{*<li>
					<a class="a1" href="{url name='site1_sbookmarking' action='gadget'}">
						<img src="/skin/i/frontends/design/icons_on/bookmarking.png" alt="Social Bookmarking" /><br />Social Bookmarking
					</a>
				</li>
				<li>
					<a class="a1" href="{Core_Module_Router::$offset}as/index.php">
						<img src="/skin/i/frontends/design/icons_on/article_module.png" alt="Article Submission Module" /><br /><!--/a> <a class="a1" href="{url name='site1_submission' action='manage'}"-->Article <br /> Submission
					</a>
				</li>*}
				{/if}
				{*<li>
					<a class="a1" href="{url name='site1_quick_indexer' action='main'}">
						<img src="/skin/i/frontends/design/icons_on/statistics.png" alt="Quick Indexer" /><br />Quick <br />Indexer
					</a>
				</li>*}
				<li>
					<a class="a1" href="{url name='site1_promotions' action='custom_promotions'}">
						<img src="/skin/i/frontends/design/icons_on/social-media.png" alt="Social Media Campaigns" /><br />Social Media <br />Campaigns
					</a>
				</li>
			</ul>
		</div>
	{/if}
	</div>
	{/if}{*if $boxId==10}
	<div class="{$wrap} box"><input type="hidden" name="box_position[]" value="10">
	{if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}
		<h2>Web tools</h2>
		<div class="inside">
			<ul>
				<li style="width:120px;">
					<a class="a1 mb" href="{url name='cpanel_tools' action='database'}" title="Cpanel Database Creator">
						<img src="/skin/i/frontends/design/icons_on/cpanel_db.png" alt="Cpanel Database Creator" /><br />Cpanel Database Creator
					</a>
				</li>
				<li style="width:117px;">
					<a class="a1 mb" href="{url name='cpanel_tools' action='subdomain'}" title="Cpanel Mass Subdomain Creator">
						<img src="/skin/i/frontends/design/icons_on/cpanel_subdomain.png" alt="Cpanel Mass Subdomain Creator" /><br /> Cpanel Mass Subdomain Creator
					</a>
				</li>
				<li style="width:100px;">
					<a class="a1 mb" href="{url name='cpanel_tools' action='addondomain'}" title="Cpanel Addon Domains Creator">
						<img src="/skin/i/frontends/design/icons_on/cpanel_addondomains.png" alt="Cpanel Addon Domains Creator" /><br />Cpanel Addon Domains Creator
					</a>
				</li>
				<li style="width:110px;">
					<a class="a1" href="{Core_Module_Router::$offset}edit-file/" >
						<img src="/skin/i/frontends/design/icons_on/site1_file_editor.png" alt="Remote File Editor" /><br />Remote File Editor
					</a>
				</li>
			</ul>
		</div>
	{/if}
	</div>
	{/if*}
{/foreach}
</div>
{/foreach}
</div>
<br>
<div style="height:20px;margin:0 auto;width: 940px;">&nbsp;
<center><a href="#save_menu" class="save_button">Save settings of menu structure</a></center>
</div>



{*if Core_Acs::haveAccess( array( 'email test group','CNM1.0' ) )}
<link rel="stylesheet" href="/skin/_js/cerabox/style/cerabox.css" media="screen" />
<script type="text/javascript" src="/skin/_js/cerabox/cerabox.js"></script>
{/if*}
<script type="text/javascript">
{literal}
window.addEvent('domready', function() {
	var return_array;
	function moveElement(event){
		event.stop();
		var item=this.getParent('.box');
		var selected=item.clone().addClass('selected').setStyles(item.getCoordinates()).setStyles({
			opacity: 0.5,
			position: 'absolute'
		}).inject(document.body);
		var drag=new Drag.Move(selected,{
			droppables: $$('.box:not(.selected)'),
			onDrop: function(dragging, box, event){
				if( box!=null && dragging.children[0].value!=box.children[0].value ){
					$$('.save_button').show();
				}
				dragging.destroy();
				$$('.box').setStyle( 'opacity', '1' );
				if (box!=null){
					var parent=item.get('html');
					item.set('html', box.get('html')).getChildren('h2').addEvent('mousedown', moveElement);
					box.set('html', parent).getChildren('h2').addEvent('mousedown', moveElement);
					return_array={
						right_box:new Array(),
						left_box:new Array()
					};
					$('wrap_right').getElements('input[name="box_position[]"]')
						.each(function( element ){
							return_array.right_box.include( element.value );
						});
					$('wrap_left').getElements('input[name="box_position[]"]')
						.each(function( element ){
							return_array.left_box.include( element.value );
						});
				}
			},
			onEnter: function(dragging, box){
				box.setStyle( 'opacity', '0.4' );
			},
			onLeave: function(dragging, box){
				box.setStyle( 'opacity', '1' );
			},
			onCancel: function(dragging){
				dragging.destroy();
				$$('.inside').setStyle( 'background-color', '#fff' );
			}
		});
		drag.start(event);
	}
	$$('.box h2').addEvent('mousedown', moveElement);
	$$('.save_button').addEvent('click', function(e){
		e.stop();
		new Request({
			url:'{/literal}{url name="site1_accounts" action="save_menu_structure"}{literal}',
			onComplete: function(){
				$$('.save_button').hide();
			}
		}).post( Object.toQueryString(return_array) )
	});
	
});
{/literal}
</script>
{/if}
{/if}