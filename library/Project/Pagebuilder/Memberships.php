<?php
class Project_Pagebuilder_Memberships extends Core_Data_Storage {

	const SITE = 1;
	const PAGE = 2;
	
	protected $_table = 'pb_memberships';
	protected $_fields = array( 'id', 'type', 'site_id', 'resource_id', 'membership_id', 'edited', 'added' );

	/** Installing */
	public static function install(){
		Core_Sql::setExec( "DROP TABLE IF EXISTS pb_memberships" );
		Core_Sql::setExec( 
			"CREATE TABLE `pb_memberships` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`type` TINYINT(1) NULL DEFAULT NULL,
				`site_id` INT(11) NULL DEFAULT NULL,
				`resource_id` INT(11) NOT NULL DEFAULT '0',
				`membership_id` TEXT NULL DEFAULT NULL,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				`edited` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;" 
		);
	}

	private $_withSiteId = false;
	public function withSiteId( $site_id ) {
		$this->_withSiteId = $site_id;

		return $this;
	}

	private $_withType = false;
	public function withType( $type ) {
		$this->_withType = $type;

		return $this;
	}

	private $_withPageId = false;
	public function withPageId( $page_id ) {
		$this->_withPageId = $page_id;

		return $this;
	}

	private $_onlyMembershipsId = false;
	public function onlyMembershipsId() {
		$this->_onlyMembershipsId = true;
		return $this;
	}

	protected function init() {
		parent::init();

		$this->_withSiteId = false;
		$this->_withTypeId = false;
		$this->_withPageId = false;
	}

	protected function assemblyQuery(){
		parent::assemblyQuery();

		if( ! empty( $this->_withSiteId ) ){
			$this->_crawler->set_where( 'd.site_id = ' . Core_Sql::fixInjection( $this->_withSiteId ) );
		}

		if( ! empty( $this->_withType ) ){
			$this->_crawler->set_where( 'd.type = ' . Core_Sql::fixInjection( $this->_withType ) );
		}

		if( ! empty( $this->_withPageId ) ){
			$this->_crawler->set_where( 'd.resource_id = ' . Core_Sql::fixInjection( $this->_withPageId ) );
		}

		// $this->_crawler->get_sql( $_strSql, $this->_paging );
		// p( array($_strSql, $this->_paging) );
	}

	public function getList( &$mixRes ) {
		parent::getList( $mixRes );

		if( $this->_onlyMembershipsId ) {
			if( array_key_exists( '0', $mixRes ) ) {
				$mixRes = array_column( $mixRes, 'membership_id' );
			} else {
				$mixRes = $mixRes['membership_id'];
			}

			$this->_onlyMembershipsId = false;
		}
		return $this;
	}
}