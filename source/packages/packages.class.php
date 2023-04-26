<?php
/**
 * WorkHorse Framework
 *
 * @category WorkHorse
 * @package ProjectSource
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2012, Rodion Konnov
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 22.11.2011
 * @version 2.0
 */


/**
 * Packages administration
 *
 * @category WorkHorse
 * @package ProjectSource
 * @copyright Copyright (c) 2005-2012, Rodion Konnov
 * @license http://opensource.org/licenses/ MIT License
 */
class packages extends Core_Module {

	public final function set_cfg() {
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Packages',
			),
			'actions'=>array(
				array( 'action'=>'manage', 'title'=>'Packages' ),
				array( 'action'=>'settings', 'title'=>'Credit Settings' ),
				array( 'action'=>'set', 'title'=>'Add/Edit package' ),
				array( 'action'=>'bonus', 'title'=>'Bonus Credits' ),
				array( 'action'=>'stat', 'title'=>'Stats' ),
			),
		);
	}

	public function bonus(){
		$this->objStore->getAndClear( $this->out );
		$_service=new Core_Payment_Service();
		if( !empty($_POST['arrData']) && $_service->addBonus($_POST['arrData']['package_ids'],$_POST['arrData']['credits']) ){
			$this->objStore->toAction( 'bonus' )->set( array( 'msg'=>'added' ) );
			$this->location();
		}
		$_pack=new Core_Payment_Package();
		$_pack->onlyTariffPkg()->withHided()->getList( $this->out['arrPackages'] );
	}

	public function stat(){
		$_model=new Project_Statistics_Package();
		$_model->withFilter($_GET['arrFilter'])->getList( $this->out['arrStats'] );
		$_package=new Core_Payment_Package();
		$_package->onlyTariffPkg()->withHided()->getList( $this->out['arrPackages'] );
	}

	public function settings(){
		$_buns=new Core_Payment_Buns();
		if ( !empty( $_POST['arrData'] ) ) {
			if ( $_buns->setEntered( $_POST['arrData'] )->setMass() ) {
				$this->location();
			}
			$_buns->getErrors( $this->out['arrErr'] );
		}
		$_buns
			->withPaging( array( 'url'=>$_GET ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
	}

	public function manage() {
		$this->objStore->getAndClear( $this->out );
		$_package=new Core_Payment_Package();
		if(!empty($_GET['delete'])){
			if($_package->withIds( $_GET['delete'] )->del()){
				$this->location();
			}
		}
		$_package
			->withoutParams()
			->withHided()
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function set() {
		$_package=new Core_Payment_Package();
		$_fgroup=new Core_Files_Group();
		if(!$_fgroup->onlyOne()->withSysName('package_logo')->getList( $_tmp )->checkEmpty()){
			$_fgroup->setEntered(array('title'=>'Package Logo','sysname'=>'package_logo'))->set();
		}
		$_files=new Project_Files_Package('package_logo');
		if ( !empty( $_POST['arrData'] ) ) {
			if(!empty($_POST['del'])){
				$_files->withIds( $_POST['del'] )->utilization();
				$_POST['arrData']['image']=0;
			}
			if( !empty($_FILES['logo']['name']) ){
				if( !$_files->setEntered()
						->setEnteredFile( $_FILES['logo'] )
						->setMediaType(Core_Files_Info::$mediaType['images'])
						->set()){
					$this->location();
				}
				$_files->getEntered( $_image );
				$_POST['arrData']['image']=$_image['id'];
			}
			if ( $_package->setEntered( $_POST['arrData'] )->set() ) {
				$this->objStore->toAction( 'manage' )->set( array( 'msg'=>'saved' ) );
				$this->location( array( 'action'=>'manage' ) );
			}
			$_package
				->getErrors( $this->out['arrErrors'] )
				->getEntered( $this->out['arrData'] );
		} elseif( $_GET['id'] ) {
			$_package
				->withHided()
				->editMode()
				->withoutParams()
				->withIds( $_GET['id'] )
				->onlyOne()
				->getList( $this->out['arrData'] );
			if(!empty($this->out['arrData']['image'])){
				$_files->withIds( $this->out['arrData']['image'] )->onlyOne()->getList( $this->out['arrData']['image'] );
			}
		}
		$_groups=new Core_Acs_Groups();
		$_groups->toSelect()->getList( $this->out['arrGroups'] );
		$_package
			->onlyTariffPkg()
			->toSelect()
			->getList( $this->out['arrTariffs'] );
	}
}
?>