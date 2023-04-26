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
 * Organizer module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_organizer extends Core_Module {
	
	public function set_cfg() {
		$this->inst_script=array(
			'module' =>array( 'title'=>'CNM Organizer', ),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Organizer', 'flg_tree'=>1 ),
				array( 'action'=>'archive', 'title'=>'Archive', 'flg_tree'=>1 ),
			),
		);
	}

	public function before_run_parent(){
		if(!Core_Acs::haveWrite()&&!empty($_POST)){
			unset($_POST);
		}
	}

	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Organizer();
		if ( !empty( $_GET['delete'] ) ) { // del
			$this->objStore->set( array( 'msg'=>( $_model->del( array( $_GET['delete'] ) )? 'delete':'delete_error' ) ) );
			$this->location( array( 'action'=>'manage' ) );
		}		
		if ( !empty( $_GET['archive'] ) ) { // archive
			$this->objStore->set( array( 'msg'=>( $_model->archive( array( $_GET['archive'] ), true )? 'archive':'archive_error' ) ) );
			$this->location( array( 'action'=>'manage' ) );
		}
		if (!empty($_POST['arrData'])){
			if ( $_model->setData($_POST['arrData'])->set() ){
				$this->objStore->set( array( 'msg'=> (( empty($_POST['arrData']['id']) )? 'created':'saved') ) );
				$this->location();				
			}
			$this->_model->getEntered( $this->out['arrData'] )->getErrors( $this->out['arrErr'] );
		}
		$_model->withOrder( @$_GET['order'] )->withPaging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
		$_model->getPaging( $this->out['arrPg'] )->getFilter( $this->out['arrFilter'] );		
	}
	
	public function archive(){
		$_model=new Project_Organizer();
		if ( !empty( $_GET['delete'] ) ) { // del
			$this->objStore->set( array( 'msg'=>( $_model->del( array( $_GET['delete'] ) )? 'delete':'delete_error' ) ) );
			$this->location( array( 'action'=>'archive' ) );
		}		
		if ( !empty( $_GET['unarchive'] ) ) { // archive
			$this->objStore->set( array( 'msg'=>( $_model->archive( array( $_GET['unarchive'] ), false )? 'unarchive':'unarchive_error' ) ) );
			$this->location( array( 'action'=>'archive' ) );
		}
		if (!empty($_POST['arrData'])){
			if ( $_model->setData($_POST['arrData'])->set() ){
				$this->objStore->set( array( 'msg'=> (( empty($_POST['arrData']['id']) )? 'created':'saved') ) );
				$this->location();				
			}
			$this->_model->getEntered( $this->out['arrData'] )->getErrors( $this->out['arrErr'] );
		}		
		$_model->onlyArchive()->withOrder( @$_GET['order'] )->withPaging( array( 
			'page'=>@$_GET['page'], 
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
		$_model->getPaging( $this->out['arrPg'] )->getFilter( $this->out['arrFilter'] );		
	}
}
?>