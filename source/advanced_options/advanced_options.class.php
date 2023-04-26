<?php
class advanced_options extends Core_Module
{
	private $_model;

	public function set_cfg() {
		$this->inst_script=array(
		'module'=>array( 'title'=>'Advanced Customization Options'),
		'actions'=>array(
					array( 'action'=>'ad', 'title'=>'Campaing Split ad', 'flg_tpl'=>1, 'flg_tree'=>1 ),
					array( 'action'=>'spots', 'title'=>'Spots', 'flg_tpl'=>1, 'flg_tree'=>1 ),
					),
		);

	}

	public function optinos(){ 
		$_model = new Project_Options( $this->params['site_type'], $this->params['site_data']['id'] );
		if (!empty($this->params['site_data']['id'])){
			$_model->get($this->out['arrOpt']);
		}
		if (!empty($_POST)){
			$this->out['arrOpt']=$_POST['arrOpt'];
		}
		$this->out['arrOpt']['flg_traking']=$this->params['site_data']['flg_traking'];
		$this->out['arrOpt']['traking_code']=$this->params['site_data']['traking_code'];
		$this->out['arrSpots']=$_model->getSpotStruct();
		$this->out['jsonOpt']=json_encode($this->out['arrOpt']);
	}

	/**
	 * Ajax Compaigns or Split
	 *
	 */
	public function ad(){
		$this->out['ids'] = $_POST['ids'];
		$this->out['flg_content'] = $_POST['flg_content'];
		if ( $_POST['flg_content'] == 2 ) {
			$_company = new Project_Widget_Adapter_Hiam_Campaign ();
			$_company
				->onlyOwner()
				->getList( $this->out['arrList'] );
		} else if ( $_POST['flg_content'] == 1 ) {
			$_splittest = new Project_Widget_Adapter_Hiam_Split ();
			$_splittest
				->onlyOwner()
				->getList( $this->out['arrList'] );
		}
	}

	/**
	 *  Ajax spots
	 *
	 */
	public function spots(){
		$_model = new Project_Options( $_POST['site_type'] );
		$this->out['ids'] = $_POST['ids'];
		$this->out['type'] = $_POST['type'];
		$this->out['spot_index'] = $_POST['spot_index'];
		if ( $_POST['type'] == Project_Options::ARTICLE ){
			$this->out['arrList']=$_model->getSavedSelection( $_POST['spot_id'] );
		}
		if ( $_POST['type'] == Project_Options::VIDEO ){
			$this->out['arr']=$_model->getVideo($_POST['spot_id'] );
		}
	}

}