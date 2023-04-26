<?php
set_time_limit(3600);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
$prj=new Project_Publisher_Arrange();
$prj->run();
?>