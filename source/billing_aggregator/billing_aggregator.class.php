<?php
/**
 * WorkHorse Framework
 *
 * @category Project
 * @package Project_Exquisite
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2015, web2innovation
 * @author Slepov Viacheslav <shadowdwarf@mail.ru>
 * @date 11.03.2015
 * @version 1.0
 */


/**
 * Billing Aggregator backend
 *
 * @category Project
 * @package Billing Aggregator
 * @copyright Copyright (c) 2005-2015, web2innovation
 * @license http://opensource.org/licenses/ MIT License
 */
class billing_aggregator extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Billing Aggregator',
			),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Manage' ),
			),
		);
	}

	public function manage(){
		$_billing=new Project_Billing();
		if(!empty($_GET['del'])&&$_billing->withIds($_GET['del'])->del()){
			$this->location();
		}
		$_billing->withPaging(array( 'url'=>$_GET ))
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}
}
?>