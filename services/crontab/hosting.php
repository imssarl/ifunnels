<?php
/**
 * Крон скрипт проверяющий хостинг на предмет не использующихся доменов
 * чистит и удаляет.
 */
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
$_hosting=new Project_Placement_Hosting();
$_hosting->check2delete();
?>