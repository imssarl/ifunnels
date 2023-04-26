<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2013, web2innovation
 * @author Pavel Livinskiy <ikontakts@gmail.com>
 * @date 13.01.2013
 * @version 1.0
 */


/**
 * Service Provider
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_sp extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Service Provider', ),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Manage accounts', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'Create accounts', 'flg_tree'=>1 ),
			),
		);
	}

	public function manage(){
		$_model=new Project_Users_Provider();
		if(!empty($_GET['login'])){
			$_model->loginAsSA( $_GET['login'],$_GET['code'] );
			$this->location(array('name'=>'site1_accounts', 'action'=>'main'));
		}
		if( !empty($_GET['del'])&&$_model->withIds( $_GET['del'] )->del() ){
			$this->location();
		}
		$_model->getErrors( $this->out['arrErrors'] );
		$_model->withOrder( @$_GET['order'] )->withPaging(array(
			'url'=>@$_GET,
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
		$_model=new Project_Users_Provider();
		$_model->onlyCount()->getList( $this->out['intSubaccountCount'] );
	}

	public function create(){
		$_model=new Project_Users_Provider();
		if( !empty($_POST['arrData']) ){
			if( isset( $_POST['arrData']['flg_allow_sub'] ) && $_POST['arrData']['flg_allow_sub']==1 ){
				$_POST['arrData']['flg_rights']=Core_Users_Management::WRITE_READ_RIGHT;
			}else{
				$_POST['arrData']['flg_rights']=Core_Users_Management::READ_RIGHT;
			}
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				$this->location(array('action'=>'manage'));
			}
		}
		if( !empty($_GET['id']) ){
			$_model->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrData'] );
		}
		$_model->getEntered($this->out['arrData'])->getErrors( $this->out['arrErrors'] );
		$_model->onlyCount()->getList( $this->out['intSubaccountCount'] );
	}
}
?>