<?php

class Project_Deliver_Request
{
    private static $_instance = null;
    private $action           = false;
    private $data             = false;
    private $response         = false;

    /**
     * Возвращает экземпляр объекта текущего класса (singleton)
     * при первом обращении создаёт
     *
     * @return Project_Deliver_Request object
     */
    public static function getInstance()
    {
        if (self::$_instance == null) {
            self::$_instance = new self();
        }

        return self::$_instance;
    }

    public function setAction($action, $data = [])
    {
        if (in_array($action, get_class_methods($this))) {
            $this->action = $action;
            $this->data   = $data;
        } else {
            throw new Exception("Action value not specified: {$action}", 1);
        }

        return $this;
    }

    public function runAction()
    {
        $action = $this->action;
        return $this->$action($this->data);
    }

    /**
     * Установка значений переменных по умолчанию
     *
     * @return void
     */
    public function init()
    {
        $this->action   = false;
        $this->data     = false;
        $this->response = false;
    }

    private function account($data)
    {
        $connection = new Project_Deliver_SignIn_Connection();
        $connection
            ->getUserData()
            ->withEmail($data->email)
            ->withMembershipId($data->primary_membership)
            ->getList($dataObj);

        $member = $dataObj[0];

        if (!empty($dataObj) && Project_Deliver_Subscription::checkStatusPayment($member['member_id'], array_column($dataObj, 'membership_id'))) {
            return [
                'error' => [
                    ['message' => 'User <b>' . $data->email . '</b> already exists. Please use the login form to access the content.'],
                ],
            ];
        }

        if (empty($data->primary_membership)) {
            return [
                'error' => [
                    ['message' => 'Empty param {primary membership}'],
                ],
            ];
        }

        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($data->primary_membership)
            ->onlyOne()
            ->getList($membershipData);

        if (empty($membershipData)) {
            return [
                'error' => [
                    ['message' => 'Non existing membership'],
                ],
            ];
        }

        $member = new Project_Deliver_Member();
        $member
            ->withEmail($data->email)
            ->withSiteId($membershipData['site_id'])
            ->withUserId($membershipData['user_id'])
            ->onlyOne()
            ->getList($customerData);

        if (!empty($customerData)) {
            return [
                'error' => [
                    ['message' => 'User <b>' . $customerData['email'] . '</b> already exists. Please login to continue'],
                ],
                'login' => true,
                'data'  => ['cid' => $customerData['id']],
            ];
        }

        $customerData = [
            'email'         => $data->email,
            'site_id'       => $membershipData['site_id'],
            'user_id'       => $membershipData['user_id'],
            'membership_id' => $data->primary_membership,
            'flg_lead'      => 1,
        ];

        if ($data->require_shipping) {
            $customerData['shipping'] = [
                'name'    => $data->name,
                'address' => [
                    'line1'       => $data->address_line_1,
                    'city'        => $data->city,
                    'postal_code' => $data->zip,
                ],
            ];
        }

        if (!empty($data->referral)) {
            $customerData['referral'] = $data->referral;
        }

        /** Create a new customer */
        $customerData = Project_Deliver_Member::createCustomer($customerData, $membershipData['stripe_account']);

        if ($customerData) {
            if ($data->require_shipping) {
                $address = new Project_Deliver_Member_Address();
                $address
                    ->setEntered(
                        [
                            'member_id' => $customerData['id'],
                            'name'      => $data->name,
                            'country'   => $data->country,
                            'address'   => $data->address_line_1,
                            'city'      => $data->city,
                            'zip'       => $data->zip,
                        ]
                    )
                    ->set();
            }

            // Automate
            Project_Deliver_Automate::add($membershipData['id'], $customerData['id']);

            return ['cid' => $customerData['id']];
        } else {
            return ['error' => [['message' => 'There was a problem creating a new user']]];
        }
    }

