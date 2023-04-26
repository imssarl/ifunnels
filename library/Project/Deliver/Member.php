<?php

class Project_Deliver_Member extends Core_Data_Storage
{

    protected $_table = 'deliver_customer';

    /**
     * @param [id] ==> Record id in a table
     * @param [site_id] ==> Site Id
     * @param [user_id] ==> User Id
     * @param [email] ==> Customer Email
     * @param [added] ==> Unixtime code when a record is created
     */
    protected $_fields = array('id', 'site_id', 'user_id', 'membership_id', 'email', 'customer_id', 'flg_lead', 'added', 'edited');

    private $_allType                  = false;
    private $_withUserId               = false;
    private $_withEmail                = false;
    private $_withSiteId               = false;
    private $_withConnectedMemberships = false;
    private $_paymentStatus            = false;
    private $_withCustomerId           = false;
    private $_withMembershipName       = false;
    private $_onlyLeads                = false;
    private $_withMembershipId         = false;
    private $_withPayMembership        = false;
    private $_filter                   = false;
    private $_withFilter               = false;
    private $_withTime                 = false;
    private $_withEmails               = false;
    

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_customer");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_customer` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`site_id` INT(11) NOT NULL DEFAULT '0',
				`user_id` INT(11) NOT NULL DEFAULT '0',
				`email` VARCHAR(255) NULL DEFAULT NULL,
				`customer_id` TEXT NULL DEFAULT NULL,
				`flg_lead` BOOLEAN DEFAULT 0,
				`membership_id` INT(11) NULL DEFAULT NULL,
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
        $this->_data->setFilter(array('clear'));

        /** Check field [site_id] */
        if (empty($this->_data->filtered['site_id'])) {
            return Core_Data_Errors::getInstance()->setError('Not selected a site');
        }

        /** Set field [user_id] */
        if (empty($this->_data->filtered['user_id'])) {
            $this->_data->setElement('user_id', Core_Users::$info['id']);
        }

