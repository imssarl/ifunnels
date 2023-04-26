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
class site1_domain_parking extends Core_Module  {

	public function before_run_parent(){
		// добавление стандартных шаблонов для NVSB сайтов.
		$_nvsb=new Project_Sites_Templates( Project_Sites::NVSB );
		$_nvsb->addCommonTemplatesToNewUser();
	}

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Domain Parking', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create', 'flg_tree'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage Project', 'flg_tree'=>1 ),
				array( 'action'=>'manage_domain', 'title'=>'Manage your Parked Domains', 'flg_tree'=>1 ),
				array( 'action'=>'stat', 'title'=>'Statistic', 'flg_tree'=>1,'flg_tpl'=>1 ),
			),
		);
	}

	public function manage_domain(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Placement();
		if(!empty($_GET['del'])||!empty($_POST['del'])){
			$_sites=new Project_Sites( Project_Sites::NVSB );
			$_sites->withPlacementId( (empty($_GET['del'])?$_POST['del']:$_GET['del']) )->onlyIds()->getList( $_arrSites );
			$_sites->delSites( $_arrSites );
			if( $_model->withIds( (empty($_GET['del'])?$_POST['del']:$_GET['del']) )->del() ){
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		$_model->withType( Project_Placement::LOCAL_HOSTING )->withDomain($_GET['arrFilter']['domain_http'] )->withOrder( @$_GET['order'] )->onlyOwner()->getList( $this->out['arrList'] );
	}

	public function create() {
		$_model=new Project_Parking();
		if( !empty($_POST['arr']) ){
			if( $_model->setFile( $_FILES)->setEntered( $_POST['arr'] )->set()) {
				$this->objStore->set( array( 'msg'=>'Post saved' ) );
				$this->location(array('action'=>'manage'));
			}
		}
		$_model->getErrors( $this->out['arrErrors'] );
	}

	public function manage(){
		$_model=new Project_Parking();
		if(!empty($_GET['del'])){
			$_model->withIds( $_GET['del'] )->del();
			$this->location();
		}
		$this->objStore->getAndClear( $this->out );
		$_model->onlyOwner()->withOrder( @$_GET['order'] )->withPaging( array(
			'url'=>@$_GET,
			'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
			'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
		) )->getList( $this->out['arrList'] );
	}

	public function stat(){
		$_model=new Project_Parking();
		$_model->withIds( $_GET['id'] )->onlyOne()->getList($this->out['arr']);
		$this->out['arr']['domains']=unserialize($this->out['arr']['domains']);
	}
}

?>