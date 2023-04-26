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
 * Remote File Editor module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_file_editor extends Core_Module  {
	
	public function set_cfg(){		
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Remote File Editor', ),
			'actions'=>array(
				array( 'action'=>'edit', 'title'=>'Edit', 'flg_tree'=>1 ),
			),
		);
	}
	
	public function edit() {}
}

?>