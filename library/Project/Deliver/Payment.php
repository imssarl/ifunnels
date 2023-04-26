<?php

class Project_Deliver_Payment extends Core_Data_Storage
{
    protected $_table  = 'deliver_payment';
    protected $_fields = ['id', 'user_id', 'membership_id', 'customer_id', 'type_payment', 'subscription_id', 'payment_intent', 'status', 'amount', 'added'];

    private $_withPaymentIntentId  = false;
    private $_withEmail            = false;
    private $_withCustomerName     = false;
    private $_withMembershipName   = false;
    private $_withShow             = false;
    private $_withTransactionsType = false;
    private $_onlySuccess          = false;
    private $_withoutOneTime       = false;
    private $_onlyFailed           = false;

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_payment");

        Core_Sql::setExec(
            "CREATE TABLE `deliver_payment` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`user_id` INT(11) NOT NULL DEFAULT '0',
				`membership_id` INT(11) NOT NULL DEFAULT '0',
				`customer_id` INT(11) NULL DEFAULT NULL,
				`type_payment` TINYINT(4) NULL DEFAULT NULL,
				`subscription_id` TEXT NULL,
				`payment_intent` TEXT NULL,
				`status` VARCHAR(255) NULL DEFAULT NULL,
				`amount` INT(11) NOT NULL DEFAULT 0,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB"
        );
    }

    public static function getInstance()
    {
        return new self();
    }

    public function withPaymentIntentId($payment_intent_id)
    {
        $this->_withPaymentIntentId = $payment_intent_id;
        return $this;
    }

    public function withEmail($email)
    {
        $this->_withEmail = $email;
        return $this;
    }

    public function withCustomerName()
    {
        $this->_withCustomerName = true;
        return $this;
    }

    public function withMembershipName()
    {
        $this->_withMembershipName = true;
        return $this;
    }

    public function withShow($type)
    {
        $this->_withShow = $type;
        return $this;
    }

    public function withTransactionsType($type)
    {
        switch ($type) {
            case 'failed':
                $this->onlyFailed();
                break;

            case 'successful':
                $this->onlySuccess();
                break;

            default:break;
        }
        return $this;
    }

    public function setFilter($filter)
    {
        if (!empty($filter['show'])) {
            $this->withShow($filter['show']);
        }

        if (!empty($filter['transactions'])) {
            $this->withTransactionsType($filter['transactions']);
        }

        return $this;
    }

    public function onlySuccess()
    {
        $this->_onlySuccess = true;
        return $this;
    }

    public function onlyFailed()
    {
        $this->_onlyFailed = true;
        return $this;
    }

    public function withoutOneTime()
    {
        $this->_withoutOneTime = true;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withShow) {
            $_crawler = new Core_Sql_Qcrawler();

            if (in_array($this->_withShow, ['all', 'only_payments'])) {
                $crawler_payment = new Core_Sql_Qcrawler();

                $crawler_payment->set_select('p.id, p.user_id, p.customer_id, 1 AS type, p.status, p.membership_id, p.type_payment, p.amount, p.added');
                $crawler_payment->set_from('deliver_payment p');
                $crawler_payment->set_where('user_id = ' . Core_Sql::fixInjection(Core_Users::$info['id']));
            }

            if (in_array($this->_withShow, ['all', 'only_rebills'])) {
                $crawler_rebills = new Core_Sql_Qcrawler();

                $crawler_rebills->set_select('r.id, r.user_id, c.id as customer_id, 2 AS type, r.status, r.membership_id, 1 as type_payment, r.amount, r.added');
                $crawler_rebills->set_from('deliver_payment_rebills r');
                $crawler_rebills->set_from('LEFT JOIN deliver_customer c ON r.customer_id = c.customer_id');
                $crawler_rebills->set_where('r.user_id = ' . Core_Sql::fixInjection(Core_Users::$info['id']));
            }

            if (isset($crawler_payment)) {
                $_crawler->set_union_select($crawler_payment);
            }

            if (isset($crawler_rebills)) {
                $_crawler->set_union_select($crawler_rebills);
            }

            $this->_crawler->clean_from();
            $this->_crawler->set_from('(' . $_crawler->gen_union_full() . ') d');
        }

        if (!empty($this->_withPaymentIntentId)) {
            $this->_crawler->set_where('d.payment_intent = ' . Core_Sql::fixInjection($this->_withPaymentIntentId));
        }

        if ($this->_withEmail) {
            if (!$this->_withCustomerName) {
                $this->_crawler->set_from('INNER JOIN deliver_customer c ON c.id = d.customer_id AND c.email LIKE "%' . $this->_withEmail . '%"');
            } else {
                $this->_crawler->set_where('c.email LIKE "%' . $this->_withEmail . '%"');
            }
        }

        if ($this->_withCustomerName) {
            $this->_crawler->set_select('c.email as customer_email');
            $this->_crawler->set_from('LEFT JOIN deliver_customer c ON c.id = d.customer_id');
        }

        if ($this->_withMembershipName) {
            $this->_crawler->set_select('m.name as membership');
            $this->_crawler->set_from('INNER JOIN deliver_membership m ON m.id = d.membership_id');
        }

        // Only Success
        if ($this->_onlySuccess) {
            $this->_crawler->set_where('d.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
        }

        // Only Failed
        if ($this->_onlyFailed) {
            $this->_crawler->set_where('d.status NOT IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
        }

        if ($this->_withoutOneTime) {
            $this->_crawler->set_where('d.type_payment = 1');
        }
    }

    public function getPaging(&$arrRes)
    {
        parent::getPaging($arrRes);

        $param = [];

        if ($arrRes['recall'] > 0) {
            $param = array_filter($_GET, function ($key) {
                return strcmp('page', $key) !== 0;
            }, ARRAY_FILTER_USE_KEY);
        }

        $param = array_unique($param);

        if (!empty($param)) {
            $param = http_build_query($param);

            $arrRes['urlmin'] .= '&' . $param;
            $arrRes['urlminus'] .= '&' . $param;
            $arrRes['urlplus'] .= '&' . $param;
            $arrRes['urlmax'] .= '&' . $param;

            foreach ($arrRes['num'] as &$num) {
                $num['url'] .= '&' . $param;
            }
        }

        return $this;
    }

    public function getOneTimePaymentDetails($paymentData, $stripe_account)
    {
        $payment_intent = $paymentData['payment_intent'];
        $amount         = intval($paymentData['amount']);
        $paymentIntent  = Project_Deliver_Stripe::getPaymentIntent($payment_intent, $stripe_account);

        if (array_key_exists('error', $paymentIntent)) {
            return $paymentIntent;
        }

        $customer = new Project_Deliver_Member();
        $customer
            ->onlyOne()
            ->onlyOwner()
            ->withIds($paymentData['customer_id'])
            ->getList($customerData);

        $response = [
            'amount'            => ($paymentIntent->amount / 100),
            'fee_amount'        => $paymentIntent->application_fee_amount / 100,
            'currency'          => $paymentIntent->currency,
            'created'           => $paymentIntent->created,
            'customer'          => $customerData,
            'payment_intent_id' => $payment_intent,
        ];

        if ($amount < $paymentIntent->amount) {
            $response['amount']     = $amount / 100;
            $response['fee_amount'] = ($amount * Project_Deliver_Subscription::getUserFeePercent($paymentData['user_id']) / 100) / 100;
        }

        return $response;
    }

    public function getSubscriptionPaymentDetails($paymentData, $stripe_account)
    {
        $subscription_id = $paymentData['subscription_id'];
        $payment_intent  = $paymentData['payment_intent'];
        $amount          = intval($paymentData['amount']);

        $response = [];

        $subscription = Project_Deliver_Stripe::getSubscription($subscription_id, $stripe_account);

        if (empty($payment_intent)) {
            $invoiceObj = Project_Deliver_Stripe::retriveInvoice($subscription->latest_invoice, $stripe_account);

            $response = [
                'amount'            => $invoiceObj->amount_paid / 100,
                'fee_amount'        => $invoiceObj->application_fee_amount / 100,
                'currency'          => $invoiceObj->currency,
                'payment_intent_id' => $invoiceObj->payment_intent,
            ];
        } else {
            $paymentIntent = Project_Deliver_Stripe::getPaymentIntent($payment_intent, $stripe_account);

            $response = [
                'amount'            => $paymentIntent->amount / 100,
                'fee_amount'        => $paymentIntent->application_fee_amount / 100,
                'currency'          => $paymentIntent->currency,
                'payment_intent_id' => $paymentIntent->id,
            ];

            if ($amount < $paymentIntent->amount) {
                $response['amount']     = $amount / 100;
                $response['fee_amount'] = ($amount * Project_Deliver_Subscription::getUserFeePercent($paymentData['user_id']) / 100) / 100;
            }
        }

        $customer = new Project_Deliver_Member();

        $customer
            ->onlyOne()
            ->onlyOwner()
            ->withIds($paymentData['customer_id'])
            ->getList($customerData);

        $response['created']  = $subscription->created;
        $response['customer'] = $customerData;

        return $response;
    }

    public function refundPayment($payment_id, $stripe_account)
    {
        $this
            ->withIds($payment_id)
            ->onlyOne()
            ->onlyOwner()
            ->getList($paymentData);

        $refund = Project_Deliver_Stripe::refundPayment(
            [
                'payment_intent' => $paymentData['payment_intent'],
                'amount'         => $paymentData['amount'],
                'reason'         => 'requested_by_customer',
            ], 
            $stripe_account
        );

        if ($refund->status == 'succeeded') {
            // TODO Возможна ошибка с доступом, нет обновления статуса у записи в deliver_subscription
            $this
                ->setEntered(
                    [
                        'id'     => $payment_id, 
                        'status' => 'refunded',
                    ]
                )
                ->set();

            if ($paymentData['subscription_id']) {
                $subscription = Project_Deliver_Stripe::getSubscription($paymentData['subscription_id'], $stripe_account);
                $subscription = $subscription->delete();
            }

            Project_Deliver_Subscription::updStatusAfterRefund($paymentData['customer_id'], $paymentData['membership_id'], 'refunded');
        } else {
            return ['error' => $refund];
        }
    }

    protected function init()
    {
        parent::init();

        $this->_withPaymentIntentId  = false;
        $this->_withEmail            = false;
        $this->_withCustomerName     = false;
        $this->_withMembershipName   = false;
        $this->_withShow             = false;
        $this->_withTransactionsType = false;
        $this->_onlySuccess          = false;
        $this->_onlyFailed           = false;
        $this->_withoutOneTime       = false;
    }

}
