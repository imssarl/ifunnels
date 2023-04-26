<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT');
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
if(empty($_GET['id'])) return;
$_mooptin = new Project_Mooptin();
$_mooptin->withIds( $_GET['id'] )->onlyOne()->getList( $_arrMoData );
echo str_replace("\r\n", '', Project_Mooptin::generateForm( $_arrMoData['settings']['optin_form'], $_arrMoData['settings']['form'], $_arrMoData['id'] ));
?>