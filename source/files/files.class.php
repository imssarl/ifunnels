<?php

class files extends Core_Module {
	
	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'Files', ),
			'actions'=>array(
				array( 'action'=>'groups_manager', 'title'=>'Groups management'),
				array( 'action'=>'files_manager', 'title'=>'Files management'),
				array( 'action'=>'file_info', 'title'=>'File info', 'flg_tpl'=>1),
			)
		);
	}

	public function groups_manager(){
		$this->objStore->getAndClear( $this->out );
		$_group=new Core_Files_Group();
		if ( !empty( $_GET['dublicate'] ) ) {
			$this->objStore->set( array( 'msg'=>($_group->duplicate( $_GET['dublicate'] ))?'dub':'not_dub' ) );
			$this->location();
		}
		if ( !empty( $_POST['arrGroups'] ) ) {
			if ( $_group->setEntered( $_POST['arrGroups'] )->setMass() ) {
				$this->location( array( 'action' => 'groups_manager', 'wg' =>true ) );
			}
			$_group
				->getErrors( $this->out['arrErr'] )
				->getEntered( $this->out['arrGroups'] );
		}else{
			if ( $_GET['flg_utilization'] ) {
				$_group->onlyDeleted();
			}
			$_group
				->withOrder( @$_GET['order'] )
				->withPaging( array(
					'page'=>@$_GET['page'], 
					'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
					'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
				) )
				->getList( $this->out['arrGroups'] )
				->getPaging( $this->out['arrPg'] )
				->getFilter( $this->out['arrFilter'] );
		}
	}

	public function files_manager(){
		$this->objStore->getAndClear( $this->out );
		$_GET['sysname']=$this->params['sysname']?$this->params['sysname']:$_GET['sysname']; // для бэкэнда передается sysname через get, чтобы не плодить action для каждой группы в files, а action добавления в бэкэнде через params
		if (empty( $_GET['sysname'] )) {
			$this->location( array( 'action' => 'groups_manager' ));
		}
		$this->params['set_action']=isSet($this->params['set_action'])?$this->params['set_action']:$this->params['action'];
		$this->params['set_name']=isSet($this->params['set_name'])?$this->params['set_name']:$this->params['name']; // это для того, чтобы работала фильтрация для всех action
		// в ожидании доработки Core File Groups для утилизированных групп
		$_file=new Core_Files_Info( @$_GET['sysname'] );
		if( isset($_POST['arrFiles']) ){
			$_file->setMode( Core_Files_Info::$mode['onlyDataEdit'] )->setEntered( $_POST['arrFiles'] )->setMass();
		}
		if ( $_GET['flg_type'] ) {
			$_file->setMediaType( @$_GET['flg_type'] );
		}
		if ( $_GET['flg_utilization']==1 ) {
			$_file->onlyDeleted();
		}
		if ( $_GET['file_id'] ) {
			$_file->withIds( array( intval( @$_GET['file_id'] ) )  );
		}
		$_file
			->withOrder( @$_GET['order'] )
			->setSharing( @$_GET['flg_utilization'] )
			->withModerate( @$_GET['flg_moderate'] )
		//	->setTitle( @$_GET['file_title'] )
			->withPaging( array(
				'page'=>@$_GET['page'],
				'url'=>@$_GET,
			) )->getList( $this->out['arrFiles'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function file_info(){
		if ( empty( $_GET['id'] ) ) {
			return false;
		}
		$_file=new Core_Files_Info();
		$_file
			->withIds( $_GET['id'] )
			->onlyOne()
			->get( $this->out['file'] );
	}

	public function show_group(){
		$_strName='Project_Files_'.$this->params['prefix'];
		$_file=new $_strName( $this->params['sysname'] );
		$_file
			->withOrder( @$_GET['order'] )
			->withPaging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function edit_group(){
		$_strName='Project_Files_'.$this->params['prefix'];
		$_file=new $_strName( $this->params['sysname'] );
		if ( !empty( $_GET['delete'] ) ) {
			$_file->onlyOwner()->withIds( $_GET['delete'] )->utilization();
		}
		$_file
			->withOrder( @$_GET['order'] )
			->withPaging( array(
				'page'=>@$_GET['page'], 
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function upload_file(){
		$this->objStore->getAndClear( $this->out );
		if ( empty( $this->params['sysname'] )||empty( $this->params['prefix'] ) ) {
			return false;
		}
		$_strName='Project_Files_'.$this->params['prefix'];
		$_file=new $_strName( $this->params['sysname'] );
		if ( !empty( $_FILES['name'] ) || !empty( $_POST['file']['id'] ) ) {
			if ( $_file->setEntered( $_POST['file'] )->setEnteredFile( $_FILES['name'] )->set()){
				$this->objStore->set( array( 'msg'=>empty($_POST['file']['id'])?'saved':'edited' ) );
				$this->location( Core_Module_Router::$uriFull );
			}
			$_file
				->getErrors($this->out['arrErrors'])
				->getEntered( $this->out['file'] );
		}
		if ( !empty( $_GET['id'] ) ) {
			$_file->withIds( $_GET['id'] )->get( $this->out['file'] );
		}
	}

	public function view_file(){
		if ( !empty( $this->params['file_id'] ) ) { // для site1_hiam показывать файл по сохраненному id
			$_strName='Project_Files_'.$this->params['prefix'];
			$_file=new $_strName();
			$_file->withIds( $this->params['file_id'] )->onlyOne()->get( $this->out['file'] );
		}
	}
}
?>