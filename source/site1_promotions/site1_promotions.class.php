<?php
class site1_promotions extends Core_Module {

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'Url Promotions', ),
			'actions'=>array(
				array( 'action'=>'custom_promotions', 'title'=>'Custom Posts Promotions', 'flg_tree'=>1 ),
				array( 'action'=>'mass_promotions', 'title'=>'Mass Social Campaign Creation ', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Social Media Campaigns', 'flg_tree'=>1 ),
				array( 'action'=>'default_settings', 'title'=>'Default Campaign Settings', 'flg_tree'=>1 ),
				array( 'action'=>'popup', 'title'=>'Promotions popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'request_url', 'title'=>'Request url', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'ajax_pause', 'title'=>'Ajax Pause Resume', 'flg_tpl'=>3, 'flg_tree'=>2 ),
			),
		);
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_synnd=new Project_Synnd();
		if( !empty( $_POST['del'] ) ) {
			if ( $_synnd->del( $_POST['del'] ) ) {
				$this->objStore->set( array( 'msg'=>'delete' ) );
			} else {
				$_synnd->getErrors($arrErr);
				$this->objStore->set( array( 'errFlow'=>end($arrErr) ) );
			}
			$this->location();
		}
		if( !empty( $_GET['id'] ) ) {
			if( !$_synnd->withIds($_GET['id'])->get_file() ){
				$_synnd->getErrors($arrErr);
				$this->out['errFlow']=end($arrErr);
			}
		}
		$_synnd
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->withOrder( @$_GET['order'] )
			->onlyOwner()
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		foreach( $this->out['arrList'] as &$_arrCampaign ){
			$_report=new Project_Synnd_Reports();
			$_report			
				->withCampaignId( $_arrCampaign['id']  )
				->getList( $_node );
			foreach( $_node as $_report ){
				if( $_report['flg_status']==2 ){
					$_arrCampaign['flg_errors']=1;
					continue 1;
				}
			}
		}
	}

	public function custom_promotions() {
		$this->objStore->getAndClear( $this->out );
		$_synnd=new Project_Synnd();
		if( !empty( $_POST ) ) {
			if( $_synnd->setEntered( $_POST['arrCampaign'] )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'strMsg'=>true ) );
				$this->location( array( 'action'=>'manage' ) );
			}
			$this->out=Core_Data_Errors::getInstance()->getErrors();
			$_synnd->getEntered( $this->out['arrCampaign'] );
		}
		if( empty( $this->out['arrCampaign']['settings'] ) ) {
			$_synnd->getDefaultSettings( Core_Users::$info['id'], $_arrSettings );
			$this->out['arrCampaign']['settings']=$_arrSettings['settings'];
		}
		$_category=new Core_Category( 'Category_Synnd' );
		$_category->getLevel( $this->out['arrCategories'] );
		$_model=new Project_Placement();
		$_model->onlyOwner()->getList( $this->out['arrDomains'] );
		$_synnd->getSocialNewsSites( $this->out['arrSites'] );
	}
	
	public function mass_promotions() {
		$this->objStore->getAndClear( $this->out );
		$_synnd=new Project_Synnd();
		if( !empty( $_POST ) ) {
			$_campaigns=$_POST['arrCampaigns'];
			$_errors=array();
			foreach( $_campaigns['title'] as $_key=>$_v ){
				$_submitCampaign=$_POST['arrCampaign'];
				unset( $_submitCampaign['arrCampaigns'] );
				$_inputArray=array(
					'url'=>$_campaigns['url'][$_key],
					'title'=>$_campaigns['title'][$_key],
					'tags'=>$_campaigns['tags'][$_key],
					'description'=>$_campaigns['description'][$_key]
				);
				$_submitCampaign['settings']=$_inputArray+$_submitCampaign['settings'];
				if( !$_synnd->setEntered( $_submitCampaign )->set() ) {
					$_errors[$_key]=$_inputArray+array( 'errors'=>Core_Data_Errors::getInstance()->getErrorsFlow() );
					Core_Data_Errors::getInstance()->reset();
				}
			}
			if( !empty( $_errors ) ){
				$this->out['errFlow']=json_encode( $_errors );
			}else{
				$this->out['strMsg']='saved';
			}
			$this->out['arrCampaigns']=$_campaigns;
		}
		if( empty( $this->out['arrCampaign']['settings'] ) ) {
			$_synnd->getDefaultSettings( Core_Users::$info['id'], $_arrSettings );
			$this->out['arrCampaign']['settings']=$_arrSettings['settings'];
		}
		$_synnd->getSocialNewsSites( $this->out['arrSites'] );
		$_category=new Core_Category( 'Category_Synnd' );
		$_category->getLevel( $this->out['arrCategories'] );
		$_model=new Project_Placement();
		$_model->onlyOwner()->getList( $this->out['arrDomains'] );
	}

	public function default_settings() {
		$_synnd=new Project_Synnd();
		if( isset($_POST['arrCampaign']['settings'])) {
			$_synnd->setDefaultSettings( Core_Users::$info['id'], $_POST['arrCampaign']['settings'] );
		}
		$_synnd
			->getDefaultSettings( Core_Users::$info['id'], $this->out['arrCampaign'] )
			->getSocialNewsSites( $this->out['arrSites'] );
		$_category=new Core_Category( 'Category_Synnd' );
		$_category->getLevel( $this->out['arrCategories'] );
	}

	public function popup() {
		$_synnd=new Project_Synnd();
		if( isset( $_GET['promotions'] ) ) {
			$_report=new Project_Synnd_Reports();
			$_report			
				->withPaging( array(
					'url'=>@$_GET,
					'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
					'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
				) )
				->withCampaignId( @$_GET['id']  )
				->getList( $this->out['arrPromotions'] );
			$this->out['arrTypes']=array();
			foreach( $this->out['arrPromotions'] as $_promotion ) {
				if( !isset( $this->out['arrTypes'][$_promotion['flg_type']] ) )
					$this->out['arrTypes'][$_promotion['flg_type']]=array(0,0);
					$this->out['arrTypes'][$_promotion['flg_type']][$_promotion['flg_status']]+=$_promotion['promote_count'];
					if( $_promotion['flg_status'] != 2 ){
						$this->out['synndErrors'][$_promotion['error_code']]=Project_Synnd_Reports::$_errorCode[$_promotion['error_code']];
					}
			}
		}elseif( isset( $_GET['schedule'] ) && isset($_GET['id']) ) {
			if( isset($_POST['save'])) {
				$_synnd=new Project_Synnd();
				if( !$_synnd->withIds( $_GET['id'] )->setType( $_POST['arrCampaign']['flg_type'] ) ) {
					$this->out=Core_Data_Errors::getInstance()->getErrors();
					$this->out['arrCampaign']=$_POST['arrCampaign'];
					$this->out['schedule']=true;
					return;
				}
				$this->out['strMsg']='saved';
			}
			$_synnd->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrCampaign'] );
			$this->out['schedule']=true;
		}else{
			$_category=new Core_Category( 'Category_Synnd' );
			if( isset($_POST['save'])) {
				$_synnd=new Project_Synnd();
				if( !$_synnd->setEntered( @$_POST['arrCampaign'] )->set() ) {
					$this->out=Core_Data_Errors::getInstance()->getErrors();
					$_synnd->getEntered( $this->out['arrCampaign'] );
					$_category->getLevel( $this->out['arrCategories'] );
					return;
				}
				$this->out['strMsg']='saved';
			}
			$_synnd->withIds( @$_GET['id'] )->onlyOne()->getList( $this->out['arrCampaign'] );
			$_category->getLevel( $this->out['arrCategories'] );
		}
		$_synnd->getSocialNewsSites( $this->out['arrSites'] );
	}
	
	public function ajax_pause() {
		if( !isset( $_POST['id'] ) || !isset( $_POST['action'] ) ){
			$this->out_js=false;
			return;
		}
		$_synnd=new Project_Synnd();
		if( !$_synnd->withIds( $_POST['id'] )->setPause( $_POST['action'] ) ) {
			$this->out_js=false;
		}
		$this->out_js=true;
	}
	
	public function request_url() {
		$this->out_js=array( 'title' => '', 'description' => '', 'tags'=>'', 'url'=>'' );
		if( empty( $_POST['url'] ) ) {
			return;
		}
		$_synnd=new Project_Synnd();
		$_synnd->getContent( $_POST['url'], $this->out_js );
	}
	
}
?>