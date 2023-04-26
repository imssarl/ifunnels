<?php

/**
 * iFunnels: Module Deliver
 *
 * Description: Pause discounts
 */

chdir(dirname(__FILE__));
chdir('../../');
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php';
WorkHorse::shell();

error_reporting(E_ALL);
header("HTTP/1.1 200 OK");

Project_Deliver_DisCount::run();
