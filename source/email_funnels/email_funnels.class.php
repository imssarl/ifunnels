<?php
class email_funnels extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Email Funnels',
			),
			'actions'=>array(
				array( 'action'=>'set', 'title'=>'Create/Edit Email Funnel' ),
				array( 'action'=>'manage', 'title'=>'Manage Email Funnels' ),
				array( 'action'=>'message2group', 'title'=>'Email Funnels to Groups' ),
				array( 'action'=>'email_search_feature', 'title'=>'Email Search Feature' ),
				array( 'action'=>'csv_import', 'title'=>'CSV Import' ),
				array( 'action'=>'referral_link', 'title'=>'Referral Link' ),
				array( 'action'=>'frontend_set', 'title'=>'Create Funnel', 'flg_tree'=>1 ),
				array( 'action'=>'frontend_manage', 'title'=>'Your Funnels', 'flg_tree'=>1 ),
				array( 'action'=>'frontend_settings', 'title'=>'Funnels Settings', 'flg_tree'=>1 ),
				array( 'action'=>'frontend_settings_set', 'title'=>'Funnels Settings Set', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'request', 'title'=>'AJAX Request', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'popup_email_funnels', 'title'=>'Popup Email Funnels', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'popup_messages', 'title'=>'Popup Messages', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'contacts', 'title'=>'Contacts', 'flg_tree'=>1 ),
				array( 'action'=>'dashboard', 'title'=>'Dashboard', 'flg_tree'=>1 ),
				array( 'action'=>'quickbroadcast', 'title'=>'Quick Broadcast', 'flg_tpl'=>1, 'flg_tree'=>1),
				// duplicate in qjmpz
				array( 'action'=>'getcode', 'title'=>'Get Code', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'unsubscribe', 'title'=>'Unsubscribe page', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				/*
				array( 'action'=>'webhook', 'title'=>'Webhook action', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				*/
			),
		);
	}

	public function referral_link(){
		if( isset( $_POST['arrData'] ) ){
			if(!empty($_FILES['upload']['tmp_name'])){
				$_POST['arrData']['settings']['referral_image']='http'.( ( empty( $_SERVER['HTTPS'] ) || $_SERVER['HTTPS']=='off' )?'':'s' ).'://'.$_SERVER['HTTP_HOST'].str_replace( DIRECTORY_SEPARATOR, '/', Project_Efunnel::uploadTmp( $_FILES['upload'] ) );
			}
			@file_put_contents( './services/referral_link.txt', serialize(array(
				'referral_link'=>$_POST['arrData']['settings']['referral_link'],
				'referral_image'=>$_POST['arrData']['settings']['referral_image']
			) ) );
		}
		$_referralData=file_get_contents( './services/referral_link.txt' );
		if( !empty( $_referralData ) ){
			$this->out['arrData']['settings']=unserialize( $_referralData );
		}
	}

	public function email_search_feature(){
		if(!empty($_POST['email']) && !empty($_POST['user_id']) ){
			$_check=0;
			ob_clean();
			try{
				Core_Sql::setConnectToServer( 'lpb.tracker' );
				//========
				
				$_table=Core_Sql::getRecord( 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = "s8rs_'.( (int)$_POST['user_id'] ).'"' );
				if( $_table !== false ){
					$_check=Core_Sql::getRecord( 'SELECT COUNT(*) as c FROM s8rs_'.( (int)$_POST['user_id'] ).' WHERE email IN ('.Core_Sql::fixInjection( $_POST['email'] ).') ' );
				}
				//========
				Core_Sql::renewalConnectFromCashe();
			} catch(Exception $e) {
				Core_Sql::renewalConnectFromCashe();
			}
			echo @$_check['c'];
			exit;
		}
		$_usersObj=new Project_Users_Management();
		$_usersObj->withGroups(array('iFunnels - Business Program'))->getList( $this->out['arrUsers'] );
	}

	public function dashboard(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel();
		$_model->onlyOwner()->getList( $_arrCampaigns );
		$_arrEFsIds = array_column($_arrCampaigns, 'id');
		if(empty($_GET['arrFilter']['time'])) {
			$_GET['arrFilter']['time']=4;
		}
		$_updArrCampaigns=array();
		foreach( $_arrCampaigns as $_cmp ){
			$_updArrCampaigns[$_cmp['id']]=$_cmp;
		}
		$_arrCampaigns=$_updArrCampaigns;
		unset( $_updArrCampaigns );
		if( isset( $_GET['arrFilter'] ) ){
			$_model
				->withFilter( @$_GET['arrFilter'] )
				->withIds( $_arrEFsIds )
				->getStatistic( $_arrStatistic );
		}else{
			$_model
				->withIds( $_arrEFsIds )
				->getStatistic( $_arrStatistic );
		}
		$_messageList=$_summaryList=array();
		$_countEf=array();
		foreach( $_arrStatistic as &$_arrStt ){
			if( empty( $_arrStt['message_id'] ) ){
				$_arrStt['message_id']=$_arrCampaigns[$_arrStt['ef_id']]['message'][0]['id']||0;
			}
			if( !isset( $_countEf[$_arrStt['ef_id']] ) ){
				$_countEf[$_arrStt['ef_id']]=0;
			}
			$_countEf[$_arrStt['ef_id']]++;
			$_messageList[ $_arrStt['message_id'] ]['efunnel_id']=$_arrStt['ef_id'];
			$_messageList[ $_arrStt['message_id'] ]['message_id']=$_arrStt['message_id'];
			$_messageList[ $_arrStt['message_id'] ]['all']=array(
				'delivered' => (int)$_arrStt['delivered']+(int)@$_messageList[ $_arrStt['message_id'] ]['all']['delivered'],
				'bounced' => (int)$_arrStt['bounced']+(int)@$_messageList[ $_arrStt['message_id'] ]['all']['bounced'],
				'spam' => (int)$_arrStt['spam']+(int)@$_messageList[ $_arrStt['message_id'] ]['all']['spam'],
				'opened' => (int)$_arrStt['opened']+(int)@$_messageList[ $_arrStt['message_id'] ]['all']['opened'],
				'clicked' => (int)$_arrStt['clicked']+(int)@$_messageList[ $_arrStt['message_id'] ]['all']['clicked'],
				'unsubscribe' => (int)$_arrStt['unsubscribe']+(int)@$_messageList[ $_arrStt['message_id'] ]['all']['unsubscribe'],
			);
			$_summaryList['all']=array(
				'delivered' => (int)$_arrStt['delivered']+(int)@$_summaryList['all']['delivered'],
				'bounced' => (int)$_arrStt['bounced']+(int)@$_summaryList['all']['bounced'],
				'spam' => (int)$_arrStt['spam']+(int)@$_summaryList['all']['spam'],
				'opened' => (int)$_arrStt['opened']+(int)@$_summaryList['all']['opened'],
				'clicked' => (int)$_arrStt['clicked']+(int)@$_summaryList['all']['clicked'],
				'unsubscribe' => (int)$_arrStt['unsubscribe']+(int)@$_summaryList['all']['unsubscribe'],
			);
		}
		$_summaryList['all']['count_ef']=$_countEf;
		$_message2subject=$_campaign2title=array();
		foreach( $_arrCampaigns as $_campaign ){
			foreach( $_campaign['message'] as $_message ){
				$_message2subject[$_message['id']]=$_message['subject'];
			}
			$_campaign2title[$_campaign['id']]=$_campaign['title'];
		}
		foreach( $_messageList as &$_messageData ){
			$_messageData['subject']=( isset( $_message2subject[ $_messageData['message_id'] ] ) )?$_message2subject[ $_messageData['message_id'] ]:array( 'Message #'.$_messageData['message_id'] );
			$_messageData['title']=( isset( $_campaign2title[ $_messageData['efunnel_id'] ] ) )?$_campaign2title[ $_messageData['efunnel_id'] ]:'Email Funnel #'.$_messageData['efunnel_id'];
			if( $_messageData['all']['delivered'] != 0 ){
				$_messageData['open_rate']=(float)sprintf("%01.2f", $_messageData['all']['opened']/$_messageData['all']['delivered']*100 );
			}else{
				$_messageData['open_rate']=(float)sprintf("%01.2f", 0 );
			}
			if( $_messageData['all']['delivered'] != 0 ){
				$_messageData['click_rate']=(float)sprintf("%01.2f", $_messageData['all']['clicked']/$_messageData['all']['delivered']*100 );
			}else{
				$_messageData['click_rate']=(float)sprintf("%01.2f", 0 );
			}
		}
		$this->out['arrList']=$this->out['arrClick']=array_values($_messageList);
		if($_GET['order'] == 'open_rate--up'){
			function cmpOR($a, $b){
				return $a["open_rate"] >  $b["open_rate"];
			}
			uasort($_messageList, "cmpOR");
			$this->out['arrList']=array_values($_messageList);
		} elseif ($_GET['order'] == 'open_rate--dn'){
			function cmpOR($a, $b){
				return $a["open_rate"] <  $b["open_rate"];
			}
			uasort($_messageList, "cmpOR");
			$this->out['arrList']=array_values($_messageList);
		}
		
		if($_GET['order'] == 'click_rate--up'){
			function cmpCR($a, $b){
				return $a["click_rate"] >  $b["click_rate"];
			}
			uasort($_messageList, "cmpCR");
			$this->out['arrClick']=array_values($_messageList);
		} elseif ($_GET['order'] == 'click_rate--dn'){
			function cmpCR($a, $b){
				return $a["click_rate"] <  $b["click_rate"];
			}
			uasort($_messageList, "cmpCR");
			$this->out['arrClick']=array_values($_messageList);
		}
		function cmpHR($a, $b){
			return $a["open_rate"] <  $b["open_rate"];
		}
		uasort($_messageList, "cmpHR");
		$this->out['arrHighest']=array_values($_messageList);
		$_reportTimer=$_model->_withTime;
		// chacke 30 before
		$_filter30Before=array(
            'time'=>8,
            'date_from'=>$_model->_withTime['from']-30*24*60*60,
            'date_to'=>$_model->_withTime['from'],
		);
		$_model->withFilter( $_filter30Before ); //->withPeriod( time()-60*60*24*30, time() );
		$_model->withIds( $_arrEFsIds )->getStatistic( $_arrOldStatistic );
		$_reportTimerOld=$_model->_withTime;
		
		$_messageOldList=array();
		$_countEf=array();
		foreach( $_arrOldStatistic as $_arrStt ){
			if( !empty( $_arrStt['message_id'] ) ){
				if( !isset( $_countEf[$_arrStt['ef_id']] ) ){
					$_countEf[$_arrStt['ef_id']]=0;
				}
				$_countEf[$_arrStt['ef_id']]++;
				$_messageOldList[ $_arrStt['message_id'] ]['efunnel_id']=$_arrStt['ef_id'];
				$_messageOldList[ $_arrStt['message_id'] ]['message_id']=$_arrStt['message_id'];
				$_messageOldList[ $_arrStt['message_id'] ]['all']=array(
					'delivered' => (int)$_arrStt['delivered']+(int)@$_messageOldList[ $_arrStt['message_id'] ]['all']['delivered'],
					'bounced' => (int)$_arrStt['bounced']+(int)@$_messageOldList[ $_arrStt['message_id'] ]['all']['bounced'],
					'spam' => (int)$_arrStt['spam']+(int)@$_messageOldList[ $_arrStt['message_id'] ]['all']['spam'],
					'opened' => (int)$_arrStt['opened']+(int)@$_messageOldList[ $_arrStt['message_id'] ]['all']['opened'],
					'clicked' => (int)$_arrStt['clicked']+(int)@$_messageOldList[ $_arrStt['message_id'] ]['all']['clicked'],
					'unsubscribe' => (int)$_arrStt['unsubscribe']+(int)@$_messageOldList[ $_arrStt['message_id'] ]['all']['unsubscribe']
				);
				$_summaryList['old']=array(
					'delivered' => (int)$_arrStt['delivered']+(int)@$_summaryList['old']['delivered'],
					'bounced' => (int)$_arrStt['bounced']+(int)@$_summaryList['old']['bounced'],
					'spam' => (int)$_arrStt['spam']+(int)@$_summaryList['old']['spam'],
					'opened' => (int)$_arrStt['opened']+(int)@$_summaryList['old']['opened'],
					'clicked' => (int)$_arrStt['clicked']+(int)@$_summaryList['old']['clicked'],
					'unsubscribe' => (int)$_arrStt['unsubscribe']+(int)@$_summaryList['old']['unsubscribe'],
				);
			}
		}
		$_summaryList['old']['count_ef']=$_countEf;
		$_message2subject=$_campaign2title=array();
		foreach( $_arrCampaigns as $_campaign ){
			foreach( $_campaign['message'] as $_message ){
				$_message2subject[$_message['id']]=$_message['subject'];
			}
			$_campaign2title[$_campaign['id']]=$_campaign['title'];
		}
		foreach( $_messageOldList as &$_messageOldData ){
			$_messageOldData['subject']=( isset( $_message2subject[ $_messageOldData['message_id'] ] ) )?$_message2subject[ $_messageOldData['message_id'] ]:array( 'Message #'.$_messageOldData['message_id'] );
			$_messageOldData['title']=( isset( $_campaign2title[ $_messageOldData['efunnel_id'] ] ) )?$_campaign2title[ $_messageOldData['efunnel_id'] ]:'Email Funnel #'.$_messageOldData['efunnel_id'];
			if( $_messageOldData['all']['delivered'] != 0 ){
				$_messageOldData['open_rate']=(float)sprintf("%01.2f", $_messageOldData['all']['opened']/$_messageOldData['all']['delivered']*100 );
			}else{
				$_messageOldData['open_rate']=(float)sprintf("%01.2f", 0 );
			}
			if( $_messageOldData['all']['delivered'] != 0 ){
				$_messageOldData['click_rate']=(float)sprintf("%01.2f", $_messageOldData['all']['clicked']/$_messageOldData['all']['delivered']*100 );
			}else{
				$_messageOldData['click_rate']=(float)sprintf("%01.2f", 0 );
			}
		}
		$this->out['arrOldList']=$this->out['arrOldClick']=array_values($_messageOldList);
		
		$_reportDelivery=abs( $_reportTimer['to']-$_reportTimer['from'] )/(24*60*60);
		$_summaryLog=array();
		foreach( $_summaryList as $_type=>$_summaryData ){
			foreach( $_summaryData as $_valueName=>&$_summaryValue ){
				if( $_valueName == 'count_ef' ){
					$_summaryLog[$_type]['ef_counter']=count( $_summaryValue );
					continue;
				}
				if( $_type=='all' ){
					$_summaryLog['all'][$_valueName]=$_summaryValue/$_reportDelivery;
				}else{
					$_summaryLog['old'][$_valueName]=$_summaryValue/30;
				}
			}
		}
		foreach( $_summaryLog['all'] as $_valueName=>$_summaryLogData ){
			if( $_summaryLog['old'][$_valueName] != 0 ){
				$_summaryLog['percent'][$_valueName]=round( 100*$_summaryLogData/$_summaryLog['old'][$_valueName], 1 )-100;
			}else{
				$_summaryLog['percent'][$_valueName]=0;
			}
		}
		$this->out['arrSummary']=$_summaryLog;
		$this->out['arrSummaryList']=$_summaryList;
		
		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			$this->out['allContacts']=Core_Sql::getRecord( 'SELECT COUNT(*) as `count` FROM s8rs_'.Core_Users::$info['id'].' WHERE flg_global_unsubscribe<>1' );
			$this->out['allContactsFilter']=Core_Sql::getRecord( 'SELECT COUNT(*) as `count` FROM s8rs_'.Core_Users::$info['id'].' WHERE flg_global_unsubscribe<>1 AND added>='.$_reportTimer['from'].' AND added<='.$_reportTimer['to'] );
			$this->out['allContactsDateBefore']=Core_Sql::getRecord( 'SELECT COUNT(*) as `count` FROM s8rs_'.Core_Users::$info['id'].' WHERE flg_global_unsubscribe<>1 AND added>='.$_reportTimerOld['from'].' AND added<='.$_reportTimerOld['to'] );
			//========
			Core_Sql::renewalConnectFromCashe();
		}catch(Exception $e){
			Core_Sql::renewalConnectFromCashe();
		}
		$this->out['allContactsPercentage']=round( 100*( $this->out['allContactsFilter']['count']/( $_reportTimer['to'] - $_reportTimer['from'] ) )/( $this->out['allContactsDateBefore']['count']/( $_reportTimerOld['to'] - $_reportTimerOld['from'] ) ), 2 );
		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========

			$this->out['allLeads']=Core_Sql::getRecord( 'SELECT COUNT(*) as `count` FROM s8rs_'.Core_Users::$info['id'].' d JOIN s8rs_events_'.Core_Users::$info['id'].' e ON d.id=e.sub_id WHERE e.event_type='.Project_Subscribers_Events::LEAD_FORM );
			$this->out['allLeadsFilter']=Core_Sql::getRecord( 'SELECT COUNT(*) as `count` FROM s8rs_'.Core_Users::$info['id'].' d JOIN s8rs_events_'.Core_Users::$info['id'].' e ON d.id=e.sub_id WHERE e.event_type='.Project_Subscribers_Events::LEAD_FORM.' AND d.added>='.$_reportTimer['from'].' AND d.added<='.$_reportTimer['to'] );
			$this->out['allLeadsDateBefore']=Core_Sql::getRecord( 'SELECT COUNT(*) as `count` FROM s8rs_'.Core_Users::$info['id'].' d JOIN s8rs_events_'.Core_Users::$info['id'].' e ON d.id=e.sub_id WHERE e.event_type='.Project_Subscribers_Events::LEAD_FORM.' AND d.added>='.$_reportTimerOld['from'].' AND d.added<='.$_reportTimerOld['to'] );

			//========
			Core_Sql::renewalConnectFromCashe();
		}catch(Exception $e){
			Core_Sql::renewalConnectFromCashe();
		}
		$this->out['allLeadsPercentage']=round( 100*( $this->out['allLeadsFilter']['count']/( $_reportTimer['to'] - $_reportTimer['from'] ) )/( $this->out['allLeadsDateBefore']['count']/( $_reportTimerOld['to'] - $_reportTimerOld['from'] ) ), 2 );
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel();
		if(!empty($_GET['delete'])){
			$this->objStore->set( array( 'msg'=>( $_model->withIds(array($_GET['delete']))->del() ) ? 'delete':'delete_error' ) );
			$this->location( array( 'action' => 'manage' ));
		}
		if(!empty($_GET['duplicate'])){
			$_model->duplicate( $_GET['duplicate'] );
			$this->location( array( 'action' => 'manage' ) );
		}
		$_model->withPaging(array(
			'page'=>@$_GET['page'],
			'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
			'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
			))
			->withOrder( @$_GET['order'] )
			->onlyTemplates()
			->getList($this->out['arrData'])
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function set(){
		$_model=new Project_Efunnel();
		if( !empty($_POST) ){
			if (!empty($_SERVER["HTTP_CLIENT_IP"])){
				$ip=$_SERVER["HTTP_CLIENT_IP"];
			} elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
				$ip=$_SERVER["HTTP_X_FORWARDED_FOR"];
			} else {
				$ip=$_SERVER["REMOTE_ADDR"];
			}
			$_POST['arrData']['options']['from_ip']=$ip;
			if( $_model->setEntered( $_POST['arrData'])->set() ){
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>(!empty($_GET['id']))?'saved':'created' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$_model->getErrors($this->out['arrErrors']);
			$_model->getEntered( $this->out['arrData'] );
		}
		if (!empty($_GET['id'])){
			$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
		}
		$_model->onlyTemplates()->getList($this->out['arrEFunnels']);
	}
	
	public function message2group(){
		if ( !empty( $_POST['change_group'] ) ){
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrG'] );
		$_f2g=new Project_Efunnel_Access();
		if(!empty($_GET['group_id'])){
			$_f2g->withGroupIds( $_GET['group_id'] )->getList( $_selectedTemplates );
		}
		$this->out['selectedTemplates']=array();
		foreach( $_selectedTemplates as $_template ){
			$this->out['selectedTemplates'][]=$_template['funnel_id'];
		}
		if(isset($_POST['save'])){
			$_arrData=array();
			$_f2g->withGroupIds( $_POST['arrR']['group_id'] )->del();
			foreach( $_POST['arrT'] as $_t ){
				$_arrData[]=array(
					'funnel_id'=> $_t, 
					'group_id'=> $_POST['arrR']['group_id']
				);
			}
			$_f2g->setEntered( $_arrData )->set();
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_squeeze=new Project_Efunnel();
		$_squeeze->onlyTemplates()->getList( $this->out['arrEFunnels'] );
	}

	public function frontend_set(){
		$_model=new Project_Efunnel();			
		if( !empty($_POST) ){
			if (!empty($_SERVER["HTTP_CLIENT_IP"])){
				$ip=$_SERVER["HTTP_CLIENT_IP"];
			} elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
				$ip=$_SERVER["HTTP_X_FORWARDED_FOR"];
			} else {
				$ip=$_SERVER["REMOTE_ADDR"];
			}
			$_POST['arrData']['options']['from_ip']=$ip;
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				if( isset( $_POST['flg_autosave'] ) && $_POST['flg_autosave'] != 1 ){
					$_model->getEntered( $_arrData );
					// добавляем обновление для списка контактов по крону
					file_put_contents(
						Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
						Core_Users::$info['id'].PHP_EOL.'Project_Efunnel_Subscribers'.PHP_EOL.'cronReturnContactsToCampaign'.PHP_EOL.serialize( array( 'id'=>$_arrData['id'] ) ) 
					);
					//----------------------------
					$this->objStore->toAction( 'frontend_manage' )->set( array( 'msg'=>(!empty($_GET['id']))?'saved':'created' ) );
					if( isset( $_POST['action_menu'] ) && $_POST['action_menu']=='template' ){
						$_userId=Core_Users::$info['id'];
						Core_Users::getInstance()->setById(1);
						foreach( $_POST['arrData']['message'] as &$_mess ){
							unset( $_mess['id'] );
						}
						$_POST['arrData']['flg_template']=1;
						$_POST['arrData']['user_id']=0;
						unset( $_POST['arrData']['id'] );
						$_model->setEntered( $_POST['arrData'] )->set();
						Core_Users::getInstance()->setById($_userId);
					}
					if( isset( $_POST['action_menu'] ) && $_POST['action_menu']=='send' ){
						$this->location( array( 'action' => 'frontend_manage' ) );
					}else{
						$this->location( array( 'action' => 'frontend_set', 'wg'=>array('id'=>$_arrData['id']) ) );
					}
				}else{
					$_model->getEntered( $this->out['arrData'] );
					ob_end_clean();
					echo json_encode( $this->out['arrData'] );
					exit;
				}
			}
			$_model->getErrors($this->out['arrErrors']);
			$_model->getEntered( $this->out['arrData'] );
		}
		if (!empty($_GET['id'])){
			$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
		}
		$_model->onlyOwner()->getList($this->out['arrEFunnels']);
		$_arrGroupsids=array();
		$_group=new Core_Acs_Groups();
		$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		foreach( $_arrCurrentGroups as $_i ){
			$_arrGroupsids[$_i['id']]=$_i['id'];
		}
		$_f2g=new Project_Efunnel_Access();
		$_f2g->withGroupIds( $_arrGroupsids )->getList( $_selectedTemplatesIds );
		if( !empty( $_selectedTemplatesIds ) ){
			$_efunnelT2G=array();
			foreach( $_selectedTemplatesIds as $_efIds ){
				$_efunnelT2G[$_efIds['funnel_id']]=$_efIds['funnel_id'];
			}
			$_model->onlyTemplates()->withIds( $_efunnelT2G )->getList( $this->out['arrTemplatesEF'] );
		}else{
			$this->out['arrTemplatesEF']=array();
		}
		$_model=new Project_Efunnel_Settings();
		$_model->onlyOwner()->getList($this->out['arrSMTP']);
		$_model=new Project_Efunnel();
		$_arrGroupsids=array();
		$_group=new Core_Acs_Groups();
		$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		foreach( $_arrCurrentGroups as $_i ){
			$_arrGroupsids[$_i['id']]=$_i['id'];
		}
		$_f2g=new Project_Efunnel_Access();
		$_f2g->withGroupIds( $_arrGroupsids )->getList( $_selectedTemplatesIds );
		$this->out['flgHaveTemplates']=false;
		if( !empty( $_selectedTemplatesIds ) ){
			$this->out['flgHaveTemplates']=true;
		}
	}

	public function quickbroadcast(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel();			
		if( !empty($_POST) ){
			if (!empty($_SERVER["HTTP_CLIENT_IP"])){
				$ip=$_SERVER["HTTP_CLIENT_IP"];
			} elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
				$ip=$_SERVER["HTTP_X_FORWARDED_FOR"];
			} else {
				$ip=$_SERVER["REMOTE_ADDR"];
			}
			$_POST['arrData']['options']['from_ip']=$ip;
			$_POST['arrData']['title']=$_POST['arrData']['message'][0]['name']=$_POST['arrData']['message'][0]['subject'][0];
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				$_model->getEntered( $_arrData );
				$this->objStore->toAction( 'quickbroadcast' )->set( array( 'id'=>$_arrData['id'] ) );
				$this->location( array( 'action' => 'quickbroadcast' ) );
			}
			$_model->getErrors($this->out['arrErrors']);
			$_model->getEntered( $this->out['arrData'] );
		}
		$_model=new Project_Efunnel_Settings();
		$_model->onlyOwner()->getList($this->out['arrSMTP']);
	}
	
	public function frontend_manage(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel();
		if(!empty($_GET['delete'])){
			if( $_model->withIds(array($_GET['delete']))->del() ){
				$this->objStore->set( array( 'msg'=>'Company deleted successfully' ) );
				file_put_contents(
					Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
					Core_Users::$info['id'].PHP_EOL.'Project_Efunnel'.PHP_EOL.'cronDeleteCampaigns'.PHP_EOL.serialize( array_filter( $_REQUEST ) ) 
				);
			}else{
				$this->objStore->set( array( 'error'=>'Company notdeleted' ) );
			}
			$this->location( array( 'action' => 'frontend_manage' ));
		}
		if(!empty($_GET['duplicate'])){
			$_model->duplicate( $_GET['duplicate'] );
			$this->location( array( 'action' => 'frontend_manage' ) );
		}
		if(isset($_GET['flg_pause'])){
			$_model->activate( $_GET['id'], $_GET['flg_pause'] )->setLog( $_GET['id'], '' );
		}
		if( !empty( $_GET['arrFilter']['type'] ) ){
			$_model->withType( $_GET['arrFilter']['type'] );
		}
		if( !empty( $_GET['title'] ) ){
			$_model->withTitleLike( $_GET['title'] );
		}
		$_model
			->onlyOwner()
			->withPaging(array(
				'page'=>@$_GET['page'],
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList($this->out['arrData'])
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}
	
	public function request(){
		if( isset( $_REQUEST['id'] ) && !empty( $_REQUEST['id'] ) ){
			$_model=new Project_Efunnel();
			$_model->withIds($_REQUEST['id'])->onlyOne()->getList($this->out_js);
			echo json_encode( $this->out_js );
			exit();
		}
		if( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'send_test_email' ){
			parse_str($_REQUEST['campaign'], $_campaignArray);
			$_settings=new Project_Efunnel_Settings();
			$_settings->withIds($_campaignArray['arrData']['smtp_id'])->onlyOne()->getList( $_campaignSMTP );
			$_campaignArray['arrData']['smtp']=$_campaignSMTP['settings'];
			$_port=25;
			if( !empty( $_campaignArray['arrData']['smtp']['smtp_port'] ) ){
				$_port=(int)$_campaignArray['arrData']['smtp']['smtp_port'];
			}
			$_sender=new Project_Efunnel_Mailer();
			$_sender->create(Zend_Registry::get('config')->path->absolute->mailpool.DIRECTORY_SEPARATOR.'servers'.DIRECTORY_SEPARATOR.Project_Efunnel_Sender::code( $_campaignArray['arrData']['smtp']['smtp_server'] ).'.'.$_port);
			$_sender->createSenderFile(
				Core_Users::$info['id'], 
				$_campaignArray['arrData'], 
				array('subject'=>$_REQUEST['subject'],'body_html'=>$_REQUEST['text'],'body_plain_text'=>$_REQUEST['textplan'],'id'=>0,  ), 
				array('email'=>$_REQUEST['email'],'data'=>array()), 
				false
			);
			exit;
		}
		if( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'test_connection' ){
			$_c=@fsockopen( $_REQUEST['server'], $_REQUEST['port'], $errno, $errstr, 30 );
			if( !empty( $errstr ) ){
				$this->out_js['error']=mb_convert_encoding( $errstr, "UTF-8" );
				echo json_encode( $this->out_js );
				exit;
			}
			stream_set_timeout($_c, 5);
			$_arrSend=array();
			$_arrSend[]="EHLO ".$_SERVER['SERVER_NAME']."\r\n";
			$_arrSend[]="HELO ".$_SERVER['SERVER_NAME']."\r\n";
			if( isset( $_REQUEST['user'] ) && !empty( $_REQUEST['user'] ) ){
				$_arrSend[]="AUTH LOGIN\r\n";
				$_arrSend[]=base64_encode( $_REQUEST['user'] )."\r\n";
			}
			if( isset( $_REQUEST['pass'] ) && !empty( $_REQUEST['pass'] ) ){
				$_arrSend[]=base64_encode( $_REQUEST['pass'] )."\r\n";
			}
/*
$_arrSend[]="MAIL FROM:<test@test.email>\r\n";
$_arrSend[]="RCPT TO:<shadow-dwarf@yandex.by>\r\n";
$_arrSend[]="DATA\r\n";
$_arrSend[]="Subject: Test message\r\n";
$_arrSend[]="From: Slava Slepov <test@test.email>\r\n";
$_arrSend[]="Content-Type: text/html; charset=\"UTF-8\"\r\n";
$_arrSend[]="Content-Transfer-Encoding: quoted-printable\r\n";
$_arrSend[]="To: <shadow-dwarf@yandex.by>\r\n";
$_arrSend[]="<b>Cool email body</b>\r\n";
$_arrSend[]=".\r\n";
*/
			$_arrSend[]="QUIT\r\n";
			$_return=fgets( $_c, 9999 );
			$_returnSMTP=$_return;
/*
echo $_return;
echo "<br/>";
*/
//echo 'S:'. htmlspecialchars( $_return ) .'<br/>';
			$_flgTlsStart=false;
			$flgSuccess=false;
			foreach( $_arrSend as $key=>$_sendStr ){
//echo 'C:'.htmlspecialchars( $_sendStr ).'<br/>';
				fputs($_c, $_sendStr);
				$_start=microtime(true);
				$_return=$this->getAnswer( $_c );
/*
echo $_sendStr;
echo "<br/>";
echo $_return;
echo "<br/>";
*/
				if( strpos( $_sendStr, 'EHLO ' ) !== false && $_return[0] == 5 ){
					continue;
				}
				$_returnSMTP.=$_return;
//echo 'E:'. htmlspecialchars( $_return ).' '.microtime(true).'<br/>';
				if( !$_flgTlsStart && strpos( $_return, 'STARTTLS' )!==false ){
					fputs($_c, "STARTTLS\r\n");
//echo 'C: STARTTLS'.'<br/>';
					$_return=$this->getAnswer( $_c );
					$_returnSMTP.=$_return;
//echo 'E:'. htmlspecialchars( $_return ).' '.microtime(true) .'<br/>';
					$cryptoMethod = STREAM_CRYPTO_METHOD_TLS_CLIENT;
					if (defined('STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT')) {
						$cryptoMethod |= STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT;
						$cryptoMethod |= STREAM_CRYPTO_METHOD_TLSv1_1_CLIENT;
					}
					set_error_handler('errorHandler');
					$flgCrypto=stream_socket_enable_crypto( $_c, true, $cryptoMethod );
					restore_error_handler();
//echo 'Crypto:'.$flgCrypto.'<br/>';
					fputs($_c, "EHLO ".$_SERVER['SERVER_NAME']."\r\n");
//echo 'C: EHLO '.$_SERVER['SERVER_NAME'].'<br/>';
					$_return=$this->getAnswer( $_c );
					$_returnSMTP.=$_return;
//echo 'E:'. htmlspecialchars( $_return ).' '.microtime(true).'<br/>';
					$_flgTlsStart=true;
				}
				if( strpos( $_return, '235 ' ) === 0 ){
					$flgSuccess=true;
				}
				if( strpos( $_return, '5' ) === 0 ){
					$this->out_js['error']='SMTP Send Error: '.$_returnSMTP;
					break;
				}
			}
			fclose($_c);
			echo json_encode( $this->out_js );
			exit;
		}
		if( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'getlist' ){
			$_model=new Project_Efunnel();
			$_model->onlyOwner()->getList( $this->out_js );
			echo json_encode( $this->out_js );
			exit();
		}
	}

	private function getAnswer( $smtp ){
		if( !is_resource($smtp) ){
			return false;
		}
		$data='';
		while( !feof( $smtp ) ){
			$str=@fgets( $smtp, 515 );
			$data.=$str;
			// If response is only 3 chars (not valid, but RFC5321 S4.2 says it must be handled),
			// or 4th character is a space, we are done reading, break the loop,
			// string array access is a micro-optimisation over strlen
			if( !isset($str[3]) or ( isset($str[3]) and $str[3] == ' ' ) ){
				break;
			}
		}
		return $data;
	}

	public function frontend_settings(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel_Settings();
		if(!empty($_GET['delete'])){
			$this->objStore->set( array( 'msg'=>( $_model->withIds(array($_GET['delete']))->del() ) ? true : Core_Data_Errors::getInstance()->getErrors()['errFlow']) );
			$this->location();
		}
		if( isset( $_GET['flg_active'] ) && isset( $_GET['id'] ) ){
			$_model->withIds($_GET['id'])->onlyOne()->getList( $_arrData );
			$_arrData['flg_active']=$_GET['flg_active'];
			$_model->setEntered( $_arrData )->set();
			$this->location();
		}
		if(!empty($_GET['delete'])){
			$this->objStore->set( array( 'msg'=>( $_model->withIds(array($_GET['delete']))->del() ) ? 'delete':'delete_error' ) );
			$this->location( array( 'action' => 'frontend_settings' ));
		}
		$_model
			->onlyOwner()
			->withPaging(array(
				'page'=>@$_GET['page'],
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList($this->out['arrData'])
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}
	
	public function frontend_settings_set(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel_Settings();
		if (!empty($_GET['id'])){
			$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
		}
		if(!empty($_FILES['upload']['tmp_name'])){
			$_POST['arrData']['settings']['referral_image']=Project_Efunnel::uploadTmp( $_FILES['upload'] );
		}
		if( !empty($_POST) ){
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				$_model->getEntered( $this->out['arrData'] );
				$this->objStore->set( array( 'msg'=>(!empty($_POST['arrData']['id']))?'saved':'created' ) );
				$this->location();
			}
			$_model->getErrors($this->out['arrErrors']);
			$_model->getEntered( $this->out['arrData'] );
		}
	}
	
	public function popup_email_funnels(){
		$_model=new Project_Efunnel();
		if (!empty($_GET['id'])){
			$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
			return;
		}
		$_arrGroupsids=array();
		$_group=new Core_Acs_Groups();
		$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		foreach( $_arrCurrentGroups as $_i ){
			$_arrGroupsids[$_i['id']]=$_i['id'];
		}
		$_f2g=new Project_Efunnel_Access();
		$_f2g->withGroupIds( $_arrGroupsids )->getList( $_selectedTemplatesIds );
		if( !empty( $_selectedTemplatesIds ) ){
			$_efunnelT2G=array();
			foreach( $_selectedTemplatesIds as $_efIds ){
				$_efunnelT2G[$_efIds['funnel_id']]=$_efIds['funnel_id'];
			}
			$_efunnel=new Project_Efunnel();
			$_efunnel->onlyTemplates()->withIds( $_efunnelT2G )->getList( $this->out['arrData'] );
			foreach ($this->out['arrData'] as $key => &$item){
				$item['length_days'] = 0;
				if( $item['type'] == '2' ){
					foreach ($item['message'] as $message){
						if( $message['flg_period'] == '1' ){
							$item['length_days'] += intval( $message['period_time'] ) / 24;
						} else {
							$item['length_days'] += intval( $message['period_time'] );
						}
					}
					$item['length_days'] = round( $item['length_days'], 2 );
				}
			}
		}else{
			$this->out['arrData']=array();
		}
	}

	public function popup_messages(){
		if( isset( $_GET['flg_pause'] ) && !empty( $_GET['message_id'] ) ){
			$_model=new Project_Efunnel_Message();
			$_model->activate( $_GET['message_id'], $_GET['flg_pause'] );
			unset( $_GET['flg_pause'], $_GET['message_id'] );
			$this->location( array( 'wg'=> 'id='. $_GET['id']) );
		}
		if( $_POST['action'] == 'resend_message' ){
			$_model=new Project_Efunnel_Message();
			$_model->addResend( $_POST['arrData'] );
		}
		if( !isset( $_GET['run'] ) ){
			$this->out['flgWait']=1;
			$this->out['strGet']=http_build_query( array( 'run'=>1 ) );
			return;
		}
		ob_end_clean();
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Efunnel();
		$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
		$_model->withIds($_GET['id'])->getStatistic($this->out['arrStatistic']);
		$_keys=$_names=array();
		foreach( $this->out['arrData']['options'] as $_key=>$_name ){
			$_keys[]='%'.strtoupper( $_key ).'%';
			$_names[]=$_name;
		}
		foreach( $this->out['arrStatistic'] as $_key=>$_name ){
			$_keys[]='%'.strtoupper( $_key ).'%';
			$_names[]=$_name;
		}
		$_s8r=new Project_Efunnel_Subscribers( Core_Users::$info['id'] );
		$_s8r->withEfunnelIds( $_GET['id'] )->noEvents()->onlyCount()->getList( $this->out['subscribersCount'] );
		$this->out['subscribersCount']=count( $this->out['subscribersCount'] );
		$_arrUniqueEmails=array();
		foreach( $this->out['arrData']['message'] as &$_message ){
			$_message['name'] = str_replace( '%%%', '%', $_message['name'] );
			$_message['name'] = str_replace( '%%', '%', $_message['name'] );
			$_message['name'] = str_replace( $_keys, $_names, $_message['name'] );
			$_subjList=array();
			foreach( $_message['subject'] as &$_subj ){
				$_subj = str_replace( '%%%', '%', $_subj );
				$_subj = str_replace( '%%', '%', $_subj );
				$_subj = str_replace( $_keys, $_names, $_subj );
				if( !empty( $_subj ) ){
					$_message['goodSubject']=md5($_subj);
					$_subjList[md5($_subj)]=array('name'=>$_subj,'open'=>0,'click'=>0);
				}else{
					$_subjList[$_message['goodSubject']]=array('name'=>$_subj,'open'=>0,'click'=>0);
				}
			}
			foreach( $_message['subject'] as $_key=>$_subj ){
				$_subj = str_replace( '%%%', '%', $_subj );
				$_subj = str_replace( '%%', '%', $_subj );
				$_subj = str_replace( $_keys, $_names, $_subj );
				if( empty( $_subj ) ){
					unset( $_message['subject'][$_key] );
				}
			}
			foreach( $this->out['arrStatistic'] as $_stat ){
				if( $_message['id'] == $_stat['message_id'] ){
					foreach( array( 'delivered', 'bounced', 'spam', 'opened', 'clicked' ) as $_tail ){
						if( !isset( $_message[$_tail] ) ){
							$_message[$_tail]=0;
						}
						if( isset( $_stat[$_tail] ) || !empty( $_stat[$_tail] ) ){
							$_message[$_tail]+=$_stat[$_tail];
						}
					}
					if( $_stat['opened']>0 ){
						if( isset( $_stat['subject'] ) && !empty( $_stat['subject'] ) && isset( $_subjList[md5($_stat['subject'])] ) ){
							$_subjList[md5($_stat['subject'])]['open']+=$_stat['opened'];
						}else{
							$_subjList[$_message['goodSubject']]['open']+=$_stat['opened'];
						}
					}
					if( $_stat['clicked']>0 ){
						if( isset( $_stat['subject'] ) && !empty( $_stat['subject'] ) && isset( $_subjList[md5($_stat['subject'])] ) ){
							$_subjList[md5($_stat['subject'])]['click']+=$_stat['clicked'];
						}else{
							$_subjList[$_message['goodSubject']]['click']+=$_stat['clicked'];
						}
					}
				}
			}
			$_message['subject']=$_subjList;
		}
	}

	public function csv_import(){
		$this->objStore->getAndClear( $this->out );
		$_import=new Project_Efunnel_Import();
		if(!empty($_GET['flg_allow'])){
			$_import->withIds( $_GET['flg_allow'] )->onlyOne()->getList( $_data );
			$_model=new Project_Efunnel_Subscribers($_data['user_id']);
			$_model->setEntered( $_data['email_list'] )->setMass();
			$_import->withIds( $_GET['flg_allow'] )->del();
		}
		if(!empty($_GET['del'])){
			$_import->withIds( $_GET['del'] )->del();
		}
		$_import
			->withPaging(array(
				'page'=>@$_GET['page'],
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
			))
			->getList($this->out['arrData'])
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		$_userIds=array();
		foreach( $this->out['arrData'] as $_data ){
			$_userIds[$_data['user_id']]=$_data['user_id'];
		}
		$_users=new Project_Users_Management();
		$_users->withIds( $_userIds )->getList($this->out['arrUsers']);
		$_userIds=array();
		foreach( $this->out['arrUsers'] as $_user ){
			$_userIds[$_user['id']]=$_user['email'];
		}
		$this->out['arrUsers']=$_userIds;
	}

	public function contacts(){
		set_time_limit(0);
		$this->objStore->getAndClear( $this->out );
		$_filters=new Project_Filters();
		if( !empty( $_GET['arrFilter'] ) && isset( $_GET['arrFilter']['filter_save'] ) && $_GET['arrFilter']['filter_save']==1 ){
			$_name=@$_GET['arrFilter']['filter_name'];
			unset( $_GET['arrFilter']['filter_name'], $_GET['arrFilter']['filter_save'] );
			if( empty( $_name ) ){
				$_name='#'.implode( ' ', $_GET['arrFilter'] );
			}
			$_filters->setEntered( array(
				'type'=>'email_funnels-contacts',
				'options'=>$_GET['arrFilter'],
				'name'=>$_name
			) )->set();
			$this->location(array('w'=>$_GET));
		}
		$_filters->withType( 'email_funnels-contacts' )->onlyOwner()->getList( $_arrFilters );
		$this->out['sFilter']=array('EF'=>array());
		foreach( $_arrFilters as $_filter ){
			$this->out['sFilter']['EF'][] = array(
				'name'             => $_filter['name'],
				'ef'               => (isset($_filter['options']['email_funnels']) ? $_filter['options']['email_funnels'] : ''),
				'status'           => (isset($_filter['options']['status']) ? $_filter['options']['status'] : ''),
				'tags'             => (isset($_filter['options']['tags']) ? $_filter['options']['tags'] : ''),
				'validation'       => (isset($_filter['options']['validation']) ? $_filter['options']['validation'] : ''),
				'time'             => (isset($_filter['options']['time']) ? $_filter['options']['time'] : ''),
				'time_start'       => (isset($_filter['options']['time_start']) ? $_filter['options']['time_start'] : ''),
				'time_end'         => (isset($_filter['options']['time_end']) ? $_filter['options']['time_end'] : ''),
				'lead_channels'    => (isset($_filter['options']['lead_channels']) ? $_filter['options']['lead_channels'] : ''),
				'membership'       => (isset($_filter['options']['membership']) ? $_filter['options']['membership'] : ''),
				'ft_ef'            => (isset($_filter['options']['ef_email_funnels']) ? $_filter['options']['ft_email_funnels'] : ''),
				'ft_status'        => (isset($_filter['options']['status']) ? $_filter['options']['ft_status'] : ''),
				'ft_tags'          => (isset($_filter['options']['tags']) ? $_filter['options']['ft_tags'] : ''),
				'ft_validation'    => (isset($_filter['options']['validation']) ? $_filter['options']['ft_validation'] : ''),
				'ft_lead_channels' => (isset($_filter['options']['lead_channels']) ? $_filter['options']['ft_lead_channels'] : ''),
				'ft_membership'    => (isset($_filter['options']['membership']) ? $_filter['options']['ft_membership'] : ''),
			);
		}
		if(!empty($_POST['arrTag']) && empty( $_POST['arrData']['action'] ) ){
			$_arrAddTags=explode( ',', $_POST['arrTag']['add'] );
			$_allTags=$_arrNewTags=array_unique( array_filter( array_merge(
				is_array( $_arrAddTags )? $_arrAddTags : array(),
				is_array( $_POST['arrTag']['have'] )? $_POST['arrTag']['have'] : array(),
				is_array( $_POST['arrTag']['select'] )? $_POST['arrTag']['select'] : array()
			) ) );
			$_allTagsIds=Project_Tags::set( $_allTags );
			$_allTags=array_flip( Project_Tags::get( $_allTagsIds ) );
			$_addTags=','.implode(',', $_allTags ).',';
			try {
				Core_Sql::setConnectToServer( 'lpb.tracker' );
				//========
				Core_Sql::setExec( 'UPDATE s8rs_'.Core_Users::$info['id'].' SET tags="'.$_addTags.'" WHERE email="'.base64_decode( $_POST['arrTag']['email'] ).'"' );
				//========
				Core_Sql::renewalConnectFromCashe();
			}catch(Exception $e){
				Core_Sql::renewalConnectFromCashe();
			}
			$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
		}
		if(!empty($_GET['action']) && $_GET['action']=='delete'){
			if( !empty( $_GET['email'] ) ){
				$_decodeEmail=base64_decode( $_GET['email'] );
			}else{
				$_decodeEmail='';
			}
			$_funnel=new Project_Efunnel_Subscribers(Core_Users::$info['id']);
			$_funnel->withEmail(array( $_decodeEmail ))->del();
			$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'], 'action'=>null, 'email'=>null  ) ) );
		}
		if( !empty( $_GET ) ){
			$_sget=$_GET;
			unSet($_sget['order']);
			$this->out['sortParam']=http_build_query($_sget);
		}
		$arrEFunnels = array();
		$_funnel=new Project_Efunnel();
		$_funnel->onlyOwner()->keyRecordForm()->getList( $this->out['arrEFunnels'] );
		$company=new Project_Mooptin();
		$company->onlyOwner()->getList($arrData);
		foreach( $arrData as $mocp ){
			$this->out['mo_campaigns'][$mocp['id']]=array('name'=>$mocp['name'],'tag'=>$mocp['tags']);
		}
		$this->out['mo_campaigns']=array_filter( $this->out['mo_campaigns'] );
		$_model=new Project_Efunnel_Subscribers(Core_Users::$info['id']);
		if( !empty( $_GET['search'] ) ){
			$_model->withTags( $_GET['search'] );
		}
		if( !empty( $_GET['email'] ) ){
			$_model->withEmail( $_GET['email'] );
		}
		if( !empty( $_GET['arrFilter']['email_funnels'] ) ){
			if( $_GET['arrFilter']['email_funnels'] == 'ns' ){
				$_funnel=new Project_Efunnel();
				$_funnel->onlyOwner()->onlyIds()->getList( $_EFids );
				$_model->withoutEfunnelIs($_EFids);
			}else{
				// Is
				if (empty($_GET['arrFilter']['ft_email_funnels']) || $_GET['arrFilter']['ft_email_funnels'] == '1') {
					$_model->withEfunnelIds( $_GET['arrFilter']['email_funnels'] );
				}

				// Is Not
				if ($_GET['arrFilter']['ft_email_funnels'] == '2') {
					$_model->withoutEfunnels( $_GET['arrFilter']['email_funnels'] );
				}
			}
		}
		if( !empty( $_GET['arrFilter']['lead_channels'] ) ){
			// Is
			if (empty($_GET['arrFilter']['ft_lead_channels']) || $_GET['arrFilter']['ft_lead_channels'] == '1') {
				$_model->withLead( $_GET['arrFilter']['lead_channels'] );
			}

			// Is Not
			if ($_GET['arrFilter']['ft_lead_channels'] == '2') {
				$_model->withoutLead( $_GET['arrFilter']['lead_channels'] );
			}

			// $_model->withLead( $_GET['arrFilter']['lead_channels'] );
		}	
		if( !empty( $_GET['arrFilter']['status'] ) && $_GET['arrFilter']['status'] != 'unsubscribe' ){

			// Is
			if (empty($_GET['arrFilter']['ft_status']) || $_GET['arrFilter']['ft_status'] == '1') {
				$_model->withStatusMessage( $_GET['arrFilter']['status'] );
			}

			// Is Not
			if ($_GET['arrFilter']['ft_status'] == '2') {
				$_model->withoutStatusMessage( $_GET['arrFilter']['status'] );
			}
		}

		if( !empty( $_GET['arrFilter']['status'] ) && $_GET['arrFilter']['status'] == 'unsubscribe' ){
			$_model->onlyFlgGlobalUnsubscribe();
		}else{
			$_model->withoutFlgGlobalUnsubscribe();
		}
		if( !empty( $_GET['arrFilter']['tags'] ) ){
			// Is
			if (empty($_GET['arrFilter']['ft_tags']) || $_GET['arrFilter']['ft_tags'] == '1') {
				$_model->withTags( $_GET['arrFilter']['tags'], true );
			}

			// Is Not
			if ($_GET['arrFilter']['ft_tags'] == '2') {
				$_model->withoutTags( $_GET['arrFilter']['tags'] );
			}
		}
		if( !empty( $_GET['arrFilter']['validation'] ) ){
			// Is
			if (empty($_GET['arrFilter']['ft_validation']) || $_GET['arrFilter']['ft_validation'] == '1') {
				$_model->withValidation( $_GET['arrFilter']['validation'] );
			}

			// Is Not
			if ($_GET['arrFilter']['ft_validation'] == '2') {
				$_model->withoutValidation( $_GET['arrFilter']['validation'] );
			}
			
		}
		if( !empty( $_GET['arrFilter']['time'] ) ){
			$_model->withTime( $_GET['arrFilter']['time'], $_GET['arrFilter']['time_start'], $_GET['arrFilter']['time_end'] );
		}

		if (!empty($_GET['arrFilter']['membership'])) {
			// Is
			if (empty($_GET['arrFilter']['ft_membership']) || $_GET['arrFilter']['ft_membership'] == '1') {
				$_model->withMembershipId($_GET['arrFilter']['membership']);
			}

			// Is Not
			if ($_GET['arrFilter']['ft_membership'] == '2') {
				$_model->withoutMembershipId($_GET['arrFilter']['membership']);
			}
		}

		$_model
			->withStatus()
			->withTagsHeat()
			->withOrder( @$_GET['order'] )
			->withPaging( array(
				'url'=>$_GET,
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getTagsHeat( $this->out['arrTagsHeat'] );
		$this->out['maxTagsHeat']=max($this->out['arrTagsHeat']);
		foreach( $this->out['arrList'] as &$_s8rData ){
			foreach( $_s8rData['efunnel_events'] as $_eventData ){
				$_addedTime=time();
				foreach( $_eventData as $_eventName=>$_eventValue ){
					if( $_eventName=='added' ){
						$_addedTime=$_eventValue;
					}
					if( strpos($_eventName, 'mo2ar_request_')!==false ){
						foreach( unserialize( base64_decode( $_eventValue ) ) as $_dataName=>$_dataValue ){
							if( !empty( $_dataValue ) && !in_array( $_dataName, array('email', 'ip', 'userAgent','id', 'callback','-','_') ) ){
								$_s8rData['s8rData'][$_dataName]=array( 'value'=>$_dataValue, 'added'=>$_addedTime );
							}
						}
					}
				}
			}
			foreach( unserialize( base64_decode( $_s8rData['settings'] ) ) as $_sdataName=>$_sdataValue ){
				if( !empty( $_sdataName ) && !empty( $_sdataValue ) ){
					$_s8rData['s8rData'][$_sdataName]=array( 'value'=>$_sdataValue, 'added'=>$_s8rData['added'] );
				}
			}	
		}
		Project_Tags::getListOfUser($this->out['arrTags']);
		if(!empty($_POST['arrData']['action']) && $_POST['arrData']['action']=='delete'){
			$_POST['user_id']=Core_Users::$info['id'];
			if( file_put_contents(
				Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
				Core_Users::$info['id'].PHP_EOL.'Project_Efunnel_Subscribers'.PHP_EOL.'cronDeleteContacts'.PHP_EOL.serialize( array_filter( $_REQUEST ) ) 
			) ){
				$this->objStore->toAction( 'contacts' )->set( array( 'msg'=>'Your contacts will now be removed from the selected funnel. It might take some time, so please check back in a while.' ) );
				$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
			}
			$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
		}
		if( !empty( $_POST ) ){
			if( $_POST['arrData']['action'] == 'remove' && !empty($_POST['arrData']['remove_email_funnels']) ){
				$_model=new Project_Efunnel_Subscribers(Core_Users::$info['id']);
				$_model->withEfunnelIds( $_POST['arrData']['remove_email_funnels'] )->withIds( $_POST['arrData']['subscribers'] )->getList( $arrContact );
				$_arrUpdate=array();
				foreach( $arrContact as $_contact ){
					foreach( $_contact['efunnel_events'] as $_event_id=>$_item ){
						if( empty( $_item['message_id'] ) && $_item['ef_id'] == $_POST['arrData']['remove_email_funnels'] ){
							$_event_id = explode('_', $_event_id)[0];
							$_arrUpdate[]='campaign_type="'.Project_Subscribers_Events::EF_REMOVED_ID.'" WHERE campaign_id="'.$_event_id.'" AND campaign_type="'.Project_Subscribers_Events::EF_ID.'" AND sub_id="'. $_contact['id'] .'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
						}
					}
				}
				try {
					Core_Sql::setConnectToServer( 'lpb.tracker' );
					//========
					foreach( $_arrUpdate as $_action ){
						Core_Sql::setExec( 'UPDATE s8rs_events_'.Core_Users::$info['id'].' SET '.$_action );
					}
					//========
					Core_Sql::renewalConnectFromCashe();
				} catch(Exception $e) {
					Core_Sql::renewalConnectFromCashe();
				}
				$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
			}
			if( $_POST['arrData']['action'] == 'export' ){
				$_model=new Project_Efunnel_Subscribers(Core_Users::$info['id']);
				if( isset( $_POST['arrData']['withTags'] ) ){
					$_model->withTags( $_POST['arrData']['withTags'] );
				}
				if( !empty( $_POST['arrData']['withEF'] ) ){
					$_model->withEfunnelIds( $_POST['arrData']['withEF'] );
				}	
				if( !empty( $_POST['arrData']['withStatus'] ) ){
					$_model->withStatusMessage( $_POST['arrData']['withStatus'] );
				}
				$_model->noEvents();
				if( isset( $_POST['arrData']['update_all'] ) && $_POST['arrData']['update_all']=='1' ){
					$_model->getList( $_arrSubscribers );
				}else{
					$_model->withIds( $_POST['arrData']['subscribers'] )->getList( $_arrSubscribers );
				}
				foreach ($_arrSubscribers as $key => $row){
					$_content .= $row['email'] . ',' . $row['name'] . ',"' . implode(",", $row['tags']) . '"'.PHP_EOL;
				}
				ob_end_clean();
				header( "Content-type: application/octet-stream" );
				header( "Content-disposition: attachment; filename=contact-list".date('Y-m-d').".csv");
				echo $_content;
				die();
			}
			if( $_POST['arrData']['action'] == 'csv' || $_POST['arrData']['action'] == 'csv_onlyimport'){
				if( $_POST['arrData']['legally'] != 1 && $_POST['arrData']['terms'] != 1 ) return;
				if( empty( $_POST['arrData']['email_funnels'] ) && $_POST['arrData']['action'] == 'csv' ) return;
				if( !empty( $_FILES['csv'] ) ){
					$_postTags=$_efunnelTags=$_arrEFunnel=$importRow=array();
					if( !empty( $_POST['arrData']['email_funnels'] ) ){
						//$importRow['sender_id']=$_POST['arrData']['email_funnels'];
						$_funnel=new Project_Efunnel();
						$_funnel->onlyOwner()->onlyOne()->withIds( $_POST['arrData']['email_funnels'] )->getList( $_arrEFunnel );
						if( isset( $_arrEFunnel['options']['tags'] ) && !empty( $_arrEFunnel['options']['tags'] ) ){
							$_efunnelTags=explode( ',', $_arrEFunnel['options']['tags'] );
							foreach( $_efunnelTags as &$_tagN ){
								$_tagN=trim($_tagN," '");
							}
							unset( $_tagN );
						}
					}
					if( isset( $_POST['arrData']['tags'] ) && !empty( $_POST['arrData']['tags'] ) ){
						$_postTags=explode( ',', $_POST['arrData']['tags'] );
						foreach( $_postTags as &$_tagN ){
							$_tagN=trim($_tagN," '");
						}
						unset( $_tagN );
					}
					$filename = Core_Files::getBaseName( $_FILES['csv']['name'] );
					$tmppath = Zend_Registry::get('config')->path->absolute->user_files.'temp/'.$filename;
					if( copy( $_FILES['csv']['tmp_name'], $tmppath ) ){
						$_time=time();
						if( ( $handle = fopen( $tmppath , "r") ) !== false ){
							// парсим csv в массив
							$_arrSaveList=array_map('str_getcsv', file( $tmppath ));
							// получаем шапку, и определяем email и tag записи
							$header=array_shift($_arrSaveList);
							if( is_array( $header ) ){
								$_newHeader=array();$_flgUpdateHeader=false;
								foreach( $header as $_key=>$_value ){
									if( filter_var($_value, FILTER_VALIDATE_EMAIL) || strpos( $_value, '@' )!==false ){
										$_newHeader[$_key]='email';
										$_flgUpdateHeader=true;
									}else{
										if( count( $header ) == 2 ){
											$_newHeader[$_key]='tags';
										}else{
											$_newHeader[$_key]=$_key;
										}
									}
								}
								if( $_flgUpdateHeader ){
									$_arrSaveList=array_merge( $_arrSaveList, array( $header ) );
									$header=$_newHeader;
								}
							}
							foreach( $header as &$_headerTag ){
								if( in_array( trim( strtolower( $_headerTag ) ), array( 'email address', 'email', 'user email' ) ) || strpos( trim( strtolower( $_headerTag ) ), 'email' ) ){
									$_headerTag='email';
								}
							}
							unset( $_headerTag );
							function _combine_array(&$row, $key, $header) {
								$row=array_combine($header, $row);
							}
							array_walk($_arrSaveList, '_combine_array', $header);
							$massImport=$_allTags=$_arrNewSave=array();
							foreach( $_arrSaveList as &$_newS8r ){
								if( !isset( $_newS8r['email'] ) ){
									continue;
								}
								if( strpos( $_newS8r['email'], ';' )!==false ){
									$_arrEData=explode( ';', $_newS8r['email'] );
									$_newS8r['email']=$_arrEData[0];
									$_newS8r['tags']=$_arrEData[1];
								}
								$_csvTags=array();
								if( strpos( $_newS8r['tags'], ',' ) && isset( $_newS8r['tags'] ) && !empty( $_newS8r['tags'] ) ){
									$_csvTags=explode( ',', trim( $_newS8r['tags'], '"') );
									foreach( $_csvTags as &$_tagN ){
										$_tagN=trim($_tagN," '");
									}
									unset( $_tagN );
								}
								$_newS8r['tags']=array_unique(array_merge($_csvTags, $_postTags, $_efunnelTags));
								foreach( $_newS8r['tags'] as &$_tagN ){
									$_tagN=trim($_tagN," '");
								}
								unset( $_tagN );
								$_allTags=array_merge($_allTags, $_newS8r['tags']);
							}
							unset( $_newS8r );
							$_arrTags=Project_Tags::get( Project_Tags::set(array_unique($_allTags)) );
							foreach( $_arrSaveList as $_newS8r ){
								if( !isset( $_newS8r['email'] ) ){
									continue;
								}
								$importRow=array();
								$importRow['email']=strtolower( $_newS8r['email'] );
								$_setTags=array();
								foreach( $_arrTags as $_id=>$_name ){
									foreach( array_unique($_newS8r['tags']) as $_name2 ){
										if( $_name==$_name2 ){
											$_setTags[]=$_id;
										}
									}
								}
								if( !empty( $_setTags ) ){
									$importRow['tags']=','.implode(',',$_setTags).',';
								}else{
									unset( $importRow['tags'] );
								}
								if( !empty( $_arrEFunnel ) ){
									$importRow['ef_id']=$_arrEFunnel['id'];
								}
								if( isset( $_newS8r['name'] ) && !empty( $_newS8r['name'] ) ){
									$importRow['name']=$_newS8r['name'];
								}
								if( isset( $_newS8r['ip'] ) && !empty( $_newS8r['ip'] ) ){
									$importRow['ip']=$_newS8r['ip'];
								}
								$massImport[]=$importRow;
							}
							$_import=new Project_Efunnel_Import();
							$_import->setEntered(array(
								'user_id'=>Core_Users::$info['id'],
								'email_list'=>base64_encode( serialize( $massImport ) ),
								'post'=>base64_encode( serialize( $_POST ) )
							))->set();
						}
						unlink( $tmppath );
					}
				}
				$this->objStore->toAction( 'contacts' )->set( array( 'msg'=>'Your import was successful! It\'s now pending approval by our team. It might take some time, so please check back in a while.' ) );
				$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
			}
			if( $_REQUEST['arrData']['action'] == 'email_funnels' ||  $_REQUEST['arrData']['action'] == 'quick_broadcast'){
				if( isset( $_POST['arrData']['update_all'] ) && $_POST['arrData']['update_all']=='1' ){
					unset( $_POST['arrData']['subscribers'] );
					unset( $_POST['arrData']['update_selected'] );
				}
				$_POST['arrData']=array_filter( $_POST['arrData'] );
				$_POST['user_id']=Core_Users::$info['id'];
				if( file_put_contents(
					Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
					Core_Users::$info['id'].PHP_EOL.'Project_Efunnel_Subscribers'.PHP_EOL.'cronUpdateContacts'.PHP_EOL.serialize( array_filter( $_REQUEST ) ) 
				) ){
					$this->objStore->toAction( 'contacts' )->set( array( 'msg'=>'Your contacts will now be added to the selected funnel. It might take some time, so please check back in a while.' ) );
					$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
				}
			}
			if( $_REQUEST['arrData']['action'] == 'add_tag' ){
				if( isset( $_POST['arrData']['update_all'] ) && $_POST['arrData']['update_all']=='1' ){
					unset( $_POST['arrData']['subscribers'] );
					unset( $_POST['arrData']['update_selected'] );
				}
				$_POST['arrData']=array_filter( $_POST['arrData'] );
				$_POST['user_id']=Core_Users::$info['id'];
				if( file_put_contents(
					Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
					Core_Users::$info['id'].PHP_EOL.'Project_Efunnel_Subscribers'.PHP_EOL.'cronUpdateContacts'.PHP_EOL.serialize( array_filter( $_REQUEST ) ) 
				) ){
					$this->objStore->toAction( 'contacts' )->set( array( 'msg'=>'Your contacts will now be added to the selected funnel. It might take some time, so please check back in a while.' ) );
					$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
				}
			}
			if( $_REQUEST['arrData']['action'] == 'remove_tag' ){
				if( isset( $_POST['arrData']['update_all'] ) && $_POST['arrData']['update_all']=='1' ){
					unset( $_POST['arrData']['subscribers'] );
					unset( $_POST['arrData']['update_selected'] );
				}
				$_POST['arrData']=array_filter( $_POST['arrData'] );
				$_POST['user_id']=Core_Users::$info['id'];
				if( file_put_contents(
					Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
					Core_Users::$info['id'].PHP_EOL.'Project_Efunnel_Subscribers'.PHP_EOL.'cronUpdateContacts'.PHP_EOL.serialize( array_filter( $_REQUEST ) ) 
				) ){
					$this->objStore->toAction( 'contacts' )->set( array( 'msg'=>'Your contacts will now be added to the selected funnel. It might take some time, so please check back in a while.' ) );
					$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
				}
			}
			if( isset( $_POST['action_edit_settings'] ) && !empty( $_POST['action_edit_settings'] ) ){
				$_arrSettings=array();
				foreach( $_POST['arrDetails'] as $_dname=>$_dvalue ){
					$_arrSettings[$_dname]=$_dvalue;
				}
				foreach( $_POST['arrAddDetails']['name'] as $_akey=>$_avalue ){
					$_arrSettings[$_avalue]=$_POST['arrAddDetails']['name'][$_akey];
				}
				$_model=new Project_Efunnel_Subscribers(Core_Users::$info['id']);
				$_model->setEmailSettings( $_POST['arrSettings']['id'], $_POST['arrSettings'], $_arrSettings );

				$this->objStore->toAction( 'contacts' )->set( array( 'msg'=>'Your contacts will now be updated.' ) );
				$this->location( array( 'action' => 'contacts', 'wg' => array( 'page'=> $_REQUEST['page'] ) ) );
			}
			if( $_POST['arrData']['action'] == 'validate' ){
				$_obj=new Project_Thechecker();
				$_model=new Project_Efunnel_Subscribers(Core_Users::$info['id']);
				if( isset( $_POST['arrData']['withTags'] ) ){
					$_model->withTags( $_POST['arrData']['withTags'] );
				}
				if( !empty( $_POST['arrData']['withEF'] ) ){
					$_model->withEfunnelIds( $_POST['arrData']['withEF'] );
				}	
				if( !empty( $_POST['arrData']['withStatus'] ) ){
					$_model->withStatusMessage( $_POST['arrData']['withStatus'] );
				}
				if( isset( $_POST['arrData']['update_all'] ) && $_POST['arrData']['update_all']=='1' ){
					$_model->getList( $_arrSubscribers );
				}else{
					$_model->withIds( $_POST['arrData']['subscribers'] )->getList( $_arrSubscribers );
				}
				foreach ($_arrSubscribers as &$item){
					$_arrEmails[$item['email']]=$item['email'];
				}
				$_status=0;
				$_valid=new Project_Validations();
				if( !$_valid->getPayment( count( $_arrEmails ) ) ){
					$_status=2;
					$_return=array( 'message'=>'Have no credits' );
				}else{
					$_return=$_obj->sendList(array_values( $_arrEmails ));
				}
				if( !isset( $_return['message'] ) ){
					$_valid->setEntered( array(
						'name'=>'Email Funnel Validation #'.@$_return['id'],
						'id_checker'=>@$_return['id'],
						'options'=>$_return+array( 'update_status'=>true ),
						'type'=>Project_Validations::CNM_LIST
					) )->set();
					$this->out['msg']='Validation project was successfully created. You would be able to see results in Verifications section of Validate module.';
				}else{
					$this->out['error']=$_return['message'];
				}
			}
		}
		foreach( $this->out['arrList'] as $key=>&$_contact ){
			if( !isset( $_contact['sender_id'] ) ){
				$_contact['sender_id']=array();
			}
			if( !isset( $_contact['options'] ) ){
				$_contact['options']=array();
			}
			if( !isset( $_contact['status'] ) || empty( $_contact['status'] ) ){
				$_contact['status']='Not Validated';
			}
			if( isset( $_contact['efunnel_events'] ) ){
				foreach( $_contact['efunnel_events'] as $removeKey=>&$_arrContact ){
					if( isset( $_arrContact['ef_id'] ) ){
						if( isset( $_arrContact['flg_type'] ) && $_arrContact['flg_type']==Project_Subscribers_Events::EF_ID ){
							$_contact['flg_subscribed'][$_arrContact['ef_id']]=true;
						}else{
							$_contact['flg_have_emails'][$_arrContact['ef_id']]=true;
						}
						$_contact['flg_ef']=true;
						$_contact['sender_id'][]=$_arrContact['ef_id'];
					}
					$_contact['options']=((is_array($_contact['options']))?$_contact['options']:array())+((is_array($_arrContact['options']))?$_arrContact['options']:array());
					$_contact['delivered']=$_contact['delivered']+$_arrContact['delivered'];
					$_contact['bounced']=$_contact['bounced']+$_arrContact['bounced'];
					$_contact['spam']=$_contact['spam']+$_arrContact['spam'];
					$_contact['opened']=$_contact['opened']+$_arrContact['opened'];
					$_contact['clicked']=$_contact['clicked']+$_arrContact['clicked'];
				}
				$_contact['sender_id']=array_unique( array_filter( $_contact['sender_id'] ) );
			}
		}

		$membership = new Project_Deliver_Membership();
		$membership
			->onlyOwner()
			->withSiteName()
			->getList($this->out['arrMembership']);
	}

	public function getcode(){
		if( isset( Core_Users::$info['id'] ) && !empty( Core_Users::$info['id'] ) ){
			$this->out['code'] = Core_Payment_Encode::encode( array( 'id' => $_GET['getcode'], 'user_id'=>Core_Users::$info['id'] ) );
			$_funnel=new Project_Efunnel();
			$_funnel->onlyOne()->withIds( $_GET['getcode'] )->getList( $_arrEFunnel );
			if( isset( $_arrEFunnel['options']['tags'] ) && !empty( $_arrEFunnel['options']['tags'] ) ){
				$this->out['tags']=$_arrEFunnel['options']['tags'];
			}
		}
		if( !empty( $_POST ) ){
			// это будет приходить только от qjmpz
			$_POST['code'] = Core_Payment_Encode::decode( $_POST['code'] );
			if( !isset( $_POST['code']['user_id'] ) ||  !isset( $_POST['code']['id'] ) ){
				// багованная шифровка
				echo 'false';
				exit;
			}
			Core_Users::getInstance()->setById( $_POST['code']['user_id'] );
			$_settings=$_POST;
			$_postTags=$_efunnelTags=array();
			$_funnel=new Project_Efunnel();
			$_funnel->onlyOne()->withIds( $_POST['code']['id'] )->getList( $_arrEFunnel );
			$_rtValidation=array('status'=>'','status_data'=>time());
			if( Project_Validations_Realtime::check( $_POST['code']['user_id'], Project_Validations_Realtime::EMAIL_FUNNEL, $_POST['code']['id'] ) 
				&& isset( $_POST['email'] ) && !empty( $_POST['email'] )
			){
				$_valid=new Project_Validations();
				$_status=2;
				$_valid->withName( $_POST['email'] )->onlyLast()->onlyOne()->getList( $_checked );
				if( (int)$_checked['added'] < time() - 24*60*60 ){
					$_status=3; // только что проверяли
					$_return=$_checked['options'];
				}
				if( $_status!=3 && $_valid->getPayment(1) ){
					$_status=1;
				}
				if( $_status == 1 ){
					$_obj=new Project_Thechecker();
					$_return=$_obj->checkOne( $_POST['email'] );
					if( !isset( $_return['message'] ) && isset( $_return['result'] ) ){
						$_valid->setEntered( array(
							'name'=>$_POST['email'],
							'options'=>$_return,
							'status'=>$_status,
							'type'=>Project_Validations::REAL_TIME
						) )->set();
						$_rtValidation['status']=$_return['result'];
						$_rtValidation['status_data']=time();
					}
				}
				if( $_status==2 || $_return['result'] == 'undeliverable' || $_return['result'] == 'unknown' ){
					echo 'This email address is not valid. Please provide a valid email address.<br data-id="'.htmlspecialchars( $_return['message'] ).'"/>';
					exit;
				}
			}
			if( isset( $_arrEFunnel['options']['tags'] ) && !empty( $_arrEFunnel['options']['tags'] ) ){
				$_efunnelTags=explode( ',', $_arrEFunnel['options']['tags'] );
			}
			if( isset( $_POST['tags'] ) && !empty( $_POST['tags'] ) ){
				$_postTags=explode( ',', $_POST['tags'] );
			}
			$_userTags=array_merge($_postTags, $_efunnelTags);
			foreach( $_userTags as &$_tag ){
				$_tag=trim($_tag);
			}
			$_userTags=','.implode( ',', array_unique($_userTags) ).',';
			unset( $_settings['email'] );
			unset( $_settings['code'] );
			unset( $_settings['tags'] );
			unset( $_settings['ef_redirect_url'] );
			$_intContactsLimit=0;
			try {
				Core_Sql::setConnectToServer( 'lpb.tracker' );
				$_intContactsLimit=Core_Sql::getRecord( 'SELECT COUNT(*) FROM s8rs_'.Core_Users::$info['id'] );
				Core_Sql::renewalConnectFromCashe();
			}catch(Exception $e){
				
			}
			if( $_intContactsLimit['COUNT(*)']+1 > Core_Users::$info['contact_limit'] ){
				Core_Users::getInstance()->retrieveFromCashe();
				echo 'false';
				exit;
				return false;
			}
			$_obj=new Project_Efunnel_Subscribers($_POST['code']['user_id']);
			$_obj->setEntered( array(
				'email' => $_POST['email'],
				'sender_id' => $_POST['code']['id'],
				'tags' => $_userTags,
				'ip' => $_POST['ip'],
			//	'settings'=>$_options
			)+$_rtValidation )->set();
			$_obj->getEntered( $_dataNew );
			Core_Users::getInstance()->retrieveFromCashe();
			echo 'true';
			exit;
		}
	}
	
	public function unsubscribe(){
		if( !isset( $_REQUEST['c'] ) || empty( $_REQUEST['c'] ) ){
			ob_clean();
			header('HTTP/1.1 404 Not Found');
			exit;
		}
		$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'EF_Debug_Unsubscribed.log' );
		$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
		$_logger=new Zend_Log( $_writer );
		if(isset($_POST['global_unsubscribe'])){
			$_data = Core_Payment_Encode::decode( $_REQUEST['c'] );
			$_subModel = new Project_Subscribers( $_data['user_id'] );
			if($_subModel->setEntered(array('email' => $_data['email'], 'flg_global_unsubscribe' => 1))->set()){
				$_subModel->getEntered($_subData);
				$_flgDone = true;
				try{
					Core_Sql::setExec( 'DELETE FROM lpb_efunnels_mailer WHERE email='.Core_Sql::fixInjection( $_data['email'] ) );
					Core_Sql::setConnectToServer( 'lpb.tracker' );
					//========
					$_paramIds=Core_Sql::getField('SELECT id FROM s8rs_events_'.$_data['user_id'].' WHERE sub_id='.$_subData['id'].' AND campaign_type IN ('.Project_Subscribers_Events::EF_ID.','.Project_Subscribers_Events::EF_UNSUBSCRIBE_ID.')');
					if( !empty( $_paramIds ) ){
						$_recordIds = Core_Sql::getField('SELECT id FROM s8rs_parameters_'.$_data['user_id'].' WHERE event_id IN ('.Core_Sql::fixInjection($_paramIds).')');
						$_logger->info(serialize( $_recordIds ));
						if( !empty( $_recordIds ) ){
							Core_Sql::setExec("DELETE FROM s8rs_parameters_" . $_data['user_id']." WHERE id IN (".Core_Sql::fixInjection($_recordIds).")");
						}
					}
					//========
					Core_Sql::renewalConnectFromCashe();
				}catch(Exception $e){
					Core_Sql::renewalConnectFromCashe();
					$_logger->info( $e->getMessage() );
				}
				if($_flgDone){
					$out['message'] = array(
						'status' => 'success',
						'header' => 'Successfully done',
						'text' => 'Now you are unsubscribed from all mailings.'
					);
				} else {
					$out['message'] = array(
						'status' => 'danger',
						'header' => 'Error',
						'text' => 'Try again later.'
					);
				}
				echo serialize( (isset($out) ? $out : array()) );
				exit();
			}
		}
		$_arrList=array();
		$_out['arrData']=Core_Payment_Encode::decode( $_REQUEST['c'] );
		$_out['strCode']=$_REQUEST['c'];
		$_model=new Project_Efunnel_Subscribers( $_out['arrData']['user_id'] );
		$_model
			->withEmail( $_out['arrData']['email'] )
			->getList( $_arrList );
		$_efIds=Core_Sql::getField('SELECT ef_id FROM lpb_efunnels_mailer WHERE email='.Core_Sql::fixInjection( $_out['arrData']['email'] ) );
		$_logger->info( 'SELECT ef_id FROM lpb_efunnels_mailer WHERE email='.Core_Sql::fixInjection( $_out['arrData']['email'] ) );
		$_logger->info( serialize($_efIds) );
		if( count( $_arrList ) == 0 ){
			header('HTTP/1.1 404 Not Found');
			exit;
		}
		$_arrEfunnels=$_nextMessage=$_out['efunnelsList']=$_out['efunnelsUnubscribed']=array();
		if( !empty( $_efIds ) ){
			$_model=new Project_Efunnel();
			$_model
				->withIds( $_efIds )
				->getList( $_arrEfunnels );
		}
		foreach( $_arrEfunnels as &$_efunnel ){
			unset( $_efunnel['message'] );
			if( $_efunnel['type'] != 1 ){
				$_out['efunnelsList'][ $_efunnel['id'] ]=$_efunnel+array( 'subscribed'=>$_out['efunnelsList'][ $_efunnel['id'] ] );
			}
		}
		$_logger->info( serialize($_out) );
		if( isset( $_POST['c'] ) && !empty( $_POST['c'] ) ){
			$_model=new Project_Efunnel();
			$_model
				->withIds( array_keys( $_POST['flg_subscribe'] ) )
				->getList( $_arrEfunnels );
			$_subscribers=new Project_Efunnel_Subscribers($_out['arrData']['user_id']);
			$_subscribers
				->withEmail( $_out['arrData']['email'] )
				->getList( $_arrMessages );
			$_arrUpdate=array();
			foreach( $_arrEfunnels as $_efId=>&$_efunnel ){
				if( $_out['efunnelsList'][$_efunnel['id']] == 0 && $_POST['flg_subscribe'][$_efunnel['id']] == 1 ){
					foreach( $_arrMessages as $_mess ){
						foreach( $_mess['efunnel_events'] as $_event_id=>$_item ){
							$_event_id=explode( '_', $_event_id );
							$_event_id=$_event_id[0];
							
							if( $_item['ef_unsubscribe_id'] == $_efunnel['id'] ){
								$_arrUpdate[]='campaign_type="'.Project_Subscribers_Events::EF_ID.'" WHERE id="'.$_event_id.'" AND campaign_type="'.Project_Subscribers_Events::EF_UNSUBSCRIBE_ID.'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
								// добавляем новую подписку пользователю 
								foreach( $_arrList as $_statistic ){
									foreach( $_statistic['efunnel_events'] as $_item ){
										$_efId=( isset( $_item['ef_id'] )?$_item['ef_id']:( isset( $_item['ef_unsubscribe_id'] )? $_item['ef_unsubscribe_id']: false) );
										$_nextMessage[$_efId]=$_item['message_id'];
									}
								}
								$arrMailer=array(
									'email'=>$_arrList[0]['email'],
									'send_date'=>time(),
									'ef_id'=>$_item['ef_id'],
									'message_id'=>$_nextMessage[$_item['ef_id']],
								);
								$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'EF_Contacts_Remove.log' );
								$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
								$_logger=new Zend_Log( $_writer );
								$_logger->info('-------------email_funnels.class.php subscribe---------------');
								$_logger->info(serialize($_SERVER));
								$_logger->info(serialize($arrMailer));
								$_logger->info('-------------email_funnels.class.php subscribe---------------');
								$_mailer=new Project_Efunnel_Mailer();
								if( $_mailer->haveEmail2Ef($arrMailer['ef_id'], $arrMailer['email']) === false ){
									$_mailer->setEntered( $arrMailer )->set();
								}
								// ---------------------------------------
								$_out['efunnelsList'][$_efunnel['id']]=(string)time();
							}
						}
					}
				}
				if( $_out['efunnelsList'][$_efunnel['id']] != 0 && $_POST['flg_subscribe'][$_efunnel['id']] == 0 ){
					foreach( $_arrMessages as $_mess ){
						foreach( $_mess['efunnel_events'] as $_event_id=>$_item ){
							$_event_id=explode( '_', $_event_id );
							$_event_id=$_event_id[0];
							if( empty( $_item['message_id'] ) && $_item['ef_id'] == $_efunnel['id'] ){
								$_arrUpdate[]='campaign_type="'.Project_Subscribers_Events::EF_UNSUBSCRIBE_ID.'" WHERE id="'.$_event_id.'" AND campaign_type="'.Project_Subscribers_Events::EF_ID.'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
								// удаляем письмо из рассылки
								$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'EF_Contacts_Remove.log' );
								$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
								$_logger=new Zend_Log( $_writer );
								$_logger->info('-------------email_funnels.class.php unsubscribe---------------');
								$_logger->info(serialize($_SERVER));
								$_logger->info('DELETE FROM lpb_efunnels_mailer WHERE email='.Core_Sql::fixInjection( $_arrList[0]['email'] ).' AND ef_id='.Core_Sql::fixInjection( $_item['ef_id'] ));
								$_logger->info('-------------email_funnels.class.php unsubscribe---------------');
								Core_Sql::setExec( 'DELETE FROM lpb_efunnels_mailer WHERE email='.Core_Sql::fixInjection( $_arrList[0]['email'] ).' AND ef_id='.Core_Sql::fixInjection( $_item['ef_id'] ) );
								// ---------------------------------------
								$_out['efunnelsList'][$_efunnel['id']]=0;
							}
						}
					}
				}
			}
			try {
				Core_Sql::setConnectToServer( 'lpb.tracker' );
				//========
				foreach( $_arrUpdate as $_action ){
					Core_Sql::setExec( 'UPDATE s8rs_events_'.$_out['arrData']['user_id'].' SET '.$_action );
				}
				//========
				Core_Sql::renewalConnectFromCashe();
			} catch(Exception $e) {
				Core_Sql::renewalConnectFromCashe();
			}
			$_out['strCode']=Core_Payment_Encode::encode( array( 'email'=>$_out['arrData']['email'], 'user_id'=>$_out['arrData']['user_id'] ) );
		}
		//if( empty( array_keys( $_out['efunnelsList'] ) ) ){
		//	header('HTTP/1.1 404 Not Found');
		//	exit;
		//}
		$_codeEmail1=explode( '@', $_out['arrData']['email'] );
		$_codeEmail=$_codeEmail1[0][0].$_codeEmail1[0][1].'****';
		$_codeEmail.=$_codeEmail1[0][strlen($_codeEmail1[0])-2].$_codeEmail1[0][strlen($_codeEmail1[0])-1].'@';
		$_codeEmail2=explode( '.', $_codeEmail1[1] );
		$_codeEmail.=$_codeEmail2[0][0].'****.';
		unset( $_codeEmail2[0] );
		$_codeEmail.=implode( '.', $_codeEmail2 );
		$_out['arrData']['codedEmail']=$_codeEmail;
		$_out['test']=base64_encode(serialize($_out));
		echo serialize($_out);
		exit;
	}
}
?>