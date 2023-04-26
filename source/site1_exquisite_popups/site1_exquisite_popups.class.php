<?php
class site1_exquisite_popups extends Core_Module {
	
	public function set_cfg() {
		$this->inst_script=array(
			'module' =>array( 'title'=>'CNM Exquisite Popups', ),
			'actions'=>array(
				array( 'action'=>'settings', 'title'=>'Exquisite Popups Settings', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Create Popup', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Popups', 'flg_tree'=>1 ),
				array( 'action'=>'subscribers', 'title'=>'Subscribers', 'flg_tree'=>1 ),
				array( 'action'=>'ajax', 'title'=>'Ajax actions', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				
				array( 'action'=>'getcode', 'title'=>'Get code', 'flg_tree'=>1, 'flg_tpl'=>1 ),
			),
		);
	}

	public function before_run_parent(){
		if (isset($_SESSION['error'])) {
			$this->out['error_message'] = $_SESSION['error'];
			unset($_SESSION['error']);
		} else $this->out['error_message'] = '';
		if (isset($_SESSION['ok'])) {
			$this->out['ok_message'] = $_SESSION['ok'];
			unset($_SESSION['ok']);
		} else $this->out['ok_message'] = '';
	}
	
	public function settings(){
		$_object=new Project_Exquisite();
		$_options=new Project_Exquisite_Options();
		$_options->onlyOwner()->getList( $this->out['options'] );
		$this->out['options']=array_filter( $this->out['options'] )+array_filter( Project_Exquisite_Options::$defaultOptions );
		$_popup=new Project_Exquisite_Popups();
		$_popup->onlyOwner()->onlyActive()->getList( $this->out['popups'] );// ORDER BY created ASC
		$this->out['account']=null;
		
		
		
		if ($this->out['options']['aweber_access_secret']) {
			try{
				require_once 'library/AWeberAPI/aweber.php';
				$aweber=new AWeberAPI($this->out['options']['aweber_consumer_key'], $this->out['options']['aweber_consumer_secret']);
				$this->out['account']=$aweber->getAccount($this->out['options']['aweber_access_key'], $this->out['options']['aweber_access_secret']);
			}catch (AWeberAPIException $exc){
				$this->out['account']=null;
			} catch (AWeberOAuthDataMissing $exc) {
				$this->out['account']=null;
			} catch (AWeberException $e) {
				echo "test";exit;
				$this->out['account']=null;
			}
		}
	}

	public function create(){
		$_options=new Project_Exquisite_Options();
		$_options->onlyOwner()->getList( $this->out['options'] );
		$this->out['options']=array_filter( $this->out['options'] )+array_filter( Project_Exquisite_Options::$defaultOptions );
		$_object=new Project_Exquisite();
		if (isset($_GET["id"]) && !empty($_GET["id"])) {
			$this->out['id'] = intval($_GET["id"]);
			$_popup=new Project_Exquisite_Popups();
			$_popup->withIds( $this->out['id'] )->get( $this->out['popup_details'] );
		}
		if (!empty($this->out['popup_details'])) {
			$this->out['id'] = $this->out['popup_details']['id'];
			$this->out['user_id'] = $this->out['popup_details']['user_id'];
			$this->out['popup_options'] = unserialize($this->out['popup_details']['options']);
			$this->out['popup_options'] = array_merge($this->out['options'], $this->out['popup_options']);
		} else {
			$this->out['str_id'] = $_object->random_string(16);
			$_popup=new Project_Exquisite_Popups();
			$_popup->setEntered( array(
				'str_id'=>$this->out['str_id'],
				'title'=>'',
				'width'=>640,
				'height'=>400,
				'options'=>''
			) )->set();
			$_popup->getEntered( $_arrPopup );
			$this->out['id'] = $_arrPopup['id'];
			$this->out['popup_options'] = Project_Exquisite_Popups::$defaultOptions;
		}
		$_layers=new Project_Exquisite_Layers();
		$_layers->withPopupId( $this->out['id'] )->getList( $this->out['layers'] ); // ORDER BY created ASC
		if( sizeof( $this->out['layers'] )>0 ){
			foreach ($this->out['layers'] as &$layer) {
				$layer['options'] = unserialize( $layer['details'] );
				if( empty( $layer['options'] ) ){
					$layer['options'] = unserialize( preg_replace_callback('!s:(\d+):"(.*?)";!s', "'s:'.strlen('$2').':\"$2\";'", $layer['details'] ) );
				}
				$layer['options'] = array_merge(Project_Exquisite_Layers::$defaultOptions, $layer['options']);
				$layer['options'] = $_object->filter_lp($layer['options'], Project_Exquisite::urlBase());
				if (strlen($layer['options']['content']) == 0)
					$layer['show_content'] = 'No content...';
				elseif (strlen($layer['options']['content']) > 192)
					$layer['show_content'] = htmlspecialchars( substr($layer['options']['content'], 0, 180).'...', ENT_QUOTES );
				else 
					$layer['show_content'] = htmlspecialchars( $layer['options']['content'], ENT_QUOTES );
				$layer['show_html'] = '';
				foreach ($layer['options'] as $key => $value) {
					$layer['show_html'] .= '<input type="hidden" id="ulp_layer_'.$layer['id'].'_'.$key.'" name="ulp_layer_'.$layer['id'].'_'.$key.'" value="'.htmlspecialchars($value, ENT_QUOTES).'">';
				}
			}
		}
	}

	public function manage(){
		$_popup=new Project_Exquisite_Popups();
		$_popup
			->onlyActive()
			->withDefault()
			->withPaging( array( 'url'=>$_GET ) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['rows'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		$_activePopups=0;
		foreach( $this->out['rows'] as &$_row ) {
			if( $_row['user_id'] != 0 ){
				$_activePopups++;
			}
			Project_Exquisite::getOnActionCampaign( $_row['str_id'], $_row['source_script'], $_row['source_action'] );
			$_layers=new Project_Exquisite_Layers();
			$_layers->withPopupId( $_row['id'] )->getList( $_row['layers'] ); // ORDER BY created ASC
		}
		if( $_activePopups==0 ){
			$this->out['message']='<strong>Important:</strong> All existing templates cannot be edited. You need to duplicate the template you wish to use by clicking the <img src="/skin/i/frontends/design/newUI/exquisite_popups/copy.png" alt=""> icon. It will then be available for editing. Alternatively, you can also create a new POPUP from scratch by clicking the <a class="btn btn-primary ulp-button" href="'.Core_Module_Router::getCurrentUrl( array('name'=>'site1_exquisite_popups','action'=>'create') ).'">Create Popup</a> link.';
		}else{
			$this->out['message']='<strong>Important:</strong> Some existing templates cannot be edited. You need to duplicate the template you wish to use by clicking the <img src="/skin/i/frontends/design/newUI/exquisite_popups/copy.png" alt=""> icon. It will then be available for editing. Alternatively, you can also create a new POPUP from scratch by clicking the <a class="btn btn-primary ulp-button" href="'.Core_Module_Router::getCurrentUrl( array('name'=>'site1_exquisite_popups','action'=>'create') ).'">Create Popup</a> link.';
		}
	}

	public function subscribers(){
		$_subscribers=new Project_Exquisite_Subscribers();
		$_subscribers
			->withPopupTitle()
			->withPaging( array( 'url'=>$_GET ) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['rows'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		
	}
	
	public function ajax(){
		$_object=new Project_Exquisite();
		$jsonp_callback = $_REQUEST['callback'];
		if (isset($_REQUEST['action'])) {
			switch ($_REQUEST['action']) {
				case 'save-settings':
					foreach (Project_Exquisite_Options::$defaultOptions as $key => $value) {
						if (isset($_POST['ulp_'.$key])) {
							$options[$key]=trim(stripslashes($_POST['ulp_'.$key]));
						}
					}
					if (isset($_POST['ulp_email_validation'])) $options['email_validation'] = 'on';
					else $options['email_validation'] = 'off';
					if (isset($_POST['ulp_ga_tracking'])) $options['ga_tracking'] = 'on';
					else $options['ga_tracking'] = 'off';
					if (isset($_POST['ulp_onexit_limits'])) $options['onexit_limits'] = 'on';
					else $options['onexit_limits'] = 'off';
					if (isset($_POST['ulp_fa_enable'])) $options['fa_enable'] = 'on';
					else $options['fa_enable'] = 'off';
					$errors = array();
					if (strlen($options['onload_delay']) > 0 && $options['onload_delay'] != preg_replace('/[^0-9]/', '', $options['onload_delay'])) $errors[] = 'Invalid OnLoad delay value.';
					if ($options['mailchimp_enable'] == 'on') {
						if (empty($options['mailchimp_api_key']) || strpos($options['mailchimp_api_key'], '-') === false) $errors[] = 'Invalid MailChimp API Key.';
//						if (empty($options['mailchimp_list_id'])) $errors[] = 'Invalid MailChimp List ID.';
					}
					if ($options['icontact_enable'] == 'on') {
						if (empty($options['icontact_appid'])) $errors[] = 'Invalid iContact App ID.';
						if (empty($options['icontact_apiusername'])) $errors[] = 'Invalid iContact API Username.';
						if (empty($options['icontact_apipassword'])) $errors[] = 'Invalid iContact API Password.';
//						if (empty($options['icontact_listid'])) $errors[] = 'Invalid iContact List ID.';
					}
					if ($options['campaignmonitor_enable'] == 'on') {
						if (empty($options['campaignmonitor_api_key'])) $errors[] = 'Invalid Campaign Monitor API Key.';
//						if (empty($options['campaignmonitor_list_id'])) $errors[] = 'Invalid Campaign Monitor List ID.';
					}
					if ($options['getresponse_enable'] == 'on') {
						if (empty($options['getresponse_api_key'])) $errors[] = 'Invalid GetResponse API Key.';
//						if (empty($options['getresponse_campaign_id'])) $errors[] = 'Invalid GetResponse Campaign ID.';
					}
					if ($options['aweber_enable'] == 'on') {
//						if (empty($options['aweber_listid'])) $errors[] = 'Invalid AWeber List ID.';
					}
					if ($options['madmimi_enable'] == 'on') {
						if (empty($options['madmimi_login'])) $errors[] = 'Invalid Mad Mimi username.';
						if (empty($options['madmimi_api_key'])) $errors[] = 'Invalid Mad Mimi API key.';
//						if (empty($options['madmimi_list_id'])) $errors[] = 'Invalid Mad Mimi list ID.';
					}
					if ($options['benchmark_enable'] == 'on') {
						if (empty($options['benchmark_api_key'])) $errors[] = 'Invalid Benchmark Email API key';
//						if (empty($options['benchmark_list_id'])) $errors[] = 'Invalid Benchmark Email list ID';
					}
					if ($options['activecampaign_enable'] == 'on') {
						if (strlen($options['activecampaign_url']) == 0 || !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $options['activecampaign_url'])) $errors[] = 'ActiveCampaign API URL must be a valid URL.';
						if (empty($options['activecampaign_api_key'])) $errors[] = 'Invalid ActiveCampaign API key';
//						if (empty($options['activecampaign_list_id'])) $errors[] = 'Invalid ActiveCampaign list ID';
					}
					if ($options['interspire_enable'] == 'on') {
						if (strlen($options['interspire_url']) == 0 || !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $options['interspire_url'])) $errors[] = 'Interspire XMP Path must be a valid URL.';
						if (empty($options['interspire_username'])) $errors[] = 'Invalid Interspire Username';
						if (empty($options['interspire_token'])) $errors[] = 'Invalid Interspire Token';
//						if (empty($options['interspire_listid'])) $errors[] = 'Invalid Interspire list ID';
					}
					if ($options['sendy_enable'] == 'on') {
						if (strlen($options['sendy_url']) == 0 || !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $options['sendy_url'])) $errors[] = 'Sendy installation URL must be a valid URL.';
//						if (empty($options['sendy_listid'])) $errors[] = 'Invalid Sendy list ID';
					}
					if (!empty($errors)) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Attention! Please correct the errors below and try again.<ul><li>'.implode('</li><li>', $errors).'</li></ul>';
						echo json_encode($return_object);
						exit;
					}
					$_options=new Project_Exquisite_Options();
					$_options->update_options( $options );
					$_SESSION['ok'] = 'Settings successfully <strong>saved</strong>.';
					$return_object = array();
					$return_object['status'] = 'OK';
					$return_object['return_url'] = Core_Module_Router::getCurrentUrl( array("name"=>"site1_exquisite_popups", "action"=>"settings") );
					echo json_encode($return_object);
					exit;
					break;
				
				case 'aweber-connect':
					if( $_SERVER['HTTP_HOST'] == 'cnm.local' ){
						$_data='
{"status":"OK","lists":{"270192":"ethiccash_free","273456":"showclicks_upgr","309222":"socializer","309710":"visualrank","314550":"vslibrary-news","314589":"niab_members","314836":"niab_jvmembers","314877":"insight_members","317011":"raisingchild","323554":"web20","323806":"web-20","336122":"forextraders","340321":"visitorsense","349634":"fs3","349636":"fs3_fs4","349637":"fs3_complete","349638":"fs3_gold","349640":"fs3_cnboto","353087":"jps_sdt","370881":"jstracker","389204":"vsvideos","389214":"vsvideosrr","389215":"vsvideosmrr","399915":"vslibrary","402338":"squidoo-re","403735":"squidoo-use","404052":"passablynews","421198":"mme3","423411":"mme3coop","429243":"niab-wait","490578":"wpmi-1","490974":"conversionpro","504979":"fbgifts","504980":"fbgifts2","514476":"nvsb","515607":"jpsdt2007","515935":"videositebuild","540363":"jpstraffictips","553771":"polka","556031":"polkaoto","557184":"safetrading","568780":"rwtraining","572271":"socializeitpro","633555":"tbbbonus","643289":"lsimonthly","652472":"web20-templates","665453":"web2templates","670720":"ts2bonusfromjp","685190":"nvcgold","687187":"nvc","714127":"web2tempdeal","717180":"flipthatwebsite","748914":"reviewsndeals","768503":"reviewsinabox","769754":"nichebusiness","812897":"fs4","912201":"statsjunkypro","970493":"plr-license","1009623":"fireblogging","1046022":"tgpsilver","1046023":"tgpgold","1046025":"tgpplatinum","1052505":"optprofits","1052614":"ppvrichesp","1052615":"ppvriches","1052654":"ppvrichesm","1057190":"ppvrichesa","1070714":"spbjvpartner","1088306":"spblueprint","1095624":"spbsoft","1095630":"spbpro","1165531":"profitoracle","1192118":"ledtvscreens","1297686":"ppvrichesvip","1317526":"skin-care-guide","1322310":"whiten-now","1352242":"nvsbplatinum","1364188":"ianretires","1466710":"turnsitesinto","1524245":"publicdomainme","1651063":"infinitefbjv","1651170":"infinitefbfull","1672259":"easyvideopress","1723324":"easy-exitbot","1747213":"freetgen-pl","1824955":"freetgen","1917319":"wsoxfactor","2141341":"nvsbspecial","2163953":"nvsbhosted","2270566":"gagnerplus2","2272322":"gagnerpluskindl","2351409":"ims-affiliates","2509795":"mlm101howto","2512167":"webtrafficom","2624838":"back-up-your-pc","2630501":"gimpdownload","2897529":"wpsimbonus","2955253":"zontlead","2955264":"zontlight","2987940":"paydayloanzus","3210454":"succeedmobile","3217026":"highqualitylead","3217371":"yoga247","3218572":"ocs-leads","3221790":"wpcheat","3262559":"jpsaffiliates","3361998":"roemails","3522553":"affiliateprofitmasterclass1","3522597":"affiliateprofitmasterclass9","3734806":"Healthy Diet","4049917":"LPS Prelaunch","4050556":"Pennyauctions","4095451":"realestatemogul","4114327":"Best Cooking Advices","4114672":"IAM- Astrology","4122662":"Be Green","4123856":"Wedding Planning NEwsletter","4123868":"iammmo","4124063":"iamselfimpro","4124141":"iamdebtmanagement","4124162":"iammusicguidetraining","4124215":"iamgardening","4124238":"iamartnentertainment","4126899":"iamtravelguides","4127836":"iamsportsfitness","4156660":"Gaming Tips and Tricks","4159181":"Games Tips and Tricks","4159191":"Gambling Tips and Tricks","4159196":"Alternative Medicine Tips","4159198":"Email Marketing Tips and Tricks","4159206":"Forex Tips and Tricks","4173188":"Beating Diabetes Weekly","4173200":"Dog Training Tricks and Tips","4173203":"Pregnancy and FitnessTricks and","4173206":"Body BuildingTricks and Tips","4173207":"Pay-Per-Click Advertising Tricks","4193572":"eCommerce Tips and Tricks","4193577":"Home Gardening Tips and Tricks","4193578":"Marriage Advice Weekly","4193582":"Parenting Advice Weekly","4193583":"Sewing Methods, Tips and Tricks","4193586":"Social Media Marketing, Tips and","4193591":"Stress Management Advice Weekly","4193593":"Video Marketing Tips and Tricks","4193600":"Website Design Resources &amp; Tips","4193603":"SEO Resources, Tips and Tricks","4201834":"Alternative Energy Tips &amp; Tricks","4201835":"Personal Finance Tips and Tricks","4201839":"Self Defense Weekly Guide","4201842":"Homebuying Advice Weekly","4201846":"Home Improvement Tips and Tricks","4201848":"Travel weekly Advice","4201850":"Wood Craft Advice Weekly","4201851":"Public Speaking Tips and Tricks","4201854":"Magic Tricks, Guide","4201856":"Survival Tips and Tricks","4217067":"Interior Design Tips and Tricks","4217070":"Self Defense Tips and Guides","4217072":"Time Management Tips and Tricks","4217075":"Traveling Tips Weekly","4224721":"How to Guide Tips and Tricks","4224724":"Photography Tips and Guides","4239308":"Baking Tips and Guides","4239311":"Body Art Tips and Tricks","4239316":"Home Improvement Weekly Guide","4239320":"Hypnosis Tips and Tricks","4239321":"Job Skills Weekly Guide","4239323":"Law &amp; Legal Services Tips","4239325":"Personal Transformation Advice","4239328":"Self Esteem Tips and Tricks","4239329":"Writing Tips &amp; Guide","4239331":"Cover Letters Tips and Guides","4270071":"Women In Their 40s","4270079":"Women In Their 40\'s","4288617":"Survival Tips &amp; Tricks","4291137":"Man\'s Guide to Career","4291149":"Becoming a Parent","4291151":"Look Beautiful and Live","4291160":"Working Woman\'s Guide","4291165":"Man\'s Guide to Life","4291183":"Internet Entrepreneur\'s Guide","4291189":"How to Finally Overcome Your Ang","4291190":"Ultimate Guide to Going College","4291197":"How to Keep Your Brain Active","4302462":"Survival Master Guide","4303641":"Becoming a parent Guide","4303649":"Cover Letters\/Resumes","4303655":"Look Beautiful For Women","4303661":"Man\'s Guide &amp; Tips to Career","4303667":"Man\'s Guide &amp; Tips to Life","4303669":"The Internet Entrepreneur\'s Guid","4303674":"Guide to Going to College","4303678":"The working Woman","4382897":"SurvivalMinds - Free Evac 3 Tool"},"html":"\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<th>Enable AWeber:<\/th>\n\t\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" id=\"ulp_aweber_enable\" name=\"ulp_aweber_enable\"  \/> Submit contact details to AWeber\n\t\t\t\t\t\t\t\t\t<br \/><em>Please tick checkbox if you want to submit contact details to AWeber.<\/em>\n\t\t\t\t\t\t\t\t<\/td>\n\t\t\t\t\t\t\t<\/tr>\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<th>List ID:<\/th>\n\t\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t\t<select name=\"ulp_aweber_listid\" class=\"ic_input_m\"><option value=\"270192\">ethiccash_free<\/option><option value=\"273456\">showclicks_upgr<\/option><option value=\"309222\">socializer<\/option><option value=\"309710\">visualrank<\/option><option value=\"314550\">vslibrary-news<\/option><option value=\"314589\">niab_members<\/option><option value=\"314836\">niab_jvmembers<\/option><option value=\"314877\">insight_members<\/option><option value=\"317011\">raisingchild<\/option><option value=\"323554\">web20<\/option><option value=\"323806\">web-20<\/option><option value=\"336122\">forextraders<\/option><option value=\"340321\">visitorsense<\/option><option value=\"349634\">fs3<\/option><option value=\"349636\">fs3_fs4<\/option><option value=\"349637\">fs3_complete<\/option><option value=\"349638\">fs3_gold<\/option><option value=\"349640\">fs3_cnboto<\/option><option value=\"353087\">jps_sdt<\/option><option value=\"370881\">jstracker<\/option><option value=\"389204\">vsvideos<\/option><option value=\"389214\">vsvideosrr<\/option><option value=\"389215\">vsvideosmrr<\/option><option value=\"399915\">vslibrary<\/option><option value=\"402338\">squidoo-re<\/option><option value=\"403735\">squidoo-use<\/option><option value=\"404052\">passablynews<\/option><option value=\"421198\">mme3<\/option><option value=\"423411\">mme3coop<\/option><option value=\"429243\">niab-wait<\/option><option value=\"490578\">wpmi-1<\/option><option value=\"490974\">conversionpro<\/option><option value=\"504979\">fbgifts<\/option><option value=\"504980\">fbgifts2<\/option><option value=\"514476\">nvsb<\/option><option value=\"515607\">jpsdt2007<\/option><option value=\"515935\">videositebuild<\/option><option value=\"540363\">jpstraffictips<\/option><option value=\"553771\">polka<\/option><option value=\"556031\">polkaoto<\/option><option value=\"557184\">safetrading<\/option><option value=\"568780\">rwtraining<\/option><option value=\"572271\">socializeitpro<\/option><option value=\"633555\">tbbbonus<\/option><option value=\"643289\">lsimonthly<\/option><option value=\"652472\">web20-templates<\/option><option value=\"665453\">web2templates<\/option><option value=\"670720\">ts2bonusfromjp<\/option><option value=\"685190\">nvcgold<\/option><option value=\"687187\">nvc<\/option><option value=\"714127\">web2tempdeal<\/option><option value=\"717180\">flipthatwebsite<\/option><option value=\"748914\">reviewsndeals<\/option><option value=\"768503\">reviewsinabox<\/option><option value=\"769754\">nichebusiness<\/option><option value=\"812897\">fs4<\/option><option value=\"912201\">statsjunkypro<\/option><option value=\"970493\">plr-license<\/option><option value=\"1009623\">fireblogging<\/option><option value=\"1046022\">tgpsilver<\/option><option value=\"1046023\">tgpgold<\/option><option value=\"1046025\">tgpplatinum<\/option><option value=\"1052505\">optprofits<\/option><option value=\"1052614\">ppvrichesp<\/option><option value=\"1052615\">ppvriches<\/option><option value=\"1052654\">ppvrichesm<\/option><option value=\"1057190\">ppvrichesa<\/option><option value=\"1070714\">spbjvpartner<\/option><option value=\"1088306\">spblueprint<\/option><option value=\"1095624\">spbsoft<\/option><option value=\"1095630\">spbpro<\/option><option value=\"1165531\">profitoracle<\/option><option value=\"1192118\">ledtvscreens<\/option><option value=\"1297686\">ppvrichesvip<\/option><option value=\"1317526\">skin-care-guide<\/option><option value=\"1322310\">whiten-now<\/option><option value=\"1352242\">nvsbplatinum<\/option><option value=\"1364188\">ianretires<\/option><option value=\"1466710\">turnsitesinto<\/option><option value=\"1524245\">publicdomainme<\/option><option value=\"1651063\">infinitefbjv<\/option><option value=\"1651170\">infinitefbfull<\/option><option value=\"1672259\">easyvideopress<\/option><option value=\"1723324\">easy-exitbot<\/option><option value=\"1747213\">freetgen-pl<\/option><option value=\"1824955\">freetgen<\/option><option value=\"1917319\">wsoxfactor<\/option><option value=\"2141341\">nvsbspecial<\/option><option value=\"2163953\">nvsbhosted<\/option><option value=\"2270566\">gagnerplus2<\/option><option value=\"2272322\">gagnerpluskindl<\/option><option value=\"2351409\">ims-affiliates<\/option><option value=\"2509795\">mlm101howto<\/option><option value=\"2512167\">webtrafficom<\/option><option value=\"2624838\">back-up-your-pc<\/option><option value=\"2630501\">gimpdownload<\/option><option value=\"2897529\">wpsimbonus<\/option><option value=\"2955253\">zontlead<\/option><option value=\"2955264\">zontlight<\/option><option value=\"2987940\">paydayloanzus<\/option><option value=\"3210454\">succeedmobile<\/option><option value=\"3217026\">highqualitylead<\/option><option value=\"3217371\">yoga247<\/option><option value=\"3218572\">ocs-leads<\/option><option value=\"3221790\">wpcheat<\/option><option value=\"3262559\">jpsaffiliates<\/option><option value=\"3361998\">roemails<\/option><option value=\"3522553\">affiliateprofitmasterclass1<\/option><option value=\"3522597\">affiliateprofitmasterclass9<\/option><option value=\"3734806\">Healthy Diet<\/option><option value=\"4049917\">LPS Prelaunch<\/option><option value=\"4050556\">Pennyauctions<\/option><option value=\"4095451\">realestatemogul<\/option><option value=\"4114327\">Best Cooking Advices<\/option><option value=\"4114672\">IAM- Astrology<\/option><option value=\"4122662\">Be Green<\/option><option value=\"4123856\">Wedding Planning NEwsletter<\/option><option value=\"4123868\">iammmo<\/option><option value=\"4124063\">iamselfimpro<\/option><option value=\"4124141\">iamdebtmanagement<\/option><option value=\"4124162\">iammusicguidetraining<\/option><option value=\"4124215\">iamgardening<\/option><option value=\"4124238\">iamartnentertainment<\/option><option value=\"4126899\">iamtravelguides<\/option><option value=\"4127836\">iamsportsfitness<\/option><option value=\"4156660\">Gaming Tips and Tricks<\/option><option value=\"4159181\">Games Tips and Tricks<\/option><option value=\"4159191\">Gambling Tips and Tricks<\/option><option value=\"4159196\">Alternative Medicine Tips<\/option><option value=\"4159198\">Email Marketing Tips and Tricks<\/option><option value=\"4159206\">Forex Tips and Tricks<\/option><option value=\"4173188\">Beating Diabetes Weekly<\/option><option value=\"4173200\">Dog Training Tricks and Tips<\/option><option value=\"4173203\">Pregnancy and FitnessTricks and<\/option><option value=\"4173206\">Body BuildingTricks and Tips<\/option><option value=\"4173207\">Pay-Per-Click Advertising Tricks<\/option><option value=\"4193572\">eCommerce Tips and Tricks<\/option><option value=\"4193577\">Home Gardening Tips and Tricks<\/option><option value=\"4193578\">Marriage Advice Weekly<\/option><option value=\"4193582\">Parenting Advice Weekly<\/option><option value=\"4193583\">Sewing Methods, Tips and Tricks<\/option><option value=\"4193586\">Social Media Marketing, Tips and<\/option><option value=\"4193591\">Stress Management Advice Weekly<\/option><option value=\"4193593\">Video Marketing Tips and Tricks<\/option><option value=\"4193600\">Website Design Resources &amp; Tips<\/option><option value=\"4193603\">SEO Resources, Tips and Tricks<\/option><option value=\"4201834\">Alternative Energy Tips &amp; Tricks<\/option><option value=\"4201835\">Personal Finance Tips and Tricks<\/option><option value=\"4201839\">Self Defense Weekly Guide<\/option><option value=\"4201842\">Homebuying Advice Weekly<\/option><option value=\"4201846\">Home Improvement Tips and Tricks<\/option><option value=\"4201848\">Travel weekly Advice<\/option><option value=\"4201850\">Wood Craft Advice Weekly<\/option><option value=\"4201851\">Public Speaking Tips and Tricks<\/option><option value=\"4201854\">Magic Tricks, Guide<\/option><option value=\"4201856\">Survival Tips and Tricks<\/option><option value=\"4217067\">Interior Design Tips and Tricks<\/option><option value=\"4217070\">Self Defense Tips and Guides<\/option><option value=\"4217072\">Time Management Tips and Tricks<\/option><option value=\"4217075\">Traveling Tips Weekly<\/option><option value=\"4224721\">How to Guide Tips and Tricks<\/option><option value=\"4224724\">Photography Tips and Guides<\/option><option value=\"4239308\">Baking Tips and Guides<\/option><option value=\"4239311\">Body Art Tips and Tricks<\/option><option value=\"4239316\">Home Improvement Weekly Guide<\/option><option value=\"4239320\">Hypnosis Tips and Tricks<\/option><option value=\"4239321\">Job Skills Weekly Guide<\/option><option value=\"4239323\">Law &amp; Legal Services Tips<\/option><option value=\"4239325\">Personal Transformation Advice<\/option><option value=\"4239328\">Self Esteem Tips and Tricks<\/option><option value=\"4239329\">Writing Tips &amp; Guide<\/option><option value=\"4239331\">Cover Letters Tips and Guides<\/option><option value=\"4270071\">Women In Their 40s<\/option><option value=\"4270079\">Women In Their 40\'s<\/option><option value=\"4288617\">Survival Tips &amp; Tricks<\/option><option value=\"4291137\">Man\'s Guide to Career<\/option><option value=\"4291149\">Becoming a Parent<\/option><option value=\"4291151\">Look Beautiful and Live<\/option><option value=\"4291160\">Working Woman\'s Guide<\/option><option value=\"4291165\">Man\'s Guide to Life<\/option><option value=\"4291183\">Internet Entrepreneur\'s Guide<\/option><option value=\"4291189\">How to Finally Overcome Your Ang<\/option><option value=\"4291190\">Ultimate Guide to Going College<\/option><option value=\"4291197\">How to Keep Your Brain Active<\/option><option value=\"4302462\">Survival Master Guide<\/option><option value=\"4303641\">Becoming a parent Guide<\/option><option value=\"4303649\">Cover Letters\/Resumes<\/option><option value=\"4303655\">Look Beautiful For Women<\/option><option value=\"4303661\">Man\'s Guide &amp; Tips to Career<\/option><option value=\"4303667\">Man\'s Guide &amp; Tips to Life<\/option><option value=\"4303669\">The Internet Entrepreneur\'s Guid<\/option><option value=\"4303674\">Guide to Going to College<\/option><option value=\"4303678\">The working Woman<\/option><option value=\"4382897\">SurvivalMinds - Free Evac 3 Tool<\/option>\n\t\t\t\t\t\t\t\t\t<\/select>\n\t\t\t\t\t\t\t\t\t<br \/><em>Select your List ID.<\/em>\n\t\t\t\t\t\t\t\t<\/td>\n\t\t\t\t\t\t\t<\/tr>","api_settings":{"aweber_consumer_key":"AzdQZZUCIu3yl6WrVm3LfLTQ","aweber_consumer_secret":"AVFiJKCwGn6CEMvmLY7euq3eU6CoaYBbPAi7Q6l7","aweber_access_key":"AgyTpImXiGHvc15tym1x8Hhc","aweber_access_secret":"6PQAkPFjyGzuyHoNMCrzfdk4aVECyfOQRSgtoLtN"}}';
						echo json_encode(json_decode($_data));
						exit;
					}
					if (!isset($_POST['aweber-oauth-id']) || empty($_POST['aweber-oauth-id'])) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Authorization Code not found.';
						echo json_encode($return_object);
						exit;
					}
					$code=trim(stripslashes($_POST['aweber-oauth-id']));
					$account = null;
					$_errorMessageFromApi='Invalid Authorization Code!';
					if( $_SERVER['HTTP_HOST'] != 'cnm.local' ){
						ob_start();
						try {
							require_once 'library/AWeberAPI/aweber.php';
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = AWeberAPI::getDataFromAweberID($code);
						} catch (AWeberAPIException $exc) {
							$_errorMessageFromApi=$exc->message;
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = null;
						} catch (AWeberOAuthDataMissing $exc) {
							$_errorMessageFromApi=$exc->message;
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = null;
						} catch (AWeberException $exc) {
							$_errorMessageFromApi=$exc->message;
							list($consumer_key, $consumer_secret, $access_key, $access_secret) = null;
						}
						ob_clean();
					}
					if (!$access_secret) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = $_errorMessageFromApi;
						echo json_encode($return_object);
						exit;
					}else{
						try {
							$aweber = new AWeberAPI($consumer_key, $consumer_secret);
							$account = $aweber->getAccount($access_key, $access_secret);
						} catch (AWeberException $e) {
							$return_object = array();
							$return_object['status'] = 'ERROR';
							$return_object['message'] = 'Can not access AWeber account!';
							echo json_encode($return_object);
							exit;
						}
					}
					$options['aweber_consumer_key'] = $consumer_key;
					$options['aweber_consumer_secret'] = $consumer_secret;
					$options['aweber_access_key'] = $access_key;
					$options['aweber_access_secret'] = $access_secret;
					$_options=new Project_Exquisite_Options();
					$_options->update_options( $options );

					if ($options['aweber_access_secret']) {
						$return_object = array();
						$return_object['status'] = 'OK';
						try {
							$aweber = new AWeberAPI($options['aweber_consumer_key'], $options['aweber_consumer_secret']);
							$aweber_account = $aweber->getAccount($options['aweber_access_key'], $options['aweber_access_secret']);
							$return_object['lists']=array();
							$lists=$aweber_account->lists->find(array());
							foreach( $lists->data['entries'] as $list ){
								$return_object['lists'][$list['id']]=$list['name'];
							}
							$_allCount=count( $lists );
							for( $i=100; isset( $lists->data['next_collection_link'] ) && $i<$_allCount; $i+=100 ){
								$lists=$account->lists->find( array('ws.start'=>$i) );
								foreach( $lists->data['entries'] as $list ){
									$return_object['lists'][$list['id']]=$list['name'];
								}
							}
							if( empty($return_object['lists']) ){
								$return_object['html'] = '
								<tr>
									<th>Enable AWeber:</th>
									<td>This AWeber account does not currently have any lists.</td>
								</tr>';
							}else{
							$return_object['html'] = '
							<tr>
								<th>Enable AWeber:</th>
								<td>
									<input type="checkbox" id="ulp_aweber_enable" name="ulp_aweber_enable" '.(($options['aweber_enable'] == "on")?'checked="checked"':'').' /> Submit contact details to AWeber
									<br /><em>Please tick checkbox if you want to submit contact details to AWeber.</em>
								</td>
							</tr>
							<tr>
								<th>List ID:</th>
								<td>
									<select name="ulp_aweber_listid" class="ic_input_m">';
										foreach ( $return_object['lists'] as $listId=>$listName ){
											//$return_object['options']=$return_object['options'].'<option value="'.$listId.'"'.(( $listId == $options['aweber_listid'] )?' selected="selected"':'').'>'.$listName.'</option>';
											$return_object['html']=$return_object['html'].'<option value="'.$listId.'"'.(( $listId == $options['aweber_listid'] )?' selected="selected"':'').'>'.$listName.'</option>';
										}
									$return_object['html']=$return_object['html'].'
									</select>
									<br /><em>Select your List ID.</em>
								</td>
							</tr>';
							}
						} catch (AWeberException $e) {
								$return_object['status'] = 'FALSE';
						}
					}
					$return_object['api_settings']=$options;
					echo json_encode($return_object);
					exit;
					break;

				case 'aweber-disconnect':
					$options['aweber_consumer_key'] = '';
					$options['aweber_consumer_secret'] = '';
					$options['aweber_access_key'] = '';
					$options['aweber_access_secret'] = '';
					$_options=new Project_Exquisite_Options();
					$_options->update_options( $options );
					$return_object = array();
					$return_object['status'] = 'OK';
					$return_object['html'] = '
						<table class="ulp_useroptions">
							<tr>
								<th>Authorization code:</th>
								<td>
									<input type="text" id="ulp_aweber_oauth_id" value="" class="widefat" placeholder="AWeber authorization code">
									<br />Get your authorization code <a target="_blank" href="https://auth.aweber.com/1.0/oauth/authorize_app/'.Project_Exquisite::$AWeberAppId.'">here</a>.
								</td>
							</tr>
							<tr>
								<th></th>
								<td style="vertical-align: middle;">
									<input type="button" class="ulp_button button-secondary" value="Make Connection" onclick="return ulp_aweber_connect();" >
									<img id="ulp-aweber-loading" src="/skin/i/frontends/design/newUI/exquisite_popups/loading.gif">
								</td>
							</tr>
						</table>';
					echo json_encode($return_object);
					exit;
					break;
					
				case 'delete':
					$id = intval($_GET["id"]);
					$_popup=new Project_Exquisite_Popups();
					$_popup->withIds( $id )->get( $popup_details );
					if (intval($popup_details["id"]) == 0) {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					if ( $_popup->withIds( $id )->del() !== false ) {
						$_SESSION['ok'] = 'Popup successfully <strong>removed</strong>.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					} else {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					exit;
					break;

				case 'block':
					$id = intval($_GET["id"]);
					$_popup=new Project_Exquisite_Popups();
					$_popup->withIds( $id )->get( $popup_details );
					if (intval($popup_details["id"]) == 0) {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					if ( $_popup->setEntered( array('blocked'=>1)+$popup_details )->set() ) {
						$_SESSION['ok'] = 'Popup successfully <strong>blocked</strong>.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					} else {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					exit;
					break;

				case 'unblock':
					$id = intval($_GET["id"]);
					$_popup=new Project_Exquisite_Popups();
					$_popup->withIds( $id )->get( $popup_details );
					if (intval($popup_details["id"]) == 0) {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					if ( $_popup->setEntered( array('blocked'=>0)+$popup_details )->set() ) {
						$_SESSION['ok'] = 'Popup successfully <strong>unblocked</strong>.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					} else {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					exit;
					break;

				case 'export':
					error_reporting(0);
					$id = intval($_GET["id"]);
					$_popup=new Project_Exquisite_Popups();
					$_popup->withIds( $id )->get( $popup_details );
					$popup_full = array();
					if (!empty($popup_details)) {
						$popup_full = array();
						$popup_full['popup'] = $popup_details;
						$_layers=new Project_Exquisite_Layers();
						$_layers->withPopupId( $id )->getList( $popup_full['layers'] );
						foreach ($popup_full['layers'] as $idx => $layer) {
							$layer_options = unserialize($layer['details']);
							if( empty( $layer_options ) ){
								$layer_options = unserialize( preg_replace_callback('!s:(\d+):"(.*?)";!s', "'s:'.strlen('$2').':\"$2\";'", $layer['details'] ) );
							}
							$layer_options = array_merge(Project_Exquisite_Layers::$defaultOptions, $layer_options);
							$layer_options = $_object->filter_lp_reverse($layer_options, Project_Exquisite::urlBase());
							$popup_full['layers'][$idx]['content'] = str_replace(Project_Exquisite::urlBase(), 'ULP-DEMO-IMAGES-URL', $value);
							$popup_full['layers'][$idx]['details'] = serialize($layer_options);
						}
						$popup_data = serialize($popup_full);
						$output = Project_Exquisite::$version.PHP_EOL.md5($popup_data).PHP_EOL.base64_encode($popup_data);
						if (strstr($_SERVER["HTTP_USER_AGENT"],"MSIE")) {
							header("Pragma: public");
							header("Expires: 0");
							header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
							header("Content-type: application-download");
							header('Content-Disposition: attachment; filename="'.$popup_details['str_id'].'.txt"');
							header("Content-Transfer-Encoding: binary");
						} else {
							header("Content-type: application-download");
							header('Content-Disposition: attachment; filename="'.$popup_details['str_id'].'.txt"');
						}
						echo $output;
						flush();
						ob_flush();
						exit;
					}
					$this->location( array( 'action'=>'manage' ) );
					exit;
					break;
					
				case 'import':
					$_arrErrors=array();
					$_countOk=0;
					foreach( $_FILES["ulp-file"]['tmp_name'] as $_key=>$_name ){
						if (is_uploaded_file($_name)) {
							$lines = file($_name);
							if (sizeof($lines) != 3) {
								$_arrErrors[] = $_FILES["ulp-file"]['name'][$_key].' <strong>Invalid</strong> popup file.';
								continue;
							}
							$version = intval(trim($lines[0]));
							if ($version > intval(Project_Exquisite::$version)) {
								$_arrErrors[] = $_FILES["ulp-file"]['name'][$_key].' Popup file version <strong>is not supported</strong>.';
								continue;
							}
							$md5_hash = trim($lines[1]);
							$popup_data = trim($lines[2]);
							$popup_data = base64_decode($popup_data);
							if (!$popup_data || md5($popup_data) != $md5_hash) {
								$_arrErrors[] = $_FILES["ulp-file"]['name'][$_key].' Popup file <strong>corrupted</strong>.';
								continue;
							}
							$popup = unserialize($popup_data);
							$popup_details = $popup['popup'];
							$str_id = $_object->random_string(16);
							$_popup=new Project_Exquisite_Popups();
							$_popup->setEntered( array(
								'str_id'=>$str_id,
								'title'=>$popup_details['title'],
								'width'=>intval($popup_details['width']),
								'height'=>intval($popup_details['height']),
								'options'=>$popup_details['options'],
								'blocked'=>1,
							) )->set();
							$_popup->getEntered( $_arrPopup );
							$popup_id = $_arrPopup['id'];
							$layers = $popup['layers'];
							if (sizeof($layers) > 0) {
								$_layers=new Project_Exquisite_Layers();
								foreach ($layers as $layer) {
									$_layers->setEntered( array(
										'popup_id'=>$popup_id,
										'title'=>$layer['title'],
										'content'=>$layer['content'],
										'zindex'=>$layer['zindex'],
										'details'=>$layer['details'],
									) )->set();
								}
							}
							$_countOk++;
						}
					}
					if( count( $_arrErrors )>0 ) {
						$_SESSION['error']='Popup file(s) <strong>not uploaded</strong><br/>'.implode( '<br/>', $_arrErrors );
					}
					if( $_countOk > 0 ){
						$_SESSION['ok'] = 'New popup(s) successfully <strong>imported</strong> and marked as <strong>blocked</strong>.';
					}
					$this->location( array( 'action'=>'manage' ) );
					exit;
					break;
				
				case 'copy':
					$id = intval($_GET["id"]);
					$_popup=new Project_Exquisite_Popups();
					$_popup->withIds( $id )->get( $popup_details );
					if (empty($popup_details)) {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'manage' ) );
						exit;
					}
					$str_id = $_object->random_string(16);
					$_popup->setEntered( array(
						'str_id'=>$str_id,
						'title'=>$popup_details['title'],
						'width'=>intval($popup_details['width']),
						'height'=>intval($popup_details['height']),
						'options'=>$popup_details['options'],
					) )->set();
					$_popup->getEntered( $_arrPopup );
					$popup_id = $_arrPopup['id'];
					$_layers=new Project_Exquisite_Layers();
					$_layers->withPopupId( $popup_details['id'] )->getList( $layers );
					if (sizeof($layers) > 0) {
						foreach ($layers as $layer) {
							$_layers->setEntered( array(
								'popup_id'=>$popup_id,
								'title'=>$layer['title'],
								'content'=>$layer['content'],
								'zindex'=>$layer['zindex'],
								'details'=>$layer['details'],
							) )->set();
						}
					}
					$_SESSION['ok'] = 'Popup successfully <strong>duplicated</strong>.';
					$this->location( array( 'action'=>'manage' ) );
					exit;
					break;
				
				case 'save-popup':
					foreach (Project_Exquisite_Popups::$defaultOptions as $key => $value) {
						if (isset($_POST['ulp_'.$key])){
							$popup_options[$key] = stripslashes(trim($_POST['ulp_'.$key]));
						}
					}
					foreach (Project_Exquisite_Options::$defaultOptions as $key => $value) {
						if (isset($_POST['ulp_'.$key])){
							$popup_options[$key] = stripslashes(trim($_POST['ulp_'.$key]));
						}
					}
					if (isset($_POST["ulp_mailchimp_double"])) $popup_options['mailchimp_double'] = "on";
					else $popup_options['mailchimp_double'] = "off";
					if (isset($_POST["ulp_mailchimp_welcome"])) $popup_options['mailchimp_welcome'] = "on";
					else $popup_options['mailchimp_welcome'] = "off";
					if (isset($_POST["ulp_mailchimp_enable"])) $popup_options['mailchimp_enable'] = "on";
					else $popup_options['mailchimp_enable'] = "off";
					if (isset($_POST["ulp_icontact_enable"])) $popup_options['icontact_enable'] = "on";
					else $popup_options['icontact_enable'] = "off";
					if (isset($_POST["ulp_campaignmonitor_enable"])) $popup_options['campaignmonitor_enable'] = "on";
					else $popup_options['campaignmonitor_enable'] = "off";
					if (isset($_POST["ulp_getresponse_enable"])) $popup_options['getresponse_enable'] = "on";
					else $popup_options['getresponse_enable'] = "off";
					if (isset($_POST["ulp_aweber_enable"])) $popup_options['aweber_enable'] = "on";
					else $popup_options['aweber_enable'] = "off";
					if (isset($_POST["ulp_madmimi_enable"])) $popup_options['madmimi_enable'] = "on";
					else $popup_options['madmimi_enable'] = "off";
					if (isset($_POST["ulp_benchmark_enable"])) $popup_options['benchmark_enable'] = "on";
					else $popup_options['benchmark_enable'] = "off";
					if (isset($_POST["ulp_benchmark_double"])) $popup_options['benchmark_double'] = "on";
					else $popup_options['benchmark_double'] = "off";
					if (isset($_POST["ulp_activecampaign_enable"])) $popup_options['activecampaign_enable'] = "on";
					else $popup_options['activecampaign_enable'] = "off";
					if (isset($_POST["ulp_interspire_enable"])) $popup_options['interspire_enable'] = "on";
					else $popup_options['interspire_enable'] = "off";
					if (isset($_POST["ulp_sendy_enable"])) $popup_options['sendy_enable'] = "on";
					else $popup_options['sendy_enable'] = "off";
					if (isset($_POST["ulp_enable_close"])) $popup_options['enable_close'] = "on";
					else $popup_options['enable_close'] = "off";
					if (isset($_POST["ulp_mail_enable"])) $popup_options['mail_enable'] = "on";
					else $popup_options['mail_enable'] = "off";
					if (isset($_POST["ulp_name_mandatory"])) $popup_options['name_mandatory'] = "on";
					else $popup_options['name_mandatory'] = "off";
					if (isset($_POST["ulp_phone_mandatory"])) $popup_options['phone_mandatory'] = "on";
					else $popup_options['phone_mandatory'] = "off";
					if (isset($_POST["ulp_message_mandatory"])) $popup_options['message_mandatory'] = "on";
					else $popup_options['message_mandatory'] = "off";
					if (isset($_POST["ulp_button_gradient"])) $popup_options['button_gradient'] = "on";
					else $popup_options['button_gradient'] = "off";
					if (isset($_POST["ulp_button_inherit_size"])) $popup_options['button_inherit_size'] = "on";
					else $popup_options['button_inherit_size'] = "off";
					if (isset($_POST["ulp_input_icons"])) $popup_options['input_icons'] = "on";
					else $popup_options['input_icons'] = "off";
					if (isset($_POST["ulp_social_google_plusone"])) $popup_options['social_google_plusone'] = "on";
					else $popup_options['social_google_plusone'] = "off";
					if (isset($_POST["ulp_social_facebook_like"])) $popup_options['social_facebook_like'] = "on";
					else $popup_options['social_facebook_like'] = "off";
					if (isset($_POST["ulp_social_twitter_tweet"])) $popup_options['social_twitter_tweet'] = "on";
					else $popup_options['social_twitter_tweet'] = "off";
					if (isset($_POST["ulp_social_linkedin_share"])) $popup_options['social_linkedin_share'] = "on";
					else $popup_options['social_linkedin_share'] = "off";
					if (isset($_POST['ulp_id'])) $popup_id = intval($_POST['ulp_id']);
					else $popup_id = 0;
					$_popups=new Project_Exquisite_Popups();
					$_popups->withIds( $popup_id )->getList( $popup_details );
					if (empty($popup_details)) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Invalid popup ID. Try again later.';
						echo json_encode($return_object);
						exit;
					}
					
					
					$errors = array();
					
					if ($popup_options['mailchimp_enable'] == 'on') {
						if (empty($popup_options['mailchimp_api_key']) || strpos($popup_options['mailchimp_api_key'], '-') === false) $errors[] = 'Invalid MailChimp API Key. Check Settings.';
						if (empty($popup_options['mailchimp_list_id'])) $errors[] = 'Invalid MailChimp List ID.';
					}
					if ($popup_options['icontact_enable'] == 'on') {
						if (empty($popup_options['icontact_appid'])) $errors[] = 'Invalid iContact App ID. Check Settings.';
						if (empty($popup_options['icontact_apiusername'])) $errors[] = 'Invalid iContact API Username. Check Settings.';
						if (empty($popup_options['icontact_apipassword'])) $errors[] = 'Invalid iContact API Password. Check Settings.';
						if (empty($popup_options['icontact_listid'])) $errors[] = 'Invalid iContact List ID.';
					}
					if ($popup_options['campaignmonitor_enable'] == 'on') {
						if (empty($popup_options['campaignmonitor_api_key'])) $errors[] = 'Invalid Campaign Monitor API Key. Check Settings.';
						if (empty($popup_options['campaignmonitor_list_id'])) $errors[] = 'Invalid Campaign Monitor List ID.';
					}
					if ($popup_options['getresponse_enable'] == 'on') {
						if (empty($popup_options['getresponse_api_key'])) $errors[] = 'Invalid GetResponse API Key. Check Settings.';
						if (empty($popup_options['getresponse_campaign_id'])) $errors[] = 'Invalid GetResponse Campaign ID.';
					}
					if ($popup_options['aweber_enable'] == 'on') {
						if (empty($popup_options['aweber_listid'])) $errors[] = 'Invalid AWeber List ID.';
					}
					if ($popup_options['madmimi_enable'] == 'on') {
						if (empty($popup_options['madmimi_login'])) $errors[] = 'Invalid Mad Mimi username. Check Settings.';
						if (empty($popup_options['madmimi_api_key'])) $errors[] = 'Invalid Mad Mimi API key. Check Settings.';
						if (empty($popup_options['madmimi_list_id'])) $errors[] = 'Invalid Mad Mimi list ID.';
					}
					if ($popup_options['benchmark_enable'] == 'on') {
						if (empty($popup_options['benchmark_api_key'])) $errors[] = 'Invalid Benchmark Email API key. Check Settings.';
						if (empty($popup_options['benchmark_list_id'])) $errors[] = 'Invalid Benchmark Email list ID.';
					}
					if ($popup_options['activecampaign_enable'] == 'on') {
						if (strlen($popup_options['activecampaign_url']) == 0 || !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $popup_options['activecampaign_url'])) $errors[] = 'ActiveCampaign API URL must be a valid URL. Check Settings.';
						if (empty($popup_options['activecampaign_api_key'])) $errors[] = 'Invalid ActiveCampaign API key. Check Settings.';
						if (empty($popup_options['activecampaign_list_id'])) $errors[] = 'Invalid ActiveCampaign list ID.';
					}
					if ($popup_options['interspire_enable'] == 'on') {
						if (strlen($popup_options['interspire_url']) == 0 || !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $popup_options['interspire_url'])) $errors[] = 'Interspire XMP Path must be a valid URL. Check Settings.';
						if (empty($popup_options['interspire_username'])) $errors[] = 'Invalid Interspire Username. Check Settings.';
						if (empty($popup_options['interspire_token'])) $errors[] = 'Invalid Interspire Token. Check Settings.';
						if (empty($popup_options['interspire_listid'])) $errors[] = 'Invalid Interspire list ID.';
					}
					if ($popup_options['sendy_enable'] == 'on') {
						if (strlen($popup_options['sendy_url']) == 0 || !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $popup_options['sendy_url'])) $errors[] = 'Sendy installation URL must be a valid URL. Check Settings.';
						if (empty($popup_options['sendy_listid'])) $errors[] = 'Invalid Sendy list ID.';
					}
					
					
					if (strlen($popup_options['onload_delay']) > 0 && $popup_options['onload_delay'] != preg_replace('/[^0-9]/', '', $popup_options['onload_delay'])) 
						$errors[] = 'Invalid OnLoad delay value.';
					if (strlen($popup_options['onscroll_offset']) > 0 && $popup_options['onscroll_offset'] != preg_replace('/[^0-9]/', '', $popup_options['onscroll_offset'])) 
						$errors[] = 'Invalid OnScroll offset value.';

					$_layers=new Project_Exquisite_Layers();
					$_layers->withPopupId( $popup_id )->getList( $layers );//$layers = $icdb->get_row("SELECT * FROM ".$icdb->prefix."layers WHERE popup_id = '".$popup_id."' AND deleted = '0'");
					if (!$layers) $errors[] = 'Create at least one layer.';
					if (strlen($popup_options['title']) < 1) $errors[] = 'Popup title is too short.';
					if (strlen($popup_options['width']) > 0 && $popup_options['width'] != preg_replace('/[^0-9]/', '', $popup_options['width'])) $errors[] = 'Invalid popup basic width.';
					if (strlen($popup_options['height']) > 0 && $popup_options['height'] != preg_replace('/[^0-9]/', '', $popup_options['height'])) $errors[] = 'Invalid popup basic height.';
					if (strlen($popup_options['overlay_color']) > 0 && $_object->get_rgb($popup_options['overlay_color']) === false) $errors[] = 'Ovarlay color must be a valid value.';
					if (floatval($popup_options['overlay_opacity']) < 0 || floatval($popup_options['overlay_opacity']) > 1) $errors[] = 'Overlay opacity must be in a range [0...1].';
					if (strlen($popup_options['name_placeholder']) < 1) $errors[] = '"Name" field placeholder is too short.';
					if (strlen($popup_options['email_placeholder']) < 1) $errors[] = '"E-mail" field placeholder is too short.';
					if (strlen($popup_options['phone_placeholder']) < 1) $errors[] ='"Phone number" field placeholder is too short.';
					if (strlen($popup_options['message_placeholder']) < 1) $errors[] ='"Message" text area placeholder is too short.';
					if (strlen($popup_options['input_border_color']) > 0 && $_object->get_rgb($popup_options['input_border_color']) === false) $errors[] = 'Input filed border color must be a valid value.';
					if (strlen($popup_options['input_background_color']) > 0 && $_object->get_rgb($popup_options['input_background_color']) === false) $errors[] = 'Input filed background color must be a valid value.';
					if (floatval($popup_options['input_background_opacity']) < 0 || floatval($popup_options['input_background_opacity']) > 1) $errors[] = 'Input filed background opacity must be in a range [0...1].';
					if (strlen($popup_options['button_label']) < 1) $errors[] = '"Subscribe" button label is too short.';
					if (strlen($popup_options['button_label_loading']) < 1) $errors[] = '"Loading" button label is too short.';
					if (strlen($popup_options['button_color']) == 0 || $_object->get_rgb($popup_options['button_color']) === false) $errors[] = '"Subscribe" button color must be a valid value.';
					if (strlen($popup_options['return_url']) > 0 && !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $popup_options['return_url'])) $errors[] = 'Redirect URL must be a valid URL.';
					if (strlen($popup_options['close_delay']) > 0 && $popup_options['close_delay'] != preg_replace('/[^0-9]/', '', $popup_options['close_delay'])) $errors[] ='Invalid autoclose delay.';
					if (strlen($popup_options['input_border_width']) > 0 && $popup_options['input_border_width'] != preg_replace('/[^0-9]/', '', $popup_options['input_border_width'])) $errors[] = 'Invalid input field border width.';
					if (strlen($popup_options['input_border_radius']) > 0 && $popup_options['input_border_radius'] != preg_replace('/[^0-9]/', '', $popup_options['input_border_radius'])) $errors[] = 'Invalid input field border radius.';
					if (strlen($popup_options['button_border_radius']) > 0 && $popup_options['button_border_radius'] != preg_replace('/[^0-9]/', '', $popup_options['button_border_radius'])) $errors[] = 'Invalid "Subscribe" button border radius.';
					if (strlen($popup_options['social_url']) > 0 && !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $popup_options['social_url'])) $errors[] = 'Social URL must be a valid URL.';
					if (strlen($popup_options['social_margin']) > 0 && $popup_options['social_margin'] != preg_replace('/[^0-9]/', '', $popup_options['social_margin'])) $errors[] = 'Invalid social button margin.';
					if (strlen($popup_options['social2_facebook_label']) < 1) $errors[] = 'Facebook Button label is too short.';
					if (strlen($popup_options['social2_facebook_color']) == 0 || $_object->get_rgb($popup_options['social2_facebook_color']) === false) $errors[] = 'Facebook Button color must be a valid value.';
					if (strlen($popup_options['social2_google_label']) < 1) $errors[] = 'Google Button label is too short.';
					if (strlen($popup_options['social2_google_color']) == 0 || $_object->get_rgb($popup_options['social2_google_color']) === false) $errors[] = 'Google Button color must be a valid value.';
					if (!empty($errors)) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Attention! Please correct the errors below and try again.<ul><li>'.implode('</li><li>', $errors).'</li></ul>';
						echo json_encode($return_object);
						exit;
					}
					$_popups->setEntered( array(
						'id'=>$popup_id,
						'title'=>$popup_options['title'],
						'width'=>intval($popup_options['width']),
						'height'=>intval($popup_options['height']),
						'options'=>serialize($popup_options),
					) )->set();
					$_SESSION['ok'] = 'Popup details successfully <strong>saved</strong>.';
					$return_object = array();
					$return_object['status'] = 'OK';
					$return_object['return_url'] = Core_Module_Router::getCurrentUrl( array("name"=>"site1_exquisite_popups", "action"=>"manage") );
					echo json_encode($return_object);
					exit;
					break;
				
				case 'save-layer':
					foreach (Project_Exquisite_Layers::$defaultOptions as $key => $value) {
						if (isset($_POST['ulp_layer_'.$key])) {
							$layer_options[$key] = stripslashes(trim($_POST['ulp_layer_'.$key]));
						}
					}
					if (isset($_POST['ulp_layer_id'])) $layer_id = intval($_POST['ulp_layer_id']);
					else $layer_id = '0';
					if (isset($_POST['ulp_popup_id'])) $popup_id = intval($_POST['ulp_popup_id']);
					else $popup_id = '0';
					if (isset($_POST['ulp_layer_confirmation_layer'])) $layer_options['confirmation_layer'] = 'on';
					else $layer_options['confirmation_layer'] = 'off';
					if (isset($_POST['ulp_layer_inline_disable'])) $layer_options['inline_disable'] = 'on';
					else $layer_options['inline_disable'] = 'off';
					$_popups=new Project_Exquisite_Popups();
					$_popups->withIds( $popup_id )->getList( $popup_details );//  $icdb->get_row("SELECT * FROM ".$icdb->prefix."popups WHERE id = '".$popup_id."'");
					if (empty($popup_details)) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Invalid popup ID. Try again later.';
						echo json_encode($return_object);
						exit;
					}
					$errors = array();
					if (strlen($layer_options['title']) < 1) $errors[] = 'Layer title is too short.';
					if (strlen($layer_options['width']) > 0 && $layer_options['width'] != preg_replace('/[^0-9]/', '', $layer_options['width'])) $errors[] = 'Invalid layer width.';
					if (strlen($layer_options['height']) > 0 && $layer_options['height'] != preg_replace('/[^0-9]/', '', $layer_options['height'])) $errors[] = 'Invalid layer height.';
					if (strlen($layer_options['left']) == 0 || $layer_options['left'] != preg_replace('/[^0-9\-]/', '', $layer_options['left'])) $errors[] = 'Invalid left position.';
					if (strlen($layer_options['top']) == 0 || $layer_options['top'] != preg_replace('/[^0-9\-]/', '', $layer_options['top'])) $errors[] = 'Invalid top position.';
					if (strlen($layer_options['background_color']) > 0 && $_object->get_rgb($layer_options['background_color']) === false) $errors[] = 'Background color must be a valid value.';
					if (floatval($layer_options['background_opacity']) < 0 || floatval($layer_options['background_opacity']) > 1) $errors[] = 'Background opacity must be in a range [0...1].';
					if (strlen($layer_options['background_image']) > 0 && !preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $layer_options['background_image'])) $errors[] = 'Background image URL must be a valid URL.';
					if (strlen($layer_options['index']) > 0 && $layer_options['index'] != preg_replace('/[^0-9]/', '', $layer_options['index']) && $layer_options['index'] > 100) $errors[] = 'Layer index must be in a range [0...100].';
					if (strlen($layer_options['appearance_delay']) > 0 && $layer_options['appearance_delay'] != preg_replace('/[^0-9]/', '', $layer_options['appearance_delay']) && $layer_options['appearance_delay'] > 10000) $errors[] = 'Appearance start delay must be in a range [0...10000].';
					if (strlen($layer_options['appearance_speed']) > 0 && $layer_options['appearance_speed'] != preg_replace('/[^0-9]/', '', $layer_options['appearance_speed']) && $layer_options['appearance_speed'] > 10000) $errors[] = 'Appearance duration speed must be in a range [0...10000].';
					if (strlen($layer_options['font_color']) > 0 && $_object->get_rgb($layer_options['font_color']) === false) $errors[] = 'Font color must be a valid value.';
					if (strlen($layer_options['font_size']) > 0 && $layer_options['font_size'] != preg_replace('/[^0-9]/', '', $layer_options['font_size']) && ($layer_options['font_size'] > 72 || $layer_options['font_size'] < 10)) $errors[] = 'Font size must be in a range [10...72].';
					if (strlen($layer_options['text_shadow_color']) > 0 && $_object->get_rgb($layer_options['text_shadow_color']) === false) $errors[] = 'Text shadow color must be a valid value.';
					if (strlen($layer_options['text_shadow_size']) > 0 && $layer_options['text_shadow_size'] != preg_replace('/[^0-9]/', '', $layer_options['text_shadow_size']) && $layer_options['text_shadow_size'] > 72) $errors[] = 'Text shadow size must be in a range [0...72].';
					if (!empty($errors)) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Attention! Please correct the errors below and try again.<ul><li>'.implode('</li><li>', $errors).'</li></ul>';
						echo json_encode($return_object);
						exit;
					}
					foreach ($layer_options as $key => $value) {
						$layer_options[$key] = str_replace(Project_Exquisite::urlBase(), 'ULP-DEMO-IMAGES-URL', $layer_options[$key]);
					}
					if ($layer_id !== '0'){
						$_layers=new Project_Exquisite_Layers();
						$_layers->withIds( $layer_id )->withPopupId( $popup_id )->getList( $layer_details );
					}
					if( $_layers->setEntered( array(
						'id'=>( $layer_id==0?null:$layer_id ),
						'popup_id'=>( $popup_id==0?null:$popup_id ),
						'title'=>$layer_options['title'],
						'content'=>$layer_options['content'],
						'zindex'=>$layer_options['index'],
						'details'=>serialize($layer_options),
					) )->set() ){
						$_layers->getEntered($_arrLayer);
						$layer_id=$_arrLayer['id'];
					}
					$layer_options = $_object->filter_lp($layer_options, Project_Exquisite::urlBase());
					$return_object = array();
					$return_object['status'] = 'OK';
					$return_object['title'] = htmlspecialchars($layer_options['title'], ENT_QUOTES);
					if (strlen($layer_options['content']) == 0) $content = 'No content...';
					else if (strlen($layer_options['content']) > 192) $content = substr($layer_options['content'], 0, 180).'...';
					else $content = $layer_options['content'];
					$return_object['content'] = htmlspecialchars($content, ENT_QUOTES);
					$layer_options_html = '';
					foreach ($layer_options as $key => $value) {
						$layer_options_html .= '<input type="hidden" id="ulp_layer_'.$layer_id.'_'.$key.'" name="ulp_layer_'.$layer_id.'_'.$key.'" value="'.htmlspecialchars($value, ENT_QUOTES).'">';
					}
					$return_object['options_html'] = $layer_options_html;
					$return_object['layer_id'] = $layer_id;
					echo json_encode($return_object);
					exit;
					break;
				
				case 'delete-layer':
					if (isset($_POST['ulp_layer_id'])) $layer_id = intval($_POST['ulp_layer_id']);
					else $layer_id = 0;
					$_layers=new Project_Exquisite_Layers();
					$_layers->withIds( $layer_id )->del();
					exit;
					break;

				case 'copy-layer':
					if (isset($_POST['ulp_layer_id'])) $layer_id = intval($_POST['ulp_layer_id']);
					else $layer_id = 0;
					$_layers=new Project_Exquisite_Layers();
					$_layers->withIds( $layer_id )->get( $layer_details );
					if (empty($layer_details)) {
						$return_object = array();
						$return_object['status'] = 'ERROR';
						$return_object['message'] = 'Layer not found!';
						echo json_encode($return_object);
						exit;
					}
					$layer_options = unserialize($layer_details['details']);
					if( empty( $layer_options ) ){
						$layer_options = unserialize( preg_replace('!s:(\d+):"(.*?)";!se', "'s:'.strlen('$2').':\"$2\";'", $layer_details['details'] ) );
					}
					$layer_options = array_merge(Project_Exquisite_Layers::$defaultOptions, $layer_options);
					$layer_options = $_object->filter_lp($layer_options, Project_Exquisite::urlBase());
					$_layers->setEntered( array(
						'popup_id'=>$layer_details['popup_id'],
						'title'=>$layer_details['title'],
						'content'=>$layer_details['content'],
						'zindex'=>$layer_details['zindex'],
						'details'=>$layer_details['details'],
					) )->set();
					$_layers->getEntered( $_arrLayers );
					$layer_id = $_arrLayers['id'];
					$return_object = array();
					$return_object['status'] = 'OK';
					$return_object['title'] = htmlspecialchars($layer_options['title'], ENT_QUOTES);
					if (strlen($layer_options['content']) == 0) $content = 'No content...';
					else if (strlen($layer_options['content']) > 192) $content = substr($layer_options['content'], 0, 180).'...';
					else $content = $layer_options['content'];
					$return_object['content'] = htmlspecialchars($content, ENT_QUOTES);
					$layer_options_html = '';
					foreach ($layer_options as $key => $value) {
						$layer_options_html .= '<input type="hidden" id="ulp_layer_'.$layer_id.'_'.$key.'" name="ulp_layer_'.$layer_id.'_'.$key.'" value="'.htmlspecialchars($value, ENT_QUOTES).'">';
					}
					$return_object['options_html'] = $layer_options_html;
					$return_object['layer_id'] = $layer_id;
					echo json_encode($return_object);
					exit;
					break;

				case 'getresponse-campaigns':
					$api_key = trim(stripslashes($_POST['getresponse_api_key']));
					$campaign_id = trim(stripslashes($_POST['getresponse_campaign_id']));
					$html_object = new stdClass();
					$campaigns = $_object->getresponse_getcampaigns($api_key);
					if (sizeof($campaigns) > 0) {
						$getresponse_options = '';
						foreach ($campaigns as $key => $value) {
							$getresponse_options .= '<option value="'.$key.'"'.($key == $campaign_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $getresponse_options;
					} else {
						$html_object->options = '<option>-- No campaigns found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;
			
				case 'icontact-lists':
					$appid = trim(stripslashes($_POST['icontact_appid']));
					$apiusername = trim(stripslashes($_POST['icontact_apiusername']));
					$apipassword = trim(stripslashes($_POST['icontact_apipassword']));
					$listid = trim(stripslashes($_POST['icontact_listid']));
					$html_object = new stdClass();
					$lists = $_object->icontact_getlists($appid, $apiusername, $apipassword);
					if (sizeof($lists) > 0) {
						$icontact_options = '';
						foreach ($lists as $key => $value) {
							$icontact_options .= '<option value="'.$key.'"'.($key == $listid ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $icontact_options;
					} else {
						$html_object->options = '<option>-- No lists found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;

				case 'madmimi-lists':
					$madmimi_login = trim(stripslashes($_POST['madmimi_login']));
					$madmimi_api_key = trim(stripslashes($_POST['madmimi_api_key']));
					$madmimi_list_id = trim(stripslashes($_POST['madmimi_list_id']));
					$html_object = new stdClass();
					
					$lists = $_object->madmimi_getlists($madmimi_login, $madmimi_api_key);
					if (sizeof($lists) > 0) {
						$madmimi_options = '';
						foreach ($lists as $key => $value) {
							$madmimi_options .= '<option value="'.$key.'"'.($key == $madmimi_list_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $madmimi_options;
					} else {
						$html_object->options = '<option>-- No lists found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;

				case 'benchmark-lists':
					$benchmark_api_key = trim(stripslashes($_POST['benchmark_api_key']));
					$benchmark_list_id = trim(stripslashes($_POST['benchmark_list_id']));
					$html_object = new stdClass();
					
					$lists = $_object->benchmark_getlists($benchmark_api_key);
					if (sizeof($lists) > 0) {
						$benchmark_options = '';
						foreach ($lists as $key => $value) {
							$benchmark_options .= '<option value="'.$key.'"'.($key == $benchmark_list_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $benchmark_options;
					} else {
						$html_object->options = '<option>-- No lists found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;

				case 'activecampaign-lists':
					$activecampaign_url = trim(stripslashes($_POST['activecampaign_url']));
					$activecampaign_api_key = trim(stripslashes($_POST['activecampaign_api_key']));
					$activecampaign_list_id = trim(stripslashes($_POST['activecampaign_list_id']));
					$html_object = new stdClass();
					
					$lists = $_object->activecampaign_getlists($activecampaign_url, $activecampaign_api_key);
					if (sizeof($lists) > 0) {
						$activecampaign_options = '';
						foreach ($lists as $key => $value) {
							$activecampaign_options .= '<option value="'.$key.'"'.($key == $activecampaign_list_id ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $activecampaign_options;
					} else {
						$html_object->options = '<option>-- No lists found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;

				case 'interspire-lists':
					$interspire_url = trim(stripslashes($_POST['interspire_url']));
					$interspire_username = trim(stripslashes($_POST['interspire_username']));
					$interspire_token = trim(stripslashes($_POST['interspire_token']));
					$interspire_listid = trim(stripslashes($_POST['interspire_listid']));
					$html_object = new stdClass();
					
					$lists = $_object->interspire_getlists($interspire_url, $interspire_username, $interspire_token);
					if (sizeof($lists) > 0) {
						$interspire_options = '';
						foreach ($lists as $key => $value) {
							$interspire_options .= '<option value="'.$key.'"'.($key == $interspire_listid ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $interspire_options;
					} else {
						$html_object->options = '<option>-- No lists found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;

				case 'interspire-fields':
					$interspire_url = trim(stripslashes($_POST['interspire_url']));
					$interspire_username = trim(stripslashes($_POST['interspire_username']));
					$interspire_token = trim(stripslashes($_POST['interspire_token']));
					$interspire_listid = trim(stripslashes($_POST['interspire_listid']));
					$interspire_nameid = trim(stripslashes($_POST['interspire_nameid']));
					$html_object = new stdClass();
					
					$fields = $_object->interspire_getfields($interspire_url, $interspire_username, $interspire_token, $interspire_listid);
					if (sizeof($fields) > 0) {
						$interspire_options = '';
						foreach ($fields as $key => $value) {
							$interspire_options .= '<option value="'.$key.'"'.($key == $interspire_nameid ? ' selected="selected"' : '').'>'.htmlspecialchars($value, ENT_QUOTES).'</option>';
						}
						$html_object->options = $interspire_options;
					} else {
						$html_object->options = '<option>-- No fields found --</option>';
					}
					echo json_encode($html_object);
					exit;
					break;
					
				case 'delete-subscriber':
					$id = intval($_GET["id"]);
					$_subscribers=new Project_Exquisite_Subscribers();
					$_subscribers->withIds( $id )->get( $subscriber_details );
					if (intval($subscriber_details["id"]) == 0) {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'subscribers' ) );
						exit;
					}
					if ($_subscribers->withIds( $id )->del() !== false) {
						$_SESSION['ok'] = 'Record successfully <strong>removed</strong>.';
						$this->location( array( 'action'=>'subscribers' ) );
						exit;
					} else {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'subscribers' ) );
						exit;
					}
					exit;
					break;
				
				case 'delete-subscribers':
					$_subscribers=new Project_Exquisite_Subscribers();
					if ($_subscribers->del() !== false) {
						$_SESSION['ok'] = 'All records successfully <strong>removed</strong>.';
						$this->location( array( 'action'=>'subscribers' ) );
						exit;
					} else {
						$_SESSION['error'] = '<strong>Invalid</strong> service call.';
						$this->location( array( 'action'=>'subscribers' ) );
						exit;
					}
					exit;
					break;

				case 'export-subscribers':
					$rows = $icdb->get_rows("SELECT t1.*, t2.title AS popup_title FROM ".$icdb->prefix."subscribers t1 LEFT JOIN ".$icdb->prefix."popups t2 ON t2.id = t1.popup_id WHERE t1.deleted = '0' ORDER BY t1.created DESC");
					if (sizeof($rows) > 0) {
						if (strstr($_SERVER["HTTP_USER_AGENT"],"MSIE")) {
							header("Pragma: public");
							header("Expires: 0");
							header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
							header("Content-type: application-download");
							header("Content-Disposition: attachment; filename=\"emails.csv\"");
							header("Content-Transfer-Encoding: binary");
						} else {
							header("Content-type: application-download");
							header("Content-Disposition: attachment; filename=\"emails.csv\"");
						}
						$separator = $options['csv_separator'];
						if ($separator == 'tab') $separator = "\t";
						echo '"Name"'.$separator.'"E-Mail"'.$separator.'"Phone #"'.$separator.'"Popup"'.$separator.'"Created"'."\r\n";
						foreach ($rows as $row) {
							echo '"'.str_replace('"', "'", $row["name"]).'"'.$separator.'"'.str_replace('"', "'", $row["email"]).'"'.$separator.str_replace('"', "'", $row["phone"]).'"'.$separator.'"'.str_replace('"', "'", $row["popup_title"]).'"'.$separator.'"'.date("Y-m-d H:i:s", $row["created"]).'"'."\r\n";
						}
						exit;
					}
					$this->location( array( 'action'=>'subscribers' ) );
					exit;
					break;

				default:
					break;
			}
		}
	}
	
	public function select(){
		$this->out['elementsName']=empty( $this->params['elementsName'] ) ? 'popupId':$this->params['elementsName'];
		$_popup=new Project_Exquisite_Popups();
		$_popup
			->onlyActive()
			->onlyOwner()
			->getList( $this->out['arrayPopups'] );
	}
	
	public function getcode(){
		if (isset($_GET["id"]) && !empty($_GET["id"])) {
			$_popup=new Project_Exquisite_Popups();
			$_popup->withStrIds( $_GET["id"] )->get( $this->out['popup_details'] );
		}
		if (!empty($this->out['popup_details'])) {
			$this->out['id'] = $this->out['popup_details']['id'];
			$this->out['popup_options'] = unserialize($this->out['popup_details']['options']);
			$this->out['popup_options'] = array_merge(Project_Exquisite_Popups::$defaultOptions, $this->out['popup_options']);
		} else {
			$this->out['str_id'] = $_object->random_string(16);
			$_popup=new Project_Exquisite_Popups();
			$_popup->setEntered( array(
				'str_id'=>$this->out['str_id'],
				'title'=>'',
				'width'=>640,
				'height'=>400,
				'options'=>''
			) )->set();
			$_popup->getEntered( $_arrPopup );
			$this->out['id'] = $_arrPopup['id'];
			$this->out['popup_options'] = Project_Exquisite_Popups::$defaultOptions;
		}
	}
}
?>