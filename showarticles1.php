<?php
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
Core_Errors::off();
error_reporting(E_ALL);
$view = new Project_Options_HtmlGenerator();
$_GET['type_view'] = 'showarticles';
$view->init($_GET);
?>