        return true;
    }

    public function withUserId($user_id = false)
    {
        if (!$user_id) {
            $this->_withUserId = Core_Users::$info['id'];
        } else {
            $this->_withUserId = $user_id;
        }

        return $this;
    }

    public function withEmail($email)
    {
        $this->_withEmail = $email;
        return $this;
    }

    public function withEmails($emails)
    {
        $this->_withEmails = $emails;
        return $this;
    }

    public function withSiteId($site_id)
    {
        $this->_withSiteId = $site_id;
        return $this;
    }

    public function withConnectedMemberships()
    {
        $this->_withConnectedMemberships = true;
        return $this;
    }

    public function paymentStatus($membershipIds)
    {
        $this->_paymentStatus = $membershipIds;
        return $this;
    }

    public function withCustomerId($cid)
    {
        $this->_withCustomerId = $cid;
        return $this;
    }

    public function withMembershipName()
    {
        $this->_withMembershipName = true;
        return $this;
    }

    public function onlyLeads()
    {
        $this->_onlyLeads = true;
        return $this;
    }

    public function withMembershipId($membership_id)
    {
        $this->_withMembershipId = $membership_id;
        return $this;
    }

    public function withPayMembership($membership_id)
    {
        $this->_withPayMembership = $membership_id;
        return $this;
    }

    public function setFilter($arrFilter)
    {
        $this->_filter = new Core_Data($arrFilter);
        $this->_filter->setFilter();

        if ($this->_filter->filtered['membership_id']) {
            $this->withMembershipId($this->_filter->filtered['membership_id']);
        }

        if ($this->_filter->filtered['membership_pay_id']) {
            $this->withPayMembership($this->_filter->filtered['membership_pay_id']);
        }

        return $this;
    }

    public function getFilter(&$arrFilter)
    {
        $arrFilter = $this->_filter->filtered;
        return $this;
    }

    public function allType()
    {
        $this->_allType = true;
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

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withUserId) {
            $this->_crawler->set_where('d.user_id=' . Core_Sql::fixInjection($this->_withUserId));
        }

        if (!empty($this->_withEmail)) {
            $this->_crawler->set_where('d.email=' . Core_Sql::fixInjection($this->_withEmail));
        }

        if (!empty($this->_withEmails)) {
            $this->_crawler->set_where('d.email IN (' . Core_Sql::fixInjection($this->_withEmails) . ')');
        }

        if (!empty($this->_withCustomerId)) {
            $this->_crawler->set_where('d.customer_id=' . Core_Sql::fixInjection($this->_withCustomerId));
        }

        if (!empty($this->_withSiteId)) {
            $this->_crawler->set_where('d.site_id=' . Core_Sql::fixInjection($this->_withSiteId));
        }

        if (!empty($this->_paymentStatus)) {
            $this->_crawler->clean_select();
            $this->_crawler->set_select('d.id, d.email, p.status as status, p.id as pid');
            $this->_crawler->set_from('INNER JOIN deliver_subscription p ON p.customer_id = d.id AND p.plan_id IN (' . Core_Sql::fixInjection($this->_paymentStatus) . ')');
        }

        if (!$this->_allType) {
            if (empty($this->_withIds) && empty($this->_withCustomerId)) {
                if ($this->_onlyLeads) {
                    $this->_crawler->set_where('d.flg_lead = 1');
                } else {
                    $this->_crawler->set_where('d.flg_lead = 0');
                }
            }
        }

        if ($this->_withMembershipName) {
            $this->_crawler->set_select('m.name as membership_name, s.name as site_name');
            $this->_crawler->set_from('LEFT JOIN deliver_membership m ON m.id = d.membership_id');
            $this->_crawler->set_from('LEFT JOIN deliver_site s ON m.site_id = s.id');
        }

        if (!empty($this->_withMembershipId)) {
            $this->_crawler->set_where('d.membership_id IN (' . Core_Sql::fixInjection($this->_withMembershipId) . ')');
        }

        if (!empty($this->_withPayMembership)) {
            // $type = Core_Sql::getCell('SELECT m.type FROM deliver_membership m WHERE m.id =' . Core_Sql::fixInjection($this->_withPayMembership));
            // if ($type === '0') {
            //     $this->_crawler->set_from('RIGHT JOIN deliver_plan_customer pc ON pc.customer_id = d.id AND pc.membership_id = ' . Core_Sql::fixInjection($this->_withPayMembership));
            // } else {
            //     $this->_crawler->set_where('d.id IN ( SELECT p.customer_id FROM `deliver_subscription` p WHERE p.plan_id IN (' . Core_Sql::fixInjection($this->_withPayMembership) . ') AND p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active']) . ') )');
            // }

            $this->_crawler->set_from('LEFT JOIN deliver_plan_customer pc ON pc.customer_id = d.id');
            $this->_crawler->set_from('LEFT JOIN deliver_subscription p ON p.customer_id = d.id');

            $this->_crawler->set_where('pc.membership_id IN (' . Core_Sql::fixInjection($this->_withPayMembership) . ')');
            $this->_crawler->set_where('p.status IS NULL OR p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active']) . ')');

            $this->_crawler->set_group('d.id');
        }

        if ($this->_withTime) {
            $this->_crawler->set_where('d.added >= ' . $this->_withTime["from"] . ' AND d.added <= ' . $this->_withTime["to"]);
        }

        // $this->_crawler->get_sql($_strSql, $this->_paging);
        // var_dump($_strSql);
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

    protected function init()
    {
        $this->_withUserId         = false;
        $this->_withSiteId         = false;
        $this->_withEmail          = false;
        $this->_withCustomerId     = false;
        $this->_paymentStatus      = false;
        $this->_withMembershipName = false;
        $this->_withMembershipId   = false;
        $this->_onlyLeads          = false;
        $this->_withPayMembership  = false;
        $this->_allType            = false;
        $this->_withFilter         = false;
        $this->_withTime           = false;
        $this->_withEmails         = false;
    }

    /**
     * Remove one or more records
     *
     * @return [boolean] - Result of request
     */
    public function del()
    {
        if (!empty($this->_withIds)) {
            /** Remove login and password of user */
            Core_Sql::setExec('DELETE FROM `deliver_signin` WHERE customer_id IN (' . Core_Sql::fixInjection($this->_withIds) . ')');

            /** Remove connections with memberships */
            Core_Sql::setExec('DELETE FROM `deliver_plan_customer` WHERE customer_id IN (' . Core_Sql::fixInjection($this->_withIds) . ')');
        }

        parent::del();
    }

    public function getList(&$mixRes)
    {
        parent::getList($mixRes);

        if ($this->_withConnectedMemberships && !empty($mixRes)) {
            $membership = new Project_Deliver_Membership();

            if (array_key_exists('0', $mixRes)) {
                foreach ($mixRes as &$record) {
                    $membership
                        ->withSiteName()
                        ->withConnectedCustomer($record['id'])
                        ->getList($record['arrPlans']);
                }
            } else {
                $membership
                    ->withSiteName()
                    ->withConnectedCustomer($mixRes['id'])
                    ->getList($mixRes['arrPlans']);
            }
            $this->_withConnectedMemberships = false;
        }

        $this->init();
        return $this;
    }

    /**
     * Check status of payment for selected email
     *
     * @param [string] $email
     * @param [int] $membership
     * @return boolean
     */
    public static function checkStatusPayment($email, $membership)
    {
        $self = new self();

        $self
            ->withEmail($email)
            ->paymentStatus($membership)
            ->getList($dataObj);

        $status = false;

        if (!empty($dataObj)) {
            foreach ($dataObj as $item) {
                if (in_array($item['status'], ['trialing', 'active', 'succeeded'])) {
                    $status = true;
                }
            }
        }

        return $status;
    }

    /**
     * Create a new customer
     *
     * @param {$data} - array with a keys [ payment_method, email, site_id, user_id ]
     * @param {$stripe_account} - ID of the connected account from a stripe.com
     *
     */
    public static function createCustomer($data = array(), $stripe_account)
    {
        if (empty($data)) {
            return false;
        }

        extract($data);

        if (!isset($site_id) || !isset($user_id)) {
            return false;
        }

        $member = new self();
        $member
            ->withEmail($email)
            // TODO Убрал так как не уверен в необходимости проверки сайта
            // ->withSiteId($site_id)
            ->withUserId($user_id)
            ->allType()
            ->onlyOne()
            ->getList($memberData);

        /** Getting data of membership */
        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membership_id)
            ->onlyOne()
            ->getList($membershipData);

        $site = new Project_Deliver_Site();
        $site
            ->withIds($membershipData['site_id'])
            ->onlyOne()
            ->getList($siteData);

        $instance = new Project_Subscribers($user_id);

        /** Check exist user data with flg_lead */
        if (!empty($memberData)) {
            /** Rewardful Referral */
            if (!empty($referral)) {
                Project_Deliver_Stripe::updateCustomer($memberData['customer_id'], ['metadata' => ['referral' => $referral]], $stripe_account);
            }

            /** Update field membership_id */
            $member
                ->setEntered(
                    [
                        'id'            => $memberData['id'],
                        'membership_id' => $membership_id,
                        'site_id'       => $memberData['site_id'],
                        'user_id'       => $memberData['user_id'],
                    ]
                )
                ->set();

            $member->getEntered($memberData);
            
            /** Added contact to general database of contacts */
            $instance
                ->setEntered(['email' => $email, 'tags' => '[Lead]: ' . $siteData['name'] . ' - ' . $membershipData['name']])
                ->set();

            return $memberData;
        }

        $customerData = [
            'email' => $email,
        ];

        /** Enabled Shipping */
        if (isset($shipping)) {
            $customerData['shipping'] = $shipping;
        }

        /** Payment Method */
        if (isset($payment_method) && !empty($payment_method)) {
            $customerData['payment_method']   = $payment_method;
            $customerData['invoice_settings'] = ['default_payment_method' => $payment_method];
        }

        if (!empty($referral)) {
            $customerData['metadata'] = ['referral' => $referral];
        }

        /** Create new customer on stripe.com */
        $customer = Project_Deliver_Stripe::setCustomer($customerData, $stripe_account);

        /** Create new Customer on iFunnels */
        $member
            ->setEntered([
                'site_id'       => $site_id,
                'user_id'       => $user_id,
                'email'         => $email,
                'customer_id'   => $customer->id,
                'membership_id' => $membership_id,
                'flg_lead'      => $flg_lead,
            ])
            ->set();

        $member->getEntered($memberData);

        /** Added contact to general database of contacts */
        $instance
            ->setEntered(['email' => $email, 'tags' => '[Lead]: ' . $siteData['name'] . ' - ' . $membershipData['name']])
            ->set();

        return $memberData;
    }

    /**
     * Create or add exist customer to membership
     *
     * @param [string] $membership_ids
     * @param [string] $email
     * @param [int] $user_id
     * @return boolean
     */
    public static function addCustomerToMembership($membership_ids, $email, $user_id)
    {
        if (empty($membership_ids)) {
            return false;
        }

        $membership_id = explode(',', $membership_ids);

        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membership_ids)
            ->getList($membershipsData);

        if (empty($membershipsData)) {
            return false;
        }

        $signin     = new Project_Deliver_SignIn();
        $connection = new Project_Deliver_SignIn_Connection();
        $address    = new Project_Deliver_Member_Address();
        $site       = new Project_Deliver_Site();

        foreach ($membershipsData as $membershipData) {
            $memberData = self::createCustomer(
                [
                    'email'    => $email,
                    'site_id'  => $membershipData['site_id'],
                    'user_id'  => $user_id,
                    'flg_lead' => '0',
                ],
                $membershipData['stripe_account']
            );

            $signin
                ->withCustomerId($memberData['id'])
                ->getList($accessData);

            $flgSendNotification = true;

            /** Check existed of access */
            if (empty($accessData)) {
                $signin
                    ->setEntered(
                        [
                            'customer_id' => $memberData['id'],
                            'membership'  => $membershipData['id'],
                        ]
                    )
                    ->set();

                // Not send notification
                $flgSendNotification = false;
            }

            $cData = [
                'customer_id'         => $memberData['id'],
                'membership_id'       => $membershipData['id'],
                'flgSendNotification' => $flgSendNotification,
            ];

            if ($membershipData['type'] == '1') {
                $cData['added_by_user'] = $membershipData['user_id'];
            }

            $address
                ->withCustomerId($memberData['id'])
                ->withCountryName()
                ->onlyOne()
                ->getList($addressData);

            $shipping_address = null;

            $site
                ->withIds($membershipData['site_id'])
                ->onlyOne()
                ->getList($siteData);

            if (!empty($addressData)) {
                $shipping_address = sprintf('%s, %s, %s, %s', $addressData['zip'], $addressData['country_name'], $addressData['city'], $addressData['address']);
            }

            if (!empty($membershipData['webhook_url'])) {
                /** Send data to webhook */
                Project_Deliver_Webhook::send(
                    $membershipData['id'],
                    [
                        'email'             => $memberData['email'],
                        'shipping_address'  => $shipping_address,
                        'product_purchased' => $siteData['name'],
                        'membership'        => $membershipData['name'],
                        'price'             => 0,
                    ]
                );
            }

            $connection
                ->setEntered($cData)
                ->set();
        }
    }

    /**
     * Add payment method for user
     *
     * @param [string] $cid
     * @param [string] $payment_method
     * @param [string] $stripe_account
     * @return mixed
     */
    public static function addPaymentMethod($cid, $payment_method, $stripe_account)
    {
        $member = new self();

        $member
            ->withCustomerId($cid)
            ->onlyOne()
            ->getList($memberData);

        if (empty($memberData)) {
            return ['error' => [
                ['message' => 'User not found'],
            ],
            ];
        }

        return Project_Deliver_Stripe::attachPaymentMethod($memberData['customer_id'], $payment_method, $stripe_account);
    }

    /** Resend new access for user
     *
     * @param string $mid - Member ID
     * @return boolean
     */
    public static function resendAccess($mid)
    {
        if (empty($mid)) {
            return false;
        }

        $member = new self();
        $member
            ->withIds($mid)
            ->onlyOne()
            ->getList($memberData);

        if (empty($memberData)) {
            return false;
        }

        $signin = new Project_Deliver_SignIn();

        $response = $signin
            ->withCustomerId($mid)
            ->regenerateAccess();

        $password = $membership = null;

        if ($response !== false) {
            $password = $response['password'];
        } else {
            return false;
        }

        $connection = new Project_Deliver_SignIn_Connection();
        $connection
            ->withCustomerId($mid)
            ->withMembershipName()
            ->getList($accessToMemberships);

        if (!empty($accessToMemberships)) {
            $membership = join(', ', array_map(function ($access) {
                return $access['name'];
            }, $accessToMemberships));
        }

        /** Send email for user with generated password */
        $mailer = new Core_Mailer();
        $mailer
            ->setVariables(
                [
                    'email'      => $memberData['email'],
                    'password'   => $password,
                    'membership' => $membership,
                ]
            )
            ->setTemplate('deliver_password')
            ->setSubject('Resend Login Details')
            ->setPeopleTo(['email' => $memberData['email'], 'name' => $memberData['email']])
            ->setPeopleFrom(
                [
                    'name'  => Zend_Registry::get('config')->engine->project_sysemail->name,
                    'email' => 'orders@ifunnels.com',
                ]
            )
            ->sendOneToMany();

        return true;
    }

    /**
     * Set password for user
     *
     * @param string $mid
     * @param string $password
     * @return boolean
     */
    public static function setPassword($mid, $password)
    {
        if (empty($mid)) {
            return false;
        }

        $member = new self();
        $member
            ->withIds($mid)
            ->onlyOne()
            ->getList($memberData);

        if (empty($memberData)) {
            return false;
        }

        $signin = new Project_Deliver_SignIn();

        $response = $signin
            ->withCustomerId($mid)
            ->regenerateAccess($password);

        $password = $membership = null;

        if ($response !== false) {
            $password = $response['password'];
        } else {
            return false;
        }

        $connection = new Project_Deliver_SignIn_Connection();
        $connection
            ->withCustomerId($mid)
            ->withMembershipName()
            ->getList($accessToMemberships);

        if (!empty($accessToMemberships)) {
            $membership = join('<br />', array_map(function ($access) {
                return $access['name'];
            }, $accessToMemberships));
        }

        /** Send email for user with generated password */
        $mailer = new Core_Mailer();
        $mailer
            ->setVariables(
                [
                    'email'      => $memberData['email'],
                    'password'   => $password,
                    'membership' => $membership,
                ]
            )
            ->setTemplate('deliver_reset_password')
            ->setSubject('Password Reset Confirmation')
            ->setPeopleTo(['email' => $memberData['email'], 'name' => $memberData['email']])
            ->setPeopleFrom(
                [
                    'name'  => Zend_Registry::get('config')->engine->project_sysemail->name,
                    'email' => 'orders@ifunnels.com',
                ]
            )
            ->sendOneToMany();

        return true;
    }

    /**
     * Check member on exists
     *
     * @param [string] $email
     * @return boolean
     */
    public static function hasExists($email)
    {
        $inst = new self();

        return $inst
            ->withEmail($email)
            ->allType()
            ->onlyOwner()
            ->onlyOne()
            ->getList()
            ->checkEmpty();
    }

    public static function hasExistsOnEthiccash($email)
    {
        $inst = new self();

        return $inst
            ->withEmail($email)
            ->allType()
            ->withUserId(1)
            ->onlyOne()
            ->getList()
            ->checkEmpty();
    }
}
