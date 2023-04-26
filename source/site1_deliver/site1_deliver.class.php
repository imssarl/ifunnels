<?php

class site1_deliver extends Core_Module
{

    public function set_cfg()
    {
        $this->inst_script = array(
            'module'  => array('title' => 'iFunnels Deliver'),
            'actions' => array(
                ['action' => 'dashboard', 'title' => 'Dashboard', 'flg_tree' => 1],
                ['action' => 'settings', 'title' => 'Settings', 'flg_tree' => 1],
                ['action' => 'discounts', 'title' => 'DisCounts', 'flg_tree' => 1],
                ['action' => 'discounts_set', 'title' => 'DisCounts Set', 'flg_tree' => 1],
                ['action' => 'memberships', 'title' => 'Memberships', 'flg_tree' => 1],
                ['action' => 'memberships_site', 'title' => 'Memberships Create Site', 'flg_tree' => 1],
                ['action' => 'memberships_plans', 'title' => 'Memberships Plans', 'flg_tree' => 1],
                ['action' => 'memberships_create_plan', 'title' => 'Memberships Create Plan', 'flg_tree' => 1],
                ['action' => 'sales', 'title' => 'Sales', 'flg_tree' => 1],
                ['action' => 'billing', 'title' => 'Billing', 'flg_tree' => 1],
                ['action' => 'subscriptions', 'title' => 'Subscriptions', 'flg_tree' => 1],
                ['action' => 'sale_detail', 'title' => 'Sale Detail', 'flg_tree' => 1],
                ['action' => 'failed_transactions', 'title' => 'Failed Transactions', 'flg_tree' => 1],
                ['action' => 'members', 'title' => 'Members', 'flg_tree' => 1],
                ['action' => 'leads', 'title' => 'Leads', 'flg_tree' => 1],
                ['action' => 'webhook', 'title' => 'Webhook', 'flg_tree' => 1],
                ['action' => 'automate', 'title' => 'Automate', 'flg_tree' => 1],
                ['action' => 'checkout', 'title' => 'Checkout', 'flg_tree' => 1, 'flg_tpl' => 1],
                ['action' => 'request', 'title' => 'Ajax Requests', 'flg_tpl' => 3, 'flg_tree' => 1],
                ['action' => 'forgot_password', 'title' => 'Forgot Password', 'flg_tpl' => 1, 'flg_tree' => 1],
                ['action' => 'reset_password', 'title' => 'Reset Password', 'flg_tpl' => 1, 'flg_tree' => 1],
            ),
        );
    }

    /** Action Dashboard */
    public function dashboard()
    {}

    /** Action Settings */
    public function settings()
    {
        $deliver = new Project_Deliver();

        $deliver
            ->onlyOne()
            ->withUserId(Core_Users::$info['id'])
            ->withAccountInfo()
            ->getList($this->out['stripe']);

        /** Disconnect user account */
        if (!empty($_POST['disconnect'])) {
            if ($deliver->withIds($this->out['stripe']['id'])->del()) {
                $this->location();
            }
        }

        if (isset($_POST['rewardful_api_key'])) {
            if ($deliver->setEntered(array_merge($this->out['stripe'], ['rewardful_api_key' => $_POST['rewardful_api_key']]))->set()) {
                $this->location();
            }
        }

        /** Check user was not connected */
        if (empty($this->out['stripe'])) {
            $connectLink = 'https://connect.stripe.com/oauth/authorize?response_type=code&client_id=%s&scope=read_write&redirect_uri=%s';

            $this->out['connect_link'] = sprintf(
                $connectLink,
                Project_Deliver_Stripe::getClientId(),
                Project_Deliver::getRedirectUrl()
            );

            if (!empty($_GET['code'])) {
                /** Get user data from stripe.com */
                $response = Project_Deliver::getAuthData($_GET['code']);

                if ($deliver->setEntered(array('settings' => $response))->set()) {
                    $this->location();
                }
            }
        }
    }

