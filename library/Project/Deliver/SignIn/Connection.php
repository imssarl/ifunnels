<?php

class Project_Deliver_SignIn_Connection extends Core_Data_Storage {

	protected $_table = 'deliver_plan_customer';
	protected $_fields = array( 'id', 'customer_id', 'membership_id', 'added_by_user', 'added' );

	private $_withMembershipId = false;
	private $_withCustomerId = false;
	private $_withEmail = false;
	private $_getUserData = false;
	private $_flgSendNotification = false;
	private $_withMembersId = false;
	private $_withLimit = false;
	private $_withMembershipName = false;
	private $_withMemberEmail = false;
	private $_withFilter = false;
	private $_withTime = false;
	private $_addedByUser = false;

	/** Installing */
	public static function install(){
		Core_Sql::setExec( "DROP TABLE IF EXISTS deliver_plan_customer" );
		Core_Sql::setExec( 
			"CREATE TABLE `deliver_plan_customer` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`customer_id` INT(11) NULL DEFAULT NULL,
				`membership_id` INT(11) NULL DEFAULT NULL,
				`added_by_user` INT(11) NULL DEFAULT NULL,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;" 
		);
	}

	public function beforeSet() {
		$this->_data->setFilter( array( 'clear' ) );

		/** Check exist record in a table */
		if( $this->getCustomerData( $this->_data->filtered['customer_id'], $this->_data->filtered['membership_id'] ) !== false ) {
			return false;
		}

		$this->_flgSendNotification = $this->_data->filtered['flgSendNotification'];

		return true;
	}

	public function afterSet() {
		if( $this->_flgSendNotification ) {
			$member = new Project_Deliver_Member();
			$member
				->withIds( $this->_data->filtered['customer_id'] )
				->onlyOne()
				->getList( $customerData );
	
			$membership = new Project_Deliver_Membership();
			$membership
				->withIds( $this->_data->filtered['membership_id'] )
				->onlyOne()
				->getList( $dataMembership );

			$site = new Project_Deliver_Site();
			$site
				->withIds( $dataMembership['site_id'] )
				->onlyOne()
				->getList( $siteData );

			$site_url = ( ! empty( $_SERVER['HTTPS'] ) && 'off' !== strtolower( $_SERVER['HTTPS'] ) ? 'https://' : 'http://' ) . $_SERVER['HTTP_HOST'];

			// Forgot password link
			$forgot_link = $site_url . Core_Module_Router::getInstance()->generateFrontendUrl( [
				'name' => 'site1_deliver', 
				'action' => 'forgot_password', 
				'w' => [
					'token' => base64_encode( serialize( [ 'membership' => $dataMembership['id'] ] ) ) 
				] 
			] );
	
			/** Send email for user with generated password */
			$mailer = new Core_Mailer();
			$mailer
				->setVariables( 
					[ 
						'email' => $customerData['email'],
						'membership' => $siteData['name'] . ' - ' . $dataMembership['name'],
						'membership_home_page_url' => $dataMembership['home_page_url'],
						'forgot_link' => $forgot_link
					] 
				)
				->setTemplate( 'deliver_access' )
				->setSubject( 'Your Purchase Details: ' . $siteData['name'] . ' - ' . $dataMembership['name'] )
				->setPeopleTo( [ 'email'=> $customerData['email'], 'name'=> $customerData['email'] ] )
				->setPeopleFrom( 
					[ 
						'name' => Zend_Registry::get( 'config' )->engine->project_sysemail->name, 
						'email' => 'orders@ifunnels.com' 
					] 
				)
				->sendOneToMany();

			$this->_flgSendNotification = false;
		}

		return true;
	}

	public function withMembershipId( $membership_id ) {
		if( ! empty( $membership_id ) ) {
			$this->_withMembershipId = $membership_id;
		}

		return $this;
	}
	
	public function withCustomerId( $customer_id ) {
		$this->_withCustomerId = $customer_id;

		return $this;
	}

	public function withEmail( $email ) {
		$this->_withEmail = $email;

		return $this;
	}

	public function getUserData() {
		$this->_getUserData = true;
		return $this;
	}

	public function withMembersId( $array ) {
		$this->_withMembersId = $array;
		return $this;
	}

	public function withLimit( $limit ) {
		if( is_integer( $limit ) ) {
			$this->_withLimit = $limit;
		}

		return $this;
	}

	public function withMembershipName() {
		$this->_withMembershipName = true;
		return $this;
	}

	public function withMemberEmail() {
		$this->_withMemberEmail = true;
		return $this;
	}

	public function withFilter( $filter ) {
        if( ! empty( $filter['time'] ) ) {
			$this->withTime( $filter['time'], $filter['date_from'], $filter['date_to'] );
        }
		return $this;
	}
	
	public function addedByUser() {
		$this->_addedByUser = true;
		return $this;
	}

