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
 * CNM Accounts and general
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_accounts extends Core_Module {

	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM accounts and general', ),
			'actions'=>array(
				array( 'action'=>'logoff', 'title'=>'Logoff', 'flg_tpl'=>2, 'flg_tree'=>1 ),
				array( 'action'=>'tutorials', 'title'=>'Tutorials and How-To Videos', 'flg_tree'=>1 ),
				array( 'action'=>'player', 'title'=>'Webinar 2010-2', 'flg_tree'=>1 ),
				array( 'action'=>'traffic', 'title'=>'Traffic Generation Training', 'flg_tree'=>1 ),
				array( 'action'=>'settings', 'title'=>'User Settings', 'flg_tree'=>1 ),
				array( 'action'=>'register', 'title'=>'Register Site', 'flg_tree'=>1 ),
				array( 'action'=>'templates', 'title'=>'Manage Template', 'flg_tree'=>1 ),
				array( 'action'=>'history', 'title'=>'History', 'flg_tree'=>1 ),
				array( 'action'=>'copyprophet', 'title'=>'Copy Prophet', 'flg_tree'=>1 ),
				array( 'action'=>'copyprophet_ajax', 'title'=>'Copy Prophet Ajax', 'flg_tree'=>1,'flg_tpl'=>1 ),
				array( 'action'=>'save_menu_structure', 'title'=>'Save menu structure', 'flg_tree'=>1,'flg_tpl'=>1 ),
				
				array( 'action'=>'registration', 'title'=>'Registration', 'flg_tree'=>1 ),
				array( 'action'=>'membermouse', 'title'=>'Member Mouse API', 'flg_tree'=>1,'flg_tpl'=>1 ),
				
				array( 'action'=>'check', 'title'=>'Check email', 'flg_tree'=>1,'flg_tpl'=>3 ),
				array( 'action'=>'activate', 'title'=>'Account Activate', 'flg_tree'=>1 ),
				array( 'action'=>'change', 'title'=>'Change password', 'flg_tree'=>1 ),
				array( 'action'=>'terms', 'title'=>'Terms', 'flg_tree'=>1,'flg_tpl'=>1),
				array( 'action'=>'emailfunnelstutorials', 'title'=>'Email Funnels - Tutorials', 'flg_tree'=>1,'flg_tpl'=>1),
				array( 'action'=>'dpa', 'title'=>'Data Protection Agreement', 'flg_tree'=>1,'flg_tpl'=>1),
				array( 'action'=>'termspage', 'title'=>'Terms with header', 'flg_tree'=>1),
				array( 'action'=>'apppolicypage', 'title'=>'Privacy Policy App with header', 'flg_tree'=>1),
				array( 'action'=>'credits', 'title'=>'Purchase Credits', 'flg_tree'=>1),
				array( 'action'=>'conditions', 'title'=>'Conditions', 'flg_tree'=>1,'flg_tpl'=>1 ),
				
				array( 'action'=>'unsubscribe', 'title'=>'Unsubscribe', 'flg_tree'=>1 ),
				
				array( 'action'=>'confirmphone', 'title'=>'Confirm Phone', 'flg_tree'=>1, 'flg_tpl'=>1 ),
				array( 'action'=>'info', 'title'=>'Info', 'flg_tree'=>1 ),
				array( 'action'=>'profile', 'title'=>'Profile', 'flg_tree'=>1 ),
				array( 'action'=>'details', 'title'=>'Details', 'flg_tree'=>1 ),
				array( 'action'=>'payment', 'title'=>'Payment', 'flg_tree'=>1 ),
				array( 'action'=>'payment_history', 'title'=>'Payment History', 'flg_tree'=>1 ),
				
				array( 'action'=>'api', 'title'=>'iFunnels API', 'flg_tree'=>1 ),

			),
		);
	}

	public function api(){
		$this->out['apiKey']=Core_Payment_Encode::encode( Core_Users::$info['id'], 1 );
		$this->out['apiSecret']=Core_Payment_Encode::encode( Core_Users::$info['id'], 3 );
		try{
			Core_Sql::setConnectToServer( 'ifunnels.api' );
			// ==========================
			if( !empty($_POST) && isset($_POST['redirectUrl'])  ){
				Core_Sql::setExec( 'UPDATE oauth_clients SET redirect_uri='.Core_Sql::fixInjection( $_POST['redirectUrl'] ) );
			}
			$_flgApiUser=Core_Sql::getRecord( 'SELECT client_secret, redirect_uri FROM oauth_clients WHERE client_id="'.$this->out['apiKey'].'"' );
			if( $_flgApiUser === false ){
				Core_Sql::setExec( 'INSERT INTO oauth_clients (client_id, client_secret ) VALUES ( '.Core_Sql::fixInjection( $this->out['apiKey'] ).', '.Core_Sql::fixInjection( $this->out['apiSecret'] ).' )' );
			}else{
				$this->out['redirectUrl']=$_flgApiUser['redirect_uri'];
			}
			// ==========================
			Core_Sql::renewalConnectFromCashe();
		}catch(Exception $e){
			p( $e );
			Core_Sql::renewalConnectFromCashe();
		}
		
		
		
		
		
	}

	public function calls(){
		Core_Users::getInstance()->reload();
		$this->objStore->getAndClear( $this->out );
		$_cron=new Project_Ccs_Arrange();
		if( !empty($_POST)&&$_cron->setEntered( $_POST['arrData'])->set() ){
			$this->objStore->set( array( 'msg'=>'Schedule was created' ) );
			$this->location();
		}
		if( !empty($_GET['del'])&&$_cron->withIds( $_GET['del'])->del() ){
			$this->objStore->set( array( 'msg'=>'Schedule was deleted' ) );
			$this->location();
		}
		$_cron->getErrors($this->out['arrErrors']);
		$_cron->onlyOwner()->withOrder( @$_GET['order'] )
		->withPaging( array('url'=>$_GET) )
		->getList( $this->out['arrList'] )
		->getPaging( $this->out['arrPg'] )
		->getFilter( $this->out['arrFilter'] );
	}

	public function confirmphone(){
		$this->objStore->getAndClear( $this->out );
		if(!empty($_GET['update_phone'])){
			$_user=new Project_Users_Management();
			$_user->withIds( Core_Users::$info['id'] )->onlyOne()->getList( $_updateData );
			unset( $_updateData['passwd'] );
			$_updateData['buyer_phone']='+'.preg_replace("/[^0-9]/","",$_GET['update_phone']);
			$_updateData['code_confirm']=mt_rand( 100000, 999999 );
			$_updateData['flg_phone']=0;
			$_user->setEntered( $_updateData )->set();
			Zend_Registry::get( 'objUser' )->reload();
		}
		if(!empty($_GET['call'])){
			$_twilio=new Project_Ccs_Twilio_Client();
			if( $_twilio->setCalled( Core_Users::$info['id'] )->confirmPhone()){
				$this->objStore->set( array( 'strMsg'=>'We\'re trying to call you now!' ) );
				$this->location(array('w'=>'start=true'));
			}
			$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
		}
		if( !empty($_GET['confirm']) ){
			$this->objStore->set( array( 'strMsg'=>'Your phone number was verified successfully. Thank you!' ) );
			Core_Users::getInstance()->reload();
			$this->location();
		}
		if( !empty($_POST['start']) ){
			$_arrange=new Project_Ccs_Arrange();
			if( $_arrange->setEntered( array(
				'action'=>Project_Ccs_Arrange::ACTION_CALL_CONFIRM,
				'start'=>$_POST['start']
			) )->set() ){
				$this->objStore->set( array( 'strMsg'=>'We try call you in '.date('d.m.Y H:i',$_POST['start']) ) );
				$this->location();
			}
			$_arrange->getErrors($this->out['arrErrors']);
		}
	}
	
	public function copyprophet(){
	}
	
	public function copyprophet_ajax(){
		$_model=new Project_Copyprophet();
		if ( isset( $_REQUEST["s"] ) ){
			$this->out['score']=$_model->getScore( $_REQUEST["s"] );
		}		
	}
	
	public function player(){
		
	}
	
	public function history() {
		$_history=new Project_Sites_History();
		$_history
		->withOrder( @$_GET['order'] )
		->withPaging( array( 
			'url'=>$_GET, 
			'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
			'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
		) )
		->getList( $this->out['arrList'] )
		->getPaging( $this->out['arrPg'] )
		->getFilter( $this->out['arrFilter'] );
	}

	public function manage() {}
	public function register() {}
	public function tutorials() {}
	public function traffic() {}
	public function templates() {}

	private function autologin(){
		if( $_GET['a'] ){
			$_str=Core_Payment_Encode::decode($_GET['a']);
			$_params=explode(Zend_Registry::get('config')->user->salt,$_str);
			if( (time()-$_params[1])>60 ){
				return false;
			}
			Core_Users::getInstance()->setById($_params[0]);
			setcookie("autologin", $_params[0], time()+3600);
			$this->location(array('action'=>'main'));
		}
	}

	public function login() {
		$this->autologin();
		$_auth=new Project_Users_Auth_Multi();
		if( $_auth->setEntered( $_POST,'arrLogin' )->authorize() ) {
			setcookie("loginName", $_POST['arrLogin']['username'], time()+3600);
			$_subscr=new Core_Payment_Subscription();
			if( $_subscr->onlyExpiry()->onlyOwner()->getList( $_tmp )->checkEmpty() ){
				$this->location( array('action'=>'payment') );
			}
			$this->location( );
		}
		$_auth->getErrors( $this->out['arrError']['login'] );
		$_forgot=new Core_Users_Forgot_Change();
		if( $_forgot->setEntered( $_POST, 'arrForgot' )->send() ) {
			$this->location(array( 'w'=>array( 'send_email'=>true )));
		}
		$_forgot->getEntered( $this->out['arrForgot'] )->getErrors( $this->out['arrError']['forgot'] );
	}

	public function settings() {
		$_user=new Core_Users_Management();
		Zend_Registry::get('objUser')->getId( $userId );
		$_user->withIds( $userId )->onlyOne()->getList( $_arrUser );
		if( $_arrUser['flg_expire']==1 ){
			$this->location( array( 'action'=>'payment' ) );
		}
		$this->location( array( 'action'=>'info' ) );
	}

	public function logoff() {
		Core_Users::logout();
		unset( $_SESSION['flgFirstLogin'] );
		$this->location();
	}

	public function save_menu_structure() {
		if( isset( $_POST['left_box'] ) && isset( $_POST['right_box'] ) ){
			$_users=new Project_Users_Management();
			Zend_Registry::get('objUser')->getId( $_userId );
			$_users->withIds( $_userId )->onlyOne()->getList( $_userSettings );
			$_userSettings['menu_settings']=serialize( $_POST );
			unset( $_userSettings['passwd'] );
			echo $_users->withIds( $_userId )->setEntered( $_userSettings )->set();
			Zend_Registry::get( 'objUser' )->reload();
		}
		exit;
	}

	public function main() {
		$this->autologin();

		if (!empty($_GET['reload'])) {
			Core_Users::getInstance()->reload();
			$this->location();
		}

		if (!empty($_POST)) {
			$_user = new Project_Users_Management();
			$_user->withIds(Core_Users::$info['id'])->setApprove($_POST['i_agree']);
		}
		
		if (!isset($_SESSION['flgFirstLogin'])) {
			$_SESSION['flgFirstLogin'] = true;
		} else {
			$_SESSION['flgFirstLogin'] = false;
		}

		$dasboard = new Project_Dashboard();
		$dasboard->getStatistics($this->out['stats']);
	}

	public function categoryWarning() {
		$_model=new Project_Wpress();
		$_bool1=$_model->onlyCount()->withoutCategories()->getList( $this->out['arrNum']['wpress'] );
		$_model=new Project_Sites( Project_Sites::NCSB );
		$_bool2=$_model->onlyCount()->withoutCategories()->getList( $this->out['arrNum']['ncsb'] )->checkEmpty();
		//$_model=new Project_Sites( Project_Sites::NVSB );
		//$_bool4=$_model->onlyCount()->withoutCategories()->getList( $this->out['arrNum']['nvsb'] )->checkEmpty();
		if ( $_bool1||$_bool2||$_bool4 ) {
			$this->out['boolShow']=true;
		}
	}

	public function balanceWarning(){
		if ( Core_Payment_Purse::getAmount()<Core_Payment_Purse::$minWarningBalance ) {
			$this->out['balanceBoolShow']=true;
		}
	}
	
	public function info() {
		$_user=new Project_Users_Management();
		Zend_Registry::get('objUser')->getId( $userId );
		$_user->withIds( $userId )->onlyOne()->getList( $this->out['arrProfile'] );
		$_groups=new Core_Acs_Groups();
		$_groups->withIds( Core_Users::$info['id'] )->getGroupByUserId( $arrGroups );
		$_groups->withIds( array_flip($arrGroups) )->getList( $this->out['arrGroups'] );
		$_subscr=new Core_Payment_Subscription();
		$_subscr
				->onlyOwner()
				->withOrder()
				->getList( $this->out['arrSubscr'] );
		$_purse=new Core_Payment_Purse();
		$_purse
				->betterAdded((60*60*24*15))
				->withType( array(Core_Payment_Purse::TYPE_REWARD_HOSTING,Core_Payment_Purse::TYPE_REWARD_SITES) )
				->onlyOwner()
				->getList( $this->out['arrReward'] );
		Core_Users::getInstance()->reload();
	}

	public function profile() {
		$this->objStore->getAndClear( $this->out );
		$_users=new Project_Users_Management();
		Zend_Registry::get('objUser')->getId( $_userId );
		if(!empty($_POST['arr'])){
			if( !isset( $_POST['arr']['flg_unsubscribe'] ) ){
				$_POST['arr']['flg_unsubscribe']=0;
			}
			if( $_users->setEntered( $_POST['arr'] )->set() ){
				Zend_Registry::get( 'objUser' )->reload();
				$this->objStore->set( array( 'strMsg'=>'Administrative settings updated successfully' ) );
				$this->location();
			}
			$_users
				->getEntered( $this->out['arrSettings'] )
				->getErrors( $this->out['arrErr'] );
		}
		$_users->withIds( $_userId )->onlyOne()->getList( $this->out['arrProfile'] );
	}

	public function details() {
		$this->objStore->getAndClear( $this->out );
		$_registration=new Project_Users_Registration();
		$_user=new Core_Users_Management();

		if ( $_POST['request'] == 'ajax' && !empty( $_POST['arrReg']['id'] ) ) {
			ob_clean();
			$_user = new Project_Users_Management();
			Zend_Registry::get('objUser')->getId( $userId );
			$_user->withIds( $userId )->onlyOne()->getList( $_arrReg );
			$_arrReg['fb_user_id'] = md5( $_POST['arrReg']['first_name'].$_POST['arrReg']['last_name'] );
			$_arrReg['settings']['facebook'] = $_POST['arrReg'];
			unset( $_arrReg['passwd']);
			echo $_user->setEntered( $_arrReg )->set();
			Zend_Registry::get( 'objUser' )->reload();
			exit;
		} else if( $_POST['request'] == 'ajax' && empty( $_POST['arrReg'] ) ){
			ob_clean();
			$_user = new Project_Users_Management();
			Zend_Registry::get('objUser')->getId( $userId );
			$_user->withIds( $userId )->onlyOne()->getList( $_arrReg );
			$_arrReg['fb_user_id'] = null;
			$_arrReg['settings']['facebook'] = null;
			$_arrReg['fb_messenger_id'] = null;
			$_botAI=new Project_Bot( $userId );
			$_botAI->cleanUserDialog();
			unset( $_arrReg['passwd']);
			echo $_user->setEntered( $_arrReg )->set();
			Zend_Registry::get( 'objUser' )->reload();
			exit;
		} 
		if ( $_registration->setEntered( $_POST, 'arrReg' )->edit() ) {
			$_registration->getEntered( $_arrReg );
			Zend_Registry::get( 'objUser' )->reload();
			$this->objStore->set( array( 'congratulations'=>true, 'arrReg'=>$_arrReg ) );
			$this->location();
		}
		$_registration
			->getFieldsError( $this->out['arrErr'] )
			->getHeadError( $this->out['strError'] );
		$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
		Zend_Registry::get('objUser')->getId( $userId );
		$_user->withIds( $userId )->onlyOne()->getList( $this->out['arrReg'] );
		if( !is_array( $this->out['arrReg']['settings'] ) ){
			$this->out['arrReg']['settings']=unserialize(base64_decode($this->out['arrReg']['settings']));
		}
		$this->out['arrTimezone']=Core_Datetime::getTimezonesToSelect();
	}

	public function payment() {
		$_package=new Core_Payment_Package();
		$_package
			->editMode()
			->withOrder( 'cost--dn' )
			->onlyTariffPkg()
			->withHided()
			->getList( $this->out['arrPackages'] );
		$_package
			->editMode()
			->withOrder( 'cost--dn' )
			->onlyCreditPkg()
			->getList( $this->out['arrCredits'] );
		$_subscr=new Core_Payment_Subscription();
		if(!empty($_GET['id'])){
			if($_subscr->withIds( $_GET['id'] )->del()){
				$this->location();
			}
		}
		$_subscr
				->onlyOwner()
				->withOrder()
				->getList( $this->out['arrSubscr'] )
				->onlyActive()
				->onlyIds()
				->onlyOwner()
				->onlyPackageIds()
				->getList( $this->out['arrIdsSubscr']);
	}
	
	public function payment_history() {
		$_package=new Core_Payment_Package();
		$_package
			->editMode()
			->withOrder( 'cost--dn' )
			->onlyTariffPkg()
			->withHided()
			->getList( $this->out['arrPackages'] );
		$_package
			->editMode()
			->withOrder( 'cost--dn' )
			->onlyCreditPkg()
			->getList( $this->out['arrCredits'] );
		$_subscr=new Core_Payment_Subscription();
		if(!empty($_GET['id'])){
			if($_subscr->withIds( $_GET['id'] )->del()){
				$this->location();
			}
		}
		$_subscr
				->onlyOwner()
				->withOrder()
				->getList( $this->out['arrSubscr'] )
				->onlyActive()
				->onlyIds()
				->onlyOwner()
				->onlyPackageIds()
				->getList( $this->out['arrIdsSubscr']);
		$_history=new Core_Payment_Service();
		$_history
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
				'inst'=>'order'
			) )
			->withOrder( @$_GET['order'] )
			->onlyOwner()
			->getList( $this->out['arrList'] )
			->getFilter( $this->out['arrFilterOrder'] )
			->getPaging( $this->out['arrPgOrder'] );
		
		
		
		$_balance=new Core_Payment_Purse();
		$_balance
			->withPaging( array(
				'url'=>@$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['pagging_rows'],
				'numofdigits'=>Core_Users::$info['arrSettings']['pagging_links'],
				'inst'=>'balance'
			) )
			->onlyOwner()
			->getList($this->out['arrBalance'])
			->getPaging( $this->out['arrPgBalance'] );
		$this->out['onPageBalance']=$_balance->getAmount( $this->out['arrBalance'][0]['added'] );
	}

	public function terms() {
		$this->out['item']=Project_Documents::getBySysName('terms');
	}

	public function emailfunnelstutorials() {
		$this->out['item']=Project_Documents::getBySysName('emailfunnelstutorials');
	}

	public function dpa() {
		$this->out['item']=Project_Documents::getBySysName('dpa');
		if( isset( $_POST['i_agree'] ) && $_POST['i_agree']==1 ){
			ob_clean();
			$_user = new Project_Users_Management();
			$_user->withIds( Core_Users::$info['id'] )->onlyOne()->getList( $_arrReg );
			$_arrReg['dpa_agree_date'] = time();
			if (!empty($_SERVER["HTTP_CLIENT_IP"])){
				$ip=$_SERVER["HTTP_CLIENT_IP"];
			}elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
				$ip=$_SERVER["HTTP_X_FORWARDED_FOR"];
			}else{
				$ip=$_SERVER["REMOTE_ADDR"];
			}
			$_arrReg['dpa_agree_ip'] = sprintf("%u\n", ip2long($ip));
			unset( $_arrReg['passwd']);
			$_user->setEntered( $_arrReg )->set();
			Zend_Registry::get( 'objUser' )->reload();
			$this->out['closePopup']=true;
		}
	}

	public function termspage() {
		$this->out['item']=Project_Documents::getBySysName('terms');
	}

	public function apppolicypage() {
		$this->out['item']=Project_Documents::getBySysName('apppolicy');
	}
	
	public function credits() {
		$_package=new Core_Payment_Package();;
		$_package
			->editMode()
			->withOrder( 'cost--dn' )
			->onlyCreditPkg()
			->getList( $this->out['arrCredits'] );
	}

	public function conditions() {
		$this->out['item']=Project_Documents::getBySysName('conditions');
	}
	
	public function unsubscribe() {
		$this->objStore->getAndClear( $this->out );
		if(!empty($_GET['params'])){
			$this->out['arrUser']=Core_Payment_Encode::decode( $_GET['params'] );
			$_users=new Project_Users_Management();
			if( !$_users->setEntered($this->out['arrUser'])->set() ){
				$_users
					->getEntered( $this->out['arrSettings'] )
					->getErrors( $this->out['arrErr'] );
			}
			return;
		}
		$this->location( Core_Module_Router::$offset );
	}

	public function change() {
		if ( empty( $_GET['code'] ) ) {
			$this->location( Core_Module_Router::$offset );
		}
		$_forgot=new Core_Users_Forgot_Change();
		if ( !$_forgot->checkCode( $_GET['code'] ) ) {
			$_forgot->getErrors( $this->out['strErr'] );
			return;
		}
		if ( $_forgot->setEntered( $_POST, 'arrCh' )->change() ) {
			$this->location( array( 'action'=>'login', 'w'=>array( 'change'=>true ) ) );
		}
		$_forgot->getEntered( $this->out['arrCh'] )->getErrors( $this->out['strErr'] );
	}

	public function logo(){
		if(!empty($_GET['p'])){
			$_model=new Core_Payment_Package();
			$_model->onlyOne()->withIds(intval(Core_Payment_Encode::decode($_GET['p'])))->getList( $this->out['arrPack'] );
			$_files=new Project_Files_Package('package_logo');
			$_files->withIds( $this->out['arrPack']['image'] )->onlyOne()->getList( $this->out['arrPack']['image'] );
		}
	}

	private function registration_auth(){
		sleep(3);// при регистрации возможны проблемы с репликацией на продакшине, поэтому ждем пока пользователь будет создан.
		$_POST['arrReg']['username']=$_POST['arrReg']['email'];
		$_auth=new Project_Users_Auth_Multi();
		if( $_auth->setEntered( $_POST,'arrReg' )->authorize() ) {
			$_subscr=new Core_Payment_Subscription();
			if( $_subscr->onlyOwner()->withPackage( $_POST['arrReg']['package_id'] )->onlyOne()->getList( $_arrSubsc )->checkEmpty()&&$_arrSubsc['flg_expiry']==0 ){
				$this->location(array('name'=>'site1_accounts','action'=>'main','wg'=>'reload=1'));
			}
			$_package=new Core_Payment_Package();
			$_package->withHided()->onlyOne()->withIds( $_POST['arrReg']['package_id'] )->getList( $_arrPack );
			if( !Core_Payment_Package::isFree($_arrPack) ){
				$this->location( $_arrPack['click2sell_url']);
			} else {
				$_free=new Project_Users_Free();
				$_free->setPackage( $_arrPack['id'] )->setUser( Core_Users::$info['id'] )->add();
				$this->location(array('name'=>'site1_accounts','action'=>'main','wg'=>'reload=1'));
			}
		}
		$_auth->getEntered( $this->out['arrReg'] )->getErrors($this->out['arrErr'])->getHeadError($this->out['strError']);
		return false;
	}

	private function registration_existing_account(){
		$_user=new Project_Users_Management();
		$_user->withEmail( $_POST['arrReg']['email'] )->onlyOne()->getList($arrUser);
		Core_Users::getInstance()->setById($arrUser['id']);
		$_package=new Core_Payment_Package();
		$_package->withHided()->onlyOne()->withIds( $_POST['arrReg']['package_id'] )->getList( $_arrPack );
		Core_Users::logout();
		if( !Core_Payment_Package::isFree($_arrPack) ){
			$this->location( $_arrPack['click2sell_url']);
		} else {
			$_free=new Project_Users_Free();
			$_free->setPackage( $_arrPack['id'] )->setUser( $arrUser['id'] )->add();
			$this->location(array('name'=>'site1_accounts','action'=>'main'));
		}
		return false;
	}

	public function membermouse() {
		Core_Errors::off();
		if(!isset($_GET["event_type"])){
			exit;
		}
		switch( $_GET["event_type"] ){
			case "mm_member_add":
			case "mm_member_account_update":
				$letters="qwertyuiopasdfghjklzxcvbnm";
				$numbers="1234567890";
				$password='';
				$password.=$letters[mt_rand(0,strlen($letters)-1)];
				$password.=$numbers[mt_rand(0,strlen($numbers)-1)];
				$password.=$letters[mt_rand(0,strlen($letters)-1)];
				$password.=$letters[mt_rand(0,strlen($letters)-1)];
				$password.=$numbers[mt_rand(0,strlen($numbers)-1)];
				$password.=$letters[mt_rand(0,strlen($letters)-1)];
				$_packageId=intval(Core_Payment_Encode::decode($_GET['p']));
				Project_Statistics_Package::add( $_packageId,Project_Statistics_Package::TYPE_IMPRESSION );
				$_arrUser=array( 'arrData'=>array(
					'package_id'=>$_packageId,
					'mm_id'=>$_GET["member_id"],
					'nickname'=>$_GET["username"],
					'buyer_name'=>$_GET["first_name"],
					'buyer_surname'=>$_GET["last_name"],
					'phone'=>$_GET["phone"],
					'buyer_phone'=>'+'.preg_replace("/[^0-9]/","", $_GET["phone"]),
					'code_confirm'=>mt_rand( 100000, 999999 ),
					'flg_phone'=>0,
					'buyer_address'=>$_GET["billing_address"],
					'buyer_country'=>$_GET["billing_country"],
					'buyer_zip'=>$_GET["billing_zip_code"],
					'buyer_province'=>$_GET["billing_state"],
					'billing_city'=>$_GET["billing_city"],
					'email'=>$_GET["email"],
					'passwd'=>$password,
					'lang'=>'en',
					'timezone'=>'UTC',
					'flg_unsubscribe'=>0,
					'flg_expire'=>1,
					'flg_sended'=>0,
					'expiry'=>0,
					'flg_active'=>1,
				));
				$_users=new Project_Users_Management();
				if ( $_users->onlyOne()->withMemberMouseId( $_arrUser['arrData']['mm_id'] )->getList( $arrProfileExists )->checkEmpty() ) {
					$_arrUser['arrData']['id']=$arrProfileExists['id'];
				}
				$_registration=new Project_Users_Registration();
				if( $_registration->setEntered( $_arrUser, 'arrData' )->adminSet() ){
					$_arrMail=array();
					$_package=new Core_Payment_Package();
					$_package->withIds($_packageId)->onlyOne()->getList( $_arrMail['arrPkg'] );
					$_arrMail['email']=$_GET["email"];
					$_arrMail['password']=$password;
					$_mailer=new Core_Mailer();
					$_mailer
						->setVariables( $_arrMail )
						->setTemplate( 'api_registration_complete' )
						->setSubject( 'Your Lead Pro Systems Account Has Been Created' )
						->setPeopleTo( array( 'email'=>$_arrMail['email'], 'name'=>$_arrUser['arrData']['nickname'] ) )
						->setPeopleFrom( array( 'name' => Zend_Registry::get('config')->engine->project_sysemail->name, 'email' => Zend_Registry::get('config')->engine->project_sysemail->email ) )
						->sendOneToMany();
				}
				break;
				
			case "mm_member_delete":
				$_users=new Project_Users_Management();
				if ( $_users->onlyOne()->withMemberMouseId( $_GET["member_id"] )->getList( $arrProfileExists )->checkEmpty() ) {
					$_users->withIds( array_keys( $arrProfileExists['id'] ) )->del();
				}
				break;
		}
		die();
	}

	public function registration() {
		$this->objStore->getAndClear( $this->out );
		if(!empty($_POST['forgot'])){
			$_forgot=new Core_Users_Forgot_Change();
			if( $_forgot->setEntered( $_POST, 'arrForgot' )->send() ) {
				$this->objStore->set( array( 'forgotmessage'=>true) );
				$this->location(array('wg'=>true));
			}
			$_forgot->getEntered( $this->out['arrForgot'] )->getErrors( $this->out['arrError']['forgot'] );
		}
		if ( !empty( $this->out['congratulations'] ) ) {
			return;
		}
		if(!empty($_GET['p'])){
			if( Core_Users::$info['id'] ){
				Core_Users::logout();
				$this->location(array('wg'=>true));
			}
			$this->out['special_offer']=intval(Core_Payment_Encode::decode($_GET['p']));
			Project_Statistics_Package::add( $this->out['special_offer'],Project_Statistics_Package::TYPE_IMPRESSION );
		}
		$_package=new Core_Payment_Package();
		$_package->withHided()->editMode()->onlyTariffPkg()->getList( $this->out['arrList'] );
		if( $_POST['arrReg']['flg_new']==='0' && !$this->registration_existing_account() ){ // account alredy exist
			return;
		}
		$_registration=new Project_Users_Registration();
		if ( $_registration->setEntered( $_POST, 'arrReg' )->make() ) {
			$_registration->getEntered($_POST['arrReg']);
			$_POST['arrReg']['passwd']=$_POST['arrReg']['password'];
			$this->registration_auth();
		}
		$_registration->getEntered( $this->out['arrReg'] )->getFieldsError( $this->out['arrErr'] )->getHeadError( $this->out['strError'] );
		$this->out['arrTimezone']=Core_Datetime::getTimezonesToSelect();
	}

	public function check(){
		if(empty($_POST['email'])){
			return false;
		}
		$_user=new Project_Users_Management();
		$this->out_js['email']=$_user->withEmail( $_POST['email'] )->getList( $_res )->checkEmpty();
	}

	public function activate() {
		if ( empty( $_GET['code'] ) ) {
			$this->location( Core_Module_Router::$offset );
		}
		$_registration=new Project_Users_Registration();
		$_registration->checkCode( $_GET['code'] )->getHeadError( $this->out['strError'] );
	}
}
?>