    /** Action Memberships */
    public function memberships()
    {
        $site = new Project_Deliver_Site();

        $site
            ->onlyOwner()
            ->withPaging(array(
                'page'        => $_GET['page'],
                'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
            ))
            ->getList($this->out['sites'])
            ->getPaging($this->out['arrPg']);

        if (!empty($_GET['delete'])) {
            $site
                ->withIds($_GET['delete'])
                ->onlyOwner()
                ->del();

            $this->location();
        }
    }

    /** Action Memberships Create Site */
    public function memberships_site()
    {
        $site = new Project_Deliver_Site();

        if (!empty($_POST) && $site->setEntered($_POST['arrData'])->set()) {
            $this->location(array('action' => 'memberships'));
        }

        if (!empty($_GET['id'])) {
            $site
                ->onlyOwner()
                ->onlyOne()
                ->withIds($_GET['id'])
                ->getList($this->out['arrData']);
        }
    }

    /** Action Membership Plans */
    public function memberships_plans()
    {
        if (Project_Deliver_Stripe::getStripeAccountId() === false) {
            $this->out['errors'][] = [
                'label'   => 'warning',
                'message' => sprintf(
                    'No connections to stripe.com. Please, add connection <a href="%s">here</a>',
                    Core_Module_Router::getCurrentUrl(['name' => 'site1_deliver', 'action' => 'settings'])
                ),
            ];
            $this->out['flg_add'] = false;
        } else {
            $this->out['flg_add'] = true;
        }

        $site = new Project_Deliver_Site();

        $site
            ->onlyOne()
            ->onlyOwner()
            ->withIds($_GET['site_id'])
            ->getList($this->out['siteData']);

        $membership = new Project_Deliver_Membership();

        $membership
            ->withSiteId($this->out['siteData']['id'])
            ->withPaging(array(
                'page'        => $_GET['page'],
                'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
            ))
            ->getList($this->out['arrMemberships'])
            ->getPaging($this->out['arrPg']);

        if (!empty($_GET['delete'])) {
            $membership
                ->withIds($_GET['delete'])
                ->del();

            $this->location();
        }
    }

    /** Action Membership Create Plan */
    public function memberships_create_plan()
    {
        $stripe_account = Project_Deliver_Stripe::getStripeAccountId();

        if ($stripe_account === false) {
            $this->location(['action' => 'memberships_plans', 'w' => ['site_id' => $_GET['site_id']]]);
        }

        $this->out['stripe_account'] = $stripe_account;

        $site = new Project_Deliver_Site();

        $site
            ->onlyOne()
            ->onlyOwner()
            ->withIds($_GET['site_id'])
            ->getList($this->out['siteData']);

        $membership = new Project_Deliver_Membership();

        $instanceCountry = new Project_Deliver_Country();

        $instanceCountry
            ->withOrder('d.name--dn')
            ->getList($this->out['arrCountries']);

        $automate = new Project_Automation();
        $automate
            ->onlyOwner()
            ->onlyCount()
            ->getList($this->out['count_automate']);

        if (!empty($_GET['id'])) {
            $membership
                ->onlyOne()
                ->onlyOwner()
                ->withIds($_GET['id'])
                ->getList($this->out['arrPlan']);
        }

        if (!empty($_POST) && $membership->setEntered($_POST['arrData'])->set()) {
            $this->location(
                array(
                    'action' => 'memberships_plans',
                    'w'      => array('site_id' => $this->out['siteData']['id']),
                )
            );
        } else {
            $membership->getEntered($this->out['arrPlan']);
            $membership->getErrors($this->out['errorLists']);
        }
    }

