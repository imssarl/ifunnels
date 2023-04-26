<?php
/**
 * WorkHorse Framework
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2012, Rodion Konnov
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 22.11.2011
 * @version 2.0
 */


/**
 * Access rights administration
 *
 * @category WorkHorse
 * @package ProjectSource
 * @copyright Copyright (c) 2005-2012, Rodion Konnov
 * @license http://opensource.org/licenses/ MIT License
 */
class documents extends Core_Module {

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Documents',
			),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Manage documents' ),
				array( 'action'=>'set', 'title'=>'Add/Edit documents' )
			),
		);
	}

	public function manage(){
		$_model=new Project_Documents();
		if( !empty($_GET['delete'])&&$_model->withIds($_GET['delete'])->del() ){
			$this->location();
		}
		$_model->withPaging(array('url'=>$_GET))
				->withOrder($_GET['order'])
				->getList( $this->out['arrList'] )
				->getPaging( $this->out['arrPg'] );
	}

	public function set(){
		$_model=new Project_Documents();
		if( !empty($_POST['arrData'])&&$_model->setEntered( $_POST['arrData'])->set() ){
			$this->location(array('action'=>'manage'));
		}
		$_model->getEntered( $this->out['arrData'] );
		$_model->getErrors( $this->out['arrErrors'] );
		if(!empty($_GET['id'])){
			$_model->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrData'] );
		}
	}

}
?>