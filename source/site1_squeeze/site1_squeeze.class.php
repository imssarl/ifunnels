<?php
class site1_squeeze extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Squeeze', ),
			'actions'=>array(
				array( 'action'=>'customization', 'title'=>'Customization', 'flg_tree'=>1 ),
				array( 'action'=>'manage_squeeze', 'title'=>'Manage landing pages', 'flg_tree'=>1 ),
				array( 'action'=>'manage_split', 'title'=>'Split Testing', 'flg_tree'=>1 ),
				array( 'action'=>'create_split', 'title'=>'Create Split Test', 'flg_tree'=>1 ),
				array( 'action'=>'manage_campaigns', 'title'=>'Manage Campaigns', 'flg_tree'=>1 ),
				array( 'action'=>'request', 'title'=>'Request get', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'create_campaigns', 'title'=>'Create Campaigns', 'flg_tree'=>1 ),
				array( 'action'=>'getlink', 'title'=>'Get Link', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'getjscode', 'title'=>'Get JS code', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'conversion_pixel', 'title'=>'Conversion pixel', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'reporting', 'title'=>'Reporting', 'flg_tree'=>1 ),
				array( 'action'=>'splittest_check', 'title'=>'Split test check', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'status_check', 'title'=>'Status_check', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'example', 'title'=>'Example', 'flg_tree'=>1,'flg_tpl'=>1  ),
				array( 'action'=>'manage', 'title'=>'Manage images'),
				array( 'action'=>'upload', 'title'=>'Upload image'),
				array( 'action'=>'manage_buttons', 'title'=>'Manage buttons'),
				array( 'action'=>'upload_button', 'title'=>'Upload button'),
				array( 'action'=>'manage_sounds', 'title'=>'Manage default sounds'), //+
				array( 'action'=>'upload_sound', 'title'=>'Upload default sound'),//+
				array( 'action'=>'default_sounds', 'title'=>'Squeeze default sounds', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'user_sounds', 'title'=>'Squeeze user sounds', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				
				array( 'action'=>'lps_stats', 'title'=>'Stats on LPS' ),

				array( 'action'=>'param2form', 'title'=>'Get to form', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'widget', 'title'=>'Widget', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'subscribers', 'title'=>'Subscribers', 'flg_tree'=>1 ),
				
				array( 'action'=>'autoresponder_ajax', 'title'=>'Autoresponder AJAX', 'flg_tree'=>2, 'flg_tpl'=>3 ),
				array( 'action'=>'backgrounds', 'title'=>'Backgrounds Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'buttons', 'title'=>'Buttons Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'templates', 'title'=>'Templates Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				// backend
				array( 'action'=>'templates2groups', 'title'=>'Squeeze Templates Access' ),
				array( 'action'=>'template_settings', 'title'=>'Squeeze Templates Settings', 'flg_tpl'=>1 ),
				array( 'action'=>'templates2tags', 'title'=>'Squeeze Templates Tags' ),
				array( 'action'=>'redirect_link', 'title'=>'Squeeze Redirect Link' ),
			),
		);
	}

	public static function install (){
		Core_Sql::setExec('DROP TABLE squeeze_split');
		Core_Sql::setExec('DROP TABLE squeeze_campaigns2split');
		Core_Sql::setExec('CREATE TABLE IF NOT EXISTS `squeeze_split` (
			`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
			`user_id` int(11) unsigned NOT NULL DEFAULT \'0\',
			`flg_closed` int(1) unsigned NOT NULL DEFAULT \'0\',
			`flg_duration` int(1) unsigned NOT NULL DEFAULT \'0\',
			`flg_pause` int(11) NOT NULL DEFAULT \'0\',
			`duration` int(11) unsigned NOT NULL DEFAULT \'0\',
			`title` varchar(255) NOT NULL DEFAULT \' \',
			`url` varchar(255) NOT NULL,
			`edited` int(11) unsigned NOT NULL DEFAULT \'0\',
			`added` int(11) unsigned NOT NULL DEFAULT \'0\',
			PRIMARY KEY (`id`)
		) ENGINE=MyISAM  DEFAULT CHARSET=utf8');


		Core_Sql::setExec('CREATE TABLE IF NOT EXISTS `squeeze_campaigns2split` (
			`split_id` int(11) unsigned NOT NULL DEFAULT \'0\',
			`campaign_id` int(11) unsigned NOT NULL DEFAULT \'0\',
			`flg_winner` int(1) unsigned NOT NULL DEFAULT \'0\',
			`shown` int(11) unsigned NOT NULL DEFAULT \'0\',
			`clicks` int(11) NOT NULL DEFAULT \'0\',
			PRIMARY KEY (`split_id`,`campaign_id`)
		) ENGINE=MyISAM DEFAULT CHARSET=utf8;');
	} 

	public function status_check(){
		
		/*$data=new Project_Conversionpixel();
		//$data->install();
		if(!empty($_GET)){
			if ( $data->setEntered($_GET)->set()){

			}	
		}
		
		//
		//print_r($_GET);*/
	}

	public function widget(){
		header( 'Access-Control-Allow-Origin: *' );
		header( 'Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept' );
		if( isset( $_POST['action'] ) && $_POST['action']=='get' ){
			Project_Users_Stat::updateLpbFull();
			echo json_encode( Core_Sql::getAssoc( 'SELECT SUM(lpb_full_clicks) as c, SUM(lpb_full_s8rs) as s FROM u_users' )[0] );
			exit;
		}
	}

	public function param2form(){
		header( 'Access-Control-Allow-Origin: *' );
		header( 'Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept' );
	}

	public function request(){
		if(empty($_POST['split_id']) && empty($_POST['country_code'])) {
			return false;
		}
		if( !empty($_POST['country_code']) ){
			if( isset( $_SERVER['HTTP_HOST'] ) && $_SERVER['HTTP_HOST'] == 'cnm.local' ){
				$this->out_js=array('+375296691605'); // TESTING CODE
			}elseif( $_POST['type'] == 'old' ){
				$_phones=new Project_Squeeze_Twilio();
				$_phones->onlyOwner()->onlyNumbers()->withCountry( @$_POST['country_code'] )->getList( $this->out_js );
				// берем из списка пользователя
			}elseif( $_POST['type'] == 'new' ){
				$_sms=new Project_Ccs_Twilio_Service();
				$_d=$_sms->_client->account->available_phone_numbers->getList(
					$_POST['country_code'],
					'Mobile',
					array(
						"SmsEnabled" => "true"
					)
				);
				$_phoneNumbers=array();
				foreach($_d->available_phone_numbers as $number) {
					$_phoneNumbers[]=$number->phone_number;
				}
				$_phones=new Project_Squeeze_Twilio();
				$_phones->onlyOwner()->onlyNumbers()->withCountry( @$_POST['country_code'] )->getList( $_oldNumbers );
				$this->out_js=array_merge( (empty($_oldNumbers))?array():$_phoneNumbers, (empty($_oldNumbers))?array():$_oldNumbers );
			}
		}elseif( !empty($_POST['split_id']) ){
			$splittest=new Project_Widget_Adapter_Squeeze_Split();
			if( $_POST['rel']=='winner' ){
				$this->out_js=$splittest->withIds( $_POST['split_id'] )->withWinnerId( $_POST['com_id'] )->request();
			}elseif( $_POST['rel']=='pause' ){
				$this->out_js=$splittest->setPause( $_POST['split_id'] );
			}elseif( $_POST['rel']=='resume' ){
				$this->out_js=$splittest->setResume( $_POST['split_id'] );	
			}
		}
		return true;
	}

	public function backgrounds(){}
	public function buttons(){}

	public function splittest_check(){
		try {
			Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
			$link=new Project_Widget_Adapter_Squeeze_Split_Link();
			if(!empty($_POST['splittest']) && !empty($_POST['campaign_id'])) {
				$link->withSplitIds(array($_POST['splittest']))->withIds(array($_POST['campaign_id']))->updateClick();
				return true;
			}
			$_idSplitTest=Project_Widget_Mutator::decode( $_GET['id'] );
			$splittest=new Project_Widget_Adapter_Squeeze_Split ();
			$splittest->onlyOwner()->onlyOne()->withIds( $_idSplitTest )->getList( $_arrSplit );
			if($_arrSplit['flg_pause'] == 1) {
				$this->out['link']=$_arrSplit['url'];
			}else{
				$_view_all=0;
				foreach ($_arrSplit['arrCom'] as $key => $value) {
					$_view_all += (int)$value['shown'];
				}
				$_koef=array();
				foreach ($_arrSplit['arrCom'] as $key => $value) {
					$_koef[]=(int)(($_view_all - (int)$value['shown']) * 100 / $_view_all);
				}
				$_koef_sum=array_sum ($_koef);
				$r=rand(0, $_koef_sum);
				
				if($r <= $_koef[0]) {
					$link->withSplitIds(array($_arrSplit['arrCom'][0]['split_id']))->withIds(array($_arrSplit['arrCom'][0]['campaign_id']))->updateLink();
					$this->out['link']=$_arrSplit['arrCom'][0]['url'];
					$this->out['splittest']=$_arrSplit['arrCom'][0]['split_id'];
					$this->out['campaign_id']=$_arrSplit['arrCom'][0]['campaign_id'];
				} else {
					$_tmp=$_koef[0];
					for($i=1; $i < count($_koef); $i++) {
						$_tmp += $_koef[$i];
						if($r <= $_tmp) {
							$link->withSplitIds(array($_arrSplit['arrCom'][$i]['split_id']))->withIds(array($_arrSplit['arrCom'][$i]['campaign_id']))->updateLink();
							$this->out['link']=$_arrSplit['arrCom'][$i]['url'];
							$this->out['splittest']=$_arrSplit['arrCom'][$i]['split_id'];
							$this->out['campaign_id']=$_arrSplit['arrCom'][$i]['campaign_id'];
						}
					}
				}
			}
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			Core_Sql::renewalConnectFromCashe();
		}
		header('Location: '.$this->out['link'].'?splittest='.$this->out['splittest'] );
		exit;
	}

	public function conversion_pixel(){
		//try {
			//Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
			$data=new Project_Conversionpixel();
			$data->withSplitIds( $_GET['id'] )->getList($this->out['arrList']);
		//} catch(Exception $e) {
			//Core_Sql::renewalConnectFromCashe();
		//}
	}

	public function manage_split(){
		$this->objStore->getAndClear( $this->out );
		try {
			Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
			$splittest=new Project_Widget_Adapter_Squeeze_Split ();
			$splittest->getCampaign();
			if ( !empty($_GET['split_del_id']) ) {
				if ( $splittest->del( $_GET['split_del_id'] ) ) {
					$this->objStore->set( array( 'msg'=>'Split test deleted successfully' ) );
				} else {
					$this->objStore->set( array( 'error'=>'Split test not deleted' ) );
				}
				$this->location( array( 'action'=>'manage_split') );
			}
			if ( !empty($_GET['split_duplicate_id']) ) {
				if ( $splittest->duplicate($_GET['split_duplicate_id'])) {
					$this->objStore->set( array( 'msg'=>'Split test duplicated successfully' ) );
				} else {
					$this->objStore->set( array( 'error'=>'Split test not duplicated' ) );
				}
				$this->location( array( 'action'=>'manage_split') );
			}
			$splittest->onlyOwner()->withOrder( @$_GET['order'] )->withPaging(array(
					'url'=>@$_GET,
					'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
					'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
				))->getList( $this->out['arrList'] )
				->getPaging( $this->out['arrPg'] )
				->getFilter( $this->out['arrFilter'] );
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			Core_Sql::renewalConnectFromCashe();
		}
		
	}

	public function create_split(){
		try {
			Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
			$splittest=new Project_Widget_Adapter_Squeeze_Split ();
			if (!empty($_POST)) {
				if ( $splittest->setEntered( $_POST['arrSplit'] )->set() ) {
					$this->objStore->toAction( 'manage_split' )->set( array( 'msg'=>'Split test created successfully ' ) );
					$this->location( array( 'action'=>'manage_split') );
				}
				$this->objStore->toAction( 'manage_split' )->set( array( 'error'=>'Split test not created' ) );
			}
			if (!empty($_GET['id'])) {
				$splittest->onlyOwner()->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrSplit'] );
			}
			if(!empty($_GET['company_id'])) {
				$_company_id=explode(',', $_GET['company_id']);
				foreach ($_company_id as $key => $value) {
					$this->out['arrSplit']['arrCom'][]=array('id' => $value);	
				}
			}
			$splittest
				->getEntered( $this->out['arrSplit'] )
				->getErrors( $this->out['arrErr'] );
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			print_r($e);
			Core_Sql::renewalConnectFromCashe();
		}
		$company=new Project_Squeeze();
		$company
			->onlyOwner()
			->getList( $this->out['arrSplit']['compains'] );
		foreach( $this->out['arrSplit']['compains'] as &$_item ){
			if( !empty( $_item['url'] ) 
				&& !is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) 
				&& !is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' )
			){
				if( $_limit == 0 ){
					continue;
				}else{
					$_limit--;
				}
				$_getReturn=json_decode( Project_Squeeze::getImageFromLink( $_item['url'] ), true );
				if( isset( $_getReturn['return'] ) && $_getReturn['return']!=0 ){
					$_limit++; // если ошибка не считаем эту картинку
				}
				rename( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg", Zend_Registry::get('config')->path->absolute->user_files.'squeeze/screenshots/'.md5( $_item['url'] ).".jpg" );
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}elseif( is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) ){
				rename( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg", Zend_Registry::get('config')->path->absolute->user_files.'squeeze/screenshots/'.md5( $_item['url'] ).".jpg" );
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots/'.md5( $_item['url'] ).".jpg";
			}elseif( is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) ){
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}
		}
	}

	public function getlink(){
		switch ( $_GET['type'] ) {
			case 'splittest': 
				$id=$_GET['id'];
				$this->out['showtext']=Project_Widget_Adapter_Squeeze_Split::getCode( $_GET['id'] );
				$this->out['md5']=Project_Widget_Mutator::encode( $id );
			break;
			case 'company': 
				$this->out['showtext']=Project_Widget_Adapter_Squeeze_Campaign::getCode( $_GET['id'] );
			break;
		}
	}

	public function getjscode(){
		$this->out['split_id']=$_GET['id'];
	}

	public function manage_campaigns(){
		$company=new Project_Widget_Adapter_Squeeze_Campaign ();
		$this->objStore->getAndClear( $this->out );
		if ( !empty($_GET['company_del_id']) ) {
			if ( $company->withIds( $_GET['company_del_id'] )->onlyOwner()->del() ) {
				$this->objStore->set( array( 'msg'=>'Company deleted successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company not  deleted' ) );
			}
			$this->location( array( 'action'=>'manage') );
		}
		if ( !empty($_GET['company_duplicate_id']) ) {
			if ( $company->duplicate( $_GET['company_duplicate_id'] ) ) {
				$this->objStore->set( array( 'msg'=>'Company duplicated successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company not duplicated' ) );
			}
			$this->location( array( 'action'=>'manage') );
		}
		$company->onlyOwner()->withOrder( @$_GET['order'] )->setFilter( @$_GET['arrType'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function create_campaigns(){
		$company=new Project_Widget_Adapter_Squeeze_Campaign ();
		if (!empty($_POST)) {
			if ( $company->setEntered( $_POST['arrCom'] )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'Compaign created successfully ' ) );
				$this->location( array( 'action'=>'manage') );
			}
			$this->objStore->toAction( 'manage_campaigns' )->set( array( 'error'=>'Compaign not created' ) );
			return;
		}
		$company
			->getEntered( $this->out['arrCom'] )
			->getErrors( $this->out['arrErrors'] );
		if (!empty($_GET)) {
			$company->onlyOwner()->onlyOne()->withIds( $_GET['id'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrCom'] );
		}
	}
	
	public function templates(){
		$_squeeze=new Project_Squeeze();
		$_t2g=new Project_Squeeze_Templates();
		$_arrGroupsids=array();
		$_group=new Core_Acs_Groups();
		if( Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_group->getList( $_arrCurrentGroups );
		}else{
			$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		}
		foreach( $_arrCurrentGroups as $_i ){
			$this->out['arrGroupsids'][$_i['id']]=$_i['title'];
		}
		if( Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_t2g->getList( $_selectedTemplatesIds );
		}else{
			$_t2g->withGroupIds( array_keys( $this->out['arrGroupsids'] ) )->getList( $_selectedTemplatesIds );
		}
		if( !empty( $_selectedTemplatesIds ) ){
			$_squeezeT2G=array();
			foreach( $_selectedTemplatesIds as $_t2g_ids ){
				if( !isset( $_squeezeT2G[$_t2g_ids['squeeze_id']] ) ){
					$_squeezeT2G[$_t2g_ids['squeeze_id']]=array();
				}
				$_squeezeT2G[$_t2g_ids['squeeze_id']][]=$_t2g_ids['group_id'];
			}
			$_squeeze->withIds( array_keys( $_squeezeT2G ) )->onlyTemplates()->getList( $_arrTemplates );
			$this->out['arrTemplates']=array();
			foreach( $_arrTemplates as $_squeezeData ){
				foreach( $_squeezeT2G[$_squeezeData['id']] as $_groupId ){
					if( !isset( $this->out['arrTemplates'][ $_groupId ] ) ){
						$this->out['arrTemplates'][$_groupId]=array( 'name'=>$this->out['arrGroupsids'][$_groupId], 'node'=>array() );
					}
					$this->out['arrTemplates'][$_groupId]['node'][]=$_squeezeData;
				}
			}
		}else{
			$this->out['arrTemplates']=null;
		}
		$this->out['templates_link']=Zend_Registry::get('config')->path->html->user_files.'squeeze'.DIRECTORY_SEPARATOR.'templates'.DIRECTORY_SEPARATOR;
	}

	public function autoresponder_ajax(){
		if( isset( $_POST['data'] ) && !empty( $_POST['data'] ) ){
			echo Project_Squeeze::editFormValues( $_POST['data'] );
		}
		exit;
	}

	public function upload(){
		$this->objStore->getAndClear( $this->out );
		if(!empty($_FILES['image']['tmp_name'])){
			$_ext=Core_Files::getExtension( $_FILES['image']['name'] );
			if( in_array( $_ext, array("gif","jpg", "png", "jpeg") ) ){
				$this->objStore->toAction( 'manage' )->set( array( 'upload'=>Project_Squeeze::upload($_FILES['image']) ) );
				$this->location( array( 'action'=>'manage' ) );
			}elseif( $_ext == 'zip' ){
				copy( $_FILES['image']['tmp_name'], Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.$_FILES['image']['name']);
				Core_Zip::getInstance()
					->setDir( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.'upload'.DIRECTORY_SEPARATOR )
					->extractZip( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.$_FILES['image']['name'] );
				Core_Files::dirScan( $arrRes, Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.'upload'.DIRECTORY_SEPARATOR );
				foreach( $arrRes as $_pathName=>$_path ){
					if( strpos( $_pathName, '__MACOSX' ) !== false ){
						break;
					}
					foreach( $_path as $_file ){
						if( is_file( $_pathName.DIRECTORY_SEPARATOR.$_file ) 
							&& filesize( $_pathName.DIRECTORY_SEPARATOR.$_file )>0
							&& in_array( Core_Files::getExtension( $_file ), array("gif","jpg", "png", "jpeg") )
						){
							Project_Squeeze::upload(
								array(
									'tmp_name'=>$_pathName.DIRECTORY_SEPARATOR.$_file,
									'name'=>$_file
								)
							);
						}
					}
				}
				Core_Files::rmDir( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.'upload' );
				Core_Files::rmFile( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'backgrounds'.DIRECTORY_SEPARATOR.$_FILES['image']['name'] );
				$this->location( array( 'action'=>'manage' ) );
			}
		}
	}

	public function templates2tags(){
		$_squeeze=new Project_Squeeze();
		if(isset($_POST['update']) && isset($_POST['arrTags']) && !empty($_POST['arrTags'])  ){
			foreach( $_POST['arrTags'] as $_id=>$_tags ){
				if( $_tags['old'] != $_tags['new'] ){
					$_squeeze->withIds( $_id )->onlyOne()->getList( $_update );
					$_update['settings']['template_tags']=$_tags['new'];
					$_squeeze->setEntered( $_update )->set();
				}
			}
			$this->location();
		}
		$_squeeze->onlyTemplates()->getList( $this->out['arrTemplates'] );
		$this->out['templates_link']=Zend_Registry::get('config')->path->html->user_files.'squeeze'.DIRECTORY_SEPARATOR.'templates'.DIRECTORY_SEPARATOR;
	}

	public function template_settings(){
		$_squeeze=new Project_Squeeze();
		if(!empty($_POST)){
			$_squeeze->withIds( $_GET['id'] )->onlyOne()->getList( $_arrTemplate );
			if( $_arrTemplate['settings']['template_description'] != $_POST['settings']['template_description'] ){
				$_arrTemplate['settings']['template_description'] = $_POST['settings']['template_description'];
			}
			unset( $_POST['settings']['template_description'] );
			$_arrTemplate['tpl_settings']=$_POST['settings'];
			$_squeeze->setEntered( $_arrTemplate )->set();
			$this->out['save_action']=true;
		}
		if(!empty($_GET['id'])){
			$_squeeze
				->onlyTemplates()
				->onlyOne()
				->withIds( $_GET['id'] )
				->getList( $this->out['template'] );
		}
	}

	public function templates2groups(){
		if ( isset( $_GET['update_image'] ) && !empty( $_GET['update_image'] ) ) {
			$_link=base64_decode( $_GET['update_image'] );
			
			$_squeeze=new Project_Squeeze();
			$_squeeze->withIds($_GET['id'])->onlyOne()->getList( $_arrData );
			$_arrData['settings']['template_reload_file']='true';
			$_arrData['settings']['template_hash']=md5($_link);
			$_arrData['settings']['template_file_path']='';
			$_squeeze->setEntered( $_arrData )->set();
			
			$_linkContent=@file_get_contents( $_link );
			if( $_linkContent === false || empty( $_linkContent ) ){
				$this->location( array( 'msg'=>'empty content' ) );
			}
			$URL2PNG_APIKEY="PAA11E0D3718E90";
			$URL2PNG_SECRET="S_4ED60B58B10F8";
			$options['force']='false';   # [false,always,timestamp] Default: false
			$options['fullpage']='false';   # [true,false] Default: false
			$options['thumbnail_max_width']='false';   # scaled image width in pixels; Default no-scaling.
			$options['viewport']="1280x1024";  # Max 5000x5000; Default 1280x1024
			$options['url']=urlencode( $_link ); # urlencode request target
			foreach($options as $key => $value){ $_parts[]="$key=$value"; } # create the query string based on the options
			$query_string=implode("&", $_parts); # create a token from the ENTIRE query string
			copy( "https://api.url2png.com/v6/".$URL2PNG_APIKEY."/".md5($query_string.$URL2PNG_SECRET)."/png/?".$query_string, Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'templates'.DIRECTORY_SEPARATOR.md5($_link).".jpg" );
		}
		if ( !empty( $_POST['change_group'] ) ) {
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrG'] );
		$_t2g=new Project_Squeeze_Templates();
		if(!empty($_GET['group_id'])){
			$_t2g->withGroupIds( $_GET['group_id'] )->getList( $_selectedTemplates );
		}
		$this->out['selectedTemplates']=array();
		foreach( $_selectedTemplates as $_template ){
			$this->out['selectedTemplates'][]=$_template['squeeze_id'];
		}
		if(isset($_POST['save'])){
			$_arrData=array();
			$_t2g->withGroupIds( $_POST['arrR']['group_id'] )->del();
			foreach( $_POST['arrT'] as $_t ){
				$_arrData[]=array(
					'squeeze_id'=> $_t, 
					'group_id'=> $_POST['arrR']['group_id']
				);
			}
			$_t2g->setEntered( $_arrData )->set();
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_squeeze=new Project_Squeeze();
		$_squeeze->onlyTemplates()->getList( $this->out['arrTemplates'] );
		$this->out['templates_link']=Zend_Registry::get('config')->path->html->user_files.'squeeze'.DIRECTORY_SEPARATOR.'templates'.DIRECTORY_SEPARATOR;
	}

	public function upload_button(){
		$this->objStore->getAndClear( $this->out );
		if(!empty($_FILES['image']['tmp_name'])){
			$this->objStore->toAction( 'manage_buttons' )->set( array( 'upload'=>Project_Squeeze::upload($_FILES['image'], $_POST['flg_type'], $_POST['tags'] ) ) );
			$this->location( array( 'action'=>'manage_buttons' ) );
		}
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		if(!empty($_GET['del'])){
			$this->objStore->set( array( 'delete'=>Project_Squeeze::delete($_GET['del']) ) );
			$this->location( array( 'action'=>'manage' ) );
		}
		$this->out['arrList']=Project_Squeeze::getBackgrounds();
	}

	public function manage_buttons(){
		$this->objStore->getAndClear( $this->out );
		$_tags=new Project_Squeeze_Buttontags();
		if( isset( $_POST['arrData'] ) ){
			$_saveData=array();
			foreach( $_POST['arrData'] as $_hash=>$_data ){
				if( !empty( $_data ) ){
					$_tags->setEntered(array(
						'id'=>$_hash,
						'tags'=>$_data
					))->set();
				}
			}
			
		}
		$this->out['arrList']=Project_Squeeze::getAllButtons();
	}

	public function upload_sound(){
		$this->objStore->getAndClear( $this->out );
		if( ( !empty($_FILES['sound']['tmp_name']) || !empty( $_POST['arrData']['id'] ) ) && !empty($_POST['arrData']) ){
			if( Project_Squeeze::uploadSound( $_FILES['sound'], $_POST['arrData'] ) ){
				$this->objStore->toAction( 'manage_sounds' )->set( array( 'upload'=> true ) );
				$this->location( array( 'action'=>'manage_sounds' ) );
			}
		}
		$category=new Core_Category( 'Squeeze' );
		$category->getTree( $this->out['arrCategoryTree'] );
		if( !empty($_GET['id']) ){
			$this->out['file']=Project_Squeeze::getDefaultSound( $_GET['id'] );
			self::selectDefaultMultilavelCategories( $this->out['arrCategoryTree'], $this->out['file']['category_id'] );
		}
	}

	public static function selectDefaultMultilavelCategories( &$category, $id ){
		foreach( $category as &$_e ){
			if( isset( $_e['id'] ) ){
				if( $_e['id']== $id ){
					$_e['selected']=true;
				}
				$oldNode=$_e['node'];
				self::selectDefaultMultilavelCategories( $_e['node'], $id );
				if( $_e['node'] !== $oldNode ){
					$_e['selected']=true;
				}
			}
		}
		return false;
	}

	public function manage_sounds(){
		$this->objStore->getAndClear( $this->out );
		if(!empty($_GET['del'])){
			$this->objStore->set( array( 'delete'=>Project_Squeeze::deleteDefaultSounds( $_GET['del'] ) ) );
			$this->location( array( 'action'=>'manage_sounds' ) );
		}
		$this->out['arrList']=Project_Squeeze::getDefaultSounds();
		$category=new Core_Category( 'Squeeze' );
		$category->getList( $arrCategories );
		$_arrCategories=array();
		foreach( $arrCategories as $_e ){
			$_arrCategories[$_e['id']]=$_e;
		}
		$this->out['arrCategoryTree']=$_arrCategories;
	}

	public static function getFilesContainingCategories( &$categories, $files){
		foreach( $categories as $_i=>&$_e ){
			if( isset( $_e['node'] ) && !empty( $_e['node'] ) ){
				self::getFilesContainingCategories( $_e['node'], $files );
			}elseif( empty( $_e['node'] ) ){
				$_flgHave=false;
				foreach( $files as $_file ){
					if( $_file['category_id']== $_e['id'] ){
						$_flgHave=true;
					}
				}
				if( !$_flgHave ){
					unset( $categories[$_i] );
				}
			}
		}
		foreach( $categories as $_i=>&$_e ){
			if( empty( $_e['node'] ) ){
				$_flgHave=false;
				foreach( $files as $_file ){
					if( $_file['category_id']== $_e['id'] ){
						$_flgHave=true;
					}
				}
				if( !$_flgHave ){
					unset( $categories[$_i] );
				}
			}
		}
	}

	public function default_sounds(){
		$this->out['arrList']=Project_Squeeze::getDefaultSounds();
		$category=new Core_Category( 'Squeeze' );
		$category->getTree( $this->out['arrCategoryTree'] );
		self::getFilesContainingCategories( $this->out['arrCategoryTree'], $this->out['arrList'] );
	}

	public function lps_stats(){
		$this->out = Core_Sql::getRecord( 'SELECT SUM(lpb_full_clicks) as total_clicks, SUM(lpb_full_views) as total_visits FROM u_users' );
		$this->out['all_lps_count']=Core_Sql::getCell('SELECT COUNT(*) as lps_count  FROM squeeze_campaigns');
	}


	public function user_sounds(){
		$_file=new Project_Files_Squeeze( 'squeeze_user_sounds' );
		if ( !empty( $_FILES['name'] ) || !empty( $_POST['file']['id'] ) ) {
			if ( $_file->setEntered( $_POST['file'] )->setEnteredFile( $_FILES['name'] )->set()){
				$this->objStore->set( array( 'msg'=>empty($_POST['file']['id'])?'saved':'edited' ) );
				$this->location( Core_Module_Router::$uriFull );
			}
			$_file
				->getErrors($this->out['arrErrors'])
				->getEntered( $this->out['file'] );
		}
		if ( !empty( $_GET['id'] ) ) {
			$_file->withIds( $_GET['id'] )->get( $this->out['file'] );
		}
		$_file
			->onlyOwner()
			->withOrder( @$_GET['order'] )
			->withPaging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function subscribers(){
		$_subscribers=new Project_Squeeze_Subscribers(Core_Users::$info['id']);
		if(!empty($_GET['action']) && $_GET['action']='delete'){
			$this->objStore->set( array( 'delete'=>$_subscribers->withIds($_GET['id'])->del() ) );
			$this->location();
		}
		if( !empty( $_COOKIE['filter'] ) ) {
			$this->out['sFilter'] = json_decode( $_COOKIE['filter'], true );
		} 
		if( !empty( $_GET['arrFilter']['lead'] ) ){
			$_subscribers->withSqueezeId( $_GET['arrFilter']['lead'] );
		}
		if( !empty( $_GET['arrFilter']['tags'] ) ){
			$_subscribers->withTags( $_GET['arrFilter']['tags'] );
		}
		if( !empty( $_GET['email'] ) ){
			$_subscribers->withEmail( $_GET['email'] );
		}
		$_subscribers
			->onlyOwner()
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		$_arIds=array();
		foreach( $this->out['arrList'] as &$cp ){
			foreach( $cp['squeeze_events'] as &$_moEvents ){
				if( isset( $_moEvents['lead_id'] ) ){
					$cp['mo_ids'][$_moEvents['added']]=$_moEvents['lead_id'];
					foreach( $_moEvents as $_paramName=>&$_paramData ){
						$_addArray=$_addDetails=array();$_mo2arr='';
						if( strpos( $_paramName, 'mo2ar_message_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_message_' ) ).'_'.$_moEvents['added'];
							$_addArray['message']=unserialize( base64_decode( $_paramData ) );
							$_addArray['added']=$_moEvents['added'];
						}
						if( strpos( $_paramName, 'mo2ar_ansver_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_ansver_' ) ).'_'.$_moEvents['added'];
							$_addArray['ansver']=base64_decode( $_paramData );
						}
						if( strpos( $_paramName, 'mo2ar_request_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_request_' ) ).'_'.$_moEvents['added'];
							$_addArray['request']=base64_decode( $_paramData );
							$_request=unserialize( base64_decode( $_paramData ) );
							if( isset( $_request['_'] ) ){
								$_addArray['added']=round( $_request['_']/1000 );
							}
						}
						if( strpos( $_paramName, 'mo2ar_hidden_' ) === 0 ){
							$_mo2arr=substr( $_paramName, strlen( 'mo2ar_hidden_' ) ).'_'.$_moEvents['added'];
							foreach( unserialize( base64_decode( $_paramData ) ) as $_name=>$_value ){
								$_addDetails['message']=htmlspecialchars( $_name ).':'.htmlspecialchars( $_value );
								$_addDetails['added']=$_moEvents['added'];
							}
						}
						if( !empty( $_addArray ) && !empty( $_mo2arr ) ){
							$_mo2arArr=explode( '_', $_mo2arr );
							if( $_mo2arArr[0] == $_moEvents['lead_id'] ){
								$_addArray['arId']=$arIds[$_mo2arArr[1]]=$_mo2arArr[1];
							}
							if( isset( $cp['messages'][$_mo2arr] ) ){
								$cp['messages'][$_mo2arr]=$_addArray+$cp['messages'][$_mo2arr];
							}else{
								$cp['messages'][$_mo2arr]=$_addArray;
							}
						}
						if( !empty( $_addDetails ) && !empty( $_mo2arr ) ){
							$_mo2arArr=explode( '_', $_mo2arr );
							if( $_mo2arArr[0] == $_moEvents['lead_id'] ){
								$_addDetails['arId']=$arIds[$_mo2arArr[1]]=$_mo2arArr[1];
							}
							if( isset( $cp['details'][$_mo2arr] ) ){
								$cp['details'][$_mo2arr]=$_addDetails+$cp['messages'][$_mo2arr];
							}else{
								$cp['details'][$_mo2arr]=$_addDetails;
							}
						}
					}
				}
				if( isset( $_moEvents['message'] ) ){
					$cp['requests'][$_moEvents['added']]=$_moEvents['message'];
				}
			}

			$cp['mo_ids'] = array_unique($cp['mo_ids']);
		}
		$company=new Project_Mooptin();
		$company->onlyOwner()->getList($arrData);
		foreach( $arrData as $mocp ){
			$this->out['mo_campaigns'][$mocp['id']]=array('name'=>$mocp['name'],'tag'=>$mocp['tags']);
		}
		$this->out['mo_campaigns']=array_filter( $this->out['mo_campaigns'] );
		$this->out['a8rData']=array();
		if( !empty( $arIds ) ){
			$a8r=new Project_Mooptin_Autoresponders();
			$a8r->onlyOwner()->withIds(array_keys($arIds))->getList($arrA8r);
			foreach( $arrA8r as $_a8r ){
				$this->out['a8rData'][$_a8r['id']]=$_a8r['name'];
			}
		}
		if( !empty( $_GET['export'] ) && !empty( $_GET['lead'] ) ){
			$content = '';
			foreach ($this->out['rows'] as $key => $row){
				$_content .= (empty($row['name']) ? '-' : $row['name'] ) . ';' . $row['email'] . ';' . $row['ip'] . ';' . date( 'Y-m-d', $row['added'] )  . PHP_EOL;
			}
			ob_end_clean();
			header( "Content-type: application/octet-stream" );
			header( "Content-disposition: attachment; filename=contact-list".date('Y-m-d').".csv");
			echo $_content;
			die();
		}
	}
	
	public function edit_group(){
		$this->objStore->getAndClear( $this->out );
		if ( empty( $this->params['sysname'] )||empty( $this->params['prefix'] ) ) {
			return false;
		}
		$_file=new Project_Files_Squeeze( $this->params['sysname'] );
		if ( !empty( $_FILES['name'] ) || !empty( $_POST['file']['id'] ) ) {
			if ( $_file->setEntered( $_POST['file'] )->setEnteredFile( $_FILES['name'] )->set()){
				$this->objStore->set( array( 'msg'=>empty($_POST['file']['id'])?'saved':'edited' ) );
				$this->location( Core_Module_Router::$uriFull );
			}
			$_file
				->getErrors($this->out['arrErrors'])
				->getEntered( $this->out['file'] );
		}
		if ( !empty( $_GET['id'] ) ) {
			$_file->withIds( $_GET['id'] )->get( $this->out['file'] );
		}
		if ( !empty( $_GET['delete'] ) ) {
			$_file->onlyOwner()->withIds( $_GET['delete'] )->utilization();
		}
		$_file
			->withOrder( @$_GET['order'] )
			->withPaging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function reporting(){
		$this->objStore->getAndClear( $this->out );
		$_squeeze=new Project_Squeeze();
		if(empty($_GET['arrFilter']['time'])) {
			$_GET['arrFilter']['time']=4;
		}
		if(!empty($_GET['id'])){
			$_squeeze
				->withReportById($_GET['id'])
				->withListFromTracker()
				->withOrder('c.crt--dn')
				->withFilter(@$_GET['arrFilter'])
				->getList($this->out['arrList']);
		}else{
			$_squeeze
				->withListFromTracker()
				->withOrder('c.crt--dn')
				->withFilter(@$_GET['arrFilter'])
				->getList($this->out['arrList'])
				->getFilter( $this->out['arrFilter'] );

			$clicks=0; $visitors=0;
			foreach ($this->out['arrList'] as $key => $value) {
				$clicks += $value['clicks'];
				$visitors += $value['visitors'];
			}
			$this->out['statistic']=array(
				'clicks' => $clicks,
				'visitors' => $visitors
			);
		}
		$this->out['arrDate']=$this->out['arrCountryList']=array();
		foreach( $this->out['arrList'] as $_page ){
			// блок графика
			if( isset( $_page['arr_visitors']['date'] ) ){
				foreach( $_page['arr_visitors']['date'] as $_date=>$_count ){
					if( isset( $this->out['arrDate'][$_date] ) ){
						$this->out['arrDate'][$_date]['view']+=$_count;
					}else{
						$this->out['arrDate'][$_date]=array(
							'date'=>$_date,
							'click'=>0,
							'view'=>$_count 
						);
					}
				}
			}
			if( isset( $_page['arr_clicks']['date'] ) ){
				foreach( $_page['arr_clicks']['date'] as $_date=>$_count ){
					if( isset( $this->out['arrDate'][$_date] ) ){
						$this->out['arrDate'][$_date]['click']+=$_count;
					}else{
						$this->out['arrDate'][$_date]=array(
							'date'=>$_date,
							'click'=>$_count ,
							'view'=>0
						);
					}
				}
			}
			// блок стран
			if( isset( $_page['arr_visitors']['countries'] ) ){
				foreach( $_page['arr_visitors']['countries'] as $_date=>$_count ){
					if( isset( $this->out['arrCountryList'][$_date] ) ){
						$this->out['arrCountryList'][$_date]['view']+=$_count;
					}else{
						$this->out['arrCountryList'][$_date]=array(
							'country'=>$_date,
							'click'=> 0,
							'view'=>$_count
						);
					}
				}
			}
			if( isset( $_page['arr_clicks']['countries'] ) ){
				foreach( $_page['arr_clicks']['countries'] as $_date=>$_count ){
					if( isset( $this->out['arrCountryList'][$_date] ) ){
						$this->out['arrCountryList'][$_date]['click']+=$_count;
					}else{
						$this->out['arrCountryList'][$_date]=array(
							'country'=>$_date,
							'click'=>$_count ,
							'view'=>0
						);
					}
				}
			}
			// utm
			if( isset( $_page['utm_log'] ) ){
				foreach( $_page['utm_log'] as $_utmLogData ){
					if( !in_array( $_utmLogData['utm_source'], $this->out['arrUtmSourceFilter'] ) && $_utmLogData['utm_source']!='' )
						$this->out['arrUtmSourceFilter'][]=$_utmLogData['utm_source'];
					if( !in_array( $_utmLogData['utm_medium'], $this->out['arrUtmMediumFilter'] ) && $_utmLogData['utm_medium']!='' )
						$this->out['arrUtmMediumFilter'][]=$_utmLogData['utm_medium'];
					if( !in_array( $_utmLogData['utm_campaign'], $this->out['arrUtmCampaignFilter'] ) && $_utmLogData['utm_campaign']!='' )
						$this->out['arrUtmCampaignFilter'][]=$_utmLogData['utm_campaign'];
					if( isset( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['utm_source'] ) && !empty($_GET['arrFilter']['utm_source']) && $_GET['arrFilter']['utm_source']!=$_utmLogData['utm_source'] ){
						continue;
					}
					if( isset( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['utm_medium'] ) &&  !empty($_GET['arrFilter']['utm_medium']) && $_GET['arrFilter']['utm_medium']!=$_utmLogData['utm_medium'] ){
						continue;
					}
					if( isset( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['utm_campaign'] ) &&  !empty($_GET['arrFilter']['utm_campaign']) && $_GET['arrFilter']['utm_campaign']!=$_utmLogData['utm_campaign'] ){
						continue;
					}
					$flgUpdatePrev=false;
					foreach( $this->out['arrUtmList'] as &$_utmUpdate ){
						if( $_utmUpdate['utm_source'] == $_utmLogData['utm_source']
							&& $_utmUpdate['utm_medium'] == $_utmLogData['utm_medium']
							&& $_utmUpdate['utm_term'] == $_utmLogData['utm_term']
							&& $_utmUpdate['utm_content'] == $_utmLogData['utm_content']
							&& $_utmUpdate['utm_campaign'] == $_utmLogData['utm_campaign'] ){
								$flgUpdatePrev=true;
								$_utmUpdate['visitors']+=$_utmLogData['visitors'];
								$_utmUpdate['clicks']+=$_utmLogData['clicks'];
								continue;
							}
					}
					if( !$flgUpdatePrev ){
						$this->out['arrUtmList'][]=$_utmLogData;
					}
				}
			}
		}
		foreach( $this->out['arrList'] as &$_adata ){
			$_adata['rate']=$_adata['clicks']/$_adata['visitors']*100;
		}
		$_func_mv='cmp_view_up';
		if($_GET['order_mv'] == 'view--dn') $_func_mv='cmp_view_dn';
		if($_GET['order_mv'] == 'view--up') $_func_mv='cmp_view_up';
		if($_GET['order_mv'] == 'click--up') $_func_mv='cmp_click_up';
		if($_GET['order_mv'] == 'click--dn') $_func_mv='cmp_click_dn';
		if($_GET['order_mv'] == 'rate--up') $_func_mv='cmp_rate_up';
		if($_GET['order_mv'] == 'rate--dn') $_func_mv='cmp_rate_dn';	
		if( count( $this->out['arrList'] ) > 1 ){
			function cmp_view_up($a, $b){
				return $a["visitors"] <  $b["visitors"];
			}
			function cmp_view_dn($a, $b){
				return $a["visitors"] >  $b["visitors"];
			}
			function cmp_click_up($a, $b){
				return $a["clicks"] <  $b["clicks"];
			}
			function cmp_click_dn($a, $b){
				return $a["clicks"] >  $b["clicks"];
			}
			function cmp_rate_up($a, $b){
				return $a["rate"] <  $b["rate"];
			}
			function cmp_rate_dn($a, $b){
				return $a["rate"] >  $b["rate"];
			}
			uasort($this->out['arrList'], $_func_mv);
		}
		foreach( $this->out['arrCountryList'] as &$_cdata ){
			$_cdata['rate']=$_cdata['click']/$_cdata['view']*100;
		}
		$_func='up_rate';
		if($_GET['order'] == 'view--up') $_func='up_view';
		if($_GET['order'] == 'view--dn') $_func='dn_view';
		if($_GET['order'] == 'click--up') $_func='up_click';
		if($_GET['order'] == 'click--dn') $_func='dn_click';	
		if($_GET['order'] == 'rate--up') $_func='up_rate';
		if($_GET['order'] == 'rate--dn') $_func='dn_rate';
		if($_GET['order'] == 'country--up') $_func='up_country';
		if($_GET['order'] == 'country--dn') $_func='dn_country';
		if( count( $this->out['arrCountryList'] ) > 1 ){
			function up_rate($a, $b){
				return $a["rate"] <  $b["rate"];
			}
			function dn_rate($a, $b){
				return $a["rate"] >  $b["rate"];
			}
			function up_view($a, $b){
				return $a["view"] <  $b["view"];
			}
			function dn_view($a, $b){
				return $a["view"] >  $b["view"];
			}
			function up_click($a, $b){
				return $a["click"] <  $b["click"];
			}
			function dn_click($a, $b){
				return $a["click"] >  $b["click"];
			}
			function up_country($a, $b){
				return $a["country"] <  $b["country"];
			}
			function dn_country($a, $b){
				return $a["country"] >  $b["country"];
			}
			uasort($this->out['arrCountryList'], $_func);
		}

		if(!empty($_GET)) {
			$_get=$_GET;
			//$id=$_GET['id'];
			unSet($_get['order']);
			unSet($_get['order_mv']);
			unSet($_get['id']);
			$this->out['sortParam']=http_build_query($_get);
			//$_GET['id']=$id;
		}
		$this->out['strDate']='[';
		foreach( $this->out['arrDate'] as $_data ){
			$this->out['strDate'].='{y:\''.$_data['date'].'\',a:'.$_data['click'].',b:'.$_data['view'].'},';
		}
		$this->out['strDate'].=']';
		function cmp_view_up_2($a, $b){
			return $a["visitors"] < $b["visitors"];
		}
		uasort($this->out['arrUtmList'], 'cmp_view_up_2');
	}

	public function manage_squeeze(){
		$this->objStore->getAndClear( $this->out );
		$_squeeze=new Project_Squeeze();
		if( isset( $_GET['duplicate'] ) && !empty( $_GET['duplicate'] ) ){
			$_squeeze->withIds( $_GET['duplicate'] )->onlyOwner()->onlyOne()->duplicate_squeeze();
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['reset_stats'] ) && !empty( $_GET['reset_stats'] ) ){
			$_squeeze->withIds( $_GET['reset_stats'] )->resetStats();
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['delete'] ) && !empty( $_GET['delete'] ) ){
			if( !$_squeeze->withIds( $_GET['delete'] )->onlyOwner()->onlyOne()->del_squeeze() ){
				$this->objStore->set(array( 'error'=>'delete' ));
			}else{
				$this->objStore->set(array( 'msg'=>'success' ));
			}
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['download'] ) && !empty( $_GET['download'] ) ){
			if( !$_squeeze->withIds( $_GET['download'] )->onlyOwner()->onlyOne()->getList( $_arrData ) ){
				$this->objStore->set(array( 'error'=>'download' ));
			}else{
				$_oldPub=$_arrData['settings']['publishing_options'];
				$_arrData['settings']['publishing_options']='download';
				$_squeeze->setEntered( $_arrData )->generate();
				$_link=Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR.time().'.zip';
				copy(
					str_replace(
						Zend_Registry::get( 'config' )->domain->url.Zend_Registry::get('config')->path->html->user_temp.Core_Users::$info['id'].'/', 
						Zend_Registry::get('config')->path->absolute->user_temp.Core_Users::$info['id'].DIRECTORY_SEPARATOR,
						$_squeeze->getGeneratedLink() 
					),
					$_link
				);
				$_arrData['settings']['publishing_options']=$_oldPub;
				$_squeeze->setEntered( $_arrData )->generate(); // TODO 2016.07.31 добавить только сохранение с базу, без заливки или скачивания
				Core_Files::download( $_link );
				die;
			}
		}
		if( isset( $_GET['hosting'] ) && !empty( $_GET['hosting'] ) ){
			$_squeeze->withIds( $_GET['hosting'] )->onlyOwner()->onlyOne()->hosting_squeeze();
			unset( $_GET );
			$this->location();
		}
		if( isset( $_GET['hosting_nossl'] ) && !empty( $_GET['hosting_nossl'] ) ){
			$_squeeze->withIds( $_GET['hosting_nossl'] )->onlyOwner()->onlyOne()->hosting_squeeze('nossl');
			unset( $_GET );
			$this->location();
		}
		if( @$_GET['where'] !== false && $_GET['where']=='flg_template-1' ){
			$_squeeze->onlyTemplates();
		}
		if(isset($_GET['search']) && !empty($_GET['search'])) {
			$_squeeze->withTags($_GET['search']);
		}
		if(isset($_GET['search_ids']) && !empty($_GET['search_ids']) ) {
			$_squeeze->withIds( str_replace(' ', '', explode( ',', $_GET['search_ids'] ) ) );
		}
		if(isset($_GET['url']) && !empty($_GET['url'])) {
			$_squeeze->withUrl( $_GET['url'] );	
		}
		if(in_array(@$_GET['order'], array('c.visitors--dn','c.visitors--up','v.subscribers--up','v.subscribers--dn','cv.crt--up','cv.crt--dn'))) {
			$_squeeze->withListFromTracker();
		}
		if( !Core_Acs::haveAccess( array( 'lps platinum' ) ) ){
			$_squeeze->flgFunnel(0);
		}
		$_squeeze
			->withOrder( @$_GET['order'] )
			->onlyOwner()
			->withPaging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		if(@$_GET['search_ids'] !== false) {
			$this->out['arrFilter']['searchIds']=$_GET['search_ids'];
		}
		$this->out['arrFilter']['searchTags']=$_GET['search'];
		$this->out['arrFilter']['where']=$_GET['where'];
		$this->out['arrFilter']['url']=$_GET['url'];
		$this->out['flgHaveVisitors']=false;
		$_arrSqueezeIds=array();
		$_limit=2;
		foreach( $this->out['arrList'] as &$_item ){
			$_item['export_id']=Project_Widget_Mutator::encode( $_item['id'] );
			$_arrSqueezeIds[]= $_item['id'];
			if( !empty( $_item['url'] ) 
				&& !is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' )
			){
				if( $_limit == 0 ){
					continue;
				}else{
					$_limit--;
				}
				$_getReturn=json_decode( Project_Squeeze::getImageFromLink( $_item['url'] ), true );
				if( isset( $_getReturn['return'] ) && $_getReturn['return']!=0 ){
					$_limit++; // если ошибка не считаем эту картинку
				}
				rename( '.'.$_getReturn['responseData']['results'][0]['url'], Zend_Registry::get('config')->path->absolute->user_files.'squeeze/screenshots/'.md5( $_item['url'] ).".jpg" );
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}elseif( is_file( Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).'.jpg' ) ){
				$_item['image']=Zend_Registry::get('config')->path->absolute->user_files.'squeeze'.DIRECTORY_SEPARATOR.'screenshots'.DIRECTORY_SEPARATOR.md5( $_item['url'] ).".jpg";
			}
		}
		try {
			Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
			if(isset($_POST['company_id']) && isset($_POST['split'])) {
				$_splittestlink=new Project_Widget_Adapter_Squeeze_Split_Link();
				$_splittestlink->setLink2($_POST['split'], explode(',', $_POST['company_id']));
				$this->location();
			}
			$splittest=new Project_Widget_Adapter_Squeeze_Split ();
			$splittest->onlyOwner()->getList( $this->out['arrSplit'] );
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			Core_Sql::renewalConnectFromCashe();
		}
	}

	public function customization(){
		$this->objStore->getAndClear( $this->out );
		if( isset( $this->out['generatedLink'] ) ){
			Core_Users::$info['send2Intercome']=array(
				'json'=>json_encode( array( 'lps_url'=>$this->out['generatedLink'], 'lps_publishing'=>'CNMHOSTED' ) ),
				'action'=>'LPS-Generated'
			);
		}
		if( isset($_POST['name']) && $_POST['name']=='q' ){
			ob_clean();
			header('Content-Type: application/json');
			echo Project_Squeeze::searchImageGoggle($_POST['value']);
			die();
		}
		if( isset($_POST['name']) && $_POST['name']=='link' ){
			ob_clean();
			header('Content-Type: application/json');
			echo Project_Squeeze::getImageFromLink($_POST['value']);
			die();
		}
		$_squeeze=new Project_Squeeze();
		$_flgExport=false;
		if( isset( $_GET['import_id'] ) ){
			$_GET['id']=Project_Widget_Mutator::decode( $_GET['import_id'] );
			$_GET['parent']='';
			$_GET['template']=1;
			$_flgExport=true;
		}
		if( isset( $_GET['id'] ) && !empty( $_GET['id'] ) && !isset( $this->out['generatedLink'] ) ){
			if( isset( $_GET['template'] ) && !empty( $_GET['template'] ) && $_GET['template']==1 ){
				if( isset( $_GET['parent'] ) && !empty( $_GET['parent'] ) ){
					$_squeeze->withIds( $_GET['parent'] )->onlyOwner()->onlyOne()->getList( $_arrParent );
				}
				$_squeeze->withIds( $_GET['id'] )->onlyOne()->getList( $this->out );
				if( $this->out['flg_template'] != 1 && !$_flgExport ){
					$this->out=array();
					unset( $_GET['id'] );
					unset( $_GET['template'] );
				}else{
					if( isset( $_arrParent ) && !empty($_arrParent) ){
						$this->out['id']=$_arrParent['id'];
						$this->out['settings']['ftp_directory']=$_arrParent['settings']['ftp_directory'];
						$this->out['settings']['domain_http']=$_arrParent['settings']['domain_http'];
						$this->out['settings']['url']=$_arrParent['settings']['url'];
						$this->out['settings']['tracking_code']=$_arrParent['settings']['tracking_code'];
						$this->out['settings']['tracking_code_body']=$_arrParent['settings']['tracking_code_body'];
						$this->out['settings']['flg_geo_location']=$_arrParent['settings']['flg_geo_location'];
						$this->out['settings']['geo_enabled']=$_arrParent['settings']['geo_enabled'];
					}else{
						unset( $this->out['id'] );
						unset( $this->out['settings']['ftp_directory'] );
						unset( $this->out['settings']['domain_http'] );
						unset( $this->out['settings']['url'] );
						$this->out['settings']['tracking_code']='';
						$this->out['settings']['tracking_code_body']='';
						$this->out['settings']['flg_geo_location']=0;
						$this->out['settings']['geo_enabled']=array();
					}
					unset( $this->out['flg_funnel'] );
					unset( $this->out['flg_template'] );
					unset( $this->out['settings']['template_description'] );
				}
			}else{
				$_squeeze->withIds( $_GET['id'] )->onlyOwner()->onlyOne()->getList( $this->out );
			}
			$_phones=new Project_Squeeze_Twilio();
			$_phones->onlyOwner()->getList( $_arrTwilioNimbers );
			if( count( $_arrTwilioNimbers )>0 ){
				$this->out['arrUserCountries']=array();
			}
			foreach( $_arrTwilioNimbers as $_number ){
				if( !isset( $this->out['arrUserCountries'][$_number['country']] ) ){
					$this->out['arrUserCountries'][$_number['country']]=array( 'code'=>$_number['country'], 'numbers'=>array() );
				}
				$this->out['arrUserCountries'][$_number['country']]['numbers'][]=$_number['phone'];
			}
		}
		$this->out['templates_link']=Zend_Registry::get( 'config' )->domain->url.Zend_Registry::get('config')->path->html->user_files.'squeeze/templates/';
		if( !empty($_POST['settings']) ){
			if( isset( $_POST['id'] ) && !empty( $_POST['id'] ) ){
				$_squeeze->withIds( $_POST['id'] )->onlyOwner()->onlyOne()->getList( $_havePage );
				if( ( $_havePage['settings']['publishing_options'] == 'local' || $_havePage['settings']['publishing_options'] == 'local_nossl' ) && $_POST['settings']['publishing_options'] == 'remote' ){
					unset( $_POST['id'] );
				}
			}
			//$_POST['settings']['header']=Project_Squeeze::prepareHeader($_POST['settings']['header']);
			$_POST['settings']['geo_flg_city']=true;
			if(!empty($_FILES['upload']['tmp_name'])){
				$_POST['settings']['upload']=Project_Squeeze::uploadTmp( $_FILES['upload'] );
			}
			if(!empty($_FILES['button']['tmp_name'])){
				$_POST['settings']['button']=Project_Squeeze::uploadTmp( $_FILES['button'] );
			}
			if( $_POST['flg_template'] == 1 && isset( $_FILES['tmp_file']['tmp_name'] )){
				$_POST['settings']['template_reload_file']=Project_Squeeze::uploadTmp( $_FILES['tmp_file'] );
			}
			if( $_POST['settings']['file_sound'] != 0 || $_POST['settings']['file_user_sound'] != 0 ){
				$_files=new Project_Files_Squeeze();
				$_files->onlyPaths()->withIds( explode( ':', implode( ':', array_filter( array( @$_POST['settings']['file_sound'], @$_POST['settings']['file_user_sound'] ) ) ) ) )->getList( $_arrRes );
				foreach( $_arrRes as $_fileSound ){
					$_POST['settings']['file_sound_path'][$_fileSound['id']]='https://'.Zend_Registry::get( 'config' )->engine->project_domain.$_fileSound['path_web'].$_fileSound['name_system'];
				}
			}
			//добавляем только новые номера в базу
			if( $_POST['settings']['mo_optin']['type'] == 'sms' 
				&& $_POST['settings']['mo_optin']['sms_number_type'] == 'provision' 
				&& !empty( $_POST['settings']['mo_optin']['sms_number'] )
			){
				//добавляем новый номер в базу
				$_phones=new Project_Squeeze_Twilio();
				$_phones->setEntered( array( 
					'phone'=>$_POST['settings']['mo_optin']['sms_number'],
					'country'=>$_POST['settings']['mo_optin']['sms_number_counry']
				))->set();
				$_POST['settings']['mo_optin']['sms_number_type']=$_POST['settings']['mo_optin']['sms_number_counry'];
			}
			// далее сохраняем\
			if( isset( $_POST['url'] ) && !empty( $_POST['url'] ) ){
				$_POST['settings']['url']=$_POST['url'];
				unset( $_POST['url'] );
			}
			$_squeeze->setEntered( $_POST )->generate();
			$_squeeze->getEntered( $_arrProject );
			$this->objStore->set( array(
				'generatedLink'=>$_squeeze->getGeneratedLink(),
				'arrErrors'=> Core_Data_Errors::getInstance()->getErrors(),
				
			)+$_arrProject );
			unset( $_POST );
			$this->location(array('wg'=>'id='.$_arrProject['id']));
		}
		if( !isset( $this->out['settings']['button'] ) ){
			$this->out['settings']['button']='default.png';
		}
		if( !isset( $this->out['settings']['background'] ) ){
			$this->out['settings']['background']='default.jpg';
		}
		if ( !empty( $this->out['settings']['file_sound'] ) ) {
			$_file=new Project_Files_Squeeze( 'squeeze_default_sounds' );
			$_file->withIds( explode( ':', $this->out['settings']['file_sound'] ) )->getList( $this->out['settings']['sound_files'] );
		}
		if ( !empty( $this->out['settings']['file_user_sound'] ) ) {
			$_file=new Project_Files_Squeeze( 'squeeze_user_sounds' );
			$_file->withIds( explode( ':', $this->out['settings']['file_user_sound'] ) )->getList( $this->out['settings']['sound_user_files'] );
		}
	}

	public function redirect_link(){
		$_squeeze=new Project_Squeeze();
		if( isset( $_POST['url'] ) && !empty( $_POST['url'] ) ){
			$_squeeze->setDefaultPage( $_POST['url'] );
			unset( $_POST );
		}
		$this->out['url']=$_squeeze->getDefaultPage();
	}

	public function learnq_script(){}

	public function example(){
		if(!empty($_FILES['button']['tmp_name'])){
			$_POST['settings']['button']=Project_Squeeze::uploadTmp($_FILES['button']);
		}
		if(!empty($_FILES['upload']['tmp_name'])){
			$_POST['settings']['upload']=Project_Squeeze::uploadTmp($_FILES['upload']);
		}
		header('X-XSS-Protection: 0');
		$_squeeze=new Project_Squeeze();
		$_POST['settings']['publishing_options']='preview';
		if( $_POST['settings']['file_sound'] != 0 || $_POST['settings']['file_user_sound'] != 0 ){
			$_files=new Project_Files_Squeeze();
			$_files->onlyPaths()->withIds( explode( ':', implode( ':', array_filter( array( @$_POST['settings']['file_sound'], @$_POST['settings']['file_user_sound'] ) ) ) ) )->getList( $_arrRes );
			foreach( $_arrRes as $_fileSound ){
				$_POST['settings']['file_sound_path'][$_fileSound['id']]='//'.Zend_Registry::get( 'config' )->engine->project_domain.$_fileSound['path_web'].$_fileSound['name_system'];
			}
		}
		if( $_squeeze->setEntered( $_POST )->generate() === false ){
			$_errors=Core_Data_Errors::getInstance()->getErrors();
			echo "Error: ".implode("<br/>", $_errors['errFlow'] );
		}
		exit;
	}

}
?>