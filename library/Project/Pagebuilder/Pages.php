<?php
class Project_Pagebuilder_Pages extends Core_Data_Storage{
	protected $_table='pb_pages';
	protected $_fields = array( 
		'id', 
		'sites_id', 
		'pages_name', 
		'pages_timestamp', 
		'pages_title', 
		'pages_meta_keywords', 
		'pages_meta_description', 
		'pages_header_includes', 
		'pages_preview', 
		'pages_template', 
		'pages_css', 
		'created_at', 
		'modified_at', 
		'pagethumb', 
		'google_fonts', 
		'cloudflare_dns', 
		'pages_header_script', 
		'pages_footer_script', 
		'protected', 
		'primary_membership', 
		'drip_feed', 
		'optimization_test',
		'testab_page_id'
	);

	protected $_withPageName = false;
	protected $_withSiteId = false;
	protected $_isTemplate = false;
	private $_withEnableTestAB = false;

	public function withPageName($str){
		if(!empty($str)){
			$this->_withPageName = $str;
		}
		return $this;
	}

	public function withSiteId($id){
		if(!empty($id)){
			$this->_withSiteId = $id;
		}
		return $this;
	}

	public function isTemplate(){
		$this->_isTemplate = true;
		return $this;
	}

	public function withEnableTestAB() {
		$this->_withEnableTestAB = true;
		return $this;
	}

	public function beforeSet() {
		$this->_data->setFilter( array( 'clear' ) );

		if( ! empty( $this->_data->filtered['drip_feed'] ) ) {
			$this->_data->setElement( 'drip_feed', json_encode( $this->_data->filtered['drip_feed'] ) );
		}

		if( ! empty( $this->_data->filtered['optimization_test'] ) ) {
			$this->_data->setElement( 'optimization_test', json_encode( $this->_data->filtered['optimization_test'] ) );

			$testAB = new Project_Pagebuilder_TestAB();
			$result = $testAB
				->setEntered( 
					[ 
						'id' => ! empty( $this->_data->filtered['testab_page_id'] ) ? $this->_data->filtered['testab_page_id'] : null, 
						'pageid' => $this->_data->filtered['id'], 
						'current_option' => '#', 
						'access_options' => json_encode( $this->_data->filtered['access_options'] ) 
					] 
				)
				->set();

			unset( $this->_data->filtered['access_options'] );

			if( ! $result ) {
				return Core_Data_Errors::getInstance()->setError( 'Error with saving TestAB options' );
			} else {
				$testAB->getEntered( $testABData );
				$this->_data->setElement( 'testab_page_id', $testABData['id'] );
			}
		}

		return true;
	}

