<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
Core_Errors::off();
$pay=new Core_Payment_Service();
$pay->setAdapter( $_GET['type'] )->setParams( $_POST )->run();
?>