    private function load_config($data)
    {
        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($data->membershipid)
            ->onlyOne()
            ->getList($membershipData);

        $site = new Project_Deliver_Site();
        $site
            ->withIds($membershipData['site_id'])
            ->onlyOne()
            ->getList($siteData);

        $response = [
            'id'                    => $membershipData['id'],
            'require_shipping'      => ($membershipData['require_shipping'] === '0' ? false : true),
            'free'                  => ($membershipData['type'] === '0' ? true : false),
            'frequency'             => intval($membershipData['frequency']),
            'title'                 => $membershipData['name'],
            'currency'              => $siteData['currency'],
            'amount'                => floatval($membershipData['amount']),
            'logo'                  => $siteData['logo'],
            'total_amount'          => floatval($membershipData['amount']),
            'billing_frequency'     => $membershipData['billing_frequency'],
            'home_page_url'         => $membershipData['home_page_url'],
            'label_charges'         => $membershipData['label_charges'],
            'add_charges_frequency' => $membershipData['add_charges_frequency'],
            'limit_rebills'         => intval($membershipData['limit_rebills']),
        ];

        if (!empty($data->bump)) {
            $membership
                ->withIds($data->bump)
                ->onlyOwner()
                ->withCurrency()
                ->getList($bumpData);

            $response['bump'] = $bumpData;
        }

        $site_url = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'];

        if ($response['require_shipping']) {
            $insCountry = new Project_Deliver_Country();

            if (!in_array('ALL', $membershipData['allowed_contries'])) {
                $insCountry
                    ->withIsoCodes($membershipData['allowed_contries']);
            }

            $insCountry
                ->getList($response['allowed_contries']);
        }

        /** Trial */
        if ((!empty($membershipData['trial_amount']) || $membershipData['trial_amount'] === '0') && !empty($membershipData['trial_duration'])) {
            $response['trial']          = true;
            $response['trial_amount']   = floatval($membershipData['trial_amount']);
            $response['trial_duration'] = floatval($membershipData['trial_duration']);
            // $response['total_amount']   = floatval($membershipData['trial_amount']);
        } else {
            $response['trial'] = false;
        }

        /** Additional Charges */
        if (!empty($membershipData['add_charges'])) {
            $response['add_charges'] = floatval($membershipData['add_charges']);
            $response['total_amount'] += floatval($membershipData['add_charges']);
        }

        /** Taxes */
        if (!empty($membershipData['add_taxes'])) {
            $response['add_taxes'] = floatval($membershipData['add_taxes']);
            $response['total_amount'] += ($response['total_amount'] * floatval($membershipData['add_taxes']) / 100);
        }

        if (!empty($response['logo'])) {
            $response['logo'] = $site_url . $response['logo'];
        }

        $response['request_url'] = $site_url . '/services/deliver-request.php';

        $response['stripe'] = [
            'publicKey'     => Project_Deliver_Stripe::getPublicKey(),
            'stripeAccount' => $membershipData['stripe_account'],
        ];

        // Forgot password link
        $response['forgot_url'] = $site_url . Core_Module_Router::getInstance()->generateFrontendUrl(['name' => 'site1_deliver', 'action' => 'forgot_password', 'w' => ['token' => base64_encode(serialize(['membership' => $data->membershipid]))]]);

        return $response;
    }

    private function customer_list($data)
    {
        $response = [];

        if (!empty($data->uid)) {
            $instance = new Project_Deliver_Member();
            $instance
                ->withUserId($data->uid)
                ->getList($memberData);

            if (!empty($memberData)) {
                $response = array_map(function ($member) {
                    return ['id' => $member['id'], 'email' => base64_encode($member['email'])];
                }, $memberData);
            }
        }

        return $response;
    }

    private function login($data)
    {
        if (!empty($data->email) && !empty($data->primary_membership)) {
            $signin   = new Project_Deliver_SignIn();
            $response = $signin->auth_account($data->cid, $data->password);

            if (!$response['status']) {
                echo json_encode(['errors' => $response['errors']]);
                exit();
            }

            $connection = new Project_Deliver_SignIn_Connection();
            $connection
                ->getUserData()
                ->withEmail($data->email)
                ->withMembershipId($data->primary_membership)
                ->getList($dataObj);

            $member = $dataObj[0];

            if (!empty($dataObj) && Project_Deliver_Subscription::checkStatusPayment($member['member_id'], array_column($dataObj, 'membership_id'))) {
                return ['errors' => [
                    ['message' => 'User <b>' . $data->email . '</b> already exists. Please use the login form to access the content.'],
                ]];
            }

            if (!empty($data->referral)) {
                $membership = new Project_Deliver_Membership();
                $membership
                    ->withIds($data->primary_membership)
                    ->onlyOne()
                    ->getList($membershipData);

                $member = new Project_Deliver_Member();
                $member
                    ->withIds($data->cid)
                    ->onlyOne()
                    ->getList($memberData);

                Project_Deliver_Stripe::updateCustomer($memberData['customer_id'], ['metadata' => ['referral' => $data->referral]], $membershipData['stripe_account']);
            }

            // Automate
            Project_Deliver_Automate::add($data->primary_membership, $data->cid);
        }

        return $response;
    }

    private function getdiscountlist($data)
    {
        return [
            'list' => Project_Deliver_DisCount::getActiveDisCount($data->membershipid, $data->cid),
        ];
    }

    private function get_customer_data($data)
    {
        $member = new Project_Deliver_Member();
        $member
            ->withIds($data->cid)
            ->onlyOne()
            ->getList($memberData);

        $customerData = Project_Deliver_Stripe::getCustomer($memberData['customer_id'], $data->stripe_account);

        if (!empty($customerData->invoice_settings->default_payment_method)) {
            $customerData->cardData = Project_Deliver_Stripe::getPaymentMethod($customerData->invoice_settings->default_payment_method, $data->stripe_account);
        }

        return $customerData;
    }

    private function payment($data)
    {
        $response = Project_Deliver_Subscription::createPaymentIntent($data->membership, $data->cid, $data->paymentMethod, $data->trial, $data->discount, $data->order_bump, $data->stripe_account);

        if ($response === false) {
            return ['errors' => [
                'message' => 'Произошла проблема с формирование Payment Intent',
            ]];
        }

        return $response;
    }

    private function add_payment_method($data)
    {
        if (!empty($data->cid) && !empty($data->paymentMethod)) {
            return Project_Deliver_Member::addPaymentMethod($data->cid, $data->paymentMethod, $data->stripe_account);
        }

        return [
            'errors' => ['message' => 'Empty {customer_id} or {payment_method}'],
        ];
    }

    private function update_payment_method($data)
    {
        if (!empty($data->paymentMethod) && !empty($data->payment_intent)) {
            $membership = new Project_Deliver_Membership();
            $membership
                ->withIds($data->membership)
                ->onlyOne()
                ->getList($membershipData);

            return
            Project_Deliver_Stripe::setPaymentIntent(
                [
                    'id'             => $data->payment_intent,
                    'payment_method' => $data->paymentMethod,
                ],
                $data->stripe_account
            );
        }

        return ['errors' => ['message' => 'Empty field {Payment Method} or {Payment Intent}']];
    }

    private function complete($data)
    {
        if (!empty($data->member) && !empty($data->membership)) {
            /** Membership Data */
            $membership = new Project_Deliver_Membership();
            $membership
                ->withIds($data->membership)
                ->onlyOne()
                ->getList($membershipData);

            if (empty($membershipData)) {
                return ['errors' => [
                    [
                        ['message' => 'Not exist a membership'],
                    ],
                ]];
            }

            /** Member Data */
            $member = new Project_Deliver_Member();
            $member
                ->withIds($data->member)
                ->onlyOne()
                ->getList($memberData);

            if (empty($memberData)) {
                return ['errors' => [
                    [
                        ['message' => 'Not exist a user'],
                    ],
                ]];
            }

            /** Site Data */
            $site = new Project_Deliver_Site();
            $site
                ->withIds($membershipData['site_id'])
                ->onlyOne()
                ->getList($siteData);

            $flgSendNotification = true;

            // Free subscriptions
            if ($membershipData['type'] == '0') {
                /** Update data of member */
                $member
                    ->setEntered(
                        [
                            'id'       => $data->member,
                            'flg_lead' => '0',
                            'site_id'  => $memberData['site_id'],
                            'user_id'  => $memberData['user_id'],
                        ]
                    )
                    ->set();

                /** Getting data of access for user */
                $signin = new Project_Deliver_SignIn();
                $signin
                    ->withCustomerId($data->member)
                    ->getList($accessData);

                /** Check existed of access */
                if (empty($accessData)) {
                    $signin
                        ->setEntered(
                            [
                                'customer_id' => $data->member,
                                'membership'  => $data->membership,
                            ]
                        )
                        ->set();

                    // Not send notification
                    $flgSendNotification = false;
                }

                $instance = new Project_Subscribers($memberData['user_id']);

                /** Update contact to general database of contacts */
                $instance
                    ->setEntered(
                        [
                            'email'       => $memberData['email'],
                            'tags'        => '[Purchased]: ' . $membershipData['name'],
                            'remove_tags' => ['[Lead]: ' . $membershipData['name']],
                        ]
                    )
                    ->set();

                $token      = Project_Deliver_Member_Token::generateToken($data->member);
                $connection = new Project_Deliver_SignIn_Connection();

                if (!empty($membershipData['webhook_url'])) {

                    $address = new Project_Deliver_Member_Address();

                    $address
                        ->withCustomerId($memberData['id'])
                        ->withCountryName()
                        ->onlyOne()
                        ->getList($addressData);

                    $shipping_address = null;

                    if (!empty($addressData)) {
                        $shipping_address = sprintf('%s, %s, %s, %s', $addressData['zip'], $addressData['country_name'], $addressData['city'], $addressData['address']);
                    }

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

                return [
                    'status' => $connection
                        ->setEntered(
                            [
                                'customer_id'         => $data->member,
                                'membership_id'       => $data->membership,
                                'flgSendNotification' => $flgSendNotification,
                            ]
                        )
                        ->set(),
                    'token'  => $token,
                ];
            }

            // Проверка
            $payment        = new Project_Deliver_Subscription();
            $connectionData = [];

            if (!empty($data->payment->id)) {
                $payment
                    ->withPaymentIntentId($data->payment->id)
                    ->getList($paymentData);

                $paymentIntent = Project_Deliver_Stripe::getPaymentIntent($data->payment->id, $data->stripe_account);

                if (isset($paymentIntent['error'])) {
                    return $paymentIntent;
                }

                Project_Deliver_Subscription::updateStatusPayment(
                    [
                        'payment_intent_id' => $paymentIntent->id,
                        'status'            => $paymentIntent->status,
                        'amount'            => $paymentIntent->amount,
                    ]
                );

                if ($paymentIntent->status === 'succeeded') {
                    $connectionData[] = [
                        'customer_id'         => $data->member,
                        'membership_id'       => $data->membership,
                        'flgSendNotification' => $flgSendNotification,
                    ];

                    if (!empty($data->order_bump)) {
                        foreach ($data->order_bump as $bump) {
                            $connectionData[] = [
                                'customer_id'         => $data->member,
                                'membership_id'       => $bump,
                                'flgSendNotification' => $flgSendNotification,
                            ];
                        }
                    }
                }
            }

            if ($membershipData['trial_amount'] != '0' && empty($paymentData)) {
                return [
                    'errors' => [
                        [
                            [
                                'message' => 'Not exist a payment',
                            ],
                        ],
                    ],
                ];
            }

            if ($data->trial) {
                $discount = new Project_Deliver_DisCount();

                if (!empty($data->discount) && $membershipData['trial_amount'] != '0') {
                    $discount
                        ->withIds($data->discount)
                        ->onlyOwner()
                        ->onlyOne()
                        ->getList($discountData);

                    // Обнуление скидки, если она для одной оплаты
                    if ($discountData['recurring'] == '0') {
                        $data->discount = false;
                    }
                }

                if ($membershipData['trial_amount'] == '0') {
                    $connectionData[] = [
                        'customer_id'         => $data->member,
                        'membership_id'       => $data->membership,
                        'flgSendNotification' => $flgSendNotification,
                    ];
                }

                $result = Project_Deliver_Subscription::createTrialSubscribe(
                    $data->membership,
                    $memberData['customer_id'],
                    ($membershipData['trial_amount'] == '0' ? null : $data->payment->id),
                    $data->discount,
                    $data->stripe_account
                );

                if ($result === false) {
                    return [
                        'errors' => [
                            [
                                'message' => '',
                            ],
                        ],
                    ];
                }
            }

            /** Updating data of member */
            $member
                ->setEntered(
                    [
                        'id'       => $data->member,
                        'flg_lead' => '0',
                        'site_id'  => $memberData['site_id'],
                        'user_id'  => $memberData['user_id'],
                    ]
                )
                ->set();

            /** Create new access for member */
            $signin = new Project_Deliver_SignIn();

            $signin
                ->withCustomerId($data->member)
                ->getList($accessData);

            if (empty($accessData)) {
                $signin
                    ->setEntered(
                        [
                            'customer_id' => $data->member,
                            'membership'  => $data->membership,
                        ]
                    )
                    ->set();

                // Not send notification
                $connectionData = array_map(function ($data) {
                    $data['flgSendNotification'] = false;
                    return $data;
                }, $connectionData);
            }

            $instance = new Project_Subscribers($memberData['user_id']);

            /** Update contact to general database of contacts */
            $instance
                ->setEntered(
                    [
                        'email'       => $memberData['email'],
                        'tags'        => '[Purchased]: ' . $siteData['name'] . ' - ' . $membershipData['name'],
                        'remove_tags' => ['[Lead]: ' . $siteData['name'] . ' - ' . $membershipData['name']],
                    ]
                )
                ->set();

            $connection = new Project_Deliver_SignIn_Connection();
            $connection
                ->setEntered($connectionData)
                ->setMass();

            $token = Project_Deliver_Member_Token::generateToken($data->member);

            if (!empty($membershipData['webhook_url'])) {
                $address = new Project_Deliver_Member_Address();

                $address
                    ->withCustomerId($memberData['id'])
                    ->withCountryName()
                    ->onlyOne()
                    ->getList($addressData);

                $shipping_address = null;

                if (!empty($addressData)) {
                    $shipping_address = sprintf('%s, %s, %s, %s', $addressData['zip'], $addressData['country_name'], $addressData['city'], $addressData['address']);
                }

                /** Send data to webhook */
                Project_Deliver_Webhook::send(
                    $membershipData['id'],
                    [
                        'email'             => $memberData['email'],
                        'shipping_address'  => $shipping_address,
                        'product_purchased' => $siteData['name'],
                        'membership'        => $membershipData['name'],
                        'price'             => sprintf('%s%s', (Project_Deliver_Currency::getCode(strtoupper($payment->currency))), intval($paymentIntent->amount) / 100),
                    ]
                );
            }

            /** Run trigger COMPLETED_CHECKOUT */
            Project_Deliver_Automate::triggerAutomate($membershipData['id'], $memberData['id']);

            return ['status' => true, 'token' => $token];
            // END

            exit();
            // Trial with free amount
            if ($data->trial && $membershipData['trial_amount'] == '0') {
                $result = Project_Deliver_Subscription::createTrialSubscribe(
                    $data->membership,
                    $memberData['customer_id'],
                    null,
                    $data->discount,
                    $data->stripe_account
                );

                /** Updating data of member */
                $member
                    ->setEntered(
                        [
                            'id'       => $data->member,
                            'flg_lead' => '0',
                            'site_id'  => $memberData['site_id'],
                            'user_id'  => $memberData['user_id'],
                        ]
                    )
                    ->set();

                /** Create new access for member */
                $signin = new Project_Deliver_SignIn();

                $signin
                    ->withCustomerId($data->member)
                    ->getList($accessData);

                if (empty($accessData)) {
                    $signin
                        ->setEntered(
                            [
                                'customer_id' => $data->member,
                                'membership'  => $data->membership,
                            ]
                        )
                        ->set();

                    // Not send notification
                    $flgSendNotification = false;
                }

                $instance = new Project_Subscribers($memberData['user_id']);

                /** Update contact to general database of contacts */
                $instance
                    ->setEntered(
                        [
                            'email'       => $memberData['email'],
                            'tags'        => '[Purchased]: ' . $siteData['name'] . ' - ' . $membershipData['name'],
                            'remove_tags' => ['[Lead]: ' . $siteData['name'] . ' - ' . $membershipData['name']],
                        ]
                    )
                    ->set();

                $connection = new Project_Deliver_SignIn_Connection();
                $connection
                    ->setEntered(
                        [
                            'customer_id'         => $data->member,
                            'membership_id'       => $data->membership,
                            'flgSendNotification' => $flgSendNotification,
                        ]
                    )
                    ->set();

                $token = Project_Deliver_Member_Token::generateToken($data->member);

                $address = new Project_Deliver_Member_Address();

                $address
                    ->withCustomerId($memberData['id'])
                    ->withCountryName()
                    ->onlyOne()
                    ->getList($addressData);

                $shipping_address = null;

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

                /** Run trigger COMPLETED_CHECKOUT */
                Project_Deliver_Automate::triggerAutomate($membershipData['id'], $memberData['id']);

                return ['status' => true, 'token' => $token];
            }

            if (empty($data->payment)) {
                return ['errors' => [
                    [
                        ['message' => 'Not exist a payment'],
                    ],
                ]];
            }

            if (empty($paymentData) || !in_array($data->membership, array_column($paymentData, 'plan_id')) || $paymentData[0]['customer_id'] !== $data->member) {
                return [
                    'errors' => [
                        [
                            [
                                'message' => 'Not exist a payment',
                            ],
                        ],
                    ],
                ];
            }

            $paymentIntent = Project_Deliver_Stripe::getPaymentIntent($paymentData[0]['payment_intent'], $data->stripe_account);

            if (!isset($paymentIntent['error'])) {
                /** Update status for payment */
                Project_Deliver_Subscription::updateStatusPayment(
                    [
                        'payment_intent_id' => $paymentIntent->id,
                        'status'            => $paymentIntent->status,
                        'amount'            => $paymentIntent->amount,
                    ]
                );

                if ($paymentIntent->status === 'succeeded') {
                    if ($data->trial) {
                        $discountInstnc = new Project_Deliver_DisCount();

                        if (!empty($data->discount)) {
                            $discountInstnc
                                ->withIds($data->discount)
                                ->onlyOwner()
                                ->onlyOne()
                                ->getList($discountData);

                            // Обнуление скидки, если она для одной оплаты
                            if ($discountData['recurring'] == '0') {
                                $data->discount = false;
                            }
                        }

                        $result = Project_Deliver_Subscription::createTrialSubscribe($data->membership, $memberData['customer_id'], $paymentIntent->id, $data->discount, $data->stripe_account);

                        if ($result === false) {
                            return [
                                'errors' => [
                                    [
                                        'message' => '',
                                    ],
                                ],
                            ];
                        }
                    }

                    /** Updating data of member */
                    $member
                        ->setEntered(
                            [
                                'id'       => $data->member,
                                'flg_lead' => '0',
                                'site_id'  => $memberData['site_id'],
                                'user_id'  => $memberData['user_id'],
                            ]
                        )
                        ->set();

                    /** Create new access for member */
                    $signin = new Project_Deliver_SignIn();

                    $signin
                        ->withCustomerId($data->member)
                        ->getList($accessData);

                    if (empty($accessData)) {
                        $signin
                            ->setEntered(
                                [
                                    'customer_id' => $data->member,
                                    'membership'  => $data->membership,
                                ]
                            )
                            ->set();

                        // Not send notification
                        $flgSendNotification = false;
                    }

                    $instance = new Project_Subscribers($memberData['user_id']);

                    /** Update contact to general database of contacts */
                    $instance
                        ->setEntered(
                            [
                                'email'       => $memberData['email'],
                                'tags'        => '[Purchased]: ' . $siteData['name'] . ' - ' . $membershipData['name'],
                                'remove_tags' => ['[Lead]: ' . $siteData['name'] . ' - ' . $membershipData['name']],
                            ]
                        )
                        ->set();

                    $connection = new Project_Deliver_SignIn_Connection();

                    if (empty($data->order_bump)) {
                        $connection
                            ->setEntered(
                                [
                                    'customer_id'         => $data->member,
                                    'membership_id'       => $data->membership,
                                    'flgSendNotification' => $flgSendNotification,
                                ]
                            )
                            ->set();
                    } else {
                        $connectionData = [];

                        $connectionData[] = [
                            'customer_id'         => $data->member,
                            'membership_id'       => $data->membership,
                            'flgSendNotification' => $flgSendNotification,
                        ];

                        foreach ($data->order_bump as $bump) {
                            $connectionData[] = [
                                'customer_id'         => $data->member,
                                'membership_id'       => $bump,
                                'flgSendNotification' => $flgSendNotification,
                            ];
                        }

                        $connection
                            ->setEntered($connectionData)
                            ->setMass();
                    }

                    $token = Project_Deliver_Member_Token::generateToken($data->member);

                    $address = new Project_Deliver_Member_Address();

                    $address
                        ->withCustomerId($memberData['id'])
                        ->withCountryName()
                        ->onlyOne()
                        ->getList($addressData);

                    $shipping_address = null;

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
                                'price'             => sprintf('%s%s', (Project_Deliver_Currency::getCode(strtoupper($payment->currency))), intval($paymentIntent->amount) / 100),
                            ]
                        );
                    }

                    /** Run trigger COMPLETED_CHECKOUT */
                    Project_Deliver_Automate::triggerAutomate($membershipData['id'], $memberData['id']);

                    return ['status' => true, 'token' => $token];
                }
            } else {
                return $paymentIntent;
            }
        }
    }

    private function token($data)
    {
        $cid = Project_Deliver_Member_Token::checkToken($data->token);

        if ($cid === false) {
            return ['cid' => false];
        }

        $memberInstance = new Project_Deliver_Member();
        $memberInstance
            ->withIds($cid)
            ->onlyOne()
            ->getList($memberData);

        $connection = new Project_Deliver_SignIn_Connection();
        $connection
            ->getUserData()
            ->withEmail($memberData['email'])
            ->withMembershipId($data->primary_membership)
            ->getList($dataObj);

        $member = $dataObj[0];

        if (!empty($dataObj) && Project_Deliver_Subscription::checkStatusPayment($member['member_id'], array_column($dataObj, 'membership_id'))) {
            return ['errors' => [
                'message' => 'User <b>' . $memberData['email'] . '</b> already exists. Please use the login form to access the content.',
            ]];
        }

        if (!empty($data->referral)) {
            $membership = new Project_Deliver_Membership();
            $membership
                ->withIds($data->primary_membership)
                ->onlyOne()
                ->getList($membershipData);

            $member = new Project_Deliver_Member();
            $member
                ->withIds($data->cid)
                ->onlyOne()
                ->getList($memberData);

            Project_Deliver_Stripe::updateCustomer($memberData['customer_id'], ['metadata' => ['referral' => $data->referral]], $membershipData['stripe_account']);
        }

        // Automate
        Project_Deliver_Automate::add($data->primary_membership, $memberData['id']);

        return ['cid' => $cid];
    }
}
