<?php
class Project_Efunnel_Message extends Core_Data_Storage {

	protected $_table='lpb_efunnels_message';
	protected $_fields=array( 'id', 'efunnel_id', 'name', 'subject', 'body_html', 'body_plain_text', 'header_title', 'period_time', 'flg_period', 'flg_pause', 'position', 'resend', 'edited', 'added' );
	
	public static function install(){
		Core_Sql::setExec("drop table if exists lpb_efunnels_message");
		Core_Sql::setExec( "CREATE TABLE `lpb_efunnels_message` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`efunnel_id` INT(11) NOT NULL DEFAULT '0',
			`name` VARCHAR(100) NULL DEFAULT NULL,
			`subject` TEXT NULL,
			`body_html` TEXT NULL,
			`body_plain_text` TEXT NULL,
			`header_title` VARCHAR(100) NULL DEFAULT NULL,
			`flg_period` INT(1) NOT NULL DEFAULT '0',
			`period_time` INT(4) NOT NULL DEFAULT '0',
			`flg_pause` TINYINT(1) NOT NULL DEFAULT '0',
			`position` INT(2) NOT NULL DEFAULT '0',
			`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
			`edited` INT(11) UNSIGNED NOT NULL DEFAULT '0',
			UNIQUE INDEX `id` (`id`)
		)
		COLLATE='utf8_general_ci'
		ENGINE=InnoDB;" );
	}
	
	private $_withEfunnelId=false;
	
	protected function init(){
		parent::init();
		$this->_withEfunnelId=false;
	}
	
	public function withEfunnelId( $_arrIds=false ){
		$this->_withEfunnelId=$_arrIds;
		return $this;
	}

	public function activate( $message_id, $flg_pause ){
		Core_Sql::setExec( 'UPDATE '. $this->_table .' SET `flg_pause` = "' . $flg_pause . '" WHERE `id`="' . $message_id . '";' );
	}
	
	public function addResend ($resendSettings = []) 
	{
		$message_id = $resendSettings['id'];
		$with_action = $resendSettings['select'];

		$crawler = new Core_Sql_Qcrawler();
		$crawler->set_select('efunnel_id');
		$crawler->set_from($this->_table);
		$crawler->set_where("id = $message_id");

		$ef_id = Core_Sql::getCell($crawler->get_result_full());
		$stats = [];

		try {
			Core_Sql::setConnectToServer( 'lpb.tracker' );

			$crawler = new Core_Sql_Qcrawler();
			$crawler->set_select('d.email, d.settings, d.name, e.search_text AS data, e.campaign_id AS ef_id, e.search_int AS message_id');

			$crawler->set_from('s8rs_' . Core_Users::$info['id'] . ' d');
			$crawler->set_from('LEFT JOIN s8rs_events_' . Core_Users::$info['id'] . ' e ON d.id = e.sub_id');

			$crawler->set_where('e.campaign_type IN (' . join(',', [Project_Subscribers_Events::EF_ID, Project_Subscribers_Events::EF_UNSUBSCRIBE_ID]) . ')');
			$crawler->set_where("e.campaign_id = $ef_id");
			$crawler->set_where("e.search_int = $message_id");

			$stats = Core_Sql::getAssoc($crawler->get_result_full());

			if (!empty($stats)) {
				$stats = array_map(function($record){
					$record['data'] = json_decode($record['data'], true);
					$record['settings'] = unserialize(base64_decode($record['settings']));
					return $record;
				}, $stats);
			}
			
			Core_Sql::renewalConnectFromCashe();
		} catch (Exception $e) {
			Core_Sql::renewalConnectFromCashe();
		}

		// Filtered contacts
		if (in_array($with_action, ['open', 'nonopen', 'click'])) {
			$stats = array_filter($stats, function($record) use ($with_action) {
				if ($with_action == 'open') {
					return !empty($record['data']['opened']);
				}

				if ($with_action == 'nonopen') {
					return empty($record['data']['opened']);
				}

				if ($with_action == 'click') {
					return !empty($record['data']['clicked']);
				}

				return true;
			});
		}

		if (!empty($stats)) {
			$insertData = [];

			foreach ($stats as $record) {
				$settings = (is_array($record['settings']) ? $record['settings'] : []) + ['name' => $record['name']];

				$insertData[] = [
					'ef_id'       => $ef_id,
					'message_id'  => $message_id,
					'email'       => $record['email'],
					'send_date'   => $resendSettings['start_time'],
					'email_data'  => base64_encode(serialize($settings)),
					'flg_resend'  => 0,
					'flg_sendone' => 1,
					'flg_status'  => 0,
					'added'       => time(),
				];
			}

			Core_Sql::setMassInsert('lpb_efunnels_mailer', $insertData);
		}
	}
	
	protected function assemblyQuery(){
		parent::assemblyQuery();
		if ( !empty( $this->_withEfunnelId ) ){
			$this->_crawler->set_where( 'd.efunnel_id IN ('.Core_Sql::fixInjection( $this->_withEfunnelId ).')' );
		}
	}
	
	public function del(){
		$_bool=false;
		if ( !empty( $this->_withIds ) ){
			Core_Sql::setExec( 'DELETE FROM '.$this->_table.' 
				WHERE id IN('.Core_Sql::fixInjection( $this->_withIds ).')' );
			$_bool=true;
		}
		if( !empty( $this->_withEfunnelId ) ){
			Core_Sql::setExec( 'DELETE FROM '.$this->_table.' 
				WHERE efunnel_id IN('.Core_Sql::fixInjection( $this->_withEfunnelId ).')' );
			$_bool=true;
		}
		$this->init();
		return $_bool;
	}
	
	protected function beforeSet(){
		$this->_data->setFilter(array('trim','clear'));
		foreach( $this->_data->filtered['subject'] as &$_subject ){
			$_subject=htmlentities( $_subject, ENT_QUOTES );
		}
		$_updateSubject=base64_encode( serialize( $this->_data->filtered['subject'] ) );
		$this->_data->setElement('subject', $_updateSubject );
		$_updateOptions=base64_encode( serialize( $this->_data->filtered['resend'] ) );
		$this->_data->setElement('resend', $_updateOptions );
		$this->_data->setFilter(array('trim','clear'));
		return true;
	}

	public function getList( &$mixRes ){
		parent::getList($mixRes);
		if( is_int( array_keys($mixRes)[0] ) ){
			foreach( $mixRes as &$_arrZeroData ){
				if( isset( $_arrZeroData['subject'] ) ){
					$_oldSubject=$_arrZeroData['subject'];
					$_arrZeroData['subject']=unserialize( base64_decode( $_arrZeroData['subject'] ) );
					if( $_arrZeroData['subject']===false || $_arrZeroData['subject']===NULL ){
						$_arrZeroData['subject']=$_oldSubject;
					}
				}
				if( isset( $_arrZeroData['resend'] ) ){
					$_oldSettings=$_arrZeroData['resend'];
					$_arrZeroData['resend']=unserialize( base64_decode( $_arrZeroData['resend'] ) );
					if( $_arrZeroData['resend']===false ){
						$_arrZeroData['resend']=$_oldSettings;
					}
				}
			}
		}elseif( isset( $mixRes['subject'] ) ){
			$_oldSubject=$mixRes['subject'];
			$mixRes['subject']=unserialize( base64_decode( $mixRes['subject'] ) );
			if( $mixRes['subject']===false || $mixRes['subject']===NULL ){
				$mixRes['subject']=$_oldSubject;
			}
			$_oldSettings=$mixRes['resend'];
			$mixRes['resend']=unserialize( base64_decode( $mixRes['resend'] ) );
			if( $mixRes['resend']===false ){
				$mixRes['resend']=$_oldSettings;
			}
		}
		$this->init();
		return $this;
	}
}
?>