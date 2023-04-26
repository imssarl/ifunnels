<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 12.04.2012
 * @version 1.0
 */


/**
 * Content Publisher module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_publisher extends Core_Module {
	
	public function set_cfg(){		
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Content Projects', ),
			'actions'=>array(
				array( 'action'=>'multiboxmanage', 'title'=>'Popup manage site', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'projects_manage', 'title'=>'Content Projects', 'flg_tree'=>1 ),
				array( 'action'=>'project_create', 'title'=>'Content Project create', 'flg_tree'=>1 ),
				array( 'action'=>'statistic', 'title'=>'Statistic', 'flg_tree'=>1 ),
				array( 'action'=>'selectcontent', 'title'=>'Select content', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'source_settings', 'title'=>'Source settings', 'flg_tree'=>1 ),
				array( 'action'=>'ajax_get', 'title'=>'Ajax get for pub2.0', 'flg_tpl'=>3, 'flg_tree'=>2 ),
			),
		);
	}

	private $_model=null;

	public function before_run_parent(){
		$this->_model=new Project_Publisher();
	}

	public function statistic(){
		if( empty( $_GET['id'] ) ){
			$this->location(array('name'=>'site1_accounts','action'=>'main'));
		}
		$this->objStore->getAndClear( $this->out );
		$_content = new Project_Sites_Content(); // подключаем класс
		// Добавить для статистики удаление из bf
		if( !empty($_POST) ){
			if( !$_content->withIds($_POST['contentIds'])->deleteContent() ){// удаление контента из сайта
				$this->objStore->set( array( 'msg'=>'error' ) );
				$this->location(array('wg'=>true));
			}
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location(array('wg'=>true));
		}
		$_content
			->withOrder( @$_GET['order'] )
			->withProjectId( $_GET['id'] )
			->withUrl()
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] ); // показывает контент выбранного сайта
		$_content->getPaging( $this->out['arrPg'] );
		$_content->getFilter( $this->out['arrFilter'] );
	}

	public function projects_manage() {
		$this->objStore->getAndClear( $this->out );
		if( !empty( $_POST['del'] ) ) {
			if ( $this->_model->del( $_POST['del'] ) ) {
				$this->objStore->set( array( 'msg'=>'delete' ) );
			} else {
				$this->_model->getErrors($arrErr);
				$this->objStore->set( array( 'arrErr'=>end($arrErr) ) );
			}
			$this->location();
		}
		$this->_model
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
			) )
			->withOrder( @$_GET['order'] )
			->withStatus()
			->onlyOwner()
			->getList( $this->out['arrList'] );
		$this->_model->getPaging( $this->out['arrPg'] );
		$this->_model->getFilter( $this->out['arrFilter'] );
	}

	public function multiboxmanage() {}


	private function setLoger( Core_Module_Store $obj ) {
		if (empty( $_GET['id'] )) {
			$obj->set( array( 'msg'=>'create' ) );
		}else{
			$obj->set( array( 'msg'=>'edit' ) );
		}
	}

	public function project_create() {
		set_time_limit(0);
		ignore_user_abort(true);
		error_reporting(E_ALL);
		ini_set('display_errors', '1');
		// чистим амазона сессию
		unset( $_SESSION['paggedData'] );
		unset( $_SESSION['asinData'] );
		unset( $_SESSION['paggedSettings'] );
		// -----------------------------
		if ( !empty( $_POST['arrPrj'] ) ) {
			$_skipType=$_POST['arrPrj']['settings']['skip'];
			$_POST['arrPrj']['settings']=$_POST['arrCnt'][$_POST['arrPrj']['flg_source']]['settings'];
			$_POST['arrPrj']['settings']['skip']=$_skipType;
			/*$_model = new Project_Content_Settings();//save setting in db if we don't have setting in  she
			$_model->getContent( $_getRes );
			if ( empty($_getRes[$_POST['arrPrj']['flg_source']]['settings']) ) {
				$_POST['arrCnt'][$_POST['arrPrj']['flg_source']]['flg_source'] = $_POST['arrPrj']['flg_source'];
				$setData[$_POST['arrPrj']['flg_source']]=$_POST['arrCnt'][$_POST['arrPrj']['flg_source']];
				$_model->setEntered( $setData )->setMass();
			} // save settings*/
			if( $_POST['arrPrj']['flg_status']==Project_Publisher::$stat['error'] ){
				$_POST['arrPrj']['restart']=1;
			}
			if( $this->_model->setData( $_POST['arrPrj'] )->set() ){
				if ( !empty( $_POST['arrPrj']['flg_run'] ) ) { //All at once
					$this->_arrange=new Project_Publisher_Arrange();
					$this->_arrange->publishImmediately( $this->_model->getData() );
				}
				$this->setLoger( $this->objStore->toAction( 'projects_manage' ) );
				$this->location( array( 'action'=>'projects_manage' ) );
			}
			$this->_model
				->getEntered( $this->out['arrPrj'] )
				->getErrors( $this->out['arrErrors']['errForm'] );
		}
		// edit
		if ( !empty( $_GET['id'] ) ) {
			$this->_model->withIds($_GET['id'])->getProject( $this->out['arrPrj'] );
		}
		$this->out['arrSitesList']=array();
		foreach( array( /*Project_Sites::BF, */Project_Sites::NCSB/*, Project_Sites::NVSB*/ ) as $_type ){
			if ( $_type==Project_Sites::BF ) {
				$sites=new Project_Wpress();
			} else {
				$sites=new Project_Sites( $_type );
			}
			$sites->toJs()->getList( $_arrSites );
			$this->out['arrSitesList'] = array_merge( $this->out['arrSitesList'], $_arrSites );
		}
		//if( $_SERVER['SERVER_NAME'] != 'cnm.local' ){
		//	$this->prepareCategoryTree();
		//}
	}

	private function prepareCategoryTree() {
		$arrSitesCategory = array();
		foreach( $this->out['arrSitesList'] as $key=>$value ) {
			// для группы Content Website Builder  ограничения на количество контента 30.
			if(Core_Acs::haveAccess('Content Website Builder')&&$value['type']==Project_Sites::NCSB&&$value['content_count']>30){
				unset($this->out['arrSitesList'][$key]);
				continue;
			}
			$arrSitesCategory[] = $value['category_id'];
		}
		$category = new Core_Category( 'Blog Fusion' );
		$category->getTree( $arrTree );
		foreach ( $arrTree as $firstkey => $value ) {
			foreach ( $arrTree[$firstkey]['node'] as $secondkey => $value){
				if ( !in_array( $value['id'], $arrSitesCategory ) ){
					unset( $arrTree[$firstkey]['node'][$secondkey] );
				}
			}
			if ( empty($arrTree[$firstkey]['node']) ){
				unset( $arrTree[$firstkey] );
		 	}
		}
		$this->out['arrCategoryTree']=$arrTree;
	}

	public function selectcontent() {
		if( empty( $_REQUEST ) ){
			header('Location: '. $_SERVER["HTTP_REFERER"] );
			exit;
		}
		if ( !empty( $_REQUEST ) || !empty( $_FILES ) ) {
			if (!empty($_REQUEST['import'])){
				$this->out['save_article_true'] = 1;
				$model = new Project_Articles();
				if ( !$model->import( $this->out['strJsonArticles'], $_REQUEST['import'], $_FILES['import'] ) ) {
					$this->out['save_article_true'] = 2;
				}
			}
			$this->out['boolRes']=Project_Content::factory( $_REQUEST['flg_source'] )
				->getAdditional( $arrRes )
				->setPost( $_REQUEST )
				->setFile( $_FILES )
				->getResult( $this->out['arrRes'] );
		}
		if( isset( $_REQUEST['arrPrj']['settings']['skip'] ) ){
			$_REQUEST['arrFlt']['skip']=$_REQUEST['arrPrj']['settings']['skip'];
			$this->out['arrPrj']=$_REQUEST['arrPrj']['settings']['skip'];
		}
		Project_Content::factory( $_REQUEST['flg_source'] )
			->getAdditional( $this->out['arrSource'] )
			->setFilter( $_REQUEST['arrFlt'] )
			->withPaging( array( 'page'=>@$_REQUEST['page'] ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFlt'] );
		$arrErrors=Core_Data_Errors::getInstance()->getErrors();
		if( !empty( $arrErrors['errFlow'] ) ){
			$this->out['error']=implode( '<br/>', $arrErrors['errFlow'] );
		}
		/*
		$model = new Project_Articles();
		$model->getAdditional( $this->out['articles'] );
		*/
	}
		
	public function source_settings() {
		/*/подключаем  список articles categorys
		$this->out['articles']=array();
		$categoryart=new Project_Articles_Category();
		$categoryart->withFlags(array('active'))->toSelect()->get( $this->out['articles'], $_arrTmp );
		/* /подключаем  список video categorys
		$this->out['video']=array();
		$categoryvid=new Project_Embed_Category();
		$categoryvid->toSelect()->get( $this->out['video'], $_arrTmp );
		*/
		/// подключаем параметры формы
		$_model = new Project_Content_Settings();
		// если первый раз зашли на форму
		if ( !empty($_POST) ) {
			$_model->setEntered( $_POST['arrCnt'] )->setMass();
			$this->location();
		}
		$_model->getContent( $_getRes );//в $getRes - данные из таблицы
		$this->out['arrCnt']=$_getRes;
		if (empty($this->params['modelSeting'])) 
			$this->params['modelSeting']==0;
		// clickbankcategorys
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
		$category->getTree( $this->out['arrCatTree'] );
		/* /Pure articles Category give EZINE
		Project_Content::factory( 4 )
			->getAdditional( $_GET['pid'] )
			->setPost( $this->out['arrCnt'] )
			->getResult( $this->out['arrRes'] );
		$this->out['arrPureArtCategories'] = $this->out['arrRes'][4]['arrCategories'];
		$this->out['arrCatArtTree'] = $this->out['arrRes'][4]['arrTree'];
		// end * /
		$categoryplr = new Core_Category( 'Article Prl' );
		$categoryplr->getLevel( $this->out['arrPlrCategories'], @$_GET['pid'] );
		$categoryplr->getTree( $this->out['arrPlrTree'] );//p($this->out);
		*/
		if( isset( $_GET['delete'] ) ){
			$_model->withIds( array( $_GET['delete'] ) )->del();
			$this->location();
		}
	}
	
	public function ajax_get(){
		Project_Content::factory( 4 )
			->getAdditional( $_GET['pid'] )
			->setPost( array ('arrCnt' => array ( '4' => array ( 'settings' => array ('flg_language' => $_POST['lang'])))) )
			->getResult( $this->out['arrRes'] );
		$this->out_js = $this->out['arrRes'][4]['arrTree'];
	}
}
?>