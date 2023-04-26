<?php

class Project_Deliver_Membership extends Core_Data_Storage
{

    protected $_table      = 'deliver_membership';
    private $_userFilePath = false;

    /**
     * @param [id] ==> Record id in a table
     * @param [site_id] ==> Site Id
     * @param [name] ==> Membership name
     * @param string $description
     * @param [type] ==> Free or Paid
     * @param [amount] ==> Amount price
     * @param [frequency] ==> Frequency [One time / Recurring]
     * @param [trial_amount] ==> Trial amount
     * @param [trial_duration] ==> Trial duration
     * @param [limit_rebills] ==> Limit rebills
     * @param [add_charges] ==> Additional Charges
     * @param [add_taxes] ==> Add Taxes
     * @param [home_page_url] ==> Home page URL
     * @param [added] ==> Unixtime code when a record is created
     * @param [edited] ==> Unixtime code when was record is edited
     */
    protected $_fields = array(
        'id',
        'site_id',
        'user_id',
        'stripe_account',
        'name',
        'description',
        'type',
        'amount',
        'frequency',
        'billing_frequency',
        'trial_amount',
        'trial_duration',
        'limit_rebills',
        'require_shipping',
        'allowed_contries',
        'add_charges',
        'add_charges_frequency',
        'label_charges',
        'charges_frequency',
        'add_taxes',
        'home_page_url',
        'webhook_url',
        'enable_automate',
        'aic', // automate initiated checkout
        'acc', // automate completed checkout
        'stripe_product_id',
        'stripe_plan_id',
        'added',
        'edited');

