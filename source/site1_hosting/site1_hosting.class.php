<?php
/**
 * CNM Project
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 19.04.2012
 * @version 1.0
 */


/**
 * Hosting
 *
 * @category CNM Project
 * @package ProjectSource
 * @copyright Copyright (c) 2009-2012, web2innovation
 */
class site1_hosting extends Core_Module {


	public function set_cfg() {
		$this->inst_script=array(
			'module'=>array( 'title'=>'CNM Hosting', ),
			'actions'=>array(
				//frontend
				array( 'action'=>'mydomains', 'title'=>'Domains Hosted With Us', 'flg_tree'=>1 ),
				array( 'action'=>'mydomains_externally', 'title'=>'Domains Hosted Externally', 'flg_tree'=>1 ),
				array( 'action'=>'addomain', 'title'=>'Form add domain', 'flg_tree'=>1, 'flg_tpl' => 1 ),
				array( 'action'=>'checkdomain', 'title'=>'Check domain', 'flg_tree'=>1, 'flg_tpl' => 3 ),
				array( 'action'=>'browse', 'title'=>'Browse directory', 'flg_tree'=>2, 'flg_tpl'=>1 ),
				//backend
				array( 'action'=>'manage', 'title'=>'Domain API'),
				array( 'action'=>'statistic', 'title'=>'Domain API statistic'),
			),
		);
	}

