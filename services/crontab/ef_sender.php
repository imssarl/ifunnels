<?php
// Z:\home\cnm.local\svn\trunk\services\crontab\efunnels.php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir(dirname(__FILE__));
chdir('../../');
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

// if (Core_Sql::isLocked('lpb_efunnels_mailer')) {
//     echo "Table is locked " . time();
//     exit();
// }

$_obj = new Project_Efunnel_Mailer();
$_obj->sender();
