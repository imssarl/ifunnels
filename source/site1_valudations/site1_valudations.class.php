<?php
/**
 * Organizer module
 *
 * @category CNM Project
 * @package ProjectSource
 */
class site1_valudations extends Core_Module {
	
	public function set_cfg(){
		$this->inst_script=array(
			'module' =>array( 'title'=>'CNM Validate', ),
			'actions'=>array(
				array( 'action'=>'buy_credits', 'title'=>'Buy Credits', 'flg_tree'=>1 ),
				array( 'action'=>'settings', 'title'=>'Settings', 'flg_tree'=>1 ),
				array( 'action'=>'verifications', 'title'=>'Verifications', 'flg_tree'=>1 ),
				array( 'action'=>'integrate', 'title'=>'Integrate', 'flg_tree'=>1 ),
				array( 'action'=>'subscribers', 'title'=>'Subscribers', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'widget', 'title'=>'Widget', 'flg_tpl'=>1, 'flg_tree'=>1 ),
				array( 'action'=>'request', 'title'=>'AJAX Request', 'flg_tpl'=>3, 'flg_tree'=>2 ),
			),
		);
	}

	public function settings(){
		if( !empty( $_POST ) ){
			if( isset( $_POST['arrData']['validation_realtime'] ) ){
				Project_Validations_Realtime::setValue( Project_Validations_Realtime::USER, Core_Users::$info['id'], $_POST['arrData']['validation_realtime'] );
			}
			if( isset( $_POST['arrData']['validation_mounthly'] ) ){
				Core_Sql::setExec('UPDATE u_users SET validation_mounthly='.$_POST['arrData']['validation_mounthly'].' WHERE id="'.Core_Users::$info['id'].'"');
			}
			if( isset( $_POST['arrData']['validation_global'] ) ){
				Core_Sql::setExec('UPDATE u_users SET validation_global='.$_POST['arrData']['validation_global'].' WHERE id="'.Core_Users::$info['id'].'"');
			}
			sleep( 3 );
			Core_Users::getInstance()->reload();
		}
	}

	public function buy_credits(){
		$this->out['amount']=Core_Payment_Purse::getAmount()*250+Core_Users::$info['validation_limit'];
	}

