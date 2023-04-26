<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

$data=file_get_contents("php://input");
$events=json_decode($data, true);

$_fileName=time();
file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_webhook/'.$_fileName.'.log', serialize( $events ), FILE_APPEND);
chmod('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_webhook/'.$_fileName.'.log', 0755);

echo 'true';

?>