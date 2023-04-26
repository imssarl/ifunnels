<?php
class Project_Efunnel_Mailer extends Core_Data_Storage {

	protected $_table='lpb_efunnels_mailer';
	protected $_fields=array( 'id', 
		'ef_id', // EF campaign
		'message_id', // EF send message id
		'email', // Subscriber Email
		'send_date', // Send Email Date
		'email_data', // Email data for send
		'flg_resend', // resend 
		'flg_sendone', // send message from ef campaigns
		'flg_status', // status on creation/save/delete
		'added' );

	public static function install(){
		Core_Sql::setExec("drop table if exists lpb_efunnels_mailer");
		Core_Sql::setExec( "CREATE TABLE `lpb_efunnels_mailer` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`ef_id` INT(11) NOT NULL DEFAULT '0',
			`message_id` INT(11) NOT NULL DEFAULT '0',
			`email` VARCHAR(255) NULL DEFAULT NULL,
			`send_date` INT(11) UNSIGNED NOT NULL DEFAULT '0',
			`email_data` TEXT NULL DEFAULT NULL,
			`flg_resend` INT(1) NOT NULL DEFAULT '0',
			`flg_sendone` INT(1) NOT NULL DEFAULT '0',
			`flg_status` INT(1) NOT NULL DEFAULT '0',
			`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
			UNIQUE INDEX `id` (`id`)
		)
		COLLATE='utf8_general_ci'
		ENGINE=InnoDB;" );
	}

	public function setEntered( $_mix=array() ){
		if( !empty( $_mix['email_data'] ) ){
			$_mix['email_data']=base64_encode( serialize( $_mix['email_data'] ) );
		}
		$this->_data=is_object( $_mix )? $_mix:new Core_Data( $_mix );
		return $this;
	}

	public function getEntered( &$arrRes ){
		if ( is_object( $this->_data ) ){
			$arrRes=$this->_data->getFiltered();
		}
		$arrRes['email_data']=unserialize( base64_decode( $arrRes['email_data'] ) );
		return $this;
	}

	public function haveEmail2Ef($_efId, $_email){
		if( empty( $_efId ) || empty( $_email ) ){
			return false;
		}
		return Core_Sql::getCell( 'SELECT id FROM '.$this->_table.' WHERE ef_id="'.$_efId.'" AND email='.Core_Sql::fixInjection( $_email ) );
	}

	protected $_sendNow=false;
	public function sendNow(){
		$this->_sendNow=true;
		return $this;
	}
	
	protected $_withStatus=false;
	public function withStatus($_int){
		$this->_withStatus=$_int;
		return $this;
	}
	
	protected $_withEmail=false;
	public function withEmail($_str){
		$this->_withEmail=$_str;
		return $this;
	}
	
	protected $_withEF=false;
	public function withEF($_int){
		$this->_withEF=$_int;
		return $this;
	}
	
	protected function assemblyQuery(){
		parent::assemblyQuery();
		if ( !empty( $this->_sendNow ) ){
			$this->_crawler->set_where( 'd.send_date<='.time() );
		}
		if ( !empty( $this->_withEmail ) ){
			$this->_crawler->set_where( 'd.email='.Core_Sql::fixInjection( $this->_withEmail ) );
		}
		if ( !empty( $this->_withEF ) ){
			$this->_crawler->set_where( 'd.ef_id='.Core_Sql::fixInjection( $this->_withEF ) );
		}
		if ( $this->_withStatus!==false ){
			$this->_crawler->set_where( 'd.flg_status='.$this->_withStatus );
		}
	}

	protected function init(){
		parent::init();
		$this->_sendNow=false;
		$this->_withStatus=false;
		$this->_withEmail=false;
	}
	
	public function create($folder){
		if (file_exists($folder)) {
			return is_writable($folder);
		}
		$folderParent = dirname($folder);
		if($folderParent != '.' && $folderParent != '/' ) {
			if(!$this->create(dirname($folder))) {
				return true;
			}
		}
		if ( is_writable($folderParent) ) {
			if ( mkdir($folder, 0777, true) ) {
				return true;
			}
		}
		return false;
	}
	
	public static function code( $_str='' ){
		$_code='';
		for( $i=0; $i<strlen( $_str ); $i++ ){
			$_code.=sprintf("%02s",dechex( ord( $_str[$i] ) ) );
		}
		return $_code;
	}
	public static function decode( $_str='' ){
		$_decode='';
		$_arrCode=str_split($_str,2);
		foreach( $_arrCode as $_char ){
			$_decode.=chr( hexdec( $_char ) );
		}
		return $_decode;
	}
	
	private $_dTime=3600; // 1 час = 3600 период между запросами по часу
	
	public function save(){
		$_dirName=Zend_Registry::get('config')->path->absolute->mailpool.'users';
		Core_Files::dirScan( $arrUsers, $_dirName, true );
		$_setData=false;
		try{
			Core_Sql::setConnectToServer( 'lpb.tracker' );
			//========
			foreach( $arrUsers[$_dirName] as $_fileName ){
				$userId=str_replace( '.ef', '', $_fileName );
				$_s8r=new Project_Efunnel_Subscribers($userId);
				if( $_fileObj=fopen(Zend_Registry::get('config')->path->absolute->mailpool.'users'.DIRECTORY_SEPARATOR.$_fileName,"r")){
					while( !feof( $_fileObj ) ){
					
						$_setData=unserialize( fgets( $_fileObj ) );
						
						echo "\n".serialize( $_setData );	
						
						if( isset( $_setData['status'] ) && !empty( $_setData['email'] ) ){
							Core_Sql::setExec( 'UPDATE s8rs_'.$_setData['user_id'].' SET `status`="'.$_setData['status'].'", `status_data`="2147483648" WHERE email IN ('.Core_Sql::fixInjection(  $_setData['email'] ).')' );
						}elseif( !empty( $_setData ) && is_array( $_setData ) && isset( $_setData['email'] ) ){
						//	$_setData['added']=time();
							$_s8r->setEntered( $_setData )->set();
							$_s8r->getEntered( $_getData );
							//======== return connection after save
							Core_Sql::setConnectToServer( 'lpb.tracker' );
							//========
						}elseif( empty( $_setData['email'] ) ){
							Core_Sql::setExec( 'DELETE FROM s8rs_'.$_setData['user_id'].' WHERE `email` IS NULL OR `email`=""' );
						}
					}
					fclose( $_fileObj ); 
				}
				unlink( $_dirName.DIRECTORY_SEPARATOR.$_fileName );
			}
			//========
			Core_Sql::renewalConnectFromCashe();
		}catch(Exception $e) {
			echo date(DATE_RFC822).': '.$e."\n";
			echo date(DATE_RFC822).': '.serialize( $_setData )."\n";
			echo date(DATE_RFC822).': '.serialize( $_getData )."\n";
			//echo date(DATE_RFC822).': '.'UPDATE s8rs_'.$_setData['user_id'].' SET `status`="'.$_setData['status'].'", `status_data`="2147483648" WHERE email IN ('.Core_Sql::fixInjection(  $_setData['email'] ).')'."\n";
			Core_Sql::renewalConnectFromCashe();
		}
	}
	
	public function errHandler($errno, $errstr, $errfile, $errline){
		echo 'SMTP Error: #'.$errno.' '.mb_convert_encoding( $errstr, "UTF-8" ).'\n\r';
		
	}
	
	public function run(){
		$_checkEmails = Core_Sql::getAssoc('SELECT email, ef_id FROM (SELECT COUNT(*) AS counter, email, ef_id FROM lpb_efunnels_mailer GROUP BY email, ef_id) p WHERE p.counter > 1');

		foreach ($_checkEmails as $_badEmail) {
			$_arrData = Core_Sql::getField('SELECT id FROM lpb_efunnels_mailer WHERE email=' . Core_Sql::fixInjection($_badEmail['email']) . ' AND ef_id = ' . Core_Sql::fixInjection($_badEmail['ef_id']));
			array_shift($_arrData);

			if (!empty($_arrData)) {
				
				echo "\nRemove duplicates: " . 'DELETE FROM lpb_efunnels_mailer WHERE id IN (' . Core_Sql::fixInjection( $_arrData ) . ' )';
				Core_Sql::setExec('DELETE FROM lpb_efunnels_mailer WHERE id IN (' . Core_Sql::fixInjection($_arrData) . ' )');
			}
		}

		$this
			->sendNow()
			->withStatus(0)
			->getList($_arrSend);

		echo "\n" . date("d-m-Y H:i:s", time()) . " For SEND:";

		$_arrSenderIds = $_arrSenderHave = $_arrSMTPIds = $_arrCampaignsIds = $_arrSmtp = array();

		foreach ($_arrSend as &$_sendData) {
			if(empty($_sendData['email'])) {
				echo "\nRemove empty: " . 'DELETE FROM lpb_efunnels_mailer WHERE id = ' . Core_Sql::fixInjection($_sendData['id']);
				Core_Sql::setExec('DELETE FROM lpb_efunnels_mailer WHERE id = ' . Core_Sql::fixInjection($_sendData['id']));
				continue;
			}

			echo "\n" . $_sendData['id'] . " " . $_sendData['email'] . " time " . $_sendData['send_date'];

			if (!isset($_arrSenderHave[$_sendData['email'] . '_' . $_sendData['ef_id'] . '_' . $_sendData['ef_id']])) {
				$_arrSenderHave[$_sendData['email'] . '_' . $_sendData['ef_id'] . '_' . $_sendData['ef_id']] = array();
			}

			if ($_sendData['flg_sendone'] != 0) {
				$_arrSenderHave[$_sendData['email'] . '_' . $_sendData['ef_id'] . '_' . $_sendData['ef_id']][$_sendData['id']] = $_sendData['id'];
			}

			$_arrCampaignsIds[$_sendData['ef_id']] = $_sendData['ef_id'];
			$_sendData['email_data'] = unserialize(base64_decode($_sendData['email_data']));
			$_arrSenderIds[] = $_sendData['id'];
		}

		foreach ($_arrSenderHave as $_arrIds) {
			if (count($_arrIds) > 1) {
				$_notDeleteFirst = true;

				foreach ($_arrIds as $_removeId) {
					if ($_notDeleteFirst) {
						$_notDeleteFirst = false;
						continue;
					}

					echo "\nRemove duplicate: " . 'DELETE FROM lpb_efunnels_mailer WHERE id=' . Core_Sql::fixInjection($_removeId);
					Core_Sql::setExec('DELETE FROM lpb_efunnels_mailer WHERE id=' . Core_Sql::fixInjection($_removeId));
				}
			}
		}

		if (!empty($_arrSenderIds)) {
			echo "\n" . 'UPDATE lpb_efunnels_mailer SET `flg_status`="1" WHERE id IN (' . Core_Sql::fixInjection($_arrSenderIds) . ')';
			Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="1" WHERE id IN (' . Core_Sql::fixInjection($_arrSenderIds) . ')');
		}

		$_objEF = new Project_Efunnel();

		$_objEF
			->onlyStarted()
			->withIds($_arrCampaignsIds)
			->getList($_arrCampaigns);

		$_arrEF = array();

		foreach ($_arrCampaigns as $_campaignData) {
			$_arrMsg = array();

			foreach ($_campaignData['message'] as $_msg) {
				$_arrMsg[$_msg['id']] = $_msg;
			}

			$_campaignData['message'] = $_arrMsg;
			$_arrEF[$_campaignData['id']] = $_campaignData;
			$_arrSMTPIds[$_campaignData['smtp_id']] = $_campaignData['smtp_id'];
		}

		unset($_arrCampaigns);

		$_settings = new Project_Efunnel_Settings();

		$_settings
			->withIds($_arrSMTPIds)
			->keyRecordForm()
			->getList($_arrSMTP);
			
		foreach ($_arrSMTP as &$_smtpData) {
			$_smtpData = unserialize(base64_decode($_smtpData['settings']));
		}

		foreach ($_arrSend as $_sendS8r) {
			if (!is_array($_arrEF[$_sendS8r['ef_id']]) || empty($_arrEF[$_sendS8r['ef_id']]['user_id'])) {
				echo "\nRemove: " . $_sendS8r['email '] . ' ' . $_sendS8r['ef_id '] . ':' . $_sendS8r['message_id '] . ' DELETE FROM lpb_efunnels_mailer WHERE id=' . Core_Sql::fixInjection($_sendS8r['id']);
				Core_Sql::setExec('DELETE FROM lpb_efunnels_mailer WHERE id=' . Core_Sql::fixInjection($_sendS8r['id']));
				continue;
			}

			if ((!isset($_sendS8r['message_id']) || empty($_sendS8r['message_id'])) && is_array($_arrEF[$_sendS8r['ef_id']]['message'])) {
				$_sendS8r['message_id'] = $this->array_key_first($_arrEF[$_sendS8r['ef_id']]['message']);
			}

			echo "\n EFM run";

			$this->createSenderFile(
				$_arrEF[$_sendS8r['ef_id']]['user_id'],
				$_arrEF[$_sendS8r['ef_id']] + array('smtp' => $_arrSMTP[$_arrEF[$_sendS8r['ef_id']]['smtp_id']]),
				$_arrEF[$_sendS8r['ef_id']]['message'][$_sendS8r['message_id']],
				array(
					'email' => $_sendS8r['email'],
					'data'  => (is_array($_sendS8r['email_data']) ? $_sendS8r['email_data'] : array()) + array('email' => $_sendS8r['email']),
				)
			);
		}

		return true;
	}

    function array_key_first(array $arr) {
        foreach($arr as $key => $unused) {
            return $key;
        }
        return NULL;
    }

	public function messages(){
		$this
			->withStatus(3)
			->getList($_arrRemove);

		foreach ($_arrRemove as $_removeS8r) {
			echo ("\n" . $_removeS8r['email '] . ' ' . $_removeS8r['ef_id '] . ':' . $_removeS8r['message_id '] . ' DELETE FROM lpb_efunnels_mailer WHERE id=' . Core_Sql::fixInjection($_removeS8r['id']));
			Core_Sql::setExec('DELETE FROM lpb_efunnels_mailer WHERE id=' . Core_Sql::fixInjection($_removeS8r['id']));
		}

		// Getting all messages with status = 2
		$this
			->withStatus(2)
			->getList($_arrSend);

		$_arrSenderIds = $_arrSMTPIds = $_arrCampaignsIds = $_arrSmtp = array();

		foreach ($_arrSend as &$_sendData) {
			$_arrCampaignsIds[$_sendData['ef_id']] = $_sendData['ef_id'];
			$_sendData['email_data']               = unserialize(base64_decode($_sendData['email_data']));
			$_arrSenderIds[]                       = $_sendData['id'];
		}
		
		$_objEF = new Project_Efunnel();

		// Getting funnels from list ids 
		$_objEF
			->onlyStarted()
			->withIds($_arrCampaignsIds)
			->getList($_arrCampaigns);

		$_arrEF = array();
		foreach ($_arrCampaigns as $_campaignData) {
			$_arrMsg = array();
			
			foreach ($_campaignData['message'] as $_msg) {
				$_arrMsg[$_msg['id']] = $_msg;
			}
			
			$_campaignData['message']     = $_arrMsg;
			$_arrEF[$_campaignData['id']] = $_campaignData;
		}

		unset($_arrCampaigns);

		foreach ($_arrSend as $_sendS8r) {
			$_efS8rC6n = $_arrEF[$_sendS8r['ef_id']];
			$_m5eId    = $_sendS8r['message_id'];

			if ((empty($_sendS8r['message_id']) || $_sendS8r['message_id'] == '0') && is_array($_efS8rC6n['message'])) {
				$_m5eId = $this->array_key_first($_efS8rC6n['message']);
			}

			$_sendPeriod = 24;
			$_flgResend  = ', `flg_resend`="0"';

			if ($_sendS8r['flg_resend'] == 0 && $_efS8rC6n['options']['flg_resender'] != 0) {
				$_flgResend = ', `flg_resend`="1"';

				if (isset($_efS8rC6n['options']['resender_time']) && !empty($_efS8rC6n['options']['resender_time'])) {
					$_sendPeriod = (int) $_efS8rC6n['options']['resender_time'];
				}
			} else {
				$_nextMessage = $_flgGetNext = false;

				foreach ($_efS8rC6n['message'] as $_mess) {
					if ($_flgGetNext) {
						$_nextMessage = $_mess;
						break;
					}

					if ($_mess['id'] == $_m5eId) {
						$_flgGetNext = true;
					}
				}

				if (isset($_nextMessage['id'])) {
					$_m5eId = $_nextMessage['id'];
				} else {

					// Run event CONTACT_COMPLEATED_EF
					Project_Automation::setEvent(Project_Automation_Event::$type['CONTACT_COMPLEATED_EF'], $_sendS8r['ef_id'], $_sendS8r['email'], array('user_id' => $_efS8rC6n['user_id']));

					echo ("\n" . $_sendS8r['email '] . ' ' . $_sendS8r['ef_id '] . ':' . $_sendS8r['message_id '] . ' UPDATE lpb_efunnels_mailer SET `flg_status`="3" WHERE id=' . Core_Sql::fixInjection($_sendS8r['id']));
					Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="3" WHERE id=' . Core_Sql::fixInjection($_sendS8r['id']));
					continue; // end foreach
				}

				$_sendPeriod = (int) $_efS8rC6n['message'][$_m5eId]['period_time'] * ($_efS8rC6n['message'][$_m5eId]['flg_period'] == 2 ? 24 : 1);
			}

			$_messageId = ', `message_id`="' . $_m5eId . '"';

			echo ("\n" . $_sendS8r['email '] . ' ' . $_sendS8r['ef_id '] . ':' . $_sendS8r['message_id '] . ' UPDATE lpb_efunnels_mailer SET `flg_status`="0"' . $_messageId . $_flgResend . ', send_date="' . ($_sendPeriod * 60 * 60 + (int) $_sendS8r['send_date']) . '" WHERE id=' . Core_Sql::fixInjection($_sendS8r['id']));
			echo ("\n" . $_sendPeriod . '*' . ($_efS8rC6n['message'][$_m5eId]['flg_period'] == 2 ? 24 : 1) . '+' . (int) $_sendS8r['send_date']);

			Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="0"' . $_messageId . $_flgResend . ', send_date="' . ($_sendPeriod * 60 * 60 + (int) $_sendS8r['send_date']) . '" WHERE id=' . Core_Sql::fixInjection($_sendS8r['id']));
		}
	}
	
	public function resendStop(){
		$this->getList( $_arrSend );
		$_arrSenderIds=$_arrSMTPIds=$_arrCampaignsIds=$_arrSmtp=array();
		foreach( $_arrSend as &$_sendData ){
			$_arrCampaignsIds[$_sendData['ef_id']]=$_sendData['ef_id'];
			$_sendData['email_data']=unserialize( base64_decode( $_sendData['email_data'] ) );
			$_arrSenderIds[]=$_sendData['id'];
		}
		$_objEF=new Project_Efunnel();
		$_objEF->onlyStarted()->withIds( $_arrCampaignsIds )->getList( $_arrCampaigns );
		$_arrEF=array();
		foreach( $_arrCampaigns as $_campaignData ){
			$_arrMsg=array();
			foreach( $_campaignData['message'] as $_msg ){
				$_arrMsg[$_msg['id']]=$_msg;
			}
			$_campaignData['message']=$_arrMsg;
			$_arrEF[$_campaignData['id']]=$_campaignData;
		}
		unset( $_arrCampaigns );
		foreach( $_arrSend as $_sendS8r ){
			$_efS8rC6n=$_arrEF[$_sendS8r['ef_id']];
			$_m5eId=$_sendS8r['message_id'];
			if( ( empty( $_sendS8r['message_id'] ) || $_sendS8r['message_id']=='0' ) && is_array( $_efS8rC6n['message'] ) ){
				$_m5eId=$this->array_key_first( $_efS8rC6n['message'] );
			}
			$_sendPeriod=24;
			$_flgResend=', `flg_resend`="0"';
			$_nextMessage=$_flgGetNext=false;
			foreach( $_efS8rC6n['message'] as $_mess ){
				if( $_flgGetNext  ){
					$_nextMessage=$_mess;
					break;
				}
				if( $_mess['id'] == $_sendS8r['message_id'] ){
					$_flgGetNext=true;
				}
			}
			if( isset( $_nextMessage['id'] ) ){
				$_m5eId=$_nextMessage['id'];
			}else{
				Core_Sql::setExec( 'DELETE FROM lpb_efunnels_mailer WHERE id='.Core_Sql::fixInjection( $_sendS8r['id'] ) );
				continue; // end foreach
			}
			$_sendPeriod=(int)$_efS8rC6n['message'][$_m5eId]['period_time']*($_efS8rC6n['message'][$_m5eId]['flg_period']==2?24:1);
			$_messageId=', `message_id`="'.$_m5eId.'"';
			Core_Sql::setExec( 'UPDATE lpb_efunnels_mailer SET `flg_status`="0"'.$_messageId.$_flgResend.', send_date="'.( $_sendPeriod*60*60+time() ).'" WHERE id='.Core_Sql::fixInjection( $_sendS8r['id'] ) );
		}
	}

	public function sender(){
		Core_Files::dirScan($arrDirs, Zend_Registry::get('config')->path->absolute->mailpool . 'servers', false);

		// flg_status=1
		foreach (array_keys($arrDirs) as $_dirName) {
			$_serverData = explode('.', basename($_dirName));
			$_serverUrl  = self::decode($_serverData[0]);
			$_serverPort = $_serverData[1];

			if (isset($_SERVER) && isset($_SERVER['SERVER_NAME']) && $_SERVER['SERVER_NAME'] == 'cnm.local') {
				$_serverUrl  = 'test.local';
				$_serverPort = '80';
			}

			Core_Files::dirScan($arrFiles, $_dirName, true);

			if (!isset($arrFiles[$_dirName]) || empty($arrFiles[$_dirName])) {
				continue;
			}

			$_badConnections = array();

			foreach ($arrFiles[$_dirName] as $_fileName) {
				$_fileData = file_get_contents($_dirName . DIRECTORY_SEPARATOR . $_fileName);

				if ($_fileData === false) {
					continue;
				}

				preg_match('/(.*)\s(EHLO(.*))/s', $_fileData, $_match);
				$_strSave = unserialize($_match[1]);

				if (!isset($_strSave['user_id'])) {
					continue;
				}

				if (isset($_badConnections[$_strSave['ef_id']]) && count($_badConnections[$_strSave['ef_id']]) >= 2) {
					$_model = new Project_Efunnel();
					$_model->activate($_strSave['ef_id'], 3)->setLog($_strSave['ef_id'], $_badConnections[$_strSave['ef_id']][0]);
					unlink($_dirName . DIRECTORY_SEPARATOR . $_fileName);
					Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="0" WHERE `email`="' . $_strSave['email'] . '" AND `ef_id`="' . $_strSave['ef_id'] . '"');
					continue;
				}

				if (isset($_SERVER) && isset($_SERVER['SERVER_NAME']) && $_SERVER['SERVER_NAME'] == 'app.local') {
					$_c = fopen(Zend_Registry::get('config')->path->absolute->mailpool . 'users.tpl', 'a+');
				} else {
					$_c = fsockopen($_serverUrl, $_serverPort, $errno, $errstr, 30);
				}

				if (!empty($errstr)) {
					fclose($_c);
					unlink($_dirName . DIRECTORY_SEPARATOR . $_fileName);
					$_model = new Project_Efunnel();
					$_model->activate($_strSave['ef_id'], 3)->setLog($_strSave['ef_id'], 'SMTP Connect Error: #' . $errno . ' ' . htmlspecialchars(mb_convert_encoding($errstr, "UTF-8")));
					echo "\n" . serialize($_strSave) . "\n" . 'SMTP Error: #' . $errno . ' ' . mb_convert_encoding($errstr, "UTF-8") . "\n" . $_serverUrl . "\n\n";
					Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="0" WHERE `email`="' . $_strSave['email'] . '" AND `ef_id`="' . $_strSave['ef_id'] . '"');
					continue;
				}

				$_strSend = $_match[2];
				$_arrSend = explode("\r\n", $_strSend);
				$_return  = @fgets($_c, 9999);

				$_flgTlsStart = false;
				$flgAnswer    = true;
				$_smtpMessage = '';

				foreach ($_arrSend as $key => &$_sendStr) {
					$_sendStr .= "\r\n";

					@fputs($_c, $_sendStr);
					$_start = microtime(true);

					if ($flgAnswer) {
						$_return = $this->getAnswer($_c);
						$_smtpMessage .= $_return;
					}

					if (strpos($_sendStr, 'EHLO ') !== false && $_return[0] == 5) {
						continue;
					}
					
					if($_sendStr === "DATA\r\n") {
						$flgAnswer = false;
					}

					if ($_sendStr === ".\r\n") {
						$flgAnswer = true;
					}

					if (!$_flgTlsStart && strpos($_return, 'STARTTLS') !== false) {
						@fputs($_c, "STARTTLS\r\n");
						
						$_return = $this->getAnswer($_c);
						$_smtpMessage .= $_return;

						$cryptoMethod = STREAM_CRYPTO_METHOD_TLS_CLIENT;

						if (defined('STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT')) {
							$cryptoMethod |= STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT;
							$cryptoMethod |= STREAM_CRYPTO_METHOD_TLSv1_1_CLIENT;
						}

						set_error_handler(array($this, 'errHandler'));

						$flgCrypto = stream_socket_enable_crypto($_c, true, $cryptoMethod);
						restore_error_handler();
						@fputs($_c, "EHLO ifunnels.com\r\n");

						$_return = $this->getAnswer($_c);
						$_smtpMessage .= $_return;
						$_flgTlsStart = true;
                    }

                    // TODO добавлена проверка на 501 ошибку, чтобы не отключать рассылку если проблема в валидности email
					if ($_return[0] == 5 && strpos($_return, '501') !== false) {
						unlink( $_dirName.DIRECTORY_SEPARATOR.$_fileName );
						echo "\n" . serialize($_strSave) . "\n" . $_strSend . "\n" . $_smtpMessage;
						Core_Sql::setExec( 'UPDATE lpb_efunnels_mailer SET `flg_status`="0" WHERE `email`="'.$_strSave['email'].'" AND `ef_id`="'.$_strSave['ef_id'].'"' );
						continue 2;
					}

					if ($_return[0] == 5){ // остановка, пауза
						unlink($_dirName . DIRECTORY_SEPARATOR . $_fileName);
						$_model = new Project_Efunnel();
						$_model->activate($_strSave['ef_id'], 3)->setLog($_strSave['ef_id'], 'SMTP Send Error: ' . $_smtpMessage);

						echo "\n" . serialize($_strSave) . "\n" . $_strSend . "\n" . $_smtpMessage;

						Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="0" WHERE `email`="' . $_strSave['email'] . '" AND `ef_id`="' . $_strSave['ef_id'] . '"');

						continue 2;
					}

					if ($_return[0] == 4){ // 2 повторные попытки отправить
						unlink($_dirName . DIRECTORY_SEPARATOR . $_fileName);
						$_badConnections[$_strSave['ef_id']][] = 'SMTP Error: ' . trim(substr($_return, strrpos($_return, ':') + 1));
						echo "\n" . serialize($_strSave) . "\n" . $_strSend . "\n" . $_smtpMessage;
						Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="0" WHERE `email`="' . $_strSave['email'] . '" AND `ef_id`="' . $_strSave['ef_id'] . '"');

						continue 2;
					}
				}

				fclose($_c);
				echo "\nSEND COMPLITE:" . serialize($_strSave) . "\n" . $_strSend . "\n" . $_smtpMessage;
				unlink($_dirName . DIRECTORY_SEPARATOR . $_fileName);

				if (!is_dir(Zend_Registry::get('config')->path->absolute->mailpool . 'users')) {
					$this->create(Zend_Registry::get('config')->path->absolute->mailpool . 'users');
				}

				if (isset($_strSave['email'])) {
					file_put_contents(Zend_Registry::get('config')->path->absolute->mailpool . 'users' . DIRECTORY_SEPARATOR . $_strSave['user_id'] . '.ef', serialize($_strSave) . "\r\n", FILE_APPEND);
					Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="2" WHERE `email`="' . $_strSave['email'] . '" AND `ef_id`="' . $_strSave['ef_id'] . '"');
				}
			}
		}

		Core_Sql::setExec('UPDATE lpb_efunnels_mailer SET `flg_status`="0" WHERE `flg_status`="1" AND send_date < "' . time() . '"'); // сброс зависших
	}

	private function getAnswer( $smtp ){
		if (!is_resource($smtp)) {
			return false;
		}

		$data = '';
		while (!feof($smtp)) {
			$str = @fgets($smtp, 515);
			$data .= $str;
			// If response is only 3 chars (not valid, but RFC5321 S4.2 says it must be handled),
			// or 4th character is a space, we are done reading, break the loop,
			// string array access is a micro-optimisation over strlen
			if (!isset($str[3]) or (isset($str[3]) and $str[3] == ' ')) {
				break;
			}
		}

		return $data;
	}

	public static function replaceData ($_content = '', $_replace = array()) {
		$_replace = array_combine(
			array_map(
				function($value) { return strtolower($value); }, array_keys($_replace)
			), 
			$_replace
		);

		preg_match_all('/\{(.*?)::(.*?)\}/', $_content, $_match);
		$_contentCash = $_content;
		foreach ($_match[0] as $_keyR => $_replaceString) {
			if (isset($_replace[$_match[1][$_keyR]])) {
				$_contentCash = str_replace($_match[0][$_keyR], $_replace[$_match[1][$_keyR]], $_contentCash);
			} else {
				$_contentCash = str_replace($_match[0][$_keyR], $_match[2][$_keyR], $_contentCash);
			}
		}
		return $_contentCash;
	}

	public function combine($_userId=false){
		//=======
		$_withLogger=true;
		$_firstStart=$_start=$_memoryStart=0;
		if( $_withLogger ){
			$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'Project_Efunnels_3line.log' );
			$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
			$_logger=new Zend_Log( $_writer );
			$_firstStart=$_start=microtime(true);
			$_logger->info('Start -----------------------------------------------------------------------------------------------------' );
			$_memoryStart=memory_get_usage();
		}
		//=======
		$_objEF=new Project_Efunnel();
		//$_objEF->withIds( '937' );
		if( $_userId !== false ){
			$_objEF->withUserId( $_userId );
		}else{
			$_objEF->withoutUserId('1');
		}
		$_objEF->onlyStarted()->getList( $_arrCampaigns );
		$_arrCampaignIds=array();
		$_arrUsersIds=array();
		foreach( $_arrCampaigns as $_campaign ){
			$_arrCampaignIds[$_campaign['id']]=$_campaign['id'];
			$_arrUsersIds[$_campaign['user_id']]=true;
		}

		if( $_withLogger && $_memoryStart!==0 && memory_get_usage()-$_memoryStart > 200000000 ){
			$_logger->info('№1 Memory limit 200Mb' );
			$_logger->info('End--------------------------------------------------------------------------------------' );
			return;
		}
		$_usersObj=new Project_Users_Management();
		$_usersObj->withIds( array_keys( $_arrUsersIds ) )->withGroups()->getList( $_arrUsers );
		$_users2Access=array();
		foreach( $_arrUsers as &$mixRes ){
			Core_Acs::getUserAccessRights( $mixRes );
			$_users2Access[$mixRes['id']]='default';
			if( in_array( 'Email Funnels Performance', $mixRes['groups'] ) ){
				$_users2Access[$mixRes['id']]='performance';
			}
		}
		unset( $_arrUsers );
		foreach( $_arrCampaigns as &$_campaign ){
			if( $_users2Access[$_campaign['user_id']] == 'performance' ){
				$_campaign['limit']=1000;
			}else{
				$_campaign['limit']=100;
			}
		}
		if( $_withLogger && $_memoryStart!==0 && memory_get_usage()-$_memoryStart > 200000000 ){
			$_logger->info('№2 Memory limit 200Mb' );
			$_logger->info('End--------------------------------------------------------------------------------------' );
			return;
		}
		/*0*/do{// обрабатываем последовательно пользователей
			$userId=array_rand( $_arrUsersIds );
			// проверяем успел ли этот контакт обновить подписчиков
			try{
				Core_Sql::setConnectToServer( 'lpb.tracker' );
				//========
				$_countNeed=Core_Sql::getRecord( 'SELECT COUNT(*) as counter FROM `s8rs_events_'.$userId.'` WHERE campaign_id IS NULL' );
				if( $_countNeed['counter'] > 0 ){
					$mixRes=array();
				//					$_logger->info('Need update s8rs for user '.$userId.' check #'.$_countNeed['counter'].'#' );
					Core_Sql::renewalConnectFromCashe();
					continue;
				}
				//========
				Core_Sql::renewalConnectFromCashe();
			}catch( Exception $e ){
				Core_Sql::renewalConnectFromCashe();
			}
			if( is_file( Zend_Registry::get('config')->path->absolute->mailpool.'users'.DIRECTORY_SEPARATOR.$userId.'.ef' ) ){
				// сбрасываем пользователя, если его не обработал сборщик статистики
				unset( $_arrUsersIds[$userId] );
				continue;
			}
			echo "\nui".$userId;
			$_massSubscribersFull=$_massSubscribers=array();
			
			/** Получение всего списка SMTP серверов???? */
			$_settings=new Project_Efunnel_Settings();
			$_settings->keyRecordForm()->getList( $_campaignSMTP );

			$_subs=new Project_Efunnel_Subscribers($userId);
			$_subs->withEfunnelIds( $_arrCampaignIds )->withoutTags()->getRandom2k()->onlyValid()->getList( $_arrSubscribers );
			if( empty( $_arrSubscribers ) ){ // перезапрашиваем один раз, мало ли конец списка
				$_subs=new Project_Efunnel_Subscribers($userId);
				$_subs->withEfunnelIds( $_arrCampaignIds )->withoutTags()->getRandom2k()->onlyValid()->getList( $_arrSubscribers );
			}
			$_arrCampaignsIds=$_arrUpdatedSubscribers=$_arrMessageSubjectOpenRate=array();
			$_arrUnsubscribed=array();
			foreach( $_arrSubscribers as &$_subscribe ){ // собираем всех подписчиков для обработки
				if( !filter_var( $_subscribe['email'], FILTER_VALIDATE_EMAIL) || strpos( $_subscribe['email'], ' ' ) !== false ){
					echo "\nError email: ".$_subscribe['email'];
					$_statsData=array(
						'user_id'=>$userId,
						'email'=>$_subscribe['email'],
						'status'=>'not_valid',
					);
					file_put_contents( Zend_Registry::get('config')->path->absolute->mailpool.'users'.DIRECTORY_SEPARATOR.$userId.'.ef',serialize( $_statsData )."\r\n", FILE_APPEND );
					continue;
				}
				foreach( $_subscribe['efunnel_events'] as $_efEvent ){
					foreach( $_efEvent as $_eventName=>$_eventValue ){
						if( strpos($_eventName, 'mo2ar_request_')!==false ){
							foreach( unserialize( base64_decode( $_eventValue ) ) as $_dataName=>$_dataValue ){
								if( !empty( $_dataValue ) && !in_array( $_dataName, array('email', 'ip', 'userAgent','id','callback','-','_') ) ){
									$_subscribe['s8rData'][$_dataName]=$_dataValue;
								}
							}
						}
					}
				}
				foreach( unserialize( base64_decode( $_subscribe['settings'] ) ) as $_sdataName=>$_sdataValue ){
					if( !empty( $_sdataName ) && !empty( $_sdataValue ) ){
						$_subscribe['s8rData'][$_sdataName]=$_sdataValue;
					}
				}
				if( !empty( $_subscribe['name'] ) && $_subscribe['name']!='( )' ){
					$_subscribe['s8rData']['name']=$_subscribe['name'];
				}
				foreach( $_subscribe['efunnel_events'] as $_efEvent ){
					if( isset( $_efEvent['ef_unsubscribe_id'] ) ){
						$_arrUnsubscribed[$_subscribe['email'].'_'.$_efEvent['ef_unsubscribe_id']]=true;
						continue;
					}
					if( empty( $_efEvent['ef_id'] ) ){
						continue;
					}
					if( !isset( $_arrMessageSubjectOpenRate[$_efEvent['message_id']] ) ){
						$_arrMessageSubjectOpenRate[$_efEvent['message_id']]=array();
					}
					if( !isset( $_arrMessageSubjectOpenRate[$_efEvent['message_id']][$_efEvent['subject']] ) ){
						$_arrMessageSubjectOpenRate[$_efEvent['message_id']][$_efEvent['subject']]=array();
					}
					if( isset( $_efEvent['opened'] ) ){
						$_arrMessageSubjectOpenRate[$_efEvent['message_id']][$_efEvent['subject']]['opened']+=$_efEvent['opened'];
					}
					if( isset( $_efEvent['delivered'] ) ){
						$_arrMessageSubjectOpenRate[$_efEvent['message_id']][$_efEvent['subject']]['delivered']+=$_efEvent['delivered'];
					}
					$_arrCampaignsIds[$_efEvent['ef_id']]=true;
					if( !isset( $_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']] ) ){
						$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]=array(
							'email'=>$_subscribe['email'],
							'ef_id'=>$_efEvent['ef_id'],
							'status'=>$_subscribe['status'],
							'data'=>$_subscribe['s8rData']
						);
					}
					if( !isset( $_efEvent['message_id'] ) || empty( $_efEvent['message_id'] ) ){
						$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['added']=$_efEvent['added'];
					}else{
						if(!isset( $_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_id'] ) ){
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_id']=array();
						}
						if( isset( $_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_id'][$_efEvent['added']] ) ){
							$_added=$_efEvent['added'];
							do{
								$_added++;
							}while( isset( $_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_id'][$_added] ) );
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_id'][$_added]=$_efEvent['message_id'];
						}else{
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_id'][$_efEvent['added']]=$_efEvent['message_id'];
						}
						if(!isset( $_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_opened'] ) ){
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_opened']=array();
						}
						if( isset( $_efEvent['opened'] ) && !empty( $_efEvent['opened'] ) ){
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_opened'][$_efEvent['message_id']]=$_efEvent['opened'];
						}
						if(!isset( $_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_clicked'] ) ){
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_clicked']=array();
						}
						if( isset( $_efEvent['clicked'] ) && !empty( $_efEvent['clicked'] ) ){
							$_arrUpdatedSubscribers[$_subscribe['email'].'_'.$_efEvent['ef_id']]['message_clicked'][$_efEvent['message_id']]=$_efEvent['clicked'];
						}
					}
				}
			}
			foreach( $_arrMessageSubjectOpenRate as $_key=>&$_mess ){
				$_maxId=$_maxValue=false;
				foreach( $_mess as $_subjName=>$_subj ){
					if( isset( $_subj['opened'] ) && isset( $_subj['delivered'] ) ){
						$_subj=(int)( $_subj['opened']*100/$_subj['delivered'] );
						if( $_maxValue===false || $_maxValue <= $_subj ){
							$_maxId=$_subjName;
							$_maxValue=$_subj;
						}
					}
				}
				if( $_maxValue !== false ){
					$_mess=$_maxId;
				}else{
					unset( $_arrMessageSubjectOpenRate[$_key] );
				}
			}
			unset( $_arrSubscribers );
			foreach( $_arrUpdatedSubscribers as $_email2efs=>$_tmp ){
				if( isset( $_arrUnsubscribed[$_email2efs] ) ){
					unset( $_arrUpdatedSubscribers[$_email2efs] );
				}
			}
			//=======
			if( $_withLogger ){
				$_start=microtime(true)-$_start;
				$_logger->info('Get user '.$userId.' campaigns '.implode(', ', array_keys($_arrCampaignsIds)).' data count '.count($_arrUpdatedSubscribers).' time: '.$_start );
				$_start=microtime(true);
				if( $_memoryStart!==0 && memory_get_usage()-$_memoryStart > 200000000 ){
					$_logger->info('№3 Memory limit 200Mb' );
					$_logger->info('End--------------------------------------------------------------------------------------' );
					return; // выходим есть проблемы со списками, ресурсов не достаточно
				}
				if( $_start - $_firstStart > 600 ){
					$_logger->info('Time limit 600s' );
					$_logger->info('End--------------------------------------------------------------------------------------' );
					break; // выходим есть проблемы со списками, ресурсов не достаточно
				}
			}
			//=======
			$_fullLimit=1000;
		/*1*/foreach( $_arrCampaigns as $_k=>&$_campaign ){ // список кампаний
				if( $_campaign['user_id'] != $userId ){
					continue;
				}
				// ограничение по колличество у пользователя и по колличеству за вызов
				if( $_campaign['limit'] <= 0 ){
					break;
				}
				if( $_fullLimit <= 0 ){
					break 2;
				}
				if( !isset( $_arrCampaignsIds[$_campaign['id']] ) ){
					continue;
				}
				if( $_memoryStart!==0 && memory_get_usage()-$_memoryStart > 200000000 ){
					if( $_withLogger ){
						$_logger->info('№4 Memory limit 200Mb' );
						$_logger->info('End--------------------------------------------------------------------------------------' );
					}
					break 2;
				}
			/*2*/foreach( $_arrUpdatedSubscribers as $_subscriber ){
					if($_subscriber['ef_id'] == $_campaign['id']){
						$_flgValidateCampaign=Project_Validations_Realtime::check( $_campaign['user_id'], Project_Validations_Realtime::EMAIL_FUNNEL, $_subscriber['ef_id'] );
						
						if( $_flgValidateCampaign && in_array( $_subscriber['status'], array('deliverable', 'risky', null) ) || !$_flgValidateCampaign ){
							if( !isset( $_campaign['subscribers'][$_subscriber['email']] ) ){
								$_campaign['subscribers'][$_subscriber['email']]=array();
							}
							$_campaign['subscribers'][$_subscriber['email']][time()-$_subscriber['added']]=$_subscriber;
						}
					}
				}
				if( !isset( $_campaign['subscribers'] ) ){
					unset( $_arrCampaigns[$_k] );
					continue;
				}
				if( isset( $_campaignSMTP[$_campaign['smtp_id']] ) ){
					$_campaign['smtp']=$_campaignSMTP[$_campaign['smtp_id']];
					$_campaign['smtp']=unserialize( base64_decode( $_campaign['smtp']['settings'] ) );
				}
				if( empty( $_campaign['smtp']['smtp_server'] ) ){
					continue;
				}
				$_arrMessagesByPeriod=array();
				$_deltaMessageTime=0;
			/*2*/foreach( $_campaign['message'] as &$_message ){
					if( $_message['flg_pause'] != 0 ){
						continue;
					}
					if( empty( $_message['subject'] ) || empty( $_message['body_html'] ) ){
						$_model=new Project_Efunnel_Message();
						$_model->withIds($_message['id'])->del();
						continue;
					}
					$_periodInHours=(int)$_message['period_time']*($_message['flg_period']==2?24:1)*$this->_dTime+$_deltaMessageTime;
					$_deltaMessageTime=$_periodInHours;
					if( !isset( $_arrMessagesByPeriod[$_periodInHours] ) ){
						$_arrMessagesByPeriod[$_periodInHours]=$_message+array( 'timing_sec'=>$_periodInHours );
					}else{
						for( $_p=$_periodInHours; $_p<$_periodInHours+$this->_dTime; $_p++ ){
							if( !isset( $_arrMessagesByPeriod[$_p] ) ){
								$_arrMessagesByPeriod[$_p]=$_message+array( 'timing_sec'=>$_p );
								break;
							}
						}
					}
				}
				ksort( $_arrMessagesByPeriod );
			/*2*/foreach( $_arrMessagesByPeriod as $_period=>&$_updMessage ){
					$_updMessage['openRateSubject']=array();
				/*3*/foreach( $_arrUpdatedSubscribers as $_sTemp=>$_subscriber ){
						if( $_subscriber['added'] > time() ){
							continue;
						}
						// считаем сколько раз уже отправлено это $_updMessage['id']
						$_arrMes2SubCount=array_count_values( $_subscriber['message_id'] );
						
						$_resenderTimeChecker=@$_campaign['options']['resender_time'];
						if( empty( $_resenderTimeChecker ) ){
							$_resenderTimeChecker=24;
						}
						$_deltaSubTime=0;
					/*4*/foreach( $_arrMes2SubCount as $_check2 ){
							if( $_check2 >= 2 ){
								$_deltaSubTime+=$_resenderTimeChecker*$this->_dTime;
							}
						}
						// логика перехода на следующее сообщение, если предыдущее не открыто пользователем
						$_flgSendMsg=false;
						if( $_subscriber['ef_id'] == $_campaign['id']
							&& $_campaign['options']['flg_resender'] == 1
							&& $_arrMes2SubCount[$_updMessage['id']] < 2 // второе сообщние resender не отправляли
							&& $_subscriber['message_opened'][$_updMessage['id']] == 0 // ни одно из сообщений resender не открывали
							&& isset( $_subscriber['added'] )
						){
							if( array_search($_updMessage['id'], $_subscriber['message_id'])!==false && array_search($_updMessage['id'], $_subscriber['message_id']) > time()-$_resenderTimeChecker*$this->_dTime ){ // время после отправки первого сообщения менее 24 часов
								// ждем дальше... не ранее чем 24 часа отправка
							}elseif( $_period+$_deltaSubTime <= time()-$_subscriber['added'] ){
								// посылаем текущее сообщение
								if( !isset( $_updMessage['subscribers'] ) ){
									$_updMessage['subscribers']=array();
								}
								$_flgSendMsg=true;
								$_updMessage['subscribers'][]=array( 'email'=>$_subscriber['email'], 'data'=>(is_array($_subscriber['data'])?$_subscriber['data']:array())+array( 'email'=>$_subscriber['email'] ) );
								if( isset( $_arrMessageSubjectOpenRate[$_updMessage['id']] ) ){
									$_updMessage['openRateSubject'][$_subscriber['email']]=$_arrMessageSubjectOpenRate[$_updMessage['id']];
								}
							}else{
								// первое и второе не могут быть отправлены по времени
							}
							unset( $_arrUpdatedSubscribers[$_sTemp] );
						}elseif( $_subscriber['ef_id'] == $_campaign['id']
							&& ( !isset( $_subscriber['message_id'] ) || !in_array( $_updMessage['id'], $_subscriber['message_id'] ) )
							&& isset( $_subscriber['added'] )
							&& $_period <= time()-$_subscriber['added']
						){ // посылаем следующее сообщение
							if( !isset( $_updMessage['subscribers'] ) ){
								$_updMessage['subscribers']=array();
							}
							$_flgSendMsg=true;
							$_updMessage['subscribers'][]=array( 'email'=>$_subscriber['email'], 'data'=>(is_array($_subscriber['data'])?$_subscriber['data']:array())+array( 'email'=>$_subscriber['email'] ) );
						}
						// тут проверка на resend если нет в отправке этого сообщения
						// проверка на resender
						$_sendMsgValue=self::array_search_last( $_updMessage['id'], $_subscriber['message_id'] );
						if( !$_flgSendMsg
							&& $_subscriber['ef_id'] == $_campaign['id']
							&& $_sendMsgValue !== false
							&& $_sendMsgValue < intval( $_updMessage['resend']['start_time'] )
							&&( $_updMessage['resend']['select'] == 'all'
								|| ( $_updMessage['resend']['select'] == 'open' && isset( $_subscriber['message_opened'][$_updMessage['id']] ) )
								|| ( $_updMessage['resend']['select'] == 'nonopen' && !isset( $_subscriber['message_opened'][$_updMessage['id']] ) )
								|| ( $_updMessage['resend']['select'] == 'click' && isset( $_subscriber['message_clicked'][$_updMessage['id']] ) ) 
							)
							&& $_updMessage['resend']['start_time'] <= time()
						){
							if( !isset( $_updMessage['subscribers'] ) ){
								$_updMessage['subscribers']=array();
							}
							$_updMessage['subscribers'][]=array( 'email'=>$_subscriber['email'], 'data'=>(is_array($_subscriber['data'])?$_subscriber['data']:array())+array( 'email'=>$_subscriber['email'] ) );
						}
					}
				}
				$_campaign['message']=$_arrMessagesByPeriod;
				unset( $_arrMessagesByPeriod );
				$_return=array();
				$_port=25;
				if( !empty( $_campaign['smtp']['smtp_port'] ) ){
					$_port=(int)$_campaign['smtp']['smtp_port'];
				}
				$this->create(Zend_Registry::get('config')->path->absolute->mailpool.DIRECTORY_SEPARATOR.'servers'.DIRECTORY_SEPARATOR.Project_Efunnel_Sender::code( $_campaign['smtp']['smtp_server'] ).'.'.$_port);
			/*2*/foreach( $_campaign['message'] as $_send ){ // список сообщений
					// ограничение по колличество у пользователя и по колличеству за вызов
					if( $_campaign['limit'] <= 0 || $_fullLimit <= 0 ){
						break 2; // надо выхзодить на запись рассылки в базу
					}
					if( !isset( $_send['subscribers'] ) 
						|| empty( $_send['subscribers'] ) 
						|| !isset( $_campaign['smtp']['smtp_server'] )
						|| empty( $_campaign['smtp']['smtp_server'] )
					){
						continue;
					}
					// $_send['subscribers']=array_unique( $_send['subscribers'] ); не работает с массой данных
				/*3*/foreach( $_send['subscribers'] as $_emailData ){ // список подписчиков
						// ограничение по колличество у пользователя и по колличеству за вызов
						if( $_campaign['limit'] <= 0 || $_fullLimit <= 0 ){
							break 3; // надо выхзодить на запись рассылки в базу
						}
				echo "\n EFM combine";					
						$this->createSenderFile( $userId, $_campaign, $_send, $_emailData );

						//=======
						if( $_withLogger ){
							$_start=microtime(true)-$_start;
							$_logger->info('-------[ '.$_emailData['email'].' for '.$_campaign['id'].'.'.$_send['id'].' ]------' );
							if( $_start - $_firstStart > 600 ){
								$_logger->info('Time limit 600s' );
								$_logger->info('Go to saver' );
								break 3; // надо выхзодить на запись рассылки в базу
							}
						}
						//=======
					}
				}
			}
			unset( $_arrUsersIds[$userId] );
		}while( count($_arrUsersIds) > 0 );
		//=======
		if( $_withLogger ){
			$_start=microtime(true)-$_start;
			$_logger->info('End time: '.$_start );
			$_logger->info('End transaction -----------------------------------------------------------------------------------------------------' );
		}
		//=======
	}

	function createSenderFile($userId, $_campaign, $_send, $_emailData, $_flgSendSettings=true){
		if( empty( $_emailData['email'] ) ){
			return false;
		}
		$_port=25;
		if( !empty( $_campaign['smtp']['smtp_port'] ) ){
			$_port=(int)$_campaign['smtp']['smtp_port'];
		}
		$_subjectSend='';
		$_keys=$_names=array();
		foreach( $_campaign['options'] as $_key=>&$_name ){
			$_keys[]='%'.strtoupper( $_key ).'%';
			if( strpos( $_name, '|') !== false ){
				$_arrNames=explode( '|', $_name );
				$_name=array_filter( $_arrNames )[array_rand( array_filter( $_arrNames ) )];
			}
			$_names[]=$_name;
		}
		if( isset( $_send['subject'] ) && !empty( $_send['subject'] ) ){
			if( isset( $_send['openRateSubject'][$_emailData['email']] ) ){ // это пересылка сообщения с лучшим subject
				$_subjectSend=$_send['openRateSubject'][$_emailData['email']];
			}elseif( is_array( $_send['subject'] ) ){
				$_subjectSend=array_filter( $_send['subject'] )[array_rand( array_filter( $_send['subject'] ) )];
			}else{
				$_subjectSend=$_send['subject'];
			}
			$_subjectSend=str_replace( '%%%', '%', $_subjectSend );
			$_subjectSend=str_replace( '%%', '%', $_subjectSend );
			$_subjectSend=str_ireplace( $_keys, $_names, $_subjectSend );
		}
		echo "\nSend mr ". date("d-m-Y H:i:s", time()) . ": " . $_emailData['email'] . " " . $_campaign['id'] . "." . $_send['id'];
		try{
			$_strLen=$_campaign['id'].'a'.$_send['id'].'b';
			$_boundary=$_strLen.substr( md5($_emailData['email']), 32-strlen($_strLen) );
			$_saveData='';
			$_saveData.="EHLO ifunnels.com\r\n";
			$_saveData.="HELO ifunnels.com\r\n";
			if( isset( $_campaign['smtp']['smtp_user'] ) && !empty( $_campaign['smtp']['smtp_user'] ) ){
				$_saveData.="AUTH LOGIN\r\n";
				$_saveData.=base64_encode($_campaign['smtp']['smtp_user'])."\r\n";
			}
			if( isset( $_campaign['smtp']['smtp_pass'] ) && !empty( $_campaign['smtp']['smtp_pass'] ) ){
				$_saveData.=base64_encode($_campaign['smtp']['smtp_pass'])."\r\n";
			}
			if( isset( $_campaign['smtp']['replay_to'] ) && !empty( $_campaign['smtp']['replay_to'] ) ){
				$_saveData.="MAIL FROM: <".$_campaign['smtp']['replay_to'].">\r\n";
			}elseif( isset( $_campaign['smtp']['from_email'] ) && !empty( $_campaign['smtp']['from_email'] ) ){
				$_saveData.="MAIL FROM: <".$_campaign['smtp']['from_email'].">\r\n";
			}
			$_saveData.="RCPT TO: <".$_emailData['email'].">\r\n";
			$_saveData.="DATA\r\n";
			if( isset( $_campaign['smtp']['from_name'] ) && !empty( $_campaign['smtp']['from_name'] ) && isset( $_campaign['smtp']['from_email'] ) && !empty( $_campaign['smtp']['from_email'] ) ){
				$_saveData.="From: \"".$_campaign['smtp']['from_name']."\" <".$_campaign['smtp']['from_email'].">\r\n";
			}
			if( !empty( $_subjectSend ) ){
				$_checkSubject="SUBJECT: =?utf-8?B?".base64_encode( html_entity_decode( htmlspecialchars_decode( self::replaceData( $_subjectSend, $_emailData['data'] ) ), ENT_QUOTES ) )."?=\r\n";
				$_saveData.=$_checkSubject;
			}
			$_saveData.="To: ".$_emailData['email']."\r\n";
			$_saveData.="MIME-Version: 1.0\r\n";
			$_saveData.="Content-Type: multipart/alternative; boundary=".$_boundary."\r\n";
			$_saveData.="\r\n";
			if( isset( $_send['body_plain_text'] ) && !empty( $_send['body_plain_text'] ) ){
				$_saveData.="--".$_boundary."\r\n";
				$_saveData.="Content-Type: text/plain; charset=\"utf-8\"\r\n";
				$_saveData.="Content-Transfer-Encoding: base64\r\n";
				$_saveData.="\r\n";
				$_sendText=str_replace( '%%%', '%', $_send['body_plain_text'] );
				$_sendText=str_replace( '%%', '%', $_sendText );
				$_sendText=self::replaceData( $_sendText, $_emailData['data'] );
				$_saveData.=rtrim(chunk_split(base64_encode( str_replace( array( "\r\n", "\r", "\n", "\t" ), ' ', str_ireplace( $_keys, $_names, $_sendText ) )." ".str_replace( array( "\r\n", "\r", "\n", "\t" ), ' ', self::replaceData( $_campaign['smtp']['smtp_footer'], $_emailData['data'] ) )." If you wish to stop receiving our emails, visit this link to unsubscribe: ".
					"https://fasttrk.net/email-funnels/unsubscribe/?c=".urlencode( Core_Payment_Encode::encode( array( 'email'=>$_emailData['email'], 'efunnel_id'=>$_campaign['id'], 'user_id'=>$_campaign['user_id'] ) ) ) )));
				$_saveData.="\r\n";
			}
			if( isset( $_send['body_html'] ) && !empty( $_send['body_html'] ) ){
				$_sendBody=str_replace( '%%%', '%', $_send['body_html'] );
				$_sendBody=str_replace( '%%', '%', $_sendBody );
				$_sendBody=str_ireplace( $_keys, $_names, $_sendBody );
				$_sendBody=self::replaceData( $_sendBody, $_emailData['data'] );
				preg_match_all( '/<a(.*)href="(.*?)"/', $_sendBody, $_arrHref );
				$_links=$_updates=array();
				foreach( $_arrHref[2] as $_link ){
					if( in_array( $_link, $_links ) ){
						continue;
					}
					if( $_link[0] == '#' ){
						continue;
					}
					$_links[]='href="'.$_link.'"';
					$_updates[]='href="'.'https://fasttrk.net/email-funnels/webhook/?code='.urlencode( Project_Efunnel_Subscribers::encode( array( 
						'smtpid' => $_boundary, 
						'email' => $_emailData['email'], 
						'user_id'=>$_campaign['user_id'], 
						'event'=>'click',
						'subject'=>md5($_subjectSend),
						'link'=>preg_replace( '/((http)(s*)\:\/\/)+/im', '$1', $_link ), 
					) ) ).'"';
				}
				$_sendBody=str_ireplace( $_links, $_updates, $_sendBody );
				preg_match_all( '/<img(.*)>/', $_sendBody, $_arrImgs );
				$_attrs=$_updates=array();
				foreach( $_arrImgs[2] as $_attr ){
					if( in_array( $_attr, $_attrs ) ){
						continue;
					}
					$_attrs[]=$_attr;
					$_updates[]=' alt=""'.$_attr;
				}
				$_sendBody=str_ireplace( $_attrs, $_updates, $_sendBody );
				$_sendBody='<img alt="" src="https://fasttrk.net/email-funnels/webhook/?code='.urlencode( Project_Efunnel_Subscribers::encode( array( 
					'smtpid' => $_boundary, 
					'email' => $_emailData['email'], 
					'user_id'=>$_campaign['user_id'], 
					'event'=>'open',
					'subject'=>md5($_subjectSend),
					'time'=>time()
				) ) ).'" width="1" height="1" />'.$_sendBody;
				if( !empty( $_send['header_title'] ) ){
					$_sendBody='<span class="preheader" style="color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;">'.$_send['header_title'].'</span>'.$_sendBody;
				}
				$_footer='';
				if( isset( $_campaign['smtp']['smtp_footer'] ) && !empty( $_campaign['smtp']['smtp_footer'] ) ){
					$_footer=str_replace( array( "\r", "\n", "\t" ), '', str_replace( "\r\n", "<br/>", self::replaceData( $_campaign['smtp']['smtp_footer'], $_emailData['data'] ) ) );
				}
				$_defaultReferralData=@file_get_contents( './services/referral_link.txt' );
				if( !empty( $_defaultReferralData ) ){
					$_defaultReferralData=unserialize( $_defaultReferralData );
					if( isset( $_defaultReferralData['referral_link'] ) ){
						if( !isset( $_campaign['smtp']['referral_link'] ) || empty( $_campaign['smtp']['referral_link'] ) ){
							$_campaign['smtp']['referral_link']=$_defaultReferralData['referral_link'];
						}
						if( !isset( $_campaign['smtp']['referral_image'] ) || empty( $_campaign['smtp']['referral_image'] ) ){
							$_campaign['smtp']['referral_image']=$_defaultReferralData['referral_image'];
						}
					}
					$_footer.='<br/><a href="'.$_campaign['smtp']['referral_link'].'" traget="_blank" ><img src="'.$_campaign['smtp']['referral_image'].'" width="100px" /></a>';
				}
				// add referal link
				$_saveData.="--".$_boundary."\r\n";
				$_saveData.="Content-Type: text/html; charset=\"utf-8\"\r\n";
				$_saveData.="Content-Transfer-Encoding: base64\r\n";
				$_saveData.="\r\n";
				$_saveData.=rtrim(chunk_split(base64_encode( str_replace( array( "\r", "\n", "\t" ), '', $_sendBody )."<br/>".$_footer.'<br/>If you wish to stop receiving our emails, please <a href="https://fasttrk.net/email-funnels/unsubscribe/?c='.urlencode( Core_Payment_Encode::encode( array( 
					'email'=>$_emailData['email'], 
					'efunnel_id'=>$_campaign['id'], 
					'user_id'=>$_campaign['user_id'] 
				) ) ).'" target="_blank">click here to unsubscribe</a>.' )));
				$_saveData.="\r\n";
			}
			$_saveData.="\r\n";
			$_saveData.="--".$_boundary."--\r\n";
			$_saveData.=".\r\n";
			$_saveData.="QUIT\r\n";
			$_returnSMTP='';
			$_smtpCheck=microtime(true);
			if( $_flgSendSettings ){
				$_statsData=array(
					'user_id'=>$userId,
					'email'=>$_emailData['email'],
					'ef_id'=>$_campaign['id'],
					'message_id'=>$_send['id'],
					'delivered'=>1,
				//	'smtp'=>$_smtpMessageId, // nrz8anmmRSSiaVusg1y1gw
					'smtpid'=>$_boundary, // nrz8anmmRSSiaVusg1y1gw
					'subject'=>$_subjectSend
				);
			}else{
				$_statsData=array(
					'user_id'=>$userId,
					'ef_id'=>$_campaign['id'],
				);
			}
			$_campaign['limit']--;
			$_fullLimit--;
			$this->create(Zend_Registry::get('config')->path->absolute->mailpool.DIRECTORY_SEPARATOR.'servers'.DIRECTORY_SEPARATOR.Project_Efunnel_Sender::code( $_campaign['smtp']['smtp_server'] ).'.'.$_port);
			file_put_contents( Zend_Registry::get('config')->path->absolute->mailpool.DIRECTORY_SEPARATOR.'servers'.DIRECTORY_SEPARATOR.Project_Efunnel_Sender::code( $_campaign['smtp']['smtp_server'] ).'.'.$_port.DIRECTORY_SEPARATOR.$_boundary.'.ef', serialize($_statsData)."\r\n".$_saveData, LOCK_EX );
			if( !is_file( Zend_Registry::get('config')->path->absolute->mailpool.'users'.DIRECTORY_SEPARATOR.$userId.'.ef' ) ){
				file_put_contents( Zend_Registry::get('config')->path->absolute->mailpool.'users'.DIRECTORY_SEPARATOR.$userId.'.ef','', FILE_APPEND );
			}
		}catch( Exception $e ){
			echo "\nError ".$e->getMessage();
		}
	}

	function array_search_last($needle, $array, $strict = false) {
		$keys = array_keys($array);
		//Not sure how smart PHP is, so I'm trying to avoid IF for every iteration
		if($strict) {
		  for($i=count($keys)-1; $i>=0; $i--) {
			//strict search
			if($array[$keys[$i]]===$needle)
			  return $keys[$i];
		  } 
		}
		else {
		  for($i=count($keys)-1; $i>=0; $i--) {
			//benevolent search
			if($array[$keys[$i]]==$needle)
			  return $keys[$i];
		  } 
		}
	}
	
	public function del(){
		if ( empty( $this->_withIds ) ){
			$_bool=false;
		} else {
			Core_Sql::setExec( 'DELETE FROM '.$this->_table.' 
				WHERE id IN('.Core_Sql::fixInjection( $this->_withIds ).')'.($this->_onlyOwner&&$this->getOwnerId( $_intId )? ' AND user_id='.$_intId:'') );
			Core_Sql::setExec( 'DELETE FROM lpb_efunnels_message WHERE efunnel_id IN('.Core_Sql::fixInjection( $this->_withIds ).')' );
			try {
				Core_Sql::setConnectToServer( 'lpb.tracker' );
				//========
				Core_Sql::setExec( 'DELETE FROM lpb_efunnels_subscribers_'.$_intId.' WHERE sender_id IN('.Core_Sql::fixInjection( $this->_withIds ).')' );
				//========
				Core_Sql::renewalConnectFromCashe();
			} catch(Exception $e) {
				Core_Sql::renewalConnectFromCashe();
				return $this;
			}
			$_bool=true;
			if(Core_Acs::haveAccess( array( 'Automate' ) )){
				Project_Automation::setEvent( Project_Automation_Action::$type['REMOVE_EF'], $this->_withIds, false, array() ); 
			}
		}
		$this->init();
		return $_bool;
	}
	
}
?>