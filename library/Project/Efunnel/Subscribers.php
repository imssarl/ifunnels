<?php
class Project_Efunnel_Subscribers extends Core_Data_Storage{
	protected $_withEmail=array();
	protected $_withoutMessages=false;
	protected $_withSmtpId=false;
	protected $_withLead=false;
	protected $_withoutLead=false;
	protected $_withTags=false;
	protected $_withoutTags=false;
	protected $_withStatus=false;
	protected $_withTagsHeat=false;
	protected $_noEvents=false;
	protected $_withStatusMessage=false;
	protected $_withoutStatusMessage=false;
	protected $_withoutEfunnelIs=false;
	protected $_withoutEfunnels=false;
	protected $_withValidation=false;
	protected $_withoutValidation=false;
	protected $_getRandom2k=false;
	protected $_arrTagsHeat=false;
	protected $_withoutFlgGlobalUnsubscribe=false;
	protected $_onlyFlgGlobalUnsubscribe=false;
	protected $_withMembershipId = false;
	protected $_withoutMembershipId = false;
	const TIME_TODAY=1,TIME_YESTERDAY=2,TIME_LAST_7_DAYS=3,TIME_THIS_MONTH=4,TIME_LAST_MONTH=5,TIME_ALL=7, TIME_MINUTE=8, TIME_CUSTOM=9;
	protected $_userId=false;

	public function __construct( $_uid=false ){
		if( $_uid !== false ){
			$this->_userId=$_uid;
		}
	}
	
