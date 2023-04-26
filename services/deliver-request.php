<?php
header('Access-Control-Allow-Origin: *');
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ERROR);
ini_set('display_errors', 'E_ERROR'); // 1

chdir(dirname(__FILE__));
chdir('../');
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

require_once Zend_Registry::get('config')->path->absolute->library . 'vendor' . DIRECTORY_SEPARATOR . 'autoload.php';

if ($input = json_decode(file_get_contents('php://input'))) {
    $errors = [];

    /** Set user ID */
    if (!empty($input->uid)) {
        Core_Users::getInstance()->setById($input->uid);
    }

    if (empty($input->action)) {
        http_response_code(400);
        exit();
    }

    echo json_encode(Project_Deliver_Request::getInstance()->setAction($input->action, $input->data)->runAction());
    http_response_code(200);

    exit();
}

http_response_code(400);
