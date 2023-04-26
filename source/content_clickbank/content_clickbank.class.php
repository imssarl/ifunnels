<?php

class content_clickbank extends Core_Module {
	
	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'Clickbank', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create' ),
				array( 'action'=>'manage', 'title'=>'Manage' ),
				array( 'action'=>'ajax_get', 'title'=>'Ajax get', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'categories', 'title'=>'Categories' ),
				array( 'action'=>'preview', 'title'=>'Preview', 'flg_tpl'=>1, 'flg_tree'=>2  ),
				array( 'action'=>'previewfrontend', 'title'=>'Preview Frontend', 'flg_tpl'=>1, 'flg_tree'=>1  )
			)
		);
	}

	public  function previewfrontend(){
		$_model=new Project_Content_Adapter_Clickbank();
		if( !empty($_GET['id']) ){
			$_model->setSettings(array('affiliate_id'=>Project_Content_Adapter_Clickbank::$defaultAFid))->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrItem'] );
		}
	}

	public  function preview(){
		$_model=new Project_Content_Adapter_Clickbank();
		if( !empty($_GET['id']) ){
			$_model->setSettings(array('affiliate_id'=>Project_Content_Adapter_Clickbank::$defaultAFid))->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrItem'] );
		}
	}

	public function create(){
		$_model=new Project_Content_Adapter_Clickbank();
		if (!empty($_POST['arrData'])){
			if ( $_model->setFile( $_FILES )->setData( $_POST['arrData'] )->set() ){
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>(!empty($_GET['id']))?'saved':'created' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$_model->getErrors($this->out['arrErrors']);
			$this->out['arrData']=$_POST['arrData'];
		}
		$category=new Core_Category( 'Clickbank' );
		if (!empty($_GET['id'])){
			$_model->forEdit()->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
			$category->getLng()->setCurLang( Core_Language::$flags[$this->out['arrData']['flg_language']]['title'] );
		}
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$category->getTree( $this->out['arrTree'] );
	}
	
	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Content_Adapter_Clickbank();
		if(!empty($_GET['delete'])){
			$this->objStore->set( array( 'msg'=>( $_model->del(array($_GET['delete'])) ) ? 'delete':'delete_error' ) );
			$this->location( array( 'action' => 'manage' ));
		}
		$_model
			->setFilter($_GET['arrFilter'] )
			->withPaging(array(
				'page'=>@$_GET['page'],
				'url'=>$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList($this->out['arrList']);
		$_model->getFilter( $this->out['arrFilter'] );
		$_model->getPaging( $this->out['arrPg'] );
		$category=new Core_Category( 'Clickbank' );
		$category->getLevel( $this->out['arrCategories'], @$_GET['pid'] );
		$_model->forBeckend()->withThumb()->getCountItems( $this->out['arrCategories'] );
		$category->getTree( $arrTree );
		$_model->forBeckend()->withThumb()->getCountItems( $arrTree );
		$this->out['treeJson']=Zend_Registry::get( 'CachedCoreString' )->php2json( $arrTree );		
	}
	
	public function ajax_get(){
		$_model=new Project_Content_Adapter_Clickbank();
		if( !empty($_GET['get-items']) ){
			$_model->withThumb($_POST['arrData']['thumb'])->setFilter( $_POST['arrData'] )->getList( $this->out_js['arr'] );
			return true;
		}
		$cat=new Core_Category( 'Clickbank' );
		$cat->getLng()->setCurLang( Core_Language::$flags[$_POST['lang']]['title'] );
		$cat->setMode( 'view' )->getTree( $this->out_js );
		if( !empty($_GET['withthumb']) ){
			$_model->withThumb($_GET['withthumb']);
		}
		$_model->getCountItems( $this->out_js );

	}

	public function categories() {}
}
?>