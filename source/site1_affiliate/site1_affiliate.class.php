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
 * Affiliate profit booster module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_affiliate extends Core_Module {
	private $_model;
	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Affiliate profit booster', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create Affiliate Pages', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Affiliate Pages', 'flg_tree'=>1 ),
				array( 'action'=>'get', 'title'=>'Get file', 'flg_tpl' =>1, 'flg_tree'=>1 ),
				array( 'action'=>'save', 'title'=>'Save file', 'flg_tpl' =>1, 'flg_tree'=>1 ),
				array( 'action'=>'edit_file', 'title'=>'Edit file', 'flg_tree'=>1 ),
				array( 'action'=>'edit_settings', 'title'=>'Edit settings', 'flg_tree'=>1 ),
			),
		);
	}

	public function  before_run_parent(){
		$this->_model = new Project_Affiliate();
	}

	public function create() {}

	public function get(){
		if ( !$this->_model->init($_POST) ) {
			echo 'Can not connect to server!';
			die();
		}
		$fileContent = $this->_model->getFile($_POST);
		if ( $fileContent===false ) {
			echo 'No search file!';
			die();
		}
		echo str_replace( "\t", '&nbsp;&nbsp;&nbsp;&nbsp;', str_replace( array( "\r\n", "\n\r", "\n", "\r"), '<br/>', htmlentities( $fileContent ) ) );
		die();
	}

	public function save(){
		if( isset( $_GET['getcode'] ) ){
			$this->_model->createContent( $_POST );
			echo str_replace( "\t", '&nbsp;&nbsp;&nbsp;&nbsp;', str_replace( array( "\r\n", "\n\r", "\n", "\r"), '<br/>', htmlentities( $_POST['file_content'] ) ) );
			exit;
		}
		if( !$this->_model->init( $_POST ) ) {
			echo 0; die();
		}
//		if ( $_POST['edit']['type']  == 'edit' && !$_POST['convert_page']) {
//			echo (!$this->_model->writeFile( $_POST ) || !$this->setAffiliatePage( $_POST )) ? 0 : 1; die();
//		} else {
			$_POST['file_content']=html_entity_decode( str_replace( '<br/>', "\n", str_replace( '&nbsp;&nbsp;&nbsp;&nbsp;', "\t", $_POST['file_content'] ) ) );
			echo (!$this->_model->creatPage( $_POST ) ) ? 0 : 1; 
			die();
//		}
		
	}

	public function manage() {
		if ( isset($_GET['del']) ) {
			$type = (!empty($_GET['cpp'])) ? 'cpp' : 'affiliate';
			$this->_model->deleteAffiliatePage( $_GET['del'] , $type );
		}
		$this->out['arrItems'] = $this->_model->getAffiliatePages();	
	}

	public function edit_file() {
		$this->edit();
	}

	public function edit_settings() {
		$this->edit();
	}

	private function edit() {
		if ( empty( $_GET['id'] ) ) {
			$this->location('./');
		}
		if (empty($_GET['cpp'])) {
			$this->out['arrItem'] = $this->_model->getAffiliatePageById( $_GET['id'] );
		} else {
			$this->out['arrItem'] = $this->_model->getCppTrakingPage( $_GET['id'] );
		}
		$this->out['arrItem']['arrFtp']['placement_id'] = $this->out['arrItem']['arrTransport']['placement_id'];
		$this->out['arrItem']['arrFtp']['url'] = $this->out['arrItem']['page_address'];
		$this->out['arrItem']['arrFtp']['ftp_directory'] = $this->out['arrItem']['ftp_directory'];
	}
}

?>