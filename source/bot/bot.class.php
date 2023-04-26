<?php
class bot extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Bot API',
			),
			'actions'=>array(
				array( 'action'=>'create_action', 'title'=>'Bot Action' ),
				array( 'action'=>'manage_logic', 'title'=>'Bot Logic' ),
			),
		);
	}
	
	public function create_action(){
		$_model=new Project_Bot();
		if( isset($_GET['id']) && !empty( $_GET['id'] ) ){
			$_model
				->withIds( @$_GET['id'] )
				->onlyOne()
				->getList( $this->out['arrData'] );
		}
		if( !empty( $_POST ) ){
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				$this->objStore->toAction( 'manage_logic' )->set( array( 'msg'=>'added' ) );
				$this->location( array( 'action' => 'manage_logic' ) );
			}
			$_model
				->getEntered( $this->out['arrData'] )
				->getErrors( $this->out['arrErrors'] );
		}
		$_model->getList( $this->out['arrList'] );
	}
	
	public function manage_logic(){
		$_botAI=new Project_Bot();
		if ( !empty( $_GET['del'] ) && $_botAI->withIds($_GET['del'])->del() ) {
			$this->objStore->set( array( 'msg'=>'deleted' ) );
			$this->location( array( 'action'=>'manage_logic' ) );
		}
		$_botAI
			->getList( $this->out['arrList'] );
	}
}
?>