    /** Action Sales */
    public function sales()
    {
        $payment = new Project_Deliver_Payment();
        $rebill  = new Project_Deliver_Rebills();

        if (!empty($_GET['email'])) {
            $payment->withEmail($_GET['email']);
        }

        if (!empty($_GET['arrFilter'])) {
            $payment->setFilter($_GET['arrFilter']);
        } else {
            $payment->setFilter(['show' => 'all']);
        }

        $payment
            ->onlyOwner()
            ->withCustomerName()
            ->withMembershipName()
            ->withPaging(
                [
                    'page'        => $_GET['page'],
                    'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                    'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
                ]
            )
            ->withOrder('d.added--up')
            ->getList($this->out['arrPayments'])
            ->getPaging($this->out['arrPg']);
    }

    /** Action Failed Transactions */
    public function failed_transactions()
    {

    }

    /** Action Sale Detail */
    public function sale_detail()
    {
        if (empty($_GET['id'])) {
            $this->location(['action' => 'sales']);
        }

        $membership   = new Project_Deliver_Membership();
        $payment      = new Project_Deliver_Payment();
        $subscription = new Project_Deliver_Subscription();

        if (empty($_GET['rebill'])) {
            $payment
                ->onlyOwner()
                ->onlyOne()
                ->withIds($_GET['id'])
                ->getList($arrPayment);

            $membership
                ->withIds($arrPayment['plan_id'])
                ->onlyOne()
                ->getList($membershipData);

            if (empty($arrPayment)) {
                $this->location(['action' => 'sales']);
            }

            if ($arrPayment['type_payment'] == 0) {
                $this->out               = $payment->getOneTimePaymentDetails($arrPayment, Project_Deliver_Stripe::getStripeAccountId());
                $this->out['payment_id'] = $arrPayment['id'];
                $this->out['status']     = $arrPayment['status'];

                if (!empty($_POST)) {
                    $this->out = $payment->refundPayment($_POST['arrData']['payment_id'], Project_Deliver_Stripe::getStripeAccountId());

                    if (!isset($this->out['error'])) {
                        $this->location(['wg' => ['id' => $_GET['id']]]);
                    }
                }
            }

            if ($arrPayment['type_payment'] == 1) {
                $this->out               = $payment->getSubscriptionPaymentDetails($arrPayment, Project_Deliver_Stripe::getStripeAccountId());
                $this->out['status']     = $arrPayment['status'];
                $this->out['payment_id'] = $arrPayment['id'];

                if (!empty($_POST)) {
                    $payment->refundPayment($_POST['arrData']['payment_id'], Project_Deliver_Stripe::getStripeAccountId());
                    $this->location();
                }
            }

            $member = new Project_Deliver_Member_Address();
            $member
                ->onlyOne()
                ->withCountryName()
                ->withCustomerId($arrPayment['customer_id'])
                ->getList($this->out['addressData']);
        }

        if (!empty($_GET['rebill'])) {
            $rebill = new Project_Deliver_Rebills();
            $rebill
                ->withIds($_GET['id'])
                ->onlyOne()
                ->getList($arrRebill);

            $membership
                ->withIds($arrRebill['membership_id'])
                ->onlyOne()
                ->getList($membershipData);

            $member = new Project_Deliver_Member();
            $member
                ->onlyOne()
                ->withCustomerId($arrRebill['customer_id'])
                ->getList($memberData);

            $data          = json_decode($arrRebill['data']);
            $invoice       = Project_Deliver_Stripe::retriveInvoice($data->latest_invoice, $membershipData['stripe_account']);
            $paymentIntent = $subscription->getOneTimePaymentDetails($invoice->payment_intent, $memberData['id'], $membershipData['stripe_account']);

            $this->out           = $paymentIntent;
            $this->out['status'] = $arrRebill['status'];
        }

    }

