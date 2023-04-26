<?php

class widget extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'Widget', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create' ),
				array( 'action'=>'manage', 'title'=>'Manage' ),
				array( 'action'=>'ajax_get', 'title'=>'Ajax get', 'flg_tpl'=>3, 'flg_tree'=>2 )
			)
		);
	}

	public function create(){
		$_model=new Project_Widget_Adapter_Cnbgenerator_Content();
		if( !empty($_POST) ){
			if( $_model->setEntered( $_POST['arrData'])->set() ){
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>(!empty($_GET['id']))?'saved':'created' ) );
				$this->location( array( 'action' => 'manage' ) );
			}
			$_model->getErrors($this->out['arrErrors']);
			$_model->getEntered( $this->out['arrData'] );
		}
		if (!empty($_GET['id'])){
			$_model->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
		}
		$_keyword=new Project_Widget_Adapter_Cnbgenerator_Keywords();
		$this->out['arrOrder']=$_keyword->getSphinxOrder();
		$this->out['arrFields']=$_keyword->getSphinxFields();
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Widget_Adapter_Cnbgenerator_Content();
		if(!empty($_GET['delete'])){
			$this->objStore->set( array( 'msg'=>( $_model->withIds(array($_GET['delete']))->del() ) ? 'delete':'delete_error' ) );
			$this->location( array( 'action' => 'manage' ));
		}
		$_model->withPaging(array(
			'page'=>@$_GET['page'],
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList($this->out['arrList'])
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function ajax_get(){
		$_model=new Project_Widget_Adapter_Cnbgenerator_Keywords();
		$_model->setEntered( $_POST )->getKeywords( $this->out_js['keywords'] );
	}
}
?>