<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 * @author Pavel Livinskiy <ikontakts@gmail.com>
 * @date 1.08.2012
 * @version 1.0
 */


/**
 * HIAM Lite module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_hiam_lite extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM HIAM Lite module', ),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Manage' ),
				array( 'action'=>'create', 'title'=>'Create' ),
			),
		);
	}

	public function manage(){
		$_model=new Project_Widget_Adapter_Hiam_Lite();
		if( !empty( $_GET['delete'] )&&$_model->withIds( $_GET['delete'] )->del() ){
			$this->location();
		}
		$_model
			->withPaging( array('url'=>$_GET) )
			->withOrder( $_GET )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$_groups=new Core_Acs_Groups();
		$_groups->getList( $this->out['arrGroups'] );
	}

	public function create(){
		$_model=new Project_Widget_Adapter_Hiam_Lite();
		if( !empty( $_POST['arrData'] )&&$_model->setEntered( $_POST['arrData'] )->set() ){
			$this->location( array('action'=>'manage') );
		}
		$_model->getEntered( $this->out['arrData'] );
		$_model->getErrors( $this->out['arrErrors'] );
		if( !empty( $_GET['id'] ) ){
			$_model->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrData'] );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->getList( $this->out['arrGroups'] );
	}

	public function view(){
		$_model=new Project_Widget_Adapter_Hiam_Lite();
		$_model
			->forFrontend()
			->getList( $this->out['arrList'] );
	}
}
?>