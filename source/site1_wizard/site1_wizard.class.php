<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 * @author Slepov Slava <shadow-dwarf@yandex.ru>
 * @date 16.07.2012
 * @version 1.0
 */


/**
 * Amazon Affiliate Website Wizard module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_wizard extends Core_Module {

	public function before_run_parent(){
		// добавление стандартных шаблонов для NCSB сайтов.
		$_nvsb=new Project_Sites_Templates( Project_Sites::NCSB );
		$_nvsb->addCommonTemplatesToNewUser();
		$_nvsb->reassignCommonToUser();
	}

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Website Wizard', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Amazon create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'zonterest', 'title'=>'Zonterest create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'clickbank', 'title'=>'Clickbank create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'clickbankpro', 'title'=>'Clickbank PRO create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'iam', 'title'=>'IAM create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'zonterestpro', 'title'=>'Zonterest PRO create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'zonterestamazideas', 'title'=>'Zonterest Amazideas create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'zonterestLight', 'title'=>'Zonterest LIGHT create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'content', 'title'=>'Content create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'contentpro', 'title'=>'Content PRO create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'video', 'title'=>'Video create', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'ajax', 'title'=>'Check domain', 'flg_tree'=>1, 'flg_tpl' => 3 ),
			),
		);
	}

	private $_categories='Blog Fusion';

	public function video(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_VIDEO_NVSB );
		$this->create_form($_model);
	}

	public function content(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_CONTENT_NCSB );
		$this->create_form($_model);
	}

	public function contentpro(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_CONTENT_PRO_NCSB );
		$this->_categories='Exclusive';
		$this->create_form($_model);
	}

	public function zonterest(){
		$_settings=new Project_Content_Settings();
		$_settings->onlyOne()->withFlgDefault()->onlySource( 9 )->getContent( $settings );
		$this->out['settings']=$settings['settings'];
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_ZONTEREST_NCSB );
		$this->create_form($_model);
	}

	public function zonterestamazideas(){
		$this->objStore->getAndClear( $this->out );
		if( isset( Core_Users::$info['zonterest_limit'] ) && ( Core_Users::$info['zonterest_limit']>0 || Core_Users::$info['zonterest_limit']==-1 ) ){
			$model=new Project_Sites( Project_Sites::NCSB );
			$model
				->withCategory( 'Zonterest' ) // 641
				->withPlacementId( 8484 ) // 8484
				->onlyCount()
				->getList( $_countZonterestSites );
			if( $_countZonterestSites < Core_Users::$info['zonterest_limit'] || Core_Users::$info['zonterest_limit']==-1 ){
				$_settings=new Project_Content_Settings();
				$_settings->onlyOne()->withFlgDefault()->onlySource( 9 )->getContent( $settings );
				$this->out['setting_id'] = $settings['id'];
				$this->out['settings']=$settings['settings'];
				$this->out['settings']['flg_amazideas']=1;
				$_settings->onlySource( 9 )->getContent( $this->out['arrSettings'] );
				$_model=new Project_Wizard( Project_Wizard::TYPE_ZONTEREST_NCSB );
				$this->create_form($_model);
			}else{
				$this->out['arrErr']=array( 'errFlow'=>array( 'site_limit' ) );
			}
		}else{
			$this->out['arrErr']=array( 'errFlow'=>array( 'site_limit' ) );
		}
	}

	public function clickbankpro(){
		$_settings=new Project_Content_Settings();
		$_settings->onlyOne()->withFlgDefault()->onlySource( 10 )->getContent( $settings );
		$this->out['settings']=$settings['settings'];
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_CLICKBANKPRO_NCSB );
		$this->create_form($_model);
		$category=new Core_Category( 'Clickbank' );
		if (!empty($_GET['id'])){
			if($_GET['id'] == true) {
				$this->out['arrData']['id']=true;
			} else {
				$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
				$category->getLng()->setCurLang( Core_Language::$flags[$this->out['arrData']['flg_language']]['title'] );
			}
		}
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$_click=new Project_Content_Adapter_Clickbank();
		$_click->getCountItems($this->out['arrCategories']);
		$category->getTree( $this->out['arrCatTree'] );
		$_click->getCountItems( $this->out['arrCatTree']);
	}

	public function iam(){
		$_settings=new Project_Content_Settings();
		$_settings->onlyOne()->withFlgDefault()->onlySource( 10 )->getContent( $settings );
		$this->out['settings']=$settings['settings'];
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_IAM_NCSB );
		$this->create_form($_model);
		$category=new Core_Category( 'Clickbank' );
		if (!empty($_GET['id'])){
			if($_GET['id'] == true) {
				$this->out['arrData']['id']=true;
			} else {
				$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
				$category->getLng()->setCurLang( Core_Language::$flags[$this->out['arrData']['flg_language']]['title'] );
			}
		}
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$_click=new Project_Content_Adapter_Clickbank();
		$_click->getCountItems($this->out['arrCategories']);
		$category->getTree( $this->out['arrCatTree'] );
		$_click->getCountItems( $this->out['arrCatTree']);
	}

	public function clickbank(){
		$_settings=new Project_Content_Settings();
		$_settings->onlyOne()->withFlgDefault()->onlySource( 10 )->getContent( $settings );
		$this->out['settings']=$settings['settings'];
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_CLICKBANK_NCSB );
		$this->create_form($_model);
		$category=new Core_Category( 'Clickbank' );
		if (!empty($_GET['id'])){
			if($_GET['id'] == true) {
				$this->out['arrData']['id']=true;
			} else {
				$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
				$category->getLng()->setCurLang( Core_Language::$flags[$this->out['arrData']['flg_language']]['title'] );
			}
		}
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$_click=new Project_Content_Adapter_Clickbank();
		$_click->withThumb(array(1,2))->getCountItems($this->out['arrCategories']);
		$category->getTree( $this->out['arrCatTree'] );
		$_click->withThumb(array(1,2))->getCountItems( $this->out['arrCatTree']);
	}

	public function zonterestpro(){
		$_settings=new Project_Content_Settings();
		$_settings->onlyOne()->withFlgDefault()->onlySource( 9 )->getContent( $settings );
		$this->out['settings']=$settings['settings'];
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_ZONTEREST_PRO_NCSB );
		$_sites=new Project_Sites( Project_Sites::NCSB );
		$_sites->withCategory('Exclusive')->onlyRoot()->onlyLocal()->toSelect()->getList( $this->out['arrSites'] );
		$this->create_form($_model);
	}

	public function zonterestLight(){
		$_settings=new Project_Content_Settings();
		$_settings->onlyOne()->withFlgDefault()->onlySource( 9 )->getContent( $settings );
		$this->out['settings']=$settings['settings'];
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_ZONTERESTLIGHT_NCSB );
		$this->create_form($_model);
	}

	public function create(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wizard( Project_Wizard::TYPE_AMAZON_NCSB );
		$this->create_form($_model);
	}

	private function create_form( $_model ){
		if( !empty( $_POST['arrData'] ) ){
			if( empty( $_POST['arrData']['domain_http'] ) && !empty( $_POST['arrData']['domain_text'] ) ){
				$_POST['arrData']['domain_http']=$_POST['arrData']['domain_text'];
				unset( $_POST['arrData']['domain_text'] );
			}
			if( $_model->setEntered( $_POST['arrData'] )->run() ){
				ob_clean();
				echo json_encode(array('result'=>true,'domain'=>$_model->getSiteUrl(),'contentCount'=>$_model->getContentCount()));
				die();
			}
			$_model->getErrors( $this->out['arrErr'] );
			ob_clean();
			echo json_encode(array('error'=>implode( "<br/>", $this->out['arrErr']['errFlow'] )));
			die();
		}
		if( !$_model->check( ( isset( $this->out['settings']['flg_amazideas'] )&&$this->out['settings']['flg_amazideas']==1 )?false:true ) ){
			$_model->getErrors( $this->out['arrErr'] );
		}
		$_category=new Core_Category( $this->_categories );
		$_category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$_category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);
	}
	
	public function ajax(){
		if( !empty( $_POST['arrData'] ) ){
			if( !empty($_POST['arrData']['prepare']) ){
				$_sites=new Project_Sites( Project_Sites::NCSB );
				$_sites->withIds($_POST['arrData']['prepare'])->onlyOne()->getList( $arrSite );
				$_POST['arrData']['main_keyword']=$arrSite['main_keyword'];
			}
			if( isset( $_POST['arrData']['flg_amazideas'] ) &&  $_POST['arrData']['flg_amazideas'] == 1 ){
				$_setting=array(
					'ftp_directory'=>'/'.$this->randomDirName().'/',
					'flg_type'=> '1',
					'flg_passive'=> '1',
					'flg_checked'=> '2',
					'flg_sended_hosting'=> '0',
					'flg_sended_domain'=> '0',
					'flg_auto'=> '1',
					'domain_http'=> 'amazideas.net',
					'placement_id'=> NULL,
					'domain_ftp'=> NULL,
					'username'=> NULL,
					'password'=> NULL,
					'db_host'=> NULL,
					'db_name'=> NULL,
					'db_username'=> NULL,
					'db_password'=> NULL,
				);
				if( @$_SERVER['HTTP_HOST'] != 'cnm.local' ){
					try{
						$_strExtractDir='Project_Wizard@zonterest';
						if ( !Zend_Registry::get( 'objUser' )->prepareTmpDir( $_strExtractDir ) ) {
							return false;
						}
						$_transport=new Project_Placement_Transport();
						if( !$_transport
							->setInfo( $_setting )
							->setSourceDir( $_strExtractDir )
							->placeAndBreakConnect() 
						){
							// ошибка ?
						}
					}catch( Core_Ssh_Exception $e ){}
					ob_end_clean();
				}
				$this->out_js=array(
					'domain_url'=>'http://amazideas.net'.$_setting['ftp_directory'],
					'domain_http'=>$_setting['domain_http'],
					'ftp_directory'=>$_setting['ftp_directory'],
				);
			}else{
				$_domain=new Project_Wizard_Domain( $_POST['arrData']['type'] );
				$this->out_js=$_domain->setWord( $_POST['arrData']['main_keyword'] )->get();
			}
		} elseif(!empty($_POST['checkCredits'])){
			$_result=Project_Wizard_Adapter_ZonterestPro::checkMutliCost( $_POST );
			$this->out_js['result']=$_result===true;
			$this->out_js['count']=$_result;
		} elseif( !empty( $_POST['domenCheck'] ) ){
			if( @$_SERVER['HTTP_HOST'] != 'cnm.local' ){
				$this->out_js=Project_Wizard_Domain::check( $_POST['domenCheck'] );
			}else{
				$this->out_js=true;
			}
		} elseif( !empty($_POST['country']) ){
			$_category=new Core_Category( 'Amazon '.$_POST['country'] );
			$_category->get( $arrTree, $_tmp );
			$this->out_js['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);
		}
	}
	
	public function setup() {}
	
	function randomDirName( $n=1 ){
		$letters="qwertyuiopasdfghjklzxcvbnm";
		$numbers="1234567890";
		$dirName='';
		$dirName.=$letters[mt_rand(0,strlen($letters)-1)];
		$dirName.=$letters[mt_rand(0,strlen($letters)-1)];
		$dirName.=$letters[mt_rand(0,strlen($letters)-1)];
		$dirName.=$numbers[mt_rand(0,strlen($numbers)-1)];
		$dirName.=$numbers[mt_rand(0,strlen($numbers)-1)];
		$_test=get_headers( 'http://amazideas.net/'.$dirName );
		if( $n>10 ){
			throw new Project_Placement_Exception( Core_Errors::DEV.'|no empty dir names' );
		}
		if( $_test[0]== 'HTTP/1.1 200 OK' ){
			$n++;
			$dirName=$this->randomDirName( $n );
		}
		return $dirName;
	}
	
}
?>