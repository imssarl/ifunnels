<?php
/**
 * Niche Content Site Builder module
 *
 * @category CNM Project
 * @package ProjectSource
 */
class site1_zonterest extends Core_Module {


	public function before_run_parent(){
		// добавление стандартных шаблонов для NCSB сайтов.
		$_ncsb=new Project_Sites_Templates( Project_Sites::NCSB  );
		$_ncsb->addCommonTemplatesToNewUser();
	}	
	
	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Amazideas', ),
			'actions'=>array(
				array( 'action'=>'edit', 'title'=>'Edit', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage', 'flg_tree'=>1 ),
				array( 'action'=>'getstarted', 'title'=>'Get Started', 'flg_tree'=>1 ),
				
				array( 'action'=>'import', 'title'=>'Import', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Create', 'flg_tree'=>1 ),
				array( 'action'=>'content', 'title'=>'Manage content', 'flg_tree'=>1 ),
				array( 'action'=>'templates', 'title'=>'Front Templates', 'flg_tree'=>1 ),
				array( 'action'=>'edit_templates', 'title'=>'Edit Template', 'flg_tree'=>1 ),
				array( 'action'=>'ajax_edit_template', 'title'=>'Ajax edit template', 'flg_tree'=>1, 'flg_tpl' => 1  ),
				array( 'action'=>'multiboxlist', 'title'=>'Popup Site List', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'multiboxmanage', 'title'=>'Popup manage ncsb site', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				
				array( 'action'=>'admin_templates', 'title'=>'Templates' ),
				array( 'action'=>'redirect_url', 'title'=>'Redirect Url' ),
			),
		);
	}

	public function getstarted() {
		$_user=new Core_Users_Management();
		if ( $_POST['request'] == 'ajax' && !empty( $_POST['arrReg']['id'] ) ) {
			ob_clean();
			$_user=new Project_Users_Management();
			Zend_Registry::get('objUser')->getId( $userId );
			$_user->withIds( $userId )->onlyOne()->getList( $_arrReg );
			$_arrReg['fb_user_id']=md5( $_POST['arrReg']['first_name'].$_POST['arrReg']['last_name'] );
			$_arrReg['settings']['facebook']=$_POST['arrReg'];
			unset( $_arrReg['passwd']);
			echo $_user->setEntered( $_arrReg )->set();
			sleep(2);
			Zend_Registry::get( 'objUser' )->reload();
			exit;
		} else if( $_POST['request'] == 'ajax' && empty( $_POST['arrReg'] ) ){
			ob_clean();
			$_user=new Project_Users_Management();
			Zend_Registry::get('objUser')->getId( $userId );
			$_user->withIds( $userId )->onlyOne()->getList( $_arrReg );
			$_arrReg['fb_user_id']=null;
			$_arrReg['fb_messenger_id']=null;
			$_arrReg['settings']['facebook']=null;
			unset( $_arrReg['passwd']);
			echo $_user->setEntered( $_arrReg )->set();
			sleep(2);
			Zend_Registry::get( 'objUser' )->reload();
			exit;
		}
		Zend_Registry::get('objUser')->getId( $userId );
		$_user->withIds( $userId )->onlyOne()->getList( $this->out['arrReg'] );
		if( !is_array( $this->out['arrReg']['settings'] ) ){
			$this->out['arrReg']['settings']=unserialize(base64_decode($this->out['arrReg']['settings']));
		}
		$_model=new Project_Content_Settings();
		// если первый раз зашли на форму
		if ( !empty($_POST) && isset( $_POST['arrCnt']  ) && !empty( $_POST['arrCnt'] ) ) {
			if( $_model->setEntered($_POST['arrCnt'])->setMass() ){}
			$this->location();
		}
		if( isset( $_GET['delete'] ) ){
			$_model->withIds( array( $_GET['delete'] ) )->del();
			$this->location();
		}
		$_model->getContent( $this->out['arrCnt'] );//в $getRes - данные из таблицы
		$this->out['i']=array( 'flg_source'=>9 );
		if( isset( Core_Users::$info['zonterest_limit'] ) ){
			$this->out['zCounter']=Core_Users::$info['zonterest_limit'];
			if( $this->out['zCounter'] == -1 ){
				$this->out['zCounter']='unlimited';
			}
		}
		$_usersettings=new Project_Content_Settings();
		$_usersettings->onlyOne()->withFlgDefault()->onlySource( '9' )->getContent( $_arrsettings );
		$_lng='US';
		if( isset( $_arrsettings['settings']['site'] ) && $_arrsettings['settings']['site'] != 0 ){
			$_lng=$_arrsettings['settings']['site'];
		}
		$_allcategory=new Core_Category( 'Amazon '.$_lng );
		$_allcategory->get( $this->out['categoryTree'], $_tmp );
	}

	public function create() {
		$_model=new Project_Sites( Project_Sites::NCSB );
		if ( !empty( $_POST ) ) {
			$_POST['multibox_ids_content_wizard']=json_decode( $_POST['multibox_ids_content_wizard'], true );
			$_settings=new Project_Content_Settings();
			$_settings->onlyOne()->withFlgDefault()->onlySource( '9' )->getContent( $_amazonSettings );
			if( $_model->setEntered( $_POST )->setAmazonSettings( $_amazonSettings['settings'] )->set() ){
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'uploaded' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$_POST['strJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($_POST['multibox_ids_content_wizard']);
			$this->out += $_POST;
			$this->out['arrOpt']=$_POST;
		} elseif ( !empty( $_GET['id'] ) ) {
			$_model->getSite( $this->out, $_GET['id'] );
		}
		$_model->getErrors($this->out['arrErrors']);
		$_templates=new Project_Sites_Templates( Project_Sites::NCSB );
		$_templates->withRight()->withPreview()->getList( $this->out['arrTemplates'] );
		$this->out['selectedTemplate']=array_search( $this->out['arrNcsb']['template_id'] , array_column( $this->out['arrTemplates'], 'id') );
		$_templates->withPreview()->getList( $this->out['strTemplatesInfo'] );
		$this->out['strTemplatesInfo']=Zend_Registry::get( 'CachedCoreString' )->php2json($this->out['strTemplatesInfo']);
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);
	}
	
	public function import(){
		$_model=new Project_Sites( Project_Sites::NCSB );
		if ( !empty( $_POST ) ) {
			if ( $_model->setEntered( $_POST )->import() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'uploaded' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$this->out += $_POST;
		}
		$_model->getErrors($this->out['arrErrors'] );
		$_templates=new Project_Sites_Templates( Project_Sites::NCSB );
		$_templates->toSelect()->getList( $this->out['arrTemplates'] );
		$_templates->withPreview()->getList( $_arrTemplatesInfo );
		$this->out['strTemplatesInfo']=Zend_Registry::get( 'CachedCoreString' )->php2json( $_arrTemplatesInfo );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);				
	}

	public function edit() {
		$_model=new Project_Sites( Project_Sites::NCSB );
		if ( !$_model->getSite( $arrSite, $_POST['arrNcsb']['id'] ) ) {
			$this->objStore->toAction( 'manage' )->set( array( 'error'=>'This site was edited' ) );
			$this->location( array( 'action' => 'manage' ) );
		}
		$_model
			->withOrder( @$_GET['order'] )
			->withCategory( 'Zonterest' ) // 641
			->getList( $this->out['menuSites'] )
			->getFilter( $this->out['arrFilter'] );
		$this->create();
	}

	public function content(){
		$this->objStore->getAndClear( $this->out );
		$_content=new Project_Sites_Content( Project_Sites::NCSB );
		// инфа о сайтах и конкретном сайте
		$_model=new Project_Sites( Project_Sites::NCSB );
		$_model
			->withOrder( @$_GET['order'] )
			->withCategory( 'Zonterest' ) // 641
			->getList( $this->out['menuSites'] );
		$_model->getSite( $_arr, $_GET['id'] );
		$this->out['arrSite']=$_arr['arrNcsb'];
		$_placement=new Project_Placement();
		$_placement->withIds( $_arr['arrNcsb']['placement_id'] )->onlyOne()->getList( $this->out['arrSite']['domen'] );
		// удаление контента
		if( !empty( $_POST['contentIds'] ) ){
			$_str=$_content->withSiteId( $_GET['id'] )->withIds( $_POST['contentIds'] )->deleteContent()? 
				'Content was deleted':'Content was not deleted';
			$this->objStore->set( array( 'delete'=>$_str ) );
			$this->location(array('action'=>'content','wg'=>true));
		}
		// получаем контент для отображения
		$_content
			->withSiteId( $_GET['id'] )
			->withOrder( @$_GET['orderPost'] )
			->onlyOwner()
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrContent'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
		if( isset( $_POST['edit'] ) && isset( $_GET['post_id'] ) ){
			if( $_content->setPostId( $_GET['post_id'] )->editRemoteContent( $_POST['arrPost'], $this->out ) ){
				$this->objStore->set( array( 'msg'=>'Post saved' ) );
				$this->location(array('wg'=>true));
			}
		}
		if( isset( $_GET['post_id'] ) ){
			$_content->setPostId( $_GET['post_id'] )->getRemoteContent( $this->out );
			if( isset( $this->out['arrEditContent']['description'] ) ){
				$this->out['arrEditContent']['description']=str_replace( '"images/more_info.png"', '"'.$this->out['arrSite']['url'].'images/more_info.png"', $this->out['arrEditContent']['description'] );
				$this->out['arrEditContent']['description']=str_replace( '"'.Zend_Registry::get( 'config' )->domain->url.'/usersdata/publishing/amazon/0/more_info.png"', '"'.$this->out['arrSite']['url'].'images/more_info.png"', $this->out['arrEditContent']['description'] );
				$this->out['arrEditContent']['description']=str_replace( array( "\\n", "\\r\\n", "\\r" ), '', $this->out['arrEditContent']['description'] );
			}
		}
		$_content->getErrors( $this->out['arrErrors'] );
	}
	
	public function manage() {
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Sites( Project_Sites::NCSB );
		if ( !empty( $_GET['del'] ) && $model->delSites( $_GET['del'] ) ) {
			$this->objStore->set( array( 'msg'=>'deleted' ) );
			$this->location( array( 'action'=>'manage' ) );
		}
		if( !empty( $_POST['updFile'] ) && !empty( $_FILES['file']['name'] ) ){
			$model->getSite( $_arr, $_POST['updFile']['id'] );
			$_connectData['arrSite']=$_arr['arrNcsb'];
			$_placement=new Project_Placement();
			$_placement->withIds( $_arr['arrNcsb']['placement_id'] )->onlyOne()->getList( $_connectData['arrSite']['domen'] );
			$_transport=new Project_Placement_Transport();
			$_transport->setInfo($_connectData['arrSite']);
			$_localDir="Zonterest_Screenshot@upload";
			if ( !Zend_Registry::get( 'objUser' )->prepareTmpDir( $_localDir ) ) {
				throw new Exception( Core_Errors::DEV."|Can'\t prepare template dir ".$_localDir."." );
			}
			$_format=explode('.', $_FILES['file']['name'] );
			$_format=$_format[1];
			if( !in_array( $_format, array( 'jpeg', 'png', 'gif' ) ) ){
				$this->objStore->set( array( 'msg'=>'file_format_error' ) );
				$this->location();
			}
			$_file='datas/desc/userscreen';
			if( file_get_contents( $_connectData['arrSite']['url'].$_file.'.'.'jpeg', 0, 0, 0, 10 ) ){ $_transport->removeFile( $_file.'.jpeg' ); }
			if( file_get_contents( $_connectData['arrSite']['url'].$_file.'.'.'png', 0, 0, 0, 10 ) ){ $_transport->removeFile( $_file.'.png' ); }
			if( file_get_contents( $_connectData['arrSite']['url'].$_file.'.'.'gif', 0, 0, 0, 10 ) ){ $_transport->removeFile( $_file.'.gif' ); }
			$_strContent=file_get_contents( $_FILES['file']['tmp_name'] );
			if( !$_transport->saveFile( $_strContent, $_file.'.'.$_format) ){
				throw new Exception( Core_Errors::DEV."|Can'\t save file ".$_strContent." to remote server ".$_file.'.'.$_format."." );
			}
			$this->objStore->set( array( 'msg'=>'image_updated' ) );
			$this->location( array( 'action'=>'manage' ) );
		}
		if ( !empty( $_POST['arrNewCat'] ) ) {
			$this->objStore->set( array( 'msg'=>( $model->changeCategory( $_POST['arrNewCat']['id'], $_POST['arrNewCat']['category_id'] )? 'changed':'error' ) ) );
			$this->location( array( 'action'=>'manage' ) );
		}
		$model
			->withOrder( @$_GET['order'] )
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->withCategory( 'Zonterest' ) // 641
			->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
		$_templates=new Project_Sites_Templates( Project_Sites::NCSB );
		$_templates->withPreview()->getList( $this->out['arrTemplates'] );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json( $arrTree );
		if( isset( Core_Users::$info['zonterest_limit'] ) ){
			$this->out['zCounter']=Core_Users::$info['zonterest_limit'];
			if( $this->out['zCounter'] == -1 ){
				$this->out['zCounter']='unlimited';
			}
		}
	}

	public function templates() {
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Sites_Templates( Project_Sites::NCSB );
		if ( !empty( $_FILES['zip'] )&&$model->addUserTemplate( $_FILES['zip'] ) ) {
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location( array('action' => 'templates') );
		}
		if ( !empty( $_GET['restore'] )&&$model->reassignCommonToUser() ) {
			$this->objStore->set( array( 'msg'=>'restore' ) );
			$this->location( array('action' => 'templates') );
		}
		if( !empty( $_GET['delete'] )&&$model->deleteUserTemplate( $_GET['delete'] ) ) {
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location( array( 'action'=>'templates' ) );
		}
		if ( !empty( $_POST['arrCopy'] )&&$model->copyTemplate( $_POST['arrCopy'] ) ){
			$this->objStore->set( array( 'msg'=>'copy' ) );
			$this->location( array( 'action'=>'templates' ) );
		}
		$model->getErrors( $this->out['arrErrors'] );
		$model->withRight()->withPaging( array( 'url'=>$_GET ) )->withOrder( @$_GET['order'] )->withPreview()->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
		$sites=new Project_Sites( Project_Sites::NCSB );
		$sites->getList( $this->out['arrSites'] );		
	}
	
	public function admin_templates(){
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Sites_Templates( Project_Sites::NCSB );
		if ( !empty( $_FILES['zip'] ) ) {
			if ( $model->addCommonTemplate( $_POST['theme'], $_FILES['zip'] ) ) {
				$this->objStore->set( array( 'msg'=>'added' ) );
			} else {
				$model->getErrors( $errorCode );
				$this->objStore->set( array( 'errorCode'=>$errorCode ) );
			}
			$this->location( array('action' => 'admin_templates') );
		}
		if( !empty( $_GET['delete'] ) ) {
			$model->deleteCommonTemplate( $_GET['delete'] );
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location( array( 'action'=>'admin_templates' ) );
		}
		$model->withPaging( array( 'url'=>$_GET ) )->onlyCommon()->withOrder( @$_GET['order'] )->withPreview()->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}
	
	public function edit_templates(){
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Sites_Templates( Project_Sites::NCSB );
		if ( !empty($_POST['arr']) ){
			if ( !$model->saveTemplate($_POST['arr']['id'], $_FILES['header']) ){
				$this->out['error']=true;
			}
			$this->objStore->toAction( 'templates' )->set( array( 'msg'=>'saved' ) );
			$this->location( array( 'action'=>'templates' ) );
				
		}		
		if ( !empty( $_GET['id'] ) ) {
			$model->withPreview()->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrTemplate'] );
			$model->template2edit($this->out['arrFiles'], $_GET['id']);
		}

	}
	
	public function ajax_edit_template(){
		if ( !empty( $_GET['open_file'] ) ){
			Core_Files::getContent($strContent, $_POST['file']);
			echo $strContent;
		}
		if ( !empty( $_GET['save_file'] ) ){
			header('Content-type: application/json;');
			if ( !Core_Files::setContent($_POST['strContent'], $_POST['file']) ){
				echo "{result:0}";
				die();
			}
			echo "{result:1}";
		}
		die();		
	}
	
	public function multiboxlist(){
		$model=new Project_Sites( Project_Sites::NCSB );
		$model->withOrder( @$_GET['order'] )->withPaging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );		
	}
	
	public function redirect_url(){
		if( isset( $_POST['url'] ) && !empty( $_POST['url'] ) ){
			$this->setDefaultPage( $_POST['url'] );
			unset( $_POST );
		}
		$this->out['url']=$this->getDefaultPage();
	}
	
	public function multiboxmanage() {
		$this->manage();
	}
	
	public static function getQjmpzService(){
		$_arr=array_chunk( array_reverse( explode( '.', $_SERVER['HTTP_HOST'] ) ), 2 );
		$_strDomain=implode( '.', array_reverse( $_arr[0] ) );
		$_tail=substr( $_strDomain , strripos( $_strDomain, '.' )+1 );
		if ( $_tail!='local' ){
			return "http://qjmpz.com/services/amazideas.php";//Core_Module::getUrl( array( 'name'=>'site1_traffic', 'action'=>'client_trafic_exchange' ) );
		}elseif( $_tail=='local' ){
			return "http://qjmpz.local/services/amazideas.php";
		}
	}

	public function getDefaultPage(){
		return file_get_contents( self::getQjmpzService().'?action=geturl' );
	}

	public function setDefaultPage( $_page='' ){
		return file_get_contents( self::getQjmpzService().'?action=seturl&url='.htmlspecialchars( $_page ) );
	}
	
}
?>