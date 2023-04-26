<?php
class site1_automations extends Core_Module {

	public function set_cfg(){
		$this->inst_script=array(
			'module'=>array(
				'title'=>'CNM Automations',
			),
			'actions'=>array(
				array( 'action'=>'frontend_set', 'title'=>'Create Automation', 'flg_tree'=>1 ),
				array( 'action'=>'frontend_manage', 'title'=>'Manage Automations', 'flg_tree'=>1 ),
				array( 'action'=>'frontend_report', 'title'=>'Report', 'flg_tree'=>1 ),
				array( 'action'=>'widget', 'title'=>'Widget action', 'flg_tpl'=>1, 'flg_tree'=>1 ),
			),
		);
	}

	public function frontend_set(){
		$_model=new Project_Automation();
		if( isset( $_POST['arrData'] ) ){
			if( $_model->setEntered( $_POST['arrData'])->set() ){
				$this->objStore->toAction( 'frontend_manage' )->set( array( 'msg'=>(!empty($_GET['id']))?'saved':'created' ) );
				$this->location( array( 'action' => 'frontend_manage' ) );
			}
			$_model->getErrors($this->out['arrErrors']);
			$_model->getEntered( $this->out['arrData'] );
		}
		if(!empty($_GET['id'])){
			$_model->onlyOwner()->withIds($_GET['id'])->onlyOne()->getList($this->out['arrData']);
			if(is_array($this->out['arrData']['events'])){
				$_tmpArrayEvents = $this->out['arrData']['events'];
				$_tmpKeyEvents = array();
				foreach($_tmpArrayEvents as $event){
					$_tmpKeyEvents[] = $event['event_type'];
				}
				$_tmpArrayEvents = array_combine($_tmpKeyEvents, $_tmpArrayEvents);
				$this->out['arrData']['events'] = $_tmpArrayEvents;
			}
			if(is_array($this->out['arrData']['actions'])){
				$_tmpArrayActions = $this->out['arrData']['actions'];
				$_tmpKeyActions = array();
				foreach($_tmpArrayActions as $event){
					$_tmpKeyActions[] = $event['action_type'];
				}
				$_tmpArrayActions = array_combine($_tmpKeyActions, $_tmpArrayActions);
				$this->out['arrData']['actions'] = $_tmpArrayActions;
			}
			if(is_array($this->out['arrData']['filters'])){
				$_tmpArrayFilters = array();
				foreach ($this->out['arrData']['filters'] as $key => $value) {
					$_tmpArrayFilters[$value['filter_type']][] = $value;
				}
				$this->out['arrData']['filters'] = $_tmpArrayFilters;
			}
		}
		$_efunnel=new Project_Efunnel();
		$_efunnel
			->onlyOwner()
			->getList($this->out['arrEfunnels']);
		$_lchannel=new Project_Mooptin();
		$_lchannel
			->onlyOwner()
			->getList( $this->out['arrLeadChannels'] );
		$_model
			->onlyOwner()
			->onlyCount()
			->getList( $this->out['intAutomationsCount'] );

		// List of membership
		$membership = new Project_Deliver_Membership();
		$membership
			->onlyOwner()
			->getList( $this->out['arrMemberships'] );

		$membership
			->onlyOwner()
			->onlyPay()
			->getList( $this->out['arrPayMemberships'] );
	}

	public function frontend_manage(){
		$this->objStore->getAndClear($this->out);

		$_model = new Project_Automation();

		if (!empty($_GET['delete'])) {
			$this->objStore->set(['msg' => ($_model->withIds([$_GET['delete']])->del()) ? 'delete' : 'delete_error']);
			$this->location(['action' => 'frontend_manage']);
		}

		if (!empty($_GET['dublicate'])) {
			$_model->duplicate($_GET['dublicate']);
			$this->location(['action' => 'frontend_manage']);
		}

		$_model
			->onlyOwner()
			->withPaging([
				'page'        => @$_GET['page'],
				'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
			])
			->withOrder(@$_GET['order'])
			->getList($this->out['arrList'])
			->getPaging($this->out['arrPg']);

		$_model
			->onlyOwner()
			->onlyCount()
			->getList($this->out['intAutomationsCount']);

		$this->out['arrListCounter'] = Project_Automation::getListCounter(array_column($this->out['arrList'], 'id'));
	}

	public function frontend_report(){
		if( isset( $_GET['id'] ) ){
			$_model=new Project_Automation_Subscribers(Core_Users::$info['id']);
			$_model
				->withAutoId( $_GET['id'] )
				->onlyEmails()
				->getList( $this->out['arrEmails'] );
		}
	}

	public function widget(){
		header( 'Access-Control-Allow-Origin: *' );
		header( 'Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept' );
		$this->out['strHost']=Zend_Registry::get( 'config' )->domain->url.'/automations/widget/';
		if( isset( $_SERVER['HTTP_HOST'] ) && $_SERVER['HTTP_HOST'] == 'cnm.local' ){
			$this->out['strHost']='http://cnm.local/automations/widget/';
		}
		if( isset( $_GET['action'] ) && $_GET['action'] == 'iframe' 
			&& isset( $_GET['c'] ) && !empty( $_GET['c'] )
			&& isset( $_COOKIE['emials'] ) && is_array( $_COOKIE['emials'] ) && !empty( $_COOKIE['emials'] )
		){
			$_codedId=Project_Coder::encode( $_GET['c'] );
			$_model=new Project_Automation();
			$_model->withIds($_codedId)->onlyOne()->getList($_arrData);
			if( !$_arrData ){
				exit;
			}
			// есть такой action
		}
	}
}
?>