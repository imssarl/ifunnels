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
 * Snippets module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_snippets extends Core_Module {

	private $_snippets;
	private $_parts;

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'Snippets module', ),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Snippets manage', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Snippets create', 'flg_tree'=>1 ),
				array( 'action'=>'partcreate', 'title'=>'Snippet part create', 'flg_tree'=>1 ),
				array( 'action'=>'getcode', 'title'=>'Snippet Get code', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'summary', 'title'=>'Snippet Summary information', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'show', 'title'=>'Snippet Preview', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'request', 'title'=>'Request get', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'spots', 'title'=>'Snippet to spot', 'flg_tree'=>1, 'flg_tpl'=>1 ),
			),
		);
	}

	public function before_run_parent(){
		$this->_snippets=new Project_Widget_Adapter_Copt_Snippets();
		$this->_parts = new Project_Widget_Adapter_Copt_Parts();
	}

	public function manage() {
		$this->objStore->getAndClear( $this->out );
		if (!empty($_GET)&empty($_GET['order'])&empty($_GET['page'])) {
			if ( !empty($_GET['snippet_del_id']) ) {
				if ( !$this->_snippets->del( $_GET['snippet_del_id'] ) ) {
					$this->objStore->set( array( 'msg'=>'Snippet successful deleted' ) );
				} else {
					$this->objStore->set( array( 'error'=>'Snippet not successful deleted' ) );
				}
			}
			if ( !empty($_GET['part_del_id']) ) {
				if ( !$this->_parts->del( $_GET['part_del_id'] ) ) {
					$this->objStore->set( array( 'msg'=>'Part successful deleted' ) );
				} else {
					$this->objStore->set( array( 'error'=>'Part not successful deleted' ) );
				}
			}
			if ( !empty($_GET['snippet_duplicate_id']) ) {
				if ( $this->_snippets->duplicate( $_GET['snippet_duplicate_id'] ) ) {
					$this->objStore->set( array( 'msg'=>'Snippet successful duplicated' ) );
				} else {
					$this->objStore->set( array( 'error'=>'Snippet not successful duplicated' ) );
				}
			}
			if ( !empty($_GET['part_duplicate_id']) ) {
				if ( $this->_parts->onlySnippet( $_GET['snippet_id'] )->duplicate( $_GET['part_duplicate_id'] )) {
					$this->objStore->set( array( 'msg'=>'Part successful duplicated' ) );
				} else {
					$this->objStore->set( array( 'error'=>'Part not successful duplicated' ) );
				}
			}
			$this->location( array( 'action'=>'manage') );
		}
		$this->_snippets->withOrder( @$_GET['order'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->withParts()->getList( $this->out['arrList'] );
		$this->_snippets->getPaging( $this->out['arrPg'] );
		$this->_snippets->getFilter( $this->out['arrFilter'] );
	}

	public function create() {
		if (!empty($_POST)) {
			if ( $this->_snippets->setData( $_POST['arrSnip'] )->set() ) {
				$this->_snippets->getEntered( $_arrData );
				if( isset( $_POST['arrSnip']['flg_traffic_exchange'] ) && $_POST['arrSnip']['flg_traffic_exchange']==1 && Core_Users::$info['id'] == '1' ){
					$_traffic=new Project_Traffic();
					$_traffic->setAds( Project_Widget_Adapter_Copt_Snippets::getCode($_arrData['id']) );
				}
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'Snippet created successfully' ) );
				$this->location( array( 'action'=>'manage') );
			}
			$this->objStore->toAction( 'manage' )->set( array( 'error'=>'Snippet not successful created' ) );
		}
		$this->_snippets
				->getEntered( $this->out['arrSnip'] )
				->getErrors( $this->out['arrErrors'] );
		if (!empty($_GET)) {
			$this->_snippets->onlyOne()->withIds( $_GET['id'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrSnip'] );
			if( Core_Users::$info['id'] == '1' ){
				$_traffic=new Project_Traffic();
				$this->out['arrSnip']['flg_traffic_exchange']=0;
				preg_match('#&id=(.*)"#im', $_traffic->getAds(), $_matches);
				if( Project_Widget_Mutator::decode( $_matches['1'] ) == $this->out['arrSnip']['id'] ){
					$this->out['arrSnip']['flg_traffic_exchange']=1;
				}
			}
		}
	}

	public function partcreate() {
		if (!empty($_POST)) {
			if ( $this->_parts->setData( $_POST['arrPart'] )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'Part created successfully'  ) );
				$this->location( array( 'action'=>'manage') );
			}
			$this->objStore->toAction( 'manage' )->set( array( 'error'=>'Part not successful created' ) );
			$this->_parts
				->getEntered( $this->out['arrPart'] )
				->getErrors( $this->out['arrErr'] );
		}
		if (!empty($_GET['snippet_id'])) {
			if (!empty($_GET['id'])) {
				$this->_parts->onlyOne()->withIds( $_GET['id'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrPart'] );
			}
			$this->out['arrPart']['snippet_id'] = $_GET['snippet_id'];
		}
	}

	public function getcode() {
		$this->out['show_id'] = $_GET['id'];
		$this->out['http'] = Zend_Registry::get( 'config' )->engine->project_domain;
	}

	public function show() {
		if ( !empty($_GET['id']) ) {
			$this->_parts->onlyOne()->withIds( $_GET['id'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $arrPart );
			$this->out['data'] = $arrPart['parsed'];
		}
	}

	public function summary() {
		if ( !empty($_GET['snippet_id']) ) {
			$this->_snippets->withIds( $_GET['snippet_id'] )->withOrder( @$_GET['order'] )->getStatistic( $this->out['arrList'] );
			$this->_snippets->getFilter( $this->out['arrFilter'] );
		}
		if ( !empty($_GET['part_id']) ) {
			$this->_parts->withIds( $_GET['part_id'] )->withOrder( @$_GET['order'] )->getStatistic( $this->out['arrList'] );
			$this->_parts->getFilter( $this->out['arrFilter'] );
		}
	}

	public function request(){
		if (!empty($_POST['id'])) {
			$this->_parts = new Project_Widget_Adapter_Copt_Parts();
			switch (  $_POST['rel'] ) {
				case 'pause' : $this->out_js = $this->_parts->withIds( $_POST['id'] )->pause(1); break;
				case 'start' : $this->out_js = $this->_parts->withIds( $_POST['id'] )->pause(0); break;
				case 'resume' : $this->out_js = $this->_parts->withIds( $_POST['id'] )->reset(); break;
			}
		}
	}

	public function spots(){
		$this->_snippets->getList( $this->out['arrList'] );
		$this->out['ids'] = $_POST['ids'];
		$this->out['spot_index'] = $_POST['spot_index'];
	}
}
?>