	public function setEmailSettings( $_emailId, $_defaultValues, $_settings=array() ){
		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			Core_Sql::setExec( 'UPDATE s8rs_'.Core_Users::$info['id'].' SET name='.Core_Sql::fixInjection( $_defaultValues['name'] ).', email='.Core_Sql::fixInjection( $_defaultValues['email'] ).', settings="'.base64_encode( serialize( $_settings ) ).'" WHERE id IN ('.Core_Sql::fixInjection( $_emailId ).')' );
			//========
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			Core_Sql::renewalConnectFromCashe();
			return false;
		}
		return false;
	}
	
	public function cronResendMessage( $_settings=array() ){
		if( !isset( $_settings['page'] ) ){
			return false;
		}
		$_model=new Project_Efunnel_Subscribers( Core_Users::$info['id'] );
		if( isset( $_settings['arrData']['withTags'] ) ){
			$_model->withTags( $_settings['arrData']['withTags'] );
		}
		if( !empty( $_settings['arrData']['withEF'] ) ){
			$_model->withEfunnelIds( $_settings['arrData']['withEF'] );
		}	
		if( !empty( $_settings['arrData']['withStatus'] ) ){
			$_model->withStatusMessage( $_settings['arrData']['withStatus'] );
		}
		$_model
			->withPaging( array(
				'url'=>array( 'page'=>$_settings['page'] ),
				'reconpage'=>1000
			) )
			->noEvents()
			->onlyValid();
		if( isset( $_settings['arrData']['update_all'] ) && $_settings['arrData']['update_all']=='1' ){
			$_model
				->getList( $_arrSubscribers );
		}else{
			$_model
				->withIds( $_settings['arrData']['subscribers'] )
				->getList( $_arrSubscribers );
		}
		if( count( $_arrSubscribers ) == 0 ){
			return false;
		}
		$_allTags=array();
		foreach($_arrSubscribers as &$item){
			if( isset( $_settings['arrData']['email_funnels'] ) && !empty( $_settings['arrData']['email_funnels'] ) ){
				$item['ef_id'] = $_settings['arrData']['email_funnels'];
			}
			if( isset( $_settings['arrData']['send'] ) && $_settings['arrData']['send']==1 && !empty( $_settings['arrData']['start'] ) ){
				$item['start'] = $_settings['arrData']['start']+date("O")*60*60+$_settings['arrData']['timezone']; // расчитываем рассылку по времени сервера, исходя из часовового пояса клиента
			}
			if( isset( $item['tags'] ) && is_array( $item['tags'] ) ){
				$_allTags=array_merge( $_allTags, $item['tags'] );
			}
			unSet( $item['settings'] );
			unSet( $item['id'] );
		}
		unset( $item );
		$_allTags=array_unique( $_allTags );
		foreach( $_allTags as $_tkey=>$_tag ){
			if( ctype_digit( $_tag ) ){
				unset( $_allTags[$_tkey] );
			}
		}
		$_arrNewTags=array();
		if( isset( $_settings['arrData']['tags'] ) && !empty( $_settings['arrData']['tags'] ) ){
			foreach( explode( ',', $_settings['arrData']['tags'] ) as $_strNewTagName ){
				$_arrNewTags[]=$_allTags[]=trim( $_strNewTagName );
			}
		}
		$_allTags=array_unique( $_allTags );
		$_allTagsIds=Project_Tags::set( $_allTags );
		$_allTags=array_flip( Project_Tags::get( $_allTagsIds ) );
		foreach( $_arrSubscribers as &$item ){
			if( isset( $item['tags'] ) && is_array( $item['tags'] ) ){
				foreach( $item['tags'] as $_tkey=>$_tag ){
					if( ctype_digit( $_tag ) ){
						unset( $item['tags'][$_tkey] ); // id убираем, т.к. их не расшифйровало на предыдущем этапе, значит таких тэгов нет
					}else{
						$item['tags'][$_tkey]=$_allTags[$_tag]; // буквы заменяем на id, для сохранения
					}
				}
				foreach( $_arrNewTags as $_addNewTag ){
					$item['tags'][]=$_allTags[$_addNewTag]; // добавляем id новых тэгов
				}
				if( !empty( $item['tags'] ) ){
					$item['tags']=','.implode( ',', array_unique( $item['tags'] ) ).',';
				}else{
					$item['tags']='';
				}
			}
		}
		unset( $item );
		if( $_model->setEntered( $_arrSubscribers )->setMass() ){
			return true;
		}
		return false;
	}

	public $cronErrorLog=array();

	public function cronUpdateContacts( $_settings=array() ){
		if (!isset($_settings['page'])) {
			$this->cronErrorLog[] = 'Empty page data';
			return false;
		}

		$_model = new Project_Efunnel_Subscribers(Core_Users::$info['id']);

		if (!empty($_settings['search'])) {
			$_model->withTags($_settings['search']);
		}

		if (!empty($_settings['email'])) {
			$_model->withEmail($_settings['email']);
		}

		if (!empty($_settings['arrFilter']['email_funnels'])) {
			if ($_settings['arrFilter']['email_funnels'] == 'ns') {
				$_funnel = new Project_Efunnel();
				$_funnel->onlyOwner()->onlyIds()->getList($_EFids);
				$_model->withoutEfunnelIs($_EFids);
			} else {
				// Is
				if (empty($_settings['arrFilter']['ft_email_funnels']) || $_settings['arrFilter']['ft_email_funnels'] == '1') {
					$_model->withEfunnelIds( $_settings['arrFilter']['email_funnels'] );
				}

				// Is Not
				if ($_settings['arrFilter']['ft_email_funnels'] == '2') {
					$_model->withoutEfunnels( $_settings['arrFilter']['email_funnels'] );
				}
			}
		}

		if (!empty($_settings['arrFilter']['lead_channels'])) {
			// Is
			if (empty($_settings['arrFilter']['ft_lead_channels']) || $_settings['arrFilter']['ft_lead_channels'] == '1') {
				$_model->withLead($_settings['arrFilter']['lead_channels']);
			}

			// Is Not
			if ($_settings['arrFilter']['ft_lead_channels'] == '2') {
				$_model->withoutLead( $_settings['arrFilter']['lead_channels'] );
			}	
		}

		if (!empty($_settings['arrFilter']['status']) && $_settings['arrFilter']['status'] != 'unsubscribe') {
			// Is
			if (empty($_settings['arrFilter']['ft_status']) || $_settings['arrFilter']['ft_status'] == '1') {
				$_model->withStatusMessage( $_settings['arrFilter']['status'] );
			}

			// Is Not
			if ($_settings['arrFilter']['ft_status'] == '2') {
				$_model->withoutStatusMessage( $_settings['arrFilter']['status'] );
			}
		}

		if (!empty($_settings['arrFilter']['status']) && $_settings['arrFilter']['status'] == 'unsubscribe') {
			$_model->onlyFlgGlobalUnsubscribe();
		} else {
			$_model->withoutFlgGlobalUnsubscribe();
		}

		if (!empty($_settings['arrFilter']['tags'])) {
			// Is
			if (empty($_settings['arrFilter']['ft_tags']) || $_settings['arrFilter']['ft_tags'] == '1') {
				$_model->withTags( $_settings['arrFilter']['tags'] );
			}

			// Is Not
			if ($_settings['arrFilter']['ft_tags'] == '2') {
				$_model->withoutTags( $_settings['arrFilter']['tags'] );
			}
		}

		if (!empty($_settings['arrFilter']['validation'])) {
			// Is
			if (empty($_settings['arrFilter']['ft_validation']) || $_settings['arrFilter']['ft_validation'] == '1') {
				$_model->withValidation( $_settings['arrFilter']['validation'] );
			}

			// Is Not
			if ($_settings['arrFilter']['ft_validation'] == '2') {
				$_model->withoutValidation( $_settings['arrFilter']['validation'] );
			}
		}

		if (!empty($_settings['arrFilter']['time'])) {
			$_model->withTime($_settings['arrFilter']['time'], $_settings['arrFilter']['time_start'], $_settings['arrFilter']['time_end']);
		}

		if (!empty($_settings['arrData']['withTags'])) {
			$_model->withTags($_settings['arrData']['withTags']);
		}

		if (empty($_settings['arrFilter']['email_funnels']) && !empty($_settings['arrData']['withEF'])) {
			$_model->withEfunnelIds($_settings['arrData']['withEF']);
		}

		if (!empty($_settings['arrData']['withStatus'])) {
			$_model->withStatusMessage($_settings['arrData']['withStatus']);
		}

		$_model
			->withPaging(array(
				'url'       => array('page' => $_settings['page']),
				'reconpage' => 500,
			))
			->noEvents()
			->onlyValid()
			->withTagsHeat();

		if (isset($_settings['arrData']['update_all']) && $_settings['arrData']['update_all'] == '1') {
			$_model
				->getList($_arrSubscribers);
		} else {
			$_model
				->withIds($_settings['arrData']['subscribers'])
				->getList($_arrSubscribers);
		}

		if (count($_arrSubscribers) == 0) {
			$this->cronErrorLog[] = 'No Subscribers Found';
			return false;
		}

		$_arrNewTag = $_allTags = array();
		if (isset($_settings['arrData']['quick_broadcast']) && !empty($_settings['arrData']['quick_broadcast'])) {
			$_settings['arrData']['email_funnels'] = $_settings['arrData']['quick_broadcast'];
		}

		if (isset($_settings['arrData']['email_funnels']) && !empty($_settings['arrData']['email_funnels'])) {
			$_funnel = new Project_Efunnel();
			$_funnel->onlyOne()->withIds($_settings['arrData']['email_funnels'])->getList($_arrEFunnel);
			if (isset($_arrEFunnel['options']['tags']) && !empty($_arrEFunnel['options']['tags'])) {
				$_arrNewTag = explode(',', $_arrEFunnel['options']['tags']);
			}
		}

		if (isset($_settings['arrData']['tags']) && !empty($_settings['arrData']['tags'])) {
			foreach (explode(',', $_settings['arrData']['tags']) as $_strNewTagName) {
				$_arrNewTag[] = trim($_strNewTagName);
			}
		}

		array_unique($_arrNewTag);
		$arrMailer = array();

		foreach($_arrSubscribers as &$item){
			foreach ($item['tags'] as &$_tagV) {
				$_tagV = trim($_tagV);
			}

			$item['tags'] = array_unique($item['tags']);
			if (isset($_settings['arrData']['email_funnels']) && !empty($_settings['arrData']['email_funnels'])) {
				$item['ef_id'] = $_settings['arrData']['email_funnels'];

			}

			if (isset($_settings['arrData']['send']) && $_settings['arrData']['send'] == 1 && !empty($_settings['arrData']['start'])) {
				// $item['start'] = $_settings['arrData']['start'] + date("O") * 60 * 60 + $_settings['arrData']['timezone']; // расчитываем рассылку по времени сервера, исходя из часовового пояса клиента
				$item['start'] = $_settings['arrData']['start'];
			}

			if (isset($item['tags']) && is_array($item['tags'])) {
				$_allTags = array_merge($_allTags, $item['tags'], $_arrNewTag);
			} else {
				$_allTags = array_merge($_allTags, $_arrNewTag);
			}

			$item['tags'] = array_unique(array_merge($item['tags'], $_arrNewTag));

			$_startDate = $item['start'];

			if (empty($_startDate)) {
				$_startDate = time();
			}
			if (!empty($item['ef_id'])) {
				$settings = unserialize(base64_decode($item['settings']));

				$arrMailer[$item['email']] = array(
					'ef_id'      => $item['ef_id'],
					'email'      => $item['email'],
					'send_date'  => $_startDate,
					'email_data' => is_array($settings) ? $settings + array('name' => $item['name']) : ['name' => $item['name']],
				);
			}

			unset($item['settings']);
			unset($item['id']);
		}

		unset($item);
		$_allTags       = array_unique($_allTags);
		$_allTagsIds    = Project_Tags::set($_allTags);
		$_removeTagsIds = array();
		if (isset($_settings['arrData']['tags_remove']) && !empty($_settings['arrData']['tags_remove'])) {
			$_removeTagsIds = Project_Tags::set($_settings['arrData']['tags_remove']);
		}

		$_allTags = array_flip(Project_Tags::get($_allTagsIds));

		foreach ($_arrSubscribers as &$item) {
			if (isset($item['tags']) && is_array($item['tags'])) {
				foreach ($item['tags'] as $_tkey => $_tag) {
					$flgRemoved = false;
					if (isset($_settings['arrData']['tags_remove']) && !empty($_settings['arrData']['tags_remove'])) {
						foreach (explode(',', $_settings['arrData']['tags_remove']) as $_strTagName) {
							if (trim($_strTagName) == $_tag) {
								Project_Automation::setEvent(Project_Automation_Event::$type['REMOVE_TAG'], $_tag, $item['email'], array('user_id' => Core_Users::$info['id']));
								unset($item['tags'][$_tkey]);
								$flgRemoved = true;
							}
						}
					}

					if (!$flgRemoved) {
					    // if( ctype_digit( $_tag ) ){
					    //     unset( $item['tags'][$_tkey] ); // id убираем, т.к. их не расшифйровало на предыдущем этапе, значит таких тэгов нет
					    // }else{
						$item['tags'][$_tkey] = $_allTags[$_tag]; // буквы заменяем на id, для сохранения
					    // }
					}
				}
				if (!empty($item['tags'])) {
					$item['tags'] = ',' . implode(',', array_filter(array_unique($item['tags']))) . ',';
				} else {
					$item['tags'] = '';
				}
			}
		}

		unset($item);

		if ($_model->setEntered($_arrSubscribers)->setMass()) {
			if (!empty($arrMailer)) {
				$_mailer = new Project_Efunnel_Mailer();

				if (!$_mailer->setEntered(array_unique($arrMailer, SORT_REGULAR))->setMass()) {
					$this->cronErrorLog[] = 'Set Mass Mailer not work';
					return false;
				}
			}
			return true;
		}
		$this->cronErrorLog[] = 'Set Mass not work';
		return false;
	}

	public function cronReturnContactsToCampaign( $_settings=array() ){
		if (!isset($_settings['page'])) {
			$this->cronErrorLog[] = 'Empty page data';
			return false;
		}

		$_model = new Project_Efunnel_Subscribers(Core_Users::$info['id']);

		$_model
			->withEfunnelIds($_settings['id'])
			->withoutFlgGlobalUnsubscribe()
			->withPaging(array(
				'url'       => array('page' => $_settings['page']),
				'reconpage' => 500,
			))
			->onlyValid()
			->withTagsHeat()
			->getList($_arrSubscribers);

		$_funnel = new Project_Efunnel();
		$_funnel
			->onlyOne()
			->withIds($_settings['id'])
			->getList($_arrEFunnel);

		$_messList = array();

		foreach ($_arrEFunnel['message'] as &$_mess) {
			unset($_mess['body_html'], $_mess['body_plain_text'], $_mess['subject'], $_mess['added'], $_mess['edited']);
			$_messList[$_mess['position']] = $_mess;
		}

		if (count($_arrSubscribers) == 0) {
			$this->cronErrorLog[] = 'No Subscribers Found';
			return false;
		}

		$_arrNewTag = $_allTags = array();
		array_unique($_arrNewTag);
		$arrMailer = array();

		foreach ($_arrSubscribers as $item) {
			$_arrHaveMails = $_arrLastSend = array();
			$_flgSubscribe = false;

			foreach ($item['efunnel_events'] as $_events) {
				if ($_events['ef_id'] == $_settings['id']) {
					if (empty($_events['message_id'])) {
						$_flgSubscribe = true;
					} else {
						if (!isset($_arrHaveMails[$_events['message_id']])) {
							$_arrLastSend[$_events['message_id']] = $_arrHaveMails[$_events['message_id']] = 0;
						}

						$_arrHaveMails[$_events['message_id']]++;
						$_arrLastSend[$_events['message_id']] = $_events['added'];
					}
				}
			}

			$_messId = $_periodInHours = 0;
			if (end($_arrHaveMails) == 1 && $_arrEFunnel['options']['flg_resender'] == 1) {
				// переотправляем это письмо
				$_messId     = array_keys($_arrLastSend)[count($_arrLastSend) - 1];
				$_sendPeriod = (int) $_arrEFunnel['options']['resender_time'];
			} else {
				$_flgGetNext = false;

				foreach ($_messList as $_mess) {
					if ($_flgGetNext || count($_arrLastSend) == 0) {
						$_messId     = $_mess['id'];
						$_sendPeriod = (int) $_mess['period_time'] * ($_mess['flg_period'] == 2 ? 24 : 1);
						break;
					}

					if ($_mess['id'] == array_keys($_arrLastSend)[count($_arrLastSend) - 1]) {
						$_flgGetNext = true;
					}
				}
			}

			if ($_messId !== 0) {
				$_mailer = new Project_Efunnel_Mailer();

				if ($_mailer->haveEmail2Ef($_settings['id'], $item['email']) === false) {
					$_mailer->setEntered(array(
						'ef_id'      => $_settings['id'],
						'message_id' => $_messId,
						'email'      => $item['email'],
						'send_date'  => (int) end($_arrLastSend) + $_sendPeriod * 60 * 60,
						'email_data' => unserialize(base64_decode($item['settings'])) + array('name' => $item['name']),
					))->set();
				}
			}
		}

		if (!empty($arrMailer)) {
			$_mailer = new Project_Efunnel_Mailer();
			if (!$_mailer->setEntered(array_unique($arrMailer, SORT_REGULAR))->setMass()) {
				$this->cronErrorLog[] = 'Set Mass Mailer not work';
				return false;
			}
			return true;
		}

		$this->cronErrorLog[] = 'Set Mass not work';
		return false;
	}
	
	public function cronDeleteContacts( $_settings=array() ){
		if( !isset( $_settings['page'] ) ){
			return false;
		}
		$_model=new Project_Efunnel_Subscribers( Core_Users::$info['id'] );
		$_funnel=new Project_Efunnel();
		$_funnel->onlyOwner()->onlyIds()->getList( $_EFids );
		
		if( !empty( $_settings['search'] ) ){
			$_model->withTags( $_settings['search'] );
		}
		if( !empty( $_settings['email'] ) ){
			$_model->withEmail( $_settings['email'] );
		}
		if( !empty( $_settings['arrFilter']['email_funnels'] ) ){
			if( $_settings['arrFilter']['email_funnels'] == 'ns' ){
				$_model->withoutEfunnelIs($_EFids);
			}else{
				// Is
				if (empty($_settings['arrFilter']['ft_email_funnels']) || $_settings['arrFilter']['ft_email_funnels'] == '1') {
					$_model->withEfunnelIds( $_settings['arrFilter']['email_funnels'] );
				}

				// Is Not
				if ($_settings['arrFilter']['ft_email_funnels'] == '2') {
					$_model->withoutEfunnels( $_settings['arrFilter']['email_funnels'] );
				}
			}
		}
		if( !empty( $_settings['arrFilter']['lead_channels'] ) ){
			// Is
			if (empty($_settings['arrFilter']['ft_lead_channels']) || $_settings['arrFilter']['ft_lead_channels'] == '1') {
				$_model->withLead($_settings['arrFilter']['lead_channels']);
			}

			// Is Not
			if ($_settings['arrFilter']['ft_lead_channels'] == '2') {
				$_model->withoutLead( $_settings['arrFilter']['lead_channels'] );
			}	
		}	
		if( !empty( $_settings['arrFilter']['status'] ) ){
			// Is
			if (empty($_settings['arrFilter']['ft_status']) || $_settings['arrFilter']['ft_status'] == '1') {
				$_model->withStatusMessage( $_settings['arrFilter']['status'] );
			}

			// Is Not
			if ($_settings['arrFilter']['ft_status'] == '2') {
				$_model->withoutStatusMessage( $_settings['arrFilter']['status'] );
			}
		}
		if( !empty( $_settings['arrFilter']['tags'] ) ){
			// Is
			if (empty($_settings['arrFilter']['ft_tags']) || $_settings['arrFilter']['ft_tags'] == '1') {
				$_model->withTags( $_settings['arrFilter']['tags'] );
			}

			// Is Not
			if ($_settings['arrFilter']['ft_tags'] == '2') {
				$_model->withoutTags( $_settings['arrFilter']['tags'] );
			}
		}
		if( !empty( $_settings['arrFilter']['validation'] ) ){
			// Is
			if (empty($_settings['arrFilter']['ft_validation']) || $_settings['arrFilter']['ft_validation'] == '1') {
				$_model->withValidation( $_settings['arrFilter']['validation'] );
			}

			// Is Not
			if ($_settings['arrFilter']['ft_validation'] == '2') {
				$_model->withoutValidation( $_settings['arrFilter']['validation'] );
			}
		}
		if( !empty( $_settings['arrFilter']['time'] ) ){
			$_model->withTime( $_settings['arrFilter']['time'], $_settings['arrFilter']['time_start'], $_settings['arrFilter']['time_end'] );
		}
		if( !empty( $_settings['arrData']['withTags'] ) ){
			$_model->withTags( $_settings['arrData']['withTags'] );
		}
		if( !empty( $_settings['arrData']['withEF'] ) ){
			$_model->withEfunnelIds( $_settings['arrData']['withEF'] );
		}	
		if( !empty( $_settings['arrData']['withStatus'] ) ){
			$_model->withStatusMessage( $_settings['arrData']['withStatus'] );
		}
		/*
		if( isset( $_settings['arrFilter']['tags'] ) ){
			$_model->withTags( $_settings['arrFilter']['tags'] );
		}
		if( !empty( $_settings['arrFilter']['email_funnels'] ) ){
			if( $_settings['arrFilter']['email_funnels'] == 'ns' ){
				$_model->withoutEfunnelIs();
			}else{
				$_model->withEfunnelIds( $_settings['arrFilter']['email_funnels'] );
			}
		}	
		if( !empty( $_settings['arrFilter']['status'] ) ){
			$_model->withStatusMessage( $_settings['arrFilter']['status'] );
		}
		if( !empty( $_settings['arrFilter']['validation'] ) ){
			$_model->withValidation( $_settings['arrFilter']['validation'] );
		}
		*/
		$_model
			->withPaging( array(
				'url'=>array( 'page'=>1 ), // всегда запрашивать на удаление только 1 страницу
				'reconpage'=>1000
			) )
			->noEvents();
		if( isset( $_settings['arrData']['update_all'] ) && $_settings['arrData']['update_all']=='1' ){
			$_model
				->getList( $_arrSubscribers );
		}else{
			$_model
				->withIds( $_settings['arrData']['subscribers'] )
				->getList( $_arrSubscribers );
		}
		if( count( $_arrSubscribers ) == 0 ){
			return false;
		}
		$_s8rIds=$_s8rEmails=array();
		foreach($_arrSubscribers as $item){
			$_s8rIds[]=$item['id'];
			$_s8rEmails[]=$item['email'];
		}

		$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'EF_Contacts_Remove.log' );
		$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
		$_logger=new Zend_Log( $_writer );
		$_logger->info('-------------Project_Efunnel_Subscribers 1---------------');
		$_logger->info(serialize($_SERVER));
		$_logger->info('DELETE FROM s8rs_'.Core_Users::$info['id'].' WHERE id IN ('.Core_Sql::fixInjection( $_s8rIds ).')');
		$_logger->info('-------------Project_Efunnel_Subscribers 1---------------');

		if( !empty( $_s8rEmails ) && !empty( $_EFids ) ){
			Core_Sql::setExec( 'DELETE FROM lpb_efunnels_mailer WHERE email IN ('.Core_Sql::fixInjection( $_s8rEmails ).') AND ef_id IN('.Core_Sql::fixInjection( $_EFids ).')' );
		}
		
		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			Core_Sql::setExec( 'DELETE FROM s8rs_'.Core_Users::$info['id'].' WHERE id IN ('.Core_Sql::fixInjection( $_s8rIds ).')' );
			//========
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			Core_Sql::renewalConnectFromCashe();
			return false;
		}
		return true;
	}
	
	public function withStatus(){
		$this->_withStatus=true;
		return $this;
	}
	
	public function withTagsHeat(){
		$this->_withTagsHeat=true;
		$this->_arrTagsHeat=array();
		return $this;
	}
	
	public function noEvents(){
		$this->_noEvents=true;
		return $this;
	}
	
	public function withLead( $_arrIds=array() ){
		$this->_withLead=$_arrIds;
		return $this;
	}

	public function withoutLead( $_arrIds=array() ){
		$this->_withoutLead=$_arrIds;
		return $this;
	}
	
	public function withoutEfunnelIs( $_arrIds=array() ){
		$this->_withoutEfunnelIs=$_arrIds;
		return $this;
	}

	public function withoutEfunnels( $_arrIds=array() ){
		$this->_withoutEfunnels=$_arrIds;
		return $this;
	}
	
	public function withEfunnelIds( $_arrIds=array() ){
		$this->_withEfunnelIds=$_arrIds;
		return $this;
	}
	
	public function withEmail( $_arrIds=array() ){
		$this->_withEmail=$_arrIds;
		return $this;
	}
	
	public function withSmtpId( $_varIds ){
		$this->_withSmtpId = $_varIds;
		return $this;
	}
	
	public function withoutMessages(){
		$this->_withoutMessages=true;
		return $this;
	}

	public function withTags( $_tags, $full = false ){
		$this->_withTags = array_filter( explode( ',', trim( Project_Tags::check( $_tags, false, $full ), ',' ) ) );
		return $this;
	}

	public function withoutTags( $_tags ){
		$this->_withoutTags = array_filter( explode( ',', trim( Project_Tags::check( $_tags, false, $full ), ',' ) ) );
		return $this;
	}

	public function getRandom2k(){
		$this->_getRandom2k=true;
		return $this;
	}

	public function onlyValid(){
		$this->_onlyValid=true;
		return $this;
	}

	public function withStatusMessage( $status ){
		if( !empty( $status ) ){
			$this->_withStatusMessage=$status;			
		}
		return $this;
	}

	public function withoutStatusMessage( $status ){
		if( !empty( $status ) ){
			$this->_withoutStatusMessage=$status;			
		}
		return $this;
	}

	public function withValidation( $status ){
		if( !empty( $status ) ){
			$this->_withValidation=$status;			
		}
		return $this;
	}

	public function withoutValidation( $status ){
		if( !empty( $status ) ){
			$this->_withoutValidation=$status;			
		}
		return $this;
	}

	public function withTime( $_type, $_start=false, $_end=false ){
		$this->_withTime=$_type;
		if( $_start !== false && $_end !== false && $_type==self::TIME_CUSTOM ){
			$this->_withTimeStart=$_start;
			$this->_withTimeEnd=$_end;
		}
		return $this;
	}
	
	public function withoutFlgGlobalUnsubscribe(){
		$this->_withoutFlgGlobalUnsubscribe=true;
		return $this;
	}

	public function onlyFlgGlobalUnsubscribe(){
		$this->_onlyFlgGlobalUnsubscribe=true;
		return $this;
	}

	public function withMembershipId($id) {
		$this->_withMembershipId = $id;
		return $this;
	}

	public function withoutMembershipId($id) {
		$this->_withoutMembershipId = $id;
		return $this;
	}

	protected function init(){
		$this->_withEfunnelIds=array();
		$this->_withLead=array();
		$this->_withoutLead=array();
		$this->_withTime=false;
		$this->_withTimeStart=false;
		$this->_withTimeEnd=false;
		$this->_withEmail=false;
		$this->_withoutMessages=false;
		$this->_withSmtpId=false;
		$this->_withTags=false;
		$this->_withoutTags=false;
		$this->_withStatus=false;
		$this->_withoutStatusMessage=false;
		$this->_withTagsHeat=false;
		$this->_getRandom2k=false;
		$this->_onlyValid=false;
		$this->_withValidation=false;
		$this->_withoutValidation=false;
		$this->_noEvents=false;
		$this->_withoutEfunnelIs=false;
		$this->_withoutEfunnels=false;
		$this->_withoutFlgGlobalUnsubscribe=false;
		$this->_onlyFlgGlobalUnsubscribe=false;
		$this->_withMembershipId = false;
		$this->_withoutMembershipId = false;
	}

	private static $_code="ABCDEFGHIJKLMNOPQRSTUVWXYZ|abcdefghijklmnopqrstuvwxyz0123456789_.-~!*'();:@&=+$,/?#[]";
	private static $_decode="LfopqrsAlW8PQ:@&cXYZa]gSD67dEuv,/?#TUbm9_.-~!*'();+$=R5eBMw|xyz012FGHIJKt34hijkC[VNOn";
	
	/**
	Только для кодирования ссылок почтовиков
	 */
	public static function encode( $_array ){
		$_codeStr='';
		if( isset( $_array['smtpid'] ) && !empty( $_array['smtpid'] ) ){
			$_codeStr.=$_array['smtpid'];
		}
		if( isset( $_array['email'] ) && !empty( $_array['email'] ) ){
			$_codeStr.='|'.$_array['email'];
		}
		if( isset( $_array['user_id'] ) && !empty( $_array['user_id'] ) ){
			$_codeStr.='|'.$_array['user_id'];
		}
		if( isset( $_array['event'] ) && !empty( $_array['event'] ) ){
			$_codeStr.='|'.$_array['event'][0];
		}
		if( isset( $_array['link'] ) && !empty( $_array['link'] ) ){
			$_codeStr.='|'.$_array['link'];
		}
		if( isset( $_array['time'] ) && !empty( $_array['time'] ) ){
			$_codeStr.='|'.$_array['time'];
		}
		if( isset( $_array['subject'] ) && !empty( $_array['subject'] ) ){
			$_codeStr.='|'.$_array['subject'];
		}
		if( strlen( base64_encode( $_codeStr ) ) > 250 ){
			return Project_Coder::encode( $_codeStr );
		}else{
			$_codedStr='';
			for( $i=0; $i<strlen( $_codeStr ); $i++ ){
				$_codedStr.=self::$_decode[ strpos( self::$_code, $_codeStr[$i] ) ];
			}
			if( strlen( base64_encode( $_codedStr ) ) == 32 ){
				return Project_Coder::encode( $_codeStr );
			}
			return str_replace( '/', '^', base64_encode( $_codedStr ) );
		}
	}

	/**
	 * Decode str to array
	 * @static
	 * @param $_str
	 * @return array
	 */
	public static function decode( $_str ) {
		if( strlen( $_str ) == 32 ){
			$_parse=Project_Coder::decode( $_str );
		}else{
			$_codedStr=base64_decode( str_replace( '^', '/', $_str ) );
			$_decodedStr='';
			for( $i=0; $i<strlen( $_codedStr ); $i++ ){
				$_decodedStr.=self::$_code[ strpos( self::$_decode, $_codedStr[$i] ) ];
			}
			$_parse=$_decodedStr;
		}
		$_parse=explode( '|', $_parse );
		$_return=array();
		if( isset( $_parse[0] ) ){
			$_return['smtpid']=$_parse[0];
		}
		if( isset( $_parse[1] ) ){
			$_return['email']=$_parse[1];
		}
		if( isset( $_parse[2] ) ){
			$_return['user_id']=$_parse[2];
		}
		if( isset( $_parse[3] ) ){
			$_return['event']=( $_parse[3] == 'c' ? 'click' : 'open' );
		}
		if( isset( $_parse[4] ) && $_return['event']=='click' ){
			$_return['link']=$_parse[4];
			// remove bug
			if( $_return['link']=='https://www.crowdcast.io/e/going-from-zero-to-on' ){
				$_return['link']='https://www.crowdcast.io/e/going-from-zero-to-one';
			}
			//
			$_return['subject']=$_parse[5];
		}else{
			$_return['time']=$_parse[4];
			$_return['subject']=$_parse[5];
		}
		return $_return;
	}
	
	public function set() {
		$this->_data->setFilter( array( 'clear' ) );
		$_s8rObj=new Project_Subscribers( $this->_userId );
		// не забыть обработать тэги
		if( isset( $this->_data->filtered['tags'] ) && !empty( $this->_data->filtered['tags'] ) ){
			if( !is_array( $this->_data->filtered['tags'] ) && strpos( $this->_data->filtered['tags'], ',' ) !== false ){
				$this->_data->filtered['tags']=explode( ',', $this->_data->filtered['tags'] );
			}
			if( !is_array( $this->_data->filtered['tags'] ) && !empty( $this->_data->filtered['tags'] ) ){
				$this->_data->filtered['tags']=array( $this->_data->filtered['tags'] );
			}
			if(Core_Acs::haveAccess( array( 'Automate' ) )){
				Project_Automation::setEvent( Project_Automation_Event::$type['CONTACT_TAGGED'] , $this->_data->filtered['tags'], $this->_data->filtered['email'], array() );
			}
			$_s8rObj->withEmails( $this->_data->filtered['email'] )->onlyOne()->getList( $_arrSubscriber );
			$this->_data->filtered['tags']=array_merge( ( is_array( $this->_data->filtered['tags'] )?$this->_data->filtered['tags']:array() ), ( is_array( $_arrSubscriber['tags'] )?$_arrSubscriber['tags']:array() ) );
			$this->_data->setElement( 'tags', Project_Tags::set( $this->_data->filtered['tags'] ) );
			$this->_data->setFilter( array( 'clear' ) );
		}
		$_s8rObj->setEntered( $this->_data->filtered )->set();
		$_s8rObj->getEntered( $this->_data->filtered );
		if(Core_Acs::haveAccess( array( 'Automate' ) )){
			Project_Automation::setEvent( Project_Automation_Event::$type['CONTACT_CREATED'] , 1, $this->_data->filtered['email'], array() );
			Project_Automation::setEvent( Project_Automation_Event::$type['CONTACT_ADDED_EF'] , $this->_data->filtered['sender_id'], $this->_data->filtered['email'], array() );
		}
		$_eventObj=new Project_Subscribers_Events( $this->_userId );
		$_added=time();
		if( isset( $this->_data->filtered['added'] ) ){
			$_added=$this->_data->filtered['added'];
		}
		$_arrEvent=array(
			'sub_id'=>$this->_data->filtered['id'],
			'event_type'=>Project_Subscribers_Events::EMIAL_FUNNEL,
			'added'=>$_added,
			'campaign_type'=>Project_Subscribers_Events::EF_ID,
			'campaign_id'=>$this->_data->filtered['ef_id'],
			'search_text'=>array(),
			'param'=>array(),
		);
		// нужно передать параметры подписчика 
		$arrMailer=array(
			'email'=>$this->_data->filtered['email'],
			'send_date'=>time(),
			'email_data'=>$this->_data->filtered['options'],
			'ef_id'=>$this->_data->filtered['ef_id'],
		);
		if( isset( $this->_data->filtered['added'] ) ){
			$arrMailer['send_date']=$this->_data->filtered['added'];
		}
		if( isset( $this->_data->filtered['sender_id'] ) ){
			$arrMailer['ef_id']=$_arrEvent['campaign_id']=$this->_data->filtered['sender_id'];
		}
		if( isset( $this->_data->filtered['message_id'] ) ){
			$_arrEvent['search_int']=$this->_data->filtered['message_id'];
		}
		if( isset( $this->_data->filtered['smtp'] ) ){
			$_arrEvent['param']['smtp']=$this->_data->filtered['smtp'];
		}
		if( isset( $this->_data->filtered['smtpid'] ) ){
			$_arrEvent['search_var']=$this->_data->filtered['smtpid'];
		}
		if( isset( $this->_data->filtered['subject'] ) ){
			$_arrEvent['search_text']['subject']=$this->_data->filtered['subject'];
		}
		if( isset( $this->_data->filtered['smtp_message_id'] ) ){
			$_arrEvent['param']['smtp_message_id']=$this->_data->filtered['smtp_message_id'];
		}
		if( isset( $this->_data->filtered['delivered'] ) ){
			$_arrEvent['search_text']['delivered']=date( "Y-m-d", time());
		}
		if( isset( $this->_data->filtered['bounced'] ) ){
			$_arrEvent['search_text']['bounced']=date( "Y-m-d", time());
		}
		if( isset( $this->_data->filtered['spam'] ) ){
			$_arrEvent['search_text']['spam']=date( "Y-m-d", time());
		}
		if( isset( $this->_data->filtered['opened'] ) ){
			$_arrEvent['search_text']['opened']=date( "Y-m-d", time());
		}
		if( isset( $this->_data->filtered['clicked'] ) ){
			$_arrEvent['search_text']['clicked']=date( "Y-m-d", time());
		}
		if( isset( $this->_data->filtered['options'] ) ){
			$_arrEvent['param']['options']=$this->_data->filtered['options'];
		}
		if( !empty( $_arrEvent['search_text'] ) ){
			$_arrEvent['search_text']=json_encode( $_arrEvent['search_text'] );
		}else{
			unset( $_arrEvent['search_text'] );
		}
		$_eventObj->setEntered( $_arrEvent )->set();
		$_mailer=new Project_Efunnel_Mailer();
		if( $_mailer->haveEmail2Ef($arrMailer['ef_id'], $arrMailer['email']) === false ){
			$_mailer->setEntered( $arrMailer )->set();
		}
		return $this;
	}
	
	protected $_withSortOrder=' ORDER BY d.added DESC';
	
	public function withOrder( $_str='' ){
		if ( !empty( $_str ) ){
			$this->_withSortOrder=$_str;
		}else{
			return $this;
		}
		$this->_cashe['order']=$this->_withSortOrder;
		if ( !is_array( $this->_withSortOrder ) ) {
			$_arrOrd=array( $this->_withSortOrder );
		}
		foreach( $_arrOrd as $v ) {
			if ( $v=='rand' ) {
				$this->_withSortOrder=' ORDER BY RAND()';
			}else{
				$_arrPrt=explode( '--', $v );
				$this->_withSortOrder=' ORDER BY '.$_arrPrt[0].' '.( ( $_arrPrt[1]=='up' ) ? 'DESC':'ASC' );
			}
		}
		return $this;
	}

	public function withPaging( $_arr=array() ){
		$this->_withPaging=$_arr;
		if( !isset( $this->_withPaging['reconpage'] ) || empty( $this->_withPaging['reconpage'] ) ){
			$this->_withPaging['reconpage']=Zend_Registry::get( 'config' )->database->paged_select->row_in_page;
		}
		if( !isset( $this->_withPaging['numofdigits'] ) || empty( $this->_withPaging['numofdigits'] ) ){
			$this->_withPaging['numofdigits']=Zend_Registry::get( 'config' )->database->paged_select->num_of_digits;
		}
		if( !isset( $this->_withPaging['url']['page'] ) || empty( $this->_withPaging['url']['page'] ) ){
			$this->_withPaging['url']['page']=1;
		}
		return $this;
	}

	public function getPaging( &$arrRes ){
		$arrRes=array();
		if ( $this->page>1 ) { // у нас не первая страница
			$this->_withPaging['rec_from']=( ( $this->page-1 )*$this->_withPaging['reconpage'] )+1;
			$_intTest=$this->_withPaging['rec_from']+$this->_withPaging['reconpage']-1;
			$this->_withPaging['rec_to']=$this->_withPaging['rowtotal']>$_intTest?$_intTest:$this->_withPaging['rowtotal'];
		} else { // первая страница
			$this->_withPaging['rec_from']=1;
			$this->_withPaging['rec_to']=$this->_withPaging['rowtotal']>$this->_withPaging['reconpage']?$this->_withPaging['reconpage']:$this->_withPaging['rowtotal'];
		}
		$this->_withPaging['maxpage']=ceil( $this->_withPaging['rowtotal']/$this->_withPaging['reconpage'] );
		$arrRes['curpage']=$this->_withPaging['url']['page'];
		$arrRes['recall']=$this->_withPaging['rowtotal'];
		$arrRes['recfrom']=$this->_withPaging['rec_from'];
		$arrRes['recto']=$this->_withPaging['rec_to'];
		if ( !( $this->_withPaging['rowtotal']>$this->_withPaging['reconpage'] ) ) {
			return $this;
		}
		if( empty( array_diff_key( $this->_withPaging['url'], array( 'page' => '' ) ) ) ){
			$this->_withPaging['href'] = '?page=';
		} else {
			$this->_withPaging['href'] = '?' . http_build_query( array_diff_key( $this->_withPaging['url'], array( 'page' => '' ) ) ) .'&page=';
		}
		// calculate diapazon refaktoring TODO 04.12.2008
		$_intStart=$this->_withPaging['url']['page']-$this->_withPaging['numofdigits']/2;
		$_intEnd=$this->_withPaging['url']['page']+$this->_withPaging['numofdigits']/2;
		if ( $_intStart<1 ) {
			$_intStart=1;
			$_intEnd=$_intStart+$this->_withPaging['numofdigits'];
		}
		$_intEnd1=intVal( ( $this->_withPaging['rowtotal']-1 )/$this->_withPaging['reconpage'] );
		$_intEnd1++;
		if ( $_intEnd>$_intEnd1&&$_intStart>$_intEnd-$_intEnd1 ) {
			$_intEnd=$_intEnd1;
			$_intStart=$_intEnd-$this->_withPaging['numofdigits'];
		} elseif ( $_intEnd>$_intEnd1 ) {
			$_intEnd=$_intEnd1;
			$_intStart=1;
		}
		$arrRes['urlmin']=$this->_withPaging['href'].'1';
		if ( $this->_withPaging['url']['page']>$_intStart ){
			$arrRes['urlminus']=$this->_withPaging['href'].( $this->_withPaging['url']['page']-1 );
		}
		$b=0;
		for ( $a=intVal( $_intStart ); $a<=$_intEnd; $a++ ) {
			if ( $a==$this->_withPaging['url']['page'] ) $arrRes['num'][$b]['sel']=1;
			$arrRes['num'][$b]['url']=$this->_withPaging['href'].$a;
			$arrRes['num'][$b]['number']=$a;
			$b++;
		}
		if ( $this->_withPaging['url']['page']<$_intEnd ){
			$arrRes['urlplus']=$this->_withPaging['href'].( $this->_withPaging['url']['page']+1 );
		}
		$arrRes['urlmax']=$this->_withPaging['href'].$this->_withPaging['maxpage'];
		$arrRes['maxpage']=$this->_withPaging['maxpage'];
		$arrRes['href']=$this->_withPaging['href'];
		return $this;
	}
	
	public function getList( &$mixRes ){
		if( empty( $this->_userId ) ){
			$this->_userId=Core_Users::$info['id'];
		}
		$page='';
		if( !empty( $this->_withPaging ) ){
			$page=' LIMIT '.( $this->_withPaging['url']['page']>1?( ( $this->_withPaging['url']['page']-1 )*$this->_withPaging['reconpage'] ).','.$this->_withPaging['reconpage'] : $this->_withPaging['reconpage'] );
		}
		/** For delimiter parts */
		if( !empty( $this->_getRandom2k ) ){
			$this->_withSortOrder=' ORDER BY id ASC';
			if(file_exists(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt')){
				$_limit = explode(':', file_get_contents(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt'));
				$page=' LIMIT ' . $_limit[0] . ',300';
				$_limit[0] += 500;
				file_put_contents(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt', implode(':', $_limit));
			} else {
				$page=' LIMIT 0,300';
			}
		}

		/** Deliver */
		if (!empty($this->_withMembershipId)) {
			$crawler = new Core_Sql_Qcrawler();

			// SELECT
			$crawler->set_select('LOWER(c.email) AS email');

			// FROM OR JOIN
			$crawler->set_from('deliver_customer c');
			$crawler->set_from('LEFT JOIN deliver_plan_customer pc ON pc.customer_id = c.id');
			$crawler->set_from('LEFT JOIN deliver_subscription p ON p.customer_id = c.id');

			// WHERE
			$crawler->set_where('pc.membership_id IN (' . Core_Sql::fixInjection($this->_withMembershipId) . ')');
			$crawler->set_where('p.status IS NULL OR p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active']) . ')');

			// GROUP BY
			$crawler->set_group('c.id');

			$crawler->get_sql($sql_query, $arrPg);
			$this->_withMembershipId = array_column(Core_Sql::getAssoc($sql_query), 'email');

			if (empty($this->_withMembershipId)) {
				$this->_withMembershipId = null;
			}
		}

		/** Deliver */
		if (!empty($this->_withoutMembershipId)) {
			$crawler = new Core_Sql_Qcrawler();

			// SELECT
			$crawler->set_select('LOWER(c.email) AS email');

			// FROM OR JOIN
			$crawler->set_from('deliver_customer c');
			$crawler->set_from('LEFT JOIN deliver_plan_customer pc ON pc.customer_id = c.id');
			$crawler->set_from('LEFT JOIN deliver_subscription p ON p.customer_id = c.id');

			// WHERE
			$crawler->set_where('pc.membership_id NOT IN (' . Core_Sql::fixInjection($this->_withoutMembershipId) . ')');
			$crawler->set_where('p.status IS NULL OR p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active']) . ')');

			// GROUP BY
			$crawler->set_group('c.id');

			$crawler->get_sql($sql_query, $arrPg);
			$this->_withoutMembershipId = array_column(Core_Sql::getAssoc($sql_query), 'email');

			if (empty($this->_withoutMembershipId)) {
				$this->_withoutMembershipId = null;
			}
		}

		$_whereMass=$_tagsCounter=$_where=array();
		try{
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			if ( !empty( $this->_withTags ) ) {
				$_moreLikes=array();
				foreach( $this->_withTags as $_tagN ){
					if( !empty( $_tagN ) ){
						$_moreLikes[]= 'd.tags LIKE \'%,'.$_tagN.',%\'';
					}
				}
				if( !empty( $_moreLikes ) ){
					$_whereMass[]='('.implode( ' OR ', $_moreLikes ).')';
				}
			}

			if ( !empty( $this->_withoutTags ) ) {
				$_moreLikes=array();
				foreach( $this->_withoutTags as $_tagN ){
					if( !empty( $_tagN ) ){
						$_moreLikes[]= 'd.tags NOT LIKE \'%,'.$_tagN.',%\'';
					}
				}
				if( !empty( $_moreLikes ) ){
					$_whereMass[]='('.implode( ' AND ', $_moreLikes ).')';
				}
			}

			if( !empty( $this->_withEfunnelIds ) ){
				$_whereMass[]='( e.campaign_type="'.Project_Subscribers_Events::EF_ID.'" AND e.campaign_id IN ('.Core_Sql::fixInjection( $this->_withEfunnelIds ).') )';
			}
			if( !empty( $this->_withoutEfunnels ) ){
				$_arrNotUserIds=Core_Sql::getField( 'SELECT d.id AS id FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.campaign_type='.Project_Subscribers_Events::EF_ID.' AND e.campaign_id IN (' . Core_Sql::fixInjection($this->_withoutEfunnels) . ')' );
				$_whereMass[]='d.id NOT IN ('.Core_Sql::fixInjection( $_arrNotUserIds ).')';
			}
			if( !empty( $this->_withoutEfunnelIs ) ){
				// campaign_type="'.Project_Subscribers_Events::EF_ID.'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
				$_arrNotUserIds=Core_Sql::getField( 'SELECT d.id AS id FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.campaign_type='.Project_Subscribers_Events::EF_ID.' GROUP BY d.email' );
				$_whereMass[]='d.id NOT IN ('.Core_Sql::fixInjection( $_arrNotUserIds ).')';
			}
			switch( $this->_withTime ){
				case self::TIME_MINUTE :
					$_whereMass[]="DATE_FORMAT(FROM_UNIXTIME(d.added),'%Y-%m-%d-%H-%i')='".date('Y-m-d-H-i',time())."'";
					break;
				case self::TIME_TODAY :
					$_whereMass[]="DATE_FORMAT(FROM_UNIXTIME(d.added),'%Y-%m-%d')='".date('Y-m-d',time())."'";
					break;
				case self::TIME_YESTERDAY :
					$_whereMass[]="DATE_FORMAT(FROM_UNIXTIME(d.added),'%Y-%m-%d')='".date('Y-m-d',strtotime("yesterday"))."'";
					break;
				case self::TIME_LAST_7_DAYS :
					$_whereMass[]="d.added>'".( time()-(60*60*24*7) )."'";
					break;
				case self::TIME_THIS_MONTH :
					$_whereMass[]="DATE_FORMAT(FROM_UNIXTIME(d.added),'%Y-%m')='".date('Y-m',time())."'";
					break;
				case self::TIME_LAST_MONTH :
					$_whereMass[]="DATE_FORMAT(FROM_UNIXTIME(d.added),'%Y-%m')='".date('Y-m',strtotime('-1 month'))."'";
					break;
				case self::TIME_CUSTOM :
					$_whereMass[]="d.added>".$this->_withTimeStart." AND d.added<".$this->_withTimeEnd;
					break;
				case self::TIME_ALL :
				default:
				break;
			}
			if( !empty( $this->_withLead ) ){
				$_whereMass[]='( e.campaign_type='.Project_Subscribers_Events::LEAD_ID.' AND e.campaign_id IN ('.Core_Sql::fixInjection( $this->_withLead ).') )';
			}

			if( !empty( $this->_withoutLead ) ){
				$_whereMass[]='( e.campaign_type='.Project_Subscribers_Events::LEAD_ID.' AND e.campaign_id NOT IN ('.Core_Sql::fixInjection( $this->_withoutLead ).') )';
			}

			if( !empty( $this->_withStatusMessage ) ){
				if( in_array( $this->_withStatusMessage, array( 'notopened', 'notclicked' ) ) ){
					// campaign_type="'.Project_Subscribers_Events::EF_ID.'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
					$_haveEmails=Core_Sql::getField( 'SELECT d.email FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.search_text LIKE \'%"'.str_replace('not','',$this->_withStatusMessage).'"%\' GROUP BY d.email' );
					$_allEFEmails=Core_Sql::getField( 'SELECT d.email FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.campaign_type="'.Project_Subscribers_Events::EF_ID.'" GROUP BY d.email' );
					$_whereMass[]='( d.email IN ("'.implode( '","', array_diff( $_allEFEmails, $_haveEmails )).'") )';
				}else{
					$_whereMass[]='( e.search_text LIKE \'%"'.str_replace('not','',$this->_withStatusMessage).'"%\' )';
				}
			}

			if( !empty( $this->_withoutStatusMessage ) ){
				if( in_array( $this->_withoutStatusMessage, array( 'notopened', 'notclicked' ) ) ){
					// campaign_type="'.Project_Subscribers_Events::EF_ID.'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
					$_haveEmails=Core_Sql::getField( 'SELECT d.email FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.search_text NOT LIKE \'%"'.str_replace('not','',$this->_withoutStatusMessage).'"%\' GROUP BY d.email' );
					$_allEFEmails=Core_Sql::getField( 'SELECT d.email FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.campaign_type="'.Project_Subscribers_Events::EF_ID.'" GROUP BY d.email' );
					$_whereMass[]='( d.email IN ("'.implode( '","', array_diff( $_allEFEmails, $_haveEmails )).'") )';
				}else{
					$_whereMass[]='( e.search_text NOT LIKE \'%"'.str_replace('not','',$this->_withoutStatusMessage).'"%\' )';
				}
			}

			if( !empty( $this->_withSmtpId ) ){
				$_whereMass[]='( e.search_var IN ('.Core_Sql::fixInjection( $this->_withSmtpId ).') )';
			}
			if ( !empty( $this->_withEmail ) ){
				$_whereMass[]='d.email IN ('.Core_Sql::fixInjection( $this->_withEmail ).')';
			}
			if ( !empty( $this->_withIds ) ){
				$_whereMass[]='d.id IN ('.Core_Sql::fixInjection( $this->_withIds ).')';
			}

			if ( !empty( $this->_withValidation ) ){
				$_whereMass[]='d.status IN ('.Core_Sql::fixInjection( $this->_withValidation ).')';
			} elseif (!empty($this->_withoutValidation)) {
				$_whereMass[]='d.status NOT IN ('.Core_Sql::fixInjection( $this->_withoutValidation ).')';
			} 
			elseif ( !empty( $this->_onlyValid ) ){
				$_whereMass[]='d.status<>"not_valid"';
			}
			$_arrEvents=array();

			if ($this->_withMembershipId !== false) {
				$_whereMass[] = 'd.email IN (' . Core_Sql::fixInjection($this->_withMembershipId) . ')';
			}

			if ($this->_withoutMembershipId !== false) {
				$_whereMass[] = 'd.email IN (' . Core_Sql::fixInjection($this->_withoutMembershipId) . ')';
			}

			// TODO Пересоздал все уже созданные таблицы
			// $fields=Core_Sql::getField( 'DESCRIBE s8rs_'.$this->_userId );
			// if ( !in_array( 'status', $fields ) ){
			// 	Core_Sql::setExec('ALTER TABLE s8rs_'.$this->_userId.' ADD COLUMN status VARCHAR(15) NOT NULL DEFAULT \'\'');
			// 	Core_Sql::setExec('ALTER TABLE s8rs_'.$this->_userId.' ADD COLUMN status_data INT(11) UNSIGNED NOT NULL DEFAULT \'0\'');
			// }
			$_strStatus='';
			if ( !empty( $this->_withStatus ) ){
				$_strStatus=' ,d.status, d.status_data';
			}
			if ( $this->_withoutFlgGlobalUnsubscribe ){
				$_whereMass[]='d.flg_global_unsubscribe <> 1';
			}
			if ( $this->_onlyFlgGlobalUnsubscribe ){
				$_whereMass[]='d.flg_global_unsubscribe = 1';
			}
			$_joinEvents='';
			if( !empty($_whereMass) && strpos( implode( ' AND ', $_whereMass ), 'e.' ) !== false ){
				$events_type = [
					Project_Subscribers_Events::EF_ID,
					Project_Subscribers_Events::EF_UNSUBSCRIBE_ID,
					Project_Subscribers_Events::EF_REMOVED_ID,
					Project_Subscribers_Events::PAUSE_EF_ID,
					Project_Subscribers_Events::REMOVE_EF_ID
				];

				if ($this->_withLead || $this->_withoutLead) {
					$events_type[] = Project_Subscribers_Events::LEAD_ID;
				}

				$_whereMass[]='e.campaign_type IN (' . join(", ", $events_type) . ')';
				$_joinEvents=' JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id';
			}
			$this->_withPaging['rowtotal']=count( Core_Sql::getField( 'SELECT 1 FROM s8rs_'.$this->_userId.' d'.$_joinEvents.(!empty($_whereMass)?' WHERE ':'').implode( ' AND ', $_whereMass ).' GROUP BY d.email' ) );
			$mixRes=Core_Sql::getAssoc( 'SELECT d.id, d.email, d.ip, d.tags, d.name, d.settings, d.added, d.flg_global_unsubscribe'.$_strStatus.' FROM s8rs_'.$this->_userId.' d'.$_joinEvents.(!empty($_whereMass)?' WHERE ':'').implode( ' AND ', $_whereMass ).' GROUP BY d.email'.(!empty($this->_withSortOrder)?$this->_withSortOrder:'').$page );

			// p('SELECT d.id, d.email, d.ip, d.tags, d.name, d.settings, d.added, d.flg_global_unsubscribe'.$_strStatus.' FROM s8rs_'.$this->_userId.' d'.$_joinEvents.(!empty($_whereMass)?' WHERE ':'').implode( ' AND ', $_whereMass ).' GROUP BY d.email'.(!empty($this->_withSortOrder)?$this->_withSortOrder:'').$page);
			
			if( !$this->_noEvents ){
				$_subIds=array();
				foreach( $mixRes as $_data ){
					$_subIds[$_data['id']]=$_data['id'];
				}
				if( !empty( $_subIds ) ){
					$mixData=Core_Sql::getAssoc( 'SELECT e.sub_id, e.added, e.search_text, e.search_var, e.search_int, e.campaign_type, e.campaign_id FROM s8rs_'.$this->_userId.' d JOIN s8rs_events_'.$this->_userId.' e ON d.id=e.sub_id WHERE e.sub_id IN ('.Core_Sql::fixInjection( $_subIds ).')' );
				}
			}
			/** For delimiter parts */
			if($this->_getRandom2k){
				if(!file_exists(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt')){
					file_put_contents(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt', '500:' . $this->_withPaging['rowtotal']);
				} else {
					$_limit = explode(':', file_get_contents(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt'));
					$_limit[1] = $this->_withPaging['rowtotal'];
					file_put_contents(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt', implode(':', $_limit));
					if($_limit[0] >= $_limit[1]) {
						unlink(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR . 'delim_' . $this->_userId . '.txt');
					}
				}
			}
			//========
			Core_Sql::renewalConnectFromCashe();
		}catch( Exception $e ){
			file_put_contents(Zend_Registry::get('config')->path->absolute->logfiles.'errors_'.$this->_userId.'.txt', serialize($e));
			if( $e->getMessage() == 'SQLSTATE[HY000]: General error: 2006 MySQL server has gone away' ){
				Core_Sql::renewalConnectFromCashe();
				return $this;
			}
			$obj1=new Project_Subscribers( $this->_userId );$obj1->install();
			$obj2=new Project_Subscribers_Events( $this->_userId );$obj2->install();
			$obj3=new Project_Subscribers_Parameters( $this->_userId );$obj3->install();
			Core_Sql::renewalConnectFromCashe();
			return $this;
		}
		$_tagsIds=$_combineEvents=array();

		foreach( $mixRes as &$_data ){
			$_data['efunnel_events']=array();
			foreach( $mixData as $_efdata ){
				if( $_efdata['sub_id'] == $_data['id'] ){
					$_mid=0;
					if( isset( $_efdata['search_int'] ) && !empty( $_efdata['search_int'] ) ){
						$_mid=$_efdata['search_int'].'_'.$_efdata['added'];
					}
					$_data['efunnel_events'][$_efdata['campaign_id'].'_'.$_mid]=array(
						'added'=>$_efdata['added'],
						'message_id'=>@$_efdata['search_int'],
						'flg_type'=>$_efdata['campaign_type']
					);
					if( $_efdata['campaign_type'] == Project_Subscribers_Events::EF_UNSUBSCRIBE_ID
						|| $_efdata['campaign_type'] == Project_Subscribers_Events::EF_REMOVED_ID
						|| $_efdata['campaign_type'] == Project_Subscribers_Events::PAUSE_EF_ID
						|| $_efdata['campaign_type'] == Project_Subscribers_Events::REMOVE_EF_ID
					){
						$_data['efunnel_events'][$_efdata['campaign_id'].'_'.$_mid]['ef_unsubscribe_id']=$_efdata['campaign_id'];
					}elseif( $_efdata['campaign_type'] == Project_Subscribers_Events::EF_ID ){
						$_data['efunnel_events'][$_efdata['campaign_id'].'_'.$_mid]['ef_id']=$_efdata['campaign_id'];
					}
					if( !empty( $_efdata['search_text'] ) ){
						$_searchData=json_decode( $_efdata['search_text'] );
						foreach( $_searchData as $_evName=>$_evValue ){
							if( $_evName != 'subject' ){
								$_data['efunnel_events'][$_efdata['campaign_id'].'_'.$_mid][$_evName]=1;
								$_data['efunnel_events'][$_efdata['campaign_id'].'_'.$_mid][$_evName.'_added']=$_evValue;
							}else{
								$_data['efunnel_events'][$_efdata['campaign_id'].'_'.$_mid][$_evName]=$_evValue;
							}
						}
					}
				}
			}
		}

		foreach( $mixRes as &$_data ){
			if( strpos( $_data['tags'], ',' ) !== false ){
				$_data['tags']=array_filter( explode( ',', trim( $_data['tags'], ',' ) ) );
			}
			if( !empty( $_data['tags'] ) && !in_array( $_data['tags'], $_tagsIds ) ){
				foreach( $_data['tags'] as $_tagId ){
					$_tagsIds[$_tagId]=$_tagId;
				}
			}
		}
		unset( $_data );
		$_arrTag2Count=array();
			
		$_tags = Project_Tags::get( implode( ',', array_unique( $_tagsIds ) ) );
		foreach( $_tagsCounter as &$_data ){
			if( strpos( $_data['tags'], ',' ) !== false ){
				$_data['tags']=array_filter( explode( ',', trim( $_data['tags'], ',' ) ) );
			}
		}
		foreach( $mixRes as &$item ){
			foreach( $item['tags'] as &$_tagGetName ){
				foreach( $_tags as $_tagId=>$_tagName ){
					if( $_tagId == $_tagGetName ) {
						$_tagGetName=$_tagName;
					}
				}
			}
		}

		$this->init();
		return $this;
	}

	public function setMass( $_flgEnd=false ){
		$this->_data->setFilter();
		$_addTime=$_efId=false;
		$_allTagsIds=array();
		$_arrSend=$_arrEmails=$_arrValues=array();
		foreach( $this->_data->filtered as $_send ){
			if( isset( $_send['email'] ) && !empty( $_send['email'] ) ){
				$_arrEmails[$_send['email']]=$_send['email'];
			}
			foreach( array_keys( $_send ) as $_name ){
				if( $_name == 'ef_id' ){
					$_efId=$_send[$_name];
					continue;
				}

				if( $_name == 'start' ){
					$_addTime=$_send[$_name];
					continue;
				}

				if( !isset( $_arrValues[$_name] ) ){
					$_arrValues[$_name]='';
				}
				if( $_name == 'email' ){
					$_arrEmails[$_name]=$_name;
				}
				if( $_name == 'tags' ){
					if( is_string( $_send[$_name] ) ){
						$_addNewTags=array_filter( explode( ',', $_send[$_name] ) );
					}elseif( is_array( $_send[$_name] ) ){
						$_addNewTags=array_filter( $_send[$_name] );
					}
					if( is_array( $_addNewTags ) && !empty( $_addNewTags ) ){
						$_allTagsIds=array_merge( $_addNewTags, $_allTagsIds );
					}
				}
			}
		}
		unset( $_send );
		$_allTags=Project_Tags::get( array_unique( $_allTagsIds ) );
		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			$_arrOldEmails=Core_Sql::getAssoc( 'SELECT d.id, d.email FROM s8rs_'.$this->_userId.' d WHERE email IN ('.Core_Sql::fixInjection( $_arrEmails ).')' );
			$_oldEmails=$_cronUpdate=array();
			foreach( $_arrOldEmails as $_data ){
				$_oldEmails[$_data['id']]=$_data['email'];
			}
			foreach( $this->_data->filtered as $_send ){
				$_arrSender=$_arrValues;
				if( !in_array( $_send['email'], $_oldEmails ) ){
					foreach( array_keys( $_arrValues ) as $_checkKey ){
						if( isset( $_send[$_checkKey] ) ){
							$_arrSender[$_checkKey]=$_send[$_checkKey];
						}
					}
					$_arrSend[$_send['email']]=implode( '","', $_arrSender );
				}
			}
			unset( $_send );
			if( !empty( $_oldEmails ) ){
				if( count( $_oldEmails ) > 1010 ){ // сформировать запрос на крон если данных больше 1000
					$_cronUpdate['arrData']['subscribers']=array_keys( $_oldEmails );
					$_cronUpdate['arrData']['update_selected']=1;
					if( !empty( $_efId ) ){
						$_cronUpdate['arrData']['email_funnels']=$_efId;
					}
					if( !empty( $_allTags ) ){
						$_cronUpdate['arrData']['tags']=implode(',', $_allTags); // должны пройти на сохранение только новые добавленные тэги
					}
					$_cronUpdate['user_id']=Core_Users::$info['id'];
					file_put_contents(
						Zend_Registry::get('config')->path->absolute->crontab.'mass_updater'.DIRECTORY_SEPARATOR.microtime(true).'.mu', 
						Core_Users::$info['id'].PHP_EOL.'Project_Efunnel_Subscribers'.PHP_EOL.'cronUpdateContacts'.PHP_EOL.serialize( array_filter( $_cronUpdate ) ) 
					);
				}else{
					$_arrTagsMass=array();
					if( !empty( $_allTags ) ){
						foreach( $_arrOldEmails as $_data ){
							$_moveUserTags=false;
							foreach( $this->_data->filtered as $_updateUsers ){
								if( $_updateUsers['email'] == $_data['email'] ){
									if( is_string( $_updateUsers['tags'] ) ){
										$_arrTagsMass[$_updateUsers['tags']][]=$_data['id'];
									}elseif( is_array( $_updateUsers['tags'] ) ){
										$_arrTagsMass[','.implode( ',', array_unique( $_updateUsers['tags'] ) ).','][]=$_data['id'];
									}
								}
							}
						}
					}
					foreach( $_arrTagsMass as $_keyTags=>$_arrUpdateIds ){
						Core_Sql::setExec( 'UPDATE s8rs_'.$this->_userId.' SET tags="'.$_keyTags.'" WHERE id IN ("'.implode( '","', $_arrUpdateIds).'")' );
					}
				}
			}
			$_intContactsLimit=Core_Sql::getRecord( 'SELECT COUNT(*) FROM s8rs_'.$this->_userId );
			if( $_intContactsLimit['COUNT(*)']+count( $_arrSend ) >= Core_Users::$info['contact_limit'] && !empty( Core_Users::$info['contact_limit'] ) ){
				$_intSlice=$_intContactsLimit['COUNT(*)']-Core_Users::$info['contact_limit'];
				if( $_intSlice >= 0 ){
					$_arrSend=array();
				}else{
					if( -$_intSlice < count( $_arrSend ) ){
						$_arrSend=array_slice($_arrSend, 0, -$_intSlice, true);
					}
				}
			}
			if( !empty( $_arrSend ) ){
				Core_Sql::setExec( 'INSERT INTO s8rs_'.$this->_userId.' (`'.implode( '`,`', array_keys( $_arrValues  ) ).'`) VALUES ("'.implode( '"),("', $_arrSend ).'")' );
			}
			$_arrNewEmailsIds=Core_Sql::getField( 'SELECT d.id FROM s8rs_'.$this->_userId.' d WHERE email IN ('.Core_Sql::fixInjection( $_arrEmails ).') AND d.flg_global_unsubscribe <> 1' );
			if( $_addTime === false ){
				$_addTime=time();
			}
			$_arrSendEv=array();
			foreach( $_arrNewEmailsIds as $_newId ){
				$_arrSendEv[]='("'.$_newId.'","'.Project_Subscribers_Events::FROM_ADMIN.'","'.$_addTime.'", "'.Project_Subscribers_Events::EF_ID.'", "'.$_efId.'")';
			}
			Core_Sql::setExec( 'INSERT INTO s8rs_events_'.$this->_userId.' (`sub_id`,`event_type`,`added`,`campaign_type`,`campaign_id`) VALUES '.implode( ',', $_arrSendEv ) );
			//========
			Core_Sql::renewalConnectFromCashe();
		}catch(Exception $e){
			$this->cronErrorLog[]=$e->getMessage();
			file_put_contents(Zend_Registry::get('config')->path->absolute->logfiles.'errors_'.$this->_userId.'.txt', serialize($e));
			$obj1=new Project_Subscribers( $this->_userId );$obj1->install();
			$obj2=new Project_Subscribers_Events( $this->_userId );$obj2->install();
			$obj3=new Project_Subscribers_Parameters( $this->_userId );$obj3->install();
			Core_Sql::renewalConnectFromCashe();
			$this->init();
			if( $_flgEnd ){
				$this->setMass( true );
				exit;
			}
			// return false;
		}
		return true;
	}
	
	public function getTagsHeat( &$_tagsHeat ){
		if( isset( $this->_arrTagsHeat ) && !empty( $this->_arrTagsHeat ) ){
			$_tagsHeat=$this->_arrTagsHeat;
		}
		$this->_arrTagsHeat=array();
	}
	
	public function del(){
		$_EFids=$_strWith=array();
		if ( !empty( $this->_withEfunnelIds ) ){
			$_strWith[]='sender_id IN ('.Core_Sql::fixInjection( $this->_withEfunnelIds ).')';
			$_EFids=$this->_withEfunnelIds;
		}else{
			$_funnel=new Project_Efunnel();
			$_funnel->withUserId(array( $this->_userId ))->onlyIds()->getList( $_EFids );
		}
		$_removeEmail='';
		if( $this->_withEmail == array( '' ) ){
			$_removeEmail=$_strWith[]='email IS NULL';
		}elseif ( !empty( $this->_withEmail ) ){
			$_removeEmail=$_strWith[]='email IN ('.Core_Sql::fixInjection( $this->_withEmail ).')';
		}
		if( empty( $_strWith ) ){
			$this->init();
			return false;
		}
		$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'EF_Contacts_Remove.log' );
		$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
		$_logger=new Zend_Log( $_writer );
		$_logger->info('-------------Project_Efunnel_Subscribers 2---------------');
		$_logger->info(serialize($_SERVER));
		$_logger->info('DELETE FROM s8rs_'.$this->_userId.' WHERE '.implode( ' and ', $_strWith ));
		$_logger->info('-------------Project_Efunnel_Subscribers 2---------------');
		if( !empty( $_EFids ) ){
			Core_Sql::setExec( 'DELETE FROM lpb_efunnels_mailer WHERE '.$_removeEmail.' AND ef_id IN('.Core_Sql::fixInjection( $_EFids ).')' );
		}
		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			Core_Sql::setExec( 'DELETE FROM s8rs_'.$this->_userId.' WHERE '.implode( ' and ', $_strWith ) );
			//========
			Core_Sql::renewalConnectFromCashe();
		} catch(Exception $e) {
			Core_Sql::renewalConnectFromCashe();
			$this->init();
			return false;
		}
		$this->init();
		return true;
	}
}
?>