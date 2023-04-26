<?php
header("Access-Control-Allow-Origin: *");
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir(dirname(__FILE__));
chdir('../');
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

require_once Zend_Registry::get('config')->path->absolute->library . 'vendor' . DIRECTORY_SEPARATOR . 'autoload.php';

/** Set Stripe API key */
\Stripe\Stripe::setApiKey(Project_Deliver_Stripe::getSecretKey());

// You can find your endpoint's secret in your webhook settings
$endpoint_secret = Project_Deliver_Stripe::WEBHOOK_ID;

$request    = @file_get_contents('php://input');
$sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];

$event = null;

try {
    $event = \Stripe\Webhook::constructEvent($request, $sig_header, $endpoint_secret);
} catch (\UnexpectedValueException $e) {
    /** Invalid payload */
    file_put_contents('php://output', json_encode(['status' => 'error', 'message' => $e->getMessage()]));
    http_response_code(400);
    exit();
} catch (\Stripe\Exception\SignatureVerificationException $e) {
    /** Invalid signature */
    file_put_contents('php://output', json_encode(['status' => 'error', 'message' => $e->getMessage()]));
    http_response_code(400);
    exit();
}

Project_Deliver_Log::log($event);

/** Handle the customer.subscription.updated event */
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

http_response_code(200);
