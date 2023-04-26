<?php
// Z:\home\cnm.local\svn\trunk\services\crontab\efunnels.php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

/** create a directory if not */
if(!is_dir(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR)){
	mkdir(Zend_Registry::get('config')->path->absolute->logfiles . 'part' . DIRECTORY_SEPARATOR);
}


exit;

$_obj=new Project_Efunnel_Sender();
$_obj->combine(1);
?>