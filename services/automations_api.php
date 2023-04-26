<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

if( !isset( $_REQUEST ) || empty( $_REQUEST ) ){
	exit;
}
$_type=false;
if( isset( $_REQUEST['a'] ) && !empty( $_REQUEST['a'] ) ){
	switch ( $_REQUEST['a'] ){
		case 'o': $_type=Project_Automation_Event::$type['OPEN_EMAIL'];break;
		case 'c': $_type=Project_Automation_Event::$type['CLICK_EMAIL_LINK'];break;
		case 'v': $_type=Project_Automation_Event::$type['VISIT_PAGE'];break;
	}
}
$_value=false;
if( isset( $_REQUEST['a'] ) && !empty( $_REQUEST['a'] ) ){
	switch ( $_REQUEST['a'] ){
		case 'o': if( isset( $_REQUEST['m'] ) && !empty( $_REQUEST['m'] ) ) $_value=$_REQUEST['m'];break;
		case 'c': if( isset( $_REQUEST['m'] ) && !empty( $_REQUEST['m'] ) ) $_value=$_REQUEST['m'];break;
		case 'v': $_value=1;break;
	}
}
$_email=false;
if( isset( $_REQUEST['e'] ) && !empty( $_REQUEST['e'] ) ){
	$_email=$_REQUEST['e'];
}
$_userId=false;
if( isset( $_REQUEST['u'] ) && !empty( $_REQUEST['u'] ) ){
	$_userId=$_REQUEST['u'];
}

$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'Automation_API.log' );
$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
$_logger=new Zend_Log( $_writer );
$_logger->info(serialize($_REQUEST));

Core_Users::getInstance()->setById( $_userId );
Project_Automation::setEvent( $_type, $_value, $_email );
if( $_type==Project_Automation_Event::$type['OPEN_EMAIL'] && isset( $_REQUEST['f'] ) && !empty( $_REQUEST['f'] ) ){
	$_mailer=new Project_Efunnel_Mailer();
	$_mailer->withEmail($_email)->withEF($_REQUEST['f'])->resendStop();
}
Core_Users::getInstance()->setZero();
