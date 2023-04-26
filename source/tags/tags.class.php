<?php
/**
 * WorkHorse Framework
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2011, Rodion Konnov
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 17.03.2011
 * @version 3.0
 */


/**
 * Tags management module
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2011, Rodion Konnov
 */
class tags extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Tags',
			),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Tags management' ),
				array( 'action'=>'manage_type', 'title'=>'Types management' ),
				array( 'action'=>'cloud', 'title'=>'Cloud', 'flg_tree'=>1 ),
				array( 'action'=>'setlist', 'title'=>'Set taglist', 'flg_tpl'=>3, 'flg_tree'=>2 ),
			),
		);
	}

	public function getlist() {
		if ( empty( $this->params['type'] ) ) {
			throw new Exception( Core_Errors::DEV.'|type or item_id not setted for module tags:getlist' );
		}
		if ( !empty($this->params['item_id']) ){
			$obj=new Core_Tags( $this->params['type'] );
			$obj->setItem( $this->params['item_id'] )->get( $this->out['arrTags'] );
		}
	}

	public function setlist() {
		if ( empty( $_POST['type'] )||empty( $_POST['item_id'] ) ) {
			$this->out_js['error']='type or item_id not setted for module tags:setlist';
			return;
		}
		$obj=new Core_Tags( $_POST['type'] );
		if ( !$obj->setItem( $_POST['item_id'] )->setTags( $_POST['tags'] )->set() ) {
			$this->out_js['error']='tags not set though Core_Tags';
			return;
		}
		$obj->get( $this->out_js['tags'] );
		$this->out_js['error']=false;
	}

	public function manage() {
		if( empty($_GET['arrFilter']['type']) ){
			$this->location(array('action'=>'manage_type'));
		}
		$_model=new Core_Tags_Management();
		if(!empty($_POST['arrList'])){
			if( $_model->setEntered( $_POST['arrList'] )->setMass() ){
				$this->location(array('wg'=>true));
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		if( !empty($_POST['arrData']) ){
			$_tags=new Core_Tags($_POST['arrData']['type'] );
			$_tags->setTags( $_POST['arrData']['tags'] )->add();
			$this->location(array('wg'=>true));
		}
		$this->out['arrFilter']=$_GET['arrFilter'];
		$_model
			->withTagName( $_GET['arrFilter']['tagnames'] )
			->withTypes( $_GET['arrFilter']['type'] )
			->withPaging( array( 'url'=>$_GET ) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$_type=new Core_Tags_Types();
		$_type->toSelect()->getList($this->out['arrTypes']);
	}

	public function manage_type(){
		$_type=new Core_Tags_Types();
		if ( !empty( $_POST['arrTypes'] ) ) {
			if ( $_type->setEntered( $_POST['arrTypes'] )->setMass() ) {
				$this->location();
			}
			$_type->getErrors( $this->out['arrErr'] );
		}
		$_type
			->withPaging( array( 'url'=>$_GET ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
	}

}
?>