    /** Action Members */
    public function members()
    {
        $member = new Project_Deliver_Member();

        if (!empty($_GET['email'])) {
            $member->withEmail($_GET['email']);
        }

        $member
            ->withUserId()
            ->withPaging(array(
                'page'        => $_GET['page'],
                'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
            ))
            ->setFilter($_GET['filter'])
            ->withConnectedMemberships()
            ->getList($this->out['arrMembers'])
            ->getFilter($this->out['arrFilter'])
            ->getPaging($this->out['arrPg']);

        /** Getting list of memberships */
        $membership = new Project_Deliver_Membership();
        $membership
            ->onlyOwner()
            ->withSiteName()
            ->getList($this->out['arrMemberships']);

        // Group membership by site_name
        $this->out['arrMembershipsGroup'] = [];
        foreach ($this->out['arrMemberships'] as $m) {
            $this->out['arrMembershipsGroup'][$m['site_name']][] = $m;
        }

        if (Core_Acs::haveAccess(['email test group'])) {
            if (!empty($_GET['delete'])) {
                $member
                    ->withIds($_GET['delete'])
                    ->del();

                $this->location();
            }
        }
    }

    /** Action checkout */
    public function checkout()
    {
        $membership = new Project_Deliver_Membership();

        $membership
            ->onlyOne()
            ->withIds($_GET['plan'])
            ->getList($this->out['arrPlan']);

        $site = new Project_Deliver_Site();

        $site
            ->withIds($this->out['arrPlan']['site_id'])
            ->onlyOne()
            ->getList($this->out['arrSite']);

        $this->out['stripe_account'] = Project_Deliver_Stripe::getStripeAccountId($this->out['arrSite']['user_id']);
        $this->out['ajaxUrl']        = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . '/services/stripe.php';

        if (!isset($_GET['cancel']) && !isset($_GET['success']) && $this->out['arrPlan']['frequency'] == '0') {
            $this->out['session'] = Project_Deliver_Membership::getCheckout($this->out['arrPlan']);
        }

        /** Update status payment */
        if (isset($_GET['session_id'])) {
            $payment = new Project_Deliver_Subscription();

            $session       = Project_Deliver_Stripe::getCheckoutSession($_GET['session_id'], $this->out['stripe_account']);
            $paymentIntent = Project_Deliver_Stripe::getPaymentIntent($session->payment_intent, $this->out['stripe_account']);

            $payment->updateStatus(
                [
                    'type_payment'   => '0',
                    'one_payment_id' => $session->id,
                    'status'         => ($paymentIntent->status !== 'succeeded' ? 'canceled' : 'succeeded'),
                ],
                $session,
                $this->out['stripe_account']
            );

            $this->out['status'] = $paymentIntent->status;
        }
    }

