<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
error_reporting(E_ALL);
Core_Files::getContent($_str,'./sms.txt');
$_str.="\n".date('d.m.Y H:i:s').' - '.serialize($_REQUEST);
Core_Files::setContent($_str,'./sms.txt');
$_sms=new Project_Ccs_Twilio_Service();
$_sms->setSettings( $_REQUEST+array('flg_zonterest20'=>true) )->sms();
?>