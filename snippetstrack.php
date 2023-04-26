<?php
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
Core_Errors::off();
error_reporting(E_ALL);
$obj=new Project_Widget();
$obj->setSettings( array('name'=>'Copt','action'=>'set','id'=>$_GET['id']) )->run();
?>