    /** Action Ajax Request */
    public function request()
    {
        $request = file_get_contents('php://input');

        if (!empty($request)) {
            $request = json_decode($request);

            switch ($request->action) {
                case 'delete_logo':
                    $site = new Project_Deliver_Site();

                    $site
                        ->withIds($request->siteid)
                        ->onlyOne()
                        ->onlyOwner()
                        ->getList($siteData);

                    if (!empty($siteData['logo'])) {
                        unlink(Zend_Registry::get('config')->path->absolute->root . $siteData['logo']);
                    }

                    $site
                        ->setEntered(['id' => $request->siteid, 'logo' => null])
                        ->set();

                    $this->out_js['status'] = 'success';
                    break;

                case 'unsubscribe':
                    $membership = new Project_Deliver_Membership();

                    $membership
                        ->withIds($request->membership_id)
                        ->onlyOne()
                        ->getList($membershipData);

                    $payment                = new Project_Deliver_Subscription();
                    $this->out_js['status'] = $payment->unsubscribe($request->subscribe_id, $request->payment_id, $membershipData['stripe_account']);
                    break;

                case 'dashboard':
                    $params = json_decode($request->data->params, true);

                    if (empty($params)) {
                        $params['arrFilter'] = ['time' => 4];
                    }

                    // Membership
                    $membership = new Project_Deliver_Membership();
                    $membership
                        ->onlyOwner()
                        ->withFilter($params['arrFilter'])
                        ->getList($arrMemberships);

                    // Payment
                    $payment = new Project_Deliver_Subscription();
                    $payment
                        ->onlyOwner()
                        ->withFilter($params['arrFilter'])
                        ->withOrder('id--dn')
                        ->getList($arrPayments);

                    $payment
                        ->onlyOwner()
                        ->withFilter($params['arrFilter'])
                        ->withOrder('id--dn')
                        ->withMembershipName()
                        ->withCustomerName()
                        ->withStatus(Project_Deliver_Subscription::STATUS_REFUNDED)
                        ->withLimit(10)
                        ->getList($this->out_js['arrRefunds']);

                    // Rebills
                    $rebill = new Project_Deliver_Rebills();
                    $rebill
                        ->onlyOwner()
                        ->withFilter($params['arrFilter'])
                        ->withOrder('id--dn')
                        ->getList($arrRebills);

                    $rebill
                        ->onlyOwner()
                        ->withFilter($params['arrFilter'])
                        ->withLimit(10)
                        ->withMembershipName()
                        ->withCurrency()
                        ->withCustomerName()
                        ->withOrder('id--up')
                        ->getList($this->out_js['arrRebills']);

                    // Member
                    $member = new Project_Deliver_Member();
                    $member
                        ->onlyOwner()
                        ->withFilter($params['arrFilter'])
                        ->getList($arrMembers);

                    $member
                        ->onlyOwner()
                        ->onlyLeads()
                        ->withFilter($params['arrFilter'])
                        ->getList($arrLeads);

                    // Connection
                    $connection = new Project_Deliver_SignIn_Connection();

                    if (!empty(array_column($arrMembers, 'id'))) {
                        $connection
                            ->withMembersId(array_column($arrMembers, 'id'))
                            ->withMembershipName()
                            ->withMemberEmail()
                            ->withLimit(5)
                            ->withFilter($params['arrFilter'])
                            ->getList($this->out_js['arrConnections']);
                    } else {
                        $this->out_js['arrConnections'] = [];
                    }

                    $dataPayments = Project_Deliver_Subscription::getTree($arrPayments);
                    $dataRebills  = Project_Deliver_Rebills::getTree($arrRebills);

                    list($total_sales, $currency) = Project_Deliver_Subscription::getTotalAmount($arrPayments);
                    $this->out_js['diagramm']     = ['data' => array_values($dataPayments), 'labels' => array_keys($dataPayments)];
                    $this->out_js['d_rebills']    = ['data' => array_values($dataRebills), 'labels' => array_keys($dataRebills)];

                    $this->out_js['count'] = [
                        'membership'  => count($arrMemberships),
                        'payment'     => count($arrPayments),
                        'member'      => count($arrMembers),
                        'lead'        => count($arrLeads),
                        'total_sales' => $total_sales,
                        'currency'    => $currency,
                    ];
                    break;

                case 'resend':
                    $response     = Project_Deliver_Member::resendAccess($request->data->mid);
                    $this->out_js = ['status' => $response];
                    break;

                case 'set_password':
                    $response     = Project_Deliver_Member::setPassword($request->data->mid, $request->data->password);
                    $this->out_js = ['status' => $response];
                    break;

                case 'remove':
                    $response     = Project_Deliver_Membership::removeMember($request->data->mid, $request->data->membership_id);
                    $this->out_js = ['status' => $response];
                    break;

                case 'add_member':
                    $response     = Project_Deliver_Membership::addMember($request->data->mid, $request->data->membership_id);
                    $this->out_js = ['status' => $response];
                    break;

                case 'add_new_member':
                    $membership = new Project_Deliver_Membership();
                    $membership
                        ->withIds($request->data->membership)
                        ->onlyOne()
                        ->getList($membershipData);

                    $flg_exist = false;
                    $member    = [];

                    if (Project_Deliver_Member::hasExists($request->data->email)) {
                        $instanceOfMember = new Project_Deliver_Member();

                        $instanceOfMember
                            ->withEmail($request->data->email)
                            ->onlyOwner()
                            ->allType()
                            ->onlyOne()
                            ->getList($member);

                        $flg_exist = true;
                    } else {
                        // Create a new member in Stripe and Deliver
                        $member = Project_Deliver_Member::createCustomer([
                            'site_id'       => $membershipData['site_id'],
                            'user_id'       => Core_Users::$info['id'],
                            'flg_lead'      => '0',
                            'email'         => $request->data->email,
                            'membership_id' => $request->data->membership,
                        ], Project_Deliver_Stripe::getStripeAccountId());
                    }

                    if (empty($member)) {
                        $this->out_js = ['status' => 'error', 'message' => '<b>Critical Error!</b> Reload this page and try again.'];
                        return;
                    }

                    // Add member to membership
                    if (!Project_Deliver_Membership::addMember($member['id'], $request->data->membership, $flg_exist)) {
                        $this->out_js = ['status' => 'error', 'message' => 'The member has access to the selected membership'];
                        return;
                    }

                    if (!$flg_exist) {
                        // Create access for member and sending to email
                        $signIn = new Project_Deliver_SignIn();
                        if ($signIn
                            ->setEntered(
                                [
                                    'customer_id' => $member['id'],
                                    'membership'  => $request->data->membership,
                                ]
                            )
                            ->set()) {
                            $this->out_js = ['status' => 'success', 'message' => 'Member has been added successfully'];
                            return;
                        }
                    }

                    $this->out_js = ['status' => 'success', 'message' => 'Member has been added successfully'];
                    break;

                case 'discount_play':
                    if (Project_Deliver_DisCount::togglePause($request->data->id)) {
                        $this->out_js = ['status' => true, 'message' => 'Successfully updated'];
                    } else {
                        $this->out_js = ['status' => false, 'message' => Core_Data_Errors::getInstance()->getErrorFlowShift()];
                    }
                    break;

                case 'discount_reset':
                    if (Project_Deliver_DisCount::reset($request->data->id)) {
                        $this->out_js = ['status' => true, 'message' => 'Successfully updated'];
                    } else {
                        $this->out_js = ['status' => false, 'message' => Core_Data_Errors::getInstance()->getErrorFlowShift()];
                    }
                    break;
            }
        }
    }

