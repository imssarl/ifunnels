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
 * Social Bookmarking module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_sbookmarking extends Core_Module {

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Social Bookmarking', ),
			'actions'=>array(
				array( 'action'=>'gadget', 'title'=>'Web gadget', 'flg_tree'=>1 ),
			),
		);
	}

	public function gadget() {}
}
?>