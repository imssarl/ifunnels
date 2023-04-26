<?php
/**
 * WorkHorse Framework
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2007-2013, Pavel Livinskiy
 * @author Pavel Livinskiy <ikontakts@gmail.com>
 * @date 19.12.2012
 * @version 1.0
 */


/**
 * News administration
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2007-2013, Pavel Livinskiy
 */
class news extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'News',
			),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Manage' ),
				array( 'action'=>'add', 'title'=>'Add' ),
			),
		);
	}

	public function add(){
		$_news=new Project_News();
		if( !empty($_POST['arrData']) ){
			if( $_news->setEntered( $_POST['arrData'] )->set() ){
				$this->location(array('action'=>'manage'));
			}
			$_news->getErrors( $this->out['arrErrors'] );
		}
		if( !empty($_GET['id']) ){
			$_news->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrData'] );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrG'] );
	}

	public function manage(){
		$_news=new Project_News();
		if( !empty($_GET['delete']) ){
			if( $_news->withIds( $_GET['delete'] )->del() ){
				$this->location();
			}
			$_news->getErrors( $this->out['arrErrors'] );
		}
		$_news->withPaging( array( 'url'=>$_GET ) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
	}
}
?>