    /** Action Leads */
    public function leads()
    {
        $member = new Project_Deliver_Member();

        if (!empty($_GET['email'])) {
            $member->withEmail($_GET['email']);
        }

        $member
            ->onlyLeads()
            ->onlyOwner()
            ->withMembershipName()
            ->withPaging(array(
                'page'        => $_GET['page'],
                'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
            ))
            ->setFilter($_GET['filter'])
            ->getList($this->out['arrMembers'])
            ->getFilter($this->out['arrFilter'])
            ->getPaging($this->out['arrPg']);

        /** Getting all list of members */
        $member
            ->onlyLeads()
            ->onlyOwner()
            ->withMembershipName()
            ->getList($listMembers);

        /** Collecting a membership of list the members */
        if (!empty($listMembers)) {
            $this->out['arrMemberships'] = array_map(function ($member) {
                return ['id' => $member['membership_id'], 'membership_name' => $member['membership_name'], 'site_name' => $member['site_name']];
            }, $listMembers);
        } else {
            $this->out['arrMemberships'] = [];
        }

        if (Core_Acs::haveAccess(['email test group'])) {
            if (!empty($_GET['delete'])) {
                $member
                    ->withIds($_GET['delete'])
                    ->del();

                $this->location();
            }
        }
    }

    // Forgot Password
    public function forgot_password()
    {
        $this->objStore->getAndClear($this->out);

        $token = unserialize(base64_decode($_GET['token']));

        if (empty($token) || empty($token['membership'])) {
            http_response_code(400);
            exit;
        }

        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($token['membership'])
            ->onlyOne()
            ->getList($membershipData);

        if (empty($membershipData)) {
            http_response_code(400);
            exit;
        }

        $signIn = new Project_Deliver_SignIn();

        if (!empty($_POST)) {
            $response = $signIn->resetPassword($membershipData['user_id'], $_POST['arrData']['email']);

            $this->objStore->set($response);
            $this->location(['w' => ['token' => $_GET['token']]]);
        }
    }