	public function manage(){
		$_model=new Project_Placement();
		if(!empty($_GET['auth'])){
			$_id=Core_Payment_Encode::decode($_GET['auth']);
			header('Location: /?a='.Core_Payment_Encode::encode($_id.Zend_Registry::get('config')->user->salt.time()));
		}
		if(!empty($_GET['del'])){
			if( $_model->withIds( $_GET['del'] )->del() ){
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		if(isset($_GET['flg_auto'])){
			$_model->setEntered(array('flg_auto'=>$_GET['flg_auto'],'id'=>$_GET['id']))->set();
			$this->location();
		}
		if( !empty($_GET['renew']) ){
			if( $_model->withIds( $_GET['renew'] )->renew() ){
				unset( $_GET['renew'] );
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		if( !empty($_GET['reactivate']) ){
			if( $_model->withIds( $_GET['reactivate'] )->reactivate() ){
				unset( $_GET['reactivate'] );
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		if( !empty($_GET['arrFilter']['renewed']['number']) && !empty($_GET['arrFilter']['renewed']['type']) ){
			if( $_GET['arrFilter']['renewed']['type'] == 'day' ){
				$_period=(int)$_GET['arrFilter']['renewed']['number'] * 24*60*60;
			}elseif( $_GET['arrFilter']['renewed']['type'] == 'week' ){
				$_period=(int)$_GET['arrFilter']['renewed']['number'] * 7*24*60*60;
			}
			$_model->onlyNotExpiredDomain()->onlyAuto()->withPeriod($_period);
		}
		if(!empty($_GET['arrFilter']['search']['domain_http'])){
			$_model->likeDomainName($_GET['arrFilter']['search']['domain_http']);
		}
		if(!empty($_GET['arrFilter']['search']['user_name'])||!empty($_GET['arrFilter']['search']['user_email'])){
			$_users=new Project_Users_Management();
			if( !empty($_GET['arrFilter']['search']['user_name']) ){
				$_users->likeNickname($_GET['arrFilter']['search']['user_name']);
			}
			if( !empty($_GET['arrFilter']['search']['user_email']) ){
				$_users->withEmail($_GET['arrFilter']['search']['user_email']);
			}
			$_users->onlyIds()->onlyOne()->getList( $_arrUsers );
			if( !empty( $_arrUsers[0] ) ){
				$_model->withUserId( $_arrUsers[0] );
			}
		}
		if( !empty( $_POST['arrFilter']['action'] ) && !empty( $_POST['arrList'] ) ){
			if( $_POST['arrFilter']['action']=='delete' && $_model->withIds( array_keys($_POST['arrList']) )->del() ){
				$this->location();
			}
			if( $_POST['arrFilter']['action']=='exteral' && $_model->withIds( array_keys($_POST['arrList']) )->setToExteral() ){
				$this->location();
			}
		}
		$_model
			->withType( Project_Placement::LOCAL_HOSTING_DOMEN )
			->withPaging(array( 
				'url'=>$_GET,
				'reconpage'=>Core_Users::$info['arrSettings']['rows_per_page'],
				'numofdigits'=>Core_Users::$info['arrSettings']['page_links'],
			))
			->withOrder( @$_GET['order'] )
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
		$_arrUsersIds=array();
		foreach( $this->out['arrList'] as $_domen ){
			$_arrUsersIds[$_domen['user_id']]=true;
		}
		$_users=new Project_Users_Management();
		$_users->withIds( array_keys( $_arrUsersIds ) )->getList( $_arrUsers );
		foreach( $_arrUsers as $_user ){
			$this->out['arrUsers'][$_user['id']]=array(
				'amount' => $_user['amount'],
				'name' => $_user['buyer_name'],
				'surname' => $_user['buyer_surname'],
				'email' => $_user['email'],
			);
		}
		unset( $_arrUsers );
	}

	public function statistic(){
		$_model=new Core_Payment_Purse();
		$_model
			->onlyInternal()
			->onlyDomainLike()
			->withPaging( array( 'url'=>$_GET ) )
			->withUsers()
			->getList( $this->out['arrList'] )
			->getPaging( $this->out['arrPg'] );
	}

	public function mydomains_externally(){
		$this->mydomains();
	}

	public function mydomains(){
		$this->objStore->getAndClear( $this->out );
		$_model=new Project_Placement();
		if(isset($_GET['flg_auto'])){
			$_model->setEntered(array('flg_auto'=>$_GET['flg_auto'],'id'=>$_GET['id']))->set();
			$this->location();
		}
		if(!empty($_GET['del'])){
			if( $_model->withIds( $_GET['del'] )->del() ){
				$this->location();
			}
			$_model->getEntered( $this->out['arrData'] )->getErrors( $this->out['arrErrors'] );
		}
		if( !empty( $_GET['set'] ) ){
			if( $_model->withIds( $_GET['set'] )->changeType() ){
				$this->objStore->set( array( 'view_message'=>true ) );
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}

		if( !empty( $_GET['ssl'] ) ){
			ob_clean();

			$response = $_model
				->withIds( $_GET['ssl'] )
				->sslCertificate();

			echo json_encode( $response );
			
			exit();
		}

		if( !empty( $_GET['renew'] ) ){
			if( $_model->withIds( $_GET['renew'] )->renew() ){
				unset( $_GET['renew'] );
				$this->objStore->set( array( 'view_message'=>true ) );
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		if( !empty( $_GET['reactivate'] ) ){
			if( $_model->withIds( $_GET['reactivate'] )->reactivate() ){
				unset( $_GET['reactivate'] );
				$this->objStore->set( array( 'view_message'=>true ) );
				$this->location();
			}
			$_model->getErrors( $this->out['arrErrors'] );
		}
		$this->out['arrList']=array( 'debug'=>1 );

		$_model
			->onlyOwner()
			->getList( $this->out['arrList'] );

		$_model->getList( $_arrFullList );

		foreach( $this->out['arrList'] as &$_domain ){ 
			if( count( explode( '.', $_domain['domain_http'] ) ) > 2 && strpos( $_domain['domain_http'], '.ifunnels.com' ) === false ) {
				$_domain['flgSslCertificate'] = true;

				foreach( $_arrFullList as $_testDomain ){
					if( strpos( $_domain['domain_http'], '.' ) + 1 == strpos( $_testDomain['domain_http'], $_domain['domain_http'] ) ) {
						$_domain['flgSslCertificate'] = false;
						continue;
					}
				}
			}
		}
	}

	public function addomain(){
		$_model=new Project_Placement();
		if( !empty($_GET['id'] ) ){
			$_model->onlyOwner()->withIds( $_GET['id'] )->onlyOne()->getList( $this->out['arrData'] );
		}
		if( !empty( $_POST['arrData'] ) ){
			$_POST['arrData']['domain_http']=strtolower( $_POST['arrData']['domain_http'] );
			if( $_model->setEntered( $_POST['arrData'] )->set() ){
				$this->location( array( 'wg'=>'close=1' ) );
			}
		}
		$_model->getEntered( $this->out['arrData'] )->getErrors( $this->out['arrErrors'] );
		if( $this->out['arrData']['flg_type']==Project_Placement::IFUNELS_HOSTING ){
			$this->out['arrData']['domain']=str_replace( '.ifunnels.com', '', $this->out['arrData']['domain'] );
		}
		$_model->onlyOwner()->withType( Project_Placement::IFUNELS_HOSTING )->onlyOne()->getList( $this->out['arrIfunnel'] );
		unset( $this->out['arrErrors']['errForm'] );
	}

	public function checkdomain(){
		$_model          = new Project_Placement_Domen();
		$_POST['domain'] = strtolower($_POST['domain']);

		if (!empty($_POST['domain'])) {
			$_flgBadWord = false;

			if (!in_array($_POST['flg_type'], [Project_Placement::LOCAL_HOSTING, Project_Placement::LOCAL_HOSTING_SUBDOMEN])) {
				foreach (array('ssl', 'get', 'book', 'join', 'add', 'purchase', 'go', 'mail', 'secure', 'app', 'help', 'docs', 'create', 'word', 'anal', 'anus', 'arse', 'ass', 'assfuck', 'asshole', 'assfucker', 'asshole', 'assshole', 'bastard', 'bitch', 'blackcock', 'bloodyhell', 'boong', 'cock', 'cockfucker', 'cocksuck', 'cocksucker', 'coon', 'coonnass', 'crap', 'cunt', 'cyberfuck', 'damn', 'darn', 'dick', 'dirty', 'douche', 'dummy', 'erect', 'erection', 'erotic', 'escort', 'fag', 'faggot', 'fuck', 'Fuckoff', 'fuckyou', 'fuckass', 'fuckhole', 'goddamn', 'gook', 'hardcore', 'hardcore', 'homoerotic', 'hore', 'lesbian', 'lesbians', 'motherfucker', 'motherfuck', 'motherfucker', 'negro', 'nigger', 'orgasim', 'orgasm', 'penis', 'penisfucker', 'piss', 'pissoff', 'porn', 'porno', 'pornography', 'pussy', 'retard', 'sadist', 'sex', 'sexy', 'shit', 'slut', 'sonofabitch', 'suck', 'tits', 'viagra', 'whore', 'xxx') as $_badWord) {
					$_strPosition = strpos(trim($_POST['domain']), $_badWord);
					if (strlen(trim($_POST['domain'])) !== strlen($_badWord) && in_array($_badWord, array('ssl', 'get', 'book', 'join', 'add', 'purchase', 'go', 'mail', 'secure', 'app', 'help', 'docs', 'create', 'word'))) {
						$_strPosition = false;
					}
					if ($_strPosition !== false) {
						$_flgBadWord           = true;
						$this->out_js['error'] = array('errDebug' => 'Don\'t use bead word "' . $_badWord . '" in domain name!', 'errFlow' => array('Sorry, this domain is not available. Try another one.'));
						break;
					}
				}
			}

			if (!$_flgBadWord) {
				if (isset($_POST['parent_domain_id']) && !empty($_POST['parent_domain_id']) && $_POST['flg_type'] == Project_Placement::LOCAL_HOSTING_SUBDOMEN) {
					$_domainObj = new Project_Placement();
					$_domainObj->onlyOwner()->withIds($_POST['parent_domain_id'])->onlyOne()->getList($_arrData);
					$this->out_js['flg_checked'] = $_model->check($_POST['domain'] . '.' . $_arrData['domain_http'], Project_Placement::LOCAL_HOSTING_SUBDOMEN);
				}
				if ($_POST['flg_type'] == Project_Placement::LOCAL_HOSTING_DOMEN) {
					$this->out_js['flg_checked'] = $_model->check($_POST['domain'], Project_Placement::LOCAL_HOSTING_DOMEN);
				}
				if ($_POST['flg_type'] == Project_Placement::LOCAL_HOSTING) {
					$this->out_js['flg_checked'] = (!$_model->check($_POST['domain'], Project_Placement::LOCAL_HOSTING) && !$_model->getErrors());
					$this->out_js['dns1']        = Project_Placement_Domen_Availability::$_NS1;
					$this->out_js['dns2']        = Project_Placement_Domen_Availability::$_NS2;
				}
				if ($_POST['flg_type'] == Project_Placement::IFUNELS_HOSTING) {
					$this->out_js['flg_checked'] = (!$_model->check($_POST['domain'] . '.ifunnels.com', Project_Placement::IFUNELS_HOSTING) && !$_model->getErrors());
				}
				$_arrError             = $_model->getErrors();
				$this->out_js['error'] = (empty($_arrError) ? null : $_arrError);
			}
		}
	}

	public function select(){
		$_model=new Project_Placement();
		if( $this->params['onlyRemote']){
			$_model->withType( Project_Placement::REMOTE_HOSTING );
		}
		if( $this->params['onlyLocal']){
			$_model->withType( array(Project_Placement::LOCAL_HOSTING,Project_Placement::LOCAL_HOSTING_DOMEN) );
		}
		$_model->withOptgroup()->onlyOwner()->getList( $this->out['arrPlacements'] );
		if( !empty( $this->params['selected']['placement_id'] ) ){
			$_model->withIds( $this->params['selected']['placement_id'] )->onlyOne()->getList( $this->out['placement'] );
		}
		$this->out['arrayName']=empty( $this->params['arrayName'] )?'arrFtp':$this->params['arrayName'];
	}

	public function browse() {
		$_model=new Project_Placement_Transport();
		if ( !$_model->setInfo( $_GET )->browseDirs( $this->out['arrDirs'] ) ) {
			$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
			$_model->breakConnect();
			return;
		}
		$_model->isPassive();
		if ( !empty( $_POST['new_folder'] ) ) {
			if ( $_model->makeDirAndBreakConnect( $_POST['new_folder'] ) ) {
				$this->location( Core_Module_Location::URLFULL );
			}
			$this->out['arrErrors']=Core_Data_Errors::getInstance()->getErrors();
		}
		$this->out['strGetCurrentDir']='ftp_directory='.$_model->getCurrentDir();
		$this->out['strCurrentDir']=$_model->getCurrentDir();
		$this->out['strPrevDir']='ftp_directory='.$_model->getPrevDir();
		$this->out['strUrl']=Core_Module_Router::$uriFull;
		$_model->breakConnect();
	}
}
?>