<?php
class api extends Core_Module {

	public final function set_cfg(){
		$this->inst_script=array(
			'module'=>array(
				'title'=>'Member API',
			),
			'actions'=>array(
				array( 'action'=>'use_action', 'title'=>'Use API actions', 'flg_tree'=>1,'flg_tpl'=>1 ),
				array( 'action'=>'statistic', 'title'=>'API Statistic' ),
				array( 'action'=>'groups_list', 'title'=>'Groups List' ),
			),
		);
	}
	
	public function groups_list(){
		$_groups=new Core_Acs_Groups();
		$_groups
			->getList( $this->out['arrList'] );
	}
	
	public function statistic(){
		$_model=new Project_Statistics_Api();
		$_model
			->withStatisticByIp()
			->withStatisticByReferer()
			->withFilter($_GET['arrFilter'])
			->withPaging( array( 'url'=>$_GET ) )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		foreach( $this->out['arrList'] as &$_data ){
			$_data['unserialized_request']=unserialize($_data['request']);
		}
	}
	
	public function use_action(){
		Core_Errors::off();
//		header('Content-Type: application/json');
		Project_Statistics_Api::add();
		if( isset(  $_REQUEST['purchase_code'] ) ){
			$_purchaseCode=base64_decode( $_REQUEST['purchase_code'] );
			$_users=new Project_Users_Management();
			$_users->withActivationCode( $_purchaseCode )->getList( $_arrUsers );
			if( isset( $_REQUEST['site_url'] ) && $_REQUEST['action']=='activate' && isset( $_arrUsers[0]['id'] ) ){
				if( count( $_arrUsers ) > 0 ){
					echo json_encode( array( 'action'=>'activated', 'code'=>'WyxSRQPONonVU1edcba9JIHGw0&$#;!?>87654MLTFEDCBAzmlkjihgfvutsrqpZYX32K <' ) );
				}else{
					echo json_encode( array('error'=>'object', 'error_description'=>'No connection to host!') );
				}
			}
			if( isset( $_REQUEST['action'] ) && $_REQUEST['action']=='get_list' && isset( $_arrUsers[0]['id'] ) ){
				$_oldUser=null;
				if( isset( Core_Users::$info['id'] ) ){
					$_oldUser=Core_Users::$info['id'];
				}
				Core_Users::getInstance()->setById( $_arrUsers[0]['id'] );
				$model=new Project_Sites( Project_Sites::NCSB );
				$model
					->withCategory( 'Zonterest' ) // 641
					->getList( $_arrList );
				if( $_oldUser != null ){
					Core_Users::getInstance()->setById( $_oldUser );
				}
				$_return=array();
				foreach( $_arrList as $_site ){
					$_return[]=array(
						'title'=>$_site['main_keyword'],
						'url'=>$_site['url']
					);
				}
				if( count( $_return ) > 0 ){
					echo json_encode( array('links'=>$_return ) );
				}
			}
			if( isset( $_REQUEST['action'] ) && $_REQUEST['action']=='check_update' || $_REQUEST['action']=='plugin_information' ){
				$response=new stdClass;
				$_name=$_REQUEST['name'];
				$downloadCounterFileName="./".$_name."/dowload.txt";
				try{
					$infoFilePosition='./'.$_name.'/info.txt';
					$downloadsCounterFile='./'.$_name.'/downloads.txt';
					$pluginFilePosition='./'.$_name.'/'.$_name.'.zip';
					$infoValues=array(
						'new version'=>'0.0.2',
						'slug'=>'Zonterest Manager',
						'requires'=>'4.9',
						'tested'=>'4.9.1',
						'rating'=>'100.0',
						'homepage'=>'http://cnm.local/zonterest-manager',
						'description'=>'Zonterest Manager your WordPress site securely and easily.',
						'changelog'=>'<h3>0.0.2</h3><ul><li>Fixed bugs in the cloning functional</li></ul><h3>0.0.3</h3><ul><li></li><ul>'
					);
					$response->slug=@$infoValues['slug'];
					$_stdClass=unserialize($_REQUEST['request']);
					if( isset( $_stdClass->version ) && $_stdClass->version==@$infoValues['new version'] ){
						die();
					}
					switch( $_REQUEST['action'] ) {
						case 'check_update':// API is asked for the existence of a new version of the plugin
							$response->url=@$infoValues['homepage'];
							$response->package="http://cnm.local/plugins/".'download.php?name='.$_name;
							$response->new_version=@$infoValues['new version'];
							break;
						case 'check_update':// API is asked for the existence of a new version of the plugin
							$response->url=@$infoValues['homepage'];
							$response->package="http://cnm.local/plugins/".'download.php?name='.$_name;
							$response->new_version=@$infoValues['new version'];
							break;
						case 'plugin_information':// Request for detailed information
							$response->name=$_name;
							$response->rating=100.0; //just for fun, gives us a 5-star rating :)
							$counter=0;
							if( file_exists( $downloadCounterFileName ) ){
								$file=fopen( $downloadCounterFileName, "r" );
								$counter=fread( $file, filesize($downloadCounterFileName) );
								fclose( $file );
							}else{
								$counter=0;
							}
							$response->requires=@$infoValues['requires'];
							$response->tested=@$infoValues['tested'];
							$response->num_ratings=$counter; //just for fun, a lot of people rated it :)
							$response->downloaded=$counter; //just for fun, a lot of people downloaded it :)
							$response->last_updated=@date("Y-m-d", @filemtime( $infoFilePosition ) );
							$response->added=@date("Y-m-d", @filemtime( $pluginFilePosition ) );
							$response->homepage=@$infoValues['homepage'];
							$response->sections=array(
								'description'=>@$infoValues['description'],
								'changelog'=>@$infoValues['changelog'],
							);
							$response->download_link="http://getbusinessblog.com/api/plugins/".'download.php?name='.$_name;
							break;
					}
				}catch(Exception $e) {
					echo serialize( $response );
				}
				echo serialize( $response );
			}
			exit;
		}
		if( !isset($_REQUEST['action']) 
			|| (  !isset( $_REQUEST['email'] ) || empty( $_REQUEST['email'] ) )
		//	|| !isset( $_REQUEST['member_id'] ) || empty( $_REQUEST['member_id'] ) 
		//	|| Project_Statistics_Api::checkRequestsLimit()
		){
			exit;
		}
		switch( $_REQUEST['action'] ){
			case "member_add":
				$letters="qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!#?@$%^&*()";
				$numbers="1234567890";
				$_users=new Project_Users_Management();
				$_arrData=array(
					'mm_id'=>@$_REQUEST['member_id'],
					'nickname'=>@$_REQUEST['username'],
					'buyer_name'=>@$_REQUEST['first_name'],
					'buyer_surname'=>@$_REQUEST['last_name'],
					'phone'=>@$_REQUEST['phone'],
					'buyer_phone'=>( isset( $_REQUEST['phone'] ) ? '+'.preg_replace("/[^0-9]/","", @$_REQUEST['phone']) : '' ),
					'buyer_address'=>@$_REQUEST['billing_address'],
					'buyer_country'=>@$_REQUEST['billing_country'],
					'buyer_zip'=>@$_REQUEST['billing_zip_code'],
					'buyer_province'=>@$_REQUEST['billing_state'],
					'buyer_city'=>@$_REQUEST['billing_city'],
					'code_confirm'=>mt_rand( 100000, 999999 ),
					'flg_phone'=>0
				);
				$_isMail=false;$_newAccount=true;
				sleep( 5 );
				if( $_users->withEmail( $_REQUEST['email'] )->getList( $arrProfileExists )->checkEmpty() ){
					$_arrData=array_merge( array_diff( $_arrData, array( '', null ) ), array_diff( $arrProfileExists[0], array( '', null ) ) );
					$_newAccount=false;
				}else{
					$password=Core_Users::generatePassword();
					$_arrData=array_merge( $_arrData, array(
						'email'=>$_REQUEST['email'],
						'passwd'=>$password,
						'password'=>$password,
						'pagging_links'=>5,
						'pagging_rows'=>10,
						'popup_width'=>70,
						'popup_height'=>70,
						'lang'=>'en',
						'timezone'=>'UTC',
						'flg_unsubscribe'=>0,
						'flg_sended'=>0,
						'expiry'=>0,
						'flg_expiry'=>0,
						'flg_active'=>1,
						'flg_maintenance'=>0,
						'flg_confirm'=>1,
						'flg_approve'=>1
					) );
					$_users->setEntered( $_arrData )->set();
					$_users->getEntered( $_arrData );
					$_isMail=true;
				}
				unset( $_arrData['passwd'] );
				unset( $_arrData['edited'] );
				$_arrGroups=@explode(',', @$_REQUEST['groups'] );
				if( empty( $_arrGroups ) ){
					$_arrGroups=array( 15 );
				}else{
					$_arrGroups[]=15;
				}
				$_groups=new Core_Acs_Groups();
				$_groups->withIds( $_arrData['id'] )->getGroupByUserId( $arrHaveGroups ); // странно но это список групп по id пользователя	
				if( !empty( $arrHaveGroups ) ){
					foreach( $arrHaveGroups as $_groupId=>$_updateGroup ){
						if( !in_array( $_groupId, $_arrGroups ) ){
							$_arrGroups[]=$_groupId;
							$_isMail=true;
						}
					}
				}
				$_groups->withIds( $_arrGroups )->getList( $arrGroups ); // это список групп по ids групп
				$_arrGroupsNames=$_arrGroupsSysNames=array();
				foreach( $arrGroups as $_gr ){
					$_arrGroupsNames[]=$_gr['title'];
					$_arrGroupsSysNames[]=$_gr['sys_name'];
				}
				if( isset( $_REQUEST['zonterest_limit'] ) ){
					if( $_REQUEST['zonterest_limit']=='unlim' ){
						$_REQUEST['zonterest_limit']=-1;
					}
					$_arrData['zonterest_limit']=$_REQUEST['zonterest_limit'];
				}
				if( isset( $_REQUEST['automation_limit'] ) ){
					$_arrData['automation_limit']=$_REQUEST['automation_limit'];
				}
				if( isset( $_REQUEST['contact_limit'] ) ){
					$_arrData['contact_limit']=$_REQUEST['contact_limit'];
				}
				if( isset( $_REQUEST['subaccounts_limit'] ) ){
					$_arrData['subaccounts_limit']=$_REQUEST['subaccounts_limit'];
				}
				if( isset( $_REQUEST['hosting_limit'] ) ){
					$_arrData['hosting_limit']=$_REQUEST['hosting_limit'];
				}
				if( $_arrData['hosting_limit'] == 'cancel' && !empty( $_arrData['id'] ) ){
					$_arrData['hosting_limit']=0;
					$_placement=new Project_Placement();
					$_placement
						->withUserId( $_arrData['id'] )
						->onlyLimitedHosting()
						->getList( $arrRes );
					foreach( $arrRes as $_item ){
						$_placement->withIds( $_item['id'] )->del();
					}
				}
				$_groups->withIds( @explode(',', @$_REQUEST['groups'] ) )->getList( $_userAddedGroup );
				if( $_users->setEntered( $_arrData )->withGroups( $_arrGroupsSysNames )->set() ){
					$_users->getEntered( $_arrData );
					if( isset( $_REQUEST['credit'] ) ){
						$_purse=new Core_Payment_Purse();
						$_purse
							->setType( Core_Payment_Purse::TYPE_REWARD_SITES )
							->setAmount( $_REQUEST['credit'] )
							->setMessage( "Added through API" )
							->setUserId( $_arrData['id'] )
							->receipts();
					}elseif( isset( $_REQUEST['payment'] ) ){
						$_purse=new Core_Payment_Purse();
						$_purse
							->setType( Core_Payment_Purse::TYPE_REWARD_SITES )
							->setAmount( $_REQUEST['payment'] )
							->setMessage( "Deleted through API" )
							->setUserId( $_arrData['id'] )
							->expenditure();
					}
					if( isset( $_REQUEST['traffic_credits'] ) ){
						Project_Traffic::addCredits( 0, $_REQUEST['traffic_credits'], $_arrData['id'] );
					}
					if( isset( $_REQUEST['lpb_limits'] ) ){
						Project_Squeeze::sendRestrictions( $_REQUEST['lpb_limits'], ( isset( $_REQUEST['lpb_limits_type'] )?(bool)$_REQUEST['lpb_limits_type']:0 ), $_arrData['id'] );
					}
					$_users->withIds( $_arrData['id'] )->activate();
					if( $_isMail ){
						$_affiliate = false;
						$_user=new Core_Users_Management();
						$_user->setCode( $_arrData, 'code_forgot' );
						$_arrMail=array();
						$_arrMail['email']=$_REQUEST['email'];
						$_arrMail['buyer_name']=$_arrData['buyer_name'];
						$_arrMail['buyer_surname']=$_arrData['buyer_surname'];
						$_arrMail['code_forgot'] = $_arrData['code_forgot'];
						foreach ($_userAddedGroup as $key => $group) {
							if( $group['title'] != 'Default' )
								$_arrMail['moduls'][] = $group['title'];
							if( in_array( $group['title'], array( 'Affiliate Funnels Starter', 'Affiliate Funnels Free' ) ) )
								$_affiliate = true;
						}
						$_arrMail['moduls']=implode( ', ', $_arrMail['moduls'] );
						$_arrMail['password']=$password;
						try{
							if( $_newAccount ){
								$_subject = 'Your Lead Pro Systems Account Has Been Created';
							} else {
								$_subject = 'Your Account Has Been Updated';
							}
							if( $_affiliate ) {
								$_subject = 'Your Affiliate Funnels Account Has Been Created';
							}
							$_mailer=new Core_Mailer();
							$_mailer
								->setVariables( $_arrMail )
								->setTemplate( ( !$_affiliate ? 'api_registration_complete' : 'affiliatefunnels_complete' ) )
								->setSubject( $_subject )
								->setPeopleTo( array( 'email'=>$_arrMail['email'], 'name'=>$_arrData['nickname'] ) )
								->setPeopleFrom( array( 'name' => Zend_Registry::get('config')->engine->project_sysemail->name, 'email' => Zend_Registry::get('config')->engine->project_sysemail->email ) )
								->sendOneToMany();
						}catch(Exception $e){
							echo json_encode(array('error'=>$e));
							exit;
						}
					}
					echo 'true';
				}else{
					$_registration->getHeadError( $_error );
					echo json_encode(array('error'=>$_error));
				}
				break;
				
			case "member_delete":
				$_users=new Project_Users_Management();
				if( $_users->onlyOne()->withMemberMouseId( @$_REQUEST['member_id'] )->withEmail( $_REQUEST['email'] )->getList( $arrProfileExists )->checkEmpty() ){
					if( !isset( $_REQUEST['groups'] ) ){
						$_users->withIds( $arrProfileExists['id'] )->del();
					} else {
						if( empty( @$_REQUEST['groups'] ) ){
							echo json_encode(array('error'=>'empty groups'));
							exit;
						}
						$_groups=new Core_Acs_Groups();
						$_groups->withIds( $arrProfileExists['id'] )->getGroupByUserId( $arrHaveGroups ); // странно но это список групп по id пользователя	
						$_arrGroups=@explode(',', @$_REQUEST['groups'] );
						foreach ( $_arrGroups as $group ) {
							unSet( $arrHaveGroups[$group] );
						}
						if( isset( $_REQUEST['zonterest_limit'] ) ){
							if( $_REQUEST['zonterest_limit']=='unlim' ){
								$_REQUEST['zonterest_limit']=-1;
							}
							$_arrData['zonterest_limit']=$_REQUEST['zonterest_limit'];
						}
						if( isset( $_REQUEST['hosting_limit'] ) ){
							$_arrData['hosting_limit']=$_REQUEST['hosting_limit'];
						}
						if( $_arrData['hosting_limit'] == 'cancel' && !empty( $_arrData['id'] ) ){
							$_arrData['hosting_limit']=0;
							$_placement=new Project_Placement();
							$_placement
								->withUserId( $_arrData['id'] )
								->onlyLimitedHosting()
								->getList( $arrRes );
							foreach( $arrRes as $_item ){
								$_placement->withIds( $_item['id'] )->del();
							}
						}
						unset( $arrProfileExists['passwd'] );
						if( $_users->setEntered( $arrProfileExists )->withGroups( $arrHaveGroups )->set() ) {
							echo 'true';
						}
					}
				}
			break;
		}
		die();
	}
}
?>