    // Reset Password
    public function reset_password()
    {
        $this->objStore->getAndClear($this->out);

        $token = $_GET['token'];

        if (empty($token)) {
            http_response_code(400);
            exit;
        }

        $signIn = new Project_Deliver_SignIn();
        $signIn
            ->withForgotToken($_GET['token'])
            ->onlyOne()
            ->getList($signData);

        if (empty($signData) && !isset($this->out['status'])) {
            http_response_code(400);
            exit;
        }

        if (!empty($_POST)) {
            if (strcmp($_POST['arrData']['password'], $_POST['arrData']['confirm_password']) === 0) {
                if ($signIn->setEntered(['id' => $signData['id'], 'password' => $_POST['arrData']['password'], 'forgot_code' => null])->set()) {
                    $this->objStore->set(['status' => true, 'message' => 'Password successfully updated']);
                    $this->location(['w' => ['token' => $_GET['token']]]);
                }
            } else {
                $this->objStore->set(['status' => false, 'message' => 'The entered passwords do not match']);
                $this->location(['w' => ['token' => $_GET['token']]]);
            }
        }
    }

    // Webhook
    public function webhook()
    {
        $this->objStore->getAndClear($this->out);

        $membership = new Project_Deliver_Membership();

        $membership
            ->withIds($_GET['mid'])
            ->onlyOne()
            ->getList($this->out['arrData']);

        if (empty($this->out['arrData'])) {
            $this->location(['action' => 'memberships']);
        }

        $logs = new Project_Deliver_Webhook();
        $logs
            ->withMembership($_GET['mid'])
            ->getList($this->out['arrLogs']);

        if (!empty($_POST)) {
            $membership
                ->setEntered(array_merge($this->out['arrData'], $_POST['arrData']))
                ->set();

            Project_Deliver_Webhook::send(
                $_GET['mid'],
                [
                    'email'             => 'test@ifunnels.com',
                    'shipping_address'  => null,
                    'product_purchased' => 'Test',
                    'membership'        => 'Test',
                    'price'             => '€0',
                ],
                true
            );

            $this->location(['w' => $_GET]);
        }
    }

    // Automate
    public function automate()
    {
        $membership = new Project_Deliver_Membership();

        $membership
            ->withIds($_GET['mid'])
            ->onlyOne()
            ->getList($this->out['arrData']);

        if (empty($this->out['arrData']['aic']) || empty($this->out['arrData']['acc'])) {
            $this->objStore->set(['status' => false, 'message' => 'Not added the Automate companies']);
            return;
        }

        $automate = new Project_Automation();
        $automate
            ->withIds([$this->out['arrData']['aic'], $this->out['arrData']['acc']])
            ->onlyOwner()
            ->getList($arrAutomates);

        list($aic, $acc) = $arrAutomates;

        $this->out['arrAIC'] = explode(',', $aic['actions'][Project_Automation_Action::$type['ADD_EF']]['value']);
        $this->out['arrACC'] = explode(',', $acc['actions'][Project_Automation_Action::$type['ADD_EF']]['value']);

        if (empty($this->out['arrData'])) {
            $this->location(['action' => 'memberships']);
        }

        $ef = new Project_Efunnel();
        $ef
            ->onlyOwner()
            ->getList($this->out['arrEF']);

        if (!empty($_POST)) {
            $automate->setEntered([
                [
                    'id'      => $aic['id'],
                    'actions' => [Project_Automation_Action::$type['ADD_EF'] => ['id' => '', 'value' => join(',', $_POST['arrData']['aic'])]],
                    'events'  => [Project_Automation_Event::$type['INITIATED_CHECKOUT'] => ['id' => '', 'value' => $_GET['mid']]],
                ],
                [
                    'id'      => $acc['id'],
                    'actions' => [
                        Project_Automation_Action::$type['ADD_EF']    => ['id' => '', 'value' => join(',', $_POST['arrData']['acc'])],
                        Project_Automation_Action::$type['REMOVE_EF'] => ['id' => '', 'value' => join(',', $_POST['arrData']['aic'])],
                    ],
                    'events'  => [Project_Automation_Event::$type['COMPLETED_CHECKOUT'] => ['id' => '', 'value' => $_GET['mid']]],
                ],
            ])
                ->setMass();

            $this->location(['w' => $_GET]);
        }
    }

