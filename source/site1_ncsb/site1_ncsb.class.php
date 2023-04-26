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
 * Niche Content Site Builder module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_ncsb extends Core_Module {


	public function before_run_parent(){
		// добавление стандартных шаблонов для NCSB сайтов.
		$_ncsb=new Project_Sites_Templates( Project_Sites::NCSB  );
		$_ncsb->addCommonTemplatesToNewUser();
	}	
	
	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Niche Content Site Builder ', ),
			'actions'=>array(
				array( 'action'=>'import', 'title'=>'Import', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Create', 'flg_tree'=>1 ),
				array( 'action'=>'edit', 'title'=>'Edit', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage', 'flg_tree'=>1 ),
				array( 'action'=>'content', 'title'=>'Manage content', 'flg_tree'=>1 ),
				array( 'action'=>'templates', 'title'=>'Front Templates', 'flg_tree'=>1 ),
				array( 'action'=>'edit_templates', 'title'=>'Edit Template', 'flg_tree'=>1 ),
				array( 'action'=>'ajax_edit_template', 'title'=>'Ajax edit template', 'flg_tree'=>1, 'flg_tpl' => 1  ),
				array( 'action'=>'admin_templates', 'title'=>'Templates' ),
				array( 'action'=>'multiboxlist', 'title'=>'Popup Site List', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'multiboxmanage', 'title'=>'Popup manage ncsb site', 'flg_tree'=>1, 'flg_tpl' => 1 ),
			),
		);
	}

	public function create() {
		$_model=new Project_Sites( Project_Sites::NCSB );
		if ( !empty( $_POST ) ) {
			$_POST['multibox_ids_content_wizard'] = json_decode( $_POST['multibox_ids_content_wizard'], true );
			if ( $_model->setEntered( $_POST )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'uploaded' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$_POST['strJson'] = Zend_Registry::get( 'CachedCoreString' )->php2json($_POST['multibox_ids_content_wizard']);
			$this->out += $_POST;
			$this->out['arrOpt'] = $_POST;
		} elseif ( !empty( $_GET['id'] ) ) {
			$_model->getSite( $this->out, $_GET['id'] );
		}
		$_model->getErrors($this->out['arrErrors']);
		$_templates=new Project_Sites_Templates( Project_Sites::NCSB );
		$_templates->withRight()->toSelect()->getList( $this->out['arrTemplates'] );
		$_templates->withPreview()->getList( $this->out['strTemplatesInfo'] );
		$this->out['strTemplatesInfo']=Zend_Registry::get( 'CachedCoreString' )->php2json($this->out['strTemplatesInfo']);
		$category = new Core_Category( 'Blog Fusion' );
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
		$category = new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson'] = Zend_Registry::get( 'CachedCoreString' )->php2json($arrTree);				
	}

	public function edit() {
		$_model=new Project_Sites( Project_Sites::NCSB );
		if ( !$_model->getSite( $arrSite, $_POST['arrNcsb']['id'] ) ) {
				$this->objStore->toAction( 'manage' )->set( array( 'error'=>'This site was deleted' ) );
				$this->location( array( 'action' => 'manage' ) );
		}
		$_model->withOrder( @$_GET['order'] )->getList( $this->out['menuSites'] );
		$_model->getFilter( $this->out['arrFilter'] );
		$this->create();
	}

	public function content(){
		$this->objStore->getAndClear( $this->out );
		$_content=new Project_Sites_Content( Project_Sites::NCSB );
		// инфа о сайтах и конкретном сайте
		$_model=new Project_Sites( Project_Sites::NCSB );
		$_model->withOrder( @$_GET['order'] )->getList( $this->out['menuSites'] );
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
			) );
		$model->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
		$_templates=new Project_Sites_Templates( Project_Sites::NCSB );
		$_templates->withPreview()->getList( $this->out['arrTemplates'] );
		$category = new Core_Category( 'Blog Fusion' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json( $arrTree );		
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
		$sites = new Project_Sites( Project_Sites::NCSB );
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
	
	public function multiboxmanage() {
		$this->manage();
	}
}
?>