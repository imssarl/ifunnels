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

$event        = json_decode($_POST['json']);
$subscription = $event->data->object;

$payment = new Project_Deliver_Subscription();

$payment
    ->withSubscriptionId($subscription->id)
    ->onlyOne()
    ->getList($subData);

if (empty($subData)) {
    echo json_encode(['error' => 'Sub not found']);
    exit();
}

try {
    $invoice = Project_Deliver_Stripe::retriveInvoice($subscription->latest_invoice, Project_Deliver_Stripe::getStripeAccountId($subData['user_id']));
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
    exit();
}

$amount = $invoice->amount_paid;

// Calc total amount
$total_amount = intval($subData['total_amount']) + intval($amount);

$rebill = new Project_Deliver_Rebills();
$rebill
    ->setEntered(
        [
            'user_id'       => $subData['user_id'],
            'payment_id'    => $subData['id'],
            'membership_id' => $subData['plan_id'],
            'customer_id'   => $subscription->customer,
            'amount'        => $amount,
            'status'        => $subscription->status,
            'data'          => json_encode($subscription),
            'added'         => $event->created,
        ]
    )
    ->set();

$payment
    ->setEntered(
        [
            'id'           => $subData['id'],
            'total_amount' => $total_amount,
        ]
    )
    ->set();
exit();