    public function withTime( $_type, $from, $to ){
		$_now = time();
		switch( $_type ){
			case Project_Statistics_Api::TIME_ALL: $this->_withTime = [ 'from' => 0, 'to' => $_now ]; break;
			case Project_Statistics_Api::TIME_TODAY: $this->_withTime = [ 'from' => strtotime( 'today' ), 'to' => $_now ]; break;
			case Project_Statistics_Api::TIME_YESTERDAY: $this->_withTime = [ 'from' => strtotime( 'yesterday' ), 'to' => strtotime( 'today' ) ]; break;
			case Project_Statistics_Api::TIME_LAST_7_DAYS: $this->_withTime = [ 'from' => $_now - 60 * 60 * 24 * 7, 'to' => $_now ]; break;
			case Project_Statistics_Api::TIME_THIS_MONTH: $this->_withTime = [ 'from' => strtotime( 'first day of this month' ), 'to' => $_now ]; break;
			case Project_Statistics_Api::THIS_YEAR: $this->_withTime = [ 'from'=>strtotime( 'first day of January ' . date( 'Y' ) ), 'to' => $_now ]; break;
			case Project_Statistics_Api::TIME_LAST_YEAR: $this->_withTime = [ 'from' => $_now - 60 * 60 * 24 * 365, 'to' => $_now ]; break;
			case 8:
				$_from = $from;
				if( ! is_int( $from ) ) {
					$_from = strtotime( $from );
				}
				$_to = $to;
				if( ! is_int( $to ) ) {
					$_to = strtotime( $to );
                }
                
				$this->_withTime = [ 'from' => $_from, 'to' => $_to ];
			break;
        }
        
		return $this;
	}

	protected function assemblyQuery() {
		parent::assemblyQuery();

		if( $this->_getUserData ) {
			$this->_crawler->clean_select();
			$this->_crawler->set_select( 's.id as id, s.customer_id as member_id, c.email as email, s.password as password, s.secretkey as secretkey, s.last_login_datetime as last_login_datetime, d.membership_id' );
			$this->_crawler->set_from( 'INNER JOIN `deliver_signin` s on d.customer_id = s.customer_id and d.membership_id IN (' . Core_Sql::fixInjection( $this->_withMembershipId ) . ')' );
			$this->_crawler->set_from( 'INNER JOIN `deliver_customer` c on s.customer_id = c.id AND c.email = ' . Core_Sql::fixInjection( $this->_withEmail ) );
		} else {
			if( ! empty( $this->_withMembershipId ) ){
				$this->_crawler->set_where( 'd.membership_id IN (' . Core_Sql::fixInjection( $this->_withMembershipId ) . ')' );
			}

			if( ! empty( $this->_withCustomerId ) ) {
				$this->_crawler->set_where( 'd.customer_id = ' . Core_Sql::fixInjection( $this->_withCustomerId ) );
			}

			if( ! empty( $this->_withMembersId ) ) {
				$this->_crawler->set_where( 'd.customer_id IN (' . Core_Sql::fixInjection( $this->_withMembersId ) . ')' );
			}
		}

		if( $this->_withLimit ) {
			$this->_crawler->set_limit( $this->_withLimit );
		}

		if( $this->_withMembershipName ) {
			$this->_crawler->set_select( 'm.name as name, m.type as type' );
			$this->_crawler->set_from( 'RIGHT JOIN `deliver_membership` m ON d.membership_id = m.id' );
		}

		if( $this->_withMemberEmail ) {
			$this->_crawler->set_select( 'c.email as email' );
			$this->_crawler->set_from( 'RIGHT JOIN `deliver_customer` c ON d.customer_id = c.id' );
		}

		if( $this->_withTime ) {
            $this->_crawler->set_where( 'd.added >= ' . $this->_withTime["from"] . ' AND d.added <= ' . $this->_withTime["to"] );
		}
		
		if( $this->_addedByUser ) {
			$this->_crawler->set_where( 'd.added_by_user IS NOT NULL' );
		}

		// $this->_crawler->get_sql( $_strSql, $this->_paging );
		// p( $_strSql );
	}

	protected function init() {
		$this->_withMembershipId = false;
		$this->_withCustomerId = false;
		$this->_getUserData = false;
		$this->_withEmail = false;
		$this->_withMembersId = false;
		$this->_withLimit = false;
		$this->_withMembershipName = false;
		$this->_withMemberEmail = false;
		$this->_withFilter = false;
		$this->_withTime = false;
		$this->_addedByUser = false;
	}

	public function getList( &$mixRes ){
		parent::getList( $mixRes );

		$this->init();
		return $this;
	}

	/**
	 * Find data in the table by field [customer_id] and return data record if exists
	 * 
	 * @param $customer_id - int
	 * 
	 * @return bool or array
	 */
	private function getCustomerData( $customer_id, $membership_id ) {
		$this
			->withCustomerId( $customer_id )
			->withMembershipId( $membership_id )
			->onlyOne()
			->getList( $dataObj );

		if( empty( $dataObj ) ) return false;

		return $dataObj;
	}
}