<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_startup_errors',1);
ini_set('display_errors',1);

$sapi_type=php_sapi_name();
if (substr($sapi_type, 0, 3) == 'cgi') {
    header('Status: 200 Ok');
}else{
    header($_SERVER['SERVER_PROTOCOL'].' 200 Ok');
}

require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

if( $_REQUEST['hub_verify_token'] === 'once_upon_a_time' ){
	echo $_REQUEST['hub_challenge'];
}else{
	
	if( is_file('./services/fm.txt') ){
		Core_Files::getContent($_str,'./services/fm.txt');
	}
	$data=json_decode(file_get_contents("php://input"), true, 512, JSON_BIGINT_AS_STRING);

	$_str.="\n/*".date('d.m.Y H:i:s').'*/ '.serialize( $argv ). ' REQUEST: '.serialize( $_REQUEST ).' CONTENT:'.serialize( $data );
	Core_Files::setContent($_str,'./services/fm.txt');
	
	$_fm=new Project_Ccs_Facebook();
	if( isset( $_GET['install'] ) ){
		$_fm->install();
	}
	echo $_fm->run( $data );
}
exit;