<?php

if( $argv[0]!='/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/create_zonterest.php' || !isset($argv[1]) || !isset($argv[2]) || empty($argv[1]) || empty($argv[2]) ){
	exit;
}
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();



if(is_file('./zonterest.txt')){
	Core_Files::getContent($_str,'./zonterest.txt');
}
$_str.="\n/*".date('d.m.Y H:i:s').'*/ '.serialize( $argv );
Core_Files::setContent($_str,'./zonterest.txt');


$_command=$argv[1];
Core_Users::getInstance()->setById( $argv[2] );

$_adapter=new Project_Ccs_Adapter();
$_category='All';
if( stripos($_command,'[') ){
	preg_match( '/(.*?)\[(.*?)\]/i', $_command, $_tmp );
	$_keyword=strtolower( trim( $_tmp[1] ) );
	$_category=$_tmp[2];
	if( strpos( $_category, ':' ) === false ){
		$_categoryName=str_replace( ' ', '', strtolower( $_category ) );
		$_usersettings=new Project_Content_Settings();
		$_usersettings->onlyOne()->withFlgDefault()->onlySource( '9' )->getContent( $_arrsettings );
		$_categoryNames=Project_Content_Adapter_Amazon::getCategory( $_categoryName, $_arrsettings['settings']['site'] );
		if( isset( $_categoryNames['remote_id'] ) ){
			$_category=$_categoryNames['title'].'::'.$_categoryNames['remote_id'];
		}else{
			$_category=$_categoryNames['title'];
		}
	}
}else{
	$_keyword=$_command;
}
//p(  array(Core_Users::$info, 'keyword'=>$_keyword, 'category'=>$_category ) );
$_adapter->setEntered( array('keyword'=>$_keyword, 'category'=>$_category ) );
$_domain=false;
if( isset( $argv[5] ) ){
	$_adapter->setDomain( $argv[5] );
}
if( isset( $argv[4] ) ){
	switch ($argv[4]){
		case 'facebook':
			$_client=new Project_Ccs_Facebook();
			if(is_file('./zonterest.txt')){
				Core_Files::getContent($_str,'./zonterest.txt');
			}
			$_str.="\n/*".date('d.m.Y H:i:s').'*/ facebook';
			Core_Files::setContent($_str,'./zonterest.txt');
		break;
		default: $_client=new Project_Ccs_Twilio_Client();
	}
}else{
	$_client=new Project_Ccs_Twilio_Client();
}
try{
	if( isset( $argv[3] ) && $argv[3]=='zonterest20' ){
		if( $_adapter->createZonterest20Site() ){
			if( isset( $argv[4] ) && $argv[4] == 'facebook' ){
				$_client->setSettings(array('body'=>'Congratulations! Here is your website live: ' ));
				$_client
					->setCalled( $argv[2] )
					->sendSMS( $return );
				$_client->setSettings(array('body'=>$_adapter->getSiteUrl() ));
				
			}else{
				$_client->setSettings(array('body'=>'Zonterest site '.$_adapter->getSiteUrl().' was created successfully', 'flg_zonterest20'=>true));
			}
		} else {
			$_strError=Core_Data_Errors::getInstance()->getErrorFlowShift();
			if( empty($_strError) ){
				$_strError='Sorry, we were not able to create a AzonFunnels site for <'.$_params.'> keyword';
			}
			$_client->setSettings(array('body'=>$_strError, 'flg_zonterest20'=>true));
		}
	}else{
		if( $_adapter->createZonterestSite() ){
			$_client->setSettings(array('body'=>'Zonterest site '.$_adapter->getSiteUrl().' was created successfully'));
		} else {
			$_strError=Core_Data_Errors::getInstance()->getErrorFlowShift();
			if( empty($_strError) ){
				$_strError='Sorry, we were not able to create a AzonFunnels site for <'.$_params.'> keyword';
			}
			$_client->setSettings(array('body'=>$_strError));
		}
	}
	$return='';
	$_client
		->setCalled( $argv[2] )
		->sendSMS( $return );
}catch(Exception $e) {
	if( isset( $argv[4] ) ){
		if ($argv[4] == 'facebook'){
			if(is_file('./zonterest.txt')){
				Core_Files::getContent($_str,'./zonterest.txt');
			}
			$_str.="\n/*".date('d.m.Y H:i:s').'*/ ERROR: '.serialize( $e );
			Core_Files::setContent($_str,'./zonterest.txt');
		}
	}
	$_client
		->setCalled( $argv[2] )
		->sendSMS( $e->message );
}
if( isset( $argv[4] ) ){
	if ($argv[4] == 'facebook'){
		if(is_file('./zonterest.txt')){
			Core_Files::getContent($_str,'./zonterest.txt');
		}
		$_str.="\n/*".date('d.m.Y H:i:s').'*/ '.$return;
		Core_Files::setContent($_str,'./zonterest.txt');
	}
}
	
exit;
?>