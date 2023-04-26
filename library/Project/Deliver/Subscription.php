<?php

class Project_Deliver_Subscription extends Core_Data_Storage
{
    protected $_table = 'deliver_subscription';

    protected $_fields = ['id', 'site_id', 'user_id', 'plan_id', 'customer_id', 'type_payment', 'one_payment_id', 'subscription_id', 'payment_intent', 'status', 'settings', 'refund_part', 'refund_amount', 'amount', 'total_amount', 'added'];
    /**
     *
     */

    const STATUS_SUCCEEDED = 'succeeded', STATUS_TRIAL = 'trial', STATUS_CANCELED = 'canceled', STATUS_REFUNDED = 'refunded';

    const ACTIVE   = ['active', 'succeeded', 'trial'];
    const CANCELED = ['canceled', 'incomplete_expired', 'past_due', 'refunded', 'requires_confirmation', 'requires_payment_method'];

    private $_withPaymentId       = false;
    private $_withPaymentIntentId = false;
    private $_withSubscriptionId  = false;
    private $_withMembershipName  = false;
    private $_withCustomerName    = false;
    private $_withUserId          = false;
    private $_withCustomerId      = false;
    private $_withMembershipIds   = false;
    private $_withFilter          = false;
    private $_withTime            = false;
    private $_withStatus          = false;
    private $_withLimit           = false;
    private $_withCurrency        = false;
    private $_withEmail           = false;
    private $_withRebills         = false;
    private $_onlySuccess         = false;
    private $_onlyFailed          = false;
    private $_withoutOneTime      = false;

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_subscription");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_subscription` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`site_id` INT(11) NOT NULL DEFAULT '0',
				`user_id` INT(11) NOT NULL DEFAULT '0',
				`plan_id` INT(11) NOT NULL DEFAULT '0',
				`customer_id` VARCHAR(255) NULL DEFAULT NULL,
				`type_payment` TINYINT(4) NULL DEFAULT NULL,
				`one_payment_id` TEXT NULL,
				`subscription_id` TEXT NULL,
				`payment_intent` TEXT NULL,
				`status` VARCHAR(255) NULL DEFAULT NULL,
				`settings` TEXT NULL,
                `refund_part` TINYINT(1) NOT NULL DEFAULT '0',
                `refund_amount` INT(11) NOT NULL DEFAULT '0',
				`amount` INT(11) NOT NULL DEFAULT 0,
				`total_amount` INT(11) NOT NULL DEFAULT 0,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB"
        );
    }

    public function beforeSet()
    {
        $this->_data->setFilter(array('clear'));

        /** Check field [site_id] */
        if (empty($this->_data->filtered['id']) && empty($this->_data->filtered['site_id'])) {
            return Core_Data_Errors::getInstance()->setError('Not selected a site');
        }

        if (!empty($this->_data->filtered['settings'])) {
            $this->_data->setElement('settings', serialize($this->_data->filtered['settings']));
        }

        if (empty($this->_data->filtered['id'])) {
            $paymentData                  = $this->_data->filtered;
            $paymentData['membership_id'] = $paymentData['plan_id'];

            if ($paymentData['refund_part']) {
                $paymentData['amount'] = $paymentData['refund_amount'];
            }

            unset($paymentData['id'], $paymentData['plan_id'], $paymentData['refund_part'], $paymentData['refund_amount']);

            Project_Deliver_Payment::getInstance()
                ->setEntered($paymentData)
                ->set();
        }

        return true;
    }

    public function withPaymentId($payment_id)
    {
        if (!empty($payment_id)) {
            $this->_withPaymentId = $payment_id;
        }

        return $this;
    }

    public function withPaymentIntentId($payment_intent_id)
    {
        $this->_withPaymentIntentId = $payment_intent_id;
        return $this;
    }

    public function withSubscriptionId($subscriptionId)
    {
        if (!empty($subscriptionId)) {
            $this->_withSubscriptionId = $subscriptionId;
        }

        return $this;
    }

    public function withMembershipName()
    {
        $this->_withMembershipName = true;
        return $this;
    }

    public function withCustomerName()
    {
        $this->_withCustomerName = true;
        return $this;
    }

    public function withUserId($userId)
    {
        if (!empty($userId)) {
            $this->_withUserId = $userId;
        }

        return $this;
    }

    public function withCustomerId($customer_id)
    {
        $this->_withCustomerId = $customer_id;
        return $this;
    }

    public function withMembershipIds($membership_ids)
    {
        $this->_withMembershipIds = $membership_ids;
        return $this;
    }

    public function withFilter($filter)
    {
        if (!empty($filter['time'])) {
            $this->withTime($filter['time'], $filter['date_from'], $filter['date_to']);
        }

        if (!empty($filter['membership'])) {
            $this->withMembershipIds($filter['membership']);
        }

        if (!empty($filter['status'])) {
            $this->withStatus($filter['status'] === 'active' ? self::ACTIVE : self::CANCELED);
        }

        return $this;
    }

    public function withTime($_type, $from, $to)
    {
        $_now = time();

        switch ($_type) {
            case Project_Statistics_Api::TIME_ALL:$this->_withTime = ['from' => 0, 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_TODAY:$this->_withTime = ['from' => strtotime('today'), 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_YESTERDAY:$this->_withTime = ['from' => strtotime('yesterday'), 'to' => strtotime('today')];
                break;
            case Project_Statistics_Api::TIME_LAST_7_DAYS:$this->_withTime = ['from' => $_now - 60 * 60 * 24 * 7, 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_THIS_MONTH:$this->_withTime = ['from' => strtotime('first day of this month'), 'to' => $_now];
                break;
            case Project_Statistics_Api::THIS_YEAR:$this->_withTime = ['from' => strtotime('first day of January ' . date('Y')), 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_LAST_YEAR:$this->_withTime = ['from' => $_now - 60 * 60 * 24 * 365, 'to' => $_now];
                break;
            case 8:
                $_from = $from;
                if (!is_int($from)) {
                    $_from = strtotime($from);
                }
                $_to = $to;
                if (!is_int($to)) {
                    $_to = strtotime($to);
                }

                $this->_withTime = ['from' => $_from, 'to' => $_to];
                break;
        }

        return $this;
    }

    public function withStatus($status)
    {
        $this->_withStatus = $status;
        return $this;
    }

    public function withLimit($limit)
    {
        if (is_integer($limit)) {
            $this->_withLimit = $limit;
        }

        return $this;
    }

    public function withCurrency()
    {
        $this->_withCurrency = true;
        return $this;
    }

    public function withEmail($email)
    {
        $this->_withEmail = $email;
        return $this;
    }

    public function withRebills()
    {
        $this->_withRebills = true;
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
        if ($this->_withRebills) {
            $_crawlerP = new Core_Sql_Qcrawler();
            $_crawlerP->set_select('p.id, p.user_id, p.status, p.amount as total_amount, p.type_payment, p.added, 1 as type');
            $_crawlerP->set_from($this->_table . ' p');

            $_crawlerR = new Core_Sql_Qcrawler();
            $_crawlerR->set_select('r.id, r.user_id, r.status, r.amount as total_amount, null as type_payment, r.added, 2 as type');
            $_crawlerR->set_from('deliver_payment_rebills r');

            // Owner
            if ($this->_onlyOwner) {
                $_crawlerP->set_where('p.user_id = ' . Core_Users::$info['id']);
                $_crawlerR->set_where('r.user_id = ' . Core_Users::$info['id']);
            }

            // Membership Name
            if ($this->_withMembershipName) {
                $_crawlerP->set_select('m.name as membership');
                $_crawlerP->set_from('RIGHT JOIN deliver_membership m ON m.id = p.plan_id');

                $_crawlerR->set_select('m.name as membership');
                $_crawlerR->set_from('RIGHT JOIN deliver_membership m ON m.id = r.membership_id');
            }

            // Customer Email
            if ($this->_withCustomerName) {
                $_crawlerP->set_select('c.email as customer_email');
                $_crawlerP->set_from('RIGHT JOIN deliver_customer c ON c.id = p.customer_id');

                $_crawlerR->set_select('c.email as customer_email');
                $_crawlerR->set_from('RIGHT JOIN deliver_customer c ON c.customer_id = r.customer_id');
            }

            // Currency
            if ($this->_withCurrency) {
                $_crawlerP->set_select('s.currency as currency');
                $_crawlerP->set_from('RIGHT JOIN `deliver_site` s ON s.id = p.site_id');

                $_crawlerR->set_select('s.currency as currency');
                $_crawlerR->set_from('RIGHT JOIN `deliver_site` s ON s.id = m.site_id');
            }

            // Search by email
            if ($this->_withEmail) {
                if (!$this->_withCustomerName) {
                    $_crawlerP->set_from('RIGHT JOIN deliver_customer c ON c.id = p.customer_id AND c.email LIKE "%' . $this->_withEmail . '%"');
                    $_crawlerR->set_from('RIGHT JOIN deliver_customer c ON c.customer_id = r.customer_id AND c.email LIKE "%' . $this->_withEmail . '%"');
                } else {
                    $_crawlerP->set_where('c.email LIKE "%' . $this->_withEmail . '%"');
                    $_crawlerR->set_where('c.email LIKE "%' . $this->_withEmail . '%"');
                }
            }

            // Only Success
            if ($this->_onlySuccess) {
                $_crawlerP->set_where('p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
                $_crawlerR->set_where('r.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
            }

            // Only Failed
            if ($this->_onlyFailed) {
                $_crawlerP->set_where('p.status NOT IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
                $_crawlerR->set_where('r.status NOT IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
            }

            $this->_crawler->set_union_select($_crawlerP);
            $this->_crawler->set_union_select($_crawlerR);

            $this->_crawler->clean_order();
            $this->_crawler->set_order('added DESC');

            return;
        }

        parent::assemblyQuery();

        if (!empty($this->_withPaymentId)) {
            $this->_crawler->set_where('d.one_payment_id=' . Core_Sql::fixInjection($this->_withPaymentId));
        }

        if (!empty($this->_withSubscriptionId)) {
            $this->_crawler->set_where('d.subscription_id=' . Core_Sql::fixInjection($this->_withSubscriptionId));
        }

        if (!empty($this->_withPaymentIntentId)) {
            $this->_crawler->set_where('d.payment_intent=' . Core_Sql::fixInjection($this->_withPaymentIntentId));
        }

        if ($this->_withMembershipName) {
            $this->_crawler->set_select('m.name as membership, m.type as type');
            $this->_crawler->set_from('INNER JOIN deliver_membership m ON m.id = d.plan_id');
        }

        if ($this->_withCustomerName) {
            $this->_crawler->set_select('c.email as customer_email');
            $this->_crawler->set_from('INNER JOIN deliver_customer c ON c.id = d.customer_id');
        }

        if ($this->_withEmail) {
            if (!$this->_withCustomerName) {
                $this->_crawler->set_from('INNER JOIN deliver_customer c ON c.id = d.customer_id AND c.email LIKE "%' . $this->_withEmail . '%"');
            } else {
                $this->_crawler->set_where('c.email LIKE "%' . $this->_withEmail . '%"');
            }
        }

        if (!empty($this->_withCustomerId)) {
            $this->_crawler->set_where('d.customer_id = ' . Core_Sql::fixInjection($this->_withCustomerId));
        }

        if (!empty($this->_withMembershipIds)) {
            $this->_crawler->set_where('d.plan_id IN (' . Core_Sql::fixInjection($this->_withMembershipIds) . ')');
        }

        if ($this->_withTime) {
            $this->_crawler->set_where('d.added >= ' . $this->_withTime["from"] . ' AND d.added <= ' . $this->_withTime["to"]);
        }

        if (!empty($this->_withStatus)) {
            $this->_crawler->set_where('d.status IN (' . Core_Sql::fixInjection($this->_withStatus) . ')');
        }

        if ($this->_withLimit) {
            $this->_crawler->set_limit($this->_withLimit);
        }

        if ($this->_withCurrency) {
            $this->_crawler->set_select('s.currency as currency');
            $this->_crawler->set_from('RIGHT JOIN `deliver_site` s ON s.id = d.site_id');
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

        // $this->_crawler->get_sql($_strSql, $this->_paging);
        // var_dump($_strSql);
    }

    protected function init()
    {
        parent::init();

        $this->_withPaymentId       = false;
        $this->_withSubscriptionId  = false;
        $this->_withMembershipName  = false;
        $this->_withCustomerName    = false;
        $this->_withCustomerId      = false;
        $this->_withMembershipIds   = false;
        $this->_withPaymentIntentId = false;
        $this->_withFilter          = false;
        $this->_withTime            = false;
        $this->_withStatus          = false;
        $this->_withLimit           = false;
        $this->_withCurrency        = false;
        $this->_withEmail           = false;
        $this->_withRebills         = false;
        $this->_onlySuccess         = false;
        $this->_onlyFailed          = false;
        $this->_withoutOneTime      = false;
    }

    /** Check status of payments for user
     *
     * @param [int] - Customer ID of the module Deliver
     * @param [array] - List of memberships ID
     *
     * @return [boolean] - Return status payment true or false
     */
    public static function checkStatusPayment($customer_id, $membership_ids, &$paymentsData = false)
    {

        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membership_ids)
            ->getList($membershipData);

        $freeMemberships = array_filter($membershipData, function ($data) {
            return $data['type'] === '0';
        });

        if (!empty($freeMemberships)) {
            return true;
        }

        $connection = new Project_Deliver_SignIn_Connection();

        $connection
            ->withCustomerId($customer_id)
            ->withMembershipId($membership_ids)
            ->addedByUser()
            ->getList($accessData);

        if (!empty($accessData)) {
            return true;
        }

        $self = new self();
        $self
            ->withCustomerId($customer_id)
            ->withMembershipIds($membership_ids)
            ->getList($dataObj);

        if ($paymentsData !== false) {
            $paymentsData = $dataObj;
        }

        $status = false;

        if (!empty($dataObj)) {
            foreach ($dataObj as $item) {
                if (in_array($item['status'], ['trialing', 'active', 'succeeded', 'trial'])) {
                    $status = true;
                }
            }
        }

        return $status;
    }

    public function getList(&$mixRes)
    {
        if (!$this->_withRebills) {
            parent::getList($mixRes);
        } else {
            $this->_crawler = new Core_Sql_Qcrawler();
            $this->assemblyQuery();

            if (!empty($this->_withPaging)) {
                $this->_crawler->set_paging($this->_withPaging)->get_union_sql($_strSql, $this->_paging);
            } elseif (!$this->_onlyCount) {
                $this->_crawler->gen_union_full($_strSql);
            }

            $mixRes            = Core_Sql::getAssoc($_strSql);
            $this->_isNotEmpty = !empty($mixRes);
        }

        $this->init();
        return $this;
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

    /**
     * Update status of subscription
     *
     * @param [array] $options
     * @return void
     */
    public static function updateStatusSubscription($options, $object)
    {
        extract($options);

        $payment = new self();
        $payment
            ->withSubscriptionId($subid)
            ->onlyOne()
            ->getList($subData);

        if (empty($subData)) {
            Core_Data_Errors::getInstance()->setError("Does not exist membership: $subid");
            return false;
        }

        try {
            $invoice = Project_Deliver_Stripe::retriveInvoice($invoice, Project_Deliver_Stripe::getStripeAccountId($subData['user_id']));
        } catch (Exception $e) {
            Core_Data_Errors::getInstance()->setError($e->getMessage());
            return false;
        }

        // if (!in_array($invoice->status, ['open', 'paid'])) {
        //     Core_Data_Errors::getInstance()->setError("The invoice does not have one of the statuses: ['open', 'paid']. Status: " . $invoice->status);
        //     return false;
        // }

        $amount = $invoice->amount_paid;

        // Calc total amount
        $total_amount = intval($subData['total_amount']) + intval($amount);

        if (isset($status) && !empty($status)) {
            return $payment
                ->setEntered(
                    [
                        'id'           => $subData['id'],
                        'status'       => $status,
                        'total_amount' => $total_amount,
                    ]
                )
                ->set() && Project_Deliver_Rebills::add($object, $invoice->total, $invoice->id);
        }
    }

    /** Update status for payment
     *
     * @param [array] - Array with options
     * @return [boolean] - Return true or false
     */
    public static function updateStatusPayment($options)
    {
        extract($options);
        $subscription = new self();

        if (isset($id)) {
            $subscription
                ->withIds($id)
                ->onlyOne()
                ->getList($paymentData);

            if (empty($paymentData)) {
                return false;
            }

            $paymentData['status']       = $status;
            $paymentData['total_amount'] = $amount;
            $paymentData['amount']       = $amount;

            return $subscription->setEntered($paymentData)->set();
        }

        if (isset($payment_intent_id)) {
            $subscription
                ->withPaymentIntentId($payment_intent_id)
                ->getList($subsData);

            if (empty($subsData)) {
                return false;
            }

            $subsData = array_map(function ($sub) use ($status, $amount) {
                $sub['status'] = $status;

                if (isset($sub['refund_amount']) && $sub['refund_part'] == '1') {
                    $sub['total_amount'] = $sub['refund_amount'];
                    $sub['amount']       = $sub['refund_amount'];
                } else {
                    $sub['total_amount'] = $amount;
                    $sub['amount']       = $amount;
                }

                return $sub;
            }, $subsData);

            $payment = new Project_Deliver_Payment();

            $payment
                ->withPaymentIntentId($payment_intent_id)
                ->getList($paymentData);

            $paymentData = array_map(function ($pay) use ($status, $amount) {
                $pay['status'] = $status;
                // $pay['amount'] = $amount;
                return $pay;
            }, $paymentData);

            $payment
                ->setEntered($paymentData)
                ->setMass();

            return $subscription->setEntered($subsData)->setMass();
        }
    }

    public static function updStatusAfterRefund($customer_id, $membership_id, $status) 
    {
        if (empty($customer_id) || empty($membership_id)) {
            throw new Exception("Error Processing Request", 1);
        }

        $instance = new self();

        $instance
            ->withMembershipIds($membership_id)
            ->withCustomerId($customer_id)
            ->onlyOne()
            ->getList($subscriptionData);

        if (!empty($subscriptionData)) {
            $subscriptionData['status'] = $status;
            $instance
                ->setEntered($subscriptionData)
                ->set();
        }
    }

    /**
     * Create subscription
     *
     * @param [int] $membershipId
     * @param [string] $payment_method_id
     * @param [string] $email
     * @param boolean $trial
     * @param [string] $paymentIntent
     * @param [string] $stripe_account
     * @return void
     */
    public static function createSubscription($membershipId, $payment_method_id, $email, $trial = false, $paymentIntent = null, $stripe_account)
    {
        /** Get data of a plan */
        $membership = new Project_Deliver_Membership();

        $membership
            ->withIds($membershipId)
            ->onlyOne()
            ->getList($planData);

        if (empty($planData)) {
            return false;
        }

        $member = new Project_Deliver_Member();

        $member
            ->withEmail($email)
            ->onlyOne()
            ->getList($customer);

        /** Check a customer exist */
        if (empty($customer)) {
            /** Create new customer */
            $customer = Project_Deliver_Member::createCustomer(
                [
                    'payment_method' => $payment_method_id,
                    'email'          => $email,
                    'site_id'        => $planData['site_id'],
                    'user_id'        => $planData['user_id'],
                ],
                $stripe_account
            );
        }

        if (empty($customer)) {
            return false;
        }

        if (!empty($planData['add_charges']) && $planData['add_charges_frequency'] == '0') {
            $site = new Project_Deliver_Site();

            $site
                ->onlyOne()
                ->withIds($planData['site_id'])
                ->getList($siteData);

            $amount = floatval($planData['add_charges']) * 100;

            if (!empty($planData['add_taxes'])) {
                $amount += intval($amount * floatval($planData['add_taxes']) / 100);
            }

            Project_Deliver_Stripe::setInvoiceItem([
                'amount'      => $amount,
                'currency'    => strtolower($siteData['currency']),
                'customer'    => $customer['customer_id'],
                'description' => (!empty($planData['label_charges']) ? $planData['label_charges'] : 'Additional Charges'),
            ], $stripe_account);
        }

        /** Create Subscription on stripe.com and add to customer */
        $subscriptionData = [
            'customer'                => $customer['customer_id'],
            'items'                   => [
                [
                    'plan' => $planData['stripe_plan_id'],
                ],
            ],
            'application_fee_percent' => self::getUserFeePercent($planData['user_id']),
            'expand'                  => ['latest_invoice.payment_intent'],
        ];

        /** Limit rebills */
        if (!empty($planData['limit_rebills'])) {
            $subscriptionData['cancel_at'] = strtotime(sprintf('+%s %s', $planData['limit_rebills'], $planData['billing_frequency']));
        }

        /** Trial */
        if ($trial && !empty($planData['trial_duration'])) {
            $subscriptionData['trial_period_days'] = intval($planData['trial_duration']);
        }

        $subscription = Project_Deliver_Stripe::setSubscription($subscriptionData, $stripe_account);

        /** Set data about subscription on table */
        $payment = new self();

        $payment->setEntered([
            'site_id'         => $planData['site_id'],
            'plan_id'         => $planData['id'],
            'user_id'         => $planData['user_id'],
            'customer_id'     => $customer['id'],
            'type_payment'    => '1',
            'payment_intent'  => $paymentIntent,
            'subscription_id' => $subscription->id,
        ])->set();

        return $subscription;
    }

    /** Create PaymentIntent on stripe.com
     *
     * @param [string] - Membership ID on a module Deliver
     * @param [string] - Customer ID on a stripe.com
     *
     * @return [array]
     */
    public static function createPaymentIntent($membershipid, $cid, $paymentMethod, $trial, $discount, $order_bump, $stripe_account)
    {
        /** Membership Data */
        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membershipid)
            ->onlyOne()
            ->getList($membershipData);

        if (empty($membershipData)) {
            return false;
        }

        /** Order Bump */
        if (!empty($order_bump) && is_array($order_bump)) {
            $membership
                ->withIds($order_bump)
                ->onlyOwner()
                ->getList($bumpList);
        }

        /** Site Data */
        $site = new Project_Deliver_Site();
        $site
            ->withIds($membershipData['site_id'])
            ->onlyOne()
            ->getList($siteData);

        $member = new Project_Deliver_Member();
        $member
            ->withCustomerId($cid)
            ->onlyOne()
            ->getList($memberData);

        if (empty($memberData)) {
            return false;
        }

        $instance = new Project_Deliver_DisCount();

        if (!empty($discount)) {
            $instance
                ->withIds($discount)
                ->onlyOne()
                ->onlyOwner()
                ->getList($discountData);

            $discountData = $instance->calcDisCount($discountData);
        }

        /** One time payment */
        if ($membershipData['frequency'] == '0') {
            $paymentIntentData = [
                'amount'               => floatval($membershipData['amount']) * 100,
                'currency'             => strtolower($siteData['currency']),
                'customer'             => $cid,
                'payment_method_types' => ['card'],
                'receipt_email'        => $memberData['email'],
                'payment_method'       => $paymentMethod,
            ];

            $paymentList = [];

            /** Add charges */
            if (!empty($membershipData['add_charges'])) {
                $paymentIntentData['amount'] += floatval($membershipData['add_charges']) * 100;
            }

            /** Add taxes */
            if (!empty($membershipData['add_taxes'])) {
                $paymentIntentData['amount'] += intval($paymentIntentData['amount'] * floatval($membershipData['add_taxes']) / 100);
            }

            $total_amount = $paymentIntentData['amount'];

            /** Order Bump */
            if (!empty($bumpList)) {
                foreach ($bumpList as $bump) {
                    $paymentIntentData['amount'] += floatval($bump['calc_amount']) * 100;
                }
            }

            // Discount
            if (!empty($discount)) {
                $paymentIntentData['amount'] = $instance->getDiscountAmount($discountData, $paymentIntentData['amount']);
                $total_amount                = $instance->getDiscountAmount($discountData, $total_amount);
            }

            /** Add application fee amount */
            $paymentIntentData['application_fee_amount'] = intval($paymentIntentData['amount'] * self::getUserFeePercent($membershipData['user_id']) / 100); // TODO: this application fee percent

            $paymentIntent = Project_Deliver_Stripe::setPaymentIntent($paymentIntentData, $stripe_account);

            $paymentList[] = [
                'site_id'        => $membershipData['site_id'],
                'plan_id'        => $membershipData['id'],
                'user_id'        => $membershipData['user_id'],
                'customer_id'    => $memberData['id'],
                'type_payment'   => '0',
                'payment_intent' => $paymentIntent->id,
                'status'         => $paymentIntent->status,
                'refund_part'    => !empty($bumpList),
                'refund_amount'  => $total_amount,
            ];

            if (!empty($bumpList)) {
                foreach ($bumpList as $bump) {
                    $paymentList[] = [
                        'site_id'        => $bump['site_id'],
                        'plan_id'        => $bump['id'],
                        'user_id'        => $bump['user_id'],
                        'customer_id'    => $memberData['id'],
                        'type_payment'   => '0',
                        'payment_intent' => $paymentIntent->id,
                        'status'         => $paymentIntent->status,
                        'refund_part'    => 1,
                        'refund_amount'  => floatval($bump['calc_amount']) * 100,
                    ];

                    // Discount
                    if (!empty($discount)) {
                        $index                                = sizeof($paymentList) - 1;
                        $paymentList[$index]['refund_amount'] = $instance->getDiscountAmount($discountData, $paymentList[$index]['refund_amount']);
                    }
                }
            }

            $payment = new self();
            $payment
                ->setEntered($paymentList)
                ->setMass();

            return $paymentIntent;
        }

        /** Subscription payment */
        if ($membershipData['frequency'] == '1') {

            /** Trial Subscribe */
            if ($trial) {

                // Trial Amount == 0 & order_bump.length > 0
                if ($membershipData['trial_amount'] == '0') {
                    $amount = 0;
                    foreach ($bumpList as $bump) {
                        $amount += intval(floatval($bump['calc_amount']) * 100);
                    }

                    // Discount
                    if (!empty($discount)) {
                        $amount = $instance->getDiscountAmount($discountData, $amount);
                    }

                    $paymentIntent = Project_Deliver_Stripe::setPaymentIntent(
                        [
                            'amount'                 => $amount,
                            'application_fee_amount' => intval($amount * self::getUserFeePercent($membershipData['user_id']) / 100), // TODO: this application fee percent
                            'currency'               => strtolower($siteData['currency']),
                            'customer'               => $cid,
                            'payment_method'         => $paymentMethod,
                        ],
                        $stripe_account
                    );

                    $payment     = new self();
                    $paymentList = [];

                    if (!empty($bumpList)) {
                        foreach ($bumpList as $bump) {
                            $paymentList[] = [
                                'site_id'        => $bump['site_id'],
                                'plan_id'        => $bump['id'],
                                'user_id'        => $bump['user_id'],
                                'customer_id'    => $memberData['id'],
                                'type_payment'   => '0',
                                'payment_intent' => $paymentIntent->id,
                                'status'         => $paymentIntent->status,
                                'refund_part'    => 1,
                                'refund_amount'  => floatval($bump['calc_amount']) * 100,
                            ];

                            // Discount
                            if (!empty($discount)) {
                                $index                                = sizeof($paymentList) - 1;
                                $paymentList[$index]['refund_amount'] = $instance->getDiscountAmount($discountData, $paymentList[$index]['refund_amount']);
                            }
                        }
                    }

                    $payment
                        ->setEntered($paymentList)
                        ->setMass();

                    return $paymentIntent;
                }

                $amount = $total_amount = floatval($membershipData['trial_amount']) * 100;

                /** Order Bump */
                if (!empty($bumpList)) {
                    foreach ($bumpList as $bump) {
                        $amount += floatval($bump['calc_amount']) * 100;
                    }
                }

                // Discount
                if (!empty($discount)) {
                    $amount = $instance->getDiscountAmount($discountData, $amount);
                }

                /** Create Payment Intent */
                $paymentIntent = Project_Deliver_Stripe::setPaymentIntent(
                    [
                        'amount'                 => $amount,
                        'application_fee_amount' => intval($amount * self::getUserFeePercent($membershipData['user_id']) / 100), // TODO: this application fee percent
                        'currency'               => strtolower($siteData['currency']),
                        'customer'               => $cid,
                        'payment_method'         => $paymentMethod,
                    ],
                    $stripe_account
                );

                $paymentList[] = [
                    'site_id'        => $membershipData['site_id'],
                    'plan_id'        => $membershipData['id'],
                    'user_id'        => $membershipData['user_id'],
                    'customer_id'    => $memberData['id'],
                    'type_payment'   => '1',
                    'payment_intent' => $paymentIntent->id,
                    'status'         => $paymentIntent->status,
                    'refund_part'    => !empty($bumpList),
                    'refund_amount'  => $total_amount,
                ];

                if (!empty($bumpList)) {
                    foreach ($bumpList as $bump) {
                        $paymentList[] = [
                            'site_id'        => $bump['site_id'],
                            'plan_id'        => $bump['id'],
                            'user_id'        => $bump['user_id'],
                            'customer_id'    => $memberData['id'],
                            'type_payment'   => '0',
                            'payment_intent' => $paymentIntent->id,
                            'status'         => $paymentIntent->status,
                            'refund_part'    => 1,
                            'refund_amount'  => floatval($bump['calc_amount']) * 100,
                        ];

                        // Discount
                        if (!empty($discount)) {
                            $index                                = sizeof($paymentList) - 1;
                            $paymentList[$index]['refund_amount'] = $instance->getDiscountAmount($discountData, $paymentList[$index]['refund_amount']);
                        }
                    }
                }

                $payment = new self();
                $payment
                    ->setEntered($paymentList)
                    ->setMass();

                return $paymentIntent;
            } else {
                // Add charges one time
                if (!empty($membershipData['add_charges']) && $membershipData['add_charges_frequency'] == '0') {

                    $amount = floatval($membershipData['add_charges']) * 100;

                    if (!empty($membershipData['add_taxes'])) {
                        $amount += intval($amount * floatval($membershipData['add_taxes']) / 100);
                    }

                    Project_Deliver_Stripe::setInvoiceItem(
                        [
                            'amount'      => $amount,
                            'currency'    => strtolower($siteData['currency']),
                            'customer'    => $cid,
                            'description' => (!empty($membershipData['label_charges']) ? $membershipData['label_charges'] : 'Additional Charges'),
                        ],
                        $stripe_account
                    );
                }

                // Order Bump
                if (!empty($bumpList)) {
                    foreach ($bumpList as $bump) {
                        Project_Deliver_Stripe::setInvoiceItem(
                            [
                                'amount'      => intval($bump['calc_amount'] * 100),
                                'currency'    => strtolower($siteData['currency']),
                                'customer'    => $cid,
                                'description' => $bump['name'],
                            ],
                            $stripe_account
                        );
                    }
                }

                /** Create Subscription on stripe.com and add to customer */
                $subscriptionData = [
                    'customer'                => $cid,
                    'items'                   => [
                        [
                            'price' => $membershipData['stripe_plan_id'],
                        ],
                    ],
                    'default_payment_method'  => $paymentMethod,
                    'application_fee_percent' => self::getUserFeePercent($membershipData['user_id']), // TODO: this application fee percent
                    'expand'                  => ['latest_invoice.payment_intent'],
                ];

                // Discount Coupon
                if (!empty($discount)) {
                    $couponData = [
                        'name'     => $discountData['name'],
                        'duration' => 'once',
                    ];

                    if ($discountData['recurring'] == '1') {
                        $couponData['duration'] = 'forever';
                    }

                    if ($discountData['discount_type'] == Project_Deliver_DisCount::DISCOUNT_TYPE_DOLLARS) {
                        $couponData['amount_off'] = intval(floatval($discountData['discount_amount']) * 100);
                        $couponData['currency']   = strtolower($siteData['currency']);
                    }

                    if ($discountData['discount_type'] == Project_Deliver_DisCount::DISCOUNT_TYPE_PERCENTS) {
                        $couponData['percent_off'] = floatval($discountData['discount_amount']);
                    }

                    $coupon                     = Project_Deliver_Stripe::createCoupon($couponData, $stripe_account);
                    $subscriptionData['coupon'] = $coupon->id;
                }

                /** Limit rebills */
                if (!empty($membershipData['limit_rebills'])) {
                    $subscriptionData['cancel_at'] = strtotime(sprintf('+%s %s', $membershipData['limit_rebills'], $membershipData['billing_frequency']));
                }

                $subscription = Project_Deliver_Stripe::setSubscription($subscriptionData, $stripe_account);

                $paymentIntent = $subscription->latest_invoice->payment_intent;

                /** Set data about subscription on table */
                $payment = new self();

                $paymentList[] = [
                    'site_id'         => $membershipData['site_id'],
                    'plan_id'         => $membershipData['id'],
                    'user_id'         => $membershipData['user_id'],
                    'customer_id'     => $memberData['id'],
                    'type_payment'    => '1',
                    'payment_intent'  => $paymentIntent->id,
                    'subscription_id' => $subscription->id,
                    'status'          => $paymentIntent->status,
                    'refund_part'     => !empty($bumpList),
                    'refund_amount'   => intval($membershipData['calc_amount'] * 100),
                ];

                if (!empty($discount)) {
                    $index                                = sizeof($paymentList) - 1;
                    $paymentList[$index]['refund_amount'] = $instance->getDiscountAmount($discountData, $paymentList[$index]['refund_amount']);
                }

                if (!empty($bumpList)) {
                    foreach ($bumpList as $bump) {
                        $paymentList[] = [
                            'site_id'        => $bump['site_id'],
                            'plan_id'        => $bump['id'],
                            'user_id'        => $bump['user_id'],
                            'customer_id'    => $memberData['id'],
                            'type_payment'   => '0',
                            'payment_intent' => $paymentIntent->id,
                            'status'         => $paymentIntent->status,
                            'refund_part'    => 1,
                            'refund_amount'  => floatval($bump['calc_amount']) * 100,
                        ];

                        // Discount
                        if (!empty($discount)) {
                            $index                                = sizeof($paymentList) - 1;
                            $paymentList[$index]['refund_amount'] = $instance->getDiscountAmount($discountData, $paymentList[$index]['refund_amount']);
                        }
                    }
                }

                $payment = new self();
                $payment
                    ->setEntered($paymentList)
                    ->setMass();

                // $payment
                //     ->setEntered(
                //         [
                //             'site_id'         => $membershipData['site_id'],
                //             'plan_id'         => $membershipData['id'],
                //             'user_id'         => $membershipData['user_id'],
                //             'customer_id'     => $memberData['id'],
                //             'type_payment'    => '1',
                //             'payment_intent'  => $paymentIntent->id,
                //             'subscription_id' => $subscription->id,
                //             'status'          => $paymentIntent->status,
                //         ]
                //     )
                //     ->set();

                return $paymentIntent;
            }
        }

        return false;
    }

    /** Create trial subscribe
     *
     * @param [string] - Membership ID from system the stripe.com
     * @param [string] - Customer ID from system the stripe.com
     * @param [string] - Payment Intent ID from system the stripe.com
     *
     * @return {boolean} Return true or false
     */
    public static function createTrialSubscribe($membershipId, $customer_id, $payment_intent_id = null, $discount, $stripe_account)
    {
        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membershipId)
            ->onlyOne()
            ->getList($membershipData);

        $site = new Project_Deliver_Site();
        $site
            ->withIds($membershipData['site_id'])
            ->onlyOne()
            ->getList($siteData);

        if (!empty($membershipData['add_charges']) && $membershipData['add_charges_frequency'] == '0') {
            $amount = floatval($membershipData['add_charges']) * 100;

            if (!empty($membershipData['add_taxes'])) {
                $amount += intval($amount * floatval($membershipData['add_taxes']) / 100);
            }

            Project_Deliver_Stripe::setInvoiceItem(
                [
                    'amount'      => $amount,
                    'currency'    => strtolower($siteData['currency']),
                    'customer'    => $customer_id,
                    'description' => (!empty($membershipData['label_charges']) ? $membershipData['label_charges'] : 'Additional Charges'),
                ],
                $stripe_account
            );
        }

        /** Create Subscription on stripe.com and add to customer */
        $subscriptionData = [
            'customer'                => $customer_id,
            'items'                   => [
                [
                    'price' => $membershipData['stripe_plan_id'],
                ],
            ],
            'application_fee_percent' => self::getUserFeePercent($membershipData['user_id']), // TODO: this application fee percent
            'expand'                  => ['latest_invoice.payment_intent'],
        ];

        /** Trial */
        if (!empty($membershipData['trial_duration'])) {
            $subscriptionData['trial_period_days'] = intval($membershipData['trial_duration']);
        }

        /** Limit rebills */
        if (!empty($membershipData['limit_rebills'])) {
            $subscriptionData['cancel_at'] = strtotime(sprintf('+%s %s', $membershipData['limit_rebills'], $membershipData['billing_frequency']));
        }

        // Discount Coupon
        if (!empty($discount)) {
            $instance = new Project_Deliver_DisCount();

            $instance
                ->withIds($discount)
                ->onlyOne()
                ->onlyOwner()
                ->getList($discountData);

            $discountData = $instance->calcDisCount($discountData);

            $couponData = [
                'name'     => $discountData['name'],
                'duration' => 'once',
            ];

            if ($discountData['recurring'] == '1') {
                $couponData['duration'] = 'forever';
            }

            if ($discountData['discount_type'] == Project_Deliver_DisCount::DISCOUNT_TYPE_DOLLARS) {
                $couponData['amount_off'] = intval(floatval($discountData['discount_amount']) * 100);
                $couponData['currency']   = strtolower($siteData['currency']);
            }

            if ($discountData['discount_type'] == Project_Deliver_DisCount::DISCOUNT_TYPE_PERCENTS) {
                $couponData['percent_off'] = floatval($discountData['discount_amount']);
            }

            $coupon                     = Project_Deliver_Stripe::createCoupon($couponData, $stripe_account);
            $subscriptionData['coupon'] = $coupon->id;
        }

        $subscription = Project_Deliver_Stripe::setSubscription($subscriptionData, $stripe_account);

        if (!isset($subscription['error'])) {
            $payment = new self();

            if ($payment_intent_id === null) {
                $member = new Project_Deliver_Member();
                $member
                    ->withCustomerId($customer_id)
                    ->onlyOne()
                    ->getList($memberData);

                return $payment
                    ->setEntered(
                        [
                            'site_id'         => $membershipData['site_id'],
                            'plan_id'         => $membershipData['id'],
                            'user_id'         => $membershipData['user_id'],
                            'customer_id'     => $memberData['id'],
                            'type_payment'    => '1',
                            'payment_intent'  => null,
                            'subscription_id' => $subscription->id,
                            'status'          => self::STATUS_TRIAL,
                        ]
                    )
                    ->set();
            } else {
                $payment
                    ->withPaymentIntentId($payment_intent_id)
                    ->withoutOneTime()
                    ->onlyOne()
                    ->getList($paymentData);

                $subscr = new Project_Deliver_Payment();

                $subscr
                    ->withPaymentIntentId($payment_intent_id)
                    ->withoutOneTime()
                    ->onlyOne()
                    ->getList($subData);

                if (!empty($paymentData)) {
                    return $payment
                        ->setEntered(
                            [
                                'id'              => $paymentData['id'],
                                'subscription_id' => $subscription->id,
                            ]
                        )
                        ->set()
                    && $subscr
                        ->setEntered(
                            [
                                'id'              => $subData['id'],
                                'subscription_id' => $subscription->id,
                            ]
                        )
                        ->set();
                } else {
                    return false;
                }
            }
        }

        return false;
    }

    /** Getting data of one time payment
     *
     * @param [string] - Payment Intent ID from system the stripe.com
     * @param [int] - Customer ID from module Deliver
     * @param [int] - User ID if needed
     *
     * @return [array] - Returned array with data or array of errors
     */
    public function getOneTimePaymentDetails($payment_intent, $customer_id, $stripe_account)
    {
        $paymentIntent = Project_Deliver_Stripe::getPaymentIntent($payment_intent, $stripe_account);

        if (array_key_exists('error', $paymentIntent)) {
            return $paymentIntent;
        }

        $customer = new Project_Deliver_Member();
        $customer
            ->onlyOne()
            ->onlyOwner()
            ->withIds($customer_id)
            ->getList($customerData);

        $response = [
            'amount'            => ($paymentIntent->amount / 100),
            'fee_amount'        => $paymentIntent->application_fee_amount / 100,
            'currency'          => $paymentIntent->currency,
            'created'           => $paymentIntent->created,
            'customer'          => $customerData,
            'payment_intent_id' => $payment_intent,
        ];

        return $response;
    }

    /**
     * Refund payment of one time
     *
     * @param [string] $payment_intent_id
     * @param [int] $payment_id
     * @param [string] $stripe_account
     * @return void
     */
    public function refundOneTimePayment($payment_intent_id, $payment_id, $stripe_account)
    {
        $refundObj = Project_Deliver_Stripe::refundPayment([
            'payment_intent' => $payment_intent_id,
        ], $stripe_account);

        if ($refundObj->status == 'succeeded') {
            $this->setEntered(['id' => $payment_id, 'status' => 'refunded'])->set();
        }
    }

    /**
     * Getting of subscription payment details
     *
     * @param [string] $subscription_id
     * @param [int] $customer_id
     * @param [string] $paymentIntent
     * @param [string] $stripe_account
     * @return array
     */
    public function getSubscriptionPaymentDetails($subscription_id, $customer_id, $paymentIntent = null, $stripe_account)
    {
        $responce = [];

        $subscription = Project_Deliver_Stripe::getSubscription($subscription_id, $stripe_account);

        if (empty($paymentIntent)) {
            $invoiceObj = Project_Deliver_Stripe::retriveInvoice($subscription->latest_invoice, $stripe_account);

            $responce = [
                'amount'            => $invoiceObj->amount_paid / 100,
                'fee_amount'        => $invoiceObj->application_fee_amount / 100,
                'currency'          => $invoiceObj->currency,
                'payment_intent_id' => $invoiceObj->payment_intent,
            ];
        } else {
            $paymentIntent = Project_Deliver_Stripe::getPaymentIntent($paymentIntent, $stripe_account);
            $responce      = [
                'amount'            => $paymentIntent->amount / 100,
                'fee_amount'        => $paymentIntent->application_fee_amount / 100,
                'currency'          => $paymentIntent->currency,
                'payment_intent_id' => $paymentIntent->id,
            ];
        }

        $customer = new Project_Deliver_Member();

        $customer
            ->onlyOne()
            ->onlyOwner()
            ->withIds($customer_id)
            ->getList($customerData);

        $responce['created']  = $subscription->created;
        $responce['customer'] = $customerData;

        return $responce;
    }

    /**
     * Refund payment of subscribe
     *
     * @param [string] $payment_intent_id
     * @param [string] $payment_id
     * @param [string] $subscription_id
     * @param [string] $stripe_account
     * @return void
     */
    public function refundSubscribePayment($payment_intent_id, $payment_id, $subscription_id, $stripe_account)
    {
        $refundObj = Project_Deliver_Stripe::refundPayment([
            'payment_intent' => $payment_intent_id,
        ], $stripe_account);

        if ($refundObj->status == 'succeeded') {
            $this->setEntered(['id' => $payment_id, 'status' => 'refunded'])->set();

            $this->unsubscribe($subscription_id, false, $stripe_account);
        }
    }

    /** Unsubscribe user
     *
     * @param [string] - ID subscribe from system stripe.com
     * @param [int] - ID payment from module Deliver
     * @param [int] - User ID
     *
     * @return [string] - Return a action status
     */
    public function unsubscribe($subscription_id, $payment_id = false, $stripe_account)
    {
        if (empty($subscription_id)) {
            return json_encode(['error' => 'Empty value: subscription id']);
        }

        $subscription = Project_Deliver_Stripe::getSubscription($subscription_id, $stripe_account);
        $subscription = $subscription->delete();

        if (!empty($payment_id)) {
            $this->setEntered(['id' => $payment_id, 'status' => $subscription->status])->set();
        }

        return $subscription->status;
    }

    /** Getting the percentage of remuneration set for the user or, if empty, return 4% by default
     * @param [int or string] - User ID
     * @return [int] - Fee percent of user or 4% by default
     */
    public static function getUserFeePercent($user_id)
    {
        /** Default fee percent */
        $default_fee = 4;

        if (empty($user_id)) {
            return $default_fee;
        }

        $instance = new Core_Users_Management();

        /** Getting data of user */
        $instance
            ->withIds($user_id)
            ->onlyOne()
            ->getList($userData);

        if (empty($userData) || empty($userData['stripe_fee'])) {
            return $default_fee;
        }

        /** Update defautl fee percent */
        $default_fee = intval($userData['stripe_fee']);

        return $default_fee;
    }

    /**
     * Return structured data for a legend
     *
     * @param [array] $arrPayments
     * @return array
     */
    public static function getTree($arrPayments)
    {
        $response = [];
        $flg_year = $flg_month = $flg_day = false;
        $output   = [];

        if (!empty($arrPayments)) {
            $response = [];
            foreach ($arrPayments as $payment) {
                if (!isset($response[date('Y', $payment['added'])])) {
                    $response[date('Y', $payment['added'])] = [];
                }

                if (!isset($response[date('Y', $payment['added'])][date('n', $payment['added'])])) {
                    $response[date('Y', $payment['added'])][date('n', $payment['added'])] = [];
                }

                if (!isset($response[date('Y', $payment['added'])][date('n', $payment['added'])][date('d', $payment['added'])])) {
                    $response[date('Y', $payment['added'])][date('n', $payment['added'])][date('d', $payment['added'])] = 0;
                }

                $response[date('Y', $payment['added'])][date('n', $payment['added'])][date('d', $payment['added'])] += 1;
            }
        }

        if (empty($response)) {return [];}

        if (count($response) > 1) {
            $flg_year = true;
        } else if (count($response[key($response)]) > 1) {
            $flg_month = true;
        } else {
            $flg_day = true;
        }

        if ($flg_year) {
            foreach ($response as $year => $month) {
                foreach ($month as $value) {
                    $output[$year] = array_sum(array_values($value));
                }
            }
        }

        $year = key($response);

        if ($flg_month) {
            foreach ($response[$year] as $month => $value) {
                $output[join('-', [$year, $month])] = array_sum($value);
            }
        }

        if ($flg_day) {
            $month = key($response[$year]);

            foreach ($response[$year][$month] as $day => $value) {
                $output[join('-', [$year, $month, $day])] = $value;
            }
        }

        return $output;
    }

    public static function getTotalAmount($arrData)
    {
        if (empty($arrData)) {
            return 0;
        }

        $sites_id = array_unique(array_column($arrData, 'site_id'));

        $site = new Project_Deliver_Site();
        $site
            ->withIds($sites_id)
            ->onlyOne()
            ->getList($siteData);

        $total = 0;

        foreach ($arrData as $data) {
            $total += intval($data['total_amount']) / 100;
        }

        return [$total, Project_Deliver_Currency::getCode($siteData['currency'])];
    }
}
