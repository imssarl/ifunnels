<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
// а тут запуск нужного класса - метода
error_reporting(E_ALL);
header( "HTTP/1.1 200 OK" );

if($_GET['type_view']=='snippetsshow'){
	if (!empty($_GET['id']) && !is_numeric($_GET['id'])) {
		$id = intval(Project_Options_Encode::decode($_GET['id']));
	} elseif(isset($_GET['id'])) {
		$id = intval($_GET['id']);
	}
	$obj=new Project_Widget();
	$obj->setSettings( array('name'=>'Copt','action'=>'get','id'=>$id, 'old'=>true ) )->run();
	die();
}

if( $_GET['type_view']=='snippetstrack'){
	$obj=new Project_Widget();
	$obj->setSettings( array('name'=>'Copt','action'=>'set','id'=>$_GET['id']) )->run();
	die();
}

$view = new Project_Options_HtmlGenerator();
$view->init($_GET);
?>