    // Subscriptions
    public function subscriptions()
    {
        $membership = new Project_Deliver_Membership();
        $membership
            ->onlyOwner()
            ->withSiteName()
            ->onlyRecurring()
            ->getList($membershipLists);

        $this->out['arrMemberships'] = [];

        foreach ($membershipLists as $value) {
            $this->out['arrMemberships'][$value['site_name']][] = $value;
        }

        $payment = new Project_Deliver_Subscription();

        if (!empty($_GET['arrFilter'])) {
            $payment->withFilter($_GET['arrFilter']);
        }

        if (!empty($_GET['email'])) {
            $payment->withEmail($_GET['email']);
        }

        $payment
            ->onlyOwner()
            ->withoutOneTime()
            ->withPaging(
                [
                    'page'        => $_GET['page'],
                    'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                    'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
                ]
            )
            ->withCustomerName()
            ->withMembershipName()
            ->getList($this->out['arrPayments'])
            ->getPaging($this->out['arrPg']);
    }

    // Billing
    public function billing()
    {
        $member = new Project_Deliver_Member();

        $member
            ->withUserId(1)
            ->withEmail(Core_Users::$info['email'])
            ->onlyOne()
            ->getList($userData);

        if (empty($userData)) {
            $this->location(['action' => 'dashboard']);
        }

        $responce = Project_Deliver_Stripe::createSession($userData['customer_id']/*'cus_JG5I6kJ0nf8bbx'*/);

        if (!$responce) {
            $this->out['error'] = join("\n", Core_Data_Errors::getInstance()->getErrorsFlow());
        }

        header('Location: ' . $responce->url);
    }

    // Discounts
    public function discounts()
    {
        $disCount = new Project_Deliver_DisCount();
        $disCount
            ->onlyOwner()
            ->withProductName()
            ->withPaging(
                [
                    'page'        => $_GET['page'],
                    'reconpage'   => Core_Users::$info['arrSettings']['rows_per_page'],
                    'numofdigits' => Core_Users::$info['arrSettings']['page_links'],
                ]
            )
            ->getList($this->out['arrDiscounts'])
            ->getPaging($this->out['arrPg']);

        if (!empty($_GET['delete'])) {
            $disCount->withIds($_GET['delete'])->del();

            $this->location();
        }
    }

    // Discounts Set
    public function discounts_set()
    {
        $membership = new Project_Deliver_Membership();
        $disCount   = new Project_Deliver_DisCount();

        $membership
            ->onlyOwner()
            ->onlyPay()
            ->withSiteName()
            ->getList($membershipList);

        foreach ($membershipList as $value) {
            $this->out['arrMemberships'][$value['site_name']][] = $value;
        }

        if (!empty($_GET['id'])) {
            $disCount
                ->withIds($_GET['id'])
                ->onlyOwner()
                ->onlyOne()
                ->getList($this->out['arrData']);

            $this->out['arrData']['products_id'] = array_column($this->out['arrData']['products'], 'membership_id');

            if (empty($this->out['arrData'])) {
                $this->location(['action' => 'discounts']);
            }
        }

        if (!empty($_POST)) {
            if ($disCount->setEntered($_POST['arrData'])->set()) {
                $this->location(['action' => 'discounts']);
            }

            $disCount
                ->getEntered($this->out['arrData'])
                ->getErrors($this->out['arrErrors']);
        }
    }
}