	public function verifications(){
		$this->objStore->getAndClear( $this->out );
		$_valid=new Project_Validations();
		if( isset( $_GET['up_id'] ) && !empty( $_GET['up_id'] ) ){
			$_valid->withChecker( $_GET['up_id'] )->onlyOne()->getList( $_dataChecker );
			$_dir='Project_Validator@statistic';
			if ( !Zend_Registry::get( 'objUser' )->prepareTmpDir( $_dir ) ){
				return Core_Data_Errors::getInstance()->setError('Can\'t create dir '.$_dir);
			}
			if( !isset( $_dataChecker['options']['zip']['url'] ) ){
				$_v=new Project_Validations();
				$_v->setEntered( array(
					'id'=>$_dataChecker['id'],
					'status'=>'0'
				) )->set();
				$this->location();
			}
			if( @copy( $_dataChecker['options']['zip']['url'], $_dir.$_GET['up_id'].'.zip' ) ){
				$zip=new ZipArchive(); 
				$zip->open( $_dir.$_GET['up_id'].'.zip' );
				$zip->deleteName( 'README.txt' );
				$zip->close();
				ob_end_clean();
				header( 'Content-type: application/octet-stream' );
				header( 'Content-disposition: attachment; filename=validate-list-'.$_GET['up_id'].'.zip');
				echo file_get_contents($_dir.$_GET['up_id'].'.zip');
				unlink( $_dir.$_GET['up_id'].'.zip' );
				die();
			}
		}
		
		if( isset( $_GET['save'] ) && !empty( $_GET['save'] ) ){
			$_valid->withIds( $_GET['save'] )->onlyOne()->getList( $_data );
			if( isset( $_data['options']['undeliverable'] ) || isset( $_data['options']['deliverable'] ) || isset( $_data['options']['risky'] ) ){
				try {
					Core_Sql::setConnectToServer( 'lpb.tracker' );
					$_time=time();
					$_arrEmails=array();
					foreach( $_data['options']['undeliverable'] as $updateTypes ){
						foreach( $updateTypes as $email ){
							$_arrEmails[]=$email;
						}
					}
					if( !empty( $_arrEmails ) ){
						Core_Sql::setExec( 'UPDATE s8rs_'.$_data['user_id'].' SET `status`="undeliverable", `status_data`="'.$_time.'" WHERE email IN ('.Core_Sql::fixInjection( $_arrEmails ).')' );
					}
					$_arrEmails=array();
					foreach( $_data['options']['risky'] as $updateTypes ){
						foreach( $updateTypes as $email ){
							$_arrEmails[]=$email;
						}
					}
					if( !empty( $_arrEmails ) ){
						Core_Sql::setExec( 'UPDATE s8rs_'.$_data['user_id'].' SET `status`="risky", `status_data`="'.$_time.'" WHERE email IN ('.Core_Sql::fixInjection( $_arrEmails ).')' );
					}
					$_arrEmails=array();
					foreach( $_data['options']['deliverable'] as $updateTypes ){
						foreach( $updateTypes as $email ){
							$_arrEmails[]=$email;
						}
					}
					if( !empty( $_arrEmails ) ){
						Core_Sql::setExec( 'UPDATE s8rs_'.$_data['user_id'].' SET `status`="deliverable", `status_data`="'.$_time.'" WHERE email IN ('.Core_Sql::fixInjection( $_arrEmails ).')' );
					}
					Core_Sql::renewalConnectFromCashe();
				} catch(Exception $e) {
					Core_Sql::renewalConnectFromCashe();
				}
			}
			$this->location();
		}
		
		if( isset( $_POST ) && !empty( $_POST ) ){
			$_return=array();
			if( isset( $_POST['email'] ) && !empty( $_POST['email'] ) ){
				$_valid->withName( $_POST['email'] )->onlyLast()->onlyOne()->getList( $_checked );
				if( (int)$_checked['added'] >= time()-24*60*60 ){
					$this->objStore->set( array( 'msg'=>'Recently checked. Status: '.$_checked['options']['result'] ) );
					$this->location();
				}
				if( !$_valid->getPayment(1) ){
					$_status=2;
				}
				$_obj=new Project_Thechecker();
				$_return=$_obj->checkOne( $_POST['email'] );
				if( !isset( $_return['message'] ) ){
					$_status=1;
					$_valid->setEntered( array(
						'name'=>$_POST['email'],
						'options'=>$_return,
						'status'=>$_status,
						'type'=>Project_Validations::SINGLE
					) )->set();
				}else{
					$this->objStore->set( array( 'error'=>$_return['message'] ) );
				}
				$this->location();
			}

			if (isset($_FILES['csv']) && !empty($_FILES['csv']) && $_FILES['csv']['error'] != 4) {
				$_obj    = new Project_Thechecker();
				$_return = $_obj->sendFile($_FILES['csv']);

				if (!isset($_return['message'])) {
					$_status = 0;

					if (!$_valid->getPayment($_return["status"]["total"])) {
						$_status = 2;
					}

					$_valid
						->setEntered(
							[
								'name'       => $_FILES['csv']['name'],
								'id_checker' => @$_return['id'],
								'options'    => $_return,
								'type'       => Project_Validations::FILE_LIST,
							]
						)
						->set();

				} else {
					$this->out['error'] = $_return['message'];
				}

				$this->location();
			}

			if( isset( $_POST['select'] ) && !empty( $_POST['select'] ) ){
				$_obj=new Project_Thechecker();
				$_arrEmails=explode( '|', $_POST['select'] );
				$_status=0;
				if( !$_valid->getPayment( count( $_arrEmails ) ) ){
					$_status=2;
					$_return=array( 'message'=>'Have no credits' );
				}else{
					$_return=$_obj->sendList($_arrEmails);
				}
				$_cnmOptions=array();
				if( isset( $_POST['remove'] ) ){
					$_cnmOptions['flg_remove']=true;
				}
				if( !isset( $_return['message'] ) ){
					$_valid->setEntered( array(
						'name'=>'Validation Project #'.@$_return['id'],
						'id_checker'=>@$_return['id'],
						'options'=>$_return+$_cnmOptions,
						'type'=>Project_Validations::CNM_LIST
					) )->set();
				}else{
					$this->out['error']=$_return['message'];
				}
				$this->location();
			}
		}
		$_valid
			->onlyOwner()
			//->withType( array( Project_Validations::SINGLE, Project_Validations::CNM_LIST, Project_Validations::FILE_LIST ) )
			->withPaging( array( 'url'=>$_GET ) )
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrLists'] )
			->getPaging( $this->out['arrPg'] )
			->getFilter( $this->out['arrFilter'] );
	}

	public function integrate(){
		$this->out['code'] = Core_Payment_Encode::encode( array( 'u'=>Core_Users::$info['id'], 't'=>time() ) );
		
	}
	
	public function subscribers(){
		$_subscribers=new Project_Subscribers(Core_Users::$info['id']);
		$_subscribers
			->getList( $this->out['arrList'] );
	}
	
	public function widget(){
		header( 'Access-Control-Allow-Origin: *' );
		header( 'Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept' );
		if( !isset( $_GET['code'] ) ){
			exit;
		}
		$_decode=Core_Payment_Encode::decode( $_GET['code'] );
		if( !isset( $_decode['u'] ) ){
			exit;
		}
		$this->out['code']=$_GET['code'];
	}
	
	public function request(){
		header( 'Access-Control-Allow-Origin: *' );
		header( 'Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept' );
		if( empty( $_POST ) ){
			$this->out_js=false;
			exit();
		}
		$_decode=Core_Payment_Encode::decode( $_POST['code'] );
		if( !isset( $_decode['u'] ) ){
			exit;
		}
		Core_Users::getInstance()->setById( $_decode['u'] );
		$_valid=new Project_Validations();
		$_valid->withName( $arrRequest['email'] )->onlyLast()->onlyOne()->getList( $_checked );
		if( (int)$_checked['added'] < time() - 24*60*60 ){
			$_status=3; // только что проверяли
		}
		if( $_status!=3 ){
			if( !$_valid->getPayment(1) ){
				$this->out_js='no credits';
			}else{
				$_obj=new Project_Thechecker();
				$_return=$_obj->checkOne( $_POST['email'] );
				if( !isset( $_return['message'] ) ){
					$_valid->setEntered( array(
						'user_id'=>$_decode['u'],
						'name'=>$_POST['email'],
						'options'=>$_return,
						'status'=>1,
						'type'=>Project_Validations::SINGLE
					) )->set();
					$this->out_js=$_return['result'];
				}else{
					$this->out_js=$_return['message'];
				}
			}
		}else{
			$this->out_js=$_checked['options']['message'];
		}
	}
}
?>