    private $_withSiteId          = false;
    private $_withSiteName        = false;
    private $_withConnectedMember = false;
    private $_onlyFree            = false;
    private $_onlyPay             = false;
    private $_withFilter          = false;
    private $_withTime            = false;
    private $_onlyRecurring       = false;
    private $_withCurrency        = false;
    private $_onlyOnetime         = false;

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_membership");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_membership` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`site_id` INT(11) NOT NULL DEFAULT '0',
				`user_id` INT(11) NOT NULL DEFAULT '0',
				`stripe_account` VARCHAR(100) NULL DEFAULT NULL,
				`name` VARCHAR(255) NULL DEFAULT NULL,
				`description` TEXT NULL DEFAULT NULL,
				`type` TINYINT(4) NULL DEFAULT NULL,
				`amount` INT(11) NULL DEFAULT NULL,
				`frequency` TINYINT(4) NULL DEFAULT NULL,
				`billing_frequency` VARCHAR(11) NULL DEFAULT 'month',
				`trial_amount` INT(11) NULL DEFAULT NULL,
				`trial_duration` INT(11) NULL DEFAULT NULL,
				`limit_rebills` INT(11) NULL DEFAULT NULL,
				`require_shipping` TINYINT(4) NULL DEFAULT '0',
				`allowed_contries` TEXT NULL,
				`add_charges` INT(11) NULL DEFAULT NULL,
				`add_charges_frequency` TINYINT(4) NULL DEFAULT '0',
				`label_charges` VARCHAR(255) NULL DEFAULT NULL,
				`charges_frequency` INT(11) NULL DEFAULT NULL,
				`add_taxes` INT(11) NULL DEFAULT NULL,
				`home_page_url` VARCHAR(255) NULL DEFAULT NULL,
				`webhook_url` TEXT NULL,
				`enable_automate` BOOLEAN NOT NULL DEFAULT 0,
				`aic` INT(11) NULL DEFAULT NULL,
				`acc` INT(11) NULL DEFAULT NULL,
				`stripe_product_id` VARCHAR(255) NULL DEFAULT NULL,
				`stripe_plan_id` VARCHAR(255) NULL DEFAULT NULL,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				`edited` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;"
        );
    }

    public function beforeSet()
    {
        $this->_data->setFilter(['trim', 'empty_to_null']);

        /** Check field [site_id] */
        if (empty($this->_data->filtered['site_id'])) {
            return Core_Data_Errors::getInstance()->setError('Not selected a site');
        }

        /** Check field [name] */
        if (empty($this->_data->filtered['name'])) {
            return Core_Data_Errors::getInstance()->setError('Empty name a membership plan');
        }

        if ($this->_data->filtered['type'] == '1') {
            if (empty($this->_data->filtered['amount']) || !is_numeric($this->_data->filtered['amount'])) {
                return Core_Data_Errors::getInstance()->setError('Input correct amount for membership');
            }
        }

        if (!empty($this->_data->filtered['require_shipping']) && empty($this->_data->filtered['allowed_contries'])) {
            return Core_Data_Errors::getInstance()->setError('Select countries of list or option all');
        }

        $membershipData = [];

        /** Set field [user_id] */
        if (empty($this->_data->filtered['id'])) {
            $this->_data->setElement('user_id', Core_Users::$info['id']);
            $this->_data->setElement('stripe_account', Project_Deliver_Stripe::getStripeAccountId());
        } else {
            $this
                ->withIds($this->_data->filtered['id'])
                ->onlyOwner()
                ->onlyOne()
                ->getList($membershipData);
        }

        if (!empty($membershipData['stripe_account']) && Project_Deliver_Stripe::getStripeAccountId() !== $membershipData['stripe_account']) {
            return false;
        }

        // Billing frequency
        if (empty($this->_data->filtered['billing_frequency'])) {
            $this->_data->setElement('billing_frequency', 'month');
        } elseif (!in_array($this->_data->filtered['billing_frequency'], ['week', 'month', 'year'])) {
            $this->_data->filtered['billing_frequency'] = 'month';
        }

        // Allowed contries
        if (!empty($this->_data->filtered['allowed_contries'])) {
            $this->_data->setElement('allowed_contries', serialize($this->_data->filtered['allowed_contries']));
        }

        /** Create/update data about a price/product in stripe.com */
        if ($this->_data->filtered['frequency'] == '1') {
            $site = new Project_Deliver_Site();

            $site
                ->withIds($this->_data->filtered['site_id'])
                ->onlyOne()
                ->getList($siteData);

            if (!empty($membershipData) && !empty($membershipData['stripe_product_id']) && !empty($membershipData['stripe_plan_id'])) {
                if (strcmp($membershipData['name'], $this->_data->filtered['name']) !== 0) {

                    /** Update product */
                    $product = Project_Deliver_Stripe::setProduct(
                        [
                            'name'              => $this->_data->filtered['name'],
                            'stripe_product_id' => $membershipData['stripe_product_id'],
                        ]
                    );

                    /** Check for errors */
                    if (is_array($product) && array_key_exists('error', $product)) {
                        return Core_Data_Errors::getInstance()->setError($product['error']);
                    }

                    $this->_data->setElement('stripe_product_id', $product);
                } else {
                    $this->_data->setElement('stripe_product_id', $membershipData['stripe_product_id']);
                }

                /** Was updated someone params of lists amount, billing frequency, additional charges, additional charges frequency or taxes */
                if (
                    $this->_data->filtered['amount'] !== $membershipData['amount'] ||
                    $this->_data->filtered['billing_frequency'] !== $membershipData['billing_frequency'] ||
                    $this->_data->filtered['add_charges'] !== $membershipData['add_charges'] ||
                    $this->_data->filtered['add_charges_frequency'] !== $membershipData['add_charges_frequency'] ||
                    $this->_data->filtered['add_taxes'] !== $membershipData['add_taxes']
                ) {
                    /** Add charges */
                    if (!empty($this->_data->filtered['add_charges']) && $this->_data->filtered['add_charges_frequency'] == '1') {
                        $this->_data->filtered['amount'] += floatval($this->_data->filtered['add_charges']);
                    }

                    /** Add taxes */
                    if (!empty($this->_data->filtered['add_taxes'])) {
                        $this->_data->filtered['amount'] += ($this->_data->filtered['amount'] * floatval($this->_data->filtered['add_taxes']) / 100);
                    }

                    /** Create plan */
                    $price = Project_Deliver_Stripe::setPrice([
                        'currency'          => strtolower($siteData['currency']),
                        'amount'            => $this->_data->filtered['amount'],
                        'stripe_product_id' => $this->_data->filtered['stripe_product_id'],
                        'interval'          => $this->_data->filtered['billing_frequency'],
                    ]);

                    /** Check for errors */
                    if (is_array($price) && array_key_exists('error', $price)) {
                        return Core_Data_Errors::getInstance()->setError($price['error']);
                    }

                    $this->_data->setElement('stripe_plan_id', $price);
                }
            } else {
                /** Create product */
                $product = Project_Deliver_Stripe::setProduct(['name' => $this->_data->filtered['name']]);

                /** Check for errors */
                if (is_array($product) && array_key_exists('error', $product)) {
                    return Core_Data_Errors::getInstance()->setError($product['error']);
                }

                $this->_data->setElement('stripe_product_id', $product);

                /** Add charges */
                if (!empty($this->_data->filtered['add_charges']) && $this->_data->filtered['add_charges_frequency'] == '1') {
                    $this->_data->filtered['amount'] += floatval($this->_data->filtered['add_charges']);
                }

                /** Add taxes */
                if (!empty($this->_data->filtered['add_taxes'])) {
                    $this->_data->filtered['amount'] += ($this->_data->filtered['amount'] * floatval($this->_data->filtered['add_taxes']) / 100);
                }

                /** Create plan */
                $price = Project_Deliver_Stripe::setPrice([
                    'currency'          => strtolower($siteData['currency']),
                    'amount'            => $this->_data->filtered['amount'],
                    'stripe_product_id' => $this->_data->filtered['stripe_product_id'],
                    'interval'          => $this->_data->filtered['billing_frequency'],
                ]);

                /** Check for errors */
                if (is_array($price) && array_key_exists('error', $price)) {
                    return Core_Data_Errors::getInstance()->setError($price['error']);
                }

                $this->_data->setElement('stripe_plan_id', $price);
            }
        }

        return true;
    }

    public function afterSet()
    {
        if ($this->_data->filtered['enable_automate'] === '1') {
            if (empty($this->_data->filtered['aic']) && empty($this->_data->filtered['acc'])) {
                $automate = new Project_Automation();

                $automate
                    ->setEntered(
                        [
                            ['title' => 'Membership: [' . $this->_data->filtered['name'] . '] INITIATED_CHECKOUT'],
                            ['title' => 'Membership: [' . $this->_data->filtered['name'] . '] COMPLETED_CHECKOUT'],
                        ]
                    )
                    ->setMass();

                $automate->getEntered($arrAutomates);

                if (!empty($arrAutomates)) {
                    list($aic, $acc) = $arrAutomates;
                    Core_Sql::setExec("UPDATE `{$this->_table}` SET `aic`={$aic['id']}, `acc`={$acc['id']} WHERE id={$this->_data->filtered['id']};");
                }
            }
        }

        return true;
    }

    public function del()
    {
        $this
            ->onlyOne()
            ->getList($recData);

        if (!empty($recData)) {
            if (!empty($recData['logo'])) {
                unlink(Zend_Registry::get('config')->path->absolute->root . $recData['logo']);
            }

            $this->withIds($recData['id']);
            parent::del();
        }
    }

    public function withSiteId($site_id)
    {
        if (!empty($site_id)) {
            $this->_withSiteId = $site_id;
        }

        return $this;
    }

    public function withSiteName()
    {
        $this->_withSiteName = true;
        return $this;
    }

    public function withFilter($filter)
    {
        if (!empty($filter['time'])) {
            $this->withTime($filter['time'], $filter['date_from'], $filter['date_to']);
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

    public function onlyFree()
    {
        $this->_onlyFree = true;
        return $this;
    }

    public function onlyPay()
    {
        $this->_onlyPay = true;
        return $this;
    }

    public function onlyRecurring()
    {
        $this->_onlyRecurring = true;
        return $this;
    }

    public function onlyOnetime()
    {
        $this->_onlyOnetime = true;
        return $this;
    }

    public function withCurrency()
    {
        $this->_withCurrency = true;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if (!empty($this->_withSiteId)) {
            $this->_crawler->set_where('d.site_id=' . Core_Sql::fixInjection($this->_withSiteId));
        }

        if (!empty($this->_withConnectedMember)) {
            $this->_crawler->clean_select();
            $this->_crawler->set_select('d.id, d.name, d.frequency, d.type, p.subscription_id as subscription_id, p.status as status, p.id as payment_id');
            $this->_crawler->set_from('INNER JOIN deliver_plan_customer pc ON pc.customer_id = ' . Core_Sql::fixInjection($this->_withConnectedMember));
            $this->_crawler->set_from('LEFT JOIN deliver_subscription p ON p.customer_id = pc.customer_id AND p.plan_id = pc.membership_id');
            $this->_crawler->set_where('d.id = pc.membership_id');
            $this->_crawler->set_where("(p.status IN ('trial', 'succeeded', 'active') OR p.status IS NULL)");
        }

        if ($this->_withSiteName) {
            $this->_crawler->set_select('s.name as site_name');
            $this->_crawler->set_from('INNER JOIN deliver_site s ON s.id = d.site_id');

            if ($this->_withCurrency) {
                $this->_crawler->set_select('s.currency as currency');
            }
        }

        if ($this->_onlyFree) {
            $this->_crawler->set_where('d.type = 0');
        }

        if ($this->_onlyPay) {
            $this->_crawler->set_where('d.type = 1');
        }

        if ($this->_withTime) {
            $this->_crawler->set_where('d.added >= ' . $this->_withTime["from"] . ' AND d.added <= ' . $this->_withTime["to"]);
        }

        if ($this->_onlyRecurring) {
            $this->_crawler->set_where('d.frequency = 1');
        }

        if ($this->_onlyOnetime) {
            $this->_crawler->set_where('d.frequency = 0');
        }

        if ($this->_withCurrency && !$this->_withSiteName) {
            $this->_crawler->set_select('s.currency as currency');
            $this->_crawler->set_from('LEFT JOIN deliver_site s ON s.id = d.site_id');
        }

        // $this->_crawler->get_sql( $_strSql, $this->_paging );
        // var_dump( $_strSql );
    }

    public function withConnectedCustomer($member_id)
    {
        if (!empty($member_id)) {
            $this->_withConnectedMember = $member_id;
        }

        return $this;
    }

    protected function init()
    {
        parent::init();

        $this->_withSiteId          = false;
        $this->_withConnectedMember = false;
        $this->_withSiteName        = false;
        $this->_onlyFree            = false;
        $this->_onlyPay             = false;
        $this->_withFilter          = false;
        $this->_withTime            = false;
        $this->_onlyRecurring       = false;
        $this->_onlyOnetime         = false;
    }

    public function getList(&$mixRes)
    {
        parent::getList($mixRes);

        if (array_key_exists('0', $mixRes)) {
            foreach ($mixRes as &$item) {
                if (!empty($item['allowed_contries'])) {
                    $item['allowed_contries'] = unserialize($item['allowed_contries']);
                }

                if ((!empty($item['trial_amount']) || $item['trial_amount'] === '0') && !empty($item['trial_duration'])) {
                    $item['trial'] = true;
                } else {
                    $item['trial'] = false;
                }

                $item['calc_amount'] = intval($item['amount']);

                /** Add charges */
                if (!empty($item['add_charges'])) {
                    $item['calc_amount'] += floatval($item['add_charges']);
                }

                /** Add taxes */
                if (!empty($item['add_taxes'])) {
                    $item['calc_amount'] += ($item['calc_amount'] * floatval($item['add_taxes']) / 100);
                }
            }
        } else {
            if (!empty($mixRes)) {
                $mixRes['allowed_contries'] = unserialize($mixRes['allowed_contries']);

                $mixRes['calc_amount'] = intval($mixRes['amount']);

                /** Add charges */
                if (!empty($mixRes['add_charges'])) {
                    $mixRes['calc_amount'] += floatval($mixRes['add_charges']);
                }

                /** Add taxes */
                if (!empty($mixRes['add_taxes'])) {
                    $mixRes['calc_amount'] += ($mixRes['calc_amount'] * floatval($mixRes['add_taxes']) / 100);
                }
            }
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
     * Remove member from membership
     *
     * @param string $mid
     * @param string $membership_id
     * @return boolean
     */
    public static function removeMember($mid, $membership_id)
    {
        $member = new Project_Deliver_Member();
        $member
            ->withIds($mid)
            ->onlyOwner()
            ->onlyOne()
            ->getList($memberData);

        if (empty($memberData)) {
            return false;
        }

        $membership = new self();
        $membership
            ->withIds($membership_id)
            ->onlyOwner()
            ->onlyOne()
            ->getList($membershipData);

        if (empty($membershipData)) {
            return false;
        }

        $connection = new Project_Deliver_SignIn_Connection();

        // Free or One Time
        $connection
            ->withMembershipId($membership_id)
            ->withCustomerId($mid)
            ->onlyOne()
            ->getList($accessData);

        // Subscription
        if ($membershipData['frequency'] === '1') {
            $payment = new Project_Deliver_Subscription();
            $payment
                ->onlyOne()
                ->onlyOwner()
                ->withCustomerId($mid)
                ->withMembershipIds($membership_id)
                ->getList($paymentData);

            if (!empty($paymentData)) {
                $payment->unsubscribe($paymentData['subscription_id'], $paymentData['id'], $membershipData['stripe_account']);
            }
        }

        if (!empty($accessData)) {
            return $connection
                ->withIds($accessData['id'])
                ->del();
        }

        return false;
    }

    /**
     * Add user to memebership
     *
     * @param string $mid
     * @param string $membership_id
     * @return boolean
     */
    public static function addMember($mid, $membership_id, $flg_notif = true)
    {
        $connection = new Project_Deliver_SignIn_Connection();

        $membership = new self();
        $membership
            ->withIds($membership_id)
            ->onlyOne()
            ->getList($membershipData);

        $member = new Project_Deliver_Member();
        $member
            ->withIds($mid)
            ->onlyOne()
            ->getList($memberData);

        $site = new Project_Deliver_Site();
        $site
            ->withIds($membershipData['site_id'])
            ->onlyOne()
            ->getList($siteData);

        Project_Deliver_Webhook::send(
            $membershipData['id'],
            [
                'email'             => $memberData['email'],
                'shipping_address'  => null,
                'product_purchased' => $siteData['name'],
                'membership'        => $membershipData['name'],
                'price'             => 0,
            ]
        );

        $memberData['flg_lead'] = '0';
        $member->setEntered($memberData)->set();

        return $connection
            ->setEntered(
                [
                    'customer_id'         => $mid,
                    'membership_id'       => $membership_id,
                    'added_by_user'       => Core_Users::$info['id'],
                    'flgSendNotification' => $flg_notif,
                ]
            )
            ->set();
    }
}
