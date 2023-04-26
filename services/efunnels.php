<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
error_reporting(E_ALL);
ini_set('display_startup_errors',1);
ini_set('display_errors',1);

$_obj=new Project_Efunnel();
$_obj->send();
?>