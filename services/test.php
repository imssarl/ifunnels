<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir(dirname(__FILE__));
chdir('../');
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

p($_REQUEST);
$event = json_decode($_GET['json']);

var_dump($event, $_GET['json']);
exit();

if ($event->type == 'customer.subscription.updated') {
    $subscription = $event->data->object;

    $response = Project_Deliver_Subscription::updateStatusSubscription(
        [
            'subid'   => $subscription->id,
            'status'  => $subscription->status,
            'invoice' => $event->data->object->latest_invoice,
        ],
        $subscription
    );

    if ($response) {
        file_put_contents('php://output', json_encode(['status' => 'succeeded', 'message' => 'Status was succeeded updated']));
    } else {
        $errors = Core_Data_Errors::getInstance()->getErrors()['errFlow'];
        file_put_contents('php://output', json_encode(['status' => 'error', 'message' => empty($errors) ? 'An error occurred while updating' : $errors]));
    }
}