	public function set(){
		$this->_data->setFilter( array( 'clear' ) );
		
		if ( !$this->beforeSet() ){
			return false;
		}

		if( isset( $this->_data->filtered['pages_title'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_title'] );
		}
		if( isset( $this->_data->filtered['pages_meta_keywords'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_meta_keywords'] );
		}

		if( isset( $this->_data->filtered['pages_meta_description'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_meta_description'] );
		}

		if( isset( $this->_data->filtered['pages_header_includes'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_header_includes'] );
		}

		if( isset( $this->_data->filtered['pages_css'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_css'] );
		}

		if( isset( $this->_data->filtered['pages_header_script'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_header_script'] );
		}

		if( isset( $this->_data->filtered['pages_footer_script'] ) ) {
			$this->updateBaseData( $this->_data->filtered['pages_footer_script'] );
		}

		$this->_data->setElement( 'id', Core_Sql::setInsertUpdate( $this->_table, $this->_data->setMask( $this->_fields )->getValid()) );
		return $this->afterSet();
	}

	protected function assemblyQuery(){
		if ($this->_onlyIds) {
			$this->_crawler->set_select('d.id');
		} elseif ($this->_toSelect) {
			$this->_crawler->set_select('d.id, d.title');
		} else {
			$this->_crawler->set_select('d.*');
		}

		$this->_crawler->set_from($this->_table . ' d');

		if (!empty($this->_withIds)) {
			$this->_crawler->set_where('d.id IN (' . Core_Sql::fixInjection($this->_withIds) . ')');
		}

		if (!($this->_onlyOne || $this->_onlyCell)) {
			$this->_crawler->set_order_sort($this->_withOrder);
		}

		if (!empty($this->_withGroup)) {
			$this->_crawler->set_group($this->_withGroup);
		}

		if ($this->_withPageName) {
			$this->_crawler->set_where('d.pages_name = ' . Core_Sql::fixInjection($this->_withPageName));
		}

		if ($this->_withSiteId) {
			$this->_crawler->set_where('d.sites_id = ' . Core_Sql::fixInjection($this->_withSiteId));
		}

		if ($this->_isTemplate) {
			$this->_crawler->set_where('d.pages_template=1');
		}

		if ($this->_withEnableTestAB) {
			$this->_crawler->set_where("d.optimization_test LIKE '{\"enable\":\"true\",%'");
		}

		if ($this->_onlyOwner) {
			$this->_crawler->set_select('s.sites_name, s.url');
			$this->_crawler->set_from('INNER JOIN pb_sites as s ON d.sites_id = s.id');
			$this->_crawler->set_where('s.user_id = ' . Core_Users::$info['id']);
		}
	}

	public function del(){
		if( !empty( $this->_withIds ) ){
			$frames = new Project_Pagebuilder_Frames();
			$frames->withPageId($this->_withIds)->onlyIds()->getList($arrFrames);
			$frames->withIds($arrFrames)->del();
			parent::del();
		}
	}

	/**
	 * Creates a new page template or saves existing one
	 *
	 * @param  	array 		$siteData
	 * @param  	string 		$contents
	 * @param  	integer 	$templateID
	 * @return 	mixed 		$pageID/$templateID
	 */
	public function saveTemplate($siteData, $contents = '', $templateID = 0, $catID = 0){
		reset($siteData);
		$pageName = key($siteData);
		$framesModel = new Project_Pagebuilder_Frames();
		// Create new template
		if ($templateID == 0){
			$pagePreview = ($contents != '') ? base64_decode($contents) : '';

			$data = array(
				'pages_name' 				=> $pageName,
				'pages_timestamp' 			=> time(),
				'pages_preview' 			=> $pagePreview,
				'pages_template' 			=> 1,
				'pages_title' 				=> $siteData[$pageName]['pageSettings']['title'],
				'pages_meta_keywords' 		=> $siteData[$pageName]['pageSettings']['meta_keywords'],
				'pages_meta_description' 	=> $siteData[$pageName]['pageSettings']['meta_description'],
				'pages_header_includes' 	=> $siteData[$pageName]['pageSettings']['header_includes'],
				'pages_css' 				=> $siteData[$pageName]['pageSettings']['page_css']
			);

			if ($this->setEntered($data)->set()){
				$this->getEntered($pageData);
				$pageID = $pageData['id'];
				$frames = $siteData[$pageName]['blocks'];

				// Page is done, now all the frames for this page
				if (is_array($frames)){
					foreach ($frames as $frameData){
						$data = array(
							'pages_id' 				=> $pageID,
							'frames_content' 		=> $frameData['frameContent'], //urldecode(base64_decode(str_replace(' ', '+', $frameData['frameContent']))),
							'frames_height' 		=> $frameData['frameHeight'],
							'frames_original_url' 	=> $frameData['originalUrl'],
							'frames_sandbox' 		=> ($frameData['sandbox'])? 1: 0,
							'frames_loaderfunction' => $frameData['loaderFunction'],
							'frames_timestamp' 		=> time()
						);
						$framesModel->setEntered($data)->set();
					}
				}

				//thumbnail
				$screenshotUrl = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . Core_Module_Router::getCurrentUrl(array('name' => 'site1_ecom_funnels', 'action' => 'loadsinglepage', 'wg' => 'id=' . $pageID));
				$filename = 'templatethumb_' . $pageID . '.jpg';

				$screen = new Project_Pagebuilder_Screenshot();

				$screenshot = $screen->make_screenshot($screenshotUrl, $filename, '520x440', Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp/sitethumbs/');
				if ($screenshot !== false){
					$this->setEntered(array('id' => $pageID, 'pagethumb' => 'tmp/sitethumbs/' . $screenshot))->set();
				}
			} else {
				$pageID = FALSE;
			}

			return $pageID;
		}
		// Update existing template
		else {
			$pagePreview = ($contents != '') ? base64_decode($contents) : '';

			$data = array(
				'id'						=> $templateID,
				'pages_name' 				=> $pageName,
				'pages_timestamp' 			=> time(),
				'pages_preview' 			=> $pagePreview,
				'pages_template' 			=> 1,
				'pages_title' 				=> $siteData[$pageName]['pageSettings']['title'],
				'pages_meta_keywords' 		=> $siteData[$pageName]['pageSettings']['meta_keywords'],
				'pages_meta_description' 	=> $siteData[$pageName]['pageSettings']['meta_description'],
				'pages_header_includes' 	=> $siteData[$pageName]['pageSettings']['header_includes'],
				'pages_css' 				=> $siteData[$pageName]['pageSettings']['page_css']
			);

			$this->setEntered($data)->set();

			// Delete old frames
			$framesModel->withPageId($templateID)->getList($arrIdsFrames);
			$idsFrames = array();
			foreach($arrIdsFrames as $id){
				$idsFrames[] = $id['id'];
			}
			$framesModel->withIds($idsFrames)->del();

			// Insert new frames
			$frames = $siteData[$pageName]['blocks'];

			if (is_array($frames)){
				foreach ($frames as $frameData){
					$data = array(
						'pages_id' 				=> $templateID,
						'frames_content' 		=> $frameData['frameContent'], //urldecode(base64_decode(str_replace(' ', '+', $frameData['frameContent']))),
						'frames_height' 		=> $frameData['frameHeight'],
						'frames_original_url' 	=> $frameData['originalUrl'],
						'frames_sandbox' 		=> ($frameData['sandbox'] == 'true') ? 1 : 0,
						'frames_loaderfunction' => $frameData['loaderFunction'],
						'frames_timestamp' 		=> time()
					);
					$framesModel->setEntered($data)->set();
				}
			}
			//thumbnail
			$screenshotUrl = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/ifunnels-studio/loadsinglepage/?id=' . $templateID;
			$filename = 'templatethumb_' . $templateID . '.jpg';
			$screen = new Project_Pagebuilder_Screenshot();

			$screenshot = $screen->make_screenshot($screenshotUrl, $filename, '520x440', Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp/sitethumbs/');
			if ($screenshot !== false){
				$this->setEntered(array('id' => $templateID, 'pagethumb' => 'tmp/sitethumbs/' . $screenshot))->set();
			}
			return $templateID;
		}
	}

	private function updateBaseData(&$_str){
		$_str=str_replace( array( '\r', '\n' ), "", $_str );
		$_str=str_replace( array( "\r", "\n" ), "", $_str );
		$_str=str_replace( '\t', "", $_str );
	}

	public function getList(&$mixRes){
		parent::getList( $mixRes );
		if( array_key_exists( 'pages_title', $mixRes ) ) {
			$this->updateBaseData( $mixRes['pages_title'] );
			$this->updateBaseData( $mixRes['pages_meta_keywords'] );
			$this->updateBaseData( $mixRes['pages_meta_description'] );
			$this->updateBaseData( $mixRes['pages_header_includes'] );
			$this->updateBaseData( $mixRes['pages_css'] );
			$this->updateBaseData( $mixRes['pages_header_script'] );
			$this->updateBaseData( $mixRes['pages_footer_script'] );
			if( empty( $mixRes['drip_feed'] ) ) {
				$mixRes['drip_feed'] = ['enable' => 0, 'after_period' => 'month', 'value' => null];
			} else {
				$mixRes['drip_feed'] = json_decode( $mixRes['drip_feed'], true );
			}

			if( ! empty( $mixRes['optimization_test'] ) ) {
				$mixRes['optimization_test'] = json_decode( $mixRes['optimization_test'], true );
			}
		} else {
			foreach( $mixRes as &$_mixData ) {
				if( isset( $_mixData['pages_title'] ) ) {
					$this->updateBaseData( $_mixData['pages_title'] );
					$this->updateBaseData( $_mixData['pages_meta_keywords'] );
					$this->updateBaseData( $_mixData['pages_meta_description'] );
					$this->updateBaseData( $_mixData['pages_header_includes'] );
					$this->updateBaseData( $_mixData['pages_css'] );
					$this->updateBaseData( $_mixData['pages_header_script'] );
					$this->updateBaseData( $_mixData['pages_footer_script'] );
				}
				if( isset( $_mixData['drip_feed'] ) ) {
					if( empty( $_mixData['drip_feed'] ) ) {
						$_mixData['drip_feed'] = ['enable' => 0, 'after_period' => 'month', 'value' => null];
					} else {
						$_mixData['drip_feed'] = json_decode( $_mixData['drip_feed'], true );
					}
				}

				if( ! empty( $_mixData['optimization_test'] ) ) {
					$_mixData['optimization_test'] = json_decode( $_mixData['optimization_test'], true );
				}
			}
		}
	}

	/** Set protection for all pages
	 * 
	 * @param $site_id - int
	 * @param $memberships - array
	 * @param $primary_membership - int
	 * 
	 * @return bool
	 */
	public function setProtection( $site_id, $memberships, $primary_membership ) {
		/** Getting all pages for site */
		$this
			->withSiteId( $site_id )
			->getList( $pagesData );

		if( empty( $pagesData ) ) return false;

		$membership = new Project_Pagebuilder_Memberships();
		foreach( $pagesData as $page ) {

			/** Enable protect for the page */
			$this
				->setEntered( [
					'id' => $page['id'],
					'protected' => '1',
					'primary_membership' => $primary_membership
				] )
				->set();

			/** Getting all added memberships to the page */
			$membership
				->withType( Project_Pagebuilder_Memberships::PAGE )
				->withSiteId( $site_id )
				->withPageId( $page['id'] )
				->getList( $arrMemberships );

			/** Delete all added memberships */
			$membership
				->withIds( array_column( $arrMemberships, 'id' ) )
				->del();

			/** Add new memberships to the page */
			foreach( $memberships as $_membership ) {
				$membership
					->setEntered(
						[
							'type' => Project_Pagebuilder_Memberships::PAGE,
							'site_id' => $site_id,
							'resource_id' => $page['id'],
							'membership_id' => $_membership
						]
					)
					->set();
			}
		}

		return true;
	}

	protected function init(){
		parent::init();
		$this->_withPageName = false;
		$this->_withSiteId = false;
		$this->_isTemplate = false;
		$this->_withEnableTestAB = false;
	}
}