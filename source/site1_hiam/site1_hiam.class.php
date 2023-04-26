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
 * HIAM module
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_hiam extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM HIAM module', ),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'HIAM company manage', 'flg_tree'=>1 ),
				array( 'action'=>'create', 'title'=>'HIAM company create', 'flg_tree'=>1 ),
				array( 'action'=>'manage_split', 'title'=>'HIAM split test', 'flg_tree'=>1 ),
				array( 'action'=>'create_split', 'title'=>'HIAM create split test', 'flg_tree'=>1 ),
				array( 'action'=>'getcode', 'title'=>'Get Company code', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'selectfile', 'title'=>'Select file corner/sound/background', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'request', 'title'=>'Request get', 'flg_tpl'=>3, 'flg_tree'=>2 ),
				array( 'action'=>'summary', 'title'=>'Company click/view information', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'manage_corners', 'title'=>'Manage corners'),
				array( 'action'=>'manage_sounds', 'title'=>'Manage sounds' ),
				array( 'action'=>'manage_backgrounds', 'title'=>'Manage backgrounds'),
				array( 'action'=>'input_file', 'title'=>'Set file', 'flg_tpl'=>1),
				// ниже будет в дальнейшем переделываться
				array( 'action'=>'hiam_default_corners', 'title'=>'Hiam default corners', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'hiam_user_corners', 'title'=>'Hiam user corners', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'hiam_default_sounds', 'title'=>'Hiam default sounds', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'hiam_user_sounds', 'title'=>'Hiam user sounds', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'hiam_default_backgrounds', 'title'=>'Hiam default backgrounds', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'hiam_user_backgrounds', 'title'=>'Hiam user backgrounds', 'flg_tree'=>1, 'flg_tpl'=>1 ),
			),
		);
	}

	public function manage(){
		$company = new Project_Widget_Adapter_Hiam_Campaign ();
		$this->objStore->getAndClear( $this->out );
		if ( !empty($_GET['company_del_id']) ) {
			if ( $company->withIds( $_GET['company_del_id'] )->onlyOwner()->del() ) {
				$this->objStore->set( array( 'msg'=>'Company deleted successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company not  deleted' ) );
			}
			$this->location( array( 'action'=>'manage') );
		}
		if ( !empty($_GET['company_duplicate_id']) ) {
			if ( $company->duplicate( $_GET['company_duplicate_id'] ) ) {
				$this->objStore->set( array( 'msg'=>'Company duplicated successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Company not duplicated' ) );
			}
			$this->location( array( 'action'=>'manage') );
		}
		$company->onlyOwner()->withOrder( @$_GET['order'] )->setFilter( @$_GET['arrType'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function create(){
		$company = new Project_Widget_Adapter_Hiam_Campaign ();
		if (!empty($_POST)) {
			if ( $company->setEntered( $_POST['arrCom'] )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'Compaign created successfully ' ) );
				$this->location( array( 'action'=>'manage') );
			}
			$this->objStore->toAction( 'manage' )->set( array( 'error'=>'Compaign not created' ) );
			return;
		}
		$company
			->getEntered( $this->out['arrCom'] )
			->getErrors( $this->out['arrErrors'] );
		if (!empty($_GET)) {
			$company->onlyOwner()->onlyOne()->withIds( $_GET['id'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrCom'] );
		}
	}

	public function manage_split(){
		$this->objStore->getAndClear( $this->out );
		$splittest = new Project_Widget_Adapter_Hiam_Split ();
		if ( !empty($_GET['split_del_id']) ) {
			if ( $splittest->del( $_GET['split_del_id'] ) ) {
				$this->objStore->set( array( 'msg'=>'Split test deleted successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Split test not deleted' ) );
			}
			$this->location( array( 'action'=>'manage_split') );
		}
		if ( !empty($_GET['split_duplicate_id']) ) {
			if ( $splittest->duplicate($_GET['split_duplicate_id'])) {
				$this->objStore->set( array( 'msg'=>'Split test duplicated successfully' ) );
			} else {
				$this->objStore->set( array( 'error'=>'Split test not duplicated' ) );
			}
			$this->location( array( 'action'=>'manage_split') );
		}
		$splittest->onlyOwner()->withOrder( @$_GET['order'] )->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function create_split(){
		$splittest = new Project_Widget_Adapter_Hiam_Split ();
		if (!empty($_POST)) {
			if ( $splittest->setEntered( $_POST['arrSplit'] )->set() ) {
				$this->objStore->toAction( 'manage_split' )->set( array( 'msg'=>'Split test created successfully ' ) );
				$this->location( array( 'action'=>'manage_split') );
			}
			$this->objStore->toAction( 'manage_split' )->set( array( 'error'=>'Split test not created' ) );
		}
		$splittest
			->getEntered( $this->out['arrSplit'] )
			->getErrors( $this->out['arrErr'] )
			->getErrors( $this->out['arrErrors'] );
		if (!empty($_GET)) {
			$splittest->onlyOwner()->onlyOne()->withIds( $_GET['id'] )->getList( $this->out['arrSplit'] );
		}
		$company=new Project_Widget_Adapter_Hiam_Campaign();
		$company
			->onlyOwner()
			->getList( $this->out['arrSplit']['compains'] );
	}

	public function getcode(){
		switch ( $_GET['type'] ) {
			case 'splittest': 
				$this->out['showtext'] = Project_Widget_Adapter_Hiam_Split::getCode( $_GET['id'] );
			break;
			case 'company': 
				$this->out['showtext'] = Project_Widget_Adapter_Hiam_Campaign::getCode( $_GET['id'] );
			break;
		}
	}
	
	public function selectfile(){
		if ( !empty( $_POST ) || !empty( $_FILES ) ) {
			$company = new Project_Widget_Adapter_Hiam_Campaign ();
			$company
				->setPost( $_POST )
				->setFile( $_FILES )
				->getResult( $this->out['arrRes'] );
		}
		$company = new Project_Widget_Adapter_Hiam_Campaign ();
		$company
			->onlyOwner()
			->fileType( $_GET['select'] )
			->withPaging(array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$this->out['select'] = $_GET['select'];
	}

	public function request(){
		if(empty($_POST['split_id'])) {
			return false;
		}
		$splittest = new Project_Widget_Adapter_Hiam_Split();
		if( $_POST['rel']=='winner' ){
			$this->out_js = $splittest->withIds( $_POST['split_id'] )->withWinnerId( $_POST['com_id'] )->request();
		}elseif( $_POST['rel']=='pause' ){
			$this->out_js = $splittest->getCampaign( $_POST['split_id'] );
		}
		return true;
	}

	public function summary(){
		if ( !empty($_GET['id']) ) {
			$company = new Project_Widget_Adapter_Hiam_Campaign ();
			if( $_GET['view'] == 'clicks' ){
				$company
					->onlyOwner()
					->withIds( @$_GET['id'] )
					->withOrder( @$_GET['order'] )
					->onlyClicks()
					->getStatistic( $this->out['arrList'] );
			} elseif( $_GET['view'] == 'effectiveness' ){
				$company
					->onlyOwner()
					->withIds( @$_GET['id'] )
					->withOrder( @$_GET['order'] )
					->onlyEffectiv()
					->getStatistic( $this->out['arrList'] );
			}
			$company->getFilter( $this->out['arrFilter'] );
		}
	}

	public function manage_corners(){
		$this->out['sysname']='hiam_default_corners';
	}
	
	public function manage_sounds(){
		$this->out['sysname']='hiam_default_sounds';
	}
	
	public function manage_backgrounds(){
		$this->out['sysname']='hiam_default_backgrounds';
	}

	public function input_file(){
		$this->out['sysname']=$_GET['sysname'];
	}

	public function hiam_default_corners(){
		$this->out['flg_access']=0;
		$this->out['set_to_item']='file_corner';
		$this->out['sysname']='hiam_default_corners';
	}

	public function hiam_user_corners(){
		$this->out['flg_access']=1;
		$this->out['set_to_item']='file_corner';
		$this->out['sysname']='hiam_user_corners';
	}

	public function hiam_default_sounds(){
		$this->out['flg_access']=0;
		$this->out['set_to_item']='file_sound';
		$this->out['sysname']='hiam_default_sounds';
	}

	public function hiam_user_sounds(){
		$this->out['flg_access']=1;
		$this->out['set_to_item']='file_sound';
		$this->out['sysname']='hiam_user_sounds';
	}

	public function hiam_default_backgrounds(){
		$this->out['flg_access']=0;
		$this->out['set_to_item']='file_background';
		$this->out['sysname']='hiam_default_backgrounds';
	}

	public function hiam_user_backgrounds(){
		$this->out['flg_access']=1;
		$this->out['set_to_item']='file_background';
		$this->out['sysname']='hiam_user_backgrounds';
	}
}
?>