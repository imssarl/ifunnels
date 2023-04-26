<?php

class admin_blogfusion extends Core_Module {
	
	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'Blogfusion', ),
			'actions'=>array(
				array( 'action'=>'plugins', 'title'=>'Plugins' ),
				array( 'action'=>'themes', 'title'=>'Themes'),
				array( 'action'=>'categories', 'title'=>'Categories' ),
				array( 'action'=>'wp_version', 'title'=>'WP version' ),
			)
		);
	}

	public function wp_version(){
		$_upgrader=Project_Wpress_Connector_Upgrade::getInstance()->runAsApplication();
		$_upgrader->getCurVersion( $this->out['version'] );
		if( !$_upgrader->checkVersion( $arrRes ) ){
			$this->out['new_version']=$arrRes['current'];
		}
		if ( !empty($_POST) ){
			Project_Wpress::wpVersion( $this->out['strLog'] );
		}
	}
	
	public function plugins() {
		$this->objStore->getAndClear( $this->out );
		$model = new Project_Wpress_Plugins();
		if( !empty( $_FILES['zip'] )&&$model->addCommonPlugin( $_FILES['zip'] ) ) {
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location( array('action' => 'plugins') );
		}
		if( !empty( $_GET['delete'] )&&$model->deleteCommonPlugin( $_GET['delete'] ) ) {
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location( array('action' => 'plugins') );
		}
		$model->getErrors( $this->out['arrErrors'] );
		$model->withPaging(array( 'url'=>$_GET ))
			->onlyCommon()
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}
	
	public function themes() {
		$this->objStore->getAndClear( $this->out );
		$model = new Project_Wpress_Theme();
		if ( !empty( $_FILES['zip'] )&&$model->addCommonTheme( $_POST['theme'], $_FILES['zip'] ) ) {
			$this->objStore->set( array( 'msg'=>'added' ) );
			$this->location( array('action' => 'themes') );
		}
		if( !empty( $_GET['delete'] )&&$model->deleteCommonTheme( $_GET['delete'] ) ) {
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location( array('action' => 'themes') );
		}
		$model->getErrors( $this->out['arrErrors'] );
		$model->withPaging(array( 'url'=>$_GET ))
			->onlyCommon()
			->withOrder( @$_GET['order'] )
			->withPreview()
			->getList( $this->out['arrList'] );
		$model->getPaging( $this->out['arrPg'] );
		$model->getFilter( $this->out['arrFilter'] );
	}
	
	public function categories() {}
}
?>