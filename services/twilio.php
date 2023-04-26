<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
error_reporting(E_ALL);
session_start();


$_str="\n/*".date('d.m.Y H:i:s').'*/ ';
if(is_file('./voice.txt')){
	Core_Files::getContent($_str,'./voice.txt');
}
if( !isset( $_SERVER['QUERY_STRING'] ) || empty( $_SERVER['QUERY_STRING'] ) ){
$_str.='
$_service=new Project_Ccs_Twilio_Service();
$_service->setSettings( unserialize( \''.serialize($_POST).'\' )+array(\'flg_zonterest20\'=>true) )->voice();
echo "<br/>";
';
}else{
	parse_str( $_SERVER['QUERY_STRING'], $_query );
$_str.='
$_obj=new Project_Ccs_Twilio_Apps();
$_obj->setSettings( array("app"=>"'.$_query['app'].'","action"=>"'.$_query['action'].'")+unserialize( \''.serialize($_POST).'\' ) )->run();
echo "<br/>";
';
}
Core_Files::setContent($_str,'./voice.txt');

$_obj=new Project_Ccs_Twilio_Apps();
$_obj->setSettings( $_REQUEST )->run();
?>
