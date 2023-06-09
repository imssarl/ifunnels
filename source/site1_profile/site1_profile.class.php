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
 * Setting profiles module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_profile extends Core_Module {

	private $_model;

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM setting profiles', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create', 'flg_tree'=>1 ),
				array( 'action'=>'edit', 'title'=>'Edit', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage', 'flg_tree'=>1 ),
			),
		);
	}

	public function before_run_parent() {
		$this->_model=new Project_Sites_Profiles();
	}

	public function create() {
		if ( !empty( $_POST['arrData'] ) ) {
			if ( $this->_model->setData( $_POST['arrData'] )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=> (( empty($_POST['arrData']['id']) )? 'created':'saved') ) );
				$this->location( array( 'action'=>'manage' ) );
			}
			$this->_model->getEntered( $this->out['arrData'] )->getErrors( $this->out['arrErr'] );
		}
	}

	public function edit() {
		if ( !$this->_model->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrData'] ) ) {
				$this->objStore->toAction( 'manage' )->set( array( 'error'=>'This profile was deleted' ) );
				$this->location( array( 'action'=>'manage' ) );
		}
		$this->create();
	}

	public function manage() {
		$this->objStore->getAndClear( $this->out );
		if ( !empty( $_POST ) ) { // del
			if ( !empty( $_POST['del'] ) ) {
				$this->objStore->set( array( 'msg'=>( $this->_model->del( array_keys( $_POST['del'] ) )? 'delete':'delete_error' ) ) );
			}
			$this->location();
		}
		if ( !empty( $_GET['dup'] ) ) { // duplicate
			$this->objStore->set( array( 'msg'=>( $this->_model->duplicate( $_GET['dup'] )? 'duplicated':'duplicated_error' ) ) );
			$this->location( array( 'action'=>'manage' ) );
		}
		$this->_model->withOrder( @$_GET['order'] )->withPaging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
		$this->_model->getPaging( $this->out['arrPg'] )->getFilter( $this->out['arrFilter'] );
	}
}
?>