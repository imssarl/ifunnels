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
 * Blogfusion module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_blogfusion extends Core_Module {
	
	private $_model;
	
	public function before_run_parent(){
		// добавление стандартных тем и плагинов модуля блогфьюжн для новых пользователей
		$_theme=new Project_Wpress_Theme();
		$_theme->addCommonThemesToNewUser();
		$_plugin=new Project_Wpress_Plugins();
		$_plugin->addCommonPluginsToNewUser();
		// модель для использования в модуле
		$this->_model=new Project_Wpress();
	}

	public function after_run_parent(){
		if ( $_GET['id'] ) {
			$this->_model->getList( $this->out['menuBlog'] );
		}
	}

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Blogfusion', ),
			'actions'=>array(
				array( 'action'=>'upgrade', 'title'=>'Upgrade Blog', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Create Blog', 'flg_tree'=>1 ),
				array( 'action'=>'ajaxcreate', 'title'=>'Create', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'import', 'title'=>'Import Blog', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Blog', 'flg_tree'=>1 ),
				array( 'action'=>'plugins', 'title'=>'Plugins', 'flg_tree'=>1 ),
				array( 'action'=>'themes', 'title'=>'Themes', 'flg_tree'=>1 ),
				array( 'action'=>'themes_search', 'title'=>'Search Themes', 'flg_tree'=>1,'flg_tpl'=>1 ),
				array( 'action'=>'plugin_search', 'title'=>'Search Plugins', 'flg_tree'=>1,'flg_tpl'=>1 ),
				array( 'action'=>'general', 'title'=>'Manage Blog Data', 'flg_tree'=>1 ),
				array( 'action'=>'categories', 'title'=>'Blog Categories', 'flg_tree'=>1 ),
				array( 'action'=>'posts', 'title'=>'Blog Posts', 'flg_tree'=>1 ),
				array( 'action'=>'comments', 'title'=>'Blog Comments', 'flg_tree'=>1 ),
				array( 'action'=>'pages', 'title'=>'Blog Pages', 'flg_tree'=>1 ),
				array( 'action'=>'edittheme', 'title'=>'Blog Edit Theme', 'flg_tree'=>1 ),
				array( 'action'=>'changetheme', 'title'=>'Blog Change Theme', 'flg_tree'=>1 ),
				array( 'action'=>'testdb', 'title'=>'Test DB Connection', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'multiboxmanage', 'title'=>'Popup manage blog', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'multiboxlist', 'title'=>'Popup Blog List', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'multiboxtheme', 'title'=>'Popup Theme', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'multiboxwidget', 'title'=>'Popup Widgets', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'blogclone', 'title'=>'Clone blog', 'flg_tree'=>1  ),
			),
		);
	}

	public function multiboxwidget(){
		$this->_model->getBlog($this->out['arrBlog'],$_GET['id']);
	}
	
	public function themes_search(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wpress_Theme();
		if (!empty($_POST)){
			if ( !$_model->downloadTheme($_POST['arr']['link']) ){
				$_model->getErrors( $errorCode );
				$this->objStore->set( array( 'errorCode'=>$errorCode ) );
				$this->location();				
			}
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location();
		}			
		if (!empty($_GET)){
			$_GET['arr']['per_page']=21;
			$_GET['arr']['page']=(!empty($_GET['page']))?$_GET['page']:1;
			$this->out['arrList']=$_model->search($_GET['arr']);
		}
	}

	public function plugin_search(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Wpress_Plugins();
		if ( !empty($_POST) ){
			if ( !$_model->downloadPlugin($_POST['arr']['link']) ){
				$_model->getErrors( $errorCode );
				$this->objStore->set( array( 'errorCode'=>$errorCode ) );
				$this->location();				
			}
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location();
		}			
		if ( !empty($_GET) ){
			$_GET['arr']['per_page']=21;
			$_GET['arr']['page']=(!empty($_GET['page']))?$_GET['page']:1;
			$this->out['arrList']=$_model->search($_GET['arr']);
		}
	}
		
	public function upgrade() {
		$_upgrader=Project_Wpress_Connector_Upgrade::getInstance()->runAsApplication();
		if ( !empty( $_POST['arrSettings'] )&&$_upgrader->setUpgradeSettings( $_POST['arrSettings'] ) ) {
			$_upgrader->setUpgradeBlogs( $_POST['jsonBlogs'], $_POST['arrSettings'] );
			$this->location();
		}
		$_upgrader->getCurVersion( $this->out['newVersion'] );
		$_upgrader->getUpgradeSettings( $this->out['arrSettings'] );
		$this->_model
			->onlyCount()
			->toVersion( $this->out['newVersion'] )
			->getList( $this->out['intNumOldBlogs'] );
		if ( $_upgrader->getUpgradeBlogs( $this->out['arrBlogsStatus'] ) ) {
			$this->_model
				->withIds( array_keys( $this->out['arrBlogsStatus'] ) )
				->getList( $this->out['arrList'] );
		}
	}
	
	public function blogclone(){
		if ( !empty($_POST) && !empty($_GET['id']) ){
			$_model=new Project_Sites( Project_Sites::BF );
			$_model->onlyOne()->withIds($_GET['id'])->getList( $copyBlog );
			if( $_model->setData( $copyBlog )->copyBlog( $_POST['arrBlog'] )){
				$this->location( array( 'action'=>'manage' ) );
			}
			$this->out['arrBlog']=$_POST['arrBlog'];
		}
		$_model->getErrors( $this->out['arrErrors'] );
	}
	
	public function multiboxtheme(){
		$modelThemes=new Project_Wpress_Theme();
		$modelThemes->withRight()->withPreview()->getList( $this->out['arrThemes'] );
	}
	
	public function multiboxlist() {
		if ( !isset( $_GET['noversion'] ) ) {
			Project_Wpress_Connector_Upgrade::getInstance()->getCurVersion( $newVersion );
			$this->_model->toVersion( $newVersion );
		}
		$this->_model
		->withOrder( @$_GET['order'] )
		->withCategories( @$_GET['category_id'] )
		->getList( $this->out['arrList'] );
		$this->_model->getFilter( $this->out['arrFilter'] );
		if ( isset( $_GET['noversion'] ) ) {
			$_category=new Project_Wpress_Content_Category();
			foreach ( $this->out['arrList'] as &$blog ) {
				$_category->setBlogById( $blog['id'] );
				$_category->getList( $blog['categories'] );
			}
		}
	}

	public function create() {
		$_model=new Project_Sites( Project_Sites::BF );
		if ( !empty( $_POST ) ) {
			$_POST['arrBlog']['files']=$_FILES;
			if ( $_model->setEntered( $_POST )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'uploaded' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$_model->getEntered( $this->out['arrBlog'] );
		}
		$modelPlugin=new Project_Wpress_Plugins();
		$modelPlugin->getList( $this->out['arrPlugins'] );
		$modelThemes=new Project_Wpress_Theme();
		$modelThemes->withRight()->withPreview()->getList( $this->out['arrThemes'] );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);
		$this->out['arrPermalink']=$this->_model->getPermalink();
		if ( $this->_model->getSettingsBlog( $arrSettings ) ) {
			$this->_model->withOrder( 'b.title--up' )->onlySettings()->toSelect()->getList( $this->out['arrSettingsSelect'] );
			foreach($arrSettings as &$_item){
				$_item['prop_settings']='';
			}
			$this->out['jsonSettings']=Zend_Registry::get( 'CachedCoreString' )->php2json( $arrSettings );
		}
		if ( !empty( $_GET['ncsb'] ) ) {
			$_site=new Project_Sites( Project_Sites::NCSB );
			$_site->getSite( $_arrSite, $_GET['ncsb'] );
			$_place=new Project_Placement();
			$_place->onlyOne()->onlyOwner()->withIds( $_arrSite['arrNcsb']['placement_id'] )->getList( $_tmpPlace );
			$this->out['arrBlog']['placement_id']=$_tmpPlace['id'];
		}
		if ( !empty( $_GET['nvsb'] ) ) {
			$_site=new Project_Sites( Project_Sites::NVSB );
			$_site->getSite( $_arrSite, $_GET['nvsb'] );
			$_place=new Project_Placement();
			$_place->onlyOne()->onlyOwner()->withIds( $_arrSite['arrNvsb']['placement_id'] )->getList( $_tmpPlace );
			$this->out['arrBlog']['placement_id']=$_tmpPlace['id'];
		}
		$_model->getErrors($this->out['arrErrors']);
	}

	public function general(){
		$this->objStore->getAndClear( $this->out );
		if (!(!empty($_GET['id'])||!empty($_POST['arrBlog']['id']))) {
			$this->location(array('action'=>'manage'));
		}
		$_model=new Project_Sites( Project_Sites::BF );
		if ( !empty( $_POST ) ) {
			$_POST['arrBlog']['files']=$_FILES;
			if ( $_model->setEntered( $_POST )->set() ) {
				$this->objStore->set( array( 'msg'=>'success' ) );
				$this->location(array( 'wg'=>'id='.$_GET['id']));
			}
			$_model->getEntered( $this->out['arrBlog'] );
		} elseif ( !$_model->getSite( $this->out['arrBlog'], $_GET['id'] ) ) {
			$this->objStore->toAction( 'manage' )->set( array( 'error'=>'This site was deleted' ) );
			$this->location( array( 'action' => 'manage' ) );
		}
		$modelPlugin=new Project_Wpress_Plugins();
		$modelPlugin->getList( $this->out['arrPlugins'] );
		$modelThemes=new Project_Wpress_Theme();
		$modelThemes->withPreview()->getList( $this->out['arrThemes'] );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);
		$this->out['arrPermalink']=$this->_model->getPermalink();
		$_model->getErrors($this->out['arrErrors']);
	}

	public function manage() {
		$_model=new Project_Sites(Project_Sites::BF);
		$this->objStore->getAndClear( $this->out );
		if ( !empty( $_POST ) ) {
			if ( !empty( $_POST['arrNewCat'] ) ) {
				$this->objStore->set( array( 'msg'=>( $this->_model->changeCategory( $_POST['arrNewCat']['id'], $_POST['arrNewCat']['category_id'] )? 'changed':'error' ) ) );
			} elseif ( $_POST['mode']=='delete'&&!empty( $_POST['del'] ) ) {
				$this->objStore->set( array( 'msg'=>( $_model->delSites( array_keys($_POST['del']) )? 'delete':'error' ) ) );
				//$this->objStore->set( array( 'msg'=>( $this->_model->deleteBlog( array_keys( $_POST['del'] ) )? 'delete':'error' ) ) );
			} elseif ( $_POST['mode']=='store-settings'&&!empty( $_POST['ids'] ) ) {
				$this->objStore->set( array( 'msg'=>( $this->_model->setSettingsBlog( 
					$_POST['ids'], 
					( empty( $_POST['set'] )? 0:array_keys( $_POST['set'] ) 
				) )? 'stored':'error' ) ) );
			}
			$this->location();
		}
		$this->_model->withPagging(array(
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		))
		->withOrder( @$_GET['order'] )
		->withCategories( @$_GET['cat'] )
		->withTitle( @$_GET['blog_title'] )
		->getList( $this->out['arrList'] );
		$this->_model->getPaging( $this->out['arrPg'] )->getFilter( $this->out['arrFilter'] );
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json( $arrTree );
		$_model->getErrors($this->out['arrErrors']);
	}

	public function import() {
		$_model=new Project_Sites( Project_Sites::BF );
		if ( !empty( $_POST['arrBlog'] )&&$_model->setEntered( $_POST )->import() ) {
			$this->location( array( 'action'=>'manage' ) );
		}
		$_model->getEntered( $this->out['arrBlog'] );
		$_model->getErrors($this->out['arrErrors']);
		$category=new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);		
	}
	
	public function plugins(){
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Wpress_Plugins();
		if ( !empty( $_GET['restore'] )&&$model->reassignCommonToUser() ) {
			$this->objStore->set( array( 'msg'=>'restore' ) );
			$this->location( array('action' => 'plugins') );
		}
		if ( !empty( $_FILES['zip'] )&&$model->addUserPlugin( $_FILES['zip'] ) ) {
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location( array('action' => 'plugins') );
		}
		if ( !empty( $_GET['del_id'] )&&$model->deleteUserPlugin( $_GET['del_id'] ) ) {
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location( array('action' => 'plugins') );
		}
		$model->getErrors( $this->out['arrErrors'] );
		$model->withPaging(array( 'url'=>$_GET ))->withOrder( @$_GET['order'] )->getList( $this->out['arrPlugins'] );
		if( Core_Acs::haveAccess(array('Blog Fusion CSPP','Blog Fusion CSP'))&&!Core_Acs::haveAccess(array('email test group')) ){
			foreach( $this->out['arrPlugins'] as $_key=>$_item ){
				if( !in_array($_item['title'],array('WordPress SEO','All in One SEO Pack','Google XML Sitemaps') )){
					unset($this->out['arrPlugins'][$_key]);
				}
			}
		}
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}
	
	public function themes(){
		$this->objStore->getAndClear( $this->out );
		$model=new Project_Wpress_Theme();
		if ( !empty( $_GET['restore'] )&&$model->reassignCommonToUser() ) {
			$this->objStore->set( array( 'msg'=>'restore' ) );
			$this->location( array('action' => 'themes') );
		}
		if ( !empty( $_POST['zip'] ) ){
			$_FILES['zip']=$_POST['zip'];
		}
		if ( !empty( $_FILES['zip'] )&&$model->addUserTheme( $_FILES['zip'] ) ) {
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location( array('action' => 'themes') );
		}
		if ( !empty( $_GET['del_id'] )&&$model->deleteUserTheme( $_GET['del_id'] ) ) {
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location( array('action' => 'themes') );
		}
		$model->getErrors( $this->out['arrErrors'] );
		$model->withRight()->withPaging(array( 'url'=>$_GET ))->withPreview()->withOrder( @$_GET['order'] )->getList( $this->out['arrThemes'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}

	public function categories() {
		$model=new Project_Wpress_Content_Category();
		if ( !$model->setBlogById( $_GET['id'] ) ) {
			$this->location( array( 'action'=>'manage' ) );
		}
		$this->out['arrBlog']=$model->blog->filtered;
		if ( !empty( $_POST ) ) {
			if ( $model->setData( $_POST['arrList'] )->set() ) {
				$this->location();
			}
			$this->out['arrErr']=$model->getErrors();
			$this->out['arrList']=$model->getData();
		}
		$model->withPagging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->withOrder( @$_GET['order'] )->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}

	public function posts() {
		$cats=new Project_Wpress_Content_Category();
		if ( !$cats->setBlogById( $_GET['id'] ) ) {
			$this->location( array( 'action'=>'manage' ) );
		}
		$cats->withOrder('flg_default--up')->getList( $this->out['arrCats'] );
		$model=new Project_Wpress_Content_Posts();
		if ( !$model->setBlogById( $_GET['id'] ) ) {
			$this->location( array( 'action'=>'manage' ) );
		}
		$this->out['arrBlog']=$model->blog->filtered;
		if ( !empty( $_POST['arrPost'] ) ) {
			// тут добавление-редактирование
			foreach( $_POST['arrPost'] as $k=>$v ) {
				if(!empty($_POST['delete'])&&empty( $v['del'] )){
					unset($_POST['arrPost'][$k]);
					continue;
				}
				$_arrDelIds[]=$k;
			}
			$_content = new Project_Sites_Content( Project_Sites::BF );
			// тут удаление
			if ( !empty( $_arrDelIds ) ) {
				$_content->withSiteId( $_GET['id'] )->withIds( $_arrDelIds )->deleteContent();
			}
			if (
				($model->setData( $_POST['arrPost'] )->setFrom( Project_Wpress_Content_Posts::$from['self'] )->set()) &&
				($_content->setFrom( Project_Wpress_Content_Posts::$from['self'] )->withSiteId( $_GET['id'] )->setContent( $model->data->filtered )->set())
			) {
				$this->location(array('wg'=>true));
			}
			$this->out['arrErr']=$model->getErrors();
			$this->out['arrPost']=$model->getData();
		}
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
		$model->withPagging( array(
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->withCategory( @$_GET['cat_id'] )->withCategories()->withOrder( @$_GET['order'] )->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}
	
	public function comments() {
		$posts=new Project_Wpress_Content_Posts();
		if ( !$posts->setBlogById( $_GET['id'] ) ) {
			$this->location( array( 'action'=>'manage' ) );
		}		
		$posts->withOrder('title--up')->getList( $this->out['arrPosts'] );
		$model=new Project_Wpress_Content_Comments();
		if ( !$model->setBlogById( $_GET['id'] ) ) {
			$this->location( array( 'action'=>'manage' ) );
		}
		$this->out['arrBlog']=$model->blog->filtered;
		if ( !empty( $_POST ) ) {
			if ( $model->setData( $_POST['arrComment'] )->set() ) {
				$this->location((!empty($_GET['redirect'])) ? $_GET['redirect'].'?id='.$_GET['id'] : '');
			}
			$this->out['arrErr']=$model->getErrors();
			$this->out['arrPost']=$model->getData();
		}
		$model->withPagging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->onlyPost( @$_GET['post_id'] )->withOrder( @$_GET['order'] )->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
	}
	
	public function pages() {
		$model=new Project_Wpress_Content_Pages();
		if ( !$model->setBlogById( $_GET['id'] ) ) {
			$this->location( array( 'action'=>'manage' ) );
		}
		$this->out['arrBlog']=$model->blog->filtered;
		if ( !empty( $_POST ) ) {
			if ( $model->setData( $_POST['arrPage'] )->set() ) {
				$this->location(array('wg'=>true));
			}
			$this->out['arrErr']=$model->getErrors();
			$this->out['arrPage']=$model->getData();
		}
		$model->withPagging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->withOrder( @$_GET['order'] )->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
	}

	public function edittheme() {
		$this->_model->onlyOne()->withIds($_GET['id'])->getList($arrBlog);
		$this->out['arrBlog'] =$arrBlog;
		$modelThemes=new Project_Wpress_Theme();
		$modelThemes->onlyOne()->onlySiteId( $arrBlog['id'] )->getList( $arrTheme );
		$_transport=new Project_Placement_Transport();
		if(!empty($_POST['arr'])){
			if(!empty($_POST['save'])){
				$_transport->setInfo( $arrBlog )->saveFile($_POST['arr']['content'],$_POST['arr']['file']);
			}
			$_transport->setInfo( $arrBlog )->readFile($this->out['arr']['content'],$_POST['arr']['file']);
			$this->out['arr']['file']=$_POST['arr']['file'];
		}
		$pathTheme='wp-content/themes/' . str_replace('.zip', '', $arrTheme['filename']) . '/';
		$_transport->setInfo( $arrBlog )->dirScan($this->out['arrDirs'], $pathTheme);
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
	}
	
	public function changetheme() {
		$this->objStore->getAndClear( $this->out );
		if ( empty($_GET['id']) ) {
			$this->location(array('action'=>'manage'));
		}
		$_model=new Project_Sites( Project_Sites::BF );
		if ( !$_model->getSite( $_arrSite['arrBlog'], $_GET['id'] ) ) {
			$this->objStore->toAction( 'manage' )->set( array( 'error'=>'This site was deleted' ) );
			$this->location( array( 'action' => 'manage' ) );
		}
		$_arrSite['arrBlog']['theme_id']=$_POST['theme'];
		unset( $_arrSite['arrBlog']['theme'] );
		$_arrSite['arrBlog']['files']=array( 'header'=>null, 'banner'=>null );
		if ( !empty( $_POST ) ) {
			if ( $_model->setEntered( $_arrSite )->set() ) {
				$this->objStore->set( array( 'msg'=>'success' ) );
				$this->location(array( 'action' => 'general', 'wg'=>'id='.$_GET['id']));
			}
			$_model->getEntered( $this->out['arrBlog'] );
			$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
		}
		$modelThemes=new Project_Wpress_Theme();
		$this->_model->onlyOne()->withIds($_GET['id'])->getList($this->out['arrBlog']);
		$modelThemes->onlyOne()->withPreview()->onlySiteId($_GET['id'])->getList( $this->out['selectedTheme'] );
		$modelThemes->withPreview()->getList( $this->out['arrList'] );
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
	}
	
	public function testdb() {
		$data=new Core_Data( $_POST );
		if ( !$data->setFilter( array( 'strip_tags', 'trim', 'clear' ) )->setChecker( array(
			'db_name'=>empty( $data->filtered['db_name'] ),
			'db_host'=>empty( $data->filtered['db_host'] ),
			'db_username'=>empty( $data->filtered['db_username'] ),
			'db_password'=>empty( $data->filtered['db_password'] ),
			'url'=>empty( $data->filtered['url'] ),
			'placement_id'=>empty( $data->filtered['placement_id'] ),
			'ftp_directory'=>empty( $data->filtered['ftp_directory'] ),
		) )->check() ) {
			$data->getErrors( $this->out_js['error'] );
			echo 'empty';
			die();
		}
		$_place=new Project_Placement();
		$_place->withIds( $data->filtered['placement_id'] )->onlyOne()->getList( $_arrPlace );
		$data->setElements(array(
			'ftp_host'		=> $_arrPlace['domain_ftp'],
			'ftp_username'	=> $_arrPlace['username'],
			'ftp_password'	=> $_arrPlace['password']
		));
		$connect=new Project_Wpress_Connector($data);
		if (!$connect->prepare()) {
			echo 'error';
			die();
		}
		echo 'succ';
		die();
	}
	
	public function multiboxmanage() {
		$this->manage();
	}
}
?>