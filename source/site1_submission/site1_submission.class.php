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
 * Article Submission module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_submission extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'Article Submission', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create Submission', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Submissions', 'flg_tree'=>1 ),
				array( 'action'=>'accounts', 'title'=>'Manage Directory Accounts', 'flg_tree'=>1 ),
				array( 'action'=>'profiles', 'title'=>'Manage Author Profiles', 'flg_tree'=>1 ),
				array( 'action'=>'edit', 'title'=>'Edit content for Submission project', 'flg_tree'=>1, 'flg_tpl' => 1 ),
			),
		);
	}

	public function create() {}

	public function manage() {}

	public function accounts() {}

	public function profiles() {}

	public function edit() {}
}
?>