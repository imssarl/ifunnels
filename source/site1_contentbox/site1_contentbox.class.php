<?php
class site1_contentbox extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Content Box', ),
			'actions'=>array(
				array( 'action'=>'create', 'title'=>'Create', 'flg_tree'=>1,'flg_tpl'=>1 ),
				array( 'action'=>'manage', 'title'=>'Manage', 'flg_tree'=>1 ),
				array( 'action'=>'view', 'title'=>'ViewJs', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				
				array( 'action'=>'templates2groups', 'title'=>'Templates Access' ),
				// pop-ups
				array( 'action'=>'images', 'title'=>'Images Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'lead_channels', 'title'=>'Lead channels Popup', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'generate_lead_channels', 'title'=>'Generate Lead Channels', 'flg_tpl'=>3, 'flg_tree'=>2 ),
			),
		);
	}

	public function templates2groups(){
		if ( !empty( $_POST['change_group'] ) ) {
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrG'] );
		$_t2g=new Project_Contentbox_Templates();
		if(!empty($_GET['group_id'])){
			$_t2g->withGroupIds( $_GET['group_id'] )->getList( $_selectedTemplates );
		}
		$this->out['selectedTemplates']=array();
		foreach( $_selectedTemplates as $_template ){
			$this->out['selectedTemplates'][]=$_template['cbox_id'];
		}
		if(isset($_POST['save'])){
			$_arrData=array();
			$_t2g->withGroupIds( $_POST['arrR']['group_id'] )->del();
			foreach( $_POST['arrT'] as $_t ){
				$_arrData[]=array(
					'cbox_id'=> $_t, 
					'group_id'=> $_POST['arrR']['group_id']
				);
			}
			$_t2g->setEntered( $_arrData )->set();
			$this->location( array( 'w'=>'group_id='.$_POST['arrR']['group_id'] ) );
		}
		$_squeeze=new Project_Contentbox();
		$_squeeze->onlyTemplates()->getList( $this->out['arrTemplates'] );
	}

	public function create(){
		if( isset( $_POST['action'] ) ){
			if( $_POST['action'] == 'parse_form' && isset( $_POST['data'] ) ){
				echo Project_Contentbox::parseForm( $_POST['data'] );
				exit;
			}
			if( $_POST['action'] == 'show_form_settings' && isset( $_POST['data'] ) ){
				echo Project_Contentbox::editFormValues( $_POST['data'] );
				exit;
			}
			if( $_POST['action'] == 'show_form' && isset( $_POST['data'] ) ){
				echo Project_Contentbox::updateForm( $_POST['data']['form'], $_POST['data']['options'] );
				exit;
			}
			// другие экшны
		}
		$_model=new Project_Contentbox();
		if( isset( $_POST['create_cb'] ) ){
			if( $_model->setEntered(array( 'settings'=>$_POST['arrSettings'], 'id'=>@$_POST['arrData']['id'], 'name'=>@$_POST['arrData']['name'], 'flg_template'=>@$_POST['arrData']['flg_template'] ))->set() ){
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'create' ) );
				$this->location( array( 'action' => 'manage' ) );
			}else{
				$_model->getErrors( $this->out['error'] );
			}
		}
		if( isset( $_GET['id'] ) ){
			$_model->withIds( $_GET['id'] )->get( $this->out['arrData'] );
		}
		$_t2g=new Project_Contentbox_Templates();
		$_arrGroupsids=array();
		$_group=new Core_Acs_Groups();
		if( Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_group->getList( $_arrCurrentGroups );
		}else{
			$_group->bySysName( Core_Users::$info['groups'] )->getList( $_arrCurrentGroups );
		}
		foreach( $_arrCurrentGroups as $_i ){
			$this->out['arrGroupsids'][$_i['id']]=$_i['title'];
		}
		if( !Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_t2g->withGroupIds( array_keys( $this->out['arrGroupsids'] ) )->getList( $_selectedTemplatesIds );
		}
		if( !empty( $_selectedTemplatesIds ) ){
			$_squeezeT2G=array();
			foreach( $_selectedTemplatesIds as $_t2g_ids ){
				if( !isset( $_squeezeT2G[$_t2g_ids['cbox_id']] ) ){
					$_squeezeT2G[$_t2g_ids['cbox_id']]=array();
				}
				$_squeezeT2G[$_t2g_ids['cbox_id']][]=$_t2g_ids['group_id'];
			}
			$_model->withIds( array_keys( $_squeezeT2G ) )->onlyTemplates()->getList( $this->out['arrTemplList'] );
		}elseif( Core_Acs::haveAccess( array( 'LPB Admins' ) ) ){
			$_model->onlyTemplates()->getList( $this->out['arrTemplList'] );
		}else{
			$this->out['arrTemplList']=null;
		}
	}
	
	public function images(){
		//		$this->out['arrList']=Project_Contentbox::getBackgrounds();
	}

	public function lead_channels(){
		$this->objStore->getAndClear( $this->out );
		$company = new Project_Mooptin();
		$company
			->onlyOwner()
			->getList( $this->out['arrList'] );
	}

	public function generate_lead_channels(){
		if(empty($_POST)) return;
		$this->objStore->getAndClear( $this->out );
		$_mooptin = new Project_Mooptin();
		$_mooptin->withIds( $_POST['id'] )->onlyOne()->getList( $_arrMoData );
		$this->out=str_replace("\n", '', str_replace("\r\n", '', Project_Mooptin::generateForm( $_arrMoData['settings']['optin_form'], $_arrMoData['settings']['form'], $_arrMoData['id'] )) );
	}
	
	public function view(){
		if( isset( $_GET['id'] ) ){
			$_model=new Project_Contentbox();
			$_model->withIds( array( Project_Contentbox::regenerateId(  $_GET['id'] ) ) )->get( $this->out['arrBoxes'] );
			$this->out['codedData']=base64_encode(json_encode(array_values($this->out['arrBoxes']['settings'])));
			$this->out['host']='//'.Zend_Registry::get( 'config' )->engine->project_domain;
			if( isset( $_GET['local_data'] ) ){
				$this->out['flgLocal']=true;
			}
		}
	}
	
	public function manage(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Contentbox();
		if( isset( $_GET['import_id'] ) ){
			$_id=Project_Widget_Mutator::decode( $_GET['import_id'] );
			if( $_model->setEntered(array( 'settings'=>$_POST['arrSettings'], 'id'=>@$_POST['arrData']['id'], 'name'=>@$_POST['arrData']['name'] ))->set() ){
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'create' ) );
				$this->location( array( 'action' => 'manage' ) );
			}else{
				$_model->getErrors( $this->out['error'] );
			}
		}
		if( !empty($_GET['delete']) ){
			$_model->onlyOwner()->withIds( array( $_GET['delete'] ) )->del();
			$this->objStore->set( array( 'msg'=>'delete' ) );
			$this->location();
		}
		$_model
			->onlyOwner()
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$_host='//'.Zend_Registry::get( 'config' )->engine->project_domain;
		foreach( $this->out['arrList'] as &$_data ){
			$_data['jscode']=htmlspecialchars( '<script type="text/javascript" src="'.$_host.Core_Module_Router::getCurrentUrl( array('name'=>'site1_contentbox','action'=>'view') ).'?id='.Project_Contentbox::generateId( $_data['id'] ).'"></script>' );
		}
	}
	
	public function select(){
		$this->out['elementsName']=empty( $this->params['elementsName'] ) ? 'contentboxId':$this->params['elementsName'];
		$_popup=new Project_Contentbox();
		$_popup
			->onlyOwner()
			->getList( $this->out['arrayContentbox'] );
	}
	
}
?>