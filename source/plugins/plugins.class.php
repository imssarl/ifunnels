<?php
class plugins extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Plugins',
			),
			'actions'=>array(
				array( 'action'=>'add', 'title'=>'Add Plugin' ),
				array( 'action'=>'manage', 'title'=>'Plugins List' ),
			),
		);
	}
	
	public function add(){
		$this->objStore->getAndClear( $this->out );
		if(!empty($_FILES['plugin']['tmp_name'])){
			$_ext=Core_Files::getExtension( $_FILES['plugin']['name'] );
			$_flgUpload=false;
			if( in_array( $_ext, array("zip") )  ){
				$_flgUpload=Project_Plugins::upload($_FILES['plugin'], $_POST['arrData']);
				if( $_flgUpload === true ){
					$this->objStore->toAction( 'manage' )->set( array( 'upload'=>$_POST['arrData']['upload'] ) );
					$this->location( array( 'action' => 'manage' ) );
				}else{
					$this->out['arrData']=$_flgUpload['arrData'];
					$this->out['arrErrors']=$_flgUpload['arrErrors'];
				}
			}
		}
		if( isset($_GET['id']) && !empty( $_GET['id'] ) ){
			$_model
				->withIds( @$_GET['id'] )
				->onlyOne()
				->getList( $this->out['arrData'] );
		}
	}
	
	public function manage(){
		$_botAI=new Project_Plugins();
		if ( !empty( $_GET['del'] ) && $_botAI->withIds($_GET['del'])->del() ) {
			$this->objStore->set( array( 'msg'=>'deleted' ) );
			$this->location( array( 'action'=>'manage_logic' ) );
		}
		$_botAI
			->getList( $this->out['arrList